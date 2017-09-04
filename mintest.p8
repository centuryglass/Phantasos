pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- variant 1.6.7 by sulai
-- original game by makiki99



map_size=34
dir={{x=-1,y=0},{x=1,y=0},{x=0,y=-1},{x=0,y=1} }
rnd_seed = rnd(30000)
music(0,0,13)
names = {
	[1] = "land",
	[2] = "shallow water",
	[3] = "mountains",
	[4] = "deep water",
	[5] = "core",
	[17] = "coal burner",
	[19] = "quarry",
	[20] = "sea purifier ii",
	[21] = "active core",
	[33] = "solar panel",
	[34] = "hydropower plant",
	[35] = "coal mine",
	[36] = "oil extractor",
	[49] = "land purifier",
	[50] = "coast purifier",
	[51] = "mountain purifier",
	[52] = "sea purifier",
	[65] = "oil burner",
	[73] = "transport",
	[74] = "transport",
	[75] = "transport",
	[76] = "transport",
	[97] = "coal burner (off)",
	[99] = "quarry (off)",
	[100] = "oil extr. (off)",
	[113] = "oil burner (off)",
	[115] = "coal mine (off)"
}

building_groups = {
	{33,34,0,0},
	{49,50,51,52},
	{73,74,75,76}
}

active2inactive = {
	[17] = 97,
	[19] = 99,
	[21] = 5,
	[36] = 100,
	[65] = 113,
	[35] = 115,
}

function get_inactive_building(b)
	if(active2inactive[b]==nil) then
		return b
	end
	return active2inactive[b]
end

function get_active_building(b)
	for active, inactive in pairs(active2inactive) do
		if(inactive==b) then
			return active
		end
	end
	return b
end

function is_active(x,y)
	local b = mget(x,y)
	if is_purifier(b) then
		return transport:is_input_satisfied(x,y)
	end
	if b==5 then return false end
	return b<97 or b>115
end

build_list = {
	{33,17,65,49,73} ,
	{34,50,74}       ,
	{19,35,51,75}    ,
	{36,52,20,76}    ,
}

selected_building = {}
for i=1,4 do selected_building[i]=0 end

effects = {
	[5]  = {0,0,0,0},
	[21]  = {0,-10,-10,0},
	[17] = {0,-1,0,4},
	[19] = {1/80,0,0,-1},
	[20] = {0,0,0,0},
	[33] = {0,0,0,1},
	[34] = {0,0,0,1},
	[35] = {0,1,0,-1},
	[36] = {0,0,1,-1},
	[49] = {0,0,0,-3},
	[50] = {0,0,0,-6},
	[51] = {0,0,0,-6},
	[52] = {0,0,0,-9},
	[65] = {0,0,-3,9 },
	[73] = {0,0,0,0},
	[74] = {0,0,0,0},
	[75] = {0,0,0,0},
	[76] = {0,0,0,0},
	[97] = {0,0,0,0},
	[99] = {0,0,0,0},
	[100]= {0,0,0,0},
	[113]= {0,0,0,0},
	[115]= {0,0,0,0 },
}


costs = {
	[17] = 20 ,
	[19] = 20 ,
	[20] = 800,
	[33] = 20 ,
	[34] = 10 ,
	[35] = 20 ,
	[36] = 10 ,
	[49] = 40 ,
	[50] = 60 ,
	[51] = 60 ,
	[52] = 80 ,
	[65] = 50 ,
	[73] = 2  ,
	[74] = 4  ,
	[75] = 6  ,
	[76] = 6  ,
}
for b in all({97,99,100,113,115}) do
	costs[b] = costs[get_active_building(b)]
end

descriptions = {
	[17] = { "converts coal to energy.", "" },
	[19] = { "generates 1 unit of",      "minerals every 5 seconds." },
	[20] = { "purifies nearby cells.",   "and potential outposts." },
	[33] = { "generates energy.",        "" },
	[34] = { "generates energy.",        "" },
	[35] = { "generates coal.",          "" },
	[36] = { "generates oil.",           "" },
	[49] = { "purifies nearby cells.",   "very effective." },
	[50] = { "purifies nearby cells.",   "very effective." },
	[51] = { "purifies nearby cells.",   "" },
	[52] = { "purifies nearby cells.",   "" },
	[65] = { "converts oil to energy.",  "" },
	[73] = { "transport on land.",       "roads, pipes and electr." },
	[74] = { "transport in water.",      "ship routes and electr." },
	[75] = { "transport in mountains.",  "needs oil for trucks." },
	[76] = { "transport in deep water.", "needs coal for ships." },
}

function _init()
	gamestate = 0
	cursor_x = map_size/2
	cursor_y = map_size/2
	minerals = 100
	coal = 0
	oil = 0
	energy = 0
	purecount = 0
	tilecount = {}
	build_select = 0
	build_type = 0
	hours = 0
	minutes = 0
	seconds = 0
	frames = 0
	time_str = "0:00:00"
	final_time = "99:59:59"
	x_pressed=0
	idle=0
	mode = 0
	msg_res = 0
	msg_str = ""
	update_corruption()
	recount()
	menuitem(4, "music off", function() music(-1) menuitem(4) end)
end


rnames = { "minerals", "coal", "oil", "energy" }

resources = {minerals=0, coal=0, oil=0, energy=0 }
function resources:new(res)
	if res==nil then
		res = {}
	elseif res[1] or res[2] or res[3] or res[4] then
		res = {minerals= res[1] or 0, coal= res[2] or 0, oil= res[3] or 0, energy= res[4] or 0 }
	end
	setmetatable(res, self)
	self.__index = self
	return res
end
function resources.__add(e1, e2)
	return resources:new({
		minerals = e1.minerals+e2.minerals,
		coal = e1.coal+e2.coal,
		oil = e1.oil+e2.oil,
		energy = e1.energy+e2.energy
	})
end
function resources.__sub(e1, e2)
	return resources:new({
		minerals = e1.minerals-e2.minerals,
		coal = e1.coal-e2.coal,
		oil = e1.oil-e2.oil,
		energy = e1.energy-e2.energy
	})
end
function resources.__lt(e1, e2)
	return
			e1.minerals < e2.minerals and
			e1.coal < e2.coal and
			e1.oil < e2.oil and
			e1.energy < e2.energy
end
function resources.__le(e1, e2)
	return
			e1.minerals <= e2.minerals and
			e1.coal <= e2.coal and
			e1.oil <= e2.oil and
			e1.energy <= e2.energy
end
function resources.__eq(e1, e2)
	return
			e1.minerals == e2.minerals and
			e1.coal == e2.coal and
			e1.oil == e2.oil and
			e1.energy == e2.energy
end
function resources:tostring()
	return
			" energy: "..self.energy..
			" coal: "..self.coal..
			" oil: "..self.oil..
			" minerals: "..self.minerals
end
function resources:tostringneeds()
	local str = ""
	if self.energy < 0 then str=str.." "..-self.energy.." energy" end
	if self.coal   < 0 then str=str.." "..-self.coal.." coal" end
	if self.oil    < 0 then str=str.." "..-self.oil.." oil" end
	return str
end
function resources:tores()
	return {self.minerals, self.coal, self.oil, self.energy}
end
function resources:get_color(r)
	if r==nil then
		r = self:getindex()
	end
	if r==1 then return 5 end
	if r==2 then return 4 end
	if r==3 then return 12 end
	if r==4 then return 9 end
	return 7
end
function resources:getindex()
	local res = self:tores()
	for i=1,4 do
		if res[i]~=0 then return i end
	end
	return nil
end



tools = {}
function tools.new_table_2d(w,h,fn_value)
	local table = {}
	for x=0,w-1 do
		table[x] = {}
		for y=0,h-1 do
			table[x][y]=fn_value(x,y)
		end
	end
	return table
end

local function has_value (tab, val)
	for _,value in pairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function tools.find_path(x, y, limit, accept_child, accept_target)

	local start = stat(1)

	local targets = {}
	local visited = {}

	local stack = {}
	local read = 0
	local write = 0
	write=write + 1  stack[write] = {x,y}
	visited[x..","..y] = true

	while write > read do

		read=read + 1  local coord = stack[read]
		local vx = coord[1]
		local vy = coord[2]

		if accept_target(vx,vy) then
			add(targets,{x=vx, y=vy })
			if #targets==limit then
				return targets
			end
		end

		for d in all(dir) do

			local cx = (vx+d.x)%map_size
			local cy = (vy+d.y)%map_size
			if not visited[cx..","..cy] then
				visited[cx..","..cy]=true
				if accept_child(cx,cy) then
					write=write + 1  stack[write] = { cx, cy }
				end
			end
		end
	end


	return targets
end

function tools.copy(table)
	copy = {}
	for k,v in pairs(table) do
		copy[k] = v
	end
	return copy
end


transport = {

	connections = tools.new_table_2d(map_size,map_size,function () return {
		input = {},

		output = {},
	} end),

	valid = function(x,y,v)
		if v~=nil then
			v = v and 1 or 0
			poke(0x4300+y*map_size+x, v)
		else
			v = peek(0x4300+y*map_size+x)
			return v~=0
		end

	end,

	conducted_resource = {}

}

function transport:invalidate_deep(x,y,r,only_inactive)
	local targets = tools.find_path(x, y, 9999,
			function(cx,cy)
				if r~=nil then
					return self:conducts(nil,cx,cy,r)
				end
				for r=1,4 do
					if self:conducts(nil,x,y, r) and self:conducts(nil,cx,cy,r) then
						return true
					end
				end
				return false
			end,
			function(tx, ty)
				if only_inactive then return not is_active(tx,ty) end
				return true
			end
	)
	for t in all(targets) do
		self.valid(t.x,t.y,false)
	end
end

function transport:conducts_any(only_type, x,y)
	for r=2,4 do
		if self:conducts(only_type,x,y, r) then
			return true
		end
	end
end

function transport:conducts(only_type, x,y, resource)

	local tile = mget(x,y)

	if tile>=73 and tile<=76 then
		return self.conducted_resource[x..","..y]==resource
	end

	if tile>=5 then
		if effects[get_active_building(tile)][resource]>0 then return true end
		return only_type ==nil or effects[get_active_building(tile)][resource] < 0 and
				get_active_building(only_type)==get_active_building(tile)
	end
	return false
end

function is_transport(tile)
	return tile>=73 and tile<=76
end

function transport:update()
	if self.ux==nil then
		self.ux = map_size
		self.uy = map_size
		self.udx = 8
		self.udy = 4
		self.uo = self.udx
		self.uo2 = {map_size,map_size}
		self.uti = 0
		self.offset = {
			{0,0},{4,2},{6,1},{2,1},{2,3},{6,3},{4,0},{0,2},
			{1,0},{5,2},{7,1},{3,1},{3,3},{7,3},{5,0},{1,2},

			{0,1},{4,3},{6,2},{2,2},{2,0},{6,0},{4,1},{0,3},
			{1,1},{5,3},{7,2},{3,2},{3,0},{7,0},{5,1},{1,3},
		}
	end

	local sub_cycle_finished=false
	while true do
		self.ux=self.ux + self.udx
		self.uy=self.uy + self.udy
		if self.ux >= map_size then self.ux = self.ux%map_size end
		if self.uy >= map_size then
			self.uo2[1]=self.uo2[1] + self.udx

			if self.uo2[1] >= map_size then
				sub_cycle_finished = true
				self.uti=self.uti + 1
				if self.uti>#self.offset then self.uti=1 end
				self.uo2 = {self.offset[self.uti][1],self.offset[self.uti][2]}
			end

			self.ux = self.uo2[1]
			self.uy = self.uo2[2]
		end

		local success = self:update_at(self.ux, self.uy)
		if success or sub_cycle_finished then
			return
		end
	end
end

function transport:update_at(x, y)

	if self.valid(x,y) then return false end
	self.valid(x,y,true)

	local b = mget(x,y)
	if b<5 or b==16 then
		self:disconnect_all_inputs(x,y)
		return false
	elseif is_transport(b) and transport.conducted_resource[x..","..y]==nil then
		if self:set_conducted_resource(x,y) then
			self:invalidate_deep(x,y)
		end
	elseif not is_active(x,y) then
		local used_path_finding = self:create_input_connections(x,y)
		if self:is_input_satisfied(x,y) then
			if is_purifier(b) then
				update_corruption()
			else
				mset(x, y, get_active_building(b))
				recount()
				if b==5 then
					sfx(10)
					msg_str="purifier cluster core online!"
					msg_res=200
				end
				for r=1,4 do
					if effects[mget(x,y)][r]>0 then
						self:invalidate_deep(x,y,r)
					end
				end
			end
		end
		return used_path_finding
	else
		local used_path_finding = self:check_input_connections(x,y)
		if not self:is_input_satisfied(x,y) then
			used_path_finding = transport:create_input_connections(x,y) or used_path_finding
			if not self:is_input_satisfied(x,y) then
				self.valid(x,y,false)
				if is_purifier(b) then
					update_corruption()
				else
					mset(x, y, get_inactive_building(b))
					recount()

					if b==5 then
						sfx(11)
						msg_str="cluster core down!"
						msg_res=100
					end

					if(is_transport(b)) then
						self:invalidate_deep(x,y)
					end
					for _,consumer in pairs(self.connections[x][y].output) do
						self.valid(consumer.x,consumer.y,false)
					end

				end
			end
		end
		return used_path_finding
	end

	return false
end

function transport:create_input_connections(x,y)


	local netto_effects = self:get_input_needs(x,y)
	if netto_effects >= resources:new() then
		return false
	end

	local used_path_finding=false
	for r=1,4 do
		local requirement = -netto_effects:tores()[r]

		if requirement > 0 then
			used_path_finding=true
			local supplier = tools.find_path(x, y, requirement,
					function(cx,cy)
						local accept = self:conducts(mget(x,y),cx,cy,r)
						return accept
					end,
					function (tx,ty)
						return self:get_free_capacity(tx,ty, r) > 0
					end
			)
			while requirement>0 and #supplier>0 do


				local s = supplier[1]
				del(supplier, s)
				local transfer = min(self:get_free_capacity(s.x,s.y, r), requirement)
				requirement=requirement - transfer

				self.connections[x][y].input[s.x..","..s.y] = s
				self.connections[s.x][s.y].output[x..","..y] = {x=x,y=y,r=r,c=transfer }
			end
		end
	end
	return used_path_finding
end

function transport:check_input_connections(x,y)
	local used_path_finding=false
	for _,supplier in pairs(self.connections[x][y].input) do

		local supplier_output_table = self.connections[supplier.x][supplier.y].output
		local supplier_output = supplier_output_table[x..","..y]
		local res = {0,0,0,0} res[supplier_output.r] = supplier_output.c
		local r = supplier_output.r

		used_path_finding=true
		local targets = tools.find_path(x,y,1,
			function(cx,cy)
				return self:conducts(mget(x,y),cx,cy,r)
			end,
			function(cx,cy)
				return cx==supplier.x and cy==supplier.y
			end
		)

		if #targets==0 then
			self:disconnect(supplier, {x=x,y=y})
		end

	end
	return used_path_finding
end

function transport:disconnect(supplier, consumer)
	self.connections[consumer.x][consumer.y].input[supplier.x..","..supplier.y]=nil
	self.connections[supplier.x][supplier.y].output[consumer.x..","..consumer.y]=nil
	self:invalidate_deep(supplier.x, supplier.y)
	self.valid(consumer.x,consumer.y,false)
end

function transport:disconnect_all_inputs(x,y)
	local this_consumer={x=x,y=y }
	for _,supplier in pairs(self.connections[x][y].input) do
		self:disconnect(supplier, this_consumer)
	end
end

function transport:disconnect_all_outputs(x,y)
	local this_producer ={x=x,y=y }
	for _,output in pairs(self.connections[x][y].output) do
		self:disconnect(this_producer, output)
	end
end

function transport:get_free_capacity(x,y, r)
	local b = mget(x, y)
	return effects[b][r] - self:get_total_output(x,y):tores()[r]
end

function transport:has_capacity(x,y)
	if mget(x,y)<=5 then
		return false
	end
	for r=2,4 do
		if self:get_free_capacity(x,y,r)>0 then
			return true
		end
	end
end

function transport:get_total_output(x,y)
	local total = resources:new()
	for _,out in pairs(self.connections[x][y].output) do
		total=total + resources:new({[out.r]=out.c})
	end
	return total
end

function transport:get_total_input(x,y)
	local total = resources:new()
	for _,supplier in pairs(self.connections[x][y].input) do
		local out = self.connections[supplier.x][supplier.y].output[x..","..y]
		total=total + resources:new({[out.r]=out.c})
	end
	return total
end

function transport:is_input_satisfied(x,y)
	if mget(x,y) <5 then return true end
	return self:get_input_needs(x,y) >= resources:new()
end

function transport:get_input_needs(x,y)
	if mget(x,y) <5 then return resources:new() end
	return self:get_total_input(x,y) + get_active_building_effects(x,y)
end

function transport:get_connection_resource(supplier, consumer)
	local out=self.connections[supplier.x][supplier.y].output[consumer.x..","..consumer.y]
	return resources:new({[out.r]=out.c})
end

function transport:set_conducted_resource(x,y, hintx, hinty)
	if not is_transport(mget(x,y)) then return end


	if hintx~=nil and self:set_conducted_resource_of_transport(x,y,hintx,hinty) then
		return true
	end
	if hintx~=nil and self:set_conducted_resource_of_producer(x,y,hintx,hinty) then
		return true
	end

	for d in all(dir) do
		local dx = (x+d.x)%map_size
		local dy = (y+d.y)%map_size
		if self:set_conducted_resource_of_transport(x,y,dx,dy) then
			return true
		end
	end

	for d in all(dir) do
		local dx = (x+d.x)%map_size
		local dy = (y+d.y)%map_size
		if self:set_conducted_resource_of_producer(x,y,dx,dy) then
			return true
		end
	end
	return false
end

function transport:set_conducted_resource_of_transport(x,y,dx,dy)
	if is_transport(mget(dx,dy)) then
		local r = self.conducted_resource[dx..","..dy]
		if r~=nil and r>0 then
			self.conducted_resource[x..","..y] = r
			self:invalidate_neighbor_transport(x,y)
			return true
		end
	end
	return false
end

function transport:set_conducted_resource_of_producer(x,y,dx,dy)
	local res = get_active_building_effects(dx,dy):tores()
	for r=2,4 do
		if res[r]>0 then
			self.conducted_resource[x..","..y] = r
			self:invalidate_neighbor_transport(x,y)
			return true
		end
	end
	return false
end

function transport:invalidate_neighbor_transport(x,y)
	for d in all(dir) do
		local dx = (x + d.x) % map_size
		local dy = (y + d.y) % map_size
		if is_transport(mget(dx,dy)) then
			self.valid( dx, dy, false)
		end
	end

end

function get_active_building_effects(x,y)
	local b = get_active_building(mget(x,y))
	if b>=5 then
		return resources:new(effects[b]);
	end
	return resources:new()
end

function destroy(x,y)
	local tile = mget(x,y)
	mset(x,y,tile%8)
	transport.valid(x,y,false)
	transport.conducted_resource[x..","..y]=nil
	if is_purifier(tile) then
		update_corruption()
	end
end

function is_purifier(tile)
	return tile >= 49 and tile <= 52 or tile==20
end

function recount()
	for i=1,115 do
		tilecount[i]=0
	end
	for x=0,map_size-1 do
		for y=0,map_size-1 do
			tilecount[mget(x,y)] = tilecount[mget(x,y)] + 1
		end
	end
	local effect_sum = {0,0,0,0 }
	total_energy=0
	total_coal=0
	total_oil=0
	for k,v in pairs(effects) do
		for i=1,4 do
			local tile_effect = effects[k][i]*tilecount[k]
			effect_sum[i]=effect_sum[i] + tile_effect
			if i==4 and tile_effect>0 then
				 total_energy=total_energy + tile_effect
			end
			if i==2 and tile_effect>0 then
				 total_coal=total_coal + tile_effect
			end
			if i==3 and tile_effect>0 then
				 total_oil=total_oil + tile_effect
			end
		end
	end
	disp_coal = effect_sum[2]
	disp_oil = effect_sum[3]
	disp_energy = effect_sum[4]
	purecount = 0
	for x=0,map_size-1 do
		for y=0,map_size-1 do
			if
				mget(x+map_size,y)==0
			then
				purecount=purecount + 1
			end
		end
	end
	mineral_gain = effect_sum[1]
	coal = effect_sum[2]
	oil = effect_sum[3]
	energy = effect_sum[4]
	if purecount == map_size*map_size and not end_screen_shown then
		end_screen_shown=true
		mode = -1
		final_time = time_str
	end
end

function update_res()
	minerals=minerals + mineral_gain
	if minerals>10000 then
		 minerals=10000
	end
end

function update_corruption()
	for x=0,map_size-1 do
		for y=0,map_size-1 do
			mset(x+map_size,y,16)
		end
	end
	for x=0,map_size-1 do
		for y=0,map_size-1 do
			if
				mget(x,y)==5 or mget(x,y)==21
			then
				for xx=-4,4 do
					for yy=-4,4 do
						mset((x+xx)%map_size+map_size,(y+yy)%map_size,0)
					end
				end
				if mget(x,y)==21 then
					update_corruption_active_core(x,y)
				end
			elseif
				mget(x,y)==49 or
				mget(x,y)==50
			then
				if transport:is_input_satisfied(x,y) then
					for xx=-2,2 do
						for yy=-2,2 do
							mset((x+xx)%map_size+map_size,(y+yy)%map_size,0)
						end
					end
				end
			elseif
				mget(x,y)==51 or
				mget(x,y)==52
			then
				if transport:is_input_satisfied(x,y) then
					for xx=-1,1 do
						for yy=-1,1 do
							mset((x+xx)%map_size+map_size,(y+yy)%map_size,0)
						end
					end
				end
			elseif
				mget(x,y)==20
			then
				if transport:is_input_satisfied(x,y) then
					for xx=-1,1 do
						for yy=-1,1 do
							mset((x+xx)%map_size+map_size,(y+yy)%map_size,0)
						end
					end
					local outposts = {-3, 3 }
					for xx in all(outposts) do
						for yy in all(outposts) do
							mset((x+xx)%map_size+map_size,(y+yy)%map_size,0)
						end
					end
				end
			end
		end
	end
	local destroyed=0
	for x=0,map_size-1 do
		for y=0,map_size-1 do
			if (mget(x+map_size,y)==16) then
				if mget(x,y)>5 then
					destroyed=destroyed + 1
				end
				destroy(x,y)
				transport:disconnect_all_inputs(x,y)
				transport:disconnect_all_outputs(x,y)
			end
		end
	end
	recount()
	if destroyed>0 then
		msg_str = destroyed.." units destroyed"
		msg_res = 60
	end
end

function update_corruption_active_core(x,y)

	local purifiers = find_active_purifiers(x,y)

	for p in all(purifiers) do
		local r=2 local d=2*r+1
		local dx = x+(p.x-x)*d;
		local dy = y+(p.y-y)*d;
		for xx=-r,r do
			for yy=-r,r do
				mset((dx+xx)%map_size+map_size,(dy+yy)%map_size,0)
			end
		end
	end

end

function find_active_purifiers(x,y)
	return tools.find_path(x,y,100,
			function(cx,cy)
				return is_purifier(mget(cx,cy))
			end,
			function(tx,ty)
				return transport:is_input_satisfied(tx,ty)
			end
	)
end
function update_time()
	frames=frames + 1
	if (frames>=30) then
		seconds=seconds + 1
		frames=frames - 30
	end
	if (seconds>=60) then
		minutes=minutes + 1
		seconds=seconds - 60
	end
	if (minutes>=60) then
		hours=hours + 1
		minutes=minutes - 60
	end
	time_str = ""..seconds
	if #time_str < 2 then
		 time_str = "0"..time_str
	end
	time_str = minutes..":"..time_str
	if #time_str < 5 then
		 time_str = "0"..time_str
	end
	time_str = hours..":"..time_str
end

function get_frame_time()
	return time_str.."."..frames
end
function save_game()
	cstore(0x1000,0x1000,0x2000,"savegame")
	cstore(0x0000,0x5e00,0xff,"savegame")
	dset(i,minerals)
end
function load_game()
	start_game()
	reload(0x1000,0x1000,0x2000,"savegame")
	reload(0x5e00,0x0000,0xff,"savegame")
	minerals=dget(i)
	for x=0,map_size-1 do
		for y=0,map_size-1 do
			if is_purifier(mget(x,y)) then
				transport:create_input_connections(x,y)
			end
		end
	end
end
function start_game()
	_init()
	srand(rnd_seed)
	map_generate()
	update_corruption()
	gamestate = 1
end
function _update()

	if gamestate == 0 then
		if btnp(4) or btnp(5) then
			start_game()
		end
	elseif gamestate == 1 then
		transport:update()
	  if mode==0 then
		idle=idle + 1;
	  	if btnp(0) or btnp(1) or btnp(2) or btnp(3) then
			last_cursor_x=cursor_x
			last_cursor_y=cursor_y
			idle=0;
		end
		if btnp(0) then
			cursor_x=cursor_x - 1
		end
		if btnp(1) then
			cursor_x=cursor_x + 1
		end
		if btnp(2) then
			cursor_y=cursor_y - 1
		end
		if btnp(3) then
			cursor_y=cursor_y + 1
		end
		cursor_x=cursor_x % map_size
		cursor_y=cursor_y % map_size

		if btn(5) then
			 x_pressed=x_pressed + 1
		end
		if not btn(5) then
			 x_pressed=0
		end

		if btn(4) or btn(5) then
		 	local tile = mget(cursor_x,cursor_y)
		 	if
		 		mget(cursor_x+map_size,cursor_y)==0 and
		 		tile < 5
		 	then
		 		if btnp(4) then
					open_build_dialog()
				elseif x_pressed>0 then
			 		if selected_building[tile]~=0 then
				 		map_construct(cursor_x,cursor_y,selected_building[tile])
				 	else
				 		msg_str = "press o to build"
				 		msg_res=60
				 	end
				 end
		 	elseif tile>5 and tile~=21 then
		 		if btnp(4) then
			 		mode = 2
			 		msg_res = 0
			 		build_type = get_land_of_tile(tile)
				elseif btnp(5) then
					if is_transport(mget(cursor_x, cursor_y)) then
						sfx(12)
						local r = transport.conducted_resource[cursor_x..","..cursor_y]
						if r==nil then r=1 end
						r=r+1 if r>4 then r=2 end
						transport.conducted_resource[cursor_x..","..cursor_y] = r
						transport:invalidate_neighbor_transport(cursor_x,cursor_y)
					end
					selected_building[get_land_of_tile(tile)] = get_active_building(tile)
					select_building_group(tile)
				end
		 	end
		 end
		 if msg_res>0 then
		 	 msg_res=msg_res - 1
		 end
	 elseif mode==1 then
	 	if btnp(0) then
			sfx(14)
	 		build_select=build_select - 1
	 	end
	 	if btnp(1) then
			sfx(14)
	 		build_select=build_select + 1
	 	end
	 	build_select = (build_select-1)%(#build_list[build_type])+1
	 	local b = build_list[build_type][build_select]
	 	if btnp(4) then
			selected_building[build_type]=b
			select_building_group(b)
	 	    map_construct(cursor_x,cursor_y,b)
	 		if mode > 0 then
	 			 mode = 0
	 		end
	 	end
	 	if btnp(5) then
	 		mode = 0
			x_pressed=-10
	 	end
		elseif mode==2 then
			if btnp(4) then
				sfx(13)
				minerals=minerals + costs[mget(cursor_x,cursor_y)]/2
				transport:invalidate_deep(cursor_x,cursor_y)

				local consumer = tools.copy(transport.connections[cursor_x][cursor_y].output)
				transport:disconnect_all_inputs(cursor_x,cursor_y)
				transport:disconnect_all_outputs(cursor_x,cursor_y)
				destroy(cursor_x,cursor_y)

				for _,c in pairs(consumer) do
					transport:create_input_connections(c.x,c.y)
				end

				mode = 0
				update_corruption()
				recount()
			end
			if btnp(5) then
				mode = 0
				x_pressed=-10
			end
		elseif mode==3 then
		  if btnp(4) or btnp(5) then
			  mode = 0
			  x_pressed=-10
		  end
		elseif mode==-1 then
		  if btnp(4) and btnp(5) then
			  mode = 0
			  x_pressed=-10
		  end
		end
		update_res()
		update_time()
	end
end

function select_building_group(tile)
	for group in all(building_groups) do
		if has_value(group, get_active_building(tile)) then
			for land,b in pairs(group) do
				if b>0 then
					selected_building[land] = b
				end
			end
		end
	end
end

function _draw()
	local start = stat(1)
	cls()
	if gamestate == 0 then
		srand(32)
		sspr(49,0,47,7,40,10)
		sspr(49,8,65,7,31,20)
		for i=1,12 do
			pset(rnd(64)+32,rnd(48)+40,6)
		end
		sspr(112,0,16,16,56,56)
		print(
			"press \x8e or \x97 to start",
			19,96,7
		)
		print(
			"a game made for ld38 by makiki",
			5,122,5
		)
	elseif gamestate == 1 then
		draw_map()
		if mode == 1 then
			rectfill(12,12,115,40,0)
			rect(12,12,115,40,7)
			local str = names[build_list[build_type][build_select]]
			print(str,65-#str*2,14)
			print("\x8b",46,24)
			print("\x91",75,24)
			local b = build_list[build_type][build_select]
			spr(b,60,22)
			print(
				"\x8e - build \x97 - cancel",
				19,34
			)
			draw_resources()
			rectfill(73,45,115,72,0)
			rect(73,45,115,72,7)
			print("gains",75,47)
			print("energy "..effects[b][4],75,54)
			print("coal   "..effects[b][2],75,60)
			print("oil    "..effects[b][3],75,66)
			rectfill(73,72,115,80,0)
			rect(73,72,115,80,7)
			spr(32,75,72)
			print(-costs[b],99,74,7)
			rectfill(12,85,115,99,0)
			rect(12,85,115,99,7)
			print(descriptions[b][1],14,87)
			print(descriptions[b][2],14,93)
		elseif mode == 2 then
			rectfill(12,12,115,40,0)
			rect(12,12,115,40,7)
			print(
				"do you really want to",
				23,17
			)
			print(
				"destroy this building?",
				21,23
			)
			print(
				"\x8e - yes \x97 - no",
				33,34
			)
			draw_resources()
			rectfill(73,45,115,72,0)
			rect(73,45,115,72,7)
			print("gains",75,47)
			local b = mget(cursor_x,cursor_y)
			print("energy "..-effects[b][4],75,54)
			print("coal   "..-effects[b][2],75,60)
			print("oil    "..-effects[b][3],75,66)
			rectfill(73,72,115,80,0)
			rect(73,72,115,80,7)
			spr(32,75,72)
			print(costs[b]/2,103,74,7)
		elseif mode==3 then
			draw_stats()
		elseif mode == -1 then
			rectfill(1,10,126,52,0)
			rect(1,10,126,52,7)
			print(
				"mission success!",
				31,12,7
			)
			print(
				"you managed to purify the",
				13,22
			)
			print(
				"planet! now we can send our",
				9,28
			)
			print(
				"people to settle on this",
				17,34
			)
			print(
				"planet without having to worry",
				4,40
			)
			print(
				"about dying from impurity!",
				13,46
			)
			rectfill(21,80,106,88,0)
			rect(21,80,106,88,7)
			print("time:",23,82,7)
			print(final_time,106-#final_time*4,82)

			rectfill(9,110,119,118,0)
			rect(9,110,119,118,5)
			print("press \x8e and \x97 to continue",11,112,5)

			if btn(4) and btn(5) then
				mode=0
				gamemode=1
			end
		end
		if msg_res>0 then
			local x1 = 64 - #msg_str/2*4
			local x2 = 64 + #msg_str/2*4
			rectfill(x1-2,20,x2,28,0)
			rect(x1-2,20,x2,28,7)
			print(msg_str,x1,22)
		end
		rectfill(0,120,127,127,0)
		if mget(cursor_x+map_size,cursor_y)==0 then
			local str = names[mget(cursor_x,cursor_y)];
			print(str, 1,122,7)
		else
			print("impurity",1,122,7)
		end

		local tile = mget(cursor_x,cursor_y)
		local land = get_land_of_tile(tile)
		local building = selected_building[land]
		if building~=0 then
			print("\x97:", 70, 122)
			spr(building, 81, 120)
		end

		spr(32,99,120)
		local miner_str = ""..flr(minerals)
		print(miner_str,128-4*#miner_str,122,7)

	end

	cpu_load = stat(1)
	draw_load = stat(1)-start
end

reduce_load=0
draw_load=0
cpu_load=0
function draw_map()

	if draw_load>0.9 and cpu_load>1 then
		reduce_load=min(1,reduce_load+1)

	end
	if draw_load<0.6 and cpu_load<1 then
		reduce_load=max(0,reduce_load -1)
	end

	for x=reduce_load,16-reduce_load do
		for y=reduce_load,14-reduce_load do
			if
			mget(
				(x+cursor_x-8)%map_size+map_size,
				(y+cursor_y-7)%map_size
			)==16
			then
				spr(16,x*8-4,y*8)
			else

				local mapx=(x+cursor_x-8)%map_size
				local mapy=(y+cursor_y-7)%map_size
				local sx = x * 8 -4
				local sy = y*8

				local b = mget(mapx,mapy)
				spr(b, sx, sy)
				pal() palt()

				if is_purifier(b) and not transport:is_input_satisfied(mapx,mapy) then
					palt(3,true) palt(0,false)
					spr(53,sx,sy)
					palt()
				end
				if transport:has_capacity(mapx,mapy) then
					spr(96, sx, sy)
				end
				if is_transport(b) then
					local r = transport.conducted_resource[mapx..","..mapy]
					if r==nil then r = 0 end
					local c = resources:get_color(r)
					pal(5, c)
					spr(1, sx, sy)
					pal()
				end

			end


		end
	end

	spr(48,60,56)

	if x_pressed==0 then
		show_cluster_at={}
	end
	if x_pressed>0 and (#show_cluster_at==0 or cursor_x==show_cluster_at.x and cursor_y==show_cluster_at.y) then
		show_cluster_at.x = cursor_x
		show_cluster_at.y = cursor_y
		for pos in all(get_cluster(cursor_x,cursor_y)) do
			local x = (pos.x-cursor_x+8)%map_size
			local y = (pos.y-cursor_y+7)%map_size
			spr(112, x*8-4, y*8)
		end
		if mget(cursor_x, cursor_y) == 21 then
			draw_cluster_core_stats()
		elseif x_pressed>60 and idle>60 then
			draw_stats()
		elseif not transport:is_input_satisfied(cursor_x,cursor_y) then
			msg_str = "need"..transport:get_input_needs(cursor_x,cursor_y):tostringneeds()
			msg_res = 2
		end
	elseif idle>30 then
		for _,pos in pairs(transport.connections[cursor_x][cursor_y].input) do
			local x = (pos.x-cursor_x+8)%map_size
			local y = (pos.y-cursor_y+7)%map_size
			local consumer = {x=cursor_x, y=cursor_y }
			local resource = transport:get_connection_resource(pos, consumer)
			pal(7,resource:get_color())
			spr(80, x*8-4, y*8)
			spr(64, 60,56)
		end
		for _,pos in pairs(transport.connections[cursor_x][cursor_y].output) do
			local x = (pos.x-cursor_x+8)%map_size
			local y = (pos.y-cursor_y+7)%map_size
			pal(7,resources:get_color(pos.r))
			spr(64, x*8-4, y*8)
			spr(80, 60,56)
		end
		pal()
	end

end

function get_cluster(x,y)
	local b = mget(x,y)
	if b<5 then return {} end
	for r=2,4 do
		if effects[get_active_building(mget(x,y))][r]<0 then
			local cluster = tools.find_path(x, y, 100,
					function(cx,cy)
						return transport:conducts(mget(x,y),cx,cy,r)
					end,
					function (tx,ty)
						return true
					end
			)
			if #cluster>1 then
				return cluster
			end
		end
	end
	return {}
end

function draw_resources()
	rectfill(12,45,54,72,0)
	rect(12,45,54,72,7)
	print("resources",14,47)
	print("energy "..min(disp_energy,energy),14,54)
	print("coal   "..min(disp_coal,coal),14,60)
	print("oil    "..min(disp_oil,oil),14,66)
end

function draw_stats()
	draw_map_mini()
	rectfill(72,24,123,75,0)
	rect(72,24,123,75,7)
	print("total",74,26)
	print("energy  "..total_energy,74,32)
	print("coal    "..total_coal,74,38)
	print("oil     "..total_oil,74,44)
	print("time",74,63)
	print(time_str,123-#time_str*4,69)
end

function draw_cluster_core_stats()

	local purifier = find_active_purifiers(map_size/2,map_size/2)
	draw_map_mini(purifier)

	rectfill(72,24,123,75,0)
	rect(72,24,123,75,7)
	cursor(74,26)
	print("cluster core")
	print("")
	print("cluster")
	print("consists of")
	print((#purifier-1).." adjazent")
	print("active")
	print("purifiers.")

end

function draw_map_mini(highlights)
	map_color = {3, 12, 5, 1}
	rectfill(4,24,55,75,0)
	rect(4,24,55,75,7)
	for x=0,map_size-1 do
		for y=0,map_size-1 do
			if mget(x+map_size,y) == 16 then
				pset(13+x,33+y,2)
			else
				local color = 6
				local tile = mget(x,y)
				if tile<5 then
					 color = map_color[tile]
				end
				pset(13+x,33+y,color)
			end
		end
	end

	clip(13,33,map_size,map_size)
	if highlights~=nil then
		for h in all(highlights) do
			local corex=map_size/2
			local corey=map_size/2
			local dx = (corex+(h.x-corex)*5)%map_size
			local dy = (corey+(h.y-corey)*5)%map_size
			rect(13+dx-3,33+dy-3,13+dx+2,33+dy+2,15)
		end
		for h in all(highlights) do
			pset(13+h.x,33+h.y,14)
		end
	end
	clip()

	pset(13+cursor_x,34+cursor_y,8)

	rectfill(4,75,55,89,0)
	rect(4,75,55,89,7)
	print("pure cells:",6,77,7)
	local str = flr(purecount/map_size/map_size*100).."%"
	print(str,55-4*#str,83,7)
end
function get_land_of_tile(tile)
	if tile<5 then
		 return tile
	end
	if tile==5 then
		 return 1
	end
	return tile%8
end

function get_build_list_selection_by_tile(land, building)
	for i=1,#build_list do
		if (build_list[land][i]==get_active_building(building)) then
			return i
		end
	end
end

function map_construct(x,y,b)
	b = get_inactive_building(b)
	local rm = minerals-costs[b]
	if rm>=0 then
		sfx(12)
 		mset(x,y,b)
 		minerals=minerals - costs[b]
		if is_transport(b) then
			transport:set_conducted_resource(x,y, last_cursor_x, last_cursor_y)
		elseif not is_active(x,y) then
			transport:create_input_connections(x,y)
			if transport:is_input_satisfied(x,y) then
				mset(x,y,get_active_building(b))
			end
		end
		transport:invalidate_deep(x,y, nil, true)
		transport:invalidate_neighbor_transport(x,y)
		update_corruption()
		recount()
		show_cluster_at={-1,-1}
	else
		if rm<0 then
			 msg_str = "need ".. -flr(rm) .." more mineral"
		end
		msg_res = 60
	end
end

function open_build_dialog()
	local tile = mget(cursor_x,cursor_y)
	if
		mget(cursor_x+map_size,cursor_y)==0 and
		tile < 5
	then
		mode = 1
		build_type = tile
		build_select = 1
		msg_res = 0
	elseif tile>5 and not tile==21 then
		mode = 1
		build_type = get_land_of_tile(tile)
		build_select = get_build_list_selection_by_tile(build_type, tile)
		msg_res = 0
	end
end


function map_generate()

	w=map_size-1
	z=w+1
	f=flr
	r=rnd

	c={4,2,1,1,1,1,3,3,3,3}

	local q=1
	local d=1200
	local v=r(2)
	local j=300
	h={}

	for x=0,w do
		for y=0,w do
			h[x+y*z]=0
		end
	end
	for i=0,j do
		x=f(r(z))
		y=f(r(z))
		h[x+y*z]=1
	end

	for i=0,d do
		local x=1+f(r(w-1))
		local y=1+f(r(w-1))
		local p=y+1
		local k=y-1
		local m=x+1
		local n=x-1
		if(h[x+y*z]>0)then
			h[x+y*z]=h[x+y*z] + v
			h[n+y*z]=h[n+y*z] + q
			h[m+y*z]=h[m+y*z] + q
			h[x+k*z]=h[x+k*z] + q
			h[x+p*z]=h[x+p*z] + q
			h[m+p*z]=h[m+p*z] + q
			h[m+k*z]=h[m+k*z] + q
			h[n+p*z]=h[n+p*z] + q
			h[n+k*z]=h[n+k*z] + q
		end
	end
	for i=1,20 do
		map_add_sine()
	end

	for x=0,w do
		for y=0,w do
			local i=f(h[x+y*z])+1
			if(i>#c) then i=#c end
			if(i<1)  then i=1 end
			local col=c[i]
			mset(x,y,col)
		end
	end


	local core_x = map_size/2
	local core_y = map_size/2
	for xx=-5,5 do
		for yy=-5,5 do
			if mget(core_x+xx, core_y+yy)==4 then
				mset(core_x+xx, core_y+yy, 2)
			end
		end
	end
	for xx=-1,1 do
		for yy=-1,1 do
			mset(core_x+xx, core_y+yy, 1)
		end
	end
	mset(core_x,core_y,5)

end

function map_add_sine()
	local amp1=r(.5)+.2
	local freq1=r(3)/100
	local shift1=r(20)
	local amp2=r(.5)+.2
	local freq2=r(3)/100
	local shift2=r(20)
	for x=0,w do
		for y=0,w do
			h[x+y*z]=h[x+y*z] + amp1*sin(freq1*(x+shift1))+.02
			h[x+y*z]=h[x+y*z] + amp2*sin(freq2*(y+shift2))+.02
		end
	end
end

__gfx__
00000000000000000000000000000000000000000055550000700007000000000000000000000000070000000000000000000000000000000000000000000000
00000000000000000000000000050000001100100556655007070007000000000000000000000000070000000000000000000000000000000000000000000000
00000000000000000000000000505000010011005566665507070007000070077000700000770070070000700770070700000000000000000000001111000000
000000000000000000dd00d005000500000000005666666507770007000707070707070007000707070007070707070700000000000000000000111111550000
00000000000000000d00dd0005005050000000005666666507070007000707070707770007000707070007070707007700000000000000000001111111555000
00000000000550000000000050050005001100105566665507070007070707070707000007000707070707070707000700000000000000000001155511111000
00000900000550000000000050050005010011000556655007070000700070070700700000770070007000700707077000000000000000000011555551111100
00000000000000000000000000000000000000000055550000000000000000000000000000000000000000000000000000000000000000000011555555111100
22002200000000000000000000000000000000000066660000000000000000000000000000000000700070000000007000000000000000070011555555511100
22002200000000500000000000000000000000000667766000000000000000000000000000000000700070000000007000000000000000077011555555551100
00220022000000500000000000000000005115006677776600700770000077000077077770007700700070000077007000077007700070070001155555555000
00220022005050500000000000555500001111006777777607070707000707000700070707070700700070000070707000707007070707070001115555555000
22002200055555500000000005556650001111006777777607070707000707000777070707070700700070000077707000707007070777070000111155550000
22002200055555500000000005555550005115006677776607070707000707000007070707070700707070700070007070707007070700070700001111000000
00220022055555500000000005555550000000000667766000700707000770700770070707077070070007000070000700770707070070007000000000000000
00220022000000000000000000000000000000000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000050050000d00d0000066600000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555500dddddd000660000001151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
005555000050050000d00d0006650000011115100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
055566500050050000d00d0006005000011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555550055555500dddddd006000500011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
005555000050050000d00d0000000050001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700777000000000000000000000000000000003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
70000007000000000000000000000000000000003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
700000070055550000dddd0000055000001111003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000056650000dccd0000566500001dd1003330033300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000056650000dccd0000566500001dd1003330033300000000000000000000000000000000000000000000000000000000000000000000000000000000
700000070055550000dddd0000055000001111003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
70000007000000000000000000055000000000003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
77700777000000000000000000055000000000003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000600000000000000000000000000000000000000000000000000000000000000000000000000005000000110010000000000000000000000000
0000000000000060000000000000000000000000000000000000000000000000000000000000000000dd00d00050500001001100000000000000000000000000
000000000060606000000000000000000000000000000000000000000000000000000000000000000d00dd000500050000000000000000000000000000000000
00000000066666600000000000000000000000000000000000000000000000000000000000000000000000000500505000000000000000000000000000000000
00077000066666600000000000000000000000000000000000000000000000000000000000077000000770005007700500077000000000000000000000000000
00777700066666600000000000000000000000000000000000000000000000000000000000077000000770005007700500077000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ee000000000500000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eeee00000000500000000000000000001001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005050500000000000555500010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555500000000005000050010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050000500000000005000050010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555500000000005555550001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09000090000000600000000000055500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000600000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006060600000000005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066666600000000005005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000060000600000000005000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09000090066666600000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40201010303030301030303030202030303030101010101010101020202020404040402020201010101020204040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40201010303030101010303030302020202030102020202020101010101020202020404040202020202020404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202010101010101010103030303030102020202010101020202030303010101020202040404040404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40402020101010101010101010103030101010201010101010102020203010101010102020204040404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404020201010101010101010101010101010201010101010103030203030101010101010202020404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040202010101010101010101010102020202020101010303030202030303010101010101020404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040402020202020202020202020202040404020201010103030302020303010101010101020204040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040201010101010303030203030301010101010204040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040202010101010101030303030301010101010204040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040402010101010101010101010101010101020204040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040402020202020101010101010101020202020404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040404040404020202020202020202020404040404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040404040404040404020202020404040404040404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000700007000000000000000000000000070000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007070007000000000000000000000000070000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007070007000070077000700000770070070000700770070700000000000000000000000000000000000000000
00000000000000000000000000000000000000007770007000707070707070007000707070007070707070700000000000000000000000000000000000000000
00000000000000000000000000000000000000007070007000707070707770007000707070007070707007700000000000000000000000000000000000000000
00000000000000000000000000000000000000007070007070707070707000007000707070707070707000700000000000000000000000000000000000000000
00000000000000000000000000000000000000007070000700070070700700000770070007000700707077000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000700070000000007000000000000000070000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000700070000000007000000000000000077000000000000000000000000000000000
00000000000000000000000000000000700770000077000077077770007700700070000077007000077007700070070000000000000000000000000000000000
00000000000000000000000000000007070707000707000700070707070700700070000070707000707007070707070000000000000000000000000000000000
00000000000000000000000000000007070707000707000777070707070700700070000077707000707007070777070000000000000000000000000000000000
00000000000000000000000000000007070707000707000007070707070700707070700070007070707007070700070700000000000000000000000000000000
00000000000000000000000000000000700707000770700770070707077070070007000070000700770707070070007000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000111100000000000000000000000060000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000011111155000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000060000000000111111155500000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000115551111100000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001155555111110000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000600000000000000000000000001155555511110000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001155555551110000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001155555555110000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000115555555500000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000111555555500000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000600000000000000000011115555000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000111100000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007770777077700770077000000777770000000770777000000777770000007770077000000770777077707770777000000000000000000
00000000000000000007070707070007000700000007700077000007070707000007707077000000700707000007000070070707070070000000000000000000
00000000000000000007770770077007770777000007707077000007070770000007770777000000700707000007770070077707700070000000000000000000
00000000000000000007000707070000070007000007700077000007070707000007707077000000700707000000070070070707070070000000000000000000
00000000000000000007000707077707700770000000777770000007700707000000777770000000700770000007700070070707070070000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000555000000550555055505550000055505550550055500000555005505550000050005500555055500000555050500000555055505050555050505550000
00000505000005000505055505000000055505050505050000000500050505050000050005050005050500000505050500000555050505050050050500500000
00000555000005000555050505500000050505550505055000000550050505500000050005050055055500000550055500000505055505500050055000500000
00000505000005050505050505000000050505050505050000000500050505050000050005050005050500000505000500000505050505050050050500500000
00000505000005550505050505550000050505050555055500000500055005050000055505550555055500000555055500000505050505050555050505550000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0404040404040402020202020202020202020404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040402010101010101010101020202020202040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040202010101010101010101010101010102040404020202020202020202020202040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040201010101010103030101010101010102020402020101010101010101010102020202040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040201010101010303030303010202020202020202010101010101010101010101010102040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040201010303030303020202020203030301010101010101010101010101010101010102040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040201010303030303030303030303030303030303030303030101010101010101010102040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040201010103030101030303030303030303030303030303030301010101010101010202040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040202010101010101030303010101010303030303030303030301010101010101020204040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040402020201010101010101010101010101010103030303030303030101010102020404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040202020101010101010101010101010101010303030303030101010102040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404020201010101010101010101010101010101010101010101010202040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040202020202020202010101010101010101010101010102020204040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040404040402020202020202010101010102020202040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040404040404040404040402020201020202040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404020202020202020202020202020202040404040404040202020404040404040404020202040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040402020101010102020201010101010102020202020204040404040404040404040202020102020404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040402010101010101010101010101010102020101010202020404040404040402020201010101020204040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040402010101010101010101010101010102010101010101020204040404040402010101030303010102040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040202010101010101010101010101010102010101010101010202040404040402010103030303010102040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040201010101010101010101010101030102010101010101010102040404040202010103030301010202040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040201010101010103030303010303030302010101010101010102040404020201010303030301010204040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040201010101010303030303030303030202010105010101010102040404020101030303030301020204040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040202010101010303030303030302020201010101010101010102040404020101030303030101020404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040202010101010303030303020202030101010101010101010202040404020201030303030101020204040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040202010101010303030302020303030301010101010102020204040404040201010303030101010204040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040201010101010103030303030303030303010101010202040404040404040201010303030301010204040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404020201010101010103030303030303030301010101020202040404040404020201010303030301010202040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404020101010101010303030303030303010101010101010202040404040404020101030303020203010102040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020101010103030303030303030303010101010101010102040404040404020101030303030202020202040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402010101010303030303030203030303030101010101010102020404040404020201010103030303010102040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402010101030303030303030202030303030301010101010101020204040404040202020101030303010102040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
001800200c0351004515055170550c0351004515055170550c0351004513055180550c0351004513055180550c0351104513055150550c0351104513055150550c0351104513055150550c035110451305515055
010c0020102451c0071c007102351c0071c007102251c007000001022510005000001021500000000001021013245000001320013235000001320013225000001320013225000001320013215000001320013215
0030002000040000400003000030020400203004040040300504005040050300503005020050200502005020070400704007030070300b0400b0400b0300b0300c0400c0400c0300c0300c0200c0200c0200c020
003000202874028740287302872026740267301c7401c7301d7401d7401d7401d7401d7301d7301d7201d72023740237402373023720267402674026730267201c7401c7401c7401c7401c7301c7301c7201c720
00180020010630170000000010631f633000000000000000010630000000000000001f633000000000000000010630000000000010631f633000000000000000010630000001063000001f633000000000000000
00180020176151761515615126150e6150c6150b6150c6151161514615126150d6150e61513615146150e615136151761517615156151461513615126150f6150e6150a615076150561504615026150161501615
011800101154300000000001054300000000000e55300000000000c553000000b5630956300003075730c00300000000000000000000000000000000000000000000000000000000000000000000000000000000
001800200e0351003511035150350e0351003511035150350e0351003511035150350e0351003511035150350c0350e03510035130350c0350e03510035130350c0350e03510035130350c0350e0351003513035
011800200c0351004515055170550c0351004515055170550c0351004513055180550c0351004513055180550c0351104513055150550c0351104513055150550c0351104513055150550c035110451305515055
003000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000030100303003040030600506006060070700a0700d0700f07013070180701b0701b0051b0050000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001b070130700d0700907005070030700207001050010400b00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001f0701a07017070110700807001070140000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300001e6102c62011620036200c620066000362005630096200560001600006000060000600006000060000600006000f6000f6000d6000d6000d6000d6000f6000f6000f6000f6000f6000f6000f60000600
000300001e0102c02011030030300c020060000300005000090000500001000000000000000000000000000000000000000f0000f0000d0000d0000d0000d0000f0000f0000f0000f0000f0000f0000f00000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 00400043
00 01410100
00 02410100
00 03420400
00 03420400
00 02414300
00 05050100
00 05020400
00 03020400
00 03020400
02 01060607
00 41424344
00 41424344
00 41424344
01 09084243
00 09014308
00 02014308
00 03020408
00 03020408
00 02414308
00 09014508
00 02050408
00 02030408
00 02030408
02 09010607
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

