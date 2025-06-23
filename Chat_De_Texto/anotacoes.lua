-- anotacoes.lua - Editor de Anotações W.E.T.S
 
os.pullEvent = os.pullEventRaw
local arquivo = "anotacoes.txt"
 
local function salvarAnotacoes(linhas)
    local f = fs.open(arquivo, "w")
    for _, linha in ipairs(linhas) do
        f.writeLine(linha)
    end
    f.close()
end
 
local function carregarAnotacoes()
    local linhas = {}
    if fs.exists(arquivo) then
        local f = fs.open(arquivo, "r")
        local linha = f.readLine()
        while linha do
            table.insert(linhas, linha)
            linha = f.readLine()
        end
        f.close()
    end
    return linhas
end
 
local function editarAnotacoes()
    term.clear()
    print("📝 Editor de Anotações\n")
    local linhas = carregarAnotacoes()
    for _, linha in ipairs(linhas) do
        print("> " .. linha)
    end
    print("\nDigite novas linhas (linha vazia para salvar):")
 
    while true do
        term.write("> ")
        local entrada = read()
        if entrada == "" then break end
        table.insert(linhas, entrada)
    end
 
    salvarAnotacoes(linhas)
    print("\n✅ Anotações salvas!")
end
 
local function enviarBackup()
    if rednet.isOpen() then
        local f = fs.open(arquivo, "r")
        local conteudo = f.readAll()
        f.close()
        rednet.broadcast({tipo="backup", arquivo="anotacoes.txt", dados=conteudo})
        print("📤 Backup enviado via Rednet!")
    end
end
 
editarAnotacoes()
enviarBackup()
 
