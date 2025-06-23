-- speaker_receiver.lua - Recebe comandos via Rednet e toca no speaker
 
-- Abrir modem
local modems = {}
for _, nome in ipairs(peripheral.getNames()) do
    local tipo = peripheral.getType(nome)
    if tipo == "modem" or tipo == "bluetooth_modem" then
        table.insert(modems, nome)
    end
end
 
if #modems == 0 then
    print("❌ Nenhum modem encontrado!")
    return
end
 
local modemName = modems[1]  -- Usar o primeiro modem encontrado
rednet.open(modemName)
print("✅ Rednet aberto no modem: " .. modemName)
 
-- Detectar speaker
local speakerName = nil
for _, nome in ipairs(peripheral.getNames()) do
    if peripheral.getType(nome) == "speaker" then
        speakerName = nome
        break
    end
end
 
if not speakerName then
    print("❌ Nenhum speaker encontrado!")
    return
end
 
print("🔊 Speaker detectado: " .. speakerName)
print("👂 Aguardando comandos via Rednet...")
 
while true do
    local id, mensagem, protocolo = rednet.receive(nil) -- recebe qualquer protocolo
    if type(mensagem) == "table" and mensagem.tipo == "speaker" then
        if mensagem.comando == "teste_som" then
            print("🔔 Comando: Teste de som recebido. Tocando beep.")
            peripheral.call(speakerName, "playNote", "harp", 1, 1)
            rednet.send(id, {tipo="speaker", status="Teste de som executado"})
 
        elseif mensagem.comando == "tocar_musica" and mensagem.nota and mensagem.octava then
            print("🎵 Tocando nota: "..mensagem.nota.." na oitava "..mensagem.octava)
            peripheral.call(speakerName, "playNote", mensagem.nota, mensagem.octava, 1)
            rednet.send(id, {tipo="speaker", status="Nota tocada: "..mensagem.nota})
 
        elseif mensagem.comando == "parar" then
            print("⏹️ Comando: Parar som recebido.")
            -- Não existe stop no speaker padrão, mas você pode implementar lógica aqui
            rednet.send(id, {tipo="speaker", status="Parar som não implementado"})
 
        else
            print("❓ Comando desconhecido: " .. tostring(mensagem.comando))
            rednet.send(id, {tipo="speaker", status="Comando desconhecido"})
        end
    end
end
 
