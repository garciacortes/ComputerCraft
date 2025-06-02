local monitor = peripheral.find("monitor")

if not monitor then
    print("Nenhum monitor encontrado!")
    return
end

term.redirect(monitor)
monitor.setTextScale(0.5)
monitor.setBackgroundColor(colors.black)
monitor.clear()

local image = paintutils.loadImage("meudesenho.nfp")
if image then
    paintutils.drawImage(image, 1, 1)
else
    print("Imagem 'meudesenho.nfp' não encontrada!")
end

term.redirect(term.native())
