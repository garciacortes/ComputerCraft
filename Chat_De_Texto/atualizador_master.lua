-- atualizador_master.lua - W.E.T.S Master Updater v5.3 - Cloud + Rednet + Auto Backup + Speaker + Email + Música + Anotações + Planilha
 
term.clear()
term.setCursorPos(1,1)
print("==========================================")
print("        🌩️ W.E.T.S Master Cloud Updater")
print("==========================================\n")
 
-- Abrir todos os modems
local sides = {"left", "right", "top", "bottom", "front", "back"}
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" and not rednet.isOpen(side) then
        rednet.open(side)
    end
end
 
-- ID do arquivo de IDs
local idsPastebin = "https://raw.githubusercontent.com/garciacortes/ComputerCraft/refs/heads/main/Chat_De_Texto/arquivos_ids.lua"
local idsFile = "arquivo_ids.lua"
 
-- Baixar a lista de IDs da nuvem
if fs.exists(idsFile) then fs.delete(idsFile) end
print("📥 Baixando lista de IDs...")
response = http.get(idsPastebin).readAll()
file = fs.open(idsFile, "w")
file.write(response)
file.close()
 
if not fs.exists(idsFile) then
    print("❌ Falha ao baixar o arquivo de IDs!")
    return
end
 
local arquivos = dofile(idsFile)
 
-- Backup dos arquivos antigos
print("\n🔄 Fazendo backup dos arquivos existentes...")
if not fs.exists("backup") then fs.makeDir("backup") end
for nome in pairs(arquivos) do
    if fs.exists(nome) then
        fs.move(nome, "backup/"..nome)
        print("✅ Backup de: "..nome)
    end
end
 
-- Download de todos os arquivos listados
print("\n⬇️ Baixando os arquivos da nuvem...")
 
for nome, pastebinID in pairs(arquivos) do
    print("➡️ "..nome.." ← "..pastebinID)
    response = http.get(pastebinID).readAll()
    file = fs.open(nome, "w")
    file.write(response)
    file.close()
end
 
print("\n✅ Atualização completa!")
print("✅ Backup salvo na pasta /backup")
 
-- Notificar no Rednet
rednet.broadcast("[MASTER] Sistema atualizado para W.E.T.S 5.3")
 
-- Detectar Speaker
local speakerSide = nil
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "speaker" then
        speakerSide = side
        break
    end
end
 
if speakerSide then
    peripheral.call(speakerSide, "playNote", "pling", 1, 2)
    print("🔊 Speaker detectado e som de atualização tocado!")
end
 
print("\n👉 Digite: menu   → Para abrir o Menu Principal")
 
