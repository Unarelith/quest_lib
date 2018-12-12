--[[

	quest_lib
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

minetest.register_craftitem("quest_lib:quest_book", {
	description = "Quest Book",
	inventory_image = "default_book.png^[colorize:#23C:120",

	on_use = function(itemstack, user, pointed_thing)
		local player_name = user:get_player_name()
		local page = quest_lib.quests.get_page(player_name)
		minetest.show_formspec(player_name, "quest_lib:book_form", quest_lib.get_page_formspec(player_name, page))
	end,
})

minetest.register_craft({
	type = "shapeless",
	output = "quest_lib:quest_book",
	recipe = {"default:book"}
})

