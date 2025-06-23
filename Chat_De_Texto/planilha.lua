-- planilha.lua - Editor de Planilha CSV - W.E.T.S
 
os.pullEvent = os.pullEventRaw
local arquivo = "planilha.csv"
 
local function salvarPlanilha(linhas)
    local f = fs.open(arquivo, "w")
    for _, linha in ipairs(linhas) do
        f.writeLine(linha)
    end
    f.close()
end
 
local function carregarPlanilha()
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
 
local function editarPlanilha()
    term.clear()
    print("📊 Editor de Planilha (Formato CSV)\n")
    local linhas = carregarPlanilha()
    for _, linha in ipairs(linhas) do
        print("> " .. linha)
    end
    print("\nDigite linhas no formato: coluna1,coluna2,coluna3")
    print("(Deixe vazio para salvar e sair)\n")
 
    while true do
        term.write("> ")
        local entrada = read()
        if entrada == "" then break end
        table.insert(linhas, entrada)
    end
 
    salvarPlanilha(linhas)
    print("\n✅ Planilha salva!")
end
 
local function enviarBackup()
    if rednet.isOpen() then
        local f = fs.open(arquivo, "r")
        local conteudo = f.readAll()
        f.close()
        rednet.broadcast({tipo="backup", arquivo="planilha.csv", dados=conteudo})
        print("📤 Backup da planilha enviado via Rednet!")
    end
end
 
editarPlanilha()
enviarBackup()
 
