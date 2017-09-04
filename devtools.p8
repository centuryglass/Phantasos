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
the full data set, but I'm not
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
	cstore(0x2000,0x2000,addr-start_addr,"phantasos.p8")
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
	--]]

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
222222222112112122222222555522555552555500000000000000000000000000000000000000001aaaaaa11aaaaaa11aaaaaa11111a1111111111111aa1111
122121222112212112212122522225555552255500000000000000000000000000000000000000001999999116666661166666611116aa11a611116a1aa91111
1221212122132221122121215555522222225255000000000000000000000000000000000000000011999911119669111166661111166aa1a991166aaa991111
12212221221322211221222122222252522522250000000000000000000000000000000000000000111991111119911111199111111666aaa999666aa9996661
12112121222322221211212122525555232223220000000000000000000000000000000000000000111661111116611111166111a9969661a999966a111666aa
12212121221221311221212125552552233225330000000000000000002200002200220000000000116666111169961111999911a9991111a991196a11166aa1
122221222112213112222122222222222233355300000000000000000022000022002200000000001669966119999991199999911a991111a911119a1116aa11
122221222112213212222122555522552222552200000000000000000022000022002200000000001aaaaaa11aaaaaa11aaaaaa111aa1111111111111111a111
55555555555555555555555511111111111111110055555500000002222222222222222200000000b33b333b334434439aa009aa9aaaa0009a9a00000009a000
56656656599999965665665614415551155514410044445600000022222222222222222220000000333b333b334433439a00009a9a09a0009a9a000000009a00
5555555559aaaa9555555555144155511555144154421445000000222222222222222222200000003b333b3334433343000000009a09a00009a000009aaaaaa0
6656656669a99a9666566566111115511551111164121246000000222220000000000222200000003b3b3b3334333443000000009a09a0009a9a000000009a00
5555555559a99a955555555511551111111155115412124500000022220000000000002220000000333b333b34333443000000009aaaa0009a9a00000009a000
656656656999999565665665145514411441554164121245000222222200000000000022222220003b33333b3433344300000000000000000000000000000000
555555555555555555555555144114411441144154121245000222222200000000000022222220003b3b3b33344333439a00009a000000000000000000000000
65666565656665656566656511111111111111116444444500022222220000002220002222222000333b3b3b344333439aa009aa000000000000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaa777777a897aa798a999a9990000002222000000222000222000000044444444a777777aaaaaaaaa444400000000000004222222
9aa99aa99aa88aa99aa99aa97a9999a799a88a99aa9a1a9a0000002222000000222200222000000048c080347a9999a79aa99aa9422444444444444404222222
99a99a999a8888a999a99a9979a88a977a8998a7a9a919a90002222222000000222222222222200048c2893479a88a9799a99a99422222222222222204222222
99a99a999aa88aa999a99a99798aa897a89aa98aa9a919a90002222222000000002222222222200044444444798aa89799a99a99442222222222222204222222
99a99a9999a99a9999a99a99798aa897a89aa98aa9a212a9000000222200000000000002200000004389c834798aa89799a99a99042222222222222204222222
99a99a9999a99a9999a99a9979a88a977a8998a7a9a212a9000000222200000000000002200000004444444479a88a9799a99a99042222222222222204222222
9aa99aa99aa99aa99aa99aa97a9999a799a88a99a9a919a90002222222000000000000022222200049c389347a9999a79aa99aa9042222222222222204222222
aaaaaaaaaaaaaaaaaaaaaaaaa777777a897aa798aaaaaaaa0002222222200000000000222222200044444444a777777aaaaaaaaa042222222222222204222222
0000000000000000000000000000000000000000b000000b000000222222222222222222200000001111111188899998000000aa101101110000500000000000
00000000000000000000000000000000000000000b0000b0000000222222222222222222200000001cccccc1998888880000000a011011010000000044000000
00000000000000000000000000000000000000000000000000000002222222222222222200000000111111119999899900000000110110110000000046600000
00000000000000000000000000000000000000000000000000000000000220002200220000000000cc111ccc9998888900000000101101110500500045550000
00000000000000000000000000000000000000000000000000000000000220002200220000000000111111118888999800000000011011100000005046666000
00000000000000000000000000000000000000000000000000000000000220002200220000000000ccccc11c9989999900000000110111010000000045555500
00000000000000000000000000000000000000000b0000b0000000000000000000000000000000001111111189998888a0000000101110110050000046666660
0000000000000000000000000000000000000000b000000b00000000000000000000000000000000cc111ccc88888999aa000000011101100000050045555555
0000000000099000000000000000000000000000000000000000000000aa90000044000000000000000440000000000000000777000000000000000000000000
000aa00000077000000000000fffff00000cc0000077770000000cc00099900000444400000a000000c4440000bb0bb0000077600ffffff0000d000000000000
00a88a0000777700000080000ffcff00007cc70007cc777000004cc0000a90000009900000aaa000044444c0003303300007760004444440d0ddd0d00044f400
00affa00077cc770000888000fcfff000cc77cc00c00c770000444000aaa900000044900000a000044cc44440bbb3bbb0277600004444440dd050dd0044f44f0
000f400007cccc7000aa8aa00fcccf000cc77cc00c00c7700024000000a990000044400000000a0044cc44440bbb3bbb0226000004444440d55555d004f44f40
000f400007cccc7000a000a00fffff70007cc70007cc7770024000000aaaa9000444440000a0aaa0000ff0000b00300b22440000000550000d0d0d000444f440
0004400007cccc7000aa0aa00ffffff0000cc00000777700040000000a999900044444000aaa0a0000ffff0000033000440000000004400000ddd00000444400
0000000007777770000aaa0000000000000000000000000000000000000000000044400000a00000000ff0000000300004000000000440000000000000000000
0000000000c0000c00000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000777000444440000000000
005dd500000cc00c0000a9000000444407700000000000000000887000000600000c00000009a90000ccccf00006660000044000007777700400040000050000
00d11d000cc00cc00000a90000044007074000000760076008888e700555555000cac00000a000a000ccccf0006666600084b000007575700044400006686600
005dd5000c00c0c00000a9000044007000040000076dd76088788e7005556550000c00000090009000ccccf0006555600888880000677760067a760006686600
0dd55dd00c0c00c00000880004400700000040000076660087878e70055676500000bb0000a000a000ccccf000666660088888000077577006a9a60008888800
05dddd500cc00cc0000008000400700000000480007666008878e70005556550000b3b000cc9a90000ccccf00065556008888800006777600678760006686600
05555550c00cc000000000000407000000000848007666000eeee7000000000000b000000cc0000000cffff00066666000888000006555600444440000686000
0055550000000c0000000000047000000000008000000000077770000000000000b0000000000000000000000000000000000000000666000044400000080000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000000000000000000000000
0000000000606000007777700ccccc00000000000040000000000000077777000060400006000000000a00000044440000aaaa00000000000000000000000000
0022220000666000006060600c1111000000000000400000008880000511110006664600006666600aaaaa00094949400aaaaaa0000000000000000000000000
0222222000060000006060600c10c10000087000094999000881880005111100006040000650550000aaa0000949494004aaaa90000000000000000000000000
044aa44000060000006060600c10c10000078000094229000117110005111100000040000656000000a0a00009494940044aa990000000000000000000000000
0444444000060000006060600c10c100000000000999990007717700067676000000400006500000000000000949494004449990000000000000000000000000
0222222000060000005555500c10c100000000000000000000777000076767000000400000000000000000000044440000449900000000000000000000000000
00000000000000000000000000000000000000000000000000000000007777000000000000000000000000000000000000049000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666600000666600777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00622600000622600662200109900990099099009944900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d22d00000622d00dd220170944449009944400947490000000000000000000000aaaa000aa9000000000000000000000a90000000000000000000000000000
00757500000757500055517600744700000974000099d9900000000000000000000a90aa900a9000000000000000000000a90000000000000000000000000000
075757d00075757d05576760009999000099990000cdd9000000000000000000000a900aa90a9000000000000000000000a90000000000000000000000000000
075576d00075576d057576000ccddcc00cccdd000ccddc000000000000000000000a9000a90a9000000000000000000000a90000000000000000000000000000
0575ddd000575ddd055776000cddddc0ccccddd00cdddc000000000000000000000a900aa90a90aa0000aaa000aaa900aaaaa90aaa00000aaa0000aa0000aaa0
055776600555776677766600ccddddcccccdddd0ccddddc00000000000000000000a90aa900aaaaa000aa0a900aaaa9000a900aa0a9000a00a900a9aa000a0a9
ef0414000e044000ef0044700000000000000000000000000000000000000000000aaaa0000a900a90a900a900a90aa900a90a900a9000aa0000a900a90aa000
0e0a4a000f004a40f04a47000000000000000000000000000000000000000000000a9000000a900a90a900a900a900a900a90a900a90000aa900a900a900aa90
f0044400e002444ee00244700000000000000000000000000000000000000000000a9000000a900a90a900a900a900a900a90a900a900a000a90a900a9a000a9
e002e200f2244220f22442200000000000000000000000000000000000000000000a9000000a900a000aa0a900a900a900a900aa0a9000a00a90aa9aa90a00a9
f022222022444400224442220000000000000000000000000000000000000000000aaa00000aa00a9000aa0aa0aa00aa00a9900aa0aaa0aaa9000aaa900aaa90
e0242420244442402444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff244420240242402444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e224220240240002442240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008b80000008b000bb000bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bbb0000003b000b00000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001b13b000030000b08380b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6111133b661013b00b31313b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6311330b611130b00b01110b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0633300b011330b00061110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0555b0b0b555b0000b51510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0b0b0000b0b0000b0b0b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777000007770000077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00878000007870000087800700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000000570000007000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00656000005600000065667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06656600065660000665660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555500055555000555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05333500053333000533350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03333300053333000533330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222111222224198142212222212222222244112224491184442222142222224122222411114111844414422221142200000000000000004221222222222224
22222122222244118144214222212221224441122144991981144221142222224111221112244149842211422221142200000000000000001411122212211141
22221111444411188114414222212211441111111119991982114411422222224441111124449199811111444221142200000000000000001142221112222411
22221111111119888411114222212212111444411111111882211111422222222244111124999118811111114211422200000000000000001114111222224111
22211222244111198441114222212222222224411119888882111211422222222222441224991111844444411111442200000000000000001111412211141111
21112222441124198442111112112222222244411491118881142221144222212224411111111111844222211111112200000000000000001111142222411111
11122224111499118442211111112222222244112491491881444222111111112244111111199118842222111111111100000000000000002111114224111111
11222224111111188144214222212222222441124991491881444422211111114441144111491188842222114441222100000000000000002111211001122112
11111111112441889144214222211222222411111111118884444422211442221111424111111189942222114222222200000000000000002211212551122112
11444411122491899114414222211222221112244111988994444442211442221111221119991189a11221114222222200000000000000002211216677221122
2222441112249189a1144144222112221111222441498899a4411444441142221441221144491889a111111114222222000000000000000012211ddd55511121
2222224114441889a4111144442112211111222441498899a1111144441442224441221144991889a44111111142122200000000000000001121dd5555551221
22222441111118ddd4111111122111114441222411498dd77114411111144222224111124111777dd44411141111111200000000000000001116666677777211
222221111117777dd4442221111111112441224411177ddd711444411114422222412411117ddd77d424111441111112000000000000000011dddd5555555511
222221111155dd77d44442221111111222411111111d777dd4144444111144422441244117777ddd74221114222211110000000000000000dddd555555555551
2222111777777dddd44444221422222222441111167dddddd44442222211111124114411ddddd77dd42211142222111100000000000000006666666777777777
22111117755dddddd4444422142222222441115566777777dd4422222221111122411111d555dd77d22221142222142242222211121111144111112222222224
22115555557777dddd6444411422222244111555ddddddddd54422222221114422411177777776dd512221144222142214211111222222411412222111111241
11115577777ddd555776444144222222111677777777777775442222222114422211ddddddddddd5511111144422144211412222222224111142222222221411
117777775ddd55577776645544222222111677777666666dd5552222222114422211dd5555777766d55116111421114221141222111141111224221112224212
117777555555557777666555554422221116666666ddddd555552662222114422111d5577777666dd55576611441114222114222222411111122411212241112
117755555555777776665555555422661166666dddd55555555666662221114221777777777666dd555777661115114222111411124112211121142222421112
175555555577777666555555555566661166dddddd555555566666662255114277777777666ddd55557776666d55514422112142242211221121124224112212
15555555777777666d5555555555666611dddddd5555557776666666655551127777777666dd555557776666d555554422112110022211222121121001211211
1155555777777666dd555555557666665dddddd555555777766666665555551667777666ddd555557776666dd55555561221221d511112212112122661211211
115557777777666dd5555555577666665ddddd5555577777666666d555555566666666ddd5555577776666dd555555561122116777212221211121dd55211212
11577777776666dd555555577766666655dd55555577776666666dd5555555666666ddddd555557777666dd55555556611222dd5555122112211266677512112
177777777666ddd555555577766666665555555777777766666ddd555555566666ddddd5555557777666dd555555556621126667777722121212ddd555551122
17777777666ddd55555577777666666615557777777776666dddd555555566666ddddd5555557777666dd55555555666221ddd5555555512111ddd5555555511
177777666ddddd55ddd77777666666651157777777776666dddd555555557666dddd55555557777666ddd5555555566622dddd55555555521166666777777771
1177666dddddddddd7777776666666d5177777777776666dddd5555555577666ddd55555557777666ddddd555555766626677777777777772666677777777777
11776dddddddddd77777777666666d5557777777776666dddddd5555557766665555555577777666ddddddddd5577666ddddd55555555555ddddd55555555555

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
00 4142434
