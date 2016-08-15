local sh = {}
sh.name = "Shaman Single Target"

function sh.init()
	print("SH init")
	
	rott_bind_key("Healing Wave")
	rott_bind_key("Flame Shock")
	rott_bind_key("Chain Lightning")
	rott_bind_key("Lightning Bolt")
	rott_bind_key("Flametongue Weapon")
	rott_bind_key("Water Shield")
	
		

end

function sh.rotation()
	
	if not UnitAffectingCombat("player") and not UnitAffectingCombat("pet") then 
		rott_resetFrames()
		return 
	end
	
	if UnitHealth("player") / UnitHealthMax("player") < 0.6 and rott_castSpellByName("Healing Wave") then
		--rott_castSpellByName("Drain Life")
		return
	end

	local hasWater = UnitBuff("player", "Water Shield")
	
	if not hasWater and rott_castSpellByName("Water Shield") then
		return
	end
	
	local hasEnchant = GetWeaponEnchantInfo()
	if not hasEnchant and rott_castSpellByName("Flametongue Weapon") then
		return
	end
	
	
	
	local hasFlame = UnitDebuff("target", "Flame Shock")
	local start, duration, canCastFlame = GetSpellCooldown("Flame Shock")
	
	if not hasFlame and (start + duration < GetTime()) and rott_castSpellByName("Flame Shock") then
		return
	end
	
	local start, duration, enabled = GetSpellCooldown("Chain Lightning")
	
	if (start + duration - 1 < GetTime()) and rott_castSpellByName("Chain Lightning") then
		return
	end
	
	if rott_castSpellByName("Lightning Bolt") then
		return
	end
	
	
	--if (UnitMana("player") / UnitManaMax("player") < 0.2) and (UnitHealth("player") / UnitHealthMax("player") > 0.6) and rott_castSpellByName("Life Tap") then
		--rott_castSpellByName("Drain Mana")
		--return
	--end
	
	--if not UnitAffectingCombat("pet") and rott_castSpellByName("Pet Attack") then
		--rott_castSpellByName("Pet Attack")
		--return
	--end
	
	--if UnitHealth("target") / UnitHealthMax("target") < 0.25 and rott_castSpellByName("Drain Soul") then
		--rott_castSpellByName("Drain Soul")
		--return
	--end
	
	local hasImmolate = UnitDebuff("target", "Immolate")
	local hasCorruption = UnitDebuff("target", "Corruption")
	local hasCurseOfAgony = UnitDebuff("target", "Curse of Agony")
	
	if not hasImmolate and rott_castSpellByName("Immolate") then
		--rott_castSpellByName("Immolate")
		return
	end

	
end

function sh.noncombat()

	--if not UnitBuff("player", "Demon Armor") then
		--rott_castSpellByName("Demon Armor")
	--end

	
end

function ShamanonLoad()
	print("SH on load")
	table.insert(rott_profileList, sh)

end