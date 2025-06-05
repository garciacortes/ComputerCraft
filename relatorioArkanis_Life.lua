-- Tudo após os dois traços (--) sao comentários
-- Salve Nono 🙂 Sou estudante de Eng de Software, fiz esse codigo para voce ter um norte para realizar seu RP


local nomeArquivo = os.date("%d-%m-%y_%H-%M-%S") .. ".txt"       -- var: gerar o nome do arq data e hora no formato: 03-06-25_14-23-05.txt

local caminho = "monitor/" .. nomeArquivo       -- var: Para guarda o Caminho que sera Salvo (meu caso esta na pasta "monitor/" so mudar)

local file = fs.open(caminho, "w")              -- Abre o arquivo para escrita

                     -- Aqui, caso deseje pode altera para (1, 20) assim seria um D20
local dados = {
    pressao = math.random(900, 1100),
    temperatura = math.random(15, 40),
    radiacao = math.random(0, 10),
    campoEletromagnetico = math.random(10, 100),
    campoGravitacional = math.random(9, 10)
}

-- Bom aqui e bem simples! e voce pode alterar a forma de saida
file.writeLine("")
file.writeLine("Registro de Leitura:")
file.writeLine("")
file.writeLine("Pressao: " .. dados.pressao .. " Pa")
file.writeLine("Temperatura: " .. dados.temperatura .. " C")
file.writeLine("Radiacao: " .. dados.radiacao .. " mSv")
file.writeLine("Campo Eletromagnetico: " .. dados.campoEletromagnetico .. " uT")
file.writeLine("Campo Gravitacional: " .. dados.campoGravitacional .. " m/s")

file.close()

print("Arquivo foi salvo como: " .. caminho)
