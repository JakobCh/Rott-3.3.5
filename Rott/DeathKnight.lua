local dk = {}
dk.name = "Blood Death Knight"
dk.runes = {}
dk.hasInit = false
dk.simpleGrind = false

function dk.updateRuneData()
	for i=1,6 do
		_, _, dk.runes[i] = GetRuneCooldown(i)
	end
end

function dk.isRuneReady(str)
	dk.updateRuneData()
	if str == "BLOOD" then
		if (dk.runes[1] or dk.runes[2]) then
			return true
		else
			return false
		end
	elseif str == "UNHOLY" then
		if (dk.runes[3] or dk.runes[4]) then
			return true
		else
			return false
		end
	elseif str == "FROST" then
		if (dk.runes[5] or dk.runes[6]) then
			return true
		else
			return false
		end
	end
	
	return false
end


function dk.init()
	print("DK init")
	
	if dk.hasInit == false then
		rott_bind_key("Death Strike")
		rott_bind_key("Heart Strike")
		rott_bind_key("Icy Touch")
		rott_bind_key("Plague Strike")
		rott_bind_key("Horn of Winter")
		--rott_bind_key("Rune Tap", "/cast Rune Tap")
		rott_bind_key("Death Coil")
		rott_bind_key("Blood Boil")
		--rott_bind_key("Pestilence")
		dk.hasInit = true
	end
end

function dk.rotation()
	
	--dk.health = UnitHealth("player")
	--dk.maxHealth = UnitHealthMax("player")
	
	if not UnitAffectingCombat("player") then 
		rott_resetFrames()
		--print("DK got out of combat")
		return
	end
	
	--if UnitHealth("target") == nil or UnitHealth("target") < 1 then return end
	
	if dk.simpleGrind then

		if dk.isRuneReady("BLOOD") and rott_castSpellByName("Blood Boil") then
			return
		end
		
		if dk.isRuneReady("UNHOLY") and dk.isRuneReady("FROST") and rott_castSpellByName("Death Strike") then
			return
		end
		
		local runicPower = UnitPower("player", 6) --6 is for runic power http://wowprogramming.com/docs/api_types#powerType
		
		if runicPower >= 40 and rott_castSpellByName("Death Coil") then
			--rott_castSpellByName("Death Coil")
			return
		end
		
		
	else
		--if (dk.health/dk.maxHealth < 0.3) then --if our hp is lower then 30%
			--if dk.isRuneReady("BLOOD") then
				--rott_castSpellByName("Rune Tap")
				--return
			--end
		--end
		
	
		local hasFrostFever, _, _, _, _, _, expireFrostFever = UnitDebuff("target", "Frost Fever")
		local hasBloodPlague, _, _, _, _, _, expireBloodPlague = UnitDebuff("target", "Blood Plague")
		
		if not hasFrostFever and rott_castSpellByName("Icy Touch") then
			--rott_castSpellByName("Icy Touch")
			--debuffStage = 2
			return
		elseif not hasBloodPlague and rott_castSpellByName("Plague Strike") then
			--rott_castSpellByName("Plague Strike")
			--debuffStage = 3
			return
		end
		
		--if hasFrostFever and hasBloodPlague and dk.multiTarget and rott_castSpellByName("Pestilence") then
			--debuffStage = 1
			--return
		--end
		
		if (dk.isRuneReady("UNHOLY") and dk.isRuneReady("FROST") and rott_castSpellByName("Death Strike")) then
			--rott_castSpellByName("Death Strike")
			return
		end
		
		if dk.isRuneReady("BLOOD") and rott_castSpellByName("Heart Strike") then
			--rott_castSpellByName("Heart Strike")
			return
		end
		
		local runicPower = UnitPower("player", 6) --6 is for runic power http://wowprogramming.com/docs/api_types#powerType
		
		if runicPower >= 40 then
			rott_castSpellByName("Death Coil")
			return
		end
		
		
		local hasHorn = GetSpellCooldown("Horn of Winter") --is 0 if the cooldown if of else its the GetTime() when the cooldown started
		
		if hasHorn == 0 then
			rott_castSpellByName("Horn of Winter")
			return
		end
	end
	
	
end

function dk.noncombat()
	
end

function DeathKnightonLoad()
	print("DK on load")
	table.insert(rott_profileList, dk)
	
	SLASH_ROTTDK1 = "/rottdk"
	SlashCmdList.ROTTDK = function(msg)
		if dk.simpleGrind then
			dk.simpleGrind = false
			print("Death Knight simple grind turned off")
		else
			dk.simpleGrind = true
			print("Death Knight simple grind turned on")
		end
	end
	
end
