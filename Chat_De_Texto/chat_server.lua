-- chat_server.lua - W.E.T.S Chat Server (Versão 4.5)
 
rednet.open("back")
 
local usuarios = {}
local grupos = {}
 
print("🌩️ Servidor de Chat W.E.T.S iniciado!")
 
local function enviarParaGrupo(sala, msg)
    if grupos[sala] then
        for _, id in ipairs(grupos[sala]) do
            rednet.send(id, msg)
        end
    end
end
 
local function processarMensagem(id, msg)
    if msg:find("JOIN:") then
        local dados = msg:sub(6)
        local username, senha = dados:match("([^|]+)|(.+)")
        usuarios[id] = {nick = username, sala = senha}
 
        if not grupos[senha] then grupos[senha] = {} end
        table.insert(grupos[senha], id)
 
        rednet.send(id, "✅ Bem-vindo ao grupo/sala: " .. senha)
        enviarParaGrupo(senha, "👋 " .. username .. " entrou na sala.")
 
    elseif msg == "/sair" then
        if usuarios[id] then
            local sala = usuarios[id].sala
            enviarParaGrupo(sala, "👋 " .. usuarios[id].nick .. " saiu.")
            for i, uid in ipairs(grupos[sala]) do
                if uid == id then table.remove(grupos[sala], i) break end
            end
            usuarios[id] = nil
        end
        rednet.send(id, "Você saiu do chat.")
 
    elseif msg == "/ajuda" then
        rednet.send(id, "🤖 Comandos: /sair | /ajuda | Use emojis como :) :( :D")
 
    else
        if usuarios[id] then
            local sala = usuarios[id].sala
            local nick = usuarios[id].nick
            local mensagemFinal = nick .. ": " .. msg
            mensagemFinal = mensagemFinal:gsub(":%)", "😊")
            mensagemFinal = mensagemFinal:gsub(":%(", "😢")
            mensagemFinal = mensagemFinal:gsub(":D", "😁")
            enviarParaGrupo(sala, mensagemFinal)
        else
            rednet.send(id, "❌ Você não está em uma sala. Use JOIN.")
        end
    end
end
 
while true do
    local id, msg = rednet.receive()
    processarMensagem(id, msg)
end
 
