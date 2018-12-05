minetest.register_craftitem("wtdn:quest_book", {
	description = "Quest Book",
	inventory_image = "default_book.png",

	on_use = function(itemstack, user, pointed_thing)
		minetest.show_formspec(user:get_player_name(), "wtdn:page_list", wtdn.get_page_list_formspec(user))
	end,
})

