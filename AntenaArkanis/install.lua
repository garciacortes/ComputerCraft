local files = {
  startup = "https://raw.githubusercontent.com/garciacortes/ComputerCraft/refs/heads/main/AntenaArkanis/startup.lua"
}

for name, url in pairs(files) do
  print("Baixando:", name)

  local res = http.get(url)
  if res then
    local file = fs.open(name .. ".lua", "w")

    while true do
      local chunk = res.read(512)
      if not chunk then break end
      file.write(chunk)
    end

    file.close()
    res.close()

    print("Ok: ", name)
  else
    print("Erro ao baixar:", name)
  end
end
