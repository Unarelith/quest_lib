--[[

	quest_lib
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

quest_lib.quests = {}
quest_lib.pages = {}

local player_quest_cache = {}

-- FIXME: A local temporary cache could be better than this
quest_lib.quests.get_page = function(player_name)
	return quest_lib.quests.get(0, player_name, 'page')
end

-- FIXME: A local temporary cache could be better than this
quest_lib.quests.set_page = function(player_name, page)
	if quest_lib.pages[page] then
		quest_lib.quests.set(0, player_name, 'page', page)
		return true
	end
end

quest_lib.quests.get = function(page, player_name, quest)
	if not player_quest_cache[player_name] then
		player_quest_cache[player_name] = quest_lib.quests.load(player_name) or {}
	end

	if not player_quest_cache[player_name][page] then
		player_quest_cache[player_name][page] = {}
	end

	if not player_quest_cache[player_name][page][quest] then
		-- player_quest_cache[player_name][page][quest] = (quest == 'page') and 1 or 0
		if quest == "page" then
			player_quest_cache[player_name][page][quest] = 1
		else
			player_quest_cache[player_name][page][quest] = 0
		end
	end

	return player_quest_cache[player_name][page][quest]
end

quest_lib.quests.add = function(page, player_name, quest)
	local player_quest = quest_lib.quests.get(page, player_name, quest)
	quest_lib.quests.set(page, player_name, quest, player_quest + 1)
end

quest_lib.quests.set = function(page, player_name, quest, value)
	player_quest_cache[player_name][page][quest] = value
	quest_lib.quests.save(player_quest_cache[player_name], player_name)

	if page ~= 0 or quest ~= 'page' then
		local rewarded = quest_lib.quests.reward_quest(page, player_name, quest)
		if rewarded then
			minetest.chat_send_all(player_name..' completed the quest "'..quest..'" on page '..page)
			minetest.sound_play("quest_lib_finish_quest", {
				to_player = player_name,
				gain = 1.0,
			})
		end
	end
end

quest_lib.quests.reward_quest = function(page, player_name, quest)
	local count = quest_lib.quests.get(page, player_name, quest)
	for _, v in ipairs(quest_lib.pages[page].quests) do
		if v.quest == quest and v.count == count then
			local player = minetest.get_player_by_name(player_name)
			local itemstack = player:get_inventory():add_item('main', v.reward)

			if not itemstack:is_empty() then
				-- FIXME: Dependency to fs_core isn't good
				fs_core.drop_item_stack(player:get_pos(), itemstack) -- If player inventory is full, drop items
			end

			return true
		end
	end
end

local filepath = minetest.get_worldpath()..'/quests'

quest_lib.quests.save = function(data, player_name)
	minetest.mkdir(filepath)

	local file = io.open(filepath..'/'..player_name, 'wb')
	if not file then
		quest_lib.log('Cannot open quest file for writing "'..filepath..'/'..player_name..'"')
	else
		file:write(minetest.serialize(data))
	end

	file:close()
end

quest_lib.quests.load = function(player_name)
	local file, err = io.open(filepath..'/'..player_name, 'rb')
	if err then return end

	local data = file:read('*a')
	file:close()
	return minetest.deserialize(data)
end

