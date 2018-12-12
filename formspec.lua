--[[

	quest_lib
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

quest_lib.get_page_formspec = function(player_name, page)
	local info = {
		page = page,
		count = 0,
		player_name = player_name,
	}

	local formspec = 'size[6.4,10;]'
		..'background[-0.1,-0.1;6.6,10.3;goals.png]'
		..'label[0,0; --== PAGE '..page..' for '..player_name..' ==--]'
		..'button[4.4,0;1,1;prev_page;<--]'
		..'button[5.4,0;1,1;next_page;-->]'

	local description = quest_lib.pages[page].get_description(player_name)
	local text = 'label[0,2.7; --== Quests ==--]'
		..'label[0,0.5;'..(description[1] or '')..']'
		..'label[0,1.0;'..(description[2] or '')..']'
		..'label[0,1.5;'..(description[3] or '')..']'
		..'label[0,2.0;'..(description[4] or '')..']'

	formspec = formspec .. text

	for k, v in ipairs(quest_lib.pages[page].quests) do
		local quest_formspec = quest_lib.get_quest_formspec(info, k, v.quest, v.count, v.name, v.hint, true)
		if quest_formspec then
			formspec = formspec..quest_formspec
		end
	end

	return formspec
end

quest_lib.get_quest_formspec = function(info, i, quest, required, text, hint, inventory)
	local quest = quest_lib.quests.get(info.page, info.player_name, quest)
	if not quest then return end

	local count = math.min(quest, required)
	local y = 2.9 + (i * 0.6)
	local formspec = 'label[0.5,'..y..'; '..text..' ('..count..'/'..required..')]'

	if hint then
		formspec = formspec..'item_image_button[5.8,'..y..';0.6,0.6;'
			..quest_lib.craft_guide.image_button_link(hint)..']'
	end

	if count == required then
		formspec = formspec .. 'image[-0.2,'..(y - 0.25)..';1,1;checkbox_checked.png]'
		info.count = info.count + 1
	else
		formspec = formspec .. 'image[-0.2,'..(y - 0.25)..';1,1;checkbox_unchecked.png]'
	end

	return formspec
end

