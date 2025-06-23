-- calculadora.lua - Calculadora Avançada W.E.T.S
 
term.clear()
term.setCursorPos(1,1)
print("🧮 Calculadora Avançada - W.E.T.S")
print("====================================\n")
 
local function pause()
    print("\nPressione qualquer tecla para voltar ao menu...")
    os.pullEvent("key")
end
 
local function operacoesBasicas()
    print("\n📌 Operações Básicas (+ - * /)")
    write("Digite o primeiro número: ")
    local a = tonumber(read())
    write("Operação (+ - * /): ")
    local op = read()
    write("Digite o segundo número: ")
    local b = tonumber(read())
 
    local resultado
    if op == "+" then
        resultado = a + b
    elseif op == "-" then
        resultado = a - b
    elseif op == "*" then
        resultado = a * b
    elseif op == "/" then
        if b == 0 then resultado = "Erro: Divisão por zero!" else resultado = a / b end
    else
        resultado = "Operação inválida!"
    end
 
    print("Resultado: " .. tostring(resultado))
    pause()
end
 
local function fisica()
    print("\n📐 Fórmulas de Física:")
    print("1 - Velocidade (V = ΔS/ΔT)")
    print("2 - Força (F = m * a)")
    print("3 - Energia Cinética (Ec = 0.5 * m * v^2)")
    write("Escolha: ")
    local op = read()
 
    if op == "1" then
        write("ΔS (distância em metros): ")
        local ds = tonumber(read())
        write("ΔT (tempo em segundos): ")
        local dt = tonumber(read())
        print("Velocidade: " .. (ds / dt) .. " m/s")
    elseif op == "2" then
        write("Massa (kg): ")
        local m = tonumber(read())
        write("Aceleração (m/s²): ")
        local a = tonumber(read())
        print("Força: " .. (m * a) .. " N")
    elseif op == "3" then
        write("Massa (kg): ")
        local m = tonumber(read())
        write("Velocidade (m/s): ")
        local v = tonumber(read())
        print("Energia Cinética: " .. (0.5 * m * v^2) .. " J")
    else
        print("Opção inválida.")
    end
    pause()
end
 
local function eletrica()
    print("\n🔋 Cálculos Elétricos:")
    print("1 - Lei de Ohm (V = R * I)")
    print("2 - Potência (P = V * I)")
    write("Escolha: ")
    local op = read()
 
    if op == "1" then
        write("Resistência (Ohms): ")
        local r = tonumber(read())
        write("Corrente (Amperes): ")
        local i = tonumber(read())
        print("Tensão: " .. (r * i) .. " Volts")
    elseif op == "2" then
        write("Tensão (Volts): ")
        local v = tonumber(read())
        write("Corrente (Amperes): ")
        local i = tonumber(read())
        print("Potência: " .. (v * i) .. " Watts")
    else
        print("Opção inválida.")
    end
    pause()
end
 
local function geometria()
    print("\n📏 Geometria:")
    print("1 - Área do Círculo (π * r²)")
    print("2 - Área do Triângulo (b * h / 2)")
    write("Escolha: ")
    local op = read()
 
    if op == "1" then
        write("Raio (m): ")
        local r = tonumber(read())
        print("Área: " .. (math.pi * r^2) .. " m²")
    elseif op == "2" then
        write("Base (m): ")
        local b = tonumber(read())
        write("Altura (m): ")
        local h = tonumber(read())
        print("Área: " .. ((b * h) / 2) .. " m²")
    else
        print("Opção inválida.")
    end
    pause()
end
 
local function conversoes()
    print("\n🌡️ Conversões:")
    print("1 - Celsius para Fahrenheit")
    print("2 - Fahrenheit para Celsius")
    write("Escolha: ")
    local op = read()
 
    if op == "1" then
        write("Temperatura em Celsius: ")
        local c = tonumber(read())
        print("Resultado: " .. (c * 9/5 + 32) .. " °F")
    elseif op == "2" then
        write("Temperatura em Fahrenheit: ")
        local f = tonumber(read())
        print("Resultado: " .. ((f - 32) * 5/9) .. " °C")
    else
        print("Opção inválida.")
    end
    pause()
end
 
while true do
    term.clear()
    term.setCursorPos(1,1)
    print("🧮 Calculadora Avançada - W.E.T.S")
    print("====================================")
    print("1 - Operações Básicas")
    print("2 - Física")
    print("3 - Elétrica")
    print("4 - Geometria")
    print("5 - Conversões")
    print("6 - Sair")
    write("\nEscolha: ")
    local escolha = read()
 
    if escolha == "1" then
        operacoesBasicas()
    elseif escolha == "2" then
        fisica()
    elseif escolha == "3" then
        eletrica()
    elseif escolha == "4" then
        geometria()
    elseif escolha == "5" then
        conversoes()
    elseif escolha == "6" then
        print("\nEncerrando Calculadora...")
        sleep(1)
        break
    else
        print("\nOpção inválida!")
        sleep(1)
    end
end
 
