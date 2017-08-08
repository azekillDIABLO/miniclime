--MiniClime v0.2
--W.I.P. version

--fixed variables
local int = 0
local slow_timer = 0
local wind = 0
local weather_force = 10

--lightning mod
lightning.auto = false
lightning.interval_low = 8
lightning.interval_high = 14


local function rain(pos)
	minetest.add_particlespawner({
		amount = 204,
		time = 0.5,
		minpos = {x = pos.x-20, y = pos.y+15, z = pos.z-20},
		maxpos = {x = pos.x+20, y = pos.y+25, z = pos.z+20},
		minvel = {x = 0, y = -6, z = 0},
		maxvel = {x = 0, y = -6, z = 0},
		minacc = {x = wind, y = -38, z = wind},
		maxacc = {x = wind, y = -38, z = wind},
		minexptime = 2,
		maxexptime = 3.5,
		minsize = 5,
		maxsize = 8,
		texture = "miniclime_rain.png",
		vertical = true,
		collisiondetection = true,
		collision_removal = true,
	})
end

local function snow(pos)
	minetest.add_particlespawner({
		amount = 20,
		time = 0.5,
		minpos = {x = pos.x-15, y = pos.y+10, z = pos.z-15},
		maxpos = {x = pos.x+15, y = pos.y+15, z = pos.z+15},
		minvel = {x = wind, y = -1, z = wind},
		maxvel = {x = wind, y = -1, z = wind},
		minacc = {x = 0, y = -0.1, z = 0},
		maxacc = {x = 0, y = -0.5, z = 0},
		minexptime = 6,
		maxexptime = 6,
		minsize = 4,
		maxsize = 5,
		texture = "miniclime_snow.png",
		vertical = true,
		collisiondetection = true,
		collision_removal = true,
	})
end

local function sandstorm(pos)
	minetest.add_particlespawner({
		amount = 15,
		time = 0.5,
		minpos = {x = pos.x-15, y = pos.y-5, z = pos.z-15},
		maxpos = {x = pos.x+15, y = pos.y-1, z = pos.z+15},
		minvel = {x = 0, y = 0, z = 0},
		maxvel = {x = 0, y = 1, z = 0},
		minacc = {x = wind, y = 1, z = wind},
		maxacc = {x = wind, y = 1, z = wind},
		minexptime = 4,
		maxexptime = 4.5,
		minsize = 5,
		maxsize = 8,
		texture = "miniclime_dust.png",
		vertical = false,
		collisiondetection = false,
		collision_removal = true,
	})
end

local function fog(pos)
	minetest.add_particlespawner({
		amount = 15,
		time = 0.5,
		minpos = {x = pos.x-10, y = pos.y+15, z = pos.z-10},
		maxpos = {x = pos.x+10, y = pos.y+15, z = pos.z+10},
		minvel = {x = wind/3, y = -3, z = wind/3},
		maxvel = {x = wind/3, y = -2, z = wind/3},
		minacc = {x = -0.2, y = -0.2, z = -0.2},
		maxacc = {x = 0.2, y = 0.2, z = 0.2},
		minexptime = 6.5,
		maxexptime = 10.5,
		minsize = 47,
		maxsize = 63,
		texture = "miniclime_fog.png",
		vertical = false,
		collisiondetection = true,
		collision_removal = false,
	})
end

local function blizzard(pos)
	minetest.add_particlespawner({
		amount = 32,
		time = 0.3,
		minpos = {x = pos.x-25, y = pos.y+1, z = pos.z-25},
		maxpos = {x = pos.x+25, y = pos.y+10, z = pos.z+25},
		minvel = {x = wind, y = -1, z = wind},
		maxvel = {x = wind, y = -1, z = wind},
		minacc = {x = wind, y = -0.3, z = wind},
		maxacc = {x = wind, y = -1, z = wind},
		minexptime = 4,
		maxexptime = 4,
		minsize = 9,
		maxsize = 19,
		texture = "miniclime_snow.png",
		vertical = true,
		collisiondetection = true,
		collision_removal = false,
	})
end

local function thunder(pos)
	minetest.add_particlespawner({
		amount = 240,
		time = 0.5,
		minpos = {x = pos.x-20, y = pos.y+15, z = pos.z-20},
		maxpos = {x = pos.x+20, y = pos.y+25, z = pos.z+20},
		minvel = {x = 0, y = -10, z = 0},
		maxvel = {x = 0, y = -10, z = 0},
		minacc = {x = wind, y = -38, z = wind},
		maxacc = {x = wind, y = -38, z = wind},
		minexptime = 2.5,
		maxexptime = 3.5,
		minsize = 8,
		maxsize = 10,
		texture = "miniclime_rain.png",
		vertical = true,
		collisiondetection = true,
		collision_removal = true,
	})
	lightning.auto = true
end

--active weather
minetest.register_globalstep(function(time_of_day)
	--variable change
	int = int+0.1
	slow_timer = int
	wind = wind+math.random(-0.1,0.1)
	
	if wind > 1 then
		wind = wind-0.2
	end
	
	if wind < -1 then
		wind = wind+0.2
	end
	
	if slow_timer == 300 then
		slow_timer = 0
		weather_force = math.random(0,100)

		if weather_force > 100 then
			weather_force = 100
		elseif weather_force < 0 then
			weather_force = 0
		end
	end
		
	--weather change
	if int > 3 then
		if weather_force > 63 then
			int = 0
			for _, player in ipairs(minetest.get_connected_players()) do
				local pos = player:getpos()
				local nodepos = {x = pos.x+math.random(-10,10), y=pos.y, z = pos.z+math.random(-10,10)}
				if nodepos.y > 0 then
					local time_of_day = minetest.get_timeofday()*24000
					
--day weather =============================================================================================================					
					if time_of_day < 18000 and time_of_day > 6000 then
						lightning.auto = false
						for i=0,60,1 do
							local node = minetest.get_node({x=nodepos.x, y=nodepos.y-i, z=nodepos.z})
								
							--rain on grass and rainforest-litter
							if node.name == "default:dirt_with_rainforest_litter" or node.name == "default:dirt_with_grass" then
								rain(pos)
								minetest.sound_play("rain_drop", {pos = pos, gain = 0.2, max_hear_distance = 10})
							end 
							
							--snow on snow (obliviously)
							if node.name == "default:snow" or node.name == "default:dirt_with_snow" or node.name == "default:snowblock" then
								snow(pos)
							end
								
							--sandstorm on desert sand
							if node.name == "default:desert_sand" or node.name == "default:dirt_with_dry_grass" then
								sandstorm(pos)
								minetest.sound_play("wind", {pos = pos, gain = 0.1, max_hear_distance = 10})
							end
						end
--night weather =============================================================================================================
					else 
						for i=0,60,1 do
							local node = minetest.get_node({x=nodepos.x, y=nodepos.y-i, z=nodepos.z})
							--fog on grass
							if pos.y < 32 or pos.y < 312 then
								if node.name == "default:air" or node.name == "default:water_source" then
									fog(pos)
									minetest.sound_play("light_rain_drop", {pos = pos, gain = 0.2, max_hear_distance = 10})
								end
							end
						
							--blizzard
							if node.name == "default:snow" or node.name == "default:dirt_with_snow" or node.name == "default:snowblock" then
								blizzard(pos)
								minetest.sound_play("wind", {pos = pos, gain = 0.1, max_hear_distance = 10})
							end
						
							--thunderstorm on grass and rainforest-litter
							if node.name == "default:dirt_with_dry_grass" or node.name == "default:dirt_with_grass" then
								thunder(pos)
								minetest.sound_play("heavy_rain_drop", {pos = pos, gain = 0.2, max_hear_distance = 10})
								minetest.sound_play("wind", {pos = pos, gain = 0.1, max_hear_distance = 10})
							end
						end
					end
				end
			end
		else -- stop lightning
			lightning.auto = false
		end
	end
end)

minetest.register_chatcommand("roll_weather", {
	params = "<value>",
	privs = {settime=true},
	description = "Allow parameting weather.",
	func = function(name, param)
		local value = tonumber(param)
		if value == nil then
			weather_force = math.random(0, 100)
			minetest.debug("[miniclime] weather_force set to " .. weather_force)
		else
			weather_force = value
			minetest.debug("[miniclime] weather_force set to " .. weather_force)
		end
	end,
})
