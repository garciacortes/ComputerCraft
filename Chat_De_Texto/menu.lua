local paintutils = paintutils
local largura, altura = term.getSize()
 
-- Cores
local bgMenu = colors.gray
local btnColor = colors.blue
local btnTextColor = colors.white
local bgFunc = colors.black
local borderColor = colors.white
 
-- Desenha botão com borda
local function desenharBotao(x, y, w, h, texto)
    paintutils.drawFilledBox(x, y, x + w, y + h, btnColor)
    paintutils.drawBox(x, y, x + w, y + h, borderColor)
    term.setCursorPos(x + 2, y + math.floor(h / 2))
    term.setTextColor(btnTextColor)
    term.write(texto)
    return { x1 = x, y1 = y, x2 = x + w, y2 = y + h }
end
 
-- Verifica se clique está dentro do botão
local function clicouBotao(x, y, btn)
    return x >= btn.x1 and x <= btn.x2 and y >= btn.y1 and y <= btn.y2
end
 
-- Desenha botão sair dentro das funções
local function desenharBotaoSair()
    local x, y, w, h = 1, altura - 4, largura - 2, 3
    paintutils.drawFilledBox(x, y, x + w, y + h, colors.red)
    paintutils.drawBox(x, y, x + w, y + h, colors.white)
    term.setCursorPos(x + 2, y + 1)
    term.setTextColor(colors.white)
    term.write("🔙 Voltar ao Menu (Clique aqui ou digite /sair)")
    return { x1 = x, y1 = y, x2 = x + w, y2 = y + h }
end
 
-- Menu principal
local function desenharMenu()
    term.setBackgroundColor(bgMenu)
    term.clear()
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
    print("=== W.E.T.S MENU PRINCIPAL ===")
 
    local botoes = {}
    botoes.chat = desenharBotao(5, 4, 20, 3, "💬 Chat")
    botoes.calc = desenharBotao(30, 4, 20, 3, "🧮 Calculadora")
    botoes.musica = desenharBotao(5, 9, 20, 3, "🎵 Música")
    botoes.anotacoes = desenharBotao(30, 9, 20, 3, "📝 Anotações")
    botoes.sair = desenharBotao(5, 14, 45, 3, "⚙️ Sair")
    return botoes
end
 
-- Função Chat (exemplo)
local function funcaoChat()
    term.setBackgroundColor(bgFunc)
    term.clear()
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
    print("=== Chat W.E.T.S ===")
    print("Digite '/sair' para voltar ao menu.\n")
 
    local btnSair = desenharBotaoSair()
 
    while true do
        term.setCursorPos(1, altura - 6)
        term.write("> ")
        local event, p1, x, y = os.pullEvent()
 
        if event == "char" or event == "key" then
            local texto = read()
            if texto == "/sair" then break end
            print("Você escreveu: " .. texto)
        elseif (event == "mouse_click" or event == "monitor_touch") and clicouBotao(x, y, btnSair) then
            break
        end
    end
end
 
-- Função Calculadora (exemplo)
local function funcaoCalculadora()
    term.setBackgroundColor(bgFunc)
    term.clear()
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
    print("=== Calculadora W.E.T.S ===")
    print("Digite '/sair' para voltar ao menu.\n")
 
    local btnSair = desenharBotaoSair()
 
    while true do
        term.setCursorPos(1, altura - 6)
        term.write("Calc> ")
        local event, p1, x, y = os.pullEvent()
 
        if event == "char" or event == "key" then
            local expr = read()
            if expr == "/sair" then break end
            local func, err = load("return " .. expr)
            if func then
                local ok, resultado = pcall(func)
                if ok then
                    print("Resultado: " .. resultado)
                else
                    print("Erro na expressão")
                end
            else
                print("Expressão inválida")
            end
        elseif (event == "mouse_click" or event == "monitor_touch") and clicouBotao(x, y, btnSair) then
            break
        end
    end
end
 
-- Loop principal do menu
local botoes = desenharMenu()
 
while true do
    local event, button, x, y = os.pullEvent()
 
    if event == "mouse_click" or event == "monitor_touch" then
        if clicouBotao(x, y, botoes.chat) then
            funcaoChat()
            botoes = desenharMenu()
        elseif clicouBotao(x, y, botoes.calc) then
            funcaoCalculadora()
            botoes = desenharMenu()
        elseif clicouBotao(x, y, botoes.musica) then
            term.clear()
            print("Função Música ainda não implementada.")
            sleep(2)
            botoes = desenharMenu()
        elseif clicouBotao(x, y, botoes.anotacoes) then
            term.clear()
            print("Função Anotações ainda não implementada.")
            sleep(2)
            botoes = desenharMenu()
        elseif clicouBotao(x, y, botoes.sair) then
            term.clear()
            print("Saindo...")
            sleep(1)
            term.clear()
            os.exit()
        end
    end
end
 
