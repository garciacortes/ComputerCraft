function getItens()
    local inv = peripheral.find("inventory")
    
    local itens = {}
    local itensName = {}
    
    for slot, _ in pairs(inv.list()) do
        local item = inv.getItemDetail(slot)
        local name = item.displayName
        local count = item.count
        
         if itens[name] then
             itens[name] = itens[name] + 1
         else
             itens[name] = count
         end
    end
    
    for k, _ in pairs(itens) do
        table.insert(itensName, k)
    end
    
    return itensName, itens
end

function getID()
    local caminho = "emporio/config.lua"
    
    local file = fs.open(caminho, "r")
    
    if file then
        local content = textutils.unserialise(file.readAll())
        local ID = content.id
        local file = fs.open(caminho, "w")
        newID = ID + 1
        file.writeLine("{id = "..newID.."}")
        file.close()
        return ID
    else
        local file = fs.open(caminho, "w")
        file.writeLine("{id = 1}")
        file.close()
        return getID()
    end
end

function headerNF(nome)
    nomeCliente = nome or "Anonimo"

    local data = os.date("%Y-%m-%d")
    local id = string.format("%06d", getID())
    local nomeArquivo = "NF-"..id.."-"..data.."-"..nomeCliente

    local caminho = "emporio/notasFiscais/ ".. nomeArquivo
    local file = fs.open(caminho, "w")

    file.writeLine("------ NOTA FISCAL ------")
    file.writeLine("ID Nota Fiscal: " .. id)
    file.writeLine("Emissao: "..os.date("%d/%m/%Y"))
    file.writeLine("Hora: "..os.date("%H:%M"))
    file.writeLine("")
    file.writeLine("Emitente: NonoNete")
    file.writeLine("")
    file.writeLine("Destinatario: "..nomeCliente)
    file.writeLine("")
    file.writeLine("Itens:")
    
    return file, caminho
end

function gerarNotaFiscal(nome)
    local caminhoNFs = {}
    
    local itensName, itens = getItens()
    local totalItens = 0
    
    for inicio = 1, #itensName, 9 do
        local file, caminho = headerNF(nome)
        for j = inicio, math.min(inicio + 8, #itensName) do
            k = itensName[j]
            v = itens[k]
            file.writeLine(j..") "..v.."x "..k)
            totalItens = totalItens + v
        end
        
        file.writeLine("")
        file.writeLine("Total: "..totalItens.." itens")
    
        file.close()
        table.insert(caminhoNFs, caminho)
    end

    return caminhoNFs
end

function moveMenu(menu, select)
    local _, key = os.pullEvent("key")
    
    if (key == keys.up or key == keys.w) and select > 1 then
        select = select - 1
    elseif (key == keys.down or key == keys.s) and select < #menu then
        select = select + 1
    elseif key == keys.enter then
        local result = optionsMenu(menu, select)
        if result == "finish" then
            return result
        elseif result == "exit" then
            return result
        end
    end
    
    return select
end

function viewShop()
   local itens = getItens()
   local menuCompra = {"Recarregar Lista", "Finalizar Compra"}
   local select = 1
   
   while true do
       local i = 1
       term.clear()
       
       drawMenu(menuCompra, select)
       
       term.setTextColor(colors.white)
       print("\nItens entregues ate o Momento")
       
       for k, v in pairs(itens) do
           print(i..") "..v.."x "..k)
           i = i + 1
       end
       term.setTextColor(colors.yellow)
       print("\nTUTORIAL")
       print("- Se nao chegou tudo aguarde uns instante e escolha recarregar lista.")
       print("- Se tiver chegado tudo finalizar Compra.")
           
       local result = moveMenu(menuCompra, select)
       
       if result == "exit" or result == "finish" then
           return result
       elseif type(result) == "number" then
           select = result
       end
   end 
end

function drawMenu(menu, select)
   term.setCursorPos(1,1)
   
   term.setTextColor(colors.blue)
   print("---------- EMPORIO NONONETE ----------")
   term.setTextColor(colors.white)
   for i, v in ipairs(menu) do
       if i == select then
           term.setTextColor(colors.orange)
           print("> ".. v)
       else
           term.setTextColor(colors.white)
           print("" .. v)
       end
   end
end

function finishShop()
    local vault = peripheral.find("inventory")
    local relay = peripheral.find("redstone_relay")
    local menuFinish = {"Com Nota Fiscal", "Sem Nota Fiscal"} 
    local select = 1
    
    while true do
        term.clear()
        
        drawMenu(menuFinish, select)
        
        local result = moveMenu(menuFinish, select)
        
        if result == "exit" or result == "finish" then
            break
        elseif type(result) == "number" then
            select = result
        end
    end
    
    term.clear()
    
    term.setCursorPos(1,1)
    term.setTextColor(colors.blue)
    print("---------- EMPORIO NONONETE ----------")
    
    term.setTextColor(colors.white)
    print("\nAguarde a entrega de todos os itens!")
    
    relay.setOutput("left", true)
    
    while true do
        local itens = vault.list()
        local isEmpty = next(itens) == nil
    
        if isEmpty then
            sleep(4)
            print("\nCompra Finalizada!")
            print("Agradeco a Preferencia, volte sempre!")
            relay.setOutput("left", false)
            sleep(2)
            break
        end
    end
    
    return "finish"
end

function comNotaFiscal()
    local printer = peripheral.find("printer")
    
    term.clear()
    term.setCursorPos(1,1)
    
    io.write("Nome do Cliente: ")
    local nome = io.read()
    
    local nf = gerarNotaFiscal(nome)
    
    for _, v in ipairs(nf) do
    
        local file = fs.open(v, "r")
    
        print("Imprimindo Nota Fiscal Aguarde!")
    
        printer.newPage()
        for line in file.readLine do
            printer.write(line)
            local x, y = printer.getCursorPos()
            printer.setCursorPos(1, y + 1)
        end
        file.close()
    end
    sleep(2)
    printer.endPage()
    
    return "finish"
end

function semNotaFiscal()
    gerarNotaFiscal()
    
    return "finish"
end

function optionsMenu(menu, select)
    local opcs = {
        Sair = function() return "exit" end,
        Visualizar_Compra = viewShop,
        Recarregar_Lista = viewShop,
        Finalizar_Compra = finishShop,
        Com_Nota_Fiscal = comNotaFiscal,
        Sem_Nota_Fiscal = semNotaFiscal
    }
    
    opcLimpo = string.gsub(menu[select], " ", "_")
    local func = opcs[opcLimpo]
    
    if func then
        return func()
    end
end

function home()
    local menuPrincipal = {"Visualizar Compra", "Sair"}
    local select = 1
    while true do
        term.clear()
    
        drawMenu(menuPrincipal, select)
    
        term.setTextColor(colors.yellow)
        print("\nTUTORIAL MENU")
        print("1- Movimentar entre opcoes com setinha para cima/w ou baixo/s.")
        print("2- Para confirmar uma opcoes so apertar enter.")
        
        local result = moveMenu(menuPrincipal, select)
        
        if result == "exit" or result == "finish" then
            break
        elseif type(result) == "number" then
            select = result
        end
    end
    term.clear()
    term.setCursorPos(1,18)
    term.setTextColor(colors.yellow)
    print("Finalizando Compra Anterir.")
    sleep(1)
    local restartSistem = {".", "..", "..."}
    for _, v in pairs(restartSistem) do
        term.clear()
        print("Reiniciando Sistema"..v)
        sleep(0.5)
    end
    home()
end

home()
            
