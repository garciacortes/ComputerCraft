-- atualizar_server.lua - Atualizador de Chat Server W.E.T.S
 
term.clear()
term.setCursorPos(1,1)
 
print("=========================================")
print("🔄 W.E.T.S - Atualizador de Servidor Chat")
print("=========================================")
print("")
print("🔗 Conectando ao servidor de nuvem...")
 
local idServer = nil
 
-- Carregar lista de IDs da nuvem
if fs.exists("arquivos_ids.lua") then
    local ids = dofile("arquivos_ids.lua")
    for _, arquivo in ipairs(ids) do
        if arquivo.nome == "chat_server.lua" then
            idServer = arquivo.pastebinID
            break
        end
    end
else
    print("\n❌ Arquivo 'arquivos_ids.lua' não encontrado!")
    return
end
 
if not idServer then
    print("\n❌ ID do chat_server.lua não encontrado dentro do arquivos_ids.lua!")
    return
end
 
-- Verificar se o arquivo já existe
if fs.exists("chat_server.lua") then
    print("\n⚠️ O arquivo 'chat_server.lua' já existe.")
    print("Deseja substituir pela nova versão? (S/N)")
 
    while true do
        local event, key = os.pullEvent("key")
        local tecla = keys.getName(key)
        if tecla == "s" or tecla == "S" then
            break
        elseif tecla == "n" or tecla == "N" then
            print("\n✅ Atualização cancelada. Mantendo a versão atual.")
            return
        end
    end
 
    -- Excluir versão antiga
    fs.delete("chat_server.lua")
end
 
print("\n📥 Baixando o novo chat_server.lua...")
response = http.get(idServer).readAll()
file = fs.open("chat_server.lua", "w")
file.write(response)
file.close()
 
if fs.exists("chat_server.lua") then
    print("✅ Servidor atualizado com sucesso!")
else
    print("❌ Falha ao baixar o chat_server.lua.")
    return
end
 
-- Animação de reinicialização
print("\n🔁 Reiniciando o servidor...")
local altura = select(2, term.getSize())
for i = 1, 3 do
    term.setCursorPos(1, altura - 1)
    print(("Reiniciando" .. string.rep(".", i)) .. " ")
    sleep(0.5)
end
 
-- Iniciar o novo servidor
shell.run("chat_server.lua")
 
