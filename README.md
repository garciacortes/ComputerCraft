COMO BAIXAR OS ARQUIVOS PARA QUALQUER COMPUTADOR

1 - ENTRE DENTRO DO EDITOR LUA DO COMPUTADOR, PARA ENTRAR SO DIGITAR LUA E APERTAR ENTER

2 - O LINK PARA BAIXAR VOCE ACESSA ELE ABRINDO O CODIGO E TRANSFORMANDO EM RAW AI SO COPIAR O LINK INTEIRO DA PAGINA, O BOTAO RAW FICA DO LADO DIREITO EM CIMA DA AREA DO CODIGO

3 - O NOME.LUA É O NOME DO ARQUIVO Q SERA SALVO NO COMPUTADOR, POR EXEMPLO SE DEIXAR nome.lua VOCE IRA ACESSAR O CODIGO USANDO EDIT nome.lua OU PARA RODAR DIGITANDO APENAS nome

4 - O CODIGO Q DEVE SER DIGITADO NO EDITOR LUA É O QUE ESTA ABAIXO, NO LINK E NOME.LUA VOCE DEVE MANTER AS ASPAS SO ALTERANDO O CONTEUDO INTERNO PARA O DESEJADO

CODIGO PARA BAIXAR O ARQUIVO: 

response = http.get("link").readAll(); file = fs.open("nome.lua", "w"); file.write(response); file.close()
