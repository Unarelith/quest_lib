--[[

	wtdn
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

wtdn = rawget(_G, "wtdn") or {}
wtdn.modpath = modpath

dofile(modpath .. "/quest.lua")
dofile(modpath .. "/formspec.lua")
dofile(modpath .. "/craftitems.lua")
dofile(modpath .. "/crafting.lua")

