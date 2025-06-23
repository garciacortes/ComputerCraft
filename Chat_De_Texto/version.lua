term.clear()
term.setCursorPos(1,1)
 
print("=======================================")
print("        SISTEMA W.E.T.S - VERSÃO 5.3")
print("=======================================")
print("Última atualização: 22/06/2025 - 17:18\n")
 
local function iaFala(texto)
    print("")
    print("╭" .. string.rep("─", #texto + 4) .. "╮")
    print("│ 🤖 " .. texto .. " │")
    print("╰" .. string.rep("─", #texto + 4) .. "╯")
    print("")
end
 
local function pausa(segundos)
    sleep(segundos)
    term.clear()
    term.setCursorPos(1,1)
end
 
-- Animação IA contagem versão
for i = 0, 100, 10 do
    term.clear()
    term.setCursorPos(1,1)
    print("Verificando atualizações... " .. i .. "%")
    sleep(0.2)
end
 
iaFala("Bem-vindo à versão 5.3 do W.E.T.S!")
 
pausa(1.5)
 
print("📌 Novidades da versão 5.3:")
sleep(1)
print("- 🎵 Música: Controle Bluetooth e playlist")
sleep(1)
print("- 📧 Email: Sistema interno com Wi-Fi")
sleep(1)
print("- 📝 Anotações e 📊 Planilha: Salvas na nuvem e impressão via modem")
sleep(1)
print("- 🌩️ Atualizador Master com backup automático")
sleep(1)
print("- 🖱️ Interface melhorada com mouse e touch")
sleep(1)
 
pausa(2)
 
iaFala("Dicas de uso:")
print("👉 Use o menu para navegar pelas funções.")
print("👉 Consulte o Suporte/Ajuda para mais informações.")
print("👉 Atualize sempre para novas funcionalidades.")
sleep(2)
 
print("\n=======================================")
print("Digite: menu   → Para abrir o menu principal")
print("=======================================")
 
