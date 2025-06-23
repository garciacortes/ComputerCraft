-- wifi_server.lua - Servidor Wi-Fi W.E.T.S com Nuvem Interna e Salas por ID
 
local pastaSalas = "salas_nuvem"
local pastebin_chat_id = "6yTXZnju" -- ID do chat_client.lua no Pastebin
 
-- Abrir todos os modems
local sides = {"left","right","top","bottom","front","back"}
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
        rednet.open(side)
        print("📡 Modem aberto: "..side)
    end
end
 
-- Criar pasta de backup das salas
if not fs.exists(pastaSalas) then
    fs.makeDir(pastaSalas)
end
 
local salas = {}
 
local function salvarSala(salaID)
    local sala = salas[salaID]
    if sala then
        local arq = fs.open(pastaSalas.."/"..salaID..".lua", "w")
        arq.write("return "..textutils.serialize(sala))
        arq.close()
        print("💾 Sala '"..salaID.."' salva na nuvem interna.")
    end
end
 
local function carregarSalas()
    for _, file in ipairs(fs.list(pastaSalas)) do
        if file:sub(-4) == ".lua" then
            local salaID = file:sub(1, -5)
            local ok, sala = pcall(dofile, pastaSalas.."/"..file)
            if ok then
                salas[salaID] = sala
                print("📥 Sala carregada: "..salaID)
            end
        end
    end
end
 
carregarSalas()
 
local function enviarParaSala(salaID, msg)
    local sala = salas[salaID]
    if not sala then return end
 
    table.insert(sala.historico, msg)
    if #sala.historico > 50 then table.remove(sala.historico, 1) end
 
    for usuarioID in pairs(sala.usuarios) do
        rednet.send(usuarioID, msg)
    end
end
 
while true do
    local id, msg = rednet.receive()
 
    if type(msg) == "table" and msg.tipo then
        -- Cliente procurando servidor da sala
        if msg.tipo == "procura_servidor" and msg.sala then
            if salas[msg.sala] then
                rednet.send(id, {tipo="resposta_servidor", sala=msg.sala})
            end
 
        -- Cliente pedindo para entrar
        elseif msg.tipo == "join" and msg.sala and msg.nick then
            if not salas[msg.sala] then
                salas[msg.sala] = {usuarios={}, historico={}}
                print("➕ Nova sala criada: "..msg.sala)
            end
            salas[msg.sala].usuarios[id] = true
            print("✅ "..msg.nick.." entrou na sala "..msg.sala)
            -- Mandar histórico
            for _, histMsg in ipairs(salas[msg.sala].historico) do
                rednet.send(id, histMsg)
            end
            enviarParaSala(msg.sala, {tipo="sistema", texto=msg.nick.." entrou."})
 
        -- Mensagem de chat
        elseif msg.tipo == "chat" and msg.sala and msg.nick and msg.texto then
            enviarParaSala(msg.sala, {tipo="chat", nick=msg.nick, texto=msg.texto})
 
        -- Sair
        elseif msg.tipo == "sair" and msg.sala and msg.nick then
            if salas[msg.sala] then
                salas[msg.sala].usuarios[id] = nil
                enviarParaSala(msg.sala, {tipo="sistema", texto=msg.nick.." saiu."})
                -- Se a sala ficar vazia, remove
                local vazio = true
                for _ in pairs(salas[msg.sala].usuarios) do vazio = false break end
                if vazio then
                    salvarSala(msg.sala)
                    salas[msg.sala] = nil
                    print("🗑️ Sala '"..msg.sala.."' apagada da memória (vazia).")
                end
            end
 
        -- Backup manual (opcional)
        elseif msg.tipo == "backup_salas" then
            for s,_ in pairs(salas) do salvarSala(s) end
            rednet.send(id, {tipo="backup_ok"})
 
        else
            print("❓ Mensagem desconhecida: "..textutils.serialize(msg))
        end
    end
end
 
