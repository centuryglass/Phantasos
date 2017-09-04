pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
--[[
phantasos devtools
copyright anthony brown 2017
this work is licensed under a
creative commons attribution 4.0
international license
https://creativecommons.org/
licenses/by/4.0/
--]]
--[[
######-global variables-#########
--]]
frame,--goes from 1-1000
classtable=0,{}

--[[
filename of the game cartridge
being developed
--]]
cart_file="phantasos.p8"

floor_sprites="0-8,16-24,32-40"
entity_sprites=
"64-78,80,128-133,144-149,176-178"

function sprite_table(str)
	local stab,ranges={},
	split(str,",")
	foreach(ranges,function(r)
		if not str_contains(r,"-") then
			add(stab,r+0)
		else
			r=split(r,"-")
			local s,e=r[1]+0,r[2]+0
			for i=s,e do
				add(stab,i)
			end
		end
	end)
	return stab
end


--large data strings:
local draw_mapping=
"88,7700112233445566,66001122334455,78010212031323041424340515253545061626364656071727374757670818283818485868091929394959690a1a2a3a4a5a0b1b2b3b4b0c1c2c3c0d1d2d0e1e0f,550011223344,4400112233,33001122,87102030405060708090a0b0c0d0e0f02131415161718191a1b1c1d1e132425262728292a2b2c2d2435363738393a3b3c35464748494a4b465758595a5768696,220011,8660708090a061718191a172829273839374849485,680616071727374708182838485809192939490a1a,580717270818283848091929,761020304050213141513242526243536354646575,670102120313230414243405152535452636465657,1100,6510203021313242435354,857080907181917282928384,5601021203132324343545,48070818283809,75405060415161526263736474,45010212132334,54102021313243,38081828,280818,57041405152506162636463747,745060617162726373,34011223,84708090818283,43102132,6430404151425253,1808,634050515262,4603041424152535,83808182,736070617172,350203131424,321021,08,470506162636172737,828081,52304041,230112,72607071,1201,240213,1302,532030314142,01,7170,4130,02,62505161,360405152526,422031,2110,370616071727,30,3120,8180,26051516,615060,70,5140,20,1504,25030414,40,50,160506,10,04,27060717,80,1707,05,60,07,06,1403,03,00"

los_mapping=
"6778,87,858786,13786756453524,54877665,0678685747372716,16786857473726,528776756463,3087766564535241,47786857,84878685,0778685848372717,328776655443,3578675646,7387867574,3678675747,658776,758776,21877665544332,0278675645352413,0478675746362515,8087868584838281,587868,0378675646352514,227766554433,3478675645,7087868584737271,64877675,0578675747362616,8687,11776655443322,71878685747372,4087767564635251,428776656453,577867,557766,5087767574636261,267867574736,567867,46786757,12786756453423,287868584838,828786858483,51877675646362,3878685848,6677,17786858473727,237867564534,31877665545342,74878675,88,1087766554433221,6878,257867574636,6387767574,3377665544,44776655,728786857473,0878685848382818,628776757463,77,277868584737,6087867574737261,15786757463626,61878675747362,0178675645342312,81878685848382,18786858483828,41877675645352,247867564635,5387766564,78,8387868584,7687,4387766554,48786858,14786757463525,45786756,2087766554534231,3778685747,0011223344556677"

level_structures=
"900,1,floor,0;0,>,stair,0;0&150,1,cave_floor,0;0;7;7,>,temple_wall,1;1;1;2,1;4;1;2,4;1;2;1,4;5;2;1,1;1;2;1,1;5;2;1,5;1;1;2,5;4;1;2,temple_floor,2;3;3;1,3;2;1;3,floor_pedestal,3;3,temple_wall,1;1;1;2,1;4;1;2,4;1;2;1,4;5;2;1,1;1;2;1,1;5;2;1,5;1;1;2,5;4;1;2,temple_floor,3;3&100,4,floor,0;0,0;2,door,0;1,>,dungeon_secret_door,0;1&100,4,cave_wall,0;1,2;1,cave_floor,0;0;3;1,1;0;1;3,>,cave_secret_door,1;1,torch,1;1&100,1,void,0;1;8;5,wall,0;0;8;1,>,dungeon_wall,1;0;6;4,2;0;3;6,0;1;8;2,0;1;7;3,2;0;4;5,1;0;7;3,door,3;0;2;4,2;1;4;2,dungeon_floor,3;1;2;2,1;2,6;1,3;4,torch,2;0,5;0,ring,6;1,statue,3;4,watcher,1;2&100,1,wall,3;1,floor,3;0,void,0;2;7;6,>,temple_wall,1;2;5;6,0;3;7;3,temple_floor,2;3;3;2,2;6;3;1,3;1;1;6,temple_door,3;2,3;4;1;2,floor_pedestal,1;4,5;4,throne,3;4,statue,1;4,5;4,watcher,3;4&200,1,void,0;2;5;5,cave_wall,0;1;5;1,cave_floor,0;0;5;1,>,dungeon_wall,0;1;5;6,cave_wall,0;1;5;3,cave_floor,1;3;3;1,1;1;1;3,floor_pedestal,1;1,3;1,door,2;4;1;2,dungeon_floor,1;5;3;1,statue,1;1,3;1,tomahawk,3;5,kobold,1;5&200,2,void,0;2;5;1,cave_wall,0;1;5;1,cave_floor,0;0;5;1,>,cave_wall,0;1;5;2,floor_pedestal,1;1,3;1,statue,1;1,3;1&100,2,floor,0;0;3;3,>,temple_floor,0;0;3;3,floor_pedestal,0;1;3;1,1;0;1;3,statue,1;1"


--[[
######## draw_mapping ###########
level drawing point mapping string:
each point list contains one
8x8 tile on the screen, followed
by all the tiles that wouldn't be
visible from the point (8,8)
if that first tile was opaque.

level drawing algorithm:
-create a blocked_points table
for each point list in draw_mapping:
	-set keypoint to the first point
	in the list

	-if keypoint is not in
	blocked_points, draw it to the
	screen

	-if keypoint is opaque or
	keypoint is in blocked_points,
	add all other points in the point
	list to blocked_points
--]]

--[[
####### los_mapping ############
line of sight point mapping string:
each point list maps one point in
a 16x16 grid, followed by all points
that would block line of sight
between it and (8,8).

each list is to be indexed by its
main point, so that finding line
of sight between point a and b
can be done in four steps:
1.transform a and b by the
translation that would put a at
(8,8)

2. look up b:to_string in the
line of sight table

3. for each point p in the list
found in step 2, transform p
by the inverse of the
transformation used in step one,
and check if the tile at that
position is opaque.

4. if any tile p is opaque, return
false. otherwise, return true
--]]

--[[
######### level_structures ######
pre-generated level structures
are stored in this string. each
consists of:

1.number of times to attempt to
place this structure.

2.maximum number of times this
structure could be placed in one
level map.

3.a list of tile types, each
followed by one or more points
or rectangles. the structure will
only be placed if these tiles
are found at some translation
and/or rotation in the level map

4.a list of tile and entity types,
each followed by one or more
points or rectangles. these tiles
and entities will be placed at the
specified coordinates, translated
and/or rotated with the same
transformation used in step 3.

>:marks the boundary between the
validation list(step 3) and the
structure list(step 4)

&:marks the boundary between two
level structures in the string
--]]


---global util functions begin---
function always_true() return true end
function always_nil() end

--[[
write debug data to log.p8l
only save logs from the last
program instance.
--]]
function log(txt)
	printh(txt,"log",not logged)
	logged=true
end

	--[[
	######-data management-#########
	--]]
	--reused whenever needed as
	--callback functions
	function always_true() return true end
	function always_nil() end

--[[
map characters to indices so
strings can be loaded from memory.
--]]
allchars = "0123456789-.abcdefghijklmnopqrstuvwxyz,;_:(){}[]<>/?+=*|!#%&@$^"
chartable={}
for i=1,#allchars do
	local c,n=sub(allchars,i,i),i-1
	chartable[n],chartable[c]=
	c,n
end

--[[
encode char c as a number
--]]
function char_to_num(c)
	return chartable[c]
end

--[[
return the character represented
by n
--]]
function num_to_char(n)
	return chartable[n]
end

--[[
load a string from memory

addr: memory address
len: length in memory
--]]
function mem_to_str(addr,len)
	local str = ""
	for i=addr,addr+len-1 do
		str = str..chartable[peek(i)]
	end
	return str
end

--[[
save a string to memory
str:the string to encode
addr:storage memory address
strname:identifier for logging
	memory operations
return: address of the first byte
	after the block of memory holding
	str
--]]
function str_to_mem(str,addr,strname)
	local last_addr
	for i=1,#str do
		last_addr=i+addr-1
		local byte = sub(str,i,i)
		poke(last_addr,char_to_num(sub(str,i,i)))
	end
	add(mem_info,strname..":")
	add(mem_info,"	address="..num_to_hexstr(addr))
	add(mem_info,"	length="..num_to_hexstr(#str))
	return last_addr+1
end

--[[
	return true if str represents
 a number. odd uses of number
	symbols (e.g) "05.6.7"
	, "--.....-." etc will cause
	false positives
	--]]
function is_numstr(str)
	if is_string(str) and #str>0 then
		for i=1,#str do
			local char = chartable[sub(str,i,i)]
			if(not char or char>11)return
		end
		return true
	end
end

--[[
return true if str contains at
least one of the characters in
match.
--]]
function str_contains(str,match)
	if is_string(str) then
		for i = 1, #str do
			for k = 1,#match do
				if(sub(str,i,i) == sub(match,k,k))return true
			end
		end
	end
end

--[[
replace all instances of c in
str with repl
--]]
function str_replace(str,c,repl)
	local rval=""
	for i = 1, #str do
		local ci = sub(str,i,i)
		rval = rval..
		(ci==c and repl or ci)
	end
	return rval
end

--[[
split str into an array around
instances of char
--]]
function split(str,char)
	local buf,subs,length =
	"",{},#str+1
	for i = 1, length do
		local c = sub(str,i,i)
		if str_contains(char,c)or i==length then
			add(subs,buf)
			buf = ""
		else
			buf = buf .. c
		end
	end
	return subs
end

--[[
recognizes non-string values
stored as strings, and returns
their converted value. supports:
numbers: base 10 only
boolean values, nil
tables: in the format
k1:v1;k2:v2...
arrays: in the format
v1;v2;v3...
empty tables:{}
classes: identified by their
names stored in global array
classtable
strings: anything that doesn't
fit in any other categories
--]]
function str_to_val(str)
	if(is_numstr(str)) str+=0
	local recurse
	if str_contains(str,";") then
		str,recurse =
		str_replace(str,";",","),true
	end
	if str_contains(str,":") then
		return str_to_table(str_replace(str,":","="))
	elseif recurse then
		return str_to_array(str)
	end
	if(str == "false")return false
	if(str == "nil")return nil
	return (str == "true") and true
	or (str == "always_nil") and always_nil
	or (str == "always_true") and always_true
	or (str == "{}") and {}
	or classtable[str] or str
end

--[[
extract an array stored in a string

str: formatted as "v1,v2,v3"
--]]
function str_to_array(str)
	local arr = split(str,",")
	for i=1,#arr do
		arr[i]=str_to_val(arr[i])
	end
	return arr
end

--[[
extract a table stored in a string
if the resulting table contains
keys addr and len, attempt to
load and convert string data
from that memory address

str: formatted as "k1=v1,k2=v2"
[tab]:optional destination table
--]]
function str_to_table(str,tab)
	local kvpairs,tab=
	split(str,","),
	tab or {}
	foreach(kvpairs,
	function(kv)
		local k,v=unpack(split(kv,"="))
		tab[str_to_val(k)]=str_to_val(v)
	end)
	if tab.addr then
		return str_to_table(mem_to_str(hexstr_to_num(tab.addr),hexstr_to_num(tab.len)),tab)
	end
	return tab
end

--[[
extract a sequence of values
stored in a string
str:can define a table or array
	string
--]]
function str_to_list(str)
	local t = is_table(str) and str
	if t then
		str=""
		foreach(t,function(v) str=str..v.."," end)
	end
	return unpack(str_to_array(str))
end

--[[
convert hex strings to number data
hexstr: a hex string, without
	the '0x' prefix
--]]
function hexstr_to_num(hexstr)
	return ("0x"..hexstr)+0
end

--[[
extract a series of points
stored as a hex string
transform:optional transformation
function to apply to each point
--]]
function hex_to_pts(hexstr,transform)
	transform=transform or
	function(p) return p end
	local pts = {}
	function hexpop()
		local num=
		hexstr_to_num(sub(hexstr,1,1))
		hexstr = sub(hexstr,2)
		return num
	end
	while #hexstr > 1 do
		local pt=transform(point(hexpop(),hexpop()))
		if pt.x<16 and pt.y<16 then
			add(pts,pt)
		elseif #pts==0
			then return
		end
	end
	return pts
end

--[[
load a table of point lists from
a string


--]]
function point_mapping(str)
	local hex_tbl,pt_tbl,mapped,offset=
	split(str,","),{},{},point(8,8)
	for i=1, #hex_tbl do
		local transformations=
		split("x=1,y=1 x=-1,y=1 x=1,y=-1 x=-1,y=-1"," ")
		foreach(transformations,
		function(transform)
			local pts=hex_to_pts(hex_tbl[i],
			function(p)
				return (p-offset)*point(transform)+offset
			end)
			if pts then
				local key=#pts[1]
				if not mapped[key] then
					add(pt_tbl,pts)
					mapped[key]=true
				end
			end
		end)
	end
	return pt_tbl
end

--[[
remove all points in a point list
where x>8 or y>8

the data is symmetrical
across the lines x=8 and y=8,
so only 1/4 of the points are
stored in the string. points
in the quadrant (0,0) to (8,8)
are transformed at this step to
find the other three quadrants

i could potentially cut the
data in half again, and
transform it eight times to get
the full data set, but i'm not
sure the token tradeoff is worth
it yet.
--]]
function quarter(ptlist,name)
	log(name.."=")
	local str=""
	foreach(ptlist,function(pts)
		if(pts[1].x <=8 and pts[1].y <=8)str=str..pts_to_hex(pts)..","
	end)
	str = sub(str,1,#str-1)
	return str
end

--[[
###### coroutine management #####
--]]
--[[
create, store, and start a
coroutine that runs fn()
fn: any function taking no params
--]]
function coroutine(fn)
	local routine=cocreate(fn)
	update_routines(routine)
	coresume(routine)
end

--[[
find the first pending coroutine
in a queue, and run it, removing
completed coroutines in the
process
co: a coroutine queue
[run_all]: if true, run every
coroutine in the queue once
--]]
function run_coroutines(co,run_all)
	local n = #co
	for i=1,n do
		local routine = -co
		if costatus(routine)=="suspended" then
			coresume(routine)
			co(routine)
			if(not run_all)return true
		end
	end
	if(run_all and #co>0)return true
end

--[[
#### general utilty functions ##
--]]
--type detection, saves tokens
function is_string(var)
	return type(var) == "string"
end
function is_table(var)
	return type(var) == "table"
end
--[[
returns all items in array t, in
order
--]]
function unpack(t,index,last)
	if is_string(t) then
		t= str_to_array(t)
		log("unpack:"..t)
		if(index)log("i="..index)
	end
	index,last=index or 1,last or #t
	if(index>last)return
	return t[index],unpack(t,index+1,last)
end


--[[
run fn(v,k) for each key:value
pair in tbl.

i'm using v,k instead of k,v
because i often don't need the
key, but i always need the value

stop early and return true if
fn returns true
--]]
function foreach_pair(tbl,fn)
	for k,v in pairs(tbl) do
		if(fn(v,k))return true
	end
end

--[[
identical to the built-in foreach
method except it stops and returns
true if fn returns true
--]]
function foreach(tbl,fn)
	for i in all(tbl) do
		if(fn(i)) return true
	end
end

--[[
problem: you need to call
	long_fun(u,v,w,x,y,z) often, and
	you have
	function uvwx()
		return u,v,w,x
	end
	if you use
	long_fun(uvwx(),y,z)
	y and z are lost.
solution: call
	long_fun(argsort({y,z},uvwx()))
	and argsort will reorder the
	parameters appropriately.
	it's kind of sloppy, but i wont
	turn down the extra tokens
--]]
function argsort(vars,a,b,c,d,e,f)
	--if this fails, add more params
	assert(not f)
	local arr = {a,b,c,d,e}
	if is_table(vars) then
		foreach(vars,function(v) add(arr,v) end)
	else
		add(arr,vars)
	end
	return unpack(arr)
end


--[[
make rounding errors go away
--]]
function round(val)
	return flr(val)+
	(val%1>0.5 and 1 or 0)
end


--[[
copy all key/value pairs in src
to dst

src: a table, or a string that
	can be converted into a table
[dst]: a destination table. if
	omitted, create a new table
return: dst or the new table
--]]
function copy_all(src,dst)
	dst,src = dst or {},
	is_string(src) and
	str_to_table(src) or src
	if src then
		foreach_pair(src,function(v,k)
			dst[k]=v
		end)
	end
	return dst
end

--[[
returns true if table t contains
value v
--]]
function contains(t,v)
	return foreach(t,
	function(val)
		if(val == v) return true
	end)
end

--[[
random integer function

rmax: maximum value,inclusive
[rmin]: minimum value, inclusive,
defaults to 1
--]]
function rndint(rmax,rmin)
rmin = rmin or 1
return rmin + flr(rnd(1+rmax-rmin))
end

--[[
e:an entity or point
return: true if e is visible on
the screen
--]]
function visible(e)
	e = e.pos or e
	return screen >e and
	you:can_see(e)
end

--[[
given a location on the level map,
find the corresponding location
on the screen
--]]
function draw_pos(p)
	return (p-screen)*8
end
--[[
iterates over a probability table

tbl: each key is a class name,
	with a value <= 1000.
fn: if rnd(1000) is less than
	that value, look up the class in
	the class table and pass it to fn.
	if fn returns true, stop the
	search
return:true if fn returned true
--]]
function prob_tbl(tbl,fn)
	if(not tbl)return true
	return foreach_pair(tbl,function(v,k)
		if rnd(1000) < v then
			if(fn(k)) return true
		end
	end)
end

--[[
convert a hexadecimal string
to the number it represents
--]]
function hexstr_to_num(hexstr)
	return('0x'..hexstr)+0
end

--[[
return the value of num as
a hexadecimal string
--]]
function num_to_hexstr(num)
	local n=num
	local str = ""
	local charindex = {}
	local hexchars = "0123456789abcdef"
	for i=1,#hexchars do
		charindex[i-1]=sub(hexchars,i,i)
	end
	while n > 0 do
		str = charindex[n%16]..str
		n = flr(n/16)
	end
	str="0x"..str
	assert(num==(str+0))
	return str
end

--[[
extract a series of points
stored as a hex string
transform:optional point transformation
--]]
function hex_to_pts(hexstr,transform)
	transform=transform or
	function(p) return p end
	local pts = {}
	function hexpop()
		assert(is_string(hexstr))
		local num=
		("0x"..sub(hexstr,1,1))+0
		hexstr = sub(hexstr,2)
		return num
	end
	while #hexstr > 0 do
		local newpt=transform(point(hexpop(),hexpop()))
		if newpt.x <16 and newpt.y<16 then
			add(pts,newpt)
		elseif #pts==0
			then return
		end
	end
	return pts
end

--[[
store a list of points in a
hex string
--]]
function pts_to_hex(pts)
local hexstr = ""
function hexadd(n)
	hexstr=hexstr..sub("0123456789abcdef",n+1,n+1)
end
foreach(pts,function(pt)
	hexadd(pt.x)
	hexadd(pt.y)
end)
return hexstr
end

	--[[
#########-object class-##########
	a basis for all class tables

	#####  operators: #####
	object(): creates a new object
		instance
	object<x: return true if object
		is type x
--]]
object,classtable={},{}
object.class={object}

--[[
create a new instance of this
class

[params]: used to initialize the
	new object
--]]
function object:new(params)
	local obj = {}
	setmetatable(obj,self.metatable)
	obj:init(params)
	return obj
end

--[[
create a new subclass of this
class

[params]: a table (or the memory
	address/string value of one)
	holding all parameters to copy
	into the subclas
--]]
function object:subclass(params)
	local subclass = {}
	if(#params == 2)params = mem_to_str(params[1],params[2])
 subclass.c_metatable={
 	__index=self,
		__call=function(this,params)
			return subclass:new(params)
		end,
		__lt=function(this,x)
			return is_table(x)
			and contains(x.classes,this)
		end
	}
	setmetatable(subclass,subclass.c_metatable)
	subclass.metatable=copy_all(self.metatable)
	subclass.metatable.__index=subclass
	subclass.classes = copy_all(self.classes)
	add(subclass.classes,subclass)
	copy_all(params,subclass)
	classtable[subclass.classname]=subclass
	return subclass
end

--[[
get the most specific class
defining an object
--]]
function object:class()
	return self.classes[#self.classes]
end

--default object initializer
function object:init(params)
	copy_all(params,self)
end

--[[
#########-suspend timer-#########
must be kept within the scope of
a single coroutine, tracks when
the routine should suspend to
allow drawing.

#####  operators: #####
timer(): checks execution time,
	resetting and yielding the
	coroutine if time exceeds .03s
--]]
timer = object:subclass"classname=timer"
timer.metatable.__call =
function(self)
	if time() - self.start > .03 then
		yield()
		self.start=time()
	end
end

function timer:init()
		self.start=time()
	end

--[[
#########-queue class-###########
basic fifo queue, non-nil data
only

#####  operators: #####
queue(val): push val onto the
	queue
-queue: remove and return a value
	from the queue
#queue: return queue length
--]]
queue = object:subclass"classname=queue,length=0"
copy_all(
{
	__unm=function(self)
		return self:pop()
	end,
	__call = function(self,n)
		self:push(n)
		return self
	end,
	__len=function(self)
		return self.length or 0
	end
},queue.metatable)

function queue:init()
 self.values={}
end

--[[
add v to the front of the queue
--]]
function queue:push(v)
 if(v)self.length +=1 self.values[#self] = v
end

--[[
access value i in the queue, if
it exists
--]]
function queue:get(i)
 if(i<=#self)return self.values[i]
end

--[[
	remove and return the last value
	in the queue
--]]
function queue:pop()
	local first = self:get(1)
 if first then
  for i = 2, #self do
   self.values[i-1],
   self.values[i] = self:get(i),nil
  end
  self.length-=1
  return first
 end
end

--[[
remove all values in the queue
--]]
function queue:clear()
	self.values,
	self.length = {},0
end

--[[
##########-stack class-##########
	standard filo stack
	operators are identical to queue
--]]
stack = queue:subclass
"classname=stack"
--[[
remove and return the first value
in the stack
--]]
function stack:pop()
	local last =
	self:get(#self)
	if last then
		self.values[#self] = nil
		self.length-=1
		return last
	end
end

--[[
#####-priority queue class-######
stores values with priority.
lower priorities pop first
operators are identical to queue
--]]
p_queue = queue:subclass
"classname=p_queue"
p_queue.metatable.__call=
function(self,v,p)
	self:push(v,p)
end

--[[
push var onto the stack with
priority p
--]]
function p_queue:push(var,p)
	local nvar = {
		value=var,
		priority=p
	}
	self.length += 1
	for i=1,#self do
		local i_val = self:get(i)
		if not i_val or
		nvar.priority < i_val.priority then
			nvar,self.values[i] =
			i_val,nvar
		end
	end
end
function p_queue:pop()
 local first = queue.pop(self)
 return first and first.value
end

--[[
#####-random queue class-######
values pop in a random order
operators are identical to queue
--]]
rnd_queue=queue:subclass
"classname=rnd_queue"
function rnd_queue:pop()
	if(#self<1)return
	val = self:get(rndint(#self))
	del(self.values,val)
	self.length-=1
	return val
end

--[[
#########-point class-###########
represents a 2d point

#####  operators: #####
	pt(x,y): set coordinates of pt
			to x,y
	pt(pt2): set coordinates of pt
			to match pt2
	pt1+pt2: return a new point with
			x,y equal to the combined values
			of pt1 and pt2
	pt1-pt2: as above, subtracting
			instead
	pt1*pt2: as above,multiplying
			instead
	pt*n:		pt's coordinates multiplied by n
	pt/n: as above, dividing by n
	-pt: return a copy of pt
	pt1==pt2: return true if coordinates
			match
	#pt: return a string representation
			of pt
--]]
point = object:subclass
"classname=point,x=0,y=0"
point.c_metatable.__call=
function(self,x,y)
	return point:new()(x,y)
end

copy_all({
	__call=function(self,x,y)
		if is_string(x) then
			str_to_table(x,self)
		elseif point<x then
			self(x:get_xy())
		else
			self.x,self.y =round(x),round(y)
		end
		return self
	end,
	__add=function(pt1,pt2)
		return point(pt1.x+pt2.x,
		pt1.y+pt2.y)
	end,
	__sub=function(pt1,pt2)
		return point(pt1.x-pt2.x,
		pt1.y-pt2.y)
	end,
	__mul=function(pt,n)
		local x,y = n,n
		if(point<n)x,y=n:get_xy()
		return point(pt.x*x,pt.y*y)
	end,
	__div=function(pt,n)
		return point(pt.x/n,pt.y/n)
	end,
	__unm=function(pt)
		return point(pt)
	end,
	__eq=function(pt1,pt2)
		return pt1.x == pt2.x and
		pt1.y == pt2.y
	end,
	__len=function(pt)
		return pt:to_string()
	end,
	__lt=function(pt,r)
		return rectangle(pt)<r
	end
},point.metatable)

--[[
move the point forward in
cardinal direction d by n units.

d: matches button mappings
[n]: defaults to 1
--]]
function point:move(d,n)
	n = n or 1
	if(d%2==0)n*=-1
	if d < 2 then
		self.x+=n
	else
		self.y+=n
	end
	return self
end

--[[
approximate distance from self
to p2
--]]
function point:dist(p2)
	local ay,ax = (p2-self):get_xy()
	ay,ax = abs(ay),abs(ax)
	if(ay > ax) return ay + ax/2
	return ax + ay/2
end

--[[
rotate self around a pivot point
by 90 degrees
[pivot]:defaults to point(0,0)
[turns_cw]:number of rotations
--]]
function point:rotate(pivot,turns_cw)
	if(turns_cw == 0)return -self
	pivot,turns_cw=pivot or point(0,0),
	turns_cw or 1
	local rot=self-pivot
	rot(-rot.y,rot.x)
	rot+=pivot
	return rot:rotate(pivot,turns_cw-1)
end

--get point data in different
--formats:

function point:get_xy()
	return self.x,self.y
end

function point:exact_distance(p2)
	local dx,dy=(p2-self):get_xy()
	return sqrt(dx*dx+dy*dy)
end


function point:to_string()
	return "x="..self.x..",".."y="..self.y
end

--[[
#######-rectangle class-#########
represents a rectangle defined
by an upper left point and a
width and height

#####  operators: #####
	rect(x,y,w,h),
	rect(p1,p2),
	rect(rect2): set rect's dimensions
		to match the given parameters
	rect+pt: return the rectangle
			obtained by offsetting rect's
			origin by pt
	rect-pt: as above,subtracting
			instead
	rect*n: return the rectangle
			obtained by multiplying rect's
			dimensions by n
	rect/n: as above, dividing
			instead
	r1==r2: return true if r1 and
			r2 have identical dimensions
			and locations
	#rect: return the area of rect
	r1<r2: return true if r1 fits
			entirely into r2
	rect>pt: return true if rect
			contains the 1x1 square at pt
	-rect: return a copy of rect
--]]
rectangle = point:subclass("classname=rectangle")
rectangle.c_metatable.__call=
function(self,x,y,w,h)
	return self:new()(x,y,w,h)
end
copy_all({
	__call=function(self,a,b,c,d)
		if(not a) return self"0,0,1,1"
		if(is_string(a)) return self(str_to_list(a))
		if rectangle<a then
			copy_all(a,self)
		elseif point<a then
			local w,h=1,1
			if point<b then
				 w,h=(b-a):get_xy()
			elseif c then
				w,h=b,c
			end
			self(a.x,a.y,w,h)
		else
		 self.x,self.y,self.w,self.h=
			a,b,c,d
		end
		return self
	end,
	__add=function(r,pt)
		local r2 = -r
		r2.x+=pt.x
		r2.y+=pt.y
		return r2
	end,
	__sub=function(r,pt)
		local r2 = -r
		r2.x-=pt.x
		r2.y-=pt.y
		return r2
	end,
	__mul=function(r,n)
		return rectangle(r.x,r.y,r.w*n,r.h*n)
	end,
	__div=function(r,n)
		return rectangle(r.x,r.y,r.w/n,r.h/n)
	end,
	__eq=function(r1,r2)
		return r1:p1()==r2:p1() and
		r1:p2() == r2:p2()
	end,
	__len=function(r)
		return r.w*r.h
	end,
	__lt=function(r1,r2)
		return r1.x+r1.w <= r2.x+r2.w
		and r1.y+r1.h <= r2.y+r2.h
		and r1.x >= r2.x
	 and r1.y >= r2.y
	end,
	__unm=function(r)
		return rectangle(r)
	end
},rectangle.metatable)


--[[
expand the rectangle's borders
by n units in all directions

[n]:defaults to 1
[d]:if given, only expand in
		direction d
--]]
function rectangle:expand(n,d)
	n=n or 1
	if d then
		local xy,wh =
		d % 2 == 0,
		d <= 1 and "w" or "h"
		if xy then
			if wh=="w" then
				self.x-=n
			else
				self.y-=n
			end
		end
		self[wh]+=n
	else
		self.x-=n
		self.y-=n
		n*=2
		self.w+=n
		self.h+=n
	end
	return self
end

--[[
rotate the rectangle 90 degrees
around a pivot point

[pivot]:defaults to point(0,0)
[turns_cw]:number of 90 degree
clockwise turns to make
--]]
function rectangle:rotate(pivot,turns_cw)
	turns_cw=turns_cw or 1
	local r = -self
	if(turns_cw==0)return self
	r.w,r.h=r.h,r.w
	r.x,r.y = r:p1():rotate(pivot):get_xy()
	r.x-=r.w-1
	return r:rotate(pivot,turns_cw-1)
end

--get rectangle data in different
--formats:

function rectangle:p1()
	return point(self:get_xy())
end

function rectangle:p2()
	return point(self.w,self.h)+self
end

--[[
function rectangle:xywh()
	return self.x,self.y,self.w,self.h
end
--]]

function rectangle:xy1xy2()
	return self.x,self.y,
	self:p2():get_xy()
end

function rectangle:to_string()
	return #self:p1()
	..","..#self:p2()
end


-----------ui functions---------
--[[
 draws a rectangular border
 region around rectangle r
--]]
function draw_border(r)
	if(is_string(r))r= rectangle(r)
	rectfill(argsort(4,r:xy1xy2()))
	rectfill(argsort(2,(-r):expand(-1):xy1xy2()))
end
--###### game menus ##########--
menu=stack:subclass
"classname=menu,index=1,turn_modded=0"
open_menus=stack()

function menu:init()
	stack.init(self)
	self.pos=rectangle"5,25,4,12"
end


function menu_close()
	active_menu,redraw =
	-open_menus, frame
	if(not active_menu)ctrl=default_ctrl
end

function menu_close_all()
	while active_menu do
		menu_close()
	end
end

function menu:add(name,op,trn)
	self{name=name,op=op,turn=trn}
end

function menu:open()
	if(self.update)self:update()
	if #self > 0 then
		open_menus(active_menu)
		active_menu = self
		ctrl=menu_ctrl
	end
end

function menu:draw()
	local pos,w =self.pos,0
	foreach(self.values,
	function(v)
		w=max(w,#v.name*4+14)
	end)
	pos.w,pos.h=
	w+6,
	6*#self+12
	draw_border(pos)
	for i=1,#self do
		local dp = point(2,6*i+2)+pos
		if(i==self.index)spr(31,dp:get_xy())
		print(self:get(i).name,dp.x+9,dp.y,10)
		i+=1
	end
end

debug_menu=menu()
debug_menu:add("save data to "..cart_file,
function()
	cart_state="mem_ops"
	local start_addr=0x2000
	mem_info={"data written to:",cart_file}
	local addr=str_to_mem(draw_mapping,start_addr,"draw_mapping")
	addr=str_to_mem(los_mapping,addr,"los_mapping")
	addr=str_to_mem(level_structures,addr,"level_structures")
	cstore(0x2000,0x2000,addr-start_addr,cart_file)
	menu_close()
end)

debug_menu:add("draw table testing",
function()
	cart_state="draw_testing"
	menu_close()
end)

debug_menu:add("line of sight testing",
function()
	cart_state="los_testing"
	menu_close()
end)

debug_menu:add("sprite previews",
function()
	reload(0x1000,0x1000,0xfff,cart_file)
	cstore(0x1000,0x1000,0xfff)
	cart_state="sprite_preview"
	menu_close()
end)
--####### main controls #######--
function default_ctrl()
	if(btnp"0")index-=1
	if(btnp"1")index+=1
	if(btnp"2")index-=16
	if(btnp"3")index+=16
	if(btnp"4") debug_menu:open()
end

--alternate controls that
--activate when a menu is active
function menu_ctrl()
		--left:close menu
	if(btnp"0")menu_close() return
	--up:change selection
	if(btnp"2") then
		active_menu.index -= 1
		if(active_menu.index==0)active_menu.index=#active_menu
	end
	--down:change selection
	if(btnp"3") active_menu.index %= #active_menu active_menu.index += 1
	--0,right:select menu item
	if btnp"4" or btnp"1" then
		if(active_menu.index<=#active_menu) active_menu:get(active_menu.index):op() redraw=frame
	end
	--x:close all menus
	if(btnp"5")menu_close_all()
end





--##### main game loop ########--
function _init()
	update_routines,draw_routines,
	ctrl,cart_state=
	queue(),queue(),
	default_ctrl,
	"none"
	--[[
	cart states:
		none: not doing anything yet
		mem_ops: saving data to
			cart_file, show data addresses
		draw_testing: show a
			visualization of the data in
			draw_mapping
		los_testing: show a visualization
			of the data in los_mapping
		sprite_preview: show entity sprites
			drawn over tile sprites
	--]]

	floor_sprites=sprite_table(floor_sprites)
	entity_sprites=sprite_table(entity_sprites)
	draw_tbl = point_mapping(draw_mapping)
	los_array= point_mapping(los_mapping)
	foreach(draw_tbl,function(pts)
		local del_all={}
		for i=2,#pts do
			local pts2
			for j=1,#draw_tbl do
				if draw_tbl[j][1] == pts[i] then
					pts2=draw_tbl[j]
					break
				end
			end
			if pts2 then
				for j=2,#pts2 do
					if contains(pts,pts2[j]) then
						add(del_all,pts2[j])
					end
				end
				foreach(del_all,function(rm)
					del(pts,rm)
				end)
		end
		end
	end)
	draw_mapping=quarter(draw_tbl,"draw_mapping")
	los_mapping=quarter(los_array,"los_mapping")
	log("draw_mapping="..draw_mapping)
	log("los_mapping="..los_mapping)
	index=1
	los_tbl={}
	foreach(los_array,function(pts)
		local main_pt=pts[1]
		los_tbl[#main_pt]=pts
		del(pts,main_pt)
	end)
end

function _update()
	if(run_coroutines(update_routines)) return
	ctrl()
end

--[[
when writing data to cart memory,
display a record of all memory
operations
--]]
function draw_mem_info()
	local w,h=0,20
	foreach(mem_info,function(s)
		h+=8
		w=max(w,#s*4+20)
	end)
	draw_border(rectangle(4,4,w,h))
	local y=10
	foreach(mem_info,function(s)
		print(s,10,y,10)
		y+=8
	end)
end

function draw_mapping_visual()
	index%=(#draw_tbl+1)
	local ipt= point(index%16,flr(index/16))
	local blocked={}
	for i=1,#draw_tbl do
		local pts = draw_tbl[i]
		local pt=pts[1]
		--spr(53,(pt*8):get_xy())
		if ipt==pt then
			blocked[#pt] = 1
		end
		if blocked[#pt] then
			local x,y = (pt*8):get_xy()
			rectfill(x,y,x+8,y+8,blocked[#pt])
			print(blocked[#pt],x+1,y+1,10)
			for p=2,#pts do
				blocked[#pts[p] ]=blocked[#pt]+1
			end
		end
	end
	spr(128,64,64)
	if(index>0)print(index.."/"..#draw_tbl..":"..#draw_tbl[index][1],1,122,8)
end

function draw_los_visual()
	index%=255
	local pt= point(index%16,flr(index/16))
	if los_tbl[#pt] then
		spr(59,(pt*8):get_xy())
		foreach(los_tbl[#pt],function(p)
			spr(58,(p*8):get_xy())
		end)
	end
	print(index.."/255:"..#pt,1,122,8)
	spr(128,64,64)
end

function draw_sprite_preview()
	if(index>#floor_sprites)index%=#floor_sprites
	local i2=1
	for y=0,15 do
		for x=0,15 do
			local dpos= point(x,y)*8
			spr(floor_sprites[index],dpos:get_xy())
			if i2 <= #entity_sprites then
				spr(entity_sprites[i2],dpos:get_xy())
			end
			i2+=1
		end
	end
	print("tile "..floor_sprites[index],1,122,8)
end

function _draw()
	frame=(frame+1)%100
	cls()
	run_coroutines(draw_routines,true)
	if cart_state=="none" then
		sspr(48,0,32,32,0,0,128,128)
	elseif cart_state=="mem_ops" then
		draw_mem_info()
	elseif cart_state=="draw_testing" then
		draw_mapping_visual()
	elseif cart_state=="los_testing" then
		draw_los_visual()
	elseif cart_state=="sprite_preview" then
		draw_sprite_preview()
	end
	--######## draw menus ##########
	foreach(open_menus.values,
	function(m)m:draw()end)
	if(active_menu)active_menu:draw()
	--[[
	--## draw table debugging ##

	local blocked={}
	for i=1,#draw_tbl do
		local pts = draw_tbl[i]
		local pt=pts[1]
		spr(53,(pt*8):get_xy())
		if i==index then
			blocked[#pt] = 1
		end
		if blocked[#pt] then
			local x,y = (pt*8):get_xy()
			rectfill(x,y,x+8,y+8,blocked[#pt])
			print(blocked[#pt],x+1,y+1,10)
			for p=2,#pts do
				blocked[#pts[p] ]=blocked[#pt]+1
			end
		end
	end
	if(index>0)print(index.."/"..#draw_tbl..":"..#draw_tbl[index][1],1,122,8)

	--## los table debugging ##
	index%=255
	local pt= point(index%16,flr(index/16))
	if los_tbl[#pt] then
		spr(59,(pt*8):get_xy())
		foreach(los_tbl[#pt],function(p)
			spr(58,(p*8):get_xy())
		end)
	end
	print(index.."/255:"..#pt,1,122,8)
	spr(128,64,64)
	if(msg_redraw) msg_update() msg_redraw=false
	msg_draw()
	foreach(open_menus.values,
	function(m)
		m:draw()
	end)
	if(active_menu)active_menu:draw()
	rectfill(0,121,30,128,1)
	print(stat(0),1,122,8)
	--]]
end


--[[
--hex sorting
	local hex=""
	foreach(los_array,
	function(los_pt)
		local sorted={}
		add(sorted,los_pt[1])
		del(los_pt,sorted[1])
		while #los_pt>0 do
			local closest
			local cdist = 999
			foreach(los_pt,function(p)
				local pdist=point(8,8):exact_distance(p)
				if(pdist < cdist) closest,cdist=p,pdist
			end)
			add(sorted,closest)
			del(los_pt,closest)
		end
		if(#hex > 0)hex = hex..","
		hex=hex..pts_to_hex(sorted)
	end)
	log(hex)

--]]
__gfx__
12022201120220311202220111111111555155550000000000000000120222010122210000000000000000000000000000000000000000000000000000000000
212002201c1020312120022015551111511113350222200006666660212000201200021000000000000000000000000000000000000000000000000000000000
202110202c103031202110205511551533113133266112000ddddd10202110201200021000000000000000000000000000000000000000000000000000000000
22021020230230212202102011551155533551152ddd120006666220220210202000002000000000000000000000000000000000000000000000000000000000
02021021230c3021020210211115511133553311266662000ddd1210020210212000002000000000000000000000000000000000000000000000000000000000
02021021102c10210202102155111555133333332ddddd0006622110020210212000002000000000000000000000000000000000000000000000000000000000
12021210022c02111202121015555111513335532666666002121220120210202000002000000000000000000000000000000000000000000000000000000000
1202221002222011120222101111111155115511dddddddd00000000120210201000001000000000000000000000000000000000000000000000000000000000
1201120112011201222222221111111111111111120112011201120112111001126112610000000000000000000000009aa009aa9aaaa0009a9a00000009a000
6266626662666266200000021dd1222112221dd16999aaa66999aaa662666066622662260000000000000000000000009a00009a9a09a0009a9a000000009a00
20112011200000012cdddd021dd1222112221dd1192211a1192000a12111011111000061000000000000000000000000000000009a09a00009a000009aaaaaa0
26662666260bb7062cdddd021111122112211111690210a6692000a62666066666000026000000000000000000000000000000009a09a0009a9a000000009a00
120112011203bb012cdddd021122111111112211190210a1192000a11211101110000006000000000000000000000000000000009aaaa0009a9a00000009a000
62666266620000062ccddd021d221dd11dd122d1692211a6692000a6626660666000000200000000000000000000000000000000000000000000000000000000
20112011201120112ccccc021dd11dd11dd11dd1190210a1192000a121112011100000060000000000000000000000009a00009a000000000000000000000000
2666266626662666222222221111111111111111692211a6692000a626662066600000020000000000000000000000009aa009aa000000000000000000000000
33bbbb333333b3331b3333b11111111112211221b113b113b113b113333bb33333bbbb3300000000444444440000000000000000000000000000000000000000
0bb10bb1013bcb31131222311b2222b12b1221b2bb3b1b3bbb3b0b3b03b00b313b0001b30000000048c080340000000000000000000000000000000000000000
10b10b1103bcccb103112230121dd12121d11d12b3b313b3b3b000b310b00b111b0001b10000000048c289340000000000000000000000000000000000000000
10b10b11033bcb310dd11dd012dccd21121cc121b3b313b3b3b000b310b00b111b0001b100000000444444440000000000000000000000000000000000000000
10b10b11103b0b110dbddbd012dccd21121cc121b3b313b3b3b000b310b00b111b0001b1000000004389c8340000000000000000000000000000000000000000
10b10b11103b0b110bddddb0121dd12121d11d12b3b313b3b3b000b310b00b111b0001b100000000444444440000000000000000000000000000000000000000
0bb10bb1033b0b31133cc3311b2222b12b1221b2b3b313b3b3b000b303b00b313b0001b30000000049c389340000000000000000000000000000000000000000
33bbbb333333b333110000111111111112211221bbbbbbbbbbbbbbbb333bb33333bbbb3300000000444444440000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0c000101111011000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc0110000110000100044000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c000cccc0000011110000000001046600000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc000c0000c0c100011110010000045550000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc00c00cc000111001110000000046666000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000ccc00cc0011110001000000045555500
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00c00001110110000010046666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc00110111010000000045555555
0000070000000000000000000000000000000a0000000aaa0000000000000000000000000000000000aa90000000000000000000000000000000000000000000
00007a8000099000007fff40000490000000a9000000aa8000044470000040000000000000094990009990000000000000000000000000000000000000000000
0000aa800007700007fcff0000c4c9000000a900000aa8000444887000884b000099790000004690000a90000760076004400440060000700aa0087000000000
0000e8000007700007cfff00044ccc900000a90009aa8000447888700288780004474970000040900aaa90000765576005455490088558800aa8877000000000
00009400007cc70007cccf000444c99000008800099800004787887002888800047447900000400000a99000007666000044940000686800008aa80000000000
0000940007c7cc7007ffff400009f0000000080099440000447887000228880004447440000040000aaaa90000766600004494000086870000a8870000000000
00000400077cc770007ffff000009f000000000044000000048887000022200000444400000000000a999900007666000009900008087070008aa80000000000
00000000007777000000000000000000000000000400000007777000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00048800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a4aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a0aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000000000444440000000000
0000000000000000000000000009a90000000000004000000000000007777700000c000006000000000a00000044440000aaaa000077770004000400000cc000
00000000000000000000000000a000a00000000000400000008880000511110000cac000006666600aaaaa00094949400aaaaaa007cc777000444000007cc700
0000000000000000000000000090009000087000094999000881880005111100000c00000650550000aaa0000949494004aaaa900c00c770067a76000cc77cc0
00000000000000000000000000a000a0000780000942290001171100051111000000bb000656000000a0a00009494940044aa9900c00c77006a9a6000cc77cc0
0000000000000000000000000cc9a90000000000099999000771770006767600000b3b000650000000000000094949400444999007cc777006787600007cc700
0000000000000000000000000cc000000000000000000000007770000767670000b00000000000000000000000444400004499000077770004444400000cc000
000000000000000000000000000000000000000000000000000000000077770000b0000000000000000000000000000000049000000000000044400000000000
00000000000000000000000000000000000000000000000000000000000000000000000000c0000c000000000000000000000000000000000044000000000000
0009a9000ffffff00000060000ccccf00006660007700000000044440000000000000600000cc00c005dd50000000cc000bb0bb0000a000000444400000d0000
00a000a0044444400555555000ccccf000666660074000000004400700222200055555500cc00cc000d11d0000004cc00033033000aaa00000099000d0ddd0d0
00900090044444400555655000ccccf000655560000400000044007002222220055565500c00c0c0005dd500000444000bbb3bbb000a000000044900dd050dd0
00a000a0044444400556765000ccccf0006666600000400004400700044aa440055676500c0c00c00dd55dd0002400000bbb3bbb00000a0000444000d55555d0
0cc9a900000550000555655000ccccf000655560000004800400700004444440055565500cc00cc005dddd50024000000b00300b00a0aaa0044444000d0d0d00
0cc00000000440000000000000cffff00066666000000848040700000222222000000000c00cc0000555555004000000000330000aaa0a000444440000ddd000
00000000000440000000000000000000000000000000008004700000000000000000000000000c0000555500000000000000300000a000000044400000000000
00444400000444400044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00422400000422400042200409900990099099009944900000000000000000000000000000000000000000000000000000000000000000000000000000000000
0042240000042240004220470944449009944400947490000000000000000000000aaaa000aa9000000000000000000000a90000000000000000000000000000
0074740000074740004444740074470000097400009959900000000000000000000a90aa900a9000000000000000000000a90000000000000000000000000000
0747474000747474044747400099990000999900008559000000000000000000000a900aa90a9000000000000000000000a90000000000000000000000000000
0744744000744744047474000885588008885500088558000000000000000000000a9000a90a9000000000000000000000a90000000000000000000000000000
047444400047444a044774000855558088885550085558000000000000000000000a900aa90a90aa0000aaa000aaa900aaaaa90aaa00000aaa0000aa0000aaa0
0447777004447770777444008855558888855550885555800000000000000000000a90aa900aaaaa000aa0a900aaaa9000a900aa0a9000a00a900a9aa000a0a9
ef0404000e044000ef0044700008b80000008b000bb000bb0000000000000000000aaaa0000a900a90a900a900a90aa900a90a900a9000aa0000a900a90aa000
0e0747000f004740f04e4700000bbb000000bb000b00000b0000000000000000000a9000000a900a90a900a900a900a900a90a900a90000aa900a900a900aa90
f0044400e002444ee0024470000ebe3b0000b0000b08380b0000000000000000000a9000000a900a90a900a900a900a900a90a900a900a000a90a900a9a000a9
e0028200f2244220f22442207eeee33b66e0e3b00b4e3e4b0000000000000000000a9000000a900a000aa0a900a900a900a900aa0a9000a00a90aa9aa90a00a9
f0222220224444002244422273ee330b6eee30b00b0eee0b0000000000000000000aaa00000aa00a9000aa0aa0aa00aa00a9900aa0aaa0aaa9000aaa900aaa90
e024242024444240244440000733300b0ee330b0006eee0000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff24442024024240244444000555b0b0b555b0000b5e5e0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e2242202402400024422400b0b0b0000b0b0000b0b0b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007770000077700000777000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
008780000078700000878007111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
000700000005700000070007111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
006560000056000000656670111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
066566000656600006656600111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
055555000555550005555500111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
058885000588880005888500111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
088888000588880005888800111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
22222111222224198142212222212222222244112224491184442222142222224122222411114111844414422221142244444444444400000000000000000000
22222122222244118144214222212221224441122144991981144221142222224111221112244149842211422221142242222222222400000000000000000000
22221111444411188114414222212211441111111119991982114411422222224441111124449199811111444221142242222224222400000000000000000000
22221111111119888411114222212212111444411111111882211111422222222244111124999118811111114211422242222244222400000000000000000000
22211222244111198441114222212222222224411119888882111211422222222222441224991111844444411111442242222414222400000000000000000000
21112222441124198442111112112222222244411491118881142221144222212224411111111111844222211111112242222414222400000000000000000000
11122224111499118442211111112222222244112491491881444222111111112244111111199118842222111111111142222414222400000000000000000000
11222224111111188144214222212222222441124991491881444422211111114441144111491188842222114441222142222444222400000000000000000000
11111111112441889144214222211222222411111111118884444422211442221111424111111189942222114222222242222244222400000000000000000000
11444411122491899114414222211222221112244111988994444442211442221111221119991189a11221114222222242222244222400000000000000000000
2222441112249189a1144144222112221111222441498899a4411444441142221441221144491889a11111111422222242222222222400000000000000000000
2222224114441889a4111144442112211111222441498899a1111144441442224441221144991889a44111111142122242222222222400000000000000000000
22222441111118ddd4111111122111114441222411498dd77114411111144222224111124111777dd44411141111111242222222222400000000000000000000
222221111117777dd4442221111111112441224411177ddd711444411114422222412411117ddd77d42411144111111242244444442400000000000000000000
222221111155dd77d44442221111111222411111111d777dd4144444111144422441244117777ddd742211142222111142241141142400000000000000000000
2222111777777dddd44444221422222222441111167dddddd44442222211111124114411ddddd77dd42211142222111142241111142400000000000000000000
22111117755dddddd4444422142222222441115566777777dd4422222221111122411111d555dd77d22221142222142242244111442400000000000000000000
22115555557777dddd6444411422222244111555ddddddddd54422222221114422411177777776dd512221144222142242224111422400000000000000000000
11115577777ddd555776444144222222111677777777777775442222222114422211ddddddddddd5511111144422144242224444422400000000000000000000
117777775ddd55577776645544222222111677777666666dd5552222222114422211dd5555777766d55116111421114242222222222400000000000000000000
117777555555557777666555554422221116666666ddddd555552662222114422111d5577777666dd55576611441114242222222222400000000000000000000
117755555555777776665555555422661166666dddd55555555666662221114221777777777666dd555777661115114242222242222400000000000000000000
175555555577777666555555555566661166dddddd555555566666662255114277777777666ddd55557776666d55514442222444222400000000000000000000
15555555777777666d5555555555666611dddddd5555557776666666655551127777777666dd555557776666d555554442222242222400000000000000000000
1155555777777666dd555555557666665dddddd555555777766666665555551667777666ddd555557776666dd555555642222414222400000000000000000000
115557777777666dd5555555577666665ddddd5555577777666666d555555566666666ddd5555577776666dd5555555642224414422400000000000000000000
11577777776666dd555555577766666655dd55555577776666666dd5555555666666ddddd555557777666dd55555556642222444222400000000000000000000
177777777666ddd555555577766666665555555777777766666ddd555555566666ddddd5555557777666dd555555556642222222222400000000000000000000
17777777666ddd55555577777666666615557777777776666dddd555555566666ddddd5555557777666dd5555555566642222222222400000000000000000000
177777666ddddd55ddd77777666666651157777777776666dddd555555557666dddd55555557777666ddd5555555566644444444444400000000000000000000
1177666dddddddddd7777776666666d5177777777776666dddd5555555577666ddd55555557777666ddddd555555766600000000000000000000000000000000
11776dddddddddd77777777666666d5557777777776666dddddd5555557766665555555577777666ddddddddd557766600000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100010e05000000000000000000000200501c0501a0501b0501a05019050000000000029050280500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000000000152501b25020250272502c2502f2503525024250332501d2501e250232502d2502f2502d2502d2502b25033250322502f2500f2500d2501925020250262502e2501a250172501a2501d25021250
001000012a4502a4502945027450264502645026450000002545023450204501d4501c450244501c450264501d450274501e4501e4501c4501f4501d450204501e45020450224502245023450244500000000000
001000003765032650306502f6502e6502c6502765023650282502a2502a2502825028250272502725025250232501c2502e6502c6502b65025650146500f6500e6500e650106501465019650366503265027550
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
00 41424304
00 41424344
00 41424344

