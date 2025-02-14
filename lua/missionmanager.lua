if Global.editor_mode then
	StreamHeist:log("Editor mode is active, mission script changes disabled")
	return
end

local is_pro_job = Global.game_settings and Global.game_settings.one_down
-- Add custom mission script changes and triggers for specific levels
MissionManager.mission_script_patch_funcs = {
	values = function(self, element, data)
		for k, v in pairs(data) do
			element._values[k] = v
			StreamHeist:log('%s value "%s" has been set to "%s"', element:editor_name(), k, tostring(v))
		end
	end,

	on_executed = function(self, element, data)
		for _, v in pairs(data) do
			local new_element = self:get_element_by_id(v.id)
			if new_element then
				local val, i = table.find_value(element._values.on_executed, function(val)
					return val.id == v.id
				end)
				if v.remove then
					if val then
						table.remove(element._values.on_executed, i)
						StreamHeist:log("Removed element %s from on_executed of %s", new_element:editor_name(), element:editor_name())
					end
				elseif val then
					val.delay = v.delay or 0
					val.delay_rand = v.delay_rand or 0
					StreamHeist:log("Modified element %s in on_executed of %s", new_element:editor_name(), element:editor_name())
				else
					table.insert(element._values.on_executed, v)
					StreamHeist:log("Added element %s to on_executed of %s", new_element:editor_name(), element:editor_name())
				end
			else
				StreamHeist:error("Mission script element %u could not be found", v.id)
			end
		end
	end,

	pre_func = function(self, element, data)
		Hooks:PreHook(element, "on_executed", "sh_on_executed_func_" .. element:id(), data)
		StreamHeist:log("%s hooked as pre function call trigger", element:editor_name())
	end,

	func = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element:id(), data)
		StreamHeist:log("%s hooked as function call trigger", element:editor_name())
	end,

	ponr = function(self, element, data)
		if is_pro_job then
			local function set_ponr()
				local ponr_timer_balance_mul = data.player_mul and managers.groupai:state():_get_balancing_multiplier(data.player_mul) or 1
				managers.groupai:state():set_point_of_no_return_timer(data.length * ponr_timer_balance_mul, -1)
			end

			Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_" .. element:id(), set_ponr)
			Hooks:PostHook(element, "client_on_executed", "eclipse_client_on_executed_ponr_" .. element:id(), set_ponr)
		end
	end,

	ponr_end = function(self, element, data)
		if is_pro_job then
			Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_end_" .. element:id(), function()
				managers.groupai:state():remove_point_of_no_return_timer(0)
			end)
			Hooks:PostHook(element, "client_on_executed", "eclipse_client_on_executed_ponr_end_" .. element:id(), function()
				managers.groupai:state():remove_point_of_no_return_timer(0)
			end)
		end
	end,

	set_ponr_state = function(self, element, data)
		if is_pro_job then
			if Network:is_server() then
				Hooks:PostHook(element, "on_executed", "eclipse_on_executed_ponr_state_" .. element:id(), function()
					managers.mission:set_ponr_state()
				end)
			end
		end
	end,

	spawn_instigator_ids = function(self, element, data)
		for _, v in pairs(data) do
			local new_element = self:get_element_by_id(v)
			if new_element then
				table.insert(element._values.spawn_instigator_ids, v)
				StreamHeist:log(string.format("Added element %s to spawn_instigator_ids of %s", new_element:editor_name(), element:editor_name()))
			else
				StreamHeist:error(string.format("Mission script element %u could not be found", v))
			end
		end
	end,

	reinforce = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_reinforce_" .. element:id(), function()
			StreamHeist:log("%s executed, toggled %u reinforce point(s)", element:editor_name(), #data)
			for _, v in pairs(data) do
				managers.groupai:state():set_area_min_police_force(v.name, v.force, v.position)
			end
		end)
		StreamHeist:log("%s hooked as reinforce trigger for %u area(s)", element:editor_name(), #data)
	end,

	difficulty = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_difficulty_" .. element:id(), function()
			StreamHeist:log("%s executed, set difficulty to %.2g", element:editor_name(), data)
			managers.groupai:state():set_difficulty(data)
		end)
		StreamHeist:log("%s hooked as difficulty change trigger", element:editor_name())
	end,

	flashlight = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element:id(), function()
			StreamHeist:log("%s executed, changing flashlight state to %s", element:editor_name(), data and "true" or "false")
			managers.game_play_central:set_flashlights_on(data)
		end)
		StreamHeist:log("%s hooked as flashlight state trigger", element:editor_name())
	end,

	groups = function(self, element, data)
		local new_groups = table.list_to_set(element._values.preferred_spawn_groups)
		for group_name, enabled in pairs(data) do
			new_groups[group_name] = enabled or nil
		end
		element._values.preferred_spawn_groups = table.map_keys(new_groups)
		StreamHeist:log("Changed %u preferred group(s) of %s", table.size(data), element:editor_name())
	end,
}

Hooks:PreHook(MissionManager, "_activate_mission", "sh__activate_mission", function(self)
	local mission_script_elements = StreamHeist:mission_script_patches()
	if not mission_script_elements then
		return
	end

	for element_id, data in pairs(mission_script_elements) do
		local element = self:get_element_by_id(element_id)
		if not element then
			StreamHeist:error("Mission script element %u could not be found", element_id)
		else
			for patch_name, patch_data in pairs(data) do
				if self.mission_script_patch_funcs[patch_name] then
					self.mission_script_patch_funcs[patch_name](self, element, patch_data)
				else
					StreamHeist:warn("MissionManager.mission_script_patch_funcs.%s does not exist", patch_name)
				end
			end
		end
	end
end)

function MissionManager:set_ponr_state()
	self._instant_start_ponr = true
end
