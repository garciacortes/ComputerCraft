-- decodificadores.lua - W.E.T.S - Binário e Morse
 
local morseTable = {
    [".-"] = "A", ["-..."] = "B", ["-.-."] = "C", ["-.."] = "D", ["."] = "E",
    ["..-."] = "F", ["--."] = "G", ["...."] = "H", [".."] = "I", [".---"] = "J",
    ["-.-"] = "K", [".-.."] = "L", ["--"] = "M", ["-."] = "N", ["---"] = "O",
    [".--."] = "P", ["--.-"] = "Q", [".-."] = "R", ["..."] = "S", ["-"] = "T",
    ["..-"] = "U", ["...-"] = "V", [".--"] = "W", ["-..-"] = "X", ["-.--"] = "Y",
    ["--.."] = "Z", ["-----"] = "0", [".----"] = "1", ["..---"] = "2", ["...--"] = "3",
    ["....-"] = "4", ["....."] = "5", ["-...."] = "6", ["--..."] = "7", ["---.."] = "8",
    ["----."] = "9"
}
 
local function binarioParaDecimal(bin)
    local decimal = 0
    local tamanho = #bin
    for i = 1, tamanho do
        if bin:sub(i,i) == "1" then
            decimal = decimal + 2 ^ (tamanho - i)
        end
    end
    return decimal
end
 
local function binarioParaTexto(binarioString)
    local resultado = ""
    for bin in string.gmatch(binarioString, "%S+") do
        local decimal = binarioParaDecimal(bin)
        resultado = resultado .. string.char(decimal)
    end
    return resultado
end
 
local function morseParaTexto(morse)
    local resultado = ""
    for palavra in string.gmatch(morse, "[^%s]+") do
        resultado = resultado .. (morseTable[palavra] or "?")
    end
    return resultado
end
 
-- Menu
term.clear()
term.setCursorPos(1,1)
print("=== DECODIFICADORES W.E.T.S ===")
print("1 - Binário → Decimal")
print("2 - Binário → Texto (ASCII)")
print("3 - Morse → Texto")
print("4 - Sair")
print("")
write("Escolha: ")
local opcao = read()
 
if opcao == "1" then
    write("\nDigite o número binário: ")
    local bin = read()
    print("\nDecimal: " .. binarioParaDecimal(bin))
 
elseif opcao == "2" then
    write("\nDigite o binário (8 bits por letra, separados por espaço): ")
    local binText = read()
    print("\nTexto: " .. binarioParaTexto(binText))
 
elseif opcao == "3" then
    write("\nDigite o código Morse (separado por espaços): ")
    local morse = read()
    print("\nTexto: " .. morseParaTexto(morse))
 
else
    print("\nSaindo...")
end
 
print("\nPressione qualquer tecla para voltar.")
os.pullEvent("key")
 
