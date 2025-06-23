term.clear()
term.setCursorPos(1,1)
 
print("===================================")
print("    W.E.T.S - INSTALADOR AUTOMÁTICO")
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
 
-- Testar comunicação com a nuvem (opcional)
print("\n🔍 Testando conexão com o servidor de nuvem...")
rednet.broadcast("PING:baixa.lua")
local id, resposta = rednet.receive(2)
if resposta then
    print("✅ Conexão com a nuvem OK! ID do servidor: " .. id)
else
    print("⚠️ Nenhuma resposta da nuvem, prosseguindo offline...")
end
 
-- Lista completa dos arquivos (Versão 5.3)
local arquivos = {
    {nome = "menu.lua", id = "EJQ2PzKr"},
    {nome = "chat_server.lua", id = "b15WbJdn"},
    {nome = "chat_client.lua", id = "6yTXZnju"},
    {nome = "versao.lua", id = "g3ykXWf5"},
    {nome = "atualizar_server.lua", id = "1i2nFHi6"},
    {nome = "calculadora.lua", id = "yfdrVZ31"},
    {nome = "atualizador_master.lua", id = "uZ6QV67i"},
    {nome = "server.lua", id = "YfGzJSxG"},
    {nome = "música.lua", id = "hmG6Ek2R"},
    {nome = "speaker_receiver.lua", id = "YHHmQcrZ"},
    {nome = "decodificadores.lua", id = "bNEPLHA6"},
    {nome = "pocket_client.lua", id = "EAuKVMKB"},
    {nome = "anotações.lua", id = "wnu1q4dU"},
    {nome = "planilha.lua", id = "D24zK5zj"},
    {nome = "email_server.lua", id = "BqdgQ1ym"},
    {nome = "email_client.lua", id = "Gb7i51mq"},
    {nome = "wifi_server.lua", id = "g9XsRj2a"},
    {nome = "arquivos_ids.lua", id = "fkwSV88X"}
}
 
-- Animação de download
local function animacao(nome)
    local barra = {"[          ]", "[=         ]", "[==        ]", "[===       ]", "[====      ]", "[=====     ]", "[======    ]", "[=======   ]", "[========  ]", "[========= ]", "[==========]"}
    for i = 1, #barra do
        term.setCursorPos(1, select(2, term.getCursorPos()))
        write("📥 Baixando "..nome.." "..barra[i].."   ")
        sleep(0.05)
    end
end
 
-- Download dos arquivos
for _, arquivo in ipairs(arquivos) do
    if fs.exists(arquivo.nome) then
        print("\n🔍 Atualizando "..arquivo.nome.." ...")
        fs.delete(arquivo.nome)
    end
    animacao(arquivo.nome)
    shell.run("pastebin get "..arquivo.id.." "..arquivo.nome)
    print(" ✅")
end
 
print("\n✅ Todos os arquivos foram baixados com sucesso!")
 
-- Inicia o servidor
print("\n🚀 Iniciando o servidor...")
sleep(2)
shell.run("server.lua")
