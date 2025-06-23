-- email_client.lua - W.E.T.S Email Client v5.3 - Email por Wi-Fi + ID por Nick + Touch
 
-- Abrir todos os modems
local sides = {"left", "right", "top", "bottom", "front", "back"}
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
        rednet.open(side)
    end
end
 
local largura, altura = term.getSize()
 
print("\n===================================")
print(" 📧 W.E.T.S EMAIL CLIENT v5.3")
print("===================================\n")
 
local function iaAjuda()
    print("\n🤖 IA de Ajuda - Email:")
    print("- Você pode enviar emails para outro usuário (pelo nick).")
    print("- Seu ID de email é: <seuNick>@wets.local")
    print("- Comandos:")
    print("  /caixa → Ver suas mensagens")
    print("  /enviar → Enviar novo email")
    print("  /ajuda → Mostrar ajuda\n")
end
 
write("Digite seu nome completo: ")
local nomeCompleto = read()
local nick = nomeCompleto:match("([^%s]+)")
local emailID = nick.."@wets.local"
 
print("\n✅ Seu email: "..emailID)
 
-- Buscar ID do servidor
local serverID = nil
print("\n🔍 Procurando servidor de Email...")
 
local function encontrarServidor()
    local id, msg = rednet.receive(3)
    if id and msg and msg:find("WETS_EMAIL_SERVER") then
        serverID = id
        print("✅ Servidor encontrado! ID: "..id)
    end
end
encontrarServidor()
 
if not serverID then
    print("❌ Servidor de email não encontrado!")
    return
end
 
local caixa = {}
 
local function mostrarCaixa()
    term.clear()
    term.setCursorPos(1,1)
    print("📥 Caixa de Entrada - "..emailID.."\n")
 
    if #caixa == 0 then
        print("Nenhuma mensagem recebida.\n")
    else
        for i, email in ipairs(caixa) do
            print(i..". De: "..email.remetente)
            print("   Assunto: "..email.assunto)
            print("   Conteúdo: "..email.corpo.."\n")
        end
    end
    print("[Atualizar] [Voltar]")
end
 
local function receberEmails()
    while true do
        local id, msg = rednet.receive()
        if id == serverID and type(msg) == "table" and msg.destinatario == emailID then
            table.insert(caixa, msg)
            print("\n📬 Novo Email recebido de "..msg.remetente.."!")
        end
    end
end
 
local function enviarEmail()
    term.clear()
    term.setCursorPos(1,1)
    print("✉️ Enviar novo Email")
 
    write("Para (Nick): ")
    local paraNick = read()
    local destinatario = paraNick.."@wets.local"
 
    write("Assunto: ")
    local assunto = read()
 
    write("Mensagem: ")
    local corpo = read()
 
    local email = {
        remetente = emailID,
        destinatario = destinatario,
        assunto = assunto,
        corpo = corpo
    }
 
    rednet.send(serverID, email)
    print("\n✅ Email enviado para "..destinatario.."!")
    sleep(1)
end
 
local function interface()
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print("📧 W.E.T.S Email - "..emailID)
        print(string.rep("-", largura))
        print("[/caixa] Ver caixa de entrada")
        print("[/enviar] Novo email")
        print("[/ajuda] Ajuda")
        print("[/sair] Sair\n")
 
        term.write("> ")
        local input = read()
 
        if input == "/caixa" then
            mostrarCaixa()
            os.pullEvent("key")
 
        elseif input == "/enviar" then
            enviarEmail()
 
        elseif input == "/ajuda" then
            iaAjuda()
            sleep(2)
 
        elseif input == "/sair" then
            print("👋 Saindo...")
            sleep(1)
            os.shutdown()
        end
    end
end
 
parallel.waitForAny(interface, receberEmails)
 
