--Heights for skyboxes
local low_orbit_low = 5000 
local low_orbit_high = 5999
local high_orbit_low = 6000
local high_orbit_high = 6999

local player_list = {} -- Holds name of skybox showing for each player

local ground_skybox = {
	"ground_pos_y.png",
	"ground_neg_y.png",
	"ground_neg_z.png",
	"ground_pos_z.png",
	"ground_pos_x.png",
	"ground_neg_x.png",
}

local low_orbit_skybox = {
	"low_orbit_pos_y.png",
	"low_orbit_neg_y.png",
	"low_orbit_neg_z.png",
	"low_orbit_pos_z.png",
	"low_orbit_pos_x.png",
	"low_orbit_neg_x.png",
}

local high_orbit_skybox = {
	"high_orbit_pos_y.png",
	"high_orbit_neg_y.png",
	"high_orbit_neg_z.png",
	"high_orbit_pos_z.png",
	"high_orbit_pos_x.png",
	"high_orbit_neg_x.png",
}

local space_skybox = {
	"space_pos_y.png",
	"space_neg_y.png",
	"space_neg_z.png",
	"space_pos_z.png",
	"space_pos_x.png",
	"space_neg_x.png",
}

local timer = 0

minetest.register_globalstep(function(dtime)

	timer = timer + dtime

	if timer < 2 then
		return
	end

	timer = 0

	for _, player in pairs(minetest.get_connected_players()) do

		local name = player:get_player_name()
		local pos = player:getpos()
		local current = player_list[name] or ""

		-- To fix the skybxes, switch pos_x/ neg_x and
		-- rotate pos_y and neg_y twice (180 degrees left or right)
		
		-- Ground
		if pos.y < low_orbit_low and current ~= "ground" then
			player:set_sky({}, "skybox", ground_skybox)
			player_list[name] = "ground"
			player:set_physics_override({gravity = 1})

		-- Low orbit
		elseif pos.y > low_orbit_low and pos.y < low_orbit_high and current ~= "low_orbit" then
			player:set_sky({}, "skybox", low_orbit_skybox)
			player_list[name] = "low_orbit"
			player:set_physics_override({gravity = 0.4})

		-- High orbit
		elseif pos.y > high_orbit_low and pos.y < high_orbit_high and current ~= "high_orbit" then
			player:set_sky({}, "skybox", high_orbit_skybox)
			player_list[name] = "high_orbit"
			player:set_physics_override({gravity = 0.2})

		-- Space
		elseif pos.y > high_orbit_high and current ~= "space" then
			player:set_sky({}, "skybox", space_skybox)
			player_list[name] = "space"
			player:set_physics_override({gravity = 0.1})
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_list[name] = nil
	player:set_physics_override({gravity = 1})
end)