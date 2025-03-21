riki_tricks_of_the_trade = class({})

function riki_tricks_of_the_trade:IsStealable()
    return true
end

function riki_tricks_of_the_trade:IsHiddenWhenStolen()
    return false
end

function riki_tricks_of_the_trade:GetChannelTime()
	return self:GetSpecialValueFor("duration")
end

function riki_tricks_of_the_trade:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function riki_tricks_of_the_trade:GetBehavior()
	local behavior = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED
	if self:GetSpecialValueFor("dispel") == 1 then
		behavior = behavior + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	end
	return behavior
end
function riki_tricks_of_the_trade:OnSpellStart()
    local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	
	local blinkData = {FX = false}
	caster:Blink( position, blinkData )

    caster:AddNewModifier(caster, self, "modifier_riki_tricks_of_the_trade_handler", {Duration = self:GetSpecialValueFor("duration")})
	
    EmitSoundOn("Hero_Riki.TricksOfTheTrade.Cast", caster)
    local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks_cast.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(nfx)
	
	if self:GetSpecialValueFor("dispel") == 1 then
		caster:Dispel( caster, true )
	end
end

function riki_tricks_of_the_trade:OnChannelFinish( bInterrupt )
	self:GetCaster():RemoveModifierByName("modifier_riki_tricks_of_the_trade_handler")
end

modifier_riki_tricks_of_the_trade_handler = class({})
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_handler", "heroes/hero_riki/riki_tricks_of_the_trade.lua" ,LUA_MODIFIER_MOTION_NONE )
function modifier_riki_tricks_of_the_trade_handler:OnCreated(table)
	local caster = self:GetCaster()
		
	self.radius = self:GetSpecialValueFor("radius")
	self.attack_rate = self:GetSpecialValueFor("attack_rate")
	self.agility_pct = caster:GetAgility() * self:GetSpecialValueFor("agility_pct") / 100
	
    if IsServer() then
		local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(nfx, 1, Vector(self.radius, self.radius, self.radius))
		EmitSoundOn("Hero_Riki.TricksOfTheTrade", caster)
		
		self:AddEffect( nfx )
		
		self:OnIntervalThink(true)
        self:StartIntervalThink( self.attack_rate )
		caster:AddNoDraw()
		
		if caster:HasScepter() then
			self.blink_strike = caster:FindAbilityByName("riki_blink_strike")
		end
    end
end

function modifier_riki_tricks_of_the_trade_handler:OnIntervalThink(bNoFX)
	local caster = self:GetCaster()
	
    local enemies = caster:FindEnemyUnitsInRadius( caster:GetAbsOrigin(), self.radius )
    for _,enemy in pairs(enemies) do
        caster:PerformGenericAttack(enemy, true, true)
		if IsEntitySafe( self.blink_strike ) then
			caster:SetCursorCastTarget( enemy )
			self.blink_strike:OnSpellStart(true)
		end
    end
	if not bNoFX then
		ParticleManager:FireParticle("particles/units/heroes/hero_riki/riki_tricks_backstab_ring.vpcf", PATTACH_WORLDORIGIN, nil, {[0] = caster:GetAbsOrigin(), [1] = Vector(self.radius,self.radius,self.radius)})
	end
end

function modifier_riki_tricks_of_the_trade_handler:OnRemoved()
    if IsServer() then
        StopSoundOn("Hero_Riki.TricksOfTheTrade.Cast", self:GetCaster())
        StopSoundOn("Hero_Riki.TricksOfTheTrade", self:GetCaster())

		self:GetCaster():RemoveNoDraw()
		
        local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks_end.vpcf", PATTACH_POINT, self:GetCaster())
        ParticleManager:SetParticleControl(nfx, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(nfx)
		
    end
end

function modifier_riki_tricks_of_the_trade_handler:CheckState()
	return {[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_OUT_OF_GAME ] = true,
			[MODIFIER_STATE_UNTARGETABLE] = true,
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true}
end

function modifier_riki_tricks_of_the_trade_handler:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_IGNORE_CAST_ANGLE }
end

function modifier_riki_tricks_of_the_trade_handler:GetModifierBonusStats_Agility()
	return self.agility_pct
end

function modifier_riki_tricks_of_the_trade_handler:GetModifierIgnoreCastAngle()
	return 1
end