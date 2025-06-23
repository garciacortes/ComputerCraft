term.clear()
term.setCursorPos(1,1)
 
print("===================================")
print(" W.E.T.S - Instalador Inteligente ")
print("===================================\n")
 
-- Abrir modem automaticamente
local modemAberto = false
local sides = {"left", "right", "top", "bottom", "front", "back"}
 
for _, side in ipairs(sides) do
    if peripheral.getType(side) == "modem" then
        rednet.open(side)
        print("📡 Modem encontrado e aberto: " .. side)
        modemAberto = true
        break
    end
end
 
if not modemAberto then
    print("❌ Nenhum modem encontrado! Instalação abortada.")
    return
end
 
-- Baixar arquivos_ids.lua da nuvem
local idArquivos = "https://raw.githubusercontent.com/garciacortes/ComputerCraft/refs/heads/main/Chat_De_Texto/arquivos_ids.lua"  -- ✅ ID do arquivos_ids.lua
print("\n📥 Baixando lista de arquivos (arquivos_ids.lua)...")
 
if fs.exists("arquivos_ids.lua") then fs.delete("arquivos_ids.lua") end
    response = http.get(idArquivos).readAll()
    file = fs.open("arquivos_ids.lua", "w")
    file.write(response)
    file.close()

 
if not fs.exists("arquivos_ids.lua") then
    print("❌ Erro ao baixar o arquivos_ids.lua!")
    return
end
 
local arquivos = dofile("arquivos_ids.lua")
 
-- Buscar o ID do atualizador_master.lua
local atualizadorID = nil
for _, arquivo in ipairs(arquivos) do
    if arquivo.nome == "atualizador_master.lua" then
        atualizadorID = arquivo.pastebinID
        break
    end
end
 
if atualizadorID then
    print("\n📥 Baixando o atualizador_master.lua...")
    if fs.exists("atualizador_master.lua") then fs.delete("atualizador_master.lua") end
    response = http.get(atualizadorID).readAll()
    file = fs.open("atualizador_master.lua", "w")
    file.write(response)
    file.close()
else
    print("❌ Não encontrei o ID do atualizador_master.lua na lista!")
    return
end
 
-- Rodar o atualizador_master.lua
print("\n🚀 Iniciando o Atualizador Master...")
sleep(2)
shell.run("atualizador_master.lua")
 
