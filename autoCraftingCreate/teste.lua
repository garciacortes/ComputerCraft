local chatBox = peripheral.wrap("right")

chatBox.sendMessage("Hello world!")

os.sleep(1)

chatBox.sendMessage("I am dave", "Dave")

os.sleep(1)

chatBox.sendMessage("\u{1F600}", nil, nil, nil, nil, true)

os.sleep(1)

chatBox.sendMessage("Welcome!", "Box", "<>", "&b", 30)

os.sleep(1)

chatBox.sendMessageToPlayer("Hello there.", "Garciacortes")
