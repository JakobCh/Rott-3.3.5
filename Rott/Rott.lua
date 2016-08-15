local rott_ButtonList = {} --contains data about the keys we have bound
						   --like this: {name, key, casttime, isMacro}
						   --name: spellname or macro name (is used in rott_castSpellByName)
						   --key: the key we signal the external program to push to cast the spell/run the macro
						   --casttime: supposed to contain the cast time for the spell but is not implemented so its just nil
						   --isMacro: if its a macro or not duh

local buttonPrefix = "Rott_Button_" --the button prefix for the spellbinds 

local rott_partyMembers = {} --not implemented yet but will contain a table of the players (and pets maybe) in your party (support for raid groups?)

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
  --{key, rgb value for first square, rgb value for second square}

local maxKeys = 18 --the amount of keys in the keyList
local currentFreeKey = 1 --used to get witch index in the keyList we should use to bind a key to

rott_lastSpellCasted = "" --why not?
rott_profileList = {} -- contains all the class profiles, see the onload function in a class lua file 

function rott_getFreeKey() --gets a free key from the keyList
	--local le = tostring(currentFreeKey)
	local le = keyList[currentFreeKey][1] --get the first value from the currentFreeKey index ("4" or "e" or something)
	
	if currentFreeKey == maxKeys + 1 then
		print("Rott.lua: All keys used up :(")
		return false
	end
	currentFreeKey = currentFreeKey + 1
	return le
	
end

function rott_bind_key(name, com) --bind a spell to a key ("Fireball") or a custom name with a macro ("Pet attack", "/petattack")
	local command, isMacro, casttime
	if com == nil then
		command = "/cast " .. name
		isMacro = false
	else
		command = com
		isMacro = true
	end
	
	casttime = nil
	
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

function rott_getSpellKey(name) --gets the button that needs to be pressed for a spell/macro to be cast
	for k, v in pairs(rott_ButtonList) do --find the spell name / macro name in the registered button list
		if v[1] == name then
			return v[2] --return the second value (a string containing the key) check on the top of this file for more info
		end
	end
	return false --if we cant find the spell/macro return false
end

function rott_isSpellMacro(name) --the same as rott_getSpellKey but we return the 4th value instead (isMacro)
	for k, v in pairs(rott_ButtonList) do
		if v[1] == name then
			return v[4]
		end
	end
	return false
end

function rott_castSpellByName(name)
	local macro = rott_isSpellMacro(name)
	
	
	if macro then --if its a macro then just run it, we cant really check cooldowns and shit on it
		local n = rott_getSpellKey(name)
		rott_clickKey(n)
		rott_lastSpellCasted = name
		return true
	end
	
	local usable = IsUsableSpell(name) --build in blizzard function to check if you can cast the spell
									   --things it checks: 
									   --if you have learned the spell, if you have the mana and/or reagents
									   --if some reactive conditions have been meet (execute/finishing shot)
									   --things it does not check:
									   --cooldown and global cooldown
	
	if not usable or UnitCastingInfo("player") or UnitChannelInfo("player") then --if we cant cast it or we are currently casting something or we are channeling something
		return false --we cant cast the spell, return
	end
	
	--print("Trying to cast: " .. name)
	local n = rott_getSpellKey(name) --get the key we need to press to trigger the spell/macro
	rott_clickKey(n) --click the key ()
	rott_lastSpellCasted = name --guess what this does
	
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

local rottFrame = CreateFrame("Frame", "rottFrame") --register frame to handle events
rottFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
rottFrame:RegisterEvent("COMBAT_LOG_EVENT")
rottFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
--rottFrame:RegisterEvent("CURSOR_UPDATE")
rottFrame:SetScript("OnEvent", rott_handleRotation)

function rott_handleRotation(self, event)
	if event == "PLAYER_REGEN_DISABLED" or event == "COMBAT_LOG_EVENT" then --if we entered combat or the combat log updates
		rott_profileList[rott_currentProfile].rotation() --run the current profile rotation
	--elseif event == "CURSOR_UPDATE" then
		--rott_profileList[rott_currentProfile].noncombat()
	elseif event == "PLAYER_REGEN_ENABLED" then --if we exit combat
		rott_resetFrames() --reset the frames in the top left
		if not rott_profileList[rott_currentProfile].noncombat == nil then
			rott_profileList[rott_currentProfile].noncombat()
		end
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
	
	rott_profileList[rott_currentProfile].init() --init current class profile
	
end

SLASH_ROTT1 = "/rott"
function SlashCmdList.ROTT(msg, editbox)
	if msg == "clear" or msg == "reset" then
		rott_resetFrames()
	elseif string.sub(msg, 1, 4) == "pro " then
		rott_currentProfile = tonumber(string.sub(msg, 5)) --get the number after "pro "
		rott_clearKeybinds()
		rott_profileList[rott_currentProfile].init() --init current class profile
	elseif msg == "profile" or msg == "pro" then
		rott_listProfiles()
	end
	
end