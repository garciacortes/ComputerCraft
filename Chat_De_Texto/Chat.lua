-- chat_client.lua - W.E.T.S Chat Client v5.3 - Suporte Touch + Wi-Fi + Salas + Admin + Rednet
 
-- Abrir todos os modems
local sides = {"left", "right", "top", "bottom", "front", "back"}
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
        rednet.open(side)
    end
end
 
print("\n===================================")
print(" W.E.T.S CLIENT - CHAT v5.3")
print("===================================\n")
 
local largura, altura = term.getSize()
 
local function iaAjuda()
    print("\n🤖 IA de Ajuda - Comandos no Chat:")
    print("- /sair → Sair da sala")
    print("- /listar → Ver salas ativas")
    print("- /backup → Forçar backup (se for admin)")
    print("- /add <Nick> → Adicionar usuário")
    print("- /remove <Nick> → Remover usuário")
    print("- /ajuda → Mostrar esta ajuda")
    print("\n📱 Suporte ao Touch: Clique nos botões rápidos abaixo do campo de mensagem.\n")
end
 
iaAjuda()
 
write("Digite seu nome completo: ")
local nomeCompleto = read()
local nick = nomeCompleto:match("([^%s]+)")
 
write("Digite a senha da sala (ID da sala): ")
local salaID = read()
 
-- Procurar o Server ID
local serverID = nil
print("\n🔍 Procurando servidor...")
 
local function encontrarServidor()
    local id, msg = rednet.receive(3)
    if id and msg and msg:find("W.E.T.S") then
        serverID = id
        print("✅ Servidor encontrado! ID: "..id)
    end
end
encontrarServidor()
 
if not serverID then
    print("❌ Nenhum servidor encontrado!")
    return
end
 
-- Enviar login
rednet.send(serverID, "JOIN:"..nick.."|"..salaID)
 
-- Exibir mensagens recebidas
local mensagens = {}
 
local function mostrarBalao(msg)
    table.insert(mensagens, msg)
    if #mensagens > altura - 8 then
        table.remove(mensagens, 1)
    end
 
    term.clear()
    term.setCursorPos(1,1)
    print("👥 Sala: "..salaID.." | Usuário: "..nick)
    print(string.rep("-", largura))
 
    for _, linha in ipairs(mensagens) do
        print(linha)
    end
 
    print(string.rep("-", largura))
    print("[Enviar] [Sair] [Listar] [Ajuda] [Backup]")
    term.setCursorPos(1, altura)
    term.write("> ")
end
 
local function receberMensagens()
    while true do
        local id, mensagem = rednet.receive()
        mostrarBalao(mensagem)
    end
end
 
local function enviarMensagens()
    while true do
        local event, p1, x, y = os.pullEvent()
 
        -- Teclado
        if event == "key" then
            term.setCursorPos(3, altura)
            local texto = read()
 
            if texto == "/sair" then
                print("👋 Saindo...")
                sleep(1)
                os.shutdown()
 
            elseif texto == "/ajuda" then
                iaAjuda()
 
            elseif texto == "/listar" then
                rednet.send(serverID, "/listarSalas")
 
            elseif texto == "/backup" then
                rednet.send(serverID, "/backup")
 
            elseif texto:find("^/add ") then
                local novoUsuario = texto:sub(6)
                rednet.send(serverID, "ADD:" .. novoUsuario .. ":" .. salaID)
 
            elseif texto:find("^/remove ") then
                local removerUsuario = texto:sub(9)
                rednet.send(serverID, "REMOVE:" .. removerUsuario .. ":" .. salaID)
 
            else
                rednet.send(serverID, salaID .. ":" .. nick .. " ➜ " .. texto)
            end
 
        -- Touch
        elseif event == "monitor_touch" or event == "mouse_click" then
            if y == altura - 1 then
                if x >= 2 and x <= 8 then
                    term.setCursorPos(3, altura)
                    local texto = read()
                    rednet.send(serverID, salaID .. ":" .. nick .. " ➜ " .. texto)
 
                elseif x >= 10 and x <= 15 then
                    os.shutdown()
 
                elseif x >= 17 and x <= 23 then
                    rednet.send(serverID, "/listarSalas")
 
                elseif x >= 25 and x <= 30 then
                    iaAjuda()
 
                elseif x >= 32 then
                    rednet.send(serverID, "/backup")
                end
            end
        end
    end
end
 
parallel.waitForAny(receberMensagens, enviarMensagens)
 
