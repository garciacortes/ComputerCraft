-- pocket_client.lua - Pocket Client W.E.T.S com IA de ajuda e auto menu
 
-- Detectar modem automaticamente
local sides = {"left", "right", "top", "bottom", "front", "back"}
local modemFound = false
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" then
        rednet.open(side)
        modemFound = true
        print("📡 Modem aberto na lateral: " .. side)
        break
    end
end
if not modemFound then
    print("❌ Nenhum modem encontrado! Abortando.")
    return
end
 
-- ID do Pocket
local pocketID = os.getComputerID()
 
-- Função de fala da IA (estilo balão)
local function iaFala(texto)
    print("")
    print("╭" .. string.rep("─", #texto + 4) .. "╮")
    print("│ 🤖 " .. texto .. " │")
    print("╰" .. string.rep("─", #texto + 4) .. "╯")
    print("")
end
 
-- Registrar o Pocket no Master
local function registrarNoMaster()
    local info = "Tipo=Pocket|Status=Online"
    rednet.broadcast("SAVE_ID_POCKET:" .. pocketID .. "|" .. info)
    print("✅ Registro enviado ao Master!")
end
 
registrarNoMaster()
 
-- IA de boas-vindas
term.clear()
term.setCursorPos(1,1)
iaFala("Olá! Sou sua IA Pocket W.E.T.S")
sleep(1)
iaFala("Você está conectado ao servidor Master.")
sleep(1)
iaFala("Use o menu abaixo para interagir com a nuvem!")
 
-- Menu automático ao iniciar
local function menuPocket()
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print("===============================")
        print("     📲 Pocket Client W.E.T.S")
        print("===============================\n")
        print("1 - 📂 Listar arquivos da Nuvem")
        print("2 - 📄 Ler conteúdo de um arquivo")
        print("3 - 📝 Criar arquivo na Nuvem")
        print("4 - 🔄 Pedir atualização ao Master")
        print("5 - ℹ️ Ajuda da IA")
        print("6 - ❌ Sair\n")
        write("Escolha: ")
        local opcao = read()
 
        if opcao == "1" then
            rednet.broadcast("LIST:nuvem")
            local id, resposta = rednet.receive(2)
            if resposta then
                print("\n📂 Arquivos na Nuvem:")
                print(resposta:gsub("LIST:", ""))
            else
                print("\n⚠️ Sem resposta do master.")
            end
            os.pullEvent("key")
 
        elseif opcao == "2" then
            write("\nDigite o nome do arquivo: ")
            local nome = read()
            rednet.broadcast("READ:" .. nome)
            local id, conteudo = rednet.receive(2)
            if conteudo then
                print("\n📄 Conteúdo:\n")
                print(conteudo:gsub("DATA:", ""))
            else
                print("\n⚠️ Sem resposta do master.")
            end
            os.pullEvent("key")
 
        elseif opcao == "3" then
            write("\nNome do novo arquivo: ")
            local nome = read()
            print("Digite o conteúdo (fim com linha vazia):")
            local linhas = {}
            while true do
                local linha = read()
                if linha == "" then break end
                table.insert(linhas, linha)
            end
            local conteudo = table.concat(linhas, "\n")
            rednet.broadcast("SAVE:" .. nome .. "|" .. conteudo)
            print("\n✅ Arquivo enviado para a Nuvem!")
            os.pullEvent("key")
 
        elseif opcao == "4" then
            rednet.broadcast("ATUALIZAR")
            print("\n🔄 Pedido de atualização enviado ao master!")
            os.pullEvent("key")
 
        elseif opcao == "5" then
            term.clear()
            term.setCursorPos(1,1)
            iaFala("Ajuda Rápida da IA:")
            print("- 📂 Opção 1: Ver arquivos que estão na nuvem.")
            print("- 📄 Opção 2: Ler o conteúdo de um arquivo específico.")
            print("- 📝 Opção 3: Criar e salvar um novo arquivo.")
            print("- 🔄 Opção 4: Pedir ao Master para atualizar todos os arquivos.")
            print("- ❌ Opção 6: Sair do Pocket Client.")
            print("\nPressione qualquer tecla para voltar.")
            os.pullEvent("key")
 
        elseif opcao == "6" then
            print("\n❌ Fechando Pocket Client...")
            sleep(1)
            break
        else
            print("\n❗ Opção inválida!")
            sleep(1)
        end
    end
end
 
menuPocket()
 
