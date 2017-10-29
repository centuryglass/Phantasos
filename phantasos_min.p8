pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
--phantasos v.0.7
--copyright anthony brown 2017
--[[
this work is licensed under a
creative commons attribution 4.0
international license
https://creativecommons.org/
licenses/by/4.0/

https://github.com/centuryglass/phantasos
has the uncompressed code, if
you're interested.
--]]
function always_true()return true end function always_nil()end kh="0123456789-.abcdefghijklmnopqrstuvwxyz,;_:(){}[]<>/?+=*|!#%&@$^"wi,ni={},{}for i=1,#kh do local c,n=sub(kh,i,i),i-1 wi[n],wi[c]=c,n end function hg(addr,len)local str=""for i=addr,addr+len-1 do str=str..wi[peek(i)]end return str end function vk(str)if lh(str)and#str>0 and#str<6 then for i=1,#str do local ff=wi[sub(str,i,i)]
if(not ff or ff>11)return
end return true end end function ub(str)if sub(str,1,1)=="{"and sub(str,#str)=="}"then return lb(sub(str,2,#str-1))end 
if(vk(str))str+=0
if(str=="false")return false
if(str=="nil")return
return(str=="true")and true or(str=="{}")and{}or ni[str]or di[str]or str end function lb(str,tab)
if(not lh(str))return str
local i,ng,tab,val=0,"",tab or{},"null"local key,c while#str>0 do c,str=sub(str,1,1),sub(str,2)if c==","then 
if(#ng>0)val=ng
elseif c=="="then key,ng=ub(ng),""elseif c=="{"then local wd=1 for i=1,#str do local c2=sub(str,i,i)
wd+=(c2=="{"and 1 or c2=="}"and-1 or 0)
if wd==0 then val,str=c..sub(str,1,i),sub(str,i+1)break end end else ng=ng..c end 
if(#str==0 and#ng>0 and val=="null")val=ng
if val!="null"then val=ub(val)if key then tab[key]=val else add(tab,val)end key,val,ng=nil,"null",""end end if tab.addr then return lb(hg(ag(tab.addr),ag(tab.len)))end return tab end function ag(sb)return("0x"..sb)+0 end function jh(str)local dd,of,fe,ug={},{},point"x=8,y=8",lb"{1,1},{-1,1},{1,-1},{-1,-1}"str=lb(str)foreach(str,function(jk)foreach(ug,function(ek)local xi,sb={},""..jk 
if(#sb%2==1)sb="0"..sb
function jc()local num=ag(sub(sb,1,1))sb=sub(sb,2)return num end while#sb>1 do local pt=(point(jc(),jc())-fe)*point(fk(ek))+fe if pt.x<16 and pt.y<16 then add(xi,pt)elseif#xi==0 then return end end local key=#xi[1]if not of[key]then add(dd,xi)of[key]=true end end)end)return dd end function ue(fn)local nh=cocreate(fn)xb(nh)coresume(nh)end function mk(co,dh)local n=#co for i=1,n do local nh=-co if costatus(nh)=="suspended"then coresume(nh)co(nh)
if(not dh)return true
end end 
if(dh and#co>0)return true
end function lh(lk)return type(lk)=="string"end function gj(lk)return type(lk)=="table"end function fk(t,index)t,index=lb(t),lb(index)or 1 local key=index if gj(index)then key=index[1]
if(#index==0)return
del(index,key)else 
index+=1
if(key>#t)return
end return t[key],fk(t,index)end function ld(jf,fn)for k,v in pairs(jf)do 
if(fn(v,k))return true
end end function foreach(jf,fn)for i in all(jf)do 
if(fn(i))return true
end end function zd(cg,a,b,c,d,e,f)assert(not f)local arr={a,b,c,d,e}if gj(cg)then foreach(cg,function(v)add(arr,v)end)else add(arr,cg)end return fk(arr)end function round(val)return flr(val)+(val%1>0.5 and 1 or 0)end function zf(mg,ih)ih,mg=ih or{},lh(mg)and lb(mg)or mg if mg then ld(mg,function(v,k)ih[k]=v end)end return ih end function oh(t,v)return ld(t,function(val)
if(val==v)return true
end)end function ob(mi,kd)kd=kd or 1 return mi<=kd and kd or kd+flr(rnd(1+mi-kd))end function wk(e)e=e.pos or e return tb>e and you:can_see(e)end function ck(p)return(p-tb)*8 end function hf(jf,fn)
if(not jf)return true
return jf and ld(jf,function(v,k)if rnd(1000)<v+qd*k.flr_mult then 
if(fn(k))return true
end end)end function we(n1,n2)return(n1+n2)%1000 end function ch(n1,n2)
if(abs(n1-n2)>500)return n2<n1
return n1<n2 end function wf(n1,n2)return n1==n2 or ch(n1,n2)end function ki(f)
if(nd)return
f=f or zg gf=gf and(ch(gf,f)and f or gf)or f end di={always_true=always_true,always_nil=always_nil,od=function(fg,t)
if(t==-3)lf(fg," is fading back.")
if t==0 and fb(fg.pos).solid then lf(fg," is stuck in a wall!")
fg-=999
end end,ud=function(fg,t)
fg-=1
end,ye=function(fg,t)if fg==you then rd=t==0 and uf or cc end end}wg=lb"addr=2c86,len=1a1"function sh()
if(pk)return
if you.yf then if you.t2 then you.t2=false else you.t2=true return end end pk=true if jj<lg then p=yj(function(p,t)return t.spawn_table and not(tb>p)and not yd(p)end)if p then hf(fb(p).spawn_table,function(class)class(p)return true end)end end vg(function(e)if e.take_turn and wf(e.turn,turn)then ld(wg,function(hi,u)local nk,fn=e[u],hi.fn if nk then if nk>0 then lf(e,hi.s)
nk*=-1
end 
if(fn)fn(e,nk)
lf(e,hi.t)e[u]=nk<0 and nk+1 
if(nk==0)lf(e,hi.e)
end end)
if(not e.sleep)e:take_turn()
e.turn=we(turn,1)end end)end function use(itm,c)if itm.use then local fx=itm.use_sfx 
if(c==you)msg(itm.use_msg)ze()
if(fx and wk(c))sfx(fx)
itm:use(c)if itm.qty then itm:bk(-1)end sh()return true end end jd={}jd.class={jd}function jd:bj(ie)local xf={}setmetatable(xf,self.xj)xf:ri(ie)return xf end function jd:gh(ie)local gh={}gh.fc={__index=self,__call=function(af,ie)return gh:bj(ie)end,__lt=function(af,x)return gj(x)and x.tc and oh(x.tc,af)end}setmetatable(gh,gh.fc)gh.xj=zf(self.xj)gh.xj.__index,gh.tc=gh,zf(self.tc)add(gh.tc,gh)zf(ie,gh)ni[gh.classname]=gh return gh end function jd:class()return self.tc[#self.tc]end function jd:ri(ie)zf(ie,self)end timer=jd:gh"classname=timer"timer.xj.__call=function(self)if time()-self.start>.03 then yield()self.start=time()end end function timer:ri()self.start=time()end queue=jd:gh"classname=queue,length=0"zf({__unm=function(self)return self:sg()end,__call=function(self,n)self:ee(n)return self end,__len=function(self)return self.length end},queue.xj)function queue:ri()self.values={}end function queue:ee(v)
if(v)self.length+=1 self.values[#self]=v
end function queue:get(i)
if(i<=#self)return self.values[i]
end function queue:sg()local ig=self:get(1)if ig then for i=2,#self do self.values[i-1],self.values[i]=self:get(i),nil end 
self.length-=1
return ig end end function queue:gg()zf("values={},length=0",self)end stack=queue:gh"classname=stack"function stack:sg()local qk=self:get(#self)if qk then self.values[#self]=nil 
self.length-=1
return qk end end p_queue=queue:gh"classname=p_queue"p_queue.xj.__call=function(self,v,p)self:ee(v,p)end function p_queue:ee(lk,p)local he={value=lk,xc=p}
self.length+=1
for i=1,#self do local mf=self:get(i)if not mf or he.xc<mf.xc then he,self.values[i]=mf,he end end end function p_queue:sg()local ig=queue.sg(self)return ig and ig.value end rnd_queue=queue:gh"classname=rnd_queue"function rnd_queue:sg()
if(#self<1)return
val=self:get(ob(#self))del(self.values,val)
self.length-=1
return val end point=jd:gh"classname=point,x=0,y=0"point.fc.__call=function(self,x,y)return point:bj()(x,y)end zf({__call=function(self,x,y)if lh(x)then lb(x,self)elseif point<x then self(x:xd())else self.x,self.y=round(x),round(y)end return self end,__add=function(mc,gk)return point(mc.x+gk.x,mc.y+gk.y)end,__sub=function(mc,gk)return point(mc.x-gk.x,mc.y-gk.y)end,__mul=function(pt,n)local x,y=n,n 
if(point<n)x,y=n:xd()
return point(pt.x*x,pt.y*y)end,__div=function(pt,n)return pt*(1/n)end,__unm=function(pt)return point(pt)end,__eq=function(mc,gk)return mc.x==gk.x and mc.y==gk.y end,__len=function(pt)return pt:kg()end,__lt=function(pt,r)return rectangle(pt)<r end},point.xj)function point:move(d,n)n=n or 1 local ax=d<2 and"x"or"y"
if(d%2==0)n*=-1
self[ax]+=n
return self end function point:ic(p2)local ay,ax=(p2-self):xd()ay,ax=abs(ay),abs(ax)return max(ay,ax)+min(ay,ax)/2 end function point:vb(cb,oe)
if(oe==0)return-self
cb,oe=cb or point"x=0,y=0",oe or 1 local hb=self-cb hb(-hb.y,hb.x)
hb+=cb
return hb:vb(cb,oe-1)end function point:xd()return self.x,self.y end function point:kg()return"x="..self.x..",".."y="..self.y end rectangle=point:gh("classname=rectangle")rectangle.fc.__call=function(self,x,y,w,h)return self:bj()(x,y,w,h)end zf({__call=function(self,a,b,c,d)
if(not a)return self"0,0,1,1"
if(lh(a))return self(fk(a))
if rectangle<a then zf(a,self)elseif point<a then local w,h=1,1 if point<b then w,h=(b-a):xd()elseif c then w,h=b,c end self(a.x,a.y,w,h)else self.x,self.y,self.w,self.h=a,b,c,d end return self end,__add=function(r,pt)local r2=-r 
r2.x+=pt.x
r2.y+=pt.y
return r2 end,__sub=function(r,pt)local r2=-r 
r2.x-=pt.x
r2.y-=pt.y
return r2 end,__mul=function(r,n)local r2=-r 
r2.w*=n
r2.h*=n
return r2 end,__div=function(r,n)return r*(1/n)end,__eq=function(r1,r2)return r1:p1()==r2:p1()and r1:p2()==r2:p2()end,__len=function(r)return r.w*r.h end,__lt=function(r1,r2)return r1.x+r1.w<=r2.x+r2.w and r1.y+r1.h<=r2.y+r2.h and r1.x>=r2.x and r1.y>=r2.y end,__unm=function(r)return rectangle(r)end},rectangle.xj)function rectangle:zj(n,d)n=n or 1 if d then local xy,wh=d%2==0,d<=1 and"w"or"h"if xy then if wh=="w"then 
self.x-=n
else 
self.y-=n
end end 
self[wh]+=n
else 
self.x-=n
self.y-=n
n*=2
self.w+=n
self.h+=n
end return self end function rectangle:vb(cb,oe)oe=oe or 1 local r=-self 
if(oe==0)return self
r.w,r.h=r.h,r.w r.x,r.y=r:p1():vb(cb):xd()
r.x-=r.w-1
return r:vb(cb,oe-1)end function rectangle:p1()return point(self:xd())end function rectangle:p2()return point(self.w,self.h)+self end function rectangle:ke()return self.x,self.y,self:p2():xd()end function xk()nc,hj,ve,ei={},{},rectangle"0,0,30,30",rectangle"1,1,28,28"oi(function(p)nc[#p]=void end)end function vh(p)return ei>p end function fb(p)return nc[#p]end function fh(p,t)if ve>p then t.lights=fb(p).lights nc[#p]=t end end function pb(e)local key=#e.pos if hj[key]then add(hj[key],e)else hj[key]={e}end 
if(creature<e)jj+=1
if(tb>e.pos)ki()
if(e.md)e:md()
end function yd(pos)return hj[#pos]end function qj(pos)for e in all(hj[#pos])do 
if(creature<e)return e
end end function dk(e,je)if e.pos then local key=#e.pos if hj[key]then del(hj[key],e)
if(#hj[key]==0)hj[key]=nil
if(creature<e)jj-=1
if(tb>e.pos)ki()
if not je then 
if(e.pe)e:pe()
if(e!=you)e.pos=nil
end end end end function be(e,pos)dk(e,true)e.pos(pos)pb(e)end function id(r,type)type=type or void local qb=true ui(function(p,t)
if(not(type<t))qb=false return true
end,r)return qb end function oi(fn,oc)oc=oc or ve for y=oc.y,oc.y+oc.h-1 do for x=oc.x,oc.x+oc.w-1 do 
if(fn(point(x,y)))return true
end end end function ui(fn,oc)oi(function(p)local t=fb(p)
if(t and fn(p,t))return true
end,oc)end function vg(fn,oc)local hd={}function gd(arr)foreach(arr,function(e)add(hd,e)end)end if oc then oi(function(p)gd(yd(p))end,oc)else ld(hj,gd)end return foreach(hd,fn)end function ci(pos,fn,bi,tg)local mj=rectangle(pos):zj(1)ui(function(p,t)
if(p!=pos or tg)
and(not bi or p.x==pos.x or p.y==pos.y)then return fn(p,t)end end,mj)end function ji(p1,p2,ej)local fe=point"x=8,y=8"-p1 local rel=p2+fe 
if(not mb[#rel])return p1
for se in all(mb[#rel])do 
se-=fe
local t=fb(se)
if(t and t.solid)return se
if(ej and qj(se))return se
end end function los(p1,p2)return not ji(p1,p2)end function uj(pos,class,bi)local bc=0 ci(pos,function(p,t)if class<t then 
bc+=1
end end,bi)return bc end function mh(mg,ih,kj,range)local g,qf,ad,rf,kj,range,hh,lc={[#mg]={vj=0,xc=0}},p_queue(),999,timer(),kj or function(pos,tile)
if(not tile.solid)return 0
end,range or 0 qf(#mg,0)while#qf>0 and stat(0)<1000 do rf()local re=-qf if point(re):ic(ih)<ad+5 and stat(0)<1000 then ci(point(re),function(p,t)local de,vj,ef=#p,g[re].vj+1,p:ic(ih)local xc=ef<=range and 0 or(not g[de]or g[de].vj>vj)and ef<=ad+5 and kj(p,t,ih,vj,g,re)if xc then g[de]={vj=vj,ph=re}
if(ef<ad)ad,hh=ef,de
if ef<=range then lc=de return true end 
xc+=ef+vj
qf(de,xc)end end,true)
if(lc)qf:gg()
end end local path,i=stack(),lc or hh while i and g[i].ph do path(point(i))i=g[i].ph end return#path>0 and path end function qi(r,class)oi(function(p)fh(p,class())end,r)end function yj(zh)zh=zh or function(p,t)return not t.solid and not yd(p)end local yc=rnd_queue()for i=1,784 do yc("x="..(i%28+1)..",y="..flr(i/28+1))end while#yc>0 do local pos=point(-yc)
if(zh(pos,fb(pos)))return pos
end end function sc(sprite,mg,ih,tf,rb)ih=ji(mg,ih,true)or ih local jb,fe=ck(mg),(ih-mg)*2 df(cocreate(function()for i=1,4 do 
jb+=fe
if(rb)pal(12,rb)
spr(sprite,jb:xd())yield()end tf(ih)end))end entity=jd:gh"classname=entity,name=entity,sprite=93,flr_mult=0"function entity:ri(pos)if pos then self.pos=-pos pb(self)end end function entity:can_see(pos)local t,p=fb(pos),self.pos return pos==p or(p:ic(pos)<=self.sight_rad or t.lights and not self.blind)and los(p,pos)end function entity:draw(jb)jb=jb or ck(self.pos)
if(self.rb)pal(12,self.rb)
spr(self.le or self.sprite,jb:xd())pal()local weapon=self.ij and self.ij.weapon 
if(weapon)weapon:draw(jb+point"x=2,y=0")
if self.le then ki(we(zg,4))self.le=nil end end item=entity:gh"classname=item,sprite=108,name=item,qty=1,throw_sfx=6"function item:ri(ie)if creature<ie then ie:take(self)elseif point<ie then entity.ri(self,ie)elseif ie then zf(ie,self)self.holder,self.pos=nil end end function item:bk(qty)
self.qty+=qty
if self.qty<=0 then if self.holder then del(self.holder.rc,self)end dk(self)zf("holder=nil,pos=nil",self)end end meat=item:gh"classname=meat,sprite=70,name=meat,hp_boost=5,flr_mult=3,use_msg=you feel much better.,use_sfx=5"function meat:use(c)
c+=self.hp_boost
end apple=meat:gh"classname=apple,sprite=71,name=apple,hp_boost=3,use_msg=you feel a bit better.,flr_mult=-1"bread=meat:gh"classname=bread,sprite=72,name=bread,hp_boost=6,flr_mult=3"statue=item:gh"classname=statue,sprite=74,name=statue"function statue:md()if nd and rnd(100)<qd-2 then sentinel(-self.pos):take(self)else fb(self.pos).solid=true end end function statue:pe()local t=fb(self.pos)t.solid=t:class().solid end color_coded_itm=item:gh"classname=color_coded_itm"function color_coded_itm:ii()local colors=rnd_queue()ld(self.colors,function(name,sk)colors{name=name.." "..self.classname,rb=sk}end)for i=1,#self.types do local c=-colors zf(c,self.types[i])end end function color_coded_itm:ri(ie)item.ri(self,ie)if not self.ti then zf(self.types[ob(#self.types)],self)end end function color_coded_itm:use(c)local ti,name,nb,yb=fk(self,"ti,name,r_name,classname")nb=nb.." "..yb if wk(c)and name!=nb then function aj(i)
if(i.name==name)i.name=nb
end aj(self.types[ti])vg(function(e)aj(e)if e.rc then foreach(e.rc,function(i)aj(i)end)end end)msg("that was a "..nb)end self:oj(c)end potion=color_coded_itm:gh"flr_mult=3,sprite=65,throw_sfx=7,use_sfx=4,classname=potion,types={{r_name=healing,use_msg=you are healed,ti=1},{r_name=poison,use_msg=you feel sick,ti=2},{r_name=wisdom,use_msg=you feel more experienced,ti=3},{r_name=sleep,use_msg=you fell asleep,ti=4},{r_name=lethe,use_msg=where are you?,ti=5},{r_name=water,use_msg=refreshing!,ti=6},{r_name=juice,use_msg=yum,ti=7},{r_name=spectral,use_msg=you feel ghostly,ti=8},{r_name=toughness,use_msg=nothing can hurt you now!,ti=9},{r_name=blindness,use_msg=who turned out the lights?,ti=10},{r_name=speed,use_msg=the world slows down.,ti=11}},colors={1=viscous,2=fizzing,3=grassy,4=umber,5=ashen,6=smoking,7=milky,8=bloody,9=orange,10=glowing,11=lime,12=sky,13=reeking,14=fragrant,15=bland,0=murky}"potion:ii()function potion:oj(c)local ti,si=self.ti,c==you 
if(ti==1)c.hp,c.poison,c.vc=c.hp_max
if(ti==2)c.poison=ob(9,5)
if(ti==3)c.exp=flr((c.exp+10)*1.5)
if(ti==4)c.sleep=ob(15,8)
if ti==5 then zf("target=nil,path=nil",c)if c==you then ui(function(p,t)t.sf=nil end)end end 
if(ti==7)c+=2
if(ti==8)c.spectral=ob(20,10)
if(ti==9)c.tough=ob(7,3)
if(ti==10)c.blind=ob(12,8)
if(ti==11)c.yf=ob(20,4)
end function potion:kf(pos)lf(self," shatters!")ci(pos,function(p,t)local c=qj(p)
if(c)self:use(c)
self.sprite=60 df(cocreate(function()for i=1,3 do self:draw(ck(p))yield()end end))end,false,true)dk(self)end mushroom=color_coded_itm:gh"use_sfx=5,classname=mushroom,sprite=67,types={{r_name=tasty,use_msg=that was delicious,ti=1},{r_name=disgusting,use_msg=that was awful,ti=2},{r_name=deathcap,use_msg=you feel deathly ill,ti=3},{r_name=magic,use_msg=look at the colors!,ti=4}},colors={0=speckled,14=lovely,8=bleeding,6=chrome,3=moldy,15=fleshy}"mushroom:ii()function mushroom:oj(c)local ti=self.ti 
if(ti==1)c+=10
if(ti==2)c-=1
if(ti==3)c.hp=1
if(ti==4)c.vc=ob(15,4)
end scroll=color_coded_itm:gh"use_sfx=3,flr_mult=2,classname=scroll,sprite=66,types={{r_name=movement,use_msg=you are somewhere else,ti=1},{r_name=wealth,use_msg=riches appear around you,ti=2},{r_name=summoning,use_msg=you have company!,ti=3},{r_name=magic mapping,use_msg=you know your surroundings.,ti=4},,{r_name=firebolt,use_msg=the scroll sends out fire.,ti=5}},colors={1=denim,0=filthy,3=mossy,4=tattered,8=ominous,6=faded}"scroll:ii()function scroll:oj(c)local ti=self.ti local yi 
if(ti==1)be(c,yj(nil,-1))
if(ti==2)yi="item_table"
if(ti==3)yi="spawn_table"
if ti==5 then xh(function(p)sc(59,point(you.pos),p,function(ih)local fg=qj(ih)
if(fg)you:bg(fg,fg.hp)
end)end)end if yi then ci(c.pos,function(p,t)while not hf(t[yi],function(class)if class!=scroll then class(p)return true end end)do end end)end if ti==4 then ui(function(p,t)t.sf=true end)end end equipment=item:gh"classname=equipment,bonuses={hitbonus=1}"function equipment:equip(c)local equip_slot,itm=self.equip_slot,c:drop(self,1,point"x=99,y=99")local ij=c.ij[equip_slot]
if(ij)ij:remove()
ld(self.bonuses,function(v,k)if type(v)=="number"then 
c[k]+=v
else c[k]=v end end)dk(itm)c.ij[equip_slot],itm.holder=itm,c end function equipment:remove()local holder=self.holder holder.ij[self.equip_slot]=nil ld(self.bonuses,function(v,k)if type(v)==number then 
holder[k]-=v
else holder[k]=holder:class()[k]end end)holder:drop(self)holder:take(self)end torch=equipment:gh"classname=torch,sprite=64,name=torch,sight_rad=4,equip_slot=weapon,bonuses={sight_rad=1,dmin_boost=1,dmax_boost=1}"function torch:md()self.sj=rectangle(self.pos):zj(self.sight_rad)ui(function(p,t)if p:ic(self.pos)<self.sight_rad and los(self.pos,p)and not(void<t)then t.lights=t.lights or{}add(self,t.lights)end end,self.sj)end function torch:pe()ui(function(p,t)if t.lights then del(t.lights,self)
if(#t.lights==0)t.lights=nil
end end,self.sj)end knife=equipment:gh"classname=knife,sprite=68,name=knife,equip_slot=weapon,throw_sfx=8,dthrown=4,flr_mult=5,bonuses={hit_boost=5,dmin_boost=1,dmax_boost=2}"sword=knife:gh"classname=sword,sprite=69,name=sword,equip_slot=weapon,dthrown=3,flr_mult=1,bonuses={hit_boost=-10,dmin_boost=3,dmax_boost=6}"tomahawk=knife:gh"classname=tomahawk,sprite=73,name=tomahawk,equip_slot=weapon,dthrown=8,flr_mult=1,bonuses={hit_boost=5,dmin_boost=1,dmax_boost=1}"plate_armor=equipment:gh"classname=plate_armor,sprite=75,name=plate armor,equip_slot=armor,flr_mult=1,bonuses={ac=3}"leather_armor=equipment:gh"classname=leather_armor,sprite=76,name=leather armor,equip_slot=armor,flr_mult=2,bonuses={ac=1}"spiked_armor=equipment:gh"classname=spiked_armor,sprite=77,name=spiked armor,equip_slot=armor,flr_mult=2,bonuses={ac=2,dmin_boost=2}"warded_armor=equipment:gh"classname=warded_armor,sprite=78,name=warded armor,equip_slot=armor,flr_mult=1,bonuses={ac=6}"def_ring=equipment:gh"classname=def_ring,sprite=80,name=ring of shielding,equip_slot=ring,flr_mult=5,bonuses={ac=3}"creature=entity:gh"classname=creature,sight_rad=4,hp_max=10,exp=2,hitrate=75,min_dmg=0,max_dmg=4,ac=0,dmax_boost=0,dmin_boost=0,hit_boost=0"zf({__add=function(self,x)self:ne(x)return self end,__sub=function(self,x)return self+-x end},creature.xj)function creature:ri(ie)entity.ri(self,ie)self.hp,self.turn,self.rc,self.ij=self.hp_max,turn,{},{}
if(self.item_table)self:hc()
end function creature:hc()hf(self.item_table,function(class)local itm=class(self)
if(equipment<itm)itm:equip(self)
end)end function creature:take_turn(a2)if not self.dj and self.pos then function j()self:take_turn(a2)end local fi,target,guard_pos,sight_rad,path,ranged,dest=fk(self,"pos,target,guard_pos,sight_rad,path,ranged")if not target and self.vd!=turn and self:can_see(you.pos)and fi:ic(you.pos)<sight_rad then self.target=you return j()end dest=target and target.pos or guard_pos local xe=target and self:can_see(dest)if target and(target.hp<=0 or not xe and fi:ic(dest)>2)then self.target,self.vd=nil,turn return j()end if ranged and xe then sc(ranged,fi,dest,function(qg)if qg==dest then self:bg(target)end end)else if dest then local pj=fi:ic(dest)
if(not path or pj<2 and
fi:ic(path:get(1))>pj)and fi!=dest then self.path=mh(fi,dest)end end local d 
if(not(self.path or guard_pos))d=ob(3,0)
self:move(d)end end 
if(self.yf and not a2)self:take_turn(true)
end function creature:tj(c2)return self.vc or target==c2 or not(self:class()<c2)end function creature:take(itm)for i in all(self.rc)do 
if(i.name==itm.name)then
dk(itm)i:bk(itm.qty)return end end if#self.rc==7 then 
if(self==you)msg"you can't carry any more."
else dk(itm)itm.pos,itm.holder=nil,self add(self.rc,itm)end end function creature:drop(itm,qty,pos)qty=qty or itm.qty pos=pos or self.pos itm:bk(-qty)for e in all(yd(pos))do 
if(e.name==itm.name)e:bk(qty)return e
end local te=itm.qty>0 and itm:class()()or itm zf(itm,te)te.qty,te.pos,te.holder=qty,-pos,nil pb(te)return te end function creature:move(d)
if(self.vc and rnd(2)<1)d=ob(3,0)
local path=self.path if d or path then local jb=d and point(self.pos):move(d)or-path local dest,fg=fb(jb),qj(jb)if dest and vh(jb)and not fg and(not dest.solid or self.spectral)then 
if(not self.le and tb>self.pos)self.le=self.sprite+1
be(self,jb)
if(wk(self))sfx(0)
else if fg and self:tj(fg)then self:bg(fg)end self.path=nil end 
if(dest and dest.kk)dest:kk(self)
if(path and#path==0)self.path=nil
end end function creature:ne(n)self.hp=min(self.hp_max,self.hp+n)if self.hp<=0 then if self==you then self.hp,self.exp=self.hp_max,0 deaths=deaths and deaths+1 or 1 msg("deaths:"..deaths)return end foreach(self.rc,function(itm)self:drop(itm)end)ld(self.ij,function(itm)self:drop(itm)end)lf(self," died.")dk(self)end end function creature:bg(c2,dmg,hitrate)dmg,hitrate=dmg or max(0,ob(self.max_dmg+self.dmax_boost,self.min_dmg+self.dmin_boost)-c2.ac),hitrate or self.hitrate+self.hit_boost 
if(not self.le and tb>self.pos)self.le=self.sprite+2
local fx function ed(bb,hk)lf(self,bb..c2.name..hk)end if ob(100)>hitrate then ed(" missed ","!")fx=1 else c2.target=c1 fx=2 if dmg==0 then ed(" barely hits ",".")return else ed(" hit "," for "..dmg.." damage.")if dmg>=c2.hp then 
if(self==you)kills+=1
self.exp+=c2.exp
end end 
c2-=dmg
end 
if(fx and wk(self))sfx(fx)
end rat=creature:gh"classname=rat,name=rat,sprite=144,hp_max=5,sight_rad=6,flr_mult=-10,item_table={meat=200,knife=10}"kobold=rat:gh"classname=kobold,name=kobold,sprite=131,hp_max=8,exp=4,min_dmg=1,max_dmg=5,ac=1,flr_mult=10,item_table={torch=600,apple=200,knife=400,leather_armor=100}"mantid=rat:gh"classname=mantid,name=mantid,sprite=147,fast=true,hp_max=12,hitrate=60,min_dmg=6,max_dmg=9,exp=10,flr_mult=10,item_table={potion=800,meat=500}"watcher=mantid:gh"classname=watcher,name=watcher,sight_rad=10,sprite=176,hp_max=20,hitrate=95,fast=false,min_dmg=3,max_dmg=6,ac=3,exp=20,flr_mult=2,item_table={knife=500,sword=1000,bread=800,potion=400,spiked_armor=200}"function watcher:ri(ie)creature.ri(self,ie)self.guard_pos=-self.pos end sentinel=watcher:gh"classname=sentinel,name=sentinel,sight_rad=2,sprite=160,hp_max=25,hitrate=100,fast=false,min_dmg=3,max_dmg=3,ac=3,exp=20,flr_mult=2,item_table={statue=1000,spiked_armor=500}"player=creature:gh"classname=player,name=rogue,sprite=128,hp_max=10,hitrate=85,min_dmg=1,max_dmg=5,take_turn=always_nil,item_table={bread=1000,apple=800,meat=200,torch=300,potion=500,scroll=500}"function player:move(d)
if(not pk)creature.move(self,d)
sh()end tile=jd:gh"classname=tile,solid=true,sprite=nil"function tile:ri()
if(self.alt_sprite and rnd(100)<5)self.sprite=self.alt_sprite
end void=tile:gh"classname=void,sprite=62"function void:bj()return self end floor=tile:gh"classname=floor,solid=false,sprite=19,alt_sprite=20"wall=tile:gh"classname=wall,sprite=16,alt_sprite=17"dungeon_floor=floor:gh"classname=dungeon_floor,item_table={knife=1,potion=2,scroll=2,mushroom=2,bread=1,plate_armor=-1,leather_armor=-2},spawn_table={rat=100,kobold=200,mantid=-20,watcher=-20}"dungeon_wall=wall:gh"classname=dungeon_wall"cave_floor=floor:gh"classname=cave_floor,sprite=3,alt_sprite=4,item_table={torch=20,apple=10,mushroom=50,potion=5,leather_armor=2},spawn_table={rat=400,mantid=-40,kobold=-2}"cave_wall=wall:gh"classname=cave_wall,sprite=0,alt_sprite=1"temple_floor=floor:gh"classname=temple_floor,sprite=35,alt_sprite=36,item_table={knife=20,tomahawk=0,sword=0,potion=30,scroll=30,def_ring=1,spiked_armor=0,warded_armor=-4},spawn_table={kobold=900,mantid=-15,watcher=0}"throne=floor:gh"classname=throne,sprite=34"floor_pedestal=floor:gh"classname=floor_pedestal,sprite=18"temple_wall=wall:gh"classname=temple_wall,sprite=32,alt_sprite=33"door=tile:gh"classname=door,sprite=21,use_sfx=9"function door:kk(rj)
if(self.solid)use(self,rj.pos)
end function door:use()local uh=self.solid and 1 or-1 self.solid=not self.solid 
self.use_sfx+=uh
self.sprite+=uh
end temple_door=door:gh"classname=temple_door,sprite=37"cave_secret_door=door:gh"classname=cave_secret_door,sprite=7"dungeon_secret_door=door:gh"classname=dungeon_secret_door,sprite=23"temple_secret_door=door:gh"classname=temple_secret_door,sprite=39"up_stair=tile:gh"classname=up_stair,sprite=5,solid=false"function up_stair:use()msg"you're not going back"end stair=tile:gh"classname=stair,sprite=6,solid=false"function stair:use()if fb(you.pos)==self then xk()
qd+=1
jj=0 ld(ni,function(cl)if rat<cl then 
cl.hp_max+=2
cl.min_dmg+=1
cl.max_dmg+=1
end end)yg,nd=point(you.pos),true pb(you)ak()uc()else msg"move closer to descend"end end function uc()local og=lb"addr=264e,len=638"local rk,range,ge=100-#og,4,timer()rd,nd,ik,pf,me,l=td,fk"true,0,0,cave_wall,cave_floor"ue(function()while ik<rk do ge()local ai=ik>55-qd if ai then me,l,range=dungeon_wall,dungeon_floor,0 end if zc then while#zc>0 do yg=-zc local t=fb(yg)if t.solid and not(door<t)then if t.jg and uj(yg,floor,false)>1 then fh(yg,door())vg(function(e)dk(e)end,rectangle(yg))else fh(yg,l())end 
pf+=lj(yg)
end end ik,zc=min(rk,flr(pf/#ve*(120+qd*10))),nil else wj=rectangle()*(ai and 4 or ob(4))if ai then local pos=yj(function(p)return id(wj+p)and vh(wj+p)end)
if(not pos)ik=rk break
wj+=pos
for d=1,4 do local bf=rectangle(wj)while(id(bf)and ve>bf and rnd(10)<7)do wj(bf)bf:zj(1,d)end end qi(wj,me)
pf+=#wj
wj:zj(-1)qi(wj,l)wj:zj(1)else 
wj+=yg
end ui(function(p,t)if ai then 
if(uj(p,l)==1 or not vh(p))t.fixed=true
if(dungeon_wall<t)t.jg=true
if(not t.lights)torch(p)
else if p:ic(yg)<=wj.w/2 then fh(p,cave_floor())
pf+=(1+lj(p))
end end end,wj)zc=ik<rk and mh(yg,ai and(point(ob(wj.w-2,1),ob(wj.h-2,1))+wj)or yj(always_true),function(p,t,ih)
if(t.fixed or not vh(p))return
return(t.jg and 40 or 0)+((t and t.solid or door<t)and(nj and(5+uj(p,floor)*2)or 10-uj(p,floor)*2+rnd(4))or 0)end,range)end end ui(function(p,t)if door<t and uj(p,door,true)>0 then fh(p,uj(p,wall,true)>1 and dungeon_floor()or dungeon_wall())end end)for i=1,#og do local sd=og[i]local qh,db,class=sd.try,sd.max yj(function(p,t)
qh-=1
if(qh<1)return true
ge()for hb=0,3 do function wc(jf,fn)return foreach(jf,function(k)if tile<k or entity<k then class=k else k=(#k==4 and rectangle or point)(fk(k))k=(k+p):vb(p,hb)return fn(k,class)end end)end if not wc(sd.val,function(pos,class)return not vh(pos)or not(rectangle<pos)and not(class<fb(pos))or pos.w and not id(pos,class)end)then wc(sd.bld,function(pos,class)if tile<class then if pos.w then qi(pos,class)else fh(pos,class())end elseif entity<class then class(pos)end end)
db-=1
if(db<1)return true
end end end)
ik+=1
end fh(you.pos,up_stair())ui(function(p,t)hf(t.item_table,function(class)class(p)return true end)end)nd,ik=false,100 return end)end function lj(p)local z=0 ci(p,function(p,t)if void<t or not vh(p)then fh(p,me())
z+=1
end end)return z end function xh(rg,pc)ze()eb,kb,eg,rd={sprite=28,pos=-you.pos,draw=entity.draw},rg,pc or tb,rh ki()end function ib()eb=nil ki()
if(rd==rh)rd=uf
end function qc(r)
if(lh(r))r=rectangle(r)
rectfill(zd(4,r:ke()))rectfill(zd(2,(-r):zj(-1):ke()))end msg=queue()function lf(e,tf,pre)if wk(e)and(pre or tf)then pre,tf=pre or"",tf or""msg(pre..e.name..tf)end end function xg()msg.qk,msg.kc=msg.kc or msg.qk,(#msg>0)and-msg end menu=stack:gh"classname=menu,index=1,turn_modded=0"dg=stack()function menu:ri()stack.ri(self)self.pos=rectangle"5,25,4,12"end function ak()ok=-dg ki()
if(not ok and rd==yh)rd=uf
end function ze()while ok do ak()end end function menu:add(name,op,gi,item)self{name=name,op=op,turn=gi,item=item}end function menu:ce()
if(self.ab)self:ab()
dg(ok)ok,self.vf,rd=self,#dg,yh ki()end function menu:draw()local pos,w=self.pos+(point(10,10)*self.vf),19 foreach(self.values,function(v)w=max(w,#v.name*4+(v.item and 24 or 14))end)pos.w,pos.h=w,max(9*#self+2,10)qc(pos)for i=1,#self do local dp,menuitem=point(10,9*i-5)+pos,self:get(i)local itm=menuitem.item if i==self.index then spr(31,dp.x-8,dp.y)end if itm then itm:draw(dp-point(0,2))
if(itm.qty>1)print(itm.qty,dp.x+7,dp.y+2,10)
dp.x+=13
end print(menuitem.name,dp.x,dp.y,10)
i+=1
end end ec=menu()function ec:ab()while self:get(#self).turn do self:sg()end ci(you.pos,function(p,t)foreach(yd(p),function(e)if item<e then self:add("take "..e.name..(e.qty>1 and"("..e.qty..")"or""),function()you:take(e)self:ab()end,turn)end end)end,false,true)
if(self.index>#self)self.index=#self
end ec:add("inventory",function()inventory:ce()end)ec:add("equipment",function()dc:ce()end)ec:add("knowledge",function()nf:ce()end)ec:add("use",function()ze()xh(function(p)
if(use(fb(p),you))return
for e in all(yd(p))do 
if(use(e,you))return
end msg"you can't use that."end,rectangle(you.pos):zj())end)inventory=menu()function inventory:ab()self.index=1 self:gg()foreach(you.rc,function(itm)self:add(itm.name,function()local eh,pi,ah=menu(),itm.name,function()ze()sh()end if itm.use then eh:add("use "..pi,function()use(itm,you)ah()end)end if equipment<itm then eh:add("equip "..pi,function()itm:equip(you)ah()end)end eh:add("drop "..pi,function()you:drop(itm,1)ah()end)eh:add("throw "..pi,function()ze()xh(function(p)sc(itm.sprite,point(you.pos),p,function(ih)you:drop(itm,1,ih)local fg=qj(ih)
if(fg)you:bg(fg,itm.dthrown or 1)
if(itm.kf)itm:kf(ih)
sfx(itm.throw_sfx)sh()end,itm.rb)end)end)eh:ce()end,nil,itm)end)end dc=menu()function dc:ab()self.index=1 self:gg()foreach(fj,function(equip_slot)local itm=you.ij[equip_slot]self:add(itm and itm.name or equip_slot,itm and function()local eh=menu()eh:add("remove "..itm.name,function()itm:remove()self:ab()ak()end)eh:ce()end or always_nil,nil,itm or item{sprite=48+#self})end)end nf=menu()function nf:ab()self:gg()local o,pg=lb"armor class:,damage:,hit rate:,creatures killed:,most exp:,most kills:,deepest floor:",{you.ac,(you.min_dmg+you.dmin_boost).."-"..(you.max_dmg+you.dmax_boost),(you.hitrate+you.hit_boost),kills,cj[1],cj[2],cj[3]}for i=1,#o do self:add(o[i]..pg[i],always_nil)end 
if(bd)self:add(bd,always_nil)
end function uf()for i=0,3 do 
if(btnp(i))you:move(i)
end 
if(btnp"4")ec:ce()
if(btnp"5")qe=not qe
ki()end function rh()for i=0,3 do if btnp(i)then local pos=(-eb.pos):move(i)if eg>pos and vh(pos)then eb.pos(pos)ki()end end end if btnp"4"then kb(eb.pos)ib()end 
if(btnp"5")msg"cancelled."ib()
end function yh()
if(btnp"0")ak()return
if(btnp"2")then
ok.index-=1
if(ok.index==0)ok.index=#ok
end 
if(btnp"3")ok.index%=#ok ok.index+=1
if btnp"4"or btnp"1"then 
if(ok.index<=#ok)ok:get(ok.index):op()ki()
end 
if(btnp"5")ze()
end function cc()
if(btnp"5")qe=not qe
sh()xg()end function td()
if(nd)return
ae=false rd=uf ki()end function bh()
tb-=tb+(point"x=8,y=8")-you.pos
end function _init()cartdata"phantasos"xk()xb,df,tb,rd,yg,qe,zg,turn,jj,lg,qd,nd,ae,kills,cj,fj=queue(),queue(),rectangle()*16,td,yj(always_true),fk"false,0,0,0,7,1,true,true,0,{0,0,0},{weapon,armor,ring}"you,uk,mb=player(yg),jh"addr=2000,len=284",{}bh()local cf=jh"addr=2284,len=3ca"foreach(cf,function(q)local of={}for i=2,#q do add(of,q[i])end mb[#q[1]]=of end)uc()msg"travel deeper, rogue."end function _update()if mk(xb)then return end if pk then turn=we(turn,1)if you.hp<=0 then zb,tk,rd=true,true,cc end pk=false local exp=you.exp you.hp_max,you.max_dmg,you.hitrate=10+flr(exp/30),player.max_dmg+flr(exp/100),80+exp/100 local pd={exp,kills,qd}for i=1,3 do cj[i]=max(pd[i],dget(i))dset(i,cj[i])end elseif btnp()!=0 and not gf then if not ae and#msg>0 then xg()else 
if(msg.kc)xg()
rd()end end end function _draw()zg=we(zg,1)if ae or nd then palt(0,false)sspr(32*(flr((zg%18)/6)),fk"96,32,32,0,0,128,128")
if(zg%9==0)sfx(0)
pal()
if(ae)sspr(fk"64,64,64,16,14,0,100,25")
local cd="press any key to start"
if(ik<100)cd="descending:"..ik.."%"
local x1=66-#cd*2 qc(rectangle(x1,118,#cd*4,128))print(cd,x1+1,121,10)return end if not nd and gf and wf(gf,zg)then gf=nil cls()bh()local gc function draw(s)spr(s,(gc*8):xd())end local li,th={},lb"0=0,1=0,2=1,3=1,4=2,5=1,6=5,7=6,8=2,9=4,10=4,11=3,12=1,13=5,14=8,15=4"for i=1,#uk do local dd=uk[i]gc=dd[1]local zi=gc+tb local t,key=fb(zi)or void,#gc ld(th,function(v,k)pal(k,you.vc and ob(16,0)or v)end)if tk or not(li[key]or t<void or(you.pos:ic(zi)>you.sight_rad and not t.lights)or you.blind)then t.sf=true if not you.vc then pal()end draw(t.sprite)vg(function(e)e:draw()end,rectangle(zi))elseif t.sf then draw(t.sprite)end pal()if t.solid or li[key]then for k=2,#dd do li[#dd[k]]=true end end end 
if(eb)eb:draw()
qc"8,116,110,10"print("hp:"..you.hp.."/"..you.hp_max.." exp:"..you.exp.." floor "..qd,fk"15,119,10")if qe then qc"17,19,94,94"rectfill(fk"19,21,110,112,0")ui(function(p,t)if t.sf or tk then function fd(s)local x,y=((p*3)+point"x=19,y=21"):xd()sspr((s%16)*8,flr(s/16)*8,8,8,x,y,3,3)end fd(t.sprite)if wk(p)then vg(function(e)fd(e.sprite)end,rectangle(p))end end end)end end 
if(mk(df,true))ki()
qc"2,2,124,14"
if(not msg.kc and#msg>0)xg()
local qk,kc=msg.qk or"",msg.kc or""print(qk,4,4,9)
if(#msg>0)spr(fk"31,120,10")
print(kc,fk"4,10,10")foreach(dg.values,function(m)m:draw()end)
if(ok)ok:draw()
end
__gfx__
12022201120220311202220111111111555155550000000000000000120222010122210000000000000000000000000000000000000000000000000000000000
212002201c1020312120022015551111511113350222200006666660212000201200021000000000000000000000000000000000000000000000000000000000
202110202c1030312021102055115515331131332661120007777710202110201200021000000000000000000000000000000000000000000000000000000000
22021020230230212202102011551155533551152777120006666220220210202000002000000000000000000000000000000000000000000000000000000000
02021021230c30210202102111155111335533112666620007771210020210212000002000000000000000000000000000000000000000000000000000000000
02021021102c10210202102155111555133333332777770006622110020210212000002000000000000000000000000000000000000000000000000000000000
12021210022c02111202121015555111513335532666666002121220120210202000002000000000000000000000000000000000000000000000000000000000
12022210022220111202221011111111551155117777777700000000120210201000001000000000000000000000000000000000000000000000000000000000
120112011201120122222222000000000000000012011201120112011211100112d112d10000000000000000000000009aa009aa9aaaa0009a9a00000009a000
d2ddd2ddd2ddd2dd200000020110222001110220d999aaadd999aaadd2ddd0ddd22dd22d0000000000000000000000009a00009a9a09a0009a9a000000009a00
20112011200000012cdddd020110222001110220192211a1192000a121110111110000d1000000000000000000000000000000009a09a00009a000009aaaaaa0
2ddd2ddd2d0bb70d2cdddd020000022001100000d90210add92000ad2ddd0ddddd00002d000000000000000000000000000000009a09a0009a9a000000009a00
120112011203bb012cdddd020022000000001100190210a1192000a1121110111000000d000000000000000000000000000000009aaaa0009a9a00000009a000
d2ddd2ddd200000d2ccddd020122011002201120d92211add92000add2ddd0ddd000000200000000000000000000000000000000000000000000000000000000
20112011201120112ccccc020110011002200220190210a1192000a1211120111000000d0000000000000000000000009a00009a000000000000000000000000
2ddd2ddd2ddd2ddd222222220000000000000000d92211add92000ad2ddd20ddd00000020000000000000000000000009aa009aa000000000000000000000000
33bbbb333333b3331b3333b11111111112211221b113b113b113b113333bb33333bbbb3300000000444444440000000000000000000000000000000000000000
0bb10bb1013bcb31131222311b2222b12b1221b2bb3b1b3bbb3b0b3b03b00b313b0001b30000000048c080340000000000000000000000000000000000000000
10b10b1103bcccb103112230121dd12121d11d12b3b313b3b3b000b310b00b111b0001b10000000048c289340000000000000000000000000000000000000000
10b10b11033bcb310dd11dd012dccd21121cc121b3b313b3b3b000b310b00b111b0001b100000000444444440000000000000000000000000000000000000000
10b10b11103b0b110dbddbd012dccd21121cc121b3b313b3b3b000b310b00b111b0001b1000000004389c8340000000000000000000000000000000000000000
10b10b11103b0b110bddddb0121dd12121d11d12b3b313b3b3b000b310b00b111b0001b100000000444444440000000000000000000000000000000000000000
0bb10bb1033b0b31133cc3311b2222b12b1221b2b3b313b3b3b000b303b00b313b0001b30000000049c389340000000000000000000000000000000000000000
33bbbb333333b333110000111111111112211221bbbbbbbbbbbbbbbb333bb33333bbbb3300000000444444440000000000000000000000000000000000000000
0000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0c000101111011000000000000000
000440000444444400040000000000000000000000000000000000000000000000000000000000000000000000808000000cccc0110000110000100044000000
0040400004004004004440000000000000000000000000000000000000000000000000000000000000000000089aa800cccc0000011110000000001046600000
0040400004000004000400000000000000000000000000000000000000000000000000000000000000000000009c9000c0000c0c100011110010000045550000
004040000440004400404000000000000000000000000000000000000000000000000000000000000000000008aa9800c00cc000111001110000000046666000
004440000040004004404400000000000000000000000000000000000000000000000000000000000000000000808000ccc00cc0011110001000000045555500
0004400000444440004440000000000000000000000000000000000000000000000000000000000000000000000000000cc00c00001110110000010046666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc00110111010000000045555555
222244222000000000000000000000000000070000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007a8000099000007fff400004900000007a0000007a00000eee7000004000000000000007a770009aa0000000000000000000000000000000000000000000
0000aa800007700007fcff0000c4c90000007a000000aa000eee887000884b0000aa7a000000a970009990000760076008800880060000700aa0087000000000
0000e8000007700007cfff00044ccc9000007a000000aa00ee7888700288780009979a700000a070009a000007655760058558900ee55ee00aa8877000000000
00009400007cc70007cccf000444c990000088000000aa00e787887002888800097997a00000a000009aaa000076660000889800006e6e00008aa80000000000
0000940007c7cc7007ffff400009f0000000080000000a00ee78870002288800099979900000a0000099a000007666000088980000e6e70000a8870000000000
00000400077cc770007ffff000009f00000000000000e8000888870000222000009999000000000009aaaa0000766600000990000e0e7070008aa80000000000
0000000000777700000000000000000000000000000008000777700000000000000000000000000009999a000000000000000000000000000000000000000000
00000000000000000444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000bb000040004000009a900007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000080000000b0000044400000a000a007cc77700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000488000000b000067a7600009000900c00c7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a4aa0000e300006a9a60000a000a00c00c7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009000a00008e000067876000cc9a90007cc77700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a0aa000008000044444000cc00000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009aa00000000000044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000000000000077700000000
0000000000000000000000000000000000000000004000000000000007777700000c000006000000000a00000044440000aaaa0000777700000077a0000cc000
000000000000000000000000000000000000000000400000008880000511110000cac000006666600aaaaa00094949400aaaaaa007cc777000077a00007cc700
0000000000000000000000000000000000087000094999000881880005111100000c00000650550000aaa0000949494004aaaa900c00c7700977a0000cc77cc0
00000000000000000000000000000000000780000942290001171100051111000000bb000656000000a0a00009494940044aa9900c00c770099a00000cc77cc0
0000000000000000000000000000000000000000099999000771770006767600000b3b000650000000000000094949400444999007cc777099880000007cc700
000000000000000000000000000000000000000000000000007770000767670000b00000000000000000000000444400004499000077770088000000000cc000
000000000000000000000000000000000000000000000000000000000077770000b0000000000000000000000000000000049000000000000800000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000c0000c000000000000000000000000000000000044000000000000
0009a9000ffffff00000060000ccccf00006660007700000000044440000000000000600000cc00c005dd50000000cc000bb0bb0000a000000444400000d0000
00a000a0044444400555555000ccccf000666660074000000004400700222200055555500cc00cc000d11d0000004cc00033033000aaa00000099000d0ddd0d0
00900090044444400555655000ccccf000655560000400000044007002222220055565500c00c0c0005dd500000444000bbb3bbb000a000000044900dd050dd0
00a000a0044444400556765000ccccf0006666600000400004400700044aa440055676500c0c00c00dd55dd0002400000bbb3bbb00000a0000444000d55555d0
0cc9a900000550000555655000ccccf000655560000004800400700004444440055565500cc00cc005dddd50024000000b00300b00a0aaa0044444000d0d0d00
0cc00000000440000000000000cffff00066666000000848040700000222222000000000c00cc0000555555004000000000330000aaa0a000444440000ddd000
00000000000440000000000000000000000000000000008004700000000000000000000000000c0000555500000000000000300000a000000044400000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666600000666600066600609900990099099009944900000000000000000000000000000000000000000000000000000000000000000000000000000000000
0062260000062260006220670944449009944400947490000000000000000000000aaaa000aa9000000000000000000000a90000000000000000000000000000
0076760000076760006666700074470000097400009959900000000000000000000a90aa900a9000000000000000000000a90000000000000000000000000000
0767676000767676066767000099990000999900008559000000000000000000000a900aa90a9000000000000000000000a90000000000000000000000000000
0766766000766766067676000885588008885500088558000000000000000000000a9000a90a9000000000000000000000a90000000000000000000000000000
0676667000676667066776000855558088885550085558000000000000000000000a900aa90a90aa0000aaa000aaa900aaaaa90aaa00000aaa0000aa0000aaa0
0667776006667770777666008855558888855550885555800000000000000000000a90aa900aaaaa000aa0a900aaaa9000a900aa0a9000a00a900a9aa000a0a9
ef0f0f000e0ff000ef00ff800008b80000008b000bb000bb0000000000000000000aaaa0000a900a90a900a900a90aa900a90a900a9000aa0000a900a90aa000
0e08f8000f00f8f0f0f8f800000bbb000000bb000b00000b0000000000000000000a9000000a900a90a900a900a900a900a90a900a90000aa900a900a900aa90
f00fff00e004fff8e004ff80000aba3b0000b0000b08380b0000000000000000000a9000000a900a90a900a900a900a900a90a900a900a000a90a900a9a000a9
e0048400f04efee0f004f0007aaaa33b66a0a3b00b4a3a4b0000000000000000000a9000000a900a000aa0a900a900a900a900aa0a9000a00a90aa9aa90a00a9
f0444e00e4efff00e04efee073aa330b6aaa30b00b0aaa0b0000000000000000000aaa00000aa00a9000aa0aa0aa00aa00a9900aa0aaa0aaa9000aaa900aaa90
e44fefe04efffef0e04ef4000733300b0aa330b0006aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000
f4efffe04eee4ef004efff000555b0b0b555b0000b5a5a0000000000000000000000000000000000000000000000000000000000000000000000000000000000
04eefee04e404e0004e4ef00b0b0b0000b0b0000b0b0b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000a000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009aa000009aa0000098a0000aaaaa00aaaaa0000aaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009990000099900000999000099caa00099caa00099ca8000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009a0000009a0000009a0a008099880800998800809988800000000000000000000000000000000000000000000000000000000000000000000000000000000
0009aaa00009aa000009aa90088498a0888498a00884988000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099a000009aaa000099900088844000888440008884aa000000000000000000000000000000000000000000000000000000000000000000000000000000000
009aaaa0009a9a00000aaa9000888800000888000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
009999a000aaa9900099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007770000077700000777000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
008780000078700000878007111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
000700000005700000070007111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
00e5e000005e000000e5ee70111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
0ee5ee000e5ee0000ee5ee00111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccdddddddd
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
11222224111111188144214000012222222441124991491881444422211111114441144111491188842222114441222142222444222400000000000000000000
11111111112441889144214000011222222411111111118884444422211442221111424111111189942222114222222242222244222400000000000000000000
11444411122491899114414000011222221112244111988994444442211442221111221119991189a11221114222222242222244222400000000000000000000
2222441112249189a1144144000112221111222441498899a4411444441142221441221144491889a11111111422222242222222222400000000000000000000
2222224114441889a4111144440112211111222441498899a1111144441442224441221144991889a44111111142122242222222222400000000000000000000
22222441111118ddd4111111100111114441222411498dd77114411111144222224111124111777dd44411141111111242222222222400000000000000000000
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
0808030902090109240903080708060905090424080c0809080a080b2404000807070607050604060305020501240a060907240e00080709060a050b040b030c020d012404020807070606050604050324050707080607240c0d0809090a0a0b0b0c240a000807080609050904090309020a0124080d0809080a080b080c240f
__map__
08082607070606260606030304040505260708010303040405020603060406050603070407050706070508060805090609050c030d040d26050503030404260404030326030301010202260807020007000c00030109010c0104020802090204030503080309030c030504080409040c0406050705080509050c050706080609
0626020201012608060900080207030803070408040904080526060803070407050803090409010c26050801070207030804080109020926070605000501050206020603060406050705260607020502060306040605060507260101000026060503000402050305042608050701090107020902080426050601020203030403
0504052604080007030800092607050600060106030703060407042604050002010302030304260504020003010302040326030801080208260208010826050701060206030604060307040726070406020603070326030401020203260804070009000803260403020103022606040501040205020503260108000826060305
0206022604060105020503052608030801080226070306010702260305000301040204260302020126000826040701060206030602070307260802080126050204000401260203010226070206000701260102000126020401032601030002260503030004010402260001260701070026040103002600022606020501060126
0306020502062604020301260201010026030701060107020726030026030102002608010800260206010501062606010500060026070026050104002602002601050004260205000401042604002605002601060005000626010026000426020700060107260800260107000726000526060026000726000626010400032600
0326000006070708260807260805080708062601030708060705060405030502042605040807070606052600060708060805070407030702070106260106070806080507040703070206260502080707060705060406032603000807070606050604050305020401260407070806080507260804080708060805260007070806
0805080408030702070107260302080707060605050404032603050708060705060406260703080708060705070426030607080607050704072606050807070626070508070706260201080707060605050404030302260002070806070506040503050204010326000407080607050704060306020501052608000807080608
0508040803080208012605080708060826000307080607050604060305020501042602020707060605050404030326030407080607050604052607000807080608050804070307020701260604080707060705260005070806070507040703060206010626080608072601010707060605050404030302022607010807080608
0507040703070226040008070706070506040603050205012604020807070606050604050326050707080607260505070706062605000807070607050704060306020601260206070806070507040703062605060708060726040607080607050726010207080607050604050304020326020807080608050804080308260802
0807080608050804080326050108070706070506040603060226030807080608050804082606060707260107070806080508040703070207260203070806070506040503042603010807070606050504050304022607040807080607052608082601000807070606050504040303020201260608070826020507080607050704
0603062606030807070607050704260303070706060505040426040407070606050526070208070806080507040703260008070806080508040803080208010826060208070706070507040603260707260207070806080508040703072606000807080607050704070307020601260105070806070507040603060206260601
0807080607050704070306022600010708060705060405030402030102260801080708060805080408030802260108070806080508040803080208260401080707060705060405030502260204070806070506040603052605030807070606050604260708260803080708060805080426070608072604030807070606050504
2604080708060805082601040708060705070406030502052604050708060705062602000807070606050504050304020301260307070806080507040726000001010202030304040505060607072c1f1d243509000026180c23350126210c17352c11171a1a1d262c0026002d2d260d170f352c1e1f0c141d262c0026002d2d
2d262c1f1d243501050026180c23350126210c17352c0e0c21102811171a1a1d262c002600260726072d2d260d170f352c1f10181b171028220c1717262c012601260126022d262c012604260126022d262c042601260226012d262c042605260226012d262c012601260226012d262c012605260226012d262c052601260126
022d262c052604260126022d261f10181b17102811171a1a1d262c022603260326012d262c032602260126032d2611171a1a1d281b100f101e1f0c17262c0326032d261f10181b171028220c1717262c012601260126022d262c012604260126022d262c042601260226012d262c042605260226012d262c012601260226012d
262c012605260226012d262c052601260126022d262c052604260126022d261f10181b17102811171a1a1d262c0326032d2d2d262c1f1d243501000026180c23350426210c17352c11171a1a1d262c0026002d262c0026022d260f1a1a1d262c0026012d2d260d170f352c0f201912101a19281e100e1d101f280f1a1a1d262c
0026012d2d2d262c1f1d243501000026180c23350426210c17352c0e0c211028220c1717262c0026012d262c0226012d260e0c21102811171a1a1d262c002600260326012d262c012600260126032d2d260d170f352c0e0c2110281e100e1d101f280f1a1a1d262c0126012d261f1a1d0e13262c0126012d2d2d262c1f1d2435
01000026180c23350126210c17352c211a140f262c002601260826052d26220c1717262c002600260826012d2d260d170f352c0f201912101a1928220c1717262c012600260626042d262c022600260326062d262c002601260826022d262c002601260726032d262c022600260426052d262c012600260726032d260f1a1a1d
262c032600260226042d262c022601260426022d260f201912101a192811171a1a1d262c032601260226022d262c0126022d262c0626012d262c0326042d261f1a1d0e13262c0226002d262c0526002d260f1011281d141912262c0626012d261e1f0c1f2010262c0326042d26220c1f0e13101d262c0126022d2d2d262c1f1d
243501000026180c23350126210c17352c220c1717262c0326012d2611171a1a1d262c0326002d26211a140f262c002602260726062d2d260d170f352c1f10181b171028220c1717262c012602260526062d262c002603260726032d261f10181b17102811171a1a1d262c022603260326022d262c022606260326012d262c03
2601260126062d261f10181b1710280f1a1a1d262c0326022d262c032604260126022d2611171a1a1d281b100f101e1f0c17262c0126042d262c0526042d261f131d1a1910262c0326042d261e1f0c1f2010262c0126042d262c0526042d26220c1f0e13101d262c0326042d2d2d262c1f1d243502000026180c23350126210c
17352c211a140f262c002602260526052d260e0c211028220c1717262c002601260526012d260e0c21102811171a1a1d262c002600260526012d2d260d170f352c0f201912101a1928220c1717262c002601260526062d260e0c211028220c1717262c002601260526032d260e0c21102811171a1a1d262c012603260326012d
262c012601260126032d2611171a1a1d281b100f101e1f0c17262c0126012d262c0326012d260f1a1a1d262c022604260126022d260f201912101a192811171a1a1d262c012605260326012d261e1f0c1f2010262c0126012d262c0326012d261f1a180c130c2216262c0326052d26161a0d1a170f262c0126052d2d2d262c1f
1d243502000026180c23350226210c17352c211a140f262c002602260526012d260e0c211028220c1717262c002601260526012d260e0c21102811171a1a1d262c002600260526012d2d260d170f352c0e0c211028220c1717262c002601260526022d2611171a1a1d281b100f101e1f0c17262c0126012d262c0326012d261e
1f0c1f2010262c0126012d262c0326012d2d2d262c1f1d243501000026180c23350226210c17352c11171a1a1d262c002600260326032d2d260d170f352c1f10181b17102811171a1a1d262c002600260326032d2611171a1a1d281b100f101e1f0c17262c002601260326012d262c012600260126032d261e1f0c1f2010262c
0126012d2d2d2c1e1710101b352c1e350011101717000c1e1710101b38261f3500141e00110c1e1f000c1e1710101b0b261119351e171b28111926103500221a161000201b0b2d260e1a1911201e100f352c1e3500171a1a161e0020191e1f100c0f240b1035001e0021141e141a19000e17100c1d1e2d261e1b100e1f1d0c17
352c1e35000e0c1900220c1716001f131d1a20121300220c17171e0b261119351e1b100e28111926103500141e001e1a17140f000c120c14190b2d261b1a141e1a19352c1e3500171a1a161e001e140e160b261f3500141e0013201d1f000d24001b1a141e1a190b261119351b1e1928111926103500171a1a161e0013100c17
1f1314101d0b2d26130c1e1f10352c1e35001e1b10100f1e00201b0b261035001e171a221e000f1a22190b2d260d1714190f352c1e3500141e000d1714190f38261035000e0c19001e1010000c120c14190b2d261019171412131f1019100f352c1e35000e0c19001e1010001021101d241f131419120b2d261f1a201213352c
1e3500171a1a161e001f1a201213101d0b26103500171a1a161e0021201719101d0c0d17102d2d0509040924060a070924080a080924090f0809080a080b090c090d090e240d0609080a070b070c0724030b07080609050a040a2404050708060705062402000807070606050504050304020301240a09090824040e0809070a
060b060c050d240e0409080a070b060c060d05240307070806080507040724070e0809080a080b070c070d24050b0709060a240a05080709060c150a1c1c170a160e341d12160e1b0c150a1c1c170a160e341a1e0e1e0e24150e17101d11340009240a0f0809080a090b090c090d0a0e240a0709082406050807070624070508
070706240907240201080707060605050404030302240d0a09080a090b090c09240002070806070506040503050204010324050a07080609240b0509070a06240004070806070507040603060205010524010b070806090509040a030a020a240b0809080a0824020d07080609050a040b030c240a0809082408000807080608
0508040803080208012405080708060824000307080607050604060305020501042402020707060605050404030324050c0809070a060b240304070806070506040524030e0809070a060b050c040d240e0c09080a090b0a0c0a0d0b24040907080608050924070c0809080a070b240700080708060805080407030702070124
__sfx__
010124010e1730a1730777306773057730a0732240321403204031f4031c2031e203202032320324203262032820328203222031320319403016030400303003020030b003084030900309403090030a4030a003
010d240103410066200161001100011000710006100051001a10015100131020b100132002320024200262002820028200222001320019400016000400003000020020b000084000900009400090000a4000a000
000208060c03002620026501b5500665006000155020c400090000a0000b4002440008400080000840008000080020c00008400090000a4000a0000b400240000640007002034000700006000054000440024400
012000000f072070720f072110720e072060720f002050020e0020500210502050020c00207102010020100202002010020100201002010020150201502174021740215402134021240213402124021340209002
0107240a036110c0710c07104001040010f0010400104001036110c0710c0710f0010f0010f001060010a001036110c0710c0710e0010700108001080010700124001080010c0010800109001090010a0010b001
01140000096110b111091000d61109111091010a6110960105101041010c60102201012010d60102701017010f60103401034010440106101071010c1010d1012410102101071010610105101041010310102101
001000000136503205052053f2053f205222052220502205022050220504205022050320501205012050e20524205042050820507205072050620505205012050220502205022050120501205012050220504205
0107080702007376273432734327343272d627353272a627126073a507125070f007090070a0070b0070c0070d0070e007050070700706007240070e007090070a0070b0070c0070d00704007070070600705007
012400003f2650d000090000a0000b0000c000244000940008000090020a4000840009000094000900024400094000800008400080000940009000090020b40008400090000a4000a00024000084000800008400
0105000003220032200222004220052200b2000920008200082000820009200092000620008200072002420003200072000620005200042000f200092000a2000b2000c2000d2000e20024200032000720006200
0110000005120016230110001603016030840324003044030700306403050030c403090030a0030b403240030c003094030a4030b003070030840308003084030700307403244030740308003084030700307003
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

