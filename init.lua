--[[

	quest_lib
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

quest_lib = rawget(_G, "quest_lib") or {}
quest_lib.modpath = modpath

dofile(modpath .. "/api.lua")
dofile(modpath .. "/events.lua")
dofile(modpath .. "/formspec.lua")
dofile(modpath .. "/quest_book.lua")
dofile(modpath .. "/craft_guide.lua")

