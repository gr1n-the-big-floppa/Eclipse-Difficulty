-- Clones a weapon preset and optionally sets values for all weapons contained in that preset
-- if the value is a function, it calls the function with the data of the value name instead
local nil_value = {}
local function based_on(preset, values)
	local p = deep_clone(preset)
	if not values then
		return p
	end
	for _, entry in pairs(p) do
		for val_name, val in pairs(values) do
			if type(val) == "function" then
				val(entry[val_name])
			else
				entry[val_name] = val ~= nil_value and val
			end
		end
	end
	return p
end

local _presets_orig = CharacterTweakData._presets
function CharacterTweakData:_presets(tweak_data, ...)
	local presets = _presets_orig(self, tweak_data, ...)
	local is_pro = Global.game_settings and Global.game_settings.one_down

	presets.weapon.base = based_on(presets.weapon.expert, {
		focus_delay = (is_pro and 0.25) or 0.35,
		aim_delay = (is_pro and { 0, 0.1 }) or { 0.15, 0.2 },
		melee_dmg = 10,
		melee_speed = 1,
		melee_retry_delay = { 1, 2 },
		range = { close = 750, optimal = 1500, far = 3000 },
		RELOAD_SPEED = 1,
	})

	presets.weapon.base.is_pistol.FALLOFF = {
		{ dmg_mul = 3.5, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.15, 0.3 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3.5, r = 3000, acc = { 0.1, 0.4 }, recoil = { 0.3, 0.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.akimbo_pistol.melee_dmg = nil
	presets.weapon.base.akimbo_pistol.melee_speed = nil
	presets.weapon.base.akimbo_pistol.melee_retry_delay = nil
	presets.weapon.base.akimbo_pistol.FALLOFF = {
		{ dmg_mul = 3.5, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.1, 0.2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3.5, r = 3000, acc = { 0.1, 0.4 }, recoil = { 0.2, 0.4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_revolver.RELOAD_SPEED = 0.9
	presets.weapon.base.is_revolver.range = { close = 1000, optimal = 2000, far = 4000 }
	presets.weapon.base.is_revolver.FALLOFF = {
		{ dmg_mul = 12.5, r = 0, acc = { 0.8, 1 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 12.5, r = 4000, acc = { 0.3, 0.6 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_sniper = deep_clone(presets.weapon.base.is_revolver)
	presets.weapon.base.is_sniper.range = { close = 5000, optimal = 10000, far = 15000 }
	presets.weapon.base.is_sniper.FALLOFF = {
		{ dmg_mul = 18, r = 0, acc = { 0, 0.5 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 18, r = 2000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 18, r = 4000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_shotgun_pump.RELOAD_SPEED = 1.5
	presets.weapon.base.is_shotgun_pump.range = { close = 500, optimal = 1000, far = 2000 }
	presets.weapon.base.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 15, r = 300, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 10.5, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2.5, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.2, 1.8 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_shotgun_mag = deep_clone(presets.weapon.base.is_shotgun_pump)
	presets.weapon.base.is_shotgun_mag.RELOAD_SPEED = 1
	presets.weapon.base.is_shotgun_mag.autofire_rounds = { 1, 3 }
	presets.weapon.base.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 7.5, r = 300, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4, r = 1000, acc = { 0.5, 0.8 }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5, r = 2000, acc = { 0.3, 0.6 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_double_barrel = deep_clone(presets.weapon.base.is_shotgun_pump)
	presets.weapon.base.is_double_barrel.FALLOFF = {
		{ dmg_mul = 17.5, r = 300, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_rifle.autofire_rounds = { 1, 5 }
	presets.weapon.base.is_rifle.FALLOFF = {
		{ dmg_mul = 5.5, r = 0, acc = { 0.45, 0.7 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 5.5, r = 3000, acc = { 0.2, 0.45 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_smg = deep_clone(presets.weapon.base.is_rifle)
	presets.weapon.base.is_smg.autofire_rounds = { 3, 8 }
	presets.weapon.base.is_smg.FALLOFF = {
		{ dmg_mul = 5, r = 0, acc = { 0.35, 0.6 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 5, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_lmg = deep_clone(presets.weapon.base.is_smg)
	presets.weapon.base.is_lmg.autofire_rounds = { 15, 30 }
	presets.weapon.base.is_lmg.FALLOFF = {
		{ dmg_mul = 4.5, r = 0, acc = { 0.3, 0.7 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4.5, r = 1000, acc = { 0.2, 0.6 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4.5, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.mini = deep_clone(presets.weapon.base.is_lmg)
	presets.weapon.base.mini.autofire_rounds = { 50, 200 }
	presets.weapon.base.mini.FALLOFF = {
		{ dmg_mul = 1, r = 0, acc = { 0.15, 0.35 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.7, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.1, r = 3000, acc = { 0, 0.15 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_flamethrower.melee_dmg = nil
	presets.weapon.base.is_flamethrower.melee_speed = nil
	presets.weapon.base.is_flamethrower.melee_retry_delay = nil
	presets.weapon.base.is_flamethrower.range = { close = 450, optimal = 900, far = 1800 }
	presets.weapon.base.is_flamethrower.FALLOFF = {
		{ dmg_mul = 2.5, r = 0, acc = { 0.15, 0.35 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.65, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0, r = 2000, acc = { 0, 0.15 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.gc = based_on(presets.weapon.base)
	presets.weapon.gc.is_rifle.autofire_rounds = { 1, 1 }
	presets.weapon.gc.is_rifle.FALLOFF = {
		{ dmg_mul = 9, r = 0, acc = { 0.45, 0.6 }, recoil = { 0.33, 0.66 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 9, r = 3000, acc = { 0.15, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}
	presets.weapon.gc.is_smg.FALLOFF = {
		{ dmg_mul = 7.5, r = 0, acc = { 0.45, 0.7 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 7.5, r = 3000, acc = { 0.2, 0.45 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite = based_on(presets.weapon.base, {
		focus_delay = (is_pro and 0.15) or 0.25,
		aim_delay = (is_pro and { 0, 0.05 }) or { 0.1, 0.1 },
	})

	presets.weapon.elite.is_rifle.autofire_rounds = { 1, 1 }
	presets.weapon.elite.is_rifle.FALLOFF = {
		{ dmg_mul = 8.5, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.33, 0.66 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 8.5, r = 3000, acc = { 0.25, 0.6 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite.is_smg.autofire_rounds = { 3, 8 }
	presets.weapon.elite.is_smg.FALLOFF = {
		{ dmg_mul = 6.5, r = 0, acc = { 0.4, 0.75 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 6.5, r = 3000, acc = { 0.15, 0.4 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite.is_shotgun_pump.RELOAD_SPEED = 1.5
	presets.weapon.elite.is_shotgun_pump.range = { close = 500, optimal = 1000, far = 2000 }
	presets.weapon.elite.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 15, r = 300, acc = { 0.8, 1 }, recoil = { 0.75, 0.75 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 10.5, r = 1000, acc = { 0.7, 0.9 }, recoil = { 0.9, 0.9 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2.5, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.shield = based_on(presets.weapon.base, {
		melee_speed = nil_value,
		melee_dmg = nil_value,
		melee_retry_delay = nil_value,
		range = { close = 500, optimal = 1000, far = 2000 },
	})
	presets.weapon.elite_shield = based_on(presets.weapon.shield, {
		focus_delay = (is_pro and 0.15) or 0.25,
		aim_delay = (is_pro and { 0, 0.05 }) or { 0.1, 0.1 },
	})

	presets.weapon.shield.is_smg.autofire_rounds = { 3, 8 }
	presets.weapon.shield.is_smg.FALLOFF = {
		{ dmg_mul = 3, r = 0, acc = { 0.35, 0.6 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_shield.is_pistol.FALLOFF = {
		{ dmg_mul = 7, r = 0, acc = { 0.5, 0.75 }, recoil = { 0.4, 0.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 7, r = 3000, acc = { 0.1, 0.4 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.taser = based_on(presets.weapon.base, {
		tase_sphere_cast_radius = 15,
		tase_distance = 1500,
		aim_delay_tase = { 0, 0.25 },
	})
	presets.weapon.taser.is_rifle.autofire_rounds = { 1, 1 }
	presets.weapon.taser.is_rifle.FALLOFF = {
		{ dmg_mul = 9, r = 0, acc = { 0.45, 0.7 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 9, r = 3000, acc = { 0.2, 0.45 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.sniper = based_on(presets.weapon.base, {
		focus_delay = 0.5,
		aim_delay = (is_pro and { 0, 0.15 }) or { 0.1, 0.25 },
		range = { close = 5000, optimal = 10000, far = 15000 },
	})

	presets.weapon.sniper.is_rifle.FALLOFF = {
		{ dmg_mul = 12, r = 0, acc = { 0, 0.5 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 12, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 12, r = 4000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.tank = based_on(presets.weapon.base, {
		melee_dmg = 20,
	})
	presets.weapon.elite_tank = based_on(presets.weapon.tank, {
		melee_dmg = 20,
		focus_delay = (is_pro and 0.15) or 0.25,
		aim_delay = (is_pro and { 0, 0.05 }) or { 0.1, 0.1 },
	})

	presets.weapon.tank.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 31.5, r = 300, acc = { 0.8, 1 }, recoil = { 1.25, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 20, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1.5, 1.75 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.75, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.tank.is_shotgun_mag.autofire_rounds = { 1, 6 }
	presets.weapon.tank.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 7.5, r = 300, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4, r = 1000, acc = { 0.5, 0.8 }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5, r = 2000, acc = { 0.3, 0.6 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_tank.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 31.5, r = 300, acc = { 0.8, 1 }, recoil = { 1, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 20, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1.25, 1.25 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.5, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_tank.is_lmg.autofire_rounds = { 25, 50 }
	presets.weapon.elite_tank.is_lmg.FALLOFF = {
		{ dmg_mul = 4.5, r = 0, acc = { 0.3, 0.7 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4.5, r = 1000, acc = { 0.2, 0.6 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4.5, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.1
	presets.gang_member_damage.REGENERATE_TIME = 3
	presets.gang_member_damage.REGENERATE_TIME_AWAY = 4
	presets.gang_member_damage.hurt_severity.bullet = {
		health_reference = "full",
		zones = {
			{
				health_limit = 0.4,
				none = 0.3,
				light = 0.6,
				moderate = 0.1,
			},
			{
				health_limit = 0.7,
				none = 0.1,
				light = 0.7,
				moderate = 0.2,
			},
			{
				none = 0.1,
				light = 0.5,
				moderate = 0.3,
				heavy = 0.1,
			},
		},
	}

	-- escort speed stuff
	presets.move_speed.escort_normal = deep_clone(presets.move_speed.normal)
	presets.move_speed.escort_slow = deep_clone(presets.move_speed.slow)

	-- Tweak dodge presets
	presets.dodge.heavy.occasions.preemptive.chance = 0.25 * ((is_pro and 1.25) or 1)
	presets.dodge.athletic.occasions.preemptive.chance = 0.5 * ((is_pro and 1.25) or 1)

	presets.dodge.ninja.speed = 2
	for _, occasion in pairs(presets.dodge.ninja.occasions) do
		occasion.chance = 1
		if occasion.variations.side_step then
			occasion.variations.side_step.chance = 1
		end
	end

	-- thanks sbz for removing this from vanilla for no reason :)
	presets.hurt_severities.only_light_hurt_and_fire = {
		tase = true,
		bullet = {
			health_reference = 1,
			zones = {
				{
					light = 1,
				},
			},
		},
		explosion = {
			health_reference = 1,
			zones = {
				{
					explode = 1,
				},
			},
		},
		melee = {
			health_reference = 1,
			zones = {
				{
					light = 1,
				},
			},
		},
		fire = {
			health_reference = 1,
			zones = {
				{
					fire = 1,
				},
			},
		},
		poison = {
			health_reference = 1,
			zones = {
				{
					none = 1,
				},
			},
		},
	}

	-- dozer damage reaction
	presets.hurt_severities.dozer = {
		tase = false,
		bullet = {
			health_reference = "current",
			zones = { { light = 1 } },
		},
		explosion = {
			health_reference = "current",
			zones = { { light = 1 } },
		},
		melee = {
			health_reference = "current",
			zones = { { light = 1 } },
		},
		fire = {
			health_reference = "current",
			zones = { { none = 1 } },
		},
		poison = {
			health_reference = "current",
			zones = { { none = 1 } },
		},
	}

	-- taser / medic preset
	presets.hurt_severities.base.bullet.zones = {
		{
			health_limit = 0.2,
			none = 0.2,
			light = 0.6,
			moderate = 0.2,
		},
		{
			health_limit = 0.4,
			light = 0.5,
			moderate = 0.3,
			heavy = 0.2,
		},
		{
			health_limit = 0.6,
			light = 0.2,
			moderate = 0.3,
			heavy = 0.5,
		},
		{
			health_limit = 0.8,
			moderate = 0.3,
			heavy = 0.7,
		},
	}
	presets.hurt_severities.base.melee.zones = {
		{
			health_limit = 0.2,
			light = 1,
		},
		{
			health_limit = 0.4,
			light = 0.5,
			moderate = 0.5,
		},
		{
			health_limit = 0.6,
			moderate = 0.5,
			heavy = 0.5,
		},
		{
			health_limit = 0.8,
			heavy = 1,
		},
	}
	presets.hurt_severities.base.explosion.zones = {
		{
			health_limit = 0.2,
			light = 0.5,
			moderate = 0.5,
		},
		{
			health_limit = 0.4,
			moderate = 0.5,
			heavy = 0.5,
		},
		{
			health_limit = 0.6,
			heavy = 0.5,
			explode = 0.5,
		},
		{
			health_limit = 0.8,
			explode = 1,
		},
	}

	-- heavies don't stumble as much
	presets.hurt_severities.no_heavy_hurt = {
		tase = true,
		bullet = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.4,
					light = 1,
				},
				{
					health_limit = 0.7,
					moderate = 1,
				},
				{
					light = 1,
					moderate = 1,
				},
			},
		},
		fire = {
			health_reference = "full",
			zones = {
				{
					fire = 1,
				},
			},
		},
		poison = {
			health_reference = "full",
			zones = {
				{
					poison = 1,
				},
			},
		},
		explosion = {
			health_reference = "full",
			zones = {
				{
					health_limit = 0.2,
					moderate = 1,
				},
				{
					health_limit = 0.5,
					heavy = 1,
				},
				{
					health_limit = 0.8,
					explode = 1,
				},
				{
					heavy = 0.5,
					explode = 0.5,
				},
			},
		},
	}
	presets.hurt_severities.no_heavy_hurt.melee = deep_clone(presets.hurt_severities.no_heavy_hurt.bullet)

	-- Setup surrender presets
	presets.surrender.weak = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 1,
			weapon_down = 0.7,
			flanked = 0.6,
			unaware_of_aggressor = 0.4,
			isolated = 0.3,
		},
		factors = {
			health = {
				[1.0] = 0,
				[0.2] = 1,
			},
			aggressor_dis = {
				[100] = 0.3,
				[1000] = 0,
			},
		},
	}
	presets.surrender.average = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.9,
			weapon_down = 0.5,
			flanked = 0.5,
			unaware_of_aggressor = 0.3,
			isolated = 0.2,
		},
		factors = {
			health = {
				[0.75] = 0,
				[0.0] = 0.5,
			},
			aggressor_dis = {
				[100] = 0.2,
				[1000] = 0,
			},
		},
	}
	presets.surrender.hard = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.8,
			weapon_down = 0.3,
			flanked = 0.4,
			unaware_of_aggressor = 0.2,
			isolated = 0.1,
		},
		factors = {
			health = {
				[0.5] = 0,
				[0.0] = 0.3,
			},
			aggressor_dis = {
				[100] = 0.1,
				[1000] = 0,
			},
		},
	}
	presets.surrender.veteran = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.2,
			weapon_down = 0.1,
			flanked = 0.1,
			unaware_of_aggressor = 0.1,
			isolated = 0.1,
		},
		factors = {
			health = {
				[0.5] = 0,
				[0.0] = 0.15,
			},
			aggressor_dis = {
				[100] = 0,
				[1000] = 0,
			},
		},
	}

	-- Enemy chatter
	presets.enemy_chatter.cop.aggressive = true
	presets.enemy_chatter.cop.go_go = true
	presets.enemy_chatter.cop.contact = true
	presets.enemy_chatter.cop.flank = true
	presets.enemy_chatter.cop.open_fire = true
	presets.enemy_chatter.cop.watch_background = true
	presets.enemy_chatter.cop.hostage_delay = true
	presets.enemy_chatter.cop.get_hostages = true
	presets.enemy_chatter.cop.get_loot = true
	presets.enemy_chatter.cop.group_death = true
	presets.enemy_chatter.cop.idle = true
	presets.enemy_chatter.cop.report = true

	presets.enemy_chatter.swat.push = true
	presets.enemy_chatter.swat.flank = true
	presets.enemy_chatter.swat.flash_grenade = true
	presets.enemy_chatter.swat.open_fire = true
	presets.enemy_chatter.swat.watch_background = true
	presets.enemy_chatter.swat.hostage_delay = true
	presets.enemy_chatter.swat.get_hostages = true
	presets.enemy_chatter.swat.get_loot = true
	presets.enemy_chatter.swat.group_death = true

	presets.enemy_chatter.gangster = {
		aggressive = true,
		contact = true,
		go_go = true,
	}

	presets.enemy_chatter.security = {
		aggressive = true,
		go_go = true,
		contact = true,
		suppress = true,
		idle = true,
		report = true,
	}

	return presets
end

Hooks:PostHook(CharacterTweakData, "init", "eclipse_init", function(self)
	-- Common SWAT
	self.fbi_swat.move_speed = self.presets.move_speed.fast
	self.fbi_swat.suppression = { panic_chance_mul = 0.3, duration = { 3, 4 }, react_point = { 0, 2 }, brown_point = { 5, 6 } }
	self.fbi_heavy_swat.suppression = { panic_chance_mul = 0.3, duration = { 3, 4 }, react_point = { 0, 2 }, brown_point = { 5, 6 } }
	self.fbi_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.city_swat.suppression = { panic_chance_mul = 0.15, duration = { 1.5, 2 }, react_point = { 2, 5 }, brown_point = { 5, 6 } }

	-- Specials
	-- sniper
	self.sniper.suppression = nil
	self.sniper.misses_first_player_shot = true

	-- cloaker
	self.spooc.use_animation_on_fire_damage = true
	self.spooc.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt_and_fire
	self.spooc.spooc_attack_use_smoke_chance = 0
	self.spooc.melee_weapon = "baton"

	-- tank
	self.tank.damage.hurt_severity = self.presets.hurt_severities.dozer -- cool damage react thing
	self.tank.ecm_vulnerability = 0
	self.tank.damage.explosion_damage_mul = 0.1
	self.tank.melee_weapon = "weapon"
	self.tank.move_speed.stand.walk.cbt = { strafe = 176, fwd = 198, bwd = 154 }
	self.tank.move_speed.stand.run.cbt = self.tank.move_speed.stand.walk.cbt

	-- elite tank
	self.tank_elite = deep_clone(self.tank)
	self.tank_elite.move_speed.stand.walk.cbt = { strafe = 196, fwd = 218, bwd = 174 }
	self.tank_elite.move_speed.stand.run.cbt = self.tank_elite.move_speed.stand.walk.cbt
	table.insert(self._enemy_list, "tank_elite")

	-- taser & medic
	self.taser.damage.hurt_severity = self.presets.hurt_severities.base
	self.medic.damage.hurt_severity = self.presets.hurt_severities.base
	self.medic.use_animation_on_fire_damage = true
	self.medic.move_speed = self.presets.move_speed.fast

	-- shield
	self.shield.damage.explosion_damage_mul = 0.7
	self.shield.damage.hurt_severity = self.presets.hurt_severities.no_hurts

	-- elite shield
	self.phalanx_minion.DAMAGE_CLAMP_BULLET = nil
	self.phalanx_minion.DAMAGE_CLAMP_EXPLOSION = nil
	self.phalanx_minion.damage.explosion_damage_mul = 0.2
	self.phalanx_minion.access = "shield"

	self.phalanx_minion_break = deep_clone(self.phalanx_minion)
	self.phalanx_minion_break.tags = { "law", "shield" }
	self.phalanx_minion_break.move_speed = self.presets.move_speed.very_fast
	self.phalanx_minion_break.allowed_stances = nil
	self.phalanx_minion_break.allowed_poses = nil
	self.phalanx_minion_break.no_equip_anim = nil
	self.phalanx_minion_break.no_run_start = nil
	self.phalanx_minion_break.no_run_stop = nil
	self.phalanx_minion_break.always_face_enemy = nil
	self.phalanx_minion_break.wall_fwd_offset = nil
	self.phalanx_minion_break.priority_shout = nil
	self.phalanx_minion_break.dodge = self.presets.dodge.athletic
	self.phalanx_minion_break.access = "swat"
	self.phalanx_minion_break.chatter = self.presets.enemy_chatter.swat
	self.phalanx_minion_break.announce_incomming = nil
	self.phalanx_minion_break.damage.hurt_severity = self.presets.hurt_severities.base
	self.phalanx_minion_break.damage.explosion_damage_mul = 1
	self.phalanx_minion_break.use_animation_on_fire_damage = nil
	self.phalanx_minion_break.damage.shield_knocked = nil
	self.phalanx_minion_break.tmp_invulnerable_on_tweak_change = 0.1
	table.insert(self._enemy_list, "phalanx_minion_break")

	-- Set custom objective interrupt distance
	self.taser.min_obj_interrupt_dis = 1000
	self.spooc.min_obj_interrupt_dis = 800
	self.shadow_spooc.min_obj_interrupt_dis = 800
	self.tank.min_obj_interrupt_dis = 600
	self.tank_hw.min_obj_interrupt_dis = 600
	self.shield.min_obj_interrupt_dis = 500
	self.phalanx_minion.min_obj_interrupt_dis = 500

	-- ZEAL Team
	self.zeal_swat = deep_clone(self.city_swat)
	self.zeal_swat.dodge = self.presets.dodge.ninja
	self.zeal_swat.suppression = nil
	self.zeal_swat.speech_prefix_p2 = "d"
	self.zeal_swat.damage.explosion_damage_mul = 0.8
	table.insert(self._enemy_list, "zeal_swat")

	self.zeal_heavy_swat = deep_clone(self.city_swat)
	self.zeal_heavy_swat.suppression = nil
	self.zeal_heavy_swat.speech_prefix_p2 = "d"
	self.zeal_heavy_swat.move_speed = self.presets.move_speed.fast
	self.zeal_heavy_swat.damage.explosion_damage_mul = 0.6
	table.insert(self._enemy_list, "zeal_heavy_swat")

	self.zeal_shield = deep_clone(self.shield)
	self.zeal_shield.speech_prefix_p2 = "d"
	table.insert(self._enemy_list, "zeal_shield")

	self.zeal_medic = deep_clone(self.medic)
	self.zeal_medic.move_speed = self.presets.move_speed.very_fast
	self.zeal_medic.speech_prefix_p2 = "d"
	self.zeal_medic.damage.explosion_damage_mul = 0.6
	table.insert(self._enemy_list, "zeal_medic")

	self.zeal_taser = deep_clone(self.taser)
	self.zeal_taser.speech_prefix_p2 = "d"
	self.zeal_taser.damage.explosion_damage_mul = 0.6
	table.insert(self._enemy_list, "zeal_taser")

	-- surrender presets
	self.security.surrender = self.presets.surrender.weak
	self.cop.surrender = self.presets.surrender.weak
	self.fbi.surrender = self.presets.surrender.weak
	self.swat.surrender = self.presets.surrender.weak
	self.fbi_swat.surrender = self.presets.surrender.average
	self.fbi_heavy_swat.surrender = self.presets.surrender.average
	self.city_swat.surrender = self.presets.surrender.hard
	self.zeal_swat.surrender = self.presets.surrender.veteran
	self.zeal_heavy_swat.surrender = self.presets.surrender.veteran

	-- Bosses
	self.biker_boss.HEALTH_INIT = 500
	self.biker_boss.player_health_scaling_mul = 1.5
	self.biker_boss.headshot_dmg_mul = 2
	self.biker_boss.no_headshot_add_mul = false
	self.biker_boss.damage.explosion_damage_mul = 0.5
	self.biker_boss.damage.hurt_severity = self.presets.hurt_severities.dozer
	self.biker_boss.move_speed = self.presets.move_speed.slow
	self.biker_boss.no_run_start = true
	self.biker_boss.no_run_stop = true
	self.biker_boss.throwable = "concussion"
	self.biker_boss.throwable_cooldown = 10

	self.chavez_boss.HEALTH_INIT = 500
	self.chavez_boss.player_health_scaling_mul = 1.5
	self.chavez_boss.headshot_dmg_mul = 1.3
	self.chavez_boss.no_headshot_add_mul = false
	self.chavez_boss.damage.explosion_damage_mul = 0.5
	self.chavez_boss.damage.hurt_severity = self.presets.hurt_severities.dozer
	self.chavez_boss.move_speed = self.presets.move_speed.very_fast
	self.chavez_boss.no_run_start = true
	self.chavez_boss.no_run_stop = true

	self.drug_lord_boss.HEALTH_INIT = 500
	self.drug_lord_boss.player_health_scaling_mul = 1.5
	self.drug_lord_boss.headshot_dmg_mul = 2
	self.drug_lord_boss.no_headshot_add_mul = false
	self.drug_lord_boss.damage.explosion_damage_mul = 0.5
	self.drug_lord_boss.damage.hurt_severity = self.presets.hurt_severities.dozer
	self.drug_lord_boss.move_speed = self.presets.move_speed.normal
	self.drug_lord_boss.no_run_start = true
	self.drug_lord_boss.no_run_stop = true
	self.drug_lord_boss.throwable = "launcher_m203"
	self.drug_lord_boss.throwable_target_verified = true
	self.drug_lord_boss.throwable_cooldown = 10

	self.hector_boss.HEALTH_INIT = 500
	self.hector_boss.player_health_scaling_mul = 1.5
	self.hector_boss.headshot_dmg_mul = 2
	self.hector_boss.no_headshot_add_mul = false
	self.hector_boss.damage.explosion_damage_mul = 0.5
	self.hector_boss.damage.hurt_severity = self.presets.hurt_severities.dozer
	self.hector_boss.move_speed = self.presets.move_speed.slow
	self.hector_boss.no_run_start = true
	self.hector_boss.no_run_stop = true
	self.hector_boss.throwable = "frag"
	self.hector_boss.throwable_cooldown = 15

	self.mobster_boss.HEALTH_INIT = 500
	self.mobster_boss.player_health_scaling_mul = 1.5
	self.mobster_boss.headshot_dmg_mul = 2
	self.mobster_boss.no_headshot_add_mul = false
	self.mobster_boss.damage.explosion_damage_mul = 0.5
	self.mobster_boss.damage.hurt_severity = self.presets.hurt_severities.dozer
	self.mobster_boss.move_speed = self.presets.move_speed.fast
	self.mobster_boss.no_run_start = true
	self.mobster_boss.no_run_stop = true

	self.triad_boss.HEALTH_INIT = 500
	self.triad_boss.player_health_scaling_mul = 1.5
	self.triad_boss.headshot_dmg_mul = 2
	self.triad_boss.no_headshot_add_mul = false
	self.triad_boss.damage.explosion_damage_mul = 0.5
	self.triad_boss.damage.hurt_severity = self.presets.hurt_severities.dozer
	self.triad_boss.move_speed = self.presets.move_speed.slow
	self.triad_boss.no_run_start = true
	self.triad_boss.no_run_stop = true
	self.triad_boss.bullet_damage_only_from_front = nil
	self.triad_boss.invulnerable_to_slotmask = nil
	self.triad_boss.throwable_target_verified = false
	self.triad_boss.throwable_cooldown = 20

	self.deep_boss.HEALTH_INIT = 500
	self.deep_boss.player_health_scaling_mul = 1.5
	self.deep_boss.headshot_dmg_mul = 2
	self.deep_boss.no_headshot_add_mul = false
	self.deep_boss.ignore_headshot = false
	self.deep_boss.damage.explosion_damage_mul = 0.5
	self.deep_boss.damage.hurt_severity = self.presets.hurt_severities.dozer
	self.deep_boss.move_speed = self.presets.move_speed.slow
	self.deep_boss.no_run_start = true
	self.deep_boss.no_run_stop = true

	-- escort speed stuff
	self.escort_cfo.move_speed = self.presets.move_speed.escort_normal
	self.escort_chinese_prisoner.move_speed = self.presets.move_speed.escort_slow
	self.escort_sand.move_speed = self.presets.move_speed.escort_slow
	self.spa_vip.move_speed = self.presets.move_speed.escort_normal
	self.escort_undercover.move_speed = self.presets.move_speed.escort_slow

	-- apply weapon presets
	self.security.weapon = self.presets.weapon.base
	self.cop.weapon = self.presets.weapon.base
	self.gangster.weapon = self.presets.weapon.base
	self.biker.weapon = self.presets.weapon.base
	self.biker_escape.weapon = self.presets.weapon.base
	self.triad.weapon = self.presets.weapon.base
	self.mobster.weapon = self.presets.weapon.base

	self.swat.weapon = self.presets.weapon.base
	self.fbi.weapon = self.presets.weapon.gc
	self.fbi_swat.weapon = self.presets.weapon.base
	self.fbi_heavy_swat.weapon = self.presets.weapon.base
	self.city_swat.weapon = self.presets.weapon.elite

	self.shield.weapon = self.presets.weapon.shield
	self.taser.weapon = self.presets.weapon.taser
	self.medic.weapon = self.presets.weapon.gc
	self.spooc.weapon = self.presets.weapon.elite
	self.sniper.weapon = self.presets.weapon.sniper
	self.tank.weapon = self.presets.weapon.tank
	self.tank_elite.weapon = self.presets.weapon.elite_tank
	self.phalanx_minion.weapon = self.presets.weapon.elite_shield
	self.phalanx_minion_break.weapon = self.presets.weapon.elite_shield

	self.biker_boss.weapon = self.presets.weapon.elite_tank
	self.chavez_boss.weapon = self.presets.weapon.base
	self.drug_lord_boss.weapon = self.presets.weapon.base
	self.hector_boss.weapon = self.presets.weapon.tank
	self.mobster_boss.weapon = self.presets.weapon.elite_tank
	self.triad_boss.weapon = self.presets.weapon.base
	self.deep_boss.weapon = self.presets.weapon.elite_tank

	self.zeal_swat.weapon = self.presets.weapon.elite
	self.zeal_heavy_swat.weapon = self.presets.weapon.gc
	self.zeal_shield.weapon = self.presets.weapon.elite_shield
	self.zeal_medic.weapon = self.presets.weapon.gc
	self.zeal_taser.weapon = self.presets.weapon.taser

	self.biker.melee_weapon = "knife_1"

	-- Set chatter presets
	self.mobster.chatter = self.presets.enemy_chatter.gangster
	self.biker.chatter = self.presets.enemy_chatter.gangster
	self.biker_escape.chatter = self.presets.enemy_chatter.gangster
	self.bolivian.chatter = self.presets.enemy_chatter.gangster
	self.bolivian_indoors.chatter = self.presets.enemy_chatter.gangster
	self.gensec.chatter = self.presets.enemy_chatter.security
	self.security.chatter = self.presets.enemy_chatter.security
	self.security_undominatable.chatter = self.presets.enemy_chatter.security
	self.security_mex.chatter = self.presets.enemy_chatter.security
	self.security_mex_no_pager.chatter = self.presets.enemy_chatter.security

	-- if bot weapons and equipment is installed and fixed weapon balance is on don't make any further changes
	if BotWeapons and BotWeapons.settings and BotWeapons.settings.weapon_balance then
		return
	end

	self.presets.weapon.gang_member = self.presets.weapon.base
end)

-- Add new enemies to the character map
local character_map_original = CharacterTweakData.character_map
function CharacterTweakData:character_map(...)
	local char_map = character_map_original(self, ...)

	table.insert(char_map.gitgud.list, "ene_zeal_swat_2")
	table.insert(char_map.gitgud.list, "ene_zeal_swat_heavy_2")
	table.insert(char_map.gitgud.list, "ene_zeal_medic_m4")
	table.insert(char_map.gitgud.list, "ene_zeal_medic_r870")

	return char_map
end

-- Add new weapons
Hooks:PostHook(CharacterTweakData, "_create_table_structure", "sh__create_table_structure", function(self)
	table.insert(self.weap_ids, "shepheard")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_shepheard/wpn_npc_shepheard"))

	table.insert(self.weap_ids, "ksg")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_ksg/wpn_npc_ksg"))
end)

local function setup_presets(self)
	local diff_i = self.tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
	local is_pro = Global.game_settings and Global.game_settings.one_down
	local f = ((diff_i ^ 2) / (diff_i * 3))
	self:_multiply_all_hp(3, 1.75)

	-- common swat
	self.swat.HEALTH_INIT = 30
	self.swat.headshot_dmg_mul = 2.4 -- 125 head health
	self.fbi_swat.HEALTH_INIT = 36
	self.fbi_swat.headshot_dmg_mul = 2.25 -- 160 head health
	self.fbi_heavy_swat.HEALTH_INIT = 72
	self.fbi_heavy_swat.headshot_dmg_mul = 2.4 -- 300 head health
	self.city_swat.HEALTH_INIT = 48
	self.city_swat.headshot_dmg_mul = 2.5 -- 192 head health

	-- specials
	self.sniper.HEALTH_INIT = 16
	self.shield.HEALTH_INIT = 45
	self.shield.headshot_dmg_mul = 2.25 -- 200 head health
	self.taser.HEALTH_INIT = 96
	self.taser.headshot_dmg_mul = 1.875 -- 512 head health
	self.spooc.HEALTH_INIT = 102
	self.spooc.headshot_dmg_mul = 4 -- 255 head health
	self.medic.HEALTH_INIT = 72
	self.medic.headshot_dmg_mul = 2 -- 360 head health
	self.tank.HEALTH_INIT = 2160
	self.tank.headshot_dmg_mul = 45 -- 480 head health
	self.tank_elite.HEALTH_INIT = 2160
	self.tank_elite.headshot_dmg_mul = 45 -- 480 head health
	self.phalanx_minion.HEALTH_INIT = 72
	self.phalanx_minion.headshot_dmg_mul = 3 -- 240 head health

	-- zeal team
	self.zeal_swat.HEALTH_INIT = 64
	self.zeal_swat.headshot_dmg_mul = 2.5 -- 256 head health
	self.zeal_heavy_swat.HEALTH_INIT = 84
	self.zeal_heavy_swat.headshot_dmg_mul = 1.75 -- 480 head health
	self.zeal_shield.HEALTH_INIT = 54
	self.zeal_shield.headshot_dmg_mul = 1.8 -- 300 head health
	self.zeal_medic.HEALTH_INIT = 84
	self.zeal_medic.headshot_dmg_mul = 2 -- 420 head health
	self.zeal_taser.HEALTH_INIT = 120
	self.zeal_taser.headshot_dmg_mul = 1.6 -- 750 head health

	-- misc
	self.spooc.spooc_attack_timeout = { 4 / f, 5 / f }
	self.taser.weapon.is_rifle.tase_distance = 750 * f
	self.taser.weapon.is_rifle.aim_delay_tase = { 0, 0.5 / f }
	self.zeal_taser.weapon.is_rifle.tase_distance = 750 * f
	self.zeal_taser.weapon.is_rifle.aim_delay_tase = { 0, 0.5 / f }
	self.tank_armor_balance_mul = { 2.5 * f, 3.25 * f, 4.25 * f, 5 * f }
	self.flashbang_multiplier = 1 * f
	self.concussion_multiplier = 1

	-- team ai health scaling
	self.presets.gang_member_damage.HEALTH_INIT = 100 * (f ^ 2)

	-- eclipse exclusive edits
	if diff_i == 6 then
		self.spooc.spooc_sound_events = { detect_stop = "cloaker_presence_stop", detect = "cloaker_presence_loop" } -- cloakers are silent on eclipse

		self:_multiply_all_speeds(1.12, 1.06)
		self.tank.move_speed.stand.walk.cbt = { strafe = 196, fwd = 218, bwd = 174 }
		self.tank.move_speed.stand.run.cbt = self.tank_elite.move_speed.stand.walk.cbt
		self.tank_elite.move_speed.stand.walk.cbt = { strafe = 216, fwd = 238, bwd = 194 }
		self.tank_elite.move_speed.stand.run.cbt = self.tank_elite.move_speed.stand.walk.cbt
		self.shield.move_speed.crouch.walk.cbt = { strafe = 270, fwd = 300, bwd = 250 }
		self.shield.move_speed.crouch.run.cbt = { strafe = 300, fwd = 340, bwd = 270 }
		self.phalanx_minion.move_speed.crouch.walk.cbt = { strafe = 270, fwd = 300, bwd = 250 }
		self.phalanx_minion.move_speed.crouch.run.cbt = { strafe = 300, fwd = 340, bwd = 270 }
		self.zeal_shield.move_speed.crouch.walk.cbt = { strafe = 290, fwd = 320, bwd = 270 }
		self.zeal_shield.move_speed.crouch.run.cbt = { strafe = 320, fwd = 360, bwd = 290 }
	end

	-- pro job speed increase
	if is_pro then
		self:_multiply_all_speeds(1.05, 1.05)
	end
end

CharacterTweakData._set_normal = setup_presets
CharacterTweakData._set_hard = setup_presets
CharacterTweakData._set_overkill = setup_presets
CharacterTweakData._set_overkill_145 = setup_presets
CharacterTweakData._set_easy_wish = setup_presets

-- fixed movement speed difficulty scaling
-- thanks redflame
function CharacterTweakData:_multiply_all_speeds(walk_mul, run_mul)
	for preset_name, preset in pairs(self.presets.move_speed) do
		if preset_name ~= "civ_fast" and preset_name ~= "escort_slow" and preset_name ~= "escort_normal" then
			for _, pose in pairs(preset) do
				for haste_name, haste in pairs(pose) do
					for stance_name, stance in pairs(haste) do
						if stance_name ~= "ntl" then
							for move_dir in pairs(stance) do
								stance[move_dir] = stance[move_dir] * (haste_name == "walk" and walk_mul or run_mul)
							end
						end
					end
				end
			end
		end
	end
end
