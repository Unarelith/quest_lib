--[[

	quest_lib
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "quest_lib:book_form" then
		local player_name = player:get_player_name()
		local page = quest_lib.quests.get_page(player_name)
		if fields["prev_page"] and page > 1 then
			quest_lib.quests.set_page(player_name, page - 1)
			minetest.show_formspec(player_name, "quest_lib:book_form", quest_lib.get_page_formspec(player_name, page - 1))
		elseif fields["next_page"] and page < #quest_lib.pages then
			quest_lib.quests.set_page(player_name, page + 1)
			minetest.show_formspec(player_name, "quest_lib:book_form", quest_lib.get_page_formspec(player_name, page + 1))
		end
	end
end)

minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	if not user then return end
	local player_name = user:get_player_name()
	local item_name = itemstack:get_name()

	for i, page in ipairs(quest_lib.pages) do
		for _, v in ipairs(page.quests) do
			if v.item_eat then
				for _, vv in ipairs(v.item_eat) do
					if item_name == vv then
						quest_lib.quests.add(i, player_name, v.quest)
						return
					end
				end
			end
		end
	end
end)

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if not player then return end
	local player_name = player:get_player_name()
	local item_name = itemstack:get_name()

	for i, page in ipairs(quest_lib.pages) do
		for _, v in ipairs(page.quests) do
			if v.craft then
				for _, vv in ipairs(v.craft) do
					if item_name == vv then
						quest_lib.quests.add(i, player_name, v.quest)
						return
					end
				end
			end
		end
	end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not digger then return end
	local player_name = digger:get_player_name()

	for i, page in ipairs(quest_lib.pages) do
		for _, v in ipairs(page.quests) do
			if v.dignode then
				for _, vv in ipairs(v.dignode) do
					if oldnode.name == vv then
						quest_lib.quests.add(i, player_name, v.quest)
						return
					end
				end
			end
		end
	end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode)
	if not placer then return end
	local player_name = placer:get_player_name()
	local page = quest_lib.quests.get_page(player_name)

	for i, page in ipairs(quest_lib.pages) do
		for _, v in ipairs(page.quests) do
			if v.placenode then
				for _, vv in ipairs(v.placenode) do
					if newnode.name == vv then
						quest_lib.quests.add(i, player_name, v.quest)
						return
					end
				end
			end
		end
	end
end)

if item_drop and item_drop.register_on_pickup then
	item_drop.register_on_pickup(function(picker, item_name)
		if not picker then return end
		local player_name = picker:get_player_name()
		local page = quest_lib.quests.get_page(player_name)

		for i, page in ipairs(quest_lib.pages) do
			for _, v in ipairs(page.quests) do
				if v.pickup then
					for _, vv in ipairs(v.pickup) do
						if item_name == vv then
							-- FIXME: Should be relative to itemstack size
							quest_lib.quests.add(i, player_name, v.quest)
							return
						end
					end
				end
			end
		end
	end)
end

