local war = {}
war.name = "Warrior"


function war.init()
	print("Warrior init")

	rott_bind_key("Heroic Strike")
	rott_bind_key("Rend")
	rott_bind_key("Victory Rush")
	rott_bind_key("Battle Shout")

end

function war.rotation()
	
	--war.health = UnitHealth("player")
	--war.maxHealth = UnitHealthMax("player")
	
	if not UnitAffectingCombat("player") then 
		rott_resetFrames()
		--print("DK got out of combat")
		return
	end
	
	local rage = UnitPower("player" , SPELL_POWER_RAGE);
	
	--if UnitHealth("target") == nil or UnitHealth("target") < 1 then return end
	
	if rott_castSpellByName("Victory Rush") then return end
	
	if rage > 10 and not UnitBuff("player", "Battle Shout") and rott_castSpellByName("Battle Shout") then return end
	
	if rage > 10 and not UnitDebuff("target", "Rend") and rott_castSpellByName("Rend") then
		return
	end
	
	if rage > 15 and rott_castSpellByName("Heroic Strike") then
		return
	end
		
	
	
	
end

function war.noncombat()
	
end

function WarrioronLoad()
	print("Warrior on load")
	table.insert(rott_profileList, war)
	
end
