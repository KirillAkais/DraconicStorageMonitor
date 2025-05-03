--[[This is a fix on https://pastebin.com/knPtJCjb, his code had a clock that called to a dead website. All I've done is remove that so that the code runs as intended, at some point I'll find a new site to call to for the clock but who knows when that will happen. ]] 
local mon = peripheral.find("monitor")
local cores = table.pack(peripheral.find("draconic_rf_storage"))
local tier = 0
local colorShield = colors.white
local colorCore = colors.white
local input, output = peripheral.find("flux_gate")
local limitTransfer = true
local currentControls = "main"
local page = 1
local putLimit = ""
local version = "0.8"
local energyStoredPrev = 0

if fs.exists("logs.cfg") then
else
	file = io.open("logs.cfg", "w")
	file:write("")
	file:close()
end

mon.setTextScale(1)

local function fileWrite(path, text)
	local file = io.open(path, "w")
	file:write(text)
	file:close()
end

local function fileWriteFromTable(path, t)
	local text = ""
	for _, line in pairs(t) do
		text = text..line.."\n"
	end
	fileWrite(path, text)
end

local function fileGetTable(path)
	if fs.exists(path) then
		local file = io.open(path, "r")
		local lines = {}
		local i = 1
		local line = file:read("*l")
		while line ~= nil do
			lines[i] = line
			line = file:read("*l")
			i = i +1
		end
		file:close()
		return lines
	end
	return {}
end

local function fileReplaceLine(path, n, text)
	local lines = fileGetTable(path)
	lines[n] = text
	fileWriteFromTable(path, lines)
end

local function fileAppend(path, text)
	local file = io.open(path, "a")
	file:write(text.."\n")
	file:close()
end

local function fileGetLength(path)
	local file = io.open(path, "r")
	local i = 0
	while file:read("*l") ~= nil do
		i = i +1
	end
	file:close()
	return i
end

local function fileGetLines(path, startN, endN)
	local lines = fileGetTable(path)
	local linesOut = {}
	local x = 1
	for i = startN, endN, 1 do
		linesOut[x] = lines[i]
		x = x + 1
	end
	return linesOut	
end

if peripheral.find("flux_gate") == nil then
	limitTransfer = false
else 
	limitTransfer = true
	detectInOutput()
end

local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function drawL1(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
end

local function drawL2(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawL3(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawL4(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
end

local function drawL5(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawL6(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawL7(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
end

local function drawL8(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawL9(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
end

local function drawL10(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
end

local function drawL11(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawL12(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawL13(xPos, yPos)
	mon.setCursorPos(xPos, yPos)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+2)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+3)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+4)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+5)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setBackgroundColor(colorShield)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+7)
	mon.setBackgroundColor(colorCore)
	mon.write(" ")
	mon.setCursorPos(xPos, yPos+8)
	mon.write(" ")
end

local function drawBox(xMin, xMax, yMin, yMax, title)
	mon.setBackgroundColor(colors.gray)
	for xPos = xMin, xMax, 1 do
		mon.setCursorPos(xPos, yMin)
		mon.write(" ")
	end
	for yPos = yMin, yMax, 1 do
		mon.setCursorPos(xMin, yPos)
		mon.write(" ")
		mon.setCursorPos(xMax, yPos)
		mon.write(" ")
	end
	for xPos = xMin, xMax, 1 do
		mon.setCursorPos(xPos, yMax)
		mon.write(" ")
	end
	mon.setCursorPos(xMin+2, yMin)
	mon.setBackgroundColor(colors.black)
	mon.write(" ")
	mon.write(title)
	mon.write(" ")
end	

local function drawDetails(xPos, yPos)
	energyStored = 0
	energyMax = 0
	
	for i = 0, #cores do
		energyStored = energyStored + cores[i].getEnergyStored()
		energyMax = energyMax + cores[i].getMaxEnergyStored()
	end
    
	energyTransfer = (energyStored - energyStoredPrev) / 20 
	energyStoredPrev = energyStored
	if limitTransfer == true then
		inputRate = input.getFlow()
		outputRate = output.getFlow()
	end
	mon.setCursorPos(xPos, yPos)
	if energyMax < 50000000 then
		tier = 1
	elseif energyMax < 300000000 then
		tier = 2
	elseif energyMax < 2000000000 then
		tier = 3 
	elseif energyMax < 10000000000 then
		tier = 4
	elseif energyMax < 50000000000 then
		tier = 5
	elseif energyMax < 400000000000 then
		tier = 6
	elseif energyMax < 3000000000000 then
		tier = 7
	else
		tier = 8
	end
	mon.write("Tier: ")
	mon.write(tier)
	mon.setCursorPos(xPos+7, yPos)
	mon.write("  ")
	mon.setCursorPos(xPos, yPos+1)
	mon.write("Stored: ")
	if energyStored < 1000 then
		mon.write(energyStored)
	elseif energyStored < 1000000 then
		mon.write(round((energyStored/1000),1))
		mon.write("k")
	elseif energyStored < 1000000000 then
		mon.write(round((energyStored/1000000),1))
		mon.write("M")
	elseif energyStored < 1000000000000 then
		mon.write(round((energyStored/1000000000),1))
		mon.write("G")
	elseif energyStored < 1000000000000000 then
		mon.write(round((energyStored/1000000000000),1))
		mon.write("T")
	elseif energyStored < 1000000000000000000 then
		mon.write(round((energyStored/1000000000000000),1))
		mon.write("P")
	elseif energyStored < 1000000000000000000000 then
		mon.write(round((energyStored/1000000000000000000),1))
		mon.write("E")
	end
	mon.write("RF")
	mon.write("/")
	if energyMax < 1000 then
		mon.write(energyMax)
	elseif energyMax < 1000000 then
		mon.write(round((energyMax/1000),1))
		mon.write("k")
	elseif energyMax < 1000000000 then
		mon.write(round((energyMax/1000000),1))
		mon.write("M")
	elseif energyMax < 1000000000000 then
		mon.write(round((energyMax/1000000000),1))
		mon.write("G")
	elseif energyMax < 1000000000000000 then
		mon.write(round((energyMax/1000000000000),1))
		mon.write("T")
	elseif energyMax < 1000000000000000000 then
		mon.write(round((energyMax/1000000000000000	),1))
		mon.write("P")
	elseif energyMax < 1000000000000000000000 then
		mon.write(round((energyMax/1000000000000000000),1))
		mon.write("E")
	end
	mon.write("RF")
	mon.setCursorPos(xPos, yPos+2)
	mon.setBackgroundColor(colors.lightGray)
	for l = 1, 20, 1 do
		mon.write(" ")
	end
	mon.setCursorPos(xPos, yPos+2)
	mon.setBackgroundColor(colors.lime)
	for l = 0, round((((energyStored/energyMax)*10)*2)-1,0), 1 do
		mon.write(" ")
	end
	mon.setCursorPos(xPos, yPos+3)
	mon.setBackgroundColor(colors.lightGray)
	for l = 1, 20, 1 do
		mon.write(" ")
	end
	mon.setCursorPos(xPos, yPos+3)
	mon.setBackgroundColor(colors.lime)
	for l = 0, round((((energyStored/energyMax)*10)*2)-1,0), 1 do
		mon.write(" ")
	end
	mon.setBackgroundColor(colors.black)
	mon.setCursorPos(xPos, yPos+4)
	mon.write("                      ")
	if string.len(tostring(round((energyStored/energyMax)*100))) == 1 then
		if round((energyStored/energyMax)*100) <= 10 then
			mon.setCursorPos(xPos, yPos+4)
			mon.write(round((energyStored/energyMax)*100))
			mon.setCursorPos(xPos+1, yPos+4)
			mon.write("% ")
		else
			mon.setCursorPos(xPos+round((((energyStored/energyMax)*100)-10)/5), yPos+4)
			mon.write(round((energyStored/energyMax)*100))
			mon.setCursorPos(xPos+round((((energyStored/energyMax)*100)-10)/5)+1, yPos+4)
			mon.write("% ")
		end
	elseif string.len(tostring(round((energyStored/energyMax)*100))) == 2 then
		if round((energyStored/energyMax)*100) <= 15 then
			mon.setCursorPos(xPos, yPos+4)
			mon.write(round((energyStored/energyMax)*100))
			mon.setCursorPos(xPos+2, yPos+4)
			mon.write("% ")
		else
			mon.setCursorPos(xPos+round((((energyStored/energyMax)*100)-15)/5), yPos+4)
			mon.write(round((energyStored/energyMax)*100))
			mon.setCursorPos(xPos+round((((energyStored/energyMax)*100)-15)/5)+2, yPos+4)
			mon.write("% ")
		end
	elseif string.len(tostring(round((energyStored/energyMax)*100))) == 3 then
		if round((energyStored/energyMax)*100) <= 20 then
			mon.setCursorPos(xPos, yPos+4)
			mon.write(round((energyStored/energyMax)*100))
			mon.setCursorPos(xPos+3, yPos+4)
			mon.write("% ")
		else
			mon.setCursorPos(xPos+round((((energyStored/energyMax)*100)-20)/5), yPos+4)
			mon.write(round((energyStored/energyMax)*100))
			mon.setCursorPos(xPos+round((((energyStored/energyMax)*100)-20)/5)+3, yPos+4)
			mon.write("% ")
		end
	end
	mon.setCursorPos(xPos, yPos+5)
	mon.write("InputMax:")
	mon.setCursorPos(xPos, yPos+6)
	mon.write("         ")
	mon.setCursorPos(xPos, yPos+6)
	mon.setTextColor(colors.lime)
	if limitTransfer == true then
		if inputRate == 0 then
			mon.setTextColor(colors.red)
		end
		if inputRate < 1000 then
			mon.write(inputRate)
		elseif inputRate < 1000000 then
			mon.write(round((inputRate/1000),1))
			mon.write("k")
		elseif inputRate < 1000000000 then
			mon.write(round((inputRate/1000000),1))
			mon.write("M")
		elseif inputRate < 1000000000000 then
			mon.write(round((inputRate/1000000000),1))
			mon.write("G")
		elseif inputRate < 1000000000000000 then
			mon.write(round((inputRate/1000000000000),1))
			mon.write("T")
		elseif inputRate < 1000000000000000000 then
			mon.write(round((inputRate/1000000000000000	),1))
			mon.write("P")
		elseif inputRate < 1000000000000000000000 then
			mon.write(round((inputRate/1000000000000000000),1))
			mon.write("E")
		end
		mon.write("RF")
	else
		mon.write("INFINITE")
	end
	mon.setTextColor(colors.white)
	mon.setCursorPos(xPos+12, yPos+5)
	mon.write("OutputMax:")
	mon.setCursorPos(xPos+12, yPos+6)
	mon.write("         ")
	mon.setTextColor(colors.red)
	mon.setCursorPos(xPos+12, yPos+6)
	if limitTransfer == true then
		if outputRate < 1000 then
			mon.write(outputRate)
		elseif outputRate < 1000000 then
			mon.write(round((outputRate/1000),1))
			mon.write("k")
		elseif outputRate < 1000000000 then
			mon.write(round((outputRate/1000000),1))
			mon.write("M")
		elseif outputRate < 1000000000000 then
			mon.write(round((outputRate/1000000000),1))
			mon.write("G")
		elseif outputRate < 1000000000000000 then
			mon.write(round((outputRate/1000000000000),1))
			mon.write("T")
		elseif outputRate < 1000000000000000000 then
			mon.write(round((outputRate/1000000000000000),1))
			mon.write("P")
		elseif outputRate < 1000000000000000000000 then
			mon.write(round((outputRate/1000000000000000000),1))
			mon.write("E")
		end
		mon.write("RF")
	else
		mon.write("INFINITE")
	end
	mon.setTextColor(colors.white)
	mon.setCursorPos(xPos, yPos+7)
	mon.write("Transfer:")
	mon.setCursorPos(xPos, yPos+8)
	if energyTransfer < 0 then
		mon.setTextColor(colors.red)
		if energyTransfer*(-1) < 1000 then
			mon.write(energyTransfer)
		elseif energyTransfer*(-1) < 1000000 then
			mon.write(round((energyTransfer/1000),1))
			mon.write("k")
		elseif energyTransfer*(-1) < 1000000000 then
			mon.write(round((energyTransfer/1000000),1))
			mon.write("M")
		elseif energyTransfer*(-1) < 1000000000000 then
			mon.write(round((energyTransfer/1000000000),1))
			mon.write("G")
		elseif energyTransfer*(-1) < 1000000000000000 then
			mon.write(round((energyTransfer/1000000000000),1))
			mon.write("T")
		elseif energyTransfer*(-1) < 1000000000000000000 then
			mon.write(round((energyTransfer/1000000000000000),1))
			mon.write("P")
		elseif energyTransfer*(-1) < 1000000000000000000000 then
			mon.write(round((energyTransfer/1000000000000000000),1))
			mon.write("E")
		end
	elseif energyTransfer == 0 then
		mon.setTextColor(colors.red)
		mon.write("0")
	else 
		mon.setTextColor(colors.lime)
		if energyTransfer < 1000 then
			mon.write(energyTransfer)
		elseif energyTransfer < 1000000 then
			mon.write(round((energyTransfer/1000),1))
			mon.write("k")
		elseif energyTransfer < 1000000000 then
			mon.write(round((energyTransfer/1000000),1))
			mon.write("M")
		elseif energyTransfer < 1000000000000 then
			mon.write(round((energyTransfer/1000000000),1))
			mon.write("G")
		elseif energyTransfer < 1000000000000000 then
			mon.write(round((energyTransfer/1000000000000),1))
			mon.write("T")
		elseif energyTransfer < 1000000000000000000 then
			mon.write(round((energyTransfer/1000000000000000),1))
			mon.write("P")
		elseif energyTransfer < 1000000000000000000000 then
			mon.write(round((energyTransfer/1000000000000000000),1))
			mon.write("E")
		end
	end
	mon.write("RF")
	mon.setTextColor(colors.white)
	mon.setCursorPos(xPos+12, yPos+7)
	mon.write("Limited:")
	mon.setCursorPos(xPos+12, yPos+8)
	if limitTransfer == true then
		mon.setTextColor(colors.lime)
		mon.write("On")
	else
		mon.setTextColor(colors.red)
		mon.write("Off")
	end
	mon.setTextColor(colors.white)
end

local function drawAll()	
	while true do
		mon.clear()
		versionText = "Version "..version.." by Game4Freak"
		verPos = 51 - string.len(versionText)
		mon.setCursorPos(verPos,26)
		mon.setTextColor(colors.gray)
		mon.setTextColor(colors.white)
		drawBox(2,20,4,16,"ENERGY CORE")
		drawBox(22,49,4,16,"DETAILS")
		yPos = 6
		xMin = 5
		for xPos = xMin, xMin+12, 1 do
			drawDetails(24,6)
			if tier <= 7 then
				colorShield = colors.lightBlue
				colorCore = colors.cyan
			else
				colorShield = colors.yellow
				colorCore = colors.orange
			end
			xPos1 = xPos
			if xPos1 >= xMin+13 then
				xPos1a = xPos1 - 13
				drawL1(xPos1a, yPos)
			else
				drawL1(xPos1, yPos)
			end
			xPos2 = xPos + 1
			if xPos2 >= xMin+13 then
				xPos2a = xPos2 - 13
				drawL2(xPos2a, yPos)
			else
				drawL2(xPos2, yPos)
			end
			xPos3 = xPos + 2
			if xPos3 >= xMin+13 then
				xPos3a = xPos3 - 13
				drawL3(xPos3a, yPos)
			else
				drawL3(xPos3, yPos)
			end
			xPos4 = xPos + 3
			if xPos4 >= xMin+13 then
				xPos4a = xPos4 - 13
				drawL4(xPos4a, yPos)
			else
				drawL4(xPos4, yPos)
			end
			xPos5 = xPos + 4
			if xPos5 >= xMin+13 then
				xPos5a = xPos5 - 13
				drawL5(xPos5a, yPos)
			else
				drawL5(xPos5, yPos)
			end
			xPos6 = xPos + 5
			if xPos6 >= xMin+13 then
				xPos6a = xPos6 - 13
				drawL6(xPos6a, yPos)
			else
				drawL6(xPos6, yPos)
			end
			xPos7 = xPos + 6
			if xPos7 >= xMin+13 then
				xPos7a = xPos7 - 13
				drawL7(xPos7a, yPos)
			else
				drawL7(xPos7, yPos)
			end
			xPos8 = xPos + 7
			if xPos8 >= xMin+13 then
				xPos8a = xPos8 - 13
				drawL8(xPos8a, yPos)
			else
				drawL8(xPos8, yPos)
			end
			xPos9 = xPos + 8
			if xPos9 >= xMin+13 then
				xPos9a = xPos9 - 13
				drawL9(xPos9a, yPos)
			else
				drawL9(xPos9, yPos)
			end
			xPos10 = xPos + 9
			if xPos10 >= xMin+13 then
				xPos10a = xPos10 - 13
				drawL10(xPos10a, yPos)
			else
				drawL10(xPos10, yPos)
			end
			xPos11 = xPos + 10
			if xPos11 >= xMin+13 then
				xPos11a = xPos11 - 13
				drawL11(xPos11a, yPos)
			else
				drawL11(xPos11, yPos)
			end
			xPos12 = xPos + 11
			if xPos12 >= xMin+13 then
				xPos12a = xPos12 - 13
				drawL12(xPos12a, yPos)
			else
				drawL12(xPos12, yPos)
			end
			xPos13 = xPos + 12
			if xPos13 >= xMin+13 then
				xPos13a = xPos13 - 13
				drawL13(xPos13a, yPos)
			else
				drawL13(xPos13, yPos)
			end
			mon.setBackgroundColor(colors.black)
			mon.setCursorPos(xMin, yPos)
			mon.write("   ")
			mon.setCursorPos(xMin+10, yPos)
			mon.write("   ")
			mon.setCursorPos(xMin, yPos+1)
			mon.write(" ")
			mon.setCursorPos(xMin+12, yPos+1)
			mon.write(" ")
			mon.setCursorPos(xMin, yPos+7)
			mon.write(" ")
			mon.setCursorPos(xMin+12, yPos+7)
			mon.write(" ")
			mon.setCursorPos(xMin, yPos+8)
			mon.write("   ")
			mon.setCursorPos(xMin+10, yPos+8)
			mon.write("   ")
			mon.setCursorPos(51 - 8,1)
			sleep(1)
		end
	end
end

while true do
	parallel.waitForAny(drawAll)
end