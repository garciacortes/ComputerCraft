-- server.lua - W.E.T.S Wi-Fi Server v5.3 - Multi Salas + Cloud + Rednet
 
-- Abrir todos os modems disponíveis
local sides = {"left", "right", "top", "bottom", "front", "back"}
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
        rednet.open(side)
    end
end
 
print("===================================")
print("🌐 W.E.T.S - Wi-Fi Server v5.3")
print("===================================\n")
 
local salas = {}  -- Estrutura: { ["ID_da_Sala"] = { usuarios = {}, mensagens = {} } }
 
-- Função: Salvar backup das salas na nuvem (arquivo local .cloud_backup)
local function salvarBackup()
    local file = fs.open("cloud_backup.lua", "w")
    file.write(textutils.serialize(salas))
    file.close()
end
 
-- Função: Carregar backup
local function carregarBackup()
    if fs.exists("cloud_backup.lua") then
        local file = fs.open("cloud_backup.lua", "r")
        local data = file.readAll()
        file.close()
        salas = textutils.unserialize(data) or {}
    end
end
 
carregarBackup()
 
print("✅ Cloud interno carregado.")
 
while true do
    local id, msg = rednet.receive()
 
    if type(msg) == "string" then
        -- Cliente está entrando em uma sala
        if msg:find("^JOIN:") then
            local partes = msg:sub(6):split("|")
            local nick = partes[1]
            local salaID = partes[2]
 
            salas[salaID] = salas[salaID] or {usuarios = {}, mensagens = {}}
            salas[salaID].usuarios[id] = nick
 
            rednet.send(id, "🤖 Bem-vindo, "..nick.."! Você entrou na sala: "..salaID)
 
        -- Cliente enviando mensagem para a sala
        elseif msg:find(":") then
            local salaID, mensagem = msg:match("([^:]+):(.+)")
            if salas[salaID] then
                -- Salvar na Cloud interna
                table.insert(salas[salaID].mensagens, mensagem)
                salvarBackup()
 
                -- Enviar para todos da sala
                for uid, _ in pairs(salas[salaID].usuarios) do
                    rednet.send(uid, mensagem)
                end
            else
                rednet.send(id, "🤖 Sala '"..salaID.."' não encontrada!")
            end
 
        -- Admin criando sala manual
        elseif msg == "/listarSalas" then
            local lista = "Salas Online:\n"
            for salaID, sala in pairs(salas) do
                lista = lista .. "- " .. salaID .. " (" .. tostring(#(sala.mensagens)) .. " msgs)\n"
            end
            rednet.send(id, lista)
 
        -- Comando Admin: Backup manual
        elseif msg == "/backup" then
            salvarBackup()
            rednet.send(id, "✅ Backup da Cloud salvo.")
 
        else
            rednet.send(id, "🤖 Comando desconhecido.")
        end
    end
end
 
