-- musica.lua
local musicas = {}
local tocando = false
local loop = false
local musicaAtual = 1
local indicePlaylist = 1
 
local function carregarMusicas()
    if fs.exists("musicas.db") then
        local file = fs.open("musicas.db", "r")
        musicas = textutils.unserialize(file.readAll()) or {}
        file.close()
    end
end
 
local function salvarMusicas()
    local file = fs.open("musicas.db", "w")
    file.write(textutils.serialize(musicas))
    file.close()
end
 
local function detectarSpeakerBluetooth()
    for _, lado in ipairs({"left", "right", "top", "bottom", "front", "back"}) do
        if peripheral.isPresent(lado) and peripheral.getType(lado) == "speaker" then
            return true
        end
    end
    return false
end
 
local function printColor(text, color)
    term.setTextColor(color)
    print(text)
    term.setTextColor(colors.white)
end
 
local function adicionarMusica()
    term.clear()
    term.setCursorPos(1,1)
    printColor("🎵 Adicionar nova música", colors.lime)
    write("Nome da música: ")
    local nome = read()
    write("Link (um link simples ou vários links separados por vírgula para playlist): ")
    local link = read()
    table.insert(musicas, {nome = nome, link = link})
    salvarMusicas()
    printColor("✅ Música adicionada!", colors.green)
    sleep(1.5)
end
 
local function listarMusicas()
    term.clear()
    term.setCursorPos(1,1)
    printColor("🎶 Suas Músicas Salvas:", colors.cyan)
    for i, m in ipairs(musicas) do
        local isPlaylist = m.link:find(",") and true or false
        print(i..". "..m.nome .. (isPlaylist and " [Playlist]" or "") .. " - "..m.link)
    end
    print("\nPressione qualquer tecla para voltar...")
    os.pullEvent("key")
end
 
local function copiarLink(link)
    printColor("\n📋 Copie o link abaixo para ouvir no celular ou navegador:", colors.yellow)
    print(link)
 
    if link:find("spotify.com") then
        printColor("⚠️ Link Spotify detectado! Abra no app oficial para ouvir.", colors.magenta)
    elseif link:find("youtube.com") or link:find("youtu.be") then
        printColor("▶️ Link YouTube detectado! Pode abrir no navegador.", colors.green)
    end
end
 
local function obterLinks(musica)
    local links = {}
    for link in string.gmatch(musica.link, "([^,]+)") do
        table.insert(links, link:match("^%s*(.-)%s*$")) -- trim espaços
    end
    return links
end
 
local function tocarMusica(index)
    term.clear()
    term.setCursorPos(1,1)
    local musica = musicas[index]
    if not musica then
        printColor("❌ Música não encontrada!", colors.red)
        sleep(1.5)
        return
    end
 
    musicaAtual = index
    indicePlaylist = 1
    tocando = true
 
    local links = obterLinks(musica)
 
    local function mostrarStatus()
        term.clear()
        term.setCursorPos(1,1)
        printColor("▶️ Tocando: "..musica.nome, colors.green)
        if #links > 1 then
            printColor("Playlist: música "..indicePlaylist.." de "..#links, colors.orange)
            copiarLink(links[indicePlaylist])
        else
            copiarLink(links[1])
        end
 
        if detectarSpeakerBluetooth() then
            printColor("\n🔊 Speaker detectado via Bluetooth!", colors.orange)
        else
            printColor("\n❌ Nenhum Speaker encontrado via Bluetooth.", colors.red)
        end
    end
 
    mostrarStatus()
 
    local function proxima()
        indicePlaylist = indicePlaylist + 1
        if indicePlaylist > #links then
            if loop then
                indicePlaylist = 1
            else
                tocando = false
                printColor("\nFim da playlist.", colors.yellow)
                sleep(1.5)
            end
        end
        if tocando then
            mostrarStatus()
        end
    end
 
    while tocando do
        printColor("\n🎛️ Controles:", colors.blue)
        print("[1] ⏸️ Pausar")
        print("[2] ⏭️ Próxima")
        print("[3] 🔁 Loop: "..(loop and "Ativado" or "Desativado"))
        print("[4] 📋 Copiar Link")
        print("[5] ⏹️ Parar e Sair")
 
        write("\nEscolha: ")
        local opcao = read()
 
        if opcao == "1" then
            tocando = false
            printColor("⏸️ Música pausada.", colors.yellow)
            sleep(1.5)
        elseif opcao == "2" then
            proxima()
        elseif opcao == "3" then
            loop = not loop
            printColor("🔁 Loop agora está "..(loop and "Ativado" or "Desativado"), colors.orange)
        elseif opcao == "4" then
            local links = obterLinks(musica)
            copiarLink(links[indicePlaylist])
        elseif opcao == "5" then
            tocando = false
            printColor("⏹️ Parando...", colors.red)
            break
        else
            printColor("❌ Opção inválida!", colors.red)
        end
    end
end
 
local function selecionarMusica()
    term.clear()
    term.setCursorPos(1,1)
    printColor("▶️ Escolha a música para tocar:", colors.cyan)
    for i, m in ipairs(musicas) do
        local isPlaylist = m.link:find(",") and true or false
        print(i..". "..m.nome .. (isPlaylist and " [Playlist]" or ""))
    end
    write("\nNúmero da música: ")
    local opcao = tonumber(read())
    if opcao and musicas[opcao] then
        tocarMusica(opcao)
    else
        printColor("❌ Opção inválida!", colors.red)
        sleep(1.5)
    end
end
 
local function menuMusica()
    carregarMusicas()
    while true do
        term.clear()
        term.setCursorPos(1,1)
        printColor("🎵 Menu de Música W.E.T.S", colors.magenta)
        print("[1] ➕ Adicionar música")
        print("[2] 📃 Listar músicas")
        print("[3] ▶️ Tocar música")
        print("[4] ⏏️ Voltar ao Menu Principal")
        write("\nEscolha uma opção: ")
        local opcao = read()
 
        if opcao == "1" then
            adicionarMusica()
        elseif opcao == "2" then
            listarMusicas()
        elseif opcao == "3" then
            selecionarMusica()
        elseif opcao == "4" then
            break
        else
            printColor("❌ Opção inválida!", colors.red)
            sleep(1.5)
        end
    end
end
 
return {menu = menuMusica}
 
