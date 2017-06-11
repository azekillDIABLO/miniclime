--MiniClime v0.2
--W.I.P. version

--fixed variables
int = 0
wind = 0
node = ""
yes_or_no = 1

--get player
minetest.register_on_joinplayer(function(player)
	local PLAYER = player:get_player_name(player)
	minetest.setting_set("PLAYER", PLAYER)
end)

--active weather
minetest.register_globalstep(function(time_of_day)
		--variable change
		int = int+0.1
		wind = wind+math.random(-0.1,0.1)
		
		if wind > 1 then
			wind = wind-0.2
		end
		
		if wind < -1 then
			wind = wind+0.2
		end
		
		--weather change
		if int > 2 then
			
			yes_or_no = yes_or_no+math.random(-10,10)

			if yes_or_no > 50 or yes_or_no < -50 then
			
				int = 0
				local PLAYER = minetest.setting_get("PLAYER")
				local obj = minetest.get_player_by_name(PLAYER)
				local pos = obj:getpos()
				
				if pos.y > 0 then
					local time_of_day = minetest.get_timeofday()*24000
					
					if time_of_day < 17000 and time_of_day > 7000 then

--day weather =============================================================================================================
						for i=0,60,1 do
							node = minetest.get_node({x=pos.x, y=pos.y-i, z=pos.z})
							--rain on grass and rainforest-litter
							if node.name == "default:dirt_with_rainforest_litter" or node.name == "default:dirt_with_grass" then
								minetest.add_particlespawner({
									amount = 24,
									time = 0.5,
									minpos = {x = pos.x-20, y = pos.y+15, z = pos.z-20},
									maxpos = {x = pos.x+20, y = pos.y+25, z = pos.z+20},
									minvel = {x = 0, y = -1, z = 0},
									maxvel = {x = 0, y = -1, z = 0},
									minacc = {x = wind, y = -10, z = wind},
									maxacc = {x = wind, y = -10, z = wind},
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
							
							--snow on snow (obliviously)
							if node.name == "default:snow" or node.name == "default:dirt_with_snow" or node.name == "default:snowblock" then
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
							
							--sandstorm on desert sand
							if node.name == "default:desert_sand" or node.name == "default:dirt_with_dry_grass" then
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
						end
						
					else
--night weather =============================================================================================================

						for i=0,60,1 do
							node = minetest.get_node({x=pos.x, y=pos.y-i, z=pos.z})
							--fog on grass
							if pos.y < 32 then
								if node.name == "default:dirt_with_grass" or node.name == "default:dirt_with_dry_grass" then
									minetest.add_particlespawner({
										amount = 15,
										time = 0.5,
										minpos = {x = pos.x-10, y = pos.y+1, z = pos.z-10},
										maxpos = {x = pos.x+10, y = pos.y+4, z = pos.z+10},
										minvel = {x = wind/3, y = math.random(-1,1), z = wind/3},
										maxvel = {x = wind/3, y = math.random(-1,1), z = wind/3},
										minacc = {x = math.random(-0.2,0.2), y = math.random(-0.2,0.2), z = math.random(-0.2,0.2)},
										maxacc = {x = math.random(-0.2,0.2), y = math.random(-0.2,0.2), z = math.random(-0.2,0.2)},
										minexptime = 4,
										maxexptime = 6.5,
										minsize = 47,
										maxsize = 63,
										texture = "miniclime_fog.png",
										vertical = false,
										collisiondetection = true,
										collision_removal = false,
									})
								end
							end
							
							--blizzard
							if node.name == "default:snow" or node.name == "default:dirt_with_snow" or node.name == "default:snowblock" then
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
						end
					end
				end
			else
				return nil
			end
		end
end)