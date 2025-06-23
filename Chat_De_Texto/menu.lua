-- menu.lua - W.E.T.S com Layout Windows + Suporte TouchScreen/Mouse
 
local versao = require("versao")
local largura, altura = term.getSize()
local paintutils = paintutils
 
-- Cores
local fundo = colors.lightBlue
local borda = colors.blue
local tituloCor = colors.white
local textoCor = colors.black
local caixaCor = colors.white
local caixaTextoCor = colors.black
local selecaoCor = colors.lime
 
-- Opções do Menu
local opcoes = {
    {texto="Abrir Chat", arquivo="chat_client.lua"},
    {texto="Lançar D20", arquivo="d20.lua"},
    {texto="Decodificar Binário", arquivo="decod_bin.lua"},
    {texto="Decodificar Morse", arquivo="decod_morse.lua"},
    {texto="Atualizar Sistema", arquivo="atualizador_master.lua"},
    {texto="Música", arquivo="musica.lua"},
    {texto="Calculadora", arquivo="calculadora.lua"},
    {texto="Anotações", arquivo="anotacoes.lua"},
    {texto="Email", arquivo="email.lua"},
    {texto="Sair", arquivo=nil},
}
 
-- Tabela para registrar área clicável de cada botão
local botoes = {}
 
-- Função: Desenhar Janela
local function desenharJanela(x, y, w, h, tituloTexto)
    paintutils.drawFilledBox(x, y, x + w - 1, y + h - 1, borda)
    paintutils.drawFilledBox(x + 1, y + 1, x + w - 2, y + h - 2, caixaCor)
    term.setTextColor(tituloCor)
    term.setBackgroundColor(borda)
    term.setCursorPos(x + 2, y)
    term.write(" "..tituloTexto.." ")
end
 
-- Função: Desenhar Botões
local function desenharBotoes()
    botoes = {} -- Limpar anteriores
    local startY = 4
    for i, opcao in ipairs(opcoes) do
        local btnX = 4
        local btnY = startY + (i - 1) * 2
        local btnW = largura - 7
        local btnH = 1
 
        paintutils.drawFilledBox(btnX, btnY, btnX + btnW, btnY + btnH, colors.lightGray)
        term.setTextColor(caixaTextoCor)
        term.setBackgroundColor(colors.lightGray)
        term.setCursorPos(btnX + 2, btnY)
        term.write(opcao.texto)
 
        -- Registrar área clicável
        table.insert(botoes, {
            x1 = btnX, y1 = btnY,
            x2 = btnX + btnW, y2 = btnY + btnH,
            arquivo = opcao.arquivo,
            nome = opcao.texto
        })
    end
end
 
-- Tela Inicial
term.setBackgroundColor(fundo)
term.clear()
 
desenharJanela(2, 2, largura - 3, altura - 3, "🌩️ W.E.T.S Menu v" .. versao)
desenharBotoes()
 
-- Rodapé
term.setTextColor(tituloCor)
term.setBackgroundColor(borda)
term.setCursorPos(3, altura - 1)
term.write(" Toque ou clique em uma opção ")
 
-- Loop de Eventos (Touch/Click)
while true do
    local evento, botao, x, y = os.pullEvent()
 
    if evento == "mouse_click" or evento == "monitor_touch" then
        for _, btn in ipairs(botoes) do
            if x >= btn.x1 and x <= btn.x2 and y >= btn.y1 and y <= btn.y2 then
                term.setBackgroundColor(colors.black)
                term.clear()
                term.setCursorPos(1,1)
 
                if btn.arquivo then
                    print("Abrindo: " .. btn.nome .. "...")
                    sleep(0.5)
                    shell.run(btn.arquivo)
                    os.reboot() -- Volta ao menu após o programa
                else
                    print("Saindo...")
                    sleep(1)
                    os.shutdown()
                end
            end
        end
    end
end
 
