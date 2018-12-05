--[[

	wtdn
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

wtdn.registered_quests = {}
wtdn.registered_pages = {}
wtdn.registered_tiers = {}

wtdn.register_quest = function(page, id, infos)
	wtdn.registered_quests[id] = infos
end

wtdn.register_page = function(id, infos)
	wtdn.registered_pages[id] = infos
end

wtdn.register_page(1, {
	label = "The Beginning",
	description = "Mine, craft, build. Most of early game quests.",
})

wtdn.register_quest(1, 1, {
	label = "Dig dirt blocks",
	description = "Start by digging 5 dirt blocks. You'll be rewarded don't worry. :)",
	page = 1,
	tier = 1,

	type = "dignode",
	nodes = {"default:dirt", "default:dirt_with_grass"},
	amount = 5,
	rewards = {"default:cobble 5"},
})

wtdn.register_quest(1, 2, {
	label = "Craft a furnace",
	description = "Let's craft our first furnace ! :D",
	requires = {"1:1"},
	page = 1,
	tier = 1,

	type = "craft",
	nodes = {"default:furnace"},
	amount = 1,
	rewards = {"default:diamond", "default:mese_crystal"},
})

