monitor = peripheral.find("monitor")
ct = colors.blue
ctn = colors.purple
cts = colors.orange

term.redirect(monitor)

monitor.setBackgroundColor(colors.black)
monitor.clear()

function emporio1()
    paintutils.drawFilledBox(13, 4, 14, 10, ct)
    paintutils.drawLine(14, 4, 19, 4, ct)
    paintutils.drawLine(14, 7, 18, 7, ct)
    paintutils.drawLine(14, 10, 19, 10, ct)
end

function emporio2()
    paintutils.drawFilledBox(21, 4, 22, 10, ct)
    paintutils.drawLine(23, 5, 24, 5, ct)
    paintutils.drawLine(25, 6, 26, 6, ct)
    paintutils.drawLine(27, 5, 28, 5, ct)
    paintutils.drawFilledBox(29, 4, 30, 10, ct)
end

function emporio3()
    paintutils.drawFilledBox(32, 4, 33, 10, ct)
    paintutils.drawLine(34, 4, 36, 4, ct)
    paintutils.drawFilledBox(36, 5, 37, 6, ct)
    paintutils.drawLine(34, 7, 36, 7, ct)
end

function emporio4()
    paintutils.drawFilledBox(39, 5, 40, 9, ct)
    paintutils.drawLine(41, 10, 45, 10, ct)
    paintutils.drawLine(41, 4, 45, 4, ct)
    paintutils.drawFilledBox(46, 5, 47, 9, ct)
end

function emporio5()
    paintutils.drawFilledBox(49, 4, 50, 10, ct)
    paintutils.drawLine(51, 4, 54, 4, ct)
    paintutils.drawFilledBox(55, 5, 56, 6, ct) 
    paintutils.drawLine(51, 7, 54, 7, ct)
    paintutils.drawLine(53, 8, 54, 8, ct)
    paintutils.drawLine(54, 9, 55, 9, ct)
    paintutils.drawLine(55, 10, 56, 10, ct)
end

function emporio6()
    paintutils.drawFilledBox(58, 4, 59, 10, ct)
end

function emporio7()
    paintutils.drawFilledBox(61, 5, 62, 9, ct)
    paintutils.drawLine(63, 10, 67, 10, ct)
    paintutils.drawLine(63, 4, 67, 4, ct)
    paintutils.drawFilledBox(68, 5, 69, 9, ct)
end

function nono1()
    paintutils.drawFilledBox(7, 15, 8, 21, ctn)
    paintutils.drawLine(9, 16, 9, 17, ctn)
    paintutils.drawLine(10, 17, 10, 18, ctn)
    paintutils.drawLine(11, 18, 11, 19, ctn)
    paintutils.drawLine(12, 19, 12, 20, ctn)
    paintutils.drawLine(13, 20, 13, 21, ctn)
    paintutils.drawFilledBox(13, 15, 14, 21, ctn)
end

function nono2()
    paintutils.drawFilledBox(16, 16, 17, 20, ctn)
    paintutils.drawLine(18, 15, 22, 15, ctn)
    paintutils.drawLine(18, 21, 22, 21, ctn)
    paintutils.drawFilledBox(23, 16, 24, 20, ctn)
end

function nono3()
    paintutils.drawFilledBox(26, 15, 27, 21, ctn)
    paintutils.drawLine(28, 16, 28, 17, ctn)
    paintutils.drawLine(29, 17, 29, 18, ctn)
    paintutils.drawLine(30, 18, 30, 19, ctn)
    paintutils.drawLine(31, 19, 31, 20, ctn)
    paintutils.drawLine(32, 20, 32, 21, ctn)
    paintutils.drawFilledBox(32, 15, 33, 21, ctn)
end

function nono4()
    paintutils.drawFilledBox(35, 16, 36, 20, ctn)
    paintutils.drawLine(37, 15, 41, 15, ctn)
    paintutils.drawLine(37, 21, 41, 21, ctn)
    paintutils.drawFilledBox(42, 16, 43, 20, ctn)
end

function nete1()
    paintutils.drawFilledBox(45, 15, 46, 21, cts)
    paintutils.drawLine(47, 16, 47, 17, cts)
    paintutils.drawLine(48, 17, 48, 18, cts)
    paintutils.drawLine(49, 18, 49, 19, cts)
    paintutils.drawLine(50, 19, 50, 20, cts)
    paintutils.drawLine(51, 20, 51, 21, cts)
    paintutils.drawFilledBox(51, 15, 52, 21, cts)
end

function nete2()
    paintutils.drawFilledBox(54, 15, 55, 21, cts)
    paintutils.drawLine(54, 15, 59, 15, cts)
    paintutils.drawLine(54, 18, 58, 18, cts)
    paintutils.drawLine(54, 21, 59, 21, cts)
end

function nete3()
    paintutils.drawLine(61, 15, 68, 15, cts)
    paintutils.drawFilledBox(64, 15, 65, 21, cts)
end

function nete4()
    paintutils.drawFilledBox(70, 15, 71, 21, cts)
    paintutils.drawLine(70, 15, 75, 15, cts)
    paintutils.drawLine(70, 18, 74, 18, cts)
    paintutils.drawLine(70, 21, 75, 21, cts)
end


-- chama todas as letras
emporio1()
emporio2()
emporio3()
emporio4()
emporio5()
emporio6()
emporio7()
nono1()
nono2()
nono3()
nono4()
nete1()
nete2()
nete3()  
nete4()
