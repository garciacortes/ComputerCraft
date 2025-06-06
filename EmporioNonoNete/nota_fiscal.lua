function getID()
    local caminho = "emporio/config.lua"
    
    local file = fs.open(caminho, "r")
    
    if file then
        local content = textutils.unserialise(file.readAll())
        local ID = content.id
        local file = fs.open(caminho, "w")
        newID = ID + 1
        file.writeLine("{id = "..newID.."}")
        file.close()
        return ID
    else
        local file = fs.open(caminho, "w")
        file.writeLine("{id = 1}")
        file.close()
        return getID()
    end
end

io.write("Nome do Cliente: ")
local nomeCliente = io.read()

local data = os.date("%Y-%m-%d")
local id = string.format("%06d", getID())
local nomeArquivo = "NF-"..id.."-"..data.."-"..nomeCliente

local caminho = "emporio/notasFiscais/ ".. nomeArquivo
local file = fs.open(caminho, "w")

file.writeLine("------ NOTA FISCAL ------")
file.writeLine("ID Nota Fiscal: " .. id)
file.writeLine("Emissao: "..os.date("%d/%m/%Y"))
file.writeLine("Hora: "..os.date("%H:%M"))
file.writeLine("")
file.writeLine("Emitente: NonoNete")
file.writeLine("")
file.writeLine("Destinatario: "..nomeCliente)
file.writeLine("")
file.writeLine("Itens:")
file.writeLine("1) 16x Oak")
file.writeLine("2) 45x Ender Pearl")
file.writeLine("3) 25x Quartzo")
file.writeLine("4) 55x Emerald")
file.writeLine("5) 30x Glowstone")
file.writeLine("6) 10x Bread")
file.writeLine("7) 17x Redstone")
file.writeLine("8) 64x Iron_Ingot")
file.writeLine("9) 28x Gold_Ingot")
file.writeLine("")
file.writeLine("Total: 350")

file.close()

print("Arquivo foi salvo em: ".. caminho)
