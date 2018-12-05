--[[

	wtdn
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

wtdn.player_data = {}

wtdn.get_page_list_formspec = function(user)
	local fs = "size[8,8;]\n"

	fs = fs.."label[3.5,0;Quest Book]\n"
	fs = fs.."textlist[0,1;7.75,5;wtdn_page_list;"
	for name, page in pairs(wtdn.registered_pages) do
		fs = fs..page.label..";"
	end
	fs = fs.."]\n"

	fs = fs.."button[3,7;2,1;wtdn_go_to_page;Go to page]"

	return fs
end

wtdn.get_quest_page_formspec = function(page)
	local page_infos = wtdn.registered_pages[page]
	if not page_infos then
		return
	end

	local fs = "size[8,8;]\n"
	fs = fs.."label[3.5,0;"..page_infos.label.."]\n"

	-- Add quests
	fs = fs.."textlist[0,1;7.75,5;wtdn_quest_list;"
	for name, quest in pairs(wtdn.registered_quests) do
		if quest.page == page then
			fs = fs..quest.label.." (0/"..quest.amount..");"
		else
			minetest.log(tostring(quest.page).." | "..tostring(page))
		end
	end
	fs = fs.."]\n"

	fs = fs.."label[0,0"

	return fs
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local player_name = player:get_player_name()

	if not wtdn.player_data[player_name] then
		wtdn.player_data[player_name] = {}
	end

	if formname == "wtdn:page_list" then
		if fields["wtdn_page_list"] ~= nil then
			local listevent = minetest.explode_textlist_event(fields["wtdn_page_list"])
			wtdn.player_data[player_name].selected_page = listevent.index
		elseif fields["wtdn_go_to_page"] ~= nil then
			local fs = wtdn.get_quest_page_formspec(wtdn.player_data[player_name].selected_page)
			minetest.log(tostring(fs))
			if fs then
				minetest.show_formspec(player_name, "wtdn:quest_page", fs)
			end
		end

		minetest.log("Player "..player_name.." submitted fields "..dump(fields))
	-- elseif formname == "wtdn:quest_page" then
	-- 	minetest.show_formspec(player_name, "wtdn:page_list", wtdn.get_page_list_formspec())
	end
end)

