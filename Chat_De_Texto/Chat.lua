-- chat_client.lua - W.E.T.S Chat Client v5.3 - Visual melhorado com paintutils + touch
 
local sides = {"left","right","top","bottom","front","back"}
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
        rednet.open(side)
    end
end
 
local largura, altura = term.getSize()
 
local mensagens = {}
local nick, salaID, serverID
local input = ""
 
local colorsTitle = colors.lightBlue
local colorsPanel = colors.gray
local colorsInputBG = colors.lightGray
local colorsButtonBG = colors.blue
local colorsButtonText = colors.white
local colorsMsgBG = colors.black
local colorsMsgText = colors.white
 
-- Desenha uma caixa com borda e fundo
local function desenharCaixa(x1, y1, x2, y2, bgColor, borderColor)
    paintutils.drawFilledBox(x1, y1, x2, y2, bgColor)
    paintutils.drawBox(x1, y1, x2, y2, borderColor)
end
 
-- Desenha layout geral
local function desenharLayout()
    term.setBackgroundColor(colorsPanel)
    term.clear()
 
    -- Título
    desenharCaixa(1,1, largura, 3, colorsTitle, colors.white)
    term.setCursorPos(math.floor((largura - 16)/2), 2)
    term.setTextColor(colors.white)
    term.write("🌐 W.E.T.S CHAT v5.3")
 
    -- Painel mensagens
    desenharCaixa(2,4, largura-1, altura-6, colorsMsgBG, colors.white)
 
    -- Painel input
    desenharCaixa(2, altura-5, largura-1, altura-3, colorsInputBG, colors.white)
 
    -- Botões
    local btns = {
        {text = "📤 Enviar", action = "enviar"},
        {text = "🚪 Sair", action = "sair"},
        {text = "📋 Listar", action = "listar"},
        {text = "❓ Ajuda", action = "ajuda"},
        {text = "💾 Backup", action = "backup"},
    }
    local x = 3
    local y = altura - 2
    for _, btn in ipairs(btns) do
        local w = #btn.text + 2
        desenharCaixa(x, y, x + w, y + 1, colorsButtonBG, colors.white)
        term.setCursorPos(x + 1, y + 1)
        term.setTextColor(colorsButtonText)
        term.write(btn.text)
        btn.x1, btn.y1, btn.x2, btn.y2 = x, y, x + w, y + 1
        x = x + w + 3
    end
 
    -- Escrever texto input
    term.setCursorPos(3, altura-4)
    term.setTextColor(colorsMsgText)
    term.clearLine()
    term.write(input)
end
 
-- Mostrar mensagens no painel
local function mostrarMensagens()
    local maxLinhas = altura - 10
    for i = 1, maxLinhas do
        term.setCursorPos(3, i + 4)
        term.setBackgroundColor(colorsMsgBG)
        term.setTextColor(colorsMsgText)
        term.clearLine()
        local msg = mensagens[#mensagens - maxLinhas + i] or ""
        term.write(msg)
    end
end
 
local function iaAjuda()
    table.insert(mensagens, "🤖 Comandos: /sair, /listar, /backup, /ajuda, /add <nick>, /remove <nick>")
    if #mensagens > 100 then
        table.remove(mensagens, 1)
    end
    mostrarMensagens()
end
 
-- Entrada de nome e sala
term.clear()
term.setCursorPos(1,1)
print("===================================")
print(" W.E.T.S CLIENT - CHAT v5.3")
print("===================================\n")
 
write("Digite seu nome completo: ")
local nomeCompleto = read()
nick = nomeCompleto:match("([^%s]+)")
 
write("Digite a senha da sala (ID da sala): ")
salaID = read()
 
print("\n🔍 Procurando servidor W.E.T.S...")
while true do
    local id, msg = rednet.receive(3)
    if id and msg and msg:find("W.E.T.S") then
        serverID = id
        print("✅ Servidor encontrado! ID: " .. id)
        break
    else
        print("❌ Nenhum servidor... Tentando novamente...")
    end
end
 
rednet.send(serverID, "JOIN:" .. nick .. "|" .. salaID)
 
desenharLayout()
mostrarMensagens()
term.setCursorPos(3, altura-4)
 
local function enviarMensagem(texto)
    rednet.send(serverID, salaID .. ":" .. nick .. " ➜ " .. texto)
end
 
local function animacaoEnviar()
    local x, y = 3, altura - 4
    local anim = {"📤", "📦", "✉️", "📬"}
    for i = 1, #anim do
        term.setCursorPos(x, y)
        term.write(anim[i])
        sleep(0.1)
    end
end
 
local function receberMensagens()
    while true do
        local id, msg = rednet.receive()
        table.insert(mensagens, msg)
        if #mensagens > 100 then
            table.remove(mensagens, 1)
        end
        mostrarMensagens()
        desenharLayout()
        term.setCursorPos(3 + #input, altura-4)
    end
end
 
local function enviarMensagens()
    while true do
        local event, p1, x, y = os.pullEvent()
 
        if event == "key" then
            term.setCursorPos(3, altura-4)
            term.clearLine()
            input = read()
            if input == "/sair" then
                rednet.send(serverID, "/sair")
                print("👋 Saindo...")
                sleep(1)
                os.exit()
            elseif input == "/ajuda" then
                iaAjuda()
            elseif input == "/listar" then
                rednet.send(serverID, "/listarSalas")
            elseif input == "/backup" then
                rednet.send(serverID, "/backup")
            elseif input:find("^/add ") then
                local novoUsuario = input:sub(6)
                rednet.send(serverID, "ADD:" .. novoUsuario .. ":" .. salaID)
            elseif input:find("^/remove ") then
                local removerUsuario = input:sub(9)
                rednet.send(serverID, "REMOVE:" .. removerUsuario .. ":" .. salaID)
            else
                enviarMensagem(input)
                animacaoEnviar()
            end
            input = ""
            desenharLayout()
            term.setCursorPos(3, altura-4)
 
        elseif event == "mouse_click" or event == "monitor_touch" then
            local btns = {
                {text = "📤 Enviar", action = function()
                    if input ~= "" then
                        enviarMensagem(input)
                        animacaoEnviar()
                        input = ""
                        desenharLayout()
                    end
                end},
                {text = "🚪 Sair", action = function()
                    rednet.send(serverID, "/sair")
                    print("👋 Saindo...")
                    sleep(1)
                    os.exit()
                end},
                {text = "📋 Listar", action = function()
                    rednet.send(serverID, "/listarSalas")
                end},
                {text = "❓ Ajuda", action = function()
                    iaAjuda()
                end},
                {text = "💾 Backup", action = function()
                    rednet.send(serverID, "/backup")
                end},
            }
            for _, btn in ipairs(btns) do
                if x >= btn.x1 and x <= btn.x2 and y >= btn.y1 and y <= btn.y2 then
                    btn.action()
                    break
                end
            end
 
            -- Clicar na caixa de texto para digitar
            if y >= altura - 5 and y <= altura - 3 and x >= 3 and x <= largura - 1 then
                term.setCursorPos(3, altura-4)
                term.clearLine()
                input = read()
                desenharLayout()
                term.setCursorPos(3, altura-4)
            end
        end
    end
end
 
parallel.waitForAny(receberMensagens, enviarMensagens)
 
