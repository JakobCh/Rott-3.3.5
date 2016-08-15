local rott_ButtonList = {}

local buttonPrefix = "Rott_Button_"

local rott_partyMembers = {}

keyList = {
{"1", {1,1,1}, {1,1,1}},
{"2", {1,1,1}, {1,1,0}},
{"3", {1,1,1}, {1,0,1}},
{"4", {1,1,1}, {0,1,1}},
{"5", {1,1,1}, {1,0,0}},
{"6", {1,1,1}, {0,0,1}},
{"7", {1,1,0}, {1,1,1}},
{"8", {1,1,0}, {1,1,0}},
{"9", {1,1,0}, {1,0,1}},
{"0", {1,1,0}, {0,1,1}},
{"a", {1,1,0}, {1,0,0}},
{"b", {1,1,0}, {0,0,1}},
{"c", {1,0,1}, {1,1,1}},
{"d", {1,0,1}, {1,1,0}},
{"e", {1,0,1}, {1,0,1}},
{"f", {1,0,1}, {0,1,1}},
{"g", {1,0,1}, {1,0,0}},
{"h", {1,0,1}, {0,0,1}},
} --the keys we have setup in the external program

local currentFreeKey = 1
local maxKeys = 18 --the amount of keys in the keyList
--local globalCooldown = 0

rott_lastSpellCasted = "" --why not?

rott_profileList = {}
--rott_currentProfile = 1

function rott_getFreeKey() --gets a free key from the keyList
	local le = tostring(currentFreeKey)
	if currentFreeKey == maxKeys + 1 then
		print("Rott.lua: All keys used up :(")
		return false
	end
	currentFreeKey = currentFreeKey + 1
	return le
	
end

function rott_bind_key(name, com) --bind a spell to a key ("Fireball") or a custom name with a macro ("Pet attack", "/petattack")
	local command, isMacro
	if com == nil then
		command = "/cast " .. name
		isMacro = false
	else
		command = com
		isMacro = true
	end
	
	key = rott_getFreeKey()
	
	btn = CreateFrame("Button", buttonPrefix .. name, nil, "SecureActionButtonTemplate")
	btn:RegisterForClicks("AnyUp")
	btn:SetAttribute("type", "macro")
	--btn:SetAttribute("macrotext", command);
	btn:SetAttribute("macrotext", command .. "\n" .. rott_frame_reset_command)
	
	table.insert(rott_ButtonList, {name, key, casttime, isMacro})

	if SetBindingClick("CTRL-" .. key, buttonPrefix .. name) == 1 then
		print("Set CTRL-" .. key .. " as binding for " .. name)
	else
		print("Binding failed")
	end
end

function rott_clickKey(key) --takes a string of a char: "1" "g" "b" ","
	for k, value in pairs(keyList) do --find the char in the key to rgb list
		if value[1] == key then
			rott_setFrameColor("Main", 255, 255, 255) --set the main frame to white to indicate that we have data to the external program
			rott_setFrameColor("Key", value[2][1], value[2][2], value[2][3]) --set the Key frame to the color that coresponds with the key
			rott_setFrameColor("Key2", value[3][1], value[3][2], value[3][3])
			--print("set frames to press " .. key)  --if shit doesnt work uncomment this
		end
	end
	
	
end

function rott_getSpellCastTime(name)
	local _, _, _, castTim = GetSpellInfo(name)
	return castTim --returns miliseconds
end

function rott_getSpellKey(name)
	for k, v in pairs(rott_ButtonList) do
		if v[1] == name then
			return v[2]
		end
	end
	return false
end

function rott_isSpellMacro(name)
	for k, v in pairs(rott_ButtonList) do
		if v[1] == name then
			return v[4]
		end
	end
	return false
end

function rott_castSpellByName(name)
	local macro = rott_isSpellMacro(name)
	local usable = IsUsableSpell(name)
	
	if macro then
		local n = rott_getSpellKey(name)
		rott_clickKey(n)
		rott_lastSpellCasted = name
		return true
	end
	
	if not usable or UnitCastingInfo("player") or UnitChannelInfo("player") then
		return false
	end
	
	
	--if globalCooldown > GetTime() then return false end
	
	--if globalCooldown <= GetTime() then
	--else
		--return 
	--end
	
	--if UnitCastingInfo("player") then return false end
	--if UnitChannelInfo("player") then return false end
	--if castTimeDone > GetTime() then return false end 
	--print("Trying to cast: " .. name)
	local n = rott_getSpellKey(name)
	rott_clickKey(n)
	rott_lastSpellCasted = name
	
	--globalCooldown = GetTime() + 1.5
	
	return true
end

function rott_clearKeybinds()
	rott_ButtonList = {}
	currentFreeKey = 1
end

function rott_listProfiles()
	for k, v in pairs(rott_profileList) do
		print(k .. ": " .. v.name)
	end
end

local rottFrame = CreateFrame("Frame", "rottFrame")
rottFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
rottFrame:RegisterEvent("COMBAT_LOG_EVENT")
rottFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
--rottFrame:RegisterEvent("CURSOR_UPDATE")
rottFrame:SetScript("OnEvent", rott_handleRotation)

function rott_handleRotation(self, event)
	if event == "PLAYER_REGEN_DISABLED" or event == "COMBAT_LOG_EVENT" then
		rott_profileList[rott_currentProfile].rotation()
	--elseif event == "CURSOR_UPDATE" then
		--rott_profileList[rott_currentProfile].noncombat()
	elseif event == "PLAYER_REGEN_ENABLED" then
		rott_resetFrames()
		rott_profileList[rott_currentProfile].noncombat()
	end
end



function rott_OnLoad()
	--print("rott_OnLoad")
	if rott_currentProfile == nil then
		rott_currentProfile = 1
	end
end

local frr = CreateFrame("Frame", "rottworldload")
frr:RegisterEvent("PLAYER_ENTERING_WORLD")
frr:SetScript("OnEvent", rott_OnWorldLoad)

function rott_OnWorldLoad()
	print("rott_OnWorldLoad")
	
	rott_profileList[rott_currentProfile].init()
	
end

SLASH_ROTT1 = "/rott"
function SlashCmdList.ROTT(msg, editbox)
	if msg == "key" then
		--rott_clickKey("1")
		print("keytest")
	elseif msg == "clear" or msg == "reset" then
		rott_resetFrames()
	elseif string.sub(msg, 1, 4) == "pro " then
		rott_currentProfile = tonumber(string.sub(msg, 5))
		rott_clearKeybinds()
		rott_profileList[rott_currentProfile].init()
	elseif msg == "profile" or msg == "pro" then
		rott_listProfiles()
	end
	
end