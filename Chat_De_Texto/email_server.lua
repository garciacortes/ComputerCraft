-- email_server.lua - W.E.T.S Email Server v5.3 - Rednet Wi-Fi + Multiuser
 
-- Abrir todos os modems
local sides = {"left", "right", "top", "bottom", "front", "back"}
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
        rednet.open(side)
    end
end
 
print("\n===================================")
print(" 📡 W.E.T.S EMAIL SERVER v5.3")
print("===================================\n")
 
-- Sinal de identificação do servidor
local serverTag = "WETS_EMAIL_SERVER"
 
-- Enviar broadcast para clientes detectarem
parallel.waitForAny(function()
    while true do
        rednet.broadcast(serverTag)
        sleep(5)
    end
end,
 
function()
    local caixas = {}
 
    while true do
        local id, msg = rednet.receive()
 
        -- Se for um email (tabela)
        if type(msg) == "table" and msg.remetente and msg.destinatario then
            print("\n📨 Novo email de "..msg.remetente.." → "..msg.destinatario)
 
            -- Criar caixa de entrada se não existir
            if not caixas[msg.destinatario] then
                caixas[msg.destinatario] = {}
            end
 
            -- Salvar na caixa
            table.insert(caixas[msg.destinatario], msg)
 
            -- Tentar enviar ao destinatário se ele estiver online
            rednet.broadcast(msg)
 
        -- Se for outro comando, pode adicionar futuros comandos aqui
        else
            print("\n🔔 Recebido comando de ID "..id..": "..tostring(msg))
        end
    end
end)
 
