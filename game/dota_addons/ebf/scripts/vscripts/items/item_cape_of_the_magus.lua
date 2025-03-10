item_cape_of_the_magus = class({})

function item_cape_of_the_magus:GetIntrinsicModifierName()
	return "modifier_item_cape_of_the_magus_passive"
end

item_cape_of_the_magus_2 = class(item_cape_of_the_magus)
item_cape_of_the_magus_3 = class(item_cape_of_the_magus_2)
item_cape_of_the_magus_4 = class(item_cape_of_the_magus_2)
item_cape_of_the_magus_5 = class(item_cape_of_the_magus_2)

modifier_item_cape_of_the_magus_passive = class({})
LinkLuaModifier( "modifier_item_cape_of_the_magus_passive", "items/item_cape_of_the_magus.lua" ,LUA_MODIFIER_MOTION_NONE )

function modifier_item_cape_of_the_magus_passive:OnCreated()
	self:OnRefresh()
end

function modifier_item_cape_of_the_magus_passive:OnRefresh()
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor("mana_regen_multiplier")
	self.spell_lifesteal_amp = self:GetAbility():GetSpecialValueFor("spell_lifesteal_amp")
	
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_cape_of_the_magus_passive:DeclareFunctions(params)
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
    }
    return funcs
end

function modifier_item_cape_of_the_magus_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_cape_of_the_magus_passive:GetModifierMPRegenAmplify_Percentage()
	return self.mana_regen_multiplier
end

function modifier_item_cape_of_the_magus_passive:GetModifierSpellLifestealRegenAmplify_Percentage()
	return self.spell_lifesteal_amp
end

function modifier_item_cape_of_the_magus_passive:IsAura()
	return true
end

function modifier_item_cape_of_the_magus_passive:GetModifierAura()
	return "modifier_item_cape_of_the_magus_passive_aura"
end

function modifier_item_cape_of_the_magus_passive:GetAuraRadius()
	return self.aura_radius
end

function modifier_item_cape_of_the_magus_passive:GetAuraDuration()
	return 0.5
end

function modifier_item_cape_of_the_magus_passive:GetAuraSearchTeam()    
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_cape_of_the_magus_passive:GetAuraSearchType()    
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

function modifier_item_cape_of_the_magus_passive:GetAuraSearchFlags()    
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_cape_of_the_magus_passive:IsHidden()
	return true
end

function modifier_item_cape_of_the_magus_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

LinkLuaModifier( "modifier_item_cape_of_the_magus_passive_aura", "items/item_cape_of_the_magus.lua" ,LUA_MODIFIER_MOTION_NONE )
modifier_item_cape_of_the_magus_passive_aura = class({})

function modifier_item_cape_of_the_magus_passive_aura:OnCreated()
	self:OnRefresh( )
end

function modifier_item_cape_of_the_magus_passive_aura:OnRefresh()
	self.aura_spell_amp = self:GetAbility():GetSpecialValueFor("aura_spell_amp")
	self.aura_bonus_magical_armor = self:GetAbility():GetSpecialValueFor("aura_bonus_magical_armor")
	self.aura_spell_lifesteal = self:GetAbility():GetSpecialValueFor("aura_spell_lifesteal") / 100
end

function modifier_item_cape_of_the_magus_passive_aura:DeclareFunctions(params)
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_item_cape_of_the_magus_passive_aura:GetModifierSpellAmplify_Percentage()
	return self.aura_spell_amp
end

function modifier_item_cape_of_the_magus_passive_aura:GetModifierMagicalResistanceBonus()
	return self.aura_bonus_magical_armor
end

function modifier_item_cape_of_the_magus_passive_aura:GetModifierConstantHealthRegen()
	return self.hp_regen_aura
end

function modifier_item_cape_of_the_magus_passive_aura:GetModifierPhysicalArmorBonus()
	return self.armor_aura
end

function modifier_item_cape_of_the_magus_passive_aura:OnTooltip()
	return self.aura_spell_lifesteal * 100
end

function modifier_item_cape_of_the_magus_passive_aura:OnTakeDamage(params)
	print( params.attacker == self:GetParent(), params.inflictor )
	if params.attacker == self:GetParent() and params.inflictor 
	and not ( HasBit( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) 
			  or HasBit( params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) 
			  or HasBit( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ) 
	then
		local spell_lifesteal = self.aura_spell_lifesteal
		print("gucci", spell_lifesteal, params.damage)
		if not params.unit:IsConsideredHero() then
			spell_lifesteal =  spell_lifesteal / 5
		end
		
		local EHPMult = self:GetParent().EHP_MULT or 1
		local lifesteal = params.damage * spell_lifesteal * math.max( 1, EHPMult )
		
		self.lifeToGive = (self.lifeToGive or 0) + lifesteal
		if self.lifeToGive > 1 then
			local preHP = params.attacker:GetHealth()
			params.attacker:HealWithParams( lifesteal, params.inflictor, false, true, self, true )
			self.lifeToGive = self.lifeToGive - math.floor(self.lifeToGive)
			local postHP = params.attacker:GetHealth()
		
			if postHP - preHP ~= 0 then
				ParticleManager:FireParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_POINT_FOLLOW, params.attacker )
			end
		end
	end
end