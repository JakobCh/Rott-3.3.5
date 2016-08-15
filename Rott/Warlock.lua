local wl = {}
wl.name = "Warlock Single Target"

function wl.init()
	print("WL init")
	
	rott_bind_key("Immolate", "/cast Immolate")
	rott_bind_key("Corruption", "/cast Corruption")
	rott_bind_key("Shadow Bolt", "/cast Shadow Bolt")
	rott_bind_key("Drain Soul", "/cast Drain Soul")
	rott_bind_key("Drain Life", "/cast Drain Life")
	rott_bind_key("Life Tap")
	rott_bind_key("Drain Mana", "/cast Drain Mana")
	rott_bind_key("Pet Attack", "/petattack")
	rott_bind_key("Curse of Agony")
		

end

function wl.rotation()
	
	if not UnitAffectingCombat("player") and not UnitAffectingCombat("pet") then 
		rott_resetFrames()
		return 
	end
	
	--if UnitHealth("player") / UnitHealthMax("player") < 0.6 and rott_castSpellByName("Drain Life") then
		--rott_castSpellByName("Drain Life")
		--return
	--end

	
	if (UnitMana("player") / UnitManaMax("player") < 0.2) and (UnitHealth("player") / UnitHealthMax("player") > 0.6) and rott_castSpellByName("Life Tap") then
		--rott_castSpellByName("Drain Mana")
		return
	end
	
	if not UnitAffectingCombat("pet") and rott_castSpellByName("Pet Attack") then
		--rott_castSpellByName("Pet Attack")
		return
	end
	
	if UnitHealth("target") / UnitHealthMax("target") < 0.25 and rott_castSpellByName("Drain Soul") then
		--rott_castSpellByName("Drain Soul")
		return
	end
	
	local hasImmolate = UnitDebuff("target", "Immolate")
	local hasCorruption = UnitDebuff("target", "Corruption")
	local hasCurseOfAgony = UnitDebuff("target", "Curse of Agony")
	
	if not hasImmolate and rott_castSpellByName("Immolate") then
		--rott_castSpellByName("Immolate")
		return
	end
	if not hasCorruption and rott_castSpellByName("Corruption") then
		--rott_castSpellByName("Corruption")
		return
	end
	if not hasCurseOfAgony and rott_castSpellByName("Curse of Agony") then
		return
	end
	
	
	if rott_castSpellByName("Shadow Bolt") then
		return
	end
	
	rott_castSpellByName("Pet Attack")
	
end

function wl.noncombat()

	--if not UnitBuff("player", "Demon Armor") then
		--rott_castSpellByName("Demon Armor")
	--end

	
end

function WarlockonLoad()
	print("WL on load")
	table.insert(rott_profileList, wl)

end