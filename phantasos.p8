pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
--[[
phantasos v.0.6
copyright anthony brown 2017
this work is licensed under a
creative commons attribution 4.0
international license
https://creativecommons.org/
licenses/by/4.0/
--]]

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
	return true if str can be
	converted to a number. odd uses
	of number symbols (e.g) "05.6.7"
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
				if (sub(str,i,i) == sub(match,k,k))return true
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
i was losing button presses between
game turns, so now _update stores
pending button presses until
they're ready to be used. this
function replaces btnp(),
prioritizing pending button presses
over new input

[n]:a button number to check
--]]
function button(n)
	if b_pending then
		if(n)return band(b_pending,2^n)==2^n
		return b_pending
	end
	return btnp(n)
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

--###-game turn management-####--

--[[
start a new game turn, generating
creatures if necessary. does
nothing if a turn is still running

return:true if a new turn was
started.
--]]
function start_turn()
	if(turn_running)return
	turn_running = true
	if num_creatures < max_creatures
	then
		p = rnd_pos(function(p,t)
			return t.spawn_table and not
			(screen > p) and not
			get_entities(p)
		end)
		if p then
			prob_tbl(get_tile(p).spawn_table,
			function(class)
				class(p)
				return true
			end)
		end
	end
end

--[[
run a scheduled action on turn start

t: the starting turn
n: number of turns to repeat
fn(): action to run
--]]
function turn_routine(t,n,fn)
	local start=turn
	turn_routines(cocreate(function()
		while turn != (t+n)%1000 and
		n!=0 do
			if(turn>=t or turn<start) fn() n-=1
			yield()
		end
	end))
end

--[[
applys a status effect

target:the affected creature
duration:number of turns the
	effect will last
[on_turn]:callback function to
	run each turn
[on_end]:callback function to run
	when the effect finishes
[start_msg,turn_msg,end_msg]:
	messages to display at different
	times if the affected creature
	is visible.
--]]
function status_effect(target,duration,
on_turn,on_end,
start_msg,turn_msg,end_msg)
	if(visible(target))name_msg(target,start_msg)
	turn_routine(turn,duration,function()
		if(target.hp<=0)return
		if(visible(target))name_msg(target,turn_msg)
		on_turn()
	end)
	turn_routine((turn+duration)%1000,1,function()
		if(target.hp<=0)return
		if(visible(target))name_msg(target,end_msg)
		on_end()
	end)
end

--reused status effects
function poison(target)
	status_effect(target,rndint(9,5),
		function() target-=1 end,nil,
		nil," is hurt by poison.",
		" recovers from poison.")
end

function sleep(target)
	if(target==you)ctrl=no_ctrl
	target.sleeping=true
	status_effect(target,rndint(10,8),
			function() target+=1 end,
			function()
			if(target==you)ctrl=default_ctrl
			target.sleeping=false
			end,
			" fell asleep.",
			" is fast asleep.",
			" woke up!.")
end

--[[
handles all the results of using
an item or tile including
use effects, starting the turn,
closing menus, and changing item
quantity

itm:any object
c:the entity using the object
return:true if c was able to use
	itm
--]]
function use(itm,c)
	if itm.use then
		start_turn()
		if(c==you) msg(itm.use_msg) menu_close_all()
		itm:use(c)
		if itm.qty then
			itm:change_qty(-1)
		end
		return true
	end
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


--[[
##########- level map -##########
--]]

--initialize a new level map
function level_init()
	lvl,
	lvl_entities,
	lvl_area,
	lvl_bounds = {},{},
	rectangle"0,0,30,30",
	rectangle"1,1,28,28"
	foreach_pos(function(p)
		lvl[#p]=void
	end)
end

--[[
check if a point or area p
is within lvl_bounds
not (lvl_bounds>p) : 5 tokens
not lvl_bounds(p) : 4 tokens
--]]
function in_bounds(p)
	return lvl_bounds>p
end

--get the tile at point p
function get_tile(p)
	return lvl[#p]
end

--set the tile at point p to t
function set_tile(p,t)
	if lvl_area>p then
		t.bright=get_tile(p).bright
		lvl[#p] = t
	end
end

--add entity e at e.pos
function add_entity(e)
	local key = #e.pos
	if lvl_entities[key] then
		add(lvl_entities[key],e)
	else
		lvl_entities[key] = {e}
	end
	if(e.on_level_add)e:on_level_add()
	if(creature<e)num_creatures+=1
	if(screen > e.pos)redraw=frame
end

--get the list of all entities
--at pos
function get_entities(pos)
	return lvl_entities[#pos]
end

--get the creature at pos
--(there should be at most 1)
function get_creature(pos)
	for e in all(lvl_entities[#pos]) do
		if(creature<e) return e
	end
end

--[[
remove an entity from the level
e: an entity in lvl_entities

[moving]: if true, e is just
		being moved and on_level_remove
		doesn't get called
--]]
function remove_entity(e,moving)
	if e.pos then
		local key = #e.pos
		if lvl_entities[key] then
			del(lvl_entities[key],e)
			if(#lvl_entities[key]==0)lvl_entities[key]=nil
			if(creature<e)num_creatures-=1
			if(screen > e.pos)redraw=frame
			if not moving then
				if(e.on_level_remove)e:on_level_remove()
				if(e!=you)e.pos=nil
			end
		end
	end
end

--move entity e to point pos
function move_entity(e,pos)
	remove_entity(e,true)
	e.pos(pos)
	add_entity(e)
end

--[[
	return true if rectangle r contains
	only void tiles

	[type]: if provided, look for this
	tile class instead of void
--]]
function rect_empty(r,type)
	type = type or void
	local empty=true
	foreach_tile(function(p,t)
		if(not(type<t))empty=false return true
	end,r)
	return empty
end

--[[
	run fn(pos)
	for each 1x1 tile position,
	stopping early if fn returns true

	[area]:if provided, only check
			tile positions within this
				rectangle
--]]
function foreach_pos(fn,area)
	area = area or lvl_area
	for y=area.y,area.y+area.h-1 do
		for x=area.x,area.x+area.w-1 do
			if(fn(point(x,y))) return true
		end
	end
end

--[[
identical to foreach_pos, except
it calls fn(point,tile) instead
of fn(point), and will not run
fn on points with no tile
--]]
function foreach_tile(fn,area)
	foreach_pos(function(p)
		local t = get_tile(p)
		if (t and fn(p,t)) return true
	end,area)
end

--[[
for each entity e in the level,
run fn(e), stopping and returning
true if fn returns true

[area]:if provided, only get
entities within this rectangle
--]]
function foreach_entity(fn,area)
	local elist = {}
	function add_all(arr)
		foreach(arr,function(e)
			add(elist,e)
		end)
	end
	if area then
		foreach_pos(function(p)
			add_all(get_entities(p))
		end,area)
	else
		foreach_pair(lvl_entities,add_all)
	end
	return foreach(elist,fn)
end

--[[
	run fn(self,pos,tile)
	for each tile adjacent to point
	pos. stop if fn returns true

	[skip_diag]:if true, dont run
		fn on diagonally adjacent tiles.
	[inc_center]:if true, run fn
			on pos.
--]]
function foreach_adj(pos,fn,
	skip_diag,inc_center)
	local adj = rectangle(pos):expand(1)
	foreach_tile(function(p,t)
		if (p != pos or inc_center)
		and (not skip_diag
		or p.x==pos.x or p.y==pos.y) then
			return fn(p,t)
		end
	end,adj)
end

--[[
find the first solid tile
blocking the path from p1 to p2.
uses angband's line of sight
algorithm, pre-calculated for
all positions in a 16x16 grid

[cblock]:if true,creatures also
		block the path
--]]
function blockpt(p1,p2,cblock)
	local offset = point(8,8)-p1
	local rel = p2+offset
	if(not los_tbl[#rel])return p1
	for blocker in all(los_tbl[#rel]) do
		blocker -= offset
		local t = get_tile(blocker)
		if(t and t.solid) return blocker
		if(cblock and get_creature(blocker))return blocker
	end
end

--[[
return true if p2 can be seen
from p1.
--]]
function los(p1,p2)
	return not blockpt(p1,p2)
end

--[[
	return the number of type
	(class) tiles around (pos).
	optional (skip_diag): if true,
	diagonally adjacent tiles are
	not counted, defaults to false
--]]
function next_to
(pos,class,skip_diag)
	local num_found=0
	foreach_adj(pos,
	function(p,t)
		if class<t then
			num_found += 1
		end
	end,skip_diag)
	return num_found
end


--[[
find a path for a creature to
take

dst: destination point
[path_fn](path,pos,tile,steps,
	paths): returns
 value of travelling over pos.
	lower=better, nil=can't go here
[range]:any tile
	within (range) units of dst will
	be a valid destination
--]]
function pathfind(src,dst,path_fn,range)
	--log("finding path to "..#dst)
	--pathtrace = {}
	local closest,final
	local paths,s_queue,
	cval,ptimer,path_fn,range=
	{
		[#src] = {
			steps = 0,
			priority = 0
	}},
	p_queue(),999, timer(),
	path_fn or
	function(pos,tile)
		if(not tile.solid) return 0
	end,range or 0
	s_queue(#src,0)
	--pathtrace[#dst]=10--yellow=destination attempt
	while #s_queue > 0 do
		ptimer()
		local srckey = -s_queue
		if point(srckey):dist(dst)
		< cval+5 and stat(0)<1000 then
			--pathtrace[srckey] = 12--blue =src
			foreach_adj(point(srckey),
			function(p,t)
				local poskey,steps,distance=
				#p,
				paths[srckey].steps+1,
				p:dist(dst)
				local priority =
				distance <= range and 0 or
				(not paths[poskey] or paths[poskey].steps > steps)
				and distance <= cval+5 and path_fn(p,t,dst,steps,paths,srckey)
				if priority then
					paths[poskey] = {
						steps=steps,
						prev=srckey
					}
					if(distance < cval)cval,closest=distance,poskey
					if distance <= range then
						final = poskey
						return true
					end
					priority+=distance+steps
					--pathtrace[poskey]=9--orange=pending
					s_queue(poskey,priority)
				--else pathtrace[poskey]=8--red=blocked
				end
			end,true)
			if(final) s_queue:clear()
		--else pathtrace[srckey]=14--pink=too far off path
		end
	end
	local path,i = stack(),final or closest
	while i and paths[i].prev do
		path(point(i))
		--pathtrace[i]=3--dark green=on final path
		i=paths[i].prev
	end
	--pathtrace[final]=10--green=destination reached
	--log("found path of length "..#path)
	return #path>0 and path
end

--[[
set all tiles in rectangle r to
new instances of class
--]]
function set_rect(r,class)
	foreach_pos(function(p)
		set_tile(p,class())
	end,r)
end


--[[
get a random map position

[validate]:function(p,t)
		returns true if the position
		chosen is valid.if not provided,
		gets a random, in-bounds,
		passable, entity free location
		in the level.
--]]
function rnd_pos(validate)
	validate = 	validate or
	function(p,t)
		return not t.solid and not
		get_entities(p)
	end
	local untried = rnd_queue()
	for i=1,784 do
		untried("x="..(i%28+1)..",y="..flr(i/28+1))
	end
	while #untried > 0 do
		local pos=point(-untried)
		if(validate(pos,get_tile(pos))) return pos
	end
end

--[[
launch an entity across the map,
drawing its path. used for
throwing items, etc

e: the entity to launch
		note: for now, it's assumed
		that e starts out without a
		position in the level, and e
		isn't added to the level afterwards
		todo: consider changing this
src: starting position
dst: targeted end position, will
	be replaced if a creature or
	solid tile is encountered on the
	path from src to dest
post: callback function to run
	after the entity lands,
	the final value of dst will be
	passed to it
--]]
function launch(e,src,dst,post)
	dst = blockpt(src,dst,true) or dst
	local dpos,offset=
	draw_pos(src),(dst-src)*2
	draw_routines(cocreate(function()
		for i=1,4 do
			dpos+=offset
			e:draw(dpos)
			yield()
		end
		if(post) post(dst)
	end))
end

--[[
######## entity class ###########
represents things with a location
within a level map
--]]
entity = object:subclass
	"classname=entity,name=entity,color=8,sprite=93"

--[[
if given an initial position,
immediately add the entity to the
map
--]]
function entity:init(pos)
	if pos then
		self.pos = point(pos)
		add_entity(self)
	end
end

--[[
	return true if pos is within
	the entity's sight radius
	and unobstructed
--]]
function entity:can_see(pos)
	local t,p = get_tile(pos),self.pos
	return pos==p or
	(p:dist(pos)<=self.sight_rad
	or t.bright)and los(p,pos)
end

--[[
		draw the entity on the screen

		[dpos]: screen coordinates,
		if not provided the entity is
		drawn at its position on the
		level map
--]]
function entity:draw(dpos)
	dpos = dpos or draw_pos(self.pos)
	if(self.p_swap) pal(12,self.p_swap)
	spr(self.tempsprite or self.sprite,dpos:get_xy())
	pal()
	local weapon=self.equipped and self.equipped.weapon
	if(weapon)weapon:draw(dpos+point(2,0))
	if self.tempsprite then
		redraw,self.tempsprite=frame+4,nil
	end
end

--[[
#########-item class-############
represents passive entities that
can move between the map and
creature inventories
--]]
item = entity:subclass
	"classname=item,sprite=108,name=item,qty=1"

--[[
if initialized with a point,
put the item on the map at that
point.
if initialized with a creature,
put the item in that creature's
inventory
if initialized with another item,
copy that item's properties, but
don't put the new item anywhere
--]]
function item:init(params)
	if creature<params then
		params:take(self)
	elseif point<params then
		entity.init(self,params)
	end
	if self:class()<params then
		copy_all(params,self)
		self.holder,self.pos=nil,nil
	end
end

--[[
change this item's quantity,
removing it from the level map/
creature inventory if quantity
reaches 0.

qty: number added to the item
quantity
--]]
function item:change_qty(qty)
	self.qty+=qty
	if self.qty <=0 then
		if self.holder then
			del(self.holder.items,self)
		end
		remove_entity(self)
		self.holder,self.pos=nil,nil
	end
end

--[[
#########- items -############
--]]

--[[
food items restore hit points
--]]
meat= item:subclass
"classname=meat,sprite=70,name=meat,color=14,hp_boost=5,use_msg=you feel much better."
function meat:use(c)
	c+=self.hp_boost
end

apple=meat:subclass
"classname=apple,sprite=71,name=apple,color=8,hp_boost=3,use_msg=you feel a bit better."

bread=meat:subclass
"classname=bread,sprite=72,name=bread,color=8,hp_boost=6"

--[[
statues block off the tile they're
on, and can be picked up, placed,
and thrown. interesting tactical
opportunities
--]]
statue=item:subclass
"classname=statue,sprite=74,name=statue,color=10"
function statue:on_level_add()
	get_tile(self.pos).solid=true
end
function statue:on_level_remove()
	local t = get_tile(self.pos)
	t.solid = t:class().solid
	end

	--[[
abstract class for items with
different colors/functions.
each has several variants,
effects only become apparent
on use
--]]
color_coded_itm=item:subclass
"classname=color_coded_itm"
function color_coded_itm:classgen()
	self.num_types,self.types=
	#self.names,{}
	--randomize color/function assignment
	local types= rnd_queue()
	foreach_pair(self.colors,
	function(v,k)
		types{
			name= v .." "..self.classname,
			color = k
		}
	end)
	for i=1,self.num_types do
		local type = -types
		type.real_name,
		type.use_msg,
		self.types[i]=
		self.names[i].." "..self.classname,
		self.messages[i],type
	end
end

--[[
	choose a random type, or copy an
	existing object
	--]]
function color_coded_itm:init(params)
	item.init(self,params)
	if not self.type then
		self.type = rndint(self.num_types)
		local type = self.types[self.type]
		self.name,self.use_msg,self.p_swap
		=type.name,type.use_msg,type.color
	end
end

--[[
creature c uses this item. if the
player sees this,reveal its identity
--]]
function color_coded_itm:use(c)
	local types = self:class().types
	local type = types[self.type]
	local name,real_name = self.name,
	type.real_name
	if visible(c) and name !=
	real_name then
		function update_names(i)
			if(i.name==name)i.name=real_name
		end
		update_names(type)
		foreach_entity(function(e)
			update_names(e)
			if e.items then
				foreach(e.items,function(i)
				update_names(i) end)
			end
		end)
		msg("that was a "..real_name)
	end
	self:on_use(c)
end

potion=color_coded_itm:subclass"classname=potion,sprite=65,color=13,names=1:healing;2:vision;3:poison;4:wisdom;5:sleep;6:lethe;7:water;8:juice;9:spectral;10:toughness;11:blindness,messages=1:you are healed;2:you see everything!!;3:you feel sick;4:you feel more experienced;5:you fell asleep;6:where are you?;7:refreshing!;8:yum;9:you feel ghostly;10:nothing can hurt you now!;11:who turned out the lights?,colors=0:murky;1:viscous;2:fizzing;3:grassy;4:umber;5:ashen;6:smoking;7:milky;8:bloody;9:orange;10:glowing;11:lime;12:sky;13:reeking;14:fragrant;15:bland"
potion:classgen()
function potion:on_use(c)

	local type,is_player,n_turns=
	self.type,c==you,rndint(10,4)
	--healing: restore max hp
	if(type == 1)c.hp=c.hp_max
	--vision: see everything for
	--a few turns
	if type == 2 then
		if(is_player)reveal_all=true
		c.can_see=always_true
		status_effect(c,rndint(5,2),
		nil,function() c.can_see=nil reveal_all=false end,
		"'s perception expands.",
		nil,"'s vision returns to normal")
	end
	--poison: take damage for several
	--turns
	if(type == 3)poison(c)
	--experience boost
	if(type == 4)c.exp=flr((c.exp+10)*1.5)
	--sleep: prevents action and
	--restore 1 hp per turn
	if(type == 5)sleep(c)
	--amnesia: forget the level layout
	--todo: make this do something to
	--non-player creatures
	if type == 6 then
		if(not is_player) return
		foreach_tile(function(p,t)
			t.seen = nil
		end)
	end
	--7:water. does nothing
	--juice: slight hp restoration
	if(type == 8)c+=2
	--spectral: walk through solid
	--objects. take care not to be
	--in a wall when it wears off
	if type == 9 then
		c.spectral = true
		local start,duration =
		turn,rndint(20,10)
		status_effect(c,duration,
			function()
				if(turn == (start+duration-3)%1000)name_msg(c," is fading back.")
			end,
			function()
				c.spectral = nil
				if get_tile(c.pos).solid then
					name_msg(c," is stuck in a wall!")
					c-=999
				end
			end,
			" can walk through walls.",nil,
			" is solid again.")
	end
	--invincibility: block attack
	--damage for a few turns
	if type == 10 then
		c.ac+=999
		status_effect(c,rndint(7,3),
		nil,function() c.ac-=999 end,
		" is invincible!",nil," looks vulnerable.")
	end
	--blindness
	if type == 11 then
		c.can_see=always_nil
		status_effect(c,rndint(12,8),
		nil,function() c.can_see=nil end,
		" is blind!",nil," can see again.")
	end
end

--[[
when thrown, potions shatter,
affecting all creatures in a 3x3
square
--]]
function potion:on_throw(pos)
	name_msg(self," shatters!")
	foreach_adj(pos,function(p,t)
		local c = get_creature(p)
		if(c) self:use(c)
		self.sprite=60
		draw_routines(cocreate(function()
			for i=1,3 do
				self:draw(draw_pos(p))
				yield()
			end
		end))
	end,false,true)
	remove_entity(self)
end

--[[
mushrooms mostly have minor effects,
mostly bad. beware the deathcap.
--]]
mushroom=color_coded_itm:subclass
"classname=mushroom,sprite=67,color=4,names=1:tasty;2:disgusting;3:deathcap;4:magic,messages=1:that was delicious;2:that was awful;3:you feel deathly ill;4:look at the colors!,colors=1:speckled;3:moldy;6:chrome;8:bleeding;14:lovely;15:fleshy"
mushroom:classgen()
function mushroom:on_use(c)
	local type=self.type
	if(type == 1)c+=10
	if(type == 2)c-=1
	if(type == 3)c.hp=1
	if type == 4 then
		c.hallucinating = true
		status_effect(c,rndint(15,4),
		nil,function() c.hallucinating=false end,
		" looks unsteady.",nil,"'s vision clears.")
	end
end

--[[
another one-use magic item type.
general rule: potions affect
creature status, scrolls interact
with the level map
--]]
scroll=color_coded_itm:subclass
"classname=scroll,sprite=66,names=1:movement;2:wealth;3:summoning,messages=1:you are somewhere else;2:riches appear around you;3:you have company!,colors=0:filthy;1:denim;4:tattered;6:faded;8:ominous"
scroll:classgen()
function scroll:on_use(c)
	local type=self.type
	local gentable
	if(type == 1)move_entity(c,rnd_pos(nil,-1))
	if(type == 2) gentable="item_table"
	if(type == 3) gentable="spawn_table"
	if gentable then
		foreach_adj(c.pos,function(p,t)
			while not prob_tbl(t[gentable],
			function(class)
				if class != scroll then
					class(p)
					return true
				end
			end) do end
		end)
	end
end

equipment=item:subclass"classname=equipment,bonuses=hitbonus:1"

function equipment:equip(c)
	local equip_slot,itm=self.equip_slot,
	c:drop(self,1,point(99,99))
	local equipped=c.equipped[equip_slot]
	if(equipped)equipped:remove()
	foreach_pair(self.bonuses,
	function(v,k)
		c[k]+=v
	end)
	remove_entity(itm)
	c.equipped[equip_slot],itm.holder
	=itm,c
end

function equipment:remove()
	local holder=self.holder
	holder.equipped[self.equip_slot]=nil
	foreach_pair(self.bonuses,
	function(v,k)
		holder[k]-=v
	end)
	holder:drop(self)
	holder:take(self)
end

--[[
tiles lit by torches (marked as
bright) are visible up to 16
tiles away as long as nothing
blocks them

when equipped, torches serve as
a weak weapon and extend sight
radius
--]]
torch = equipment:subclass
	"classname=torch,sprite=64,name=torch,sight_rad=4,color=10,equip_slot=weapon,bonuses=sight_rad:1;dmin_boost:1;dmax_boost:1"

	--[[
	run fn(p,t) for each map tile
	lit by the torch
	--]]
	function torch:foreach_lit(fn)
		local light_area = rectangle(self.pos)
		:expand(self.sight_rad)
		foreach_tile(function(p,t)
			if p:dist(self.pos) < self.sight_rad
			and los(self.pos,p) then
				fn(p,t)
			end
		end,light_area)
	end
function torch:on_level_add()
	self:foreach_lit(
	function(p,t)
		if not (void<t) then
			t.bright = t.bright
			and t.bright+1 or 1
		end
	end)
end
function torch:on_level_remove()
	self:foreach_lit(
	function(p,t)
		if(t.bright)t.bright-=1
		if(t.bright==0)t.bright=nil
	end)
end
--[[
basic weapon, mild damage and
accuracy boosts. also decent as
a thrown weapon
--]]
knife = equipment:subclass
	"classname=knife,sprite=68,name=knife,color=6,equip_slot=weapon,dthrown=4,bonuses=hit_boost:5;dmin_boost:1;dmax_boost:2"

--[[
a strong weapon, but landing hits
becomes more difficult.
not meant as a thrown weapon but
better than throwing apples
--]]
sword = equipment:subclass
	"classname=sword,sprite=69,name=sword,color=6,equip_slot=weapon,dthrown=3,bonuses=hit_boost:-10;dmin_boost:3;dmax_boost:6"

--[[
only slightly better than a torch
as an equipped weapon, but
very effective when thrown.
--]]
	tomahawk = equipment:subclass
	"classname=tomahawk,sprite=73,name=tomahawk,equip_slot=weapon,dthrown=8,bonuses=hit_boost:5;dmin_boost:1;dmax_boost:1"

	plate_armor = equipment:subclass
	"classname=plate_armor,sprite=75,name=plate armor,equip_slot=armor,bonuses=ac:3"
	leather_armor = equipment:subclass
	"classname=leather_armor,sprite=76,name=leather armor,equip_slot=armor,bonuses=ac:1"
	spiked_armor = equipment:subclass
	"classname=spiked_armor,sprite=77,name=spiked armor,equip_slot=armor,bonuses=ac:2;dmin_boost=2"
	warded_armor = equipment:subclass
	"classname=warded_armor,sprite=78,name=warded armor,equip_slot=armor,bonuses=ac:6"

	ring = equipment:subclass
		"classname=ring,sprite=80,name=ring,equip_slot=rings,bonuses=ac:1"

	--[[
------creature class-------------
represents entities that have
health and experience and take
actions on turns

#####  operators: #####
crt+n: crt gains n hp
crt-n: crt loses n hp
--]]
creature = entity:subclass
"classname=creature,sight_rad=4,hp_max=10,exp=2,hitrate=75,min_dmg=0,max_dmg=4,ac=0,dmax_boost=0,dmin_boost=0,hit_boost=0"

copy_all({
	__add=function(self,x)
		self:hp_change(x)
		return self
	end,
	__sub=function(self,x)
		self:hp_change(-x)
		return self
	end
},creature.metatable)

function creature:init(params)
	entity.init(self,params)
	self.hp,self.turn,self.items,self.equipped=
	self.hp_max,turn,{},{}
	if(self.item_table) self:item_gen()
end

--generate starting items
function creature:item_gen()
	prob_tbl(self.item_table,
	function(class)
		local itm = class(self)
		if(equipment<itm)itm:equip(self)
	end)
end

--[[
each turn, creatures will either:
1.seek out and attack the player
	if within range
2.attempt to return to a guard
	position, if they have one
3.wander around randomly
--]]
function creature:take_turn()
	if not self.sleeping and self.pos then
		local c_p,you_p,guard_pos = self.pos,
		you.pos,self.guard_pos
		if screen>c_p and
		not gameover and
		(self:can_see(you_p) or
		c_p:dist(you_p)<4) then
			local valid_path
			local path=self.path
			for i=1,path and #path or 0 do
				if path:get(i):dist(you_p)
				<=c_p:dist(you_p) then
					valid_path=true
				end
			end
			if(not valid_path)self.path=pathfind(c_p,you_p)
		elseif guard_pos and c_p!=guard_pos then
			self.path=pathfind(c_p,guard_pos)
		end
		local d
		if(not(self.path or guard_pos))d=rndint(3,0)
		self:move(d)
	end
end
--[[
creatures will attack eachother if
they're in the way, but they won't
hurt their own kind
--]]
function creature:would_attack(c2)
	return not(self:class()<c2)
end

--take an item from the level map
function creature:take(itm)
	for i in all(self.items) do
		if(i.name == itm.name) then
			remove_entity(itm)
			i:change_qty(itm.qty)
			return
		end
	end
	if #self.items ==7 then
		if(self==you)msg"you can't carry any more."
	else
		remove_entity(itm)
		itm.pos,itm.holder=nil,self
		add(self.items,itm)
	end
end

--[[
drop an item onto the level map
[qty]:number to drop, default is all
[pos]:place where the item enters
		the level. default is at creature
			position
--]]
function creature:drop(itm,qty,pos)
	qty = qty or itm.qty
	pos = pos or self.pos
	itm:change_qty(-qty)
	for e in all(get_entities(pos)) do
		if(e.name == itm.name) e:change_qty(qty) return e
	end
	local dropped = itm.qty > 0
	and itm:class()() or itm
	copy_all(itm,dropped)
	dropped.qty,dropped.pos,dropped.holder
	=qty,-pos,nil
	add_entity(dropped)
	return dropped
end


--[[
creature attempts to follow a path
or move in a direction through the
level.
[d]: optional direction
--]]
function creature:move(d)
	local path = self.path
	if d or path then
 	local dpos = d and
 	point(self.pos):move(d)
 	or -path
 	local dest,crt = get_tile(dpos),
		get_creature(dpos)
		if dest and in_bounds(dpos) and
		not crt and (not dest.solid or
		self.spectral) then
				if(not self.tempsprite and screen>self.pos)self.tempsprite=self.sprite+1
				move_entity(self,dpos)
		else
			if crt and
			self:would_attack(crt) then
				self:attack(crt)
			end
			self.path = nil
		end
		if(dest and dest.on_move)dest:on_move(self)
		if(path and #path==0)self.path=nil
	end
end

--[[
change a creature's hp, removing
it and dropping its items if
hp reaches 0
--]]
function creature:hp_change(n)
	self.hp=min(self.hp_max,self.hp+n)
	if self.hp <= 0 then
		foreach(self.items,function(itm)
			self:drop(itm)
		end)
		foreach_pair(self.equipped,
		function(itm)
			self:drop(itm)
		end)
		name_msg(self," died.")
		remove_entity(self)
	end
end

--[[
	this creature attacks another
	creature (c2)
	[dmg]:replaces the creature's
			usual attack damage
	[hitrate]: replaces the creature's
			usual hitrate
--]]
function creature:attack(c2,dmg,hitrate)
	dmg,hitrate=
	dmg or max(0,rndint(self.max_dmg+self.dmax_boost,self.min_dmg+self.dmin_boost)-c2.ac),
	hitrate or self.hitrate+self.hit_boost
	if(not self.tempsprite and screen>self.pos)self.tempsprite=self.sprite+2
	local battle_msg = function(msg1,msg2)
		name_msg(self,msg1..c2.name..msg2)
	end
	if rndint(100) > hitrate then
		battle_msg(" missed ","!")
	else
		if dmg == 0 then
			 battle_msg(" barely hits ",".")
				return
		else
			battle_msg(" hit "," for "..dmg.." damage.")
			if dmg >= c2.hp then
				if(self==you)kills+=1
				self.exp+=c2.exp
			end
		end
		c2 -= dmg
	end
end


--weakest enemy class, usually not much of a threat
rat = creature:subclass
"classname=rat,name=rat,sprite=144,hp_max=5,sight_rad=6,item_table=meat:900;knife:10"

--slightly stronger, usually armed
kobold=rat:subclass
"classname=kobold,name=kobold,sprite=131,hp_max=8,exp=4,min_dmg=1,max_dmg=5,ac=1,item_table=torch:600;knife:400;leather_armor:100"

--vicious but innacurate
mantid=rat:subclass
"classname=mantid,name=mantid,sprite=147,hp_max=12,hitrate=60,min_dmg=4,max_dmg=8,exp=10,item_table=potion:1000;meat:500"

--powerful guards
watcher=mantid:subclass
"classname=watcher,name=watcher,sight_rad=10,sprite=176,hp_max=20,hitrate=95,min_dmg=3,max_dmg=6,ac=3,exp=20,item_table=knife:500;sword:1000;bread:800;potion:400;spiked_armor=200"
function watcher:init(params)
	creature.init(self,params)
	self.guard_pos=-self.pos
end

--player class
player = creature:subclass
"classname=player,name=rogue,color=7,sprite=128,hp_max=10,hitrate=85,min_dmg=1,max_dmg=5,take_turn=always_nil,item_table=bread:1000;apple:800;meat:200;torch:1000;potion:500;scroll:500"

function player:move(d)
	if(redraw>frame and not gameover) creature.move(self,d)
	start_turn()
end

--########-tile classes-########-
tile = object:subclass
	"classname=tile,solid=true,sprite=nil,color=2"
--occasionally switch up tile sprites
function tile:init()
	if(self.alt_sprite and rnd(100)<5) self.sprite=self.alt_sprite
end
--generate tile items
function initial_items()
	foreach_tile(function(p,t)
		prob_tbl(t.item_table,
		function(class)
			class(p)
			return true
		end)
	end)
end
--static tile, placeholder for
--empty spaces
void = tile:subclass"classname=void,sprite=62"
function void:new()
	return self
end

floor = tile:subclass
	"classname=floor,solid=false,sprite=19,alt_sprite=20,color=4"

wall = tile:subclass
	"classname=wall,sprite=16,alt_sprite=17,color=6"

dungeon_floor = floor:subclass
"classname=dungeon_floor,item_table=torch:10;knife:10;potion:15;scroll:15;mushroom:10;bread:20;plate_armor:10;leather_armor:10,spawn_table=rat:100;kobold:200;mantid:20"

dungeon_wall = wall:subclass
	"classname=dungeon_wall"

cave_floor=floor:subclass
	"classname=cave_floor,sprite=3,alt_sprite=4,color=0,item_table=torch:20;apple:10;mushroom:50;potion:10;leather_armor:5,spawn_table=rat:400"

cave_wall=wall:subclass
	"classname=cave_wall,sprite=0,alt_sprite=1,color=1"

temple_floor=floor:subclass
	"classname=temple_floor,sprite=35,alt_sprite=36,color=11,item_table=torch:20;knife:40;tomahawk:20;sword:20;potion:50;scroll:50;ring:10;spiked_armor:10;warded_armor:5,spawn_table=kobold:900;mantid:500"

throne=floor:subclass
	"classname=throne,sprite=34,color=11"

floor_pedestal=floor:subclass
	"classname=floor_pedestal,sprite=18,color=6"

temple_wall=wall:subclass
		"classname=temple_wall,sprite=32,alt_sprite=33,color=12"

door = tile:subclass
	"classname=door,sprite=21,color=9"
function door:on_move()
	if(self.solid)self:use()
end

function door:use()
	local s_change = self.solid and 1 or -1
	self.solid=not self.solid
	self.sprite+=s_change
	self.color+=s_change
end

temple_door = door:subclass
"classname=temple_door,sprite=37"

cave_secret_door = door:subclass
"classname=cave_secret_door,sprite=7"

dungeon_secret_door = door:subclass
"classname=dungeon_secret_door,sprite=23"

temple_secret_door = door:subclass
"classname=temple_secret_door,sprite=39"

up_stair = tile:subclass
	"classname=up_stair,sprite=5,color=13,solid=false"
function up_stair:use()
	msg"you're not going back"
end

stair = tile:subclass
	"classname=stair,sprite=6,color=13,solid=false"
function stair:use()
	if get_tile(you.pos) == self then
		level_init()
		lvl_floor+=1
		num_creatures=0
		foreach_pair(classtable,
		function(cl)
			if rat<cl then
				cl.exp+=flr(cl.exp*.5)
				cl.hp_max+=2
				cl.min_dmg+=1
				cl.max_dmg+=1
				cl.p_swap=lvl_floor
			end
		end)
		build_pos,building=
		point(you.pos),true
		add_entity(you)
		menu_close()
		build_level()
	else
		msg"move closer to descend"
	end
end

--#####- level building -#######
function build_level()
	--load pre-designed level features
	--from memory
	local f_lists=split(	mem_to_str(0x2694,0x4c0),"&")
	local top_percent,range,ftimer=
	100-#f_lists,4,timer()
	ctrl,building,
	build_percent,tiles_placed,
	builder_walls,builder_floors =
	loading_ctrl,str_to_list"true,0,0,cave_wall,cave_floor"
	coroutine(function()
		--### main building loop  ###
		while build_percent < top_percent do
			ftimer()
			local build_dungeon=build_percent>35
			if build_dungeon then
				builder_walls,builder_floors,range=
				dungeon_wall,dungeon_floor,0
			end

			--follow the path to build passages
			if build_path then
				while #build_path > 0 do
					build_pos = -build_path
					local t=get_tile(build_pos)
					if t.solid and not (door<t) then
						if t.doorway and
						next_to(build_pos,floor,false) > 1 then
							set_tile(build_pos,door())
							foreach_entity(function(e)
								remove_entity(e)
							end,rectangle(build_pos))
						else
							set_tile(build_pos,builder_floors())
						end
						tiles_placed += build_walls(build_pos)
					end
				end
				--calculate build progress
				build_percent,build_path =
				min(top_percent,flr(tiles_placed
				/#lvl_area*(110+lvl_floor*10))),nil
			else

				--##### room building  ######
				last_room=rectangle()*
				(build_dungeon and 4 or rndint(4))
				--## dungeon rooms ##
				if build_dungeon then
					local pos = rnd_pos(function(p)
						return rect_empty(last_room+p) and in_bounds(last_room+p)
					end)
					if(not pos) build_percent=top_percent break
					last_room += pos
					for d=1,4 do
						local expanded=rectangle(last_room)
						while(rect_empty(expanded)
						and lvl_area>expanded
						and rnd(10)<8) do
							last_room(expanded)
							expanded:expand(1,d)
						end
					end
					set_rect(last_room,builder_walls)
					tiles_placed += #last_room
					last_room:expand(-1)
					set_rect(last_room,builder_floors)
					last_room:expand(1)
				else
					last_room+=build_pos
				end
				foreach_tile(function(p,t)
					if build_dungeon then
						if(next_to(p,builder_floors)==1 or not in_bounds(p))t.fixed=true
						if(dungeon_wall<t) t.doorway=true
						if(not t.bright)torch(p)
					else
						if p:dist(build_pos) <=
						last_room.w/2 then
							set_tile(p,cave_floor())
							tiles_placed+=(1+build_walls(p))
						end
					end
				end,last_room)

				--find a path to the next room
				build_path = build_percent<top_percent
				and pathfind(build_pos,
				build_dungeon and
				(point(rndint(last_room.w-2,1),rndint(last_room.h-2,1))+last_room)
				or rnd_pos(always_true),
				function(p,t,dst)
					if(t.fixed or not in_bounds(p)) return
					if(p:dist(dst) < 4)return 0
					return (t.doorway and 40 or 0) +
					((t and t.solid or door<t)
					and (dungeon_building and
					(5+next_to(p,floor)*2) or
					10-next_to(p,floor) * 2+rnd(4))
					or 0)
				end,
				range)
			end
		end
		--place pre-designed structures
		for i=1,#f_lists do
			--log("attempting to place structure "..i.." of "..#f_lists)
			local f_list,validating=
			str_to_array(f_lists[i]),true
			local attempts,build_count=f_list[1],f_list[2]
			del(f_list,attempts)
			del(f_list,build_count)
			rnd_pos(function(p,t)
				attempts-=1
				--build_percent=(flr(build_percent).."."..(900-attempts))+0
				if(attempts < 1)return true
				ftimer()
				for i=0,3 do
					local class
					for k in all(f_list) do
						validating,class=
						k!=">" and validating,
						#k==0 and k or class
						if #k >1 then
							k=#k==4 and rectangle(unpack(k))
							or point(unpack(k))
							k=(k+p):rotate(p,i)
							if validating then
								if(not in_bounds(k)) break
								if k.w then
								 if(not rect_empty(k,class))break
								elseif not (class<get_tile(k))
									then break
								end
							else
								if tile<class then
									if k.w then
										set_rect(k,class)
									else
										set_tile(k,class())
									end
								end
								if(entity<class) class(k)
							end
						end
					end
					if not validating then
						build_count -=1
						validating=true
						if(build_count<1)return true
					end
				end
			end)
			build_percent+=1
		end
		set_tile(you.pos,up_stair())
		initial_items()
		building,show_map,redraw,build_percent=
		str_to_list"false,false,0,100"
		return
	end)
end

--build walls around floor tiles
function build_walls(p)
	local placed = 0
	foreach_adj(p,
	function(p,t)
		if void<t or
		not in_bounds(p) then
			set_tile(p,builder_walls())
			placed+=1
		end
	end)
	return placed
end


-----------ui functions---------
--[[
cursor for selecting points in
the level map
--]]
function map_cursor_init(action,bounds)
	menu_close_all()
	map_cursor,map_cursor_action,
	map_cursor_bounds,
	ctrl,redraw =
	{
		sprite=28,
		pos=-you.pos,
		draw=entity.draw
	},
	action,
	bounds or screen,
	selection_ctrl,frame
end

function map_cursor_remove()
	ctrl,map_cursor,redraw =
	default_ctrl,nil,frame
end

--[[
 draws a rectangular border
 region around rectangle r
--]]
function draw_border(r)
	if(is_string(r))r= rectangle(r)
	rectfill(argsort(4,r:xy1xy2()))
	rectfill(argsort(2,(-r):expand(-1):xy1xy2()))
end

--#####  game messages  #######--
msg = queue()
function name_msg(e,post,pre)
	if visible(e) and (pre or post) then
		pre,post=pre or "",post or ""
		msg(pre..e.name..post)
	end
end

function msg_update()
	msg.last,msg.curr=
	msg.curr or msg.last,(#msg>0) and -msg
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
	--[[
	if self.turn_modded!=turn and
	self.update then
		self:update()
		self.turn_modded=turn
	end
	--]]
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

main_menu=menu()
function main_menu:update()
	while self:get(#self).turn do
		self:pop()
	end
	foreach_adj(you.pos,function(p,t)
		foreach(get_entities(p),
		function(e)
			if item<e then
				self:add("take "..e.name..
					(e.qty>1 and "("..e.qty..")" or ""),
					function()
						you:take(e)
						self:update()
					end,turn)
			end
		end)
	end,false,true)
	if(self.index>#self)self.index=#self
end

main_menu:add("inventory",
function() inventory:open() end)

main_menu:add("equipment",
function() equip_menu:open() end)

main_menu:add("knowledge",
function() stats:open() end)

main_menu:add("use",
function()
	menu_close_all()
	map_cursor_init(function(p)
		if(use(get_tile(p),you)) return
		for e in all(get_entities(p)) do
			if(use(e,you)) return
		end
		msg"you can't use that."
	end,
	rectangle(you.pos):expand())
end)
--[[
main_menu:add("god mode",
function()
	copy_all("can_see=always_true,spectral=true,sight_rad=999,hp_max=999,hitrate=100,min_dmg=999,max_dmg=2222",you)
	reveal_all=true
	turn_routine(turn,-1,function()
		you.hp=999
	end)
end)
--]]

inventory=menu()
function inventory:update()
	self.index = 1
	self:clear()
	foreach(you.items,
	function(itm)
		self:add("",function()
			local itm_menu,itm_name,commit=
			menu(),
			itm.name,
			function()
				menu_close_all()
				start_turn()
			end
			itm_menu.pos=rectangle"20,60,1,1"
			if itm.use then
				itm_menu:add("use "..itm_name,
				function()
					use(itm,you)
					commit()
				end)
			end
			if equipment<itm then
				itm_menu:add("equip "..itm_name,
				function()
					itm:equip(you)
					commit()
				end)
			end
			itm_menu:add("drop "..itm_name,
			function()
				you:drop(itm,1)
				commit()
			end)
			itm_menu:add("throw "..itm_name,
			function()
				menu_close_all()
				map_cursor_init(function(p)
					launch(itm,point(you.pos),p,
					function(dst)
						you:drop(itm,1,dst)
						local crt =get_creature(dst)
						if(crt) you:attack(crt,itm.dthrown or 1)
						if(itm.on_throw)itm:on_throw(dst)
						start_turn()
					end)
					redraw=frame
				end,screen)
			end)
			itm_menu:open()
		end)
	end)
end

function inventory:draw()
	draw_border"56,20,19,88"
	for i=1,min(#you.items,7) do
		local y1,itm =11+i*12,you.items[i]
		itm:draw(point(60,y1))
		if(i == self.index)spr(28,60,y1)
		print(itm.qty,69,y1+6,10)
	end
end

equip_menu=menu()
function equip_menu:update()
	self.index = 1
	self:clear()
	foreach(equip_types,
	function(equip_slot)
		local itm = you.equipped[equip_slot]
		self{
			op=itm and function()
				local itm_menu=menu()
				itm_menu.pos=rectangle"20,60,1,1"
				itm_menu{
					name="remove "..itm.name,
					op=function()
						itm:remove()
						self:update()
						menu_close()
					end
				}
				itm_menu:open()
			end or always_nil
		}
	end)
end

stats=menu()
function stats:update()
	self:clear()
	foreach(
	{
		"armor class:"..you.ac,
		"damage:"..(you.min_dmg+you.dmin_boost).."-"..(you.max_dmg+you.dmax_boost),
		"hit rate:"..(you.hitrate+you.hit_boost),
		"creatures killed:"..kills,
		"most exp:"..high_scores[1],
		"most kills:"..high_scores[2],
		"deepest floor:"..high_scores[3]
	},
	function(txt)
		self:add(txt,always_nil)
	end)
end


function equip_menu:draw()
	sspr(str_to_list"96,96,12,30,56,20")
	spr(28,58,13+9*self.index)
	local i=0
	foreach(equip_types,function(eqp)
		local itm=you.equipped[eqp]
		if itm then
			itm:draw(point(58,22+i))
		end
		i+=9
	end)
end

--####### main controls #######--
function default_ctrl()
	for i=0,3 do
		if(button(i)) you:move(i)
	end
	if(button"4") main_menu:open()
	if(button"5") show_map,redraw=not show_map,frame
end

function selection_ctrl()
	for i=0,3 do
		if button(i) then
			local pos =
			(-map_cursor.pos):move(i)
			if map_cursor_bounds>pos and
			in_bounds(pos) then
				map_cursor.pos(pos)
				redraw=frame
			end
		end
	end
	if button"4" then
		map_cursor_action(map_cursor.pos)
		map_cursor_remove()
	end
	if(button"5") msg"cancelled." map_cursor_remove()
end

--alternate controls that
--activate when a menu is active
function menu_ctrl()
		--left:close menu
	if(button"0")menu_close() return
	--up:change selection
	if(button"2") then
		active_menu.index -= 1
		if(active_menu.index==0)active_menu.index=#active_menu
	end
	--down:change selection
	if(button"3") active_menu.index %= #active_menu active_menu.index += 1
	--0,right:select menu item
	if button"4" or button"1" then
		if(active_menu.index<=#active_menu) active_menu:get(active_menu.index):op() redraw=frame
	end
	--x:close all menus
	if(button"5")menu_close_all()
end

function no_ctrl()
	if(button"5") show_map,redraw=not show_map,frame
	start_turn()
	msg_update()
end

function loading_ctrl()
	if(building or title and btnp() == 0) return
	title=false
	ctrl=default_ctrl
end

--keep the draw area centered
--around the player
function set_screen()
	screen-=screen+point(8,8)-you.pos
end

--##### main game loop ########--
function _init()
	cartdata"phantasos"
	level_init()
	update_routines,turn_routines,
	draw_routines,screen,ctrl,build_pos,
	redraw,show_map,frame,turn,
	num_creatures,max_creatures,
	lvl_floor,building,title,
	kills,high_scores,equip_types
	= queue(),queue(),queue(),
	rectangle()*16,loading_ctrl,
	rnd_pos(always_true),
	str_to_list"true,0,0,0,0,7,1,true,true,0,0;0;0,weapon;armor;rings"
	log("equip types:")
	log(equip_types[1])
	log(equip_types[2])
	log(equip_types[3])
	function point_mapping(str)
		local hex_tbl,pt_tbl,mapped,offset=
		split(str,","),{},{},point(8,8)
		for i=1, #hex_tbl do
			foreach(split("x=1,y=1 x=-1,y=1 x=1,y=-1 x=-1,y=-1"," "),
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
	you,draw_tbl,los_tbl =
	player(build_pos),
	point_mapping(mem_to_str(0x2000,0x2ca)),{}
	set_screen()
	local los_array= point_mapping(mem_to_str(0x22ca,0x3ca))
	foreach(los_array,
	function(los_pt)
		local mapped = {}
		for i=2,#los_pt do
			add(mapped,los_pt[i])
		end
		los_tbl[#los_pt[1]]=mapped
	end)
	build_level()
	msg"travel deeper, rogue."
end

function _update()
	if(b_pending==0)b_pending = btnp()
	if(run_coroutines(update_routines)) return
	if b_pending!=0 and not turn_running then
		if not title and #msg>0 then
			msg_update()
		else 
			if(msg.curr)msg_update()
			ctrl() 
		end
		b_pending=0
	elseif turn_running then
		if foreach_entity(function(e)
			if e.turn == turn and e.take_turn then
				e:take_turn()
				e.turn +=1
				--return true
			end
		end) then return true end
	--when all entities are done:
		run_coroutines(turn_routines,true)
		turn+=1
		if you.hp <=0 and not gameover then
			gameover,reveal_all,ctrl=
			true,true,no_ctrl
		end
		redraw,turn_running =
		frame,false
		local exp=you.exp
		you.hp_max,you.max_dmg,you.hitrate=
		10+flr(exp/10),
		player.max_dmg+flr(exp/10),
		80+exp/10
		local score={exp,kills,lvl_floor}
		for i=1,3 do
			high_scores[i]=max(score[i],dget(i))
			dset(i,high_scores[i])
		end
	end
end

function _draw()
	frame+=1
	frame%=1000
	--### draw loading screen #######
	if title or	building then
		sspr(32*(flr((frame%18)/6)),str_to_list"96,32,32,0,0,128,128")
		if(title) sspr(str_to_list"64,64,64,16,14,0,100,25")
		local txt = "press any key to start"
		if(build_percent < 100) txt="descending:"..build_percent.."%"
		local x1 = 66-#txt*2
		draw_border(rectangle(x1,118,#txt*4,128))
		print(txt,x1+1,121,10)
		return
	end
	if redraw<frame then
		--######## draw level ##########
		redraw=2000
		cls()
		set_screen()
		local keypt
		function draw(s)
				spr(s,(keypt*8):get_xy())
		end
		local hidden={}
		for i=1,#draw_tbl do
			if you.hallucinating then
				pal(rndint(16,0),rndint(16,0))
			end
			local pt_tbl=draw_tbl[i]
			keypt = pt_tbl[1]
			local abs_pos = keypt+screen
			local t,visible,key =
			get_tile(abs_pos) or void,
			reveal_all,#keypt
			draw(62)
			if not (hidden[key]
			or t < void
			or (you.pos:dist(abs_pos)
			> you.sight_rad and not t.bright)
			or you.can_see == always_nil) then
				t.seen,visible=true,true
			end
			if t.solid or hidden[key] then
				for k=2,#pt_tbl do
					hidden[#pt_tbl[k]] = true
				end
			end
			if t.seen or reveal_all then
				draw(t.sprite)
				if not visible then
					pal(1,0)
					draw(61)
					pal()
				else
					foreach_entity(function(e)
						e:draw()
					end,rectangle(abs_pos))
				end
			end
		end
		if(map_cursor)map_cursor:draw()

		--###### draw status bar ######
		draw_border"8,116,110,10"
		print("hp:"..you.hp.."/"
		..you.hp_max.." exp:"..you.exp
		.." floor "..lvl_floor,str_to_list"15,119,10")

		--#### draw minimap window ######
		if show_map then
			draw_border"32,28,69,69"
			foreach_tile(function(p,t)
				if t.seen or reveal_all then
					local c=t.color
					--if(pathtrace and pathtrace[#p])c=pathtrace[#p]
					if visible(p) then
						foreach_entity(function(e)
							c=e.color
						end,rectangle(p))
					end
					local x,y = ((p*2)+point(38,34)):get_xy()
					rectfill(x,y,x+2,y+2,c)
				end
			end)
		end
	end
	if(run_coroutines(draw_routines,true))redraw=frame

	--###### draw messages #########
	draw_border"2,2,124,14"
	if(not msg.curr	and #msg > 0)msg_update()
	local last,curr = msg.last or "",msg.curr or ""
	print(last,64-2*#last,4,9)
	if(#msg>0)spr(str_to_list"31,120,10")
	print(curr,64-2*#curr,10,10)

	--######## draw menus ##########
	foreach(open_menus.values,
	function(m)m:draw()end)
	if(active_menu)active_menu:draw()
	--print memory use for debug
	--rectfill(str_to_list"0,121,40,138,1")
	--print(stat(0)..":"..frame,str_to_list"1,122,8")
end

__gfx__
12022201120220311202220155555555555255550000000000000000120222010122210028800288000000000000000000000000000000000000000000000000
212002201b1020312120022052225555555223350222200005555550212000201200021028000028000000000000000000000000000000000000000000000000
202110202b1030312021102022552252222232352661120006666640202110201200021000000000000000000000000000000000000000000000000000000000
22021020230230212202102055222222522522252555120005555220220210202000002000000000000000000000000000000000000000000000000000000000
02021021230b30210202102155522225232223222666620006664240020210212000002000000000000000000000000000000000000000000000000000000000
02021021102b10210202102122555222233225332555550005522440020210212000002000000000000000000000000000000000000000000000000000000000
12021210022b02111202121052222555223335532666666002424220120210202000002028000028000000000000000000000000000000000000000000000000
12022210022220111202221055555555222255225555555500000000120210201000001028800288000000000000000000000000000000000000000000000000
1501150115011501555555551111111111111111150115011501150115111001156115610000000000000000000000009aa009aa9aaaa0009a9a00000009a000
6566656665666566544444451dd1555115551dd16aaa99966aaa999665666066657665760000000000000000000000009a00009a9a09a0009a9a000000009a00
5011501150000001576666451dd1555115551dd11a2211911a2000915111011111000061000000000000000000000000000000009a09a00009a000009aaaaaa0
56665666560bb7065766664511111551155111116a4214966a2000965666066666000076000000000000000000000000000000009a09a0009a9a000000009a00
150115011503bb015766664511551111111155111a4214911a2000911511101110000006000000000000000000000000000000009aaaa0009a9a00000009a000
6566656665000006577666451d551dd11dd155d16a2211966a200096656660666000000700000000000000000000000000000000000000000000000000000000
5011501150115011577777451dd11dd11dd11dd11a4214911a40009151115011100000060000000000000000000000009a00009a000000000000000000000000
56665666566656665555555511111111111111116a2211966a40009656665066600000070000000000000000000000009aa009aa000000000000000000000000
aaaaaaaaaaaaaaaa11aaaa111111111112211221a229a229a229a229aaaaaaaaaaaaaaaa00000000444444440000000000000000000000000000000000000000
9aa29aa29aa1caa2181444811a2222a12a1221a2aa9a1a9aaa9a0a9a9aa14aa29aa004aa0000000048c080340000000000000000000000000000000000000000
29a29a229a1ccca2ca1144ac121dd12121d11d12a9a919a9a9a000a929a14a2229a004a20000000048c289340000000000000000000000000000000000000000
29a29a229aa1caa2c991199c12dccd21121cc121a9a919a9a9a000a929a14a2229a004a200000000444444440000000000000000000000000000000000000000
29a29a2229a29a22c984489c12dccd21121cc121a9a919a9a9a000a929a14a2229a004a2000000004389c8340000000000000000000000000000000000000000
29a29a2229a29a22c844448c121dd12121d11d12a9a919a9a9a000a929a14a2229a004a200000000444444440000000000000000000000000000000000000000
9aa29aa29aa29aa2199119911a2222a12a1221a2a9a919a9a9a000a99aa14aa29aa004aa0000000049c389340000000000000000000000000000000000000000
aaaaaaaaaaaaaaaa11cccc111111111112211221aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00000000444444440000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0c000101111011000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc0110000110000100044000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c000cccc0000011110000000001046600000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc000c0000c0c100011110010000045550000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc00c00cc000111001110000000046666000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000ccc00cc0011110001000000045555500
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00c00001110110000010046666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc00110111010000000045555555
0000070000000000000000000000000000000a00000007770000000000000000000000000000000000aa90000000000000000000000000000000000000000000
00007a80000990000fffff00000490000000a9000000776000008870000040000000000000094990009990000000000000000000000000000000000000000000
0000aa80000770000ffcff0000c4c9000000a9000007760008888e7000884b000099790000004690000a900007600760044004400700007003b00cb000000000
00002800000770000fcfff00044ccc900000a9000277600088788e700288ee0004474970000040900aaa9000076dd760024224800dd55dd0033cc3b000000000
00002400007cc7000fcccf000444c990000088000226000087878e7002888e0004f447900000400000a990000076660000448400007d7d0000c33c0000000000
0000240007c7cc700fffff700009f00000000800224400008878e700022888000444f440000040000aaaa900007666000044840000d7d700003cc30000000000
00002200077cc7700ffffff000009f0000000000440000000eeee7000022200000444400000000000a99990000766600000880000d0d707000c33c0000000000
00000000007777000000000000000000000000000400000007777000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a8aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00666600000666600777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00622600000622600662200109900990099099009944900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d22d00000622d00dd220170944449009944400947490000000000000000000000aaaa000aa9000000000000000000000a90000000000000000000000000000
00757500000757500055517600744700000974000099d9900000000000000000000a90aa900a9000000000000000000000a90000000000000000000000000000
075757d00075757d05576760009999000099990000cdd9000000000000000000000a900aa90a9000000000000000000000a90000000000000000000000000000
075576d00075576d057576000ccddcc00cccdd000ccddc000000000000000000000a9000a90a9000000000000000000000a90000000000000000000000000000
0575ddd000575ddd055776000cddddc0ccccddd00cdddc000000000000000000000a900aa90a90aa0000aaa000aaa900aaaaa90aaa00000aaa0000aa0000aaa0
055776600555776677766600ccddddcccccdddd0ccddddc00000000000000000000a90aa900aaaaa000aa0a900aaaa9000a900aa0a9000a00a900a9aa000a0a9
ef0414000e044000ef0044700008b80000008b000bb000bb0000000000000000000aaaa0000a900a90a900a900a90aa900a90a900a9000aa0000a900a90aa000
0e0c4c000f004c40f04c4700000bbb0000003b000b00000b0000000000000000000a9000000a900a90a900a900a900a900a90a900a90000aa900a900a900aa90
f0044400e002444ee0024470000cbc3b000030000b08380b0000000000000000000a9000000a900a90a900a900a900a900a90a900a900a000a90a900a9a000a9
e002e200f2244220f22442207cccc33b66c0c3b00b3c3c3b0000000000000000000a9000000a900a000aa0a900a900a900a900aa0a9000a00a90aa9aa90a00a9
f0222220224444002244422273cc330b6ccc30b00b0ccc0b0000000000000000000aaa00000aa00a9000aa0aa0aa00aa00a9900aa0aaa0aaa9000aaa900aaa90
e024242024444240244440000733300b0cc330b0006ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff24442024024240244444000555b0b0b555b0000b5c5c0000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
053335000533330005333500111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
033333000533330005333300111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
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
060606070706040606080606060606060707070306070707072406060807240a030809090609050303240d06060606060b060c0524020f0809060606060505040d030e240e0f0809092404070707070306000203070c0707070707070c030707030707050809080a06070108070803080507060504010102060e0d080608050c
0408030902090109240903080708060905090424080c0809080a080b2404000807070607050604060305020501240a060907240e00080709060a050b040b030c020d012404020807070606050604050324050707080607240c0d0809090a0a0b0b0c240a000807080609050904090309020a0124080d0809080a080b080c240f
__map__
0808260707060626060603030404050526070801030304040502060306040605060307040705070607050806080309040905090609000c010c020c030c040c050c000d010d020d030d040d000e010e020e030e000f010f020f00100110001126050503030404260404030326030301010202260807070009000c000d000e000f
00100011000601070109010c010d010e010f0110010702080209020c020d020e020f020703080309030c030d030e030704080409040c040d04080509050c0507060806090626020201012608060c000c01090307040904080526060803070407050803090409000c010c26050801070207030804080009010902092607060500
0501050206020603060406050705260607020502060306040605060507260101000026060503000402050305042608050900090107020902080308042605060102020303040305040526040800070308000926070506000601060307030604070426040500020103020303042605040200030103020403260308010802082602
0801082605070106020603060406030704072607040602060307032603040102020326080407000900080326040302010302260604050104020502050326010800082606030502060226040601050205030526080308010802260703060107022603050003010402042603020201260008260407010602060306020703072608
0208012605020400040126020301022607020600070126010200012602040103260103000226050303000401040226000126070107002604010300260002260602050106012603060205020626040203012602010100260307010601070207260300260301020026080108002602060105010626060105000600260700260501
0400260200260105000426020500040104260400260500260106000500062601002600042602070006010726080026010700072600052606002600072600062601040003260003260000060707082608072608050807080626010307080607050604050305020426050408070706060526000607080608050704070307020701
0626010607080608050704070307020626050208070706070506040603260300080707060605060405030502040126040707080608050726080408070806080526000707080608050804080307020701072603020807070606050504040326030507080607050604062607030807080607050704260306070806070507040726
0605080707062607050807070626020108070706060505040403030226000207080607050604050305020401032600040708060705070406030602050105260800080708060805080408030802080126050807080608260003070806070506040603050205010426020207070606050504040303260304070806070506040526
0700080708060805080407030702070126060408070706070526000507080607050704070306020601062608060807260101070706060505040403030202260701080708060805070407030702260400080707060705060406030502050126040208070706060506040503260507070806072605050707060626050008070706
0705070406030602060126020607080607050704070306260506070806072604060708060705072601020708060705060405030402032602080708060805080408030826080208070806080508040803260501080707060705060406030602260308070806080508040826060607072601070708060805080407030702072602
0307080607050604050304260301080707060605050405030402260704080708060705260808260100080707060605050404030302020126060807082602050708060705070406030626060308070706070507042603030707060605050404260404070706060505260702080708060805070407032600080708060805080408
0308020801082606020807070607050704060326070726020707080608050804070307260600080708060705070407030702060126010507080607050704060306020626060108070806070507040703060226000107080607050604050304020301022608010807080608050804080308022601080708060805080408030802
0826040108070706070506040503050226020407080607050604060305260503080707060605060426070826080308070806080508042607060807260403080707060605050426040807080608050826010407080607050704060305020526040507080607050626020008070706060505040503040203012603070708060805
070407260000010102020303040405050606070709000026012611171a1a1d260027002631261e1f0c141d260027003b0105002601260e0c21102811171a1a1d26002700270727072631261f10181b171028220c1717260127012701270226012704270127022604270127022701260427052702270126012701270227012601
27052702270126052701270127022605270427012702261f10181b17102811171a1a1d260227032703270126032702270127032611171a1a1d281b100f101e1f0c1726032703261f10181b171028220c171726012701270127022601270427012702260427012702270126042705270227012601270127022701260127052702
270126052701270127022605270427012702261f10181b17102811171a1a1d260327033b01000026042611171a1a1d2600270026002702260f1a1a1d260027012631260f201912101a19281e100e1d101f280f1a1a1d260027013b0100002604260e0c211028220c17172600270126022701260e0c21102811171a1a1d260027
002703270126012700270127032631260e0c2110281e100e1d101f280f1a1a1d26012701261f1a1d0e13260127013b010000260126211a140f260027012708270526220c171726002700270827012631260f201912101a1928220c17172601270027062704260227002703270626002701270827022600270127072703260227
00270427052601270027072703260f1a1a1d26032700270227042602270127042702260f201912101a192811171a1a1d2603270127022702260127022606270126032704261f1a1d0e132602270026052700261d14191226062701261e1f0c1f20102603270426220c1f0e13101d260127023b010000260126220c1717260327
012611171a1a1d2603270026211a140f26002702270727062631261f10181b171028220c171726012702270527062600270327072703261f10181b17102811171a1a1d260227032703270226022706270327012603270127012706261f10181b1710280f1a1a1d2603270226032704270127022611171a1a1d281b100f101e1f
0c172601270426052704261f131d1a191026032704261e1f0c1f2010260127042605270426220c1f0e13101d260327043b020000260126211a140f2600270227052705260e0c211028220c17172600270127052701260e0c21102811171a1a1d26002700270527012631260f201912101a1928220c1717260027012705270626
0e0c211028220c17172600270127052703260e0c21102811171a1a1d260127032703270126012701270127032611171a1a1d281b100f101e1f0c172601270126032701260f1a1a1d2602270427012702260f201912101a192811171a1a1d2601270527032701261e1f0c1f20102601270126032701261f1a180c130c22162603
270526161a0d1a170f260127053b020000260226211a140f2600270227052701260e0c211028220c17172600270127052701260e0c21102811171a1a1d26002700270527012631260e0c211028220c171726002701270527022611171a1a1d281b100f101e1f0c172601270126032701261e1f0c1f201026012701260327013b
01000026022611171a1a1d26002700270327032631261f10181b17102811171a1a1d26002700270327032611171a1a1d281b100f101e1f0c1726002701270327012601270027012703261e1f0c1f2010260127011a192811171a1a1d2601270527032701261e1f0c1f20102601270126032701261f1a180c130c221626032705
26161a0d1a170f260127053b020000260526211a140f2600270227052701260e0c211028220c17172600270127052701260e0c21102811171a1a1d26002700270527012631260e0c211028220c171726002701270527022611171a1a1d281b100f101e1f0c172601270126032701261e1f0c1f201026012701260327013b0100
002601260e0c21102811171a1a1d26002700270727072631261f10181b171028220c171726012701270127022601270427012702260427012702270126042705270227012601270127022701260127052702270126052701270127022605270427012702261f10181b17102811171a1a1d260227032703270126032702270127
032611171a1a1d281b100f101e1f0c1726032703261f10181b171028220c171726012701270127022601270427012702260427012702270126042705270227012601270127022701260127052702270126052701270127022605270427012702261f10181b17102811171a1a1d26032703260327030624060108070806070507
04070306022400010708060705060405030402030102240f0f09090a0a0b0b0c0c0d0d0e0e24080108070806080508040803080224010e07080609050a040b030c020d24060f0809080a070b070c070d060e240108070806080508040803080208240d0c09080a090b0a0c0b240e0909080a080b080c090d09240d0d09090a0a
0b0b0c0c240d0509080a070b060c0624050e0809070a070b060c060d2404010807070607050604050305022402040708060705060406030524020a0708060905090409030a24050308070706060506042407082408030807080608050804240e0a09080a090b090c090d0a240a0e0809090a090b090c0a0d2407060807240403
080707060605050424040807080608050824010407080607050704060305020524030a070806090509040924060a070924080a080924090f0809080a080b090c090d090e240d0609080a070b070c0724030b07080609050a040a2404050708060705062402000807070606050504050304020301240a09090824040e0809070a
060b060c050d240e0409080a070b060c060d05240307070806080507040724070e0809080a080b070c070d24050b0709060a240a05080709060c150a1c1c170a160e341d12160e1b0c150a1c1c170a160e341a1e0e1e0e24150e17101d11340009240a0f0809080a090b090c090d0a0e240a0709082406050807070624070508
070706240907240201080707060605050404030302240d0a09080a090b090c09240002070806070506040503050204010324050a07080609240b0509070a06240004070806070507040603060205010524010b070806090509040a030a020a240b0809080a0824020d07080609050a040b030c240a0809082408000807080608
0508040803080208012405080708060824000307080607050604060305020501042402020707060605050404030324050c0809070a060b240304070806070506040524030e0809070a060b050c040d240e0c09080a090b0a0c0a0d0b24040907080608050924070c0809080a070b240700080708060805080407030702070124
__sfx__
0a02080702060244400a040090220045007040064400544004440030500205001050240600444007050064500502209400084300803008420090200941009010244000c4300803009420090200a4100b0100b022
0a0124010903009420090200a4102401008430080300842008020084100802208010084300803008420080200841024420010400743006430050300403003030020220b000084300903009420090200a4100a010
07070806094300803008420080200941009010090220c440090400a0400b4402441008430080300842008020080220c07008440090500a4500a0600b460240300643007022034400704006040054400444024400
060a050b084200802007410070100702202410070400643005030044200302024470064400805008450070600746007070060220b450094400a05024410010400743006030054200442003020020220207007440
0b02240a040600346024060064400805007450070220c41008430090300a4200b020244600f040094400a0500b4500c4500d0600e0220702008430080300742024040080220c4000843009030094200a0200b410
070806090b040094400a0220f410090400a4300b0300c4200d4200e020244000f430090300a4200b0200c4100d0100e0220e420090400a4300b4300c0300d0302446002040074400605005450040600302202450
040a030b054400405003050244400d040090400a4400b4400c0220f400094300a0300b4200c0200d4100e01024470044400805007450070600646005070050220945008440090502406000040074400644005050
2406080702450010220100008430070300642005020044100301002400244100f040094300a0300b4200c4200d0200e022054400704006440240300e040094300a4300b4300c0300d02204450070400644005050
08240205080220d040090400a0400b0400c040244500944008050090220a4600844009050094500906024470094400805008450080600946009070090220b41008430090300a4200a02024060084400805008450
050404240704006430054300403003030240100943008030084200802009410090220645008440070502403003040074300643005430040220f060090400a4400b4400c0500d4500e45024410034300703006420
0008070808070084400805008450080600846024020044300703006420050220c430090400a0400b430240300c040094300a4300b022070100843008030084200702007410244600744008050084500706007022
070a060b060400504004040030400204001040240300204007430064300543004030030220546008440070500645006060240500a4400902207430244000a43008030084200902009410090100a0220446008440
0507080605060244500e040094400a4400b0500c0500d022004700704006440050500445003060024600107024010074300803008420080200741007022060000843008030074200702007410070100640024400
050804080742007020064100601006022064000843008030074200702007410060102400001430080300742006020054100401003400020220f470094400a0500b4500c0600d4600e07024040010400704006040
0a080b08030400202201070070400644005050044500306002460240300f040090400a4300b4300c4300d0300e02201040070400604005040040400304002040244600c44008050094500a0600b0220e44009040
060305240c4400d440244600d440090500a4500b0600c0220d420090400a4300b0300c030244200e040094300a4300b0300c0300d022044000843007030074200602005410050102401004430080300742006020
07060807020500704006440054400444003050244200304007430060300503004022070402404003040070400604005040040220e050090400a4400b4400c4400d050240500e040094400a4400b4400c0500d022
0b090c092402003040074300603005420040220404007040060400504024400044300803007420070200641005010050220305007040064400544004440240300a430090220805008440244400f040090400a040
0b060c050d4400e0220d030090400a4300b4300c430244100b43008030094200a0200a022044200704006430050302401000040074300603005420044200302002410010220a44009040240200e040094300a030
160e1b0c0d0220e020090400a4300b0300c0300d420244100743008030084200702007022070700844008050084500706007460244200b430090300a0220a42008430090300c4210a0611c4310a0310e0231d011
07000800150501c0611705016070340511e0701e070244210e4311046111023000000240003400030100401004410054100502024050054600007000470004600107001060024600245003060034500402208420
050b040c090000740008400094000701008010090100841008020240500b4500c4500d0600d0600e4600e4600f0700f02207060064600746006070070700647007470240500c4500d4500e0600e4500f0600f022
020803080346002070014702442006000010000240002000034000301003010044100441005020050220b0500c4500d4500d0600e0600e4600f4600f070240600846008070084700802204040004300004001040
070f080f0044024440050500045000060000500145001060010500245002440030500344004050040220b4600c0700c4700d47024060060700447004460050700547005022084500806008460070700807009070
0904090009470244200d0200e4100f0200f02207420040000500006000044000540006400050100601006410074100602007020240200d4100e0100f022044200040000010010100141002410030202442009410
000801080a4000a0100a4100a0200a0000b4000b0100b0000c4000c02204060034600207001470244700f02204450030600146002460000700107000470244200440000010000100141001410020200302203040
0005010502040244100e0100f02207460070700647007470244400405000450004400105001440020500244003050030220f430244300e4300f02203460020700147024010080000840008022054300002001020
090d090e02420000300103002030030300403003430044302446003470010700202207020050000600006400074000601007010064100741024460060700547005070060220b0600c4600d0700d4700e47024060
0a0f240d09470094600a0700a4700a0220d4400e4400f4400f050244100400001400020100302209410090000a000094000a40009010240600e4600f0220d470240100f02209060094600a460090700a07009470
0f24030f0b0700c4700c4700d0220e0300f4200f030244600447002070030220f420244400d4400e4400f0500f0220407003470240400443000040004400004001040020400302207470240300d4200e0300e420
0e0c0f0d2402003400000100141002022044400144002440034400005001050020500305000450240300441000020000200142001020024200242003022010400004024050034500006000450010500245002022
0d0c0e0d240300302000420004200142002030020220403000410000200102002020014200242003420240400c0400d0400e0400f0220d0400e0400f04024450040700047000460010700146002060030220c450
24030a020f4600f07024070024700102204050014500245003450000600106002060004602405004060004600045001060014500206002450030220f03024440024400005000440010220d4200f4100e0200f020
010a24060a0000b4000b0100b0000c0220e4200f020244200e0200f0220a0100b0000a4000b40024040030400004001040020220c4600d0700e470244600a0700a0700b4700b0220344000440014400244000050
000201240e4200f0300f0220e0500f0500f450240400d0400e0400f022074100600007000064000740007010240100e4000f022034200001000410014100102002020244200f0220d0600e4600f0702441002400
0f09240d0b4000c000244100c0100d4000e0000f02200040244700d022044300042000030010300203003030014300243003430244000f022034500106002060004600146000070240500105000450000220e440
070124020e0700f0220c4100f0000e4000d010240400204000040010220e4100f01024420024100002000020010220241000400010102444001440000220f440240200f0220f4002445000022070100600007000
050302000a4000a0000b4000b0220e0200f4102440002000010220b0100c0000d0000c400244400e4400f0220e4500f060240500d0500e4500e4500f022020200001001410244400f0220141000010244700b022
0d000e0003000034000440004010244000b0000c0220f050244700c02200400244300143000022064702402001410000220e0400f04024000020220245000060010600046024030024200042001030010220b410
0824010e0c4000d4000c01024060000220e4600f07024410060000400005400050100501006022040100200003400240100d4000e0000f022010600046024470020220f020244600247000070010220a00024470
240e010f00470240400e0400f0220240001000240100900009400090000a02200460244100700006400060000740007010070220f410240500e0500f4500f022020600146000070240600207000460010220e470
24020500000220b0700c47024410000220340002000240400104000022020300042001420010302403001420000300002207000244700e0220900024420010200002202000244000a0000a0000b0220142000020
07000600030000440004022014600007024020000220500024060014600002200060244500f02208470240000f0220d4000e00024400060000500006022010002407000022014400044024000040220a47024010
080a090b07400070220c47024470000220800024400070000702200440240000502206000240000b02200050240000702200030240000e02201020004102446000022004100c050090400a4400b440240700b440
24080724090600a4600a0220f450090400a4400b4400c0500d0500e0502403007430080220d40008430090300a4200b0200b4100c010244100d430090300a4200b0200c0220e070094400a0500b4500c0600d460
0c0b0d0b0e40008430090300a4200b0200c4100d0102404005040070400602201410070400643005030044200342002020240500404007440064400502205020084300703006420240600f040094400a4400b050
0e0708060e02200030070400604005430044300343002430010302446003440070500645005060040220906008440080500945024060054400805007450060220b4000843009030094200a0200a4100a01024000
080d0824094200a0200b4100b0100c4000d02201030070400604005430044300343002030244700a44008050084500906009460090700a0220501008430070300742006020064102407008440080500845008060
0b09080a0300008430070300642006020054100501004400240000a4300803008420090200941009010094000a0220b02008430090300a420244300a040090220f430090400a0400b0400c4300d4300e43024460
24090824094500a0600a0220e030090400a4300b4300c4300d0302444000040070400604005040044400344002440010220644007040240200f040094300a4300b0300c4200d4200e02204430070400604005430
0709060a0e460090400a4400b0500c4500d060240000c4300803009420090200a4100a0100b4000b0220c450090400a4400b05024040040400704006040050220206007040064400505004050034502406002040
090a0a0b0505004450030220745008440070502407003440080500745006060054600402204050070400644005440244400604007022004300704006040050400404003430024300143024430090220b46008440
0809080a0a060244700544008050074500706006460060700602205470084400705007450060600646006070244300f040090400a0400b4300c4300d4300e0220f010090400a4300b0300c4200d0200e41024470
080608050845008060084600807008022074600844008050074500706024410020400743006030054200402003022090200843008030094202446000040074400605005050044500345002060010220901008430
090d240b09020094102445006440080500702208440240300d040094300a4300b4300c02203420070400643005030040302447000040074400605005450040600346002070010220907008440080500845009060
080b090c0a4400805009022040600744006050054502407007440080500845008060074600702207410084300803007420070202441006430080300742007020070220a060084400905009450244600944008050
24000207090220a47008440080500945009060094600a070240500744008022064200843007030244300504007430060220943024010010400743006030054200402003410020220d050090400a4400b4400c440
0a08240208030074200602005410050100440003022050500704006440244500544007050060220002007040064300543004030030300242001420244000b4300803009420090200a4100a0100a0220b04009040
050504040d43008030094200a0200b4100c0220a04009040240400004007040060400504004040030400204001022050400704006040240000343008030074200602006410050100540004022020100743006030
070b240703410244200c040094300a0300b0220302007040064300503004420244100e040094300a0300b4200c0200d0220e060090400a4400b0500c0500d4502402009430080300842009022070600844008050
0b060c0500040070400604005040044300343002430010220602008430070300742024000054300803007420070200741006010064000602208030084302405003040074400644005440040220d020090400a430
03070224240100f040094300a0300b4200c0200d4100e0220e47008440090500a4500b0600c4600d0702440001430070300642005020044100301002022084500844008050244300104007040060400543004430
060a050b0044007040060400504004040034400244001440244400304007040064400544004022080600844008050084502402000040074300643005030040300342002420010220a03009430240700004007440
080c240f04450030600246001022040100843007030064200602005410244200743008030070220c46008440090500a4500b06024050000400704006440054400444003440020500102208460084400805008450
__music__
00 0e09080a
00 090b0a0c
00 0b0d0c0e
00 0d240c0c
00 09090a0a
00 0b0b240a
00 01080708
00 06090509
00 0409030a
00 02240505
00 07070606
00 24050008
00 07070607
00 05070406
00 03060206
00 0124030c
00 07080609
00 050a040b
00 240e0209
00 070a060b
00 050c040d
00 0324000d
00 07080609
00 050a040a
00 030b020b
00 010c2409
00 05080709
00 06240b02
00 08070906
00 09050a04
00 0a03240f
00 0d09080a
00 090b0a0c
00 0b0d0b0e
00 0c240909
00 240b0709
00 080a0724
00 02060708
00 06070507
00 04070306
00 240b0c08
00 09090a0a
00 0b240506
00 07080607
00 240b0f08
00 09090a09
00 0b0a0c0a
00 0d0a0e24
00 04060708
00 06070507
00 24010207
00 08060705
00 06040503
00 04020324
00 0d0e0809
00 090a0a0b
00 0b0c0c0d
00 24080f08
00 09080a08
00 0b080c08
00 0d080e24
00 01004344
00 41424344
00 41424344

