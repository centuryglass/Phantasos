pico-8 cartridge // http://www.pico-8.com
version 10
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
 function log(af)printh(af,"log",not vj)vj=true end function always_true()return true end function always_nil()end kb="0123456789-.abcdefghijklmnopqrstuvwxyz,;_:(){}[]<>/?+=*|!#%&@$^"id={}for i=1,#kb do local c,n=sub(kb,i,i),i-1 id[n],id[c]=c,n end function fj(addr,len)local str=""for i=addr,addr+len-1 do str=str..id[peek(i)]end return str end function of(str)if wb(str)and#str>0 and#str<6 then for i=1,#str do local tf=id[sub(str,i,i)]
if(not tf or tf>11)return
end return true end end function xf(str)if sub(str,1,1)=="{"and sub(str,#str)=="}"then return sd(sub(str,2,#str-1))end 
if(of(str))str+=0
if(str=="false")return false
if(str=="nil")return nil
return(str=="true")and true or(str=="always_nil")and always_nil or(str=="always_true")and always_true or(str=="{}")and{}or kk[str]or str end function sd(str,tab)
if(not wb(str))return str
local i,kg,tab,val=0,"",tab or{},"null"local key,c while#str>0 do c,str=sub(str,1,1),sub(str,2)if c==","then 
if(#kg>0)val=kg
elseif c=="="then key,kg=xf(kg),""elseif c=="{"then local qe=1 for i=1,#str do local c2=sub(str,i,i)
qe+=(c2=="{"and 1 or c2=="}"and-1 or 0)
if qe==0 then val,str=c..sub(str,1,i),sub(str,i+1)break end end else kg=kg..c end 
if(#str==0 and#kg>0 and val=="null")val=kg
if val!="null"then val=xf(val)if key then tab[key]=val else add(tab,val)end key,val,kg=nil,"null",""end end if tab.addr then return sd(fj(pc(tab.addr),pc(tab.len)))end return tab end function pc(nf)return("0x"..nf)+0 end function je(str)local td,pi,jf,ee={},{},point(8,8),sd"{1,1},{-1,1},{1,-1},{-1,-1}"str=sd(str)foreach(str,function(ui)foreach(ee,function(q)local ag,nf={},""..ui 
if(#nf%2==1)nf="0"..nf
function fc()local rf=pc(sub(nf,1,1))nf=sub(nf,2)return rf end while#nf>1 do local pt=(point(fc(),fc())-jf)*point(xj(q))+jf if pt.x<16 and pt.y<16 then add(ag,pt)elseif#ag==0 then return end end local key=#ag[1]if not pi[key]then add(td,ag)pi[key]=true end end)end)return td end function ob(fn)local ub=cocreate(fn)ad(ub)coresume(ub)end function fb(co,gf)local n=#co for i=1,n do local ub=-co if costatus(ub)=="suspended"then coresume(ub)co(ub)
if(not gf)return true
end end 
if(gf and#co>0)return true
end function wb(bc)return type(bc)=="string"end function vi(bc)return type(bc)=="table"end function xj(t,index)t,index=sd(t),sd(index)or 1 local key=index if vi(index)then key=index[1]
if(#index==0)return
del(index,key)else 
index+=1
if(key>#t)return
end return t[key],xj(t,index)end function kd(og,fn)for k,v in pairs(og)do 
if(fn(v,k))return true
end end function foreach(og,fn)for i in all(og)do 
if(fn(i))return true
end end function rg(ik,a,b,c,d,e,f)assert(not f)local arr={a,b,c,d,e}if vi(ik)then foreach(ik,function(v)add(arr,v)end)else add(arr,ik)end return xj(arr)end function round(val)return flr(val)+(val%1>0.5 and 1 or 0)end function jb(wc,hc)hc,wc=hc or{},wb(wc)and sd(wc)or wc if wc then kd(wc,function(v,k)hc[k]=v end)end return hc end function hg(t,v)return kd(t,function(val)
if(val==v)return true
end)end function wg(yg,vb)vb=vb or 1 return vb+flr(rnd(1+yg-vb))end function rk(e)e=e.pos or e return lb>e and you:can_see(e)end function ci(p)return(p-lb)*8 end function fd(og,fn)
if(not og)return true
return og and kd(og,function(v,k)if rnd(1000)<v+j*k.flr_mult then 
if(fn(k))return true
end end)end function ef(n1,n2)return(n1+n2)%1000 end function g(n1,n2)
if(abs(n1-n2)>500)return n2<n1
return n1<n2 end function tj(n1,n2)return n1==n2 or g(n1,n2)end function pj(f)
if(hb)return
f=f or ok ve=ve and(g(ve,f)and f or ve)or f end function fk()
if(nk)return
nk=true if hf<oi then p=oe(function(p,t)return t.spawn_table and not(lb>p)and not ei(p)end)if p then fd(qi(p).spawn_table,function(class)class(p)return true end)end end wf(function(e)if e.take_turn and tj(e.turn,turn)then e:take_turn()e.turn=ef(turn,1)end end)end function lk(t,n,fn)mg(cocreate(function()while turn!=ef(t,n)and n!=0 do 
if(tj(t,turn))fn()n-=1
yield()end end))end function qd(target,duration,qf,jc,ec,eg,bj)
if(rk(target))sh(target,ec)
lk(turn,duration,function()
if(target.hp<=0)return
if(rk(target))sh(target,eg)
qf()end)lk(ef(turn,duration),1,function()
if(target.hp<=0)return
if(rk(target))sh(target,bj)
jc()end)end function poison(target)qd(target,wg(9,5),
function()target-=1 end,nil,
nil," is hurt by poison."," recovers from poison.")end function sleep(target)
if(target==you)vk=zh
target.gi=true qd(target,wg(10,8),
function()target+=1 end,
function()
if(target==you)vk=jd
target.gi=false end," fell asleep."," is fast asleep."," woke up!.")end function use(itm,c)if itm.use then local fx=itm.use_sfx 
if(c==you)msg(itm.use_msg)ue()
if(fx and rk(c))sfx(fx)
itm:use(c)if itm.qty then itm:dk(-1)end fk()return true end end kc,kk={},{}kc.class={kc}function kc:ld(ti)local pg={}setmetatable(pg,self.me)pg:tc(ti)return pg end function kc:sc(ti)local sc={}
if(#ti==2)ti=fj(ti[1],ti[2])
sc.xi={__index=self,__call=function(pb,ti)return sc:ld(ti)end,__lt=function(pb,x)return vi(x)and x.xd and hg(x.xd,pb)end}setmetatable(sc,sc.xi)sc.me=jb(self.me)sc.me.__index,sc.xd=sc,jb(self.xd)add(sc.xd,sc)jb(ti,sc)kk[sc.classname]=sc return sc end function kc:class()return self.xd[#self.xd]end function kc:tc(ti)jb(ti,self)end timer=kc:sc"classname=timer"timer.me.__call=function(self)if time()-self.start>.03 then yield()self.start=time()end end function timer:tc()self.start=time()end queue=kc:sc"classname=queue,length=0"jb({__unm=function(self)return self:hk()end,__call=function(self,n)self:ih(n)return self end,__len=function(self)return self.length end},queue.me)function queue:tc()self.values={}end function queue:ih(v)
if(v)self.length+=1 self.values[#self]=v
end function queue:get(i)
if(i<=#self)return self.values[i]
end function queue:hk()local be=self:get(1)if be then for i=2,#self do self.values[i-1],self.values[i]=self:get(i),nil end 
self.length-=1
return be end end function queue:clear()jb("values={},length=0",self)end stack=queue:sc"classname=stack"function stack:hk()local ze=self:get(#self)if ze then self.values[#self]=nil 
self.length-=1
return ze end end p_queue=queue:sc"classname=p_queue"p_queue.me.__call=function(self,v,p)self:ih(v,p)end function p_queue:ih(bc,p)local yf={value=bc,yj=p}
self.length+=1
for i=1,#self do local ij=self:get(i)if not ij or yf.yj<ij.yj then yf,self.values[i]=ij,yf end end end function p_queue:hk()local be=queue.hk(self)return be and be.value end rnd_queue=queue:sc"classname=rnd_queue"function rnd_queue:hk()
if(#self<1)return
val=self:get(wg(#self))del(self.values,val)
self.length-=1
return val end point=kc:sc"classname=point,x=0,y=0"point.xi.__call=function(self,x,y)return point:ld()(x,y)end jb({__call=function(self,x,y)if wb(x)then sd(x,self)elseif point<x then self(x:nj())else self.x,self.y=round(x),round(y)end return self end,__add=function(zi,hj)return point(zi.x+hj.x,zi.y+hj.y)end,__sub=function(zi,hj)return point(zi.x-hj.x,zi.y-hj.y)end,__mul=function(pt,n)local x,y=n,n 
if(point<n)x,y=n:nj()
return point(pt.x*x,pt.y*y)end,__div=function(pt,n)return pt*(1/n)end,__unm=function(pt)return point(pt)end,__eq=function(zi,hj)return zi.x==hj.x and zi.y==hj.y end,__len=function(pt)return pt:gg()end,__lt=function(pt,r)return rectangle(pt)<r end},point.me)function point:move(d,n)n=n or 1 local ax=d<2 and"x"or"y"
if(d%2==0)n*=-1
self[ax]+=n
return self end function point:md(p2)local ay,ax=(p2-self):nj()ay,ax=abs(ay),abs(ax)return max(ay,ax)+min(ay,ax)/2 end function point:uc(mi,xe)
if(xe==0)return-self
mi,xe=mi or point(0,0),xe or 1 local vg=self-mi vg(-vg.y,vg.x)
vg+=mi
return vg:uc(mi,xe-1)end function point:nj()return self.x,self.y end function point:gg()return"x="..self.x..",".."y="..self.y end rectangle=point:sc("classname=rectangle")rectangle.xi.__call=function(self,x,y,w,h)return self:ld()(x,y,w,h)end jb({__call=function(self,a,b,c,d)
if(not a)return self"0,0,1,1"
if(wb(a))return self(xj(a))
if rectangle<a then jb(a,self)elseif point<a then local w,h=1,1 if point<b then w,h=(b-a):nj()elseif c then w,h=b,c end self(a.x,a.y,w,h)else self.x,self.y,self.w,self.h=a,b,c,d end return self end,__add=function(r,pt)local r2=-r 
r2.x+=pt.x
r2.y+=pt.y
return r2 end,__sub=function(r,pt)local r2=-r 
r2.x-=pt.x
r2.y-=pt.y
return r2 end,__mul=function(r,n)local r2=-r 
r2.w*=n
r2.h*=n
return r2 end,__div=function(r,n)return r*(1/n)end,__eq=function(r1,r2)return r1:p1()==r2:p1()and r1:p2()==r2:p2()end,__len=function(r)return r.w*r.h end,__lt=function(r1,r2)return r1.x+r1.w<=r2.x+r2.w and r1.y+r1.h<=r2.y+r2.h and r1.x>=r2.x and r1.y>=r2.y end,__unm=function(r)return rectangle(r)end},rectangle.me)function rectangle:expand(n,d)n=n or 1 if d then local xy,wh=d%2==0,d<=1 and"w"or"h"if xy then if wh=="w"then 
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
end return self end function rectangle:uc(mi,xe)xe=xe or 1 local r=-self 
if(xe==0)return self
r.w,r.h=r.h,r.w r.x,r.y=r:p1():uc(mi):nj()
r.x-=r.w-1
return r:uc(mi,xe-1)end function rectangle:p1()return point(self:nj())end function rectangle:p2()return point(self.w,self.h)+self end function rectangle:z()return self.x,self.y,self:p2():nj()end function rectangle:gg()return#self:p1()..","..#self:p2()end function yi()cf,tk,th,oh={},{},rectangle"0,0,30,30",rectangle"1,1,28,28"nb(function(p)cf[#p]=void end)end function ni(p)return oh>p end function qi(p)return cf[#p]end function ug(p,t)if th>p then t.kf=qi(p).kf cf[#p]=t end end function nd(e)local key=#e.pos if tk[key]then add(tk[key],e)else tk[key]={e}end 
if(e.qc)e:qc()
if(creature<e)hf+=1
if(lb>e.pos)pj()
end function ei(pos)return tk[#pos]end function jg(pos)for e in all(tk[#pos])do 
if(creature<e)return e
end end function ib(e,fg)if e.pos then local key=#e.pos if tk[key]then del(tk[key],e)
if(#tk[key]==0)tk[key]=nil
if(creature<e)hf-=1
if(lb>e.pos)pj()
if not fg then 
if(e.ye)e:ye()
if(e!=you)e.pos=nil
end end end end function ri(e,pos)ib(e,true)e.pos(pos)nd(e)end function nc(r,type)type=type or void local zf=true gc(function(p,t)
if(not(type<t))zf=false return true
end,r)return zf end function nb(fn,uh)uh=uh or th for y=uh.y,uh.y+uh.h-1 do for x=uh.x,uh.x+uh.w-1 do 
if(fn(point(x,y)))return true
end end end function gc(fn,uh)nb(function(p)local t=qi(p)
if(t and fn(p,t))return true
end,uh)end function wf(fn,uh)local lf={}function cc(arr)foreach(arr,function(e)add(lf,e)end)end if uh then nb(function(p)cc(ei(p))end,uh)else kd(tk,cc)end return foreach(lf,fn)end function vh(pos,fn,yh,fh)local vd=rectangle(pos):expand(1)gc(function(p,t)
if(p!=pos or fh)
and(not yh or p.x==pos.x or p.y==pos.y)then return fn(p,t)end end,vd)end function wi(p1,p2,cd)local jf=point(8,8)-p1 local rel=p2+jf 
if(not vf[#rel])return p1
for di in all(vf[#rel])do 
di-=jf
local t=qi(di)
if(t and t.solid)return di
if(cd and jg(di))return di
end end function los(p1,p2)return not wi(p1,p2)end function sj(pos,class,yh)local dd=0 vh(pos,function(p,t)if class<t then 
dd+=1
end end,yh)return dd end function qg(wc,hc,bg,range)local mf,yc,uf,gh,bg,range,sk,qk={[#wc]={ic=0,yj=0}},p_queue(),999,timer(),bg or function(pos,tile)
if(not tile.solid)return 0
end,range or 0 yc(#wc,0)while#yc>0 do gh()local ud=-yc if point(ud):md(hc)<uf+5 and stat(0)<1000 then vh(point(ud),function(p,t)local eh,ic,l=#p,mf[ud].ic+1,p:md(hc)local yj=l<=range and 0 or(not mf[eh]or mf[eh].ic>ic)and l<=uf+5 and bg(p,t,hc,ic,mf,ud)if yj then mf[eh]={ic=ic,kj=ud}
if(l<uf)uf,sk=l,eh
if l<=range then qk=eh return true end 
yj+=l+ic
yc(eh,yj)end end,true)
if(qk)yc:clear()
end end local path,i=stack(),qk or sk while i and mf[i].kj do path(point(i))i=mf[i].kj end return#path>0 and path end function hd(r,class)nb(function(p)ug(p,class())end,r)end function oe(he)he=he or function(p,t)return not t.solid and not ei(p)end local ff=rnd_queue()for i=1,784 do ff("x="..(i%28+1)..",y="..flr(i/28+1))end while#ff>0 do local pos=point(-ff)
if(he(pos,qi(pos)))return pos
end end function uk(e,wc,hc,oj)hc=wi(wc,hc,true)or hc local pf,jf=ci(wc),(hc-wc)*2 sf(cocreate(function()for i=1,4 do 
pf+=jf
e:draw(pf)yield()end 
if(oj)oj(hc)
end))end entity=kc:sc"classname=entity,name=entity,color=8,sprite=93,flr_mult=0"function entity:tc(pos)if pos then self.pos=point(pos)nd(self)end end function entity:can_see(pos)local t,p=qi(pos),self.pos return pos==p or(p:md(pos)<=self.sight_rad or t.kf)and los(p,pos)end function entity:draw(pf)pf=pf or ci(self.pos)
if(self.ai)pal(12,self.ai)
spr(self.ah or self.sprite,pf:nj())pal()local weapon=self.hi and self.hi.weapon 
if(weapon)weapon:draw(pf+point(2,0))
if self.ah then pj(ef(ok,8))self.ah=nil end end item=entity:sc"classname=item,sprite=108,name=item,qty=1,throw_sfx=6"function item:tc(ti)if creature<ti then ti:take(self)elseif point<ti then entity.tc(self,ti)end if self:class()<ti then jb(ti,self)self.ie,self.pos=nil end end function item:dk(qty)
self.qty+=qty
if self.qty<=0 then if self.ie then del(self.ie.pe,self)end ib(self)self.ie,self.pos=nil end end meat=item:sc"classname=meat,sprite=70,name=meat,color=14,hp_boost=5,flr_mult=3,use_msg=you feel much better.,use_sfx=5"function meat:use(c)
c+=self.hp_boost
end apple=meat:sc"classname=apple,sprite=71,name=apple,color=8,hp_boost=3,use_msg=you feel a bit better.,flr_mult=-1"bread=meat:sc"classname=bread,sprite=72,name=bread,color=8,hp_boost=6,flr_mult=3"statue=item:sc"classname=statue,sprite=74,name=statue,color=10"function statue:qc()qi(self.pos).solid=true end function statue:ye()local t=qi(self.pos)t.solid=t:class().solid end color_coded_itm=item:sc"classname=color_coded_itm"function color_coded_itm:si()self.ki,self.od=#self.names,{}local od=rnd_queue()kd(self.colors,function(v,k)od{name=v.." "..self.classname,color=k}end)for i=1,self.ki do local type=-od type.gd,type.use_msg,self.od[i]=self.names[i].." "..self.classname,self.messages[i],type end end function color_coded_itm:tc(ti)item.tc(self,ti)if not self.type then self.type=wg(self.ki)local type=self.od[self.type]self.name,self.use_msg,self.ai=type.name,type.use_msg,type.color end end function color_coded_itm:use(c)local od=self:class().od local type=od[self.type]local name,gd=self.name,type.gd if rk(c)and name!=gd then function lj(i)
if(i.name==name)i.name=gd
end lj(type)wf(function(e)lj(e)if e.pe then foreach(e.pe,function(i)lj(i)end)end end)msg("that was a "..gd)end self:rj(c)end potion=color_coded_itm:sc"classname=potion,sprite=65,color=13,use_sfx=4,throw_sfx=7,flr_mult=3,names={1=healing,2=vision,3=poison,4=wisdom,5=sleep,6=lethe,7=water,8=juice,9=spectral,10=toughness,11=blindness},messages={1=you are healed,2=you see everything!,3=you feel sick,4=you feel more experienced,5=you fell asleep,6=where are you?,7=refreshing!,8=yum,9=you feel ghostly,10=nothing can hurt you now!,11=who turned out the lights?},colors={0=murky,1=viscous,2=fizzing,3=grassy,4=umber,5=ashen,6=smoking,7=milky,8=bloody,9=orange,10=glowing,11=lime,12=sky,13=reeking,14=fragrant,15=bland}"potion:si()function potion:rj(c)local type,ge,ii=self.type,c==you,wg(10,4)
if(type==1)c.hp=c.hp_max
if type==2 then 
if(ge)we=true
c.can_see=always_true qd(c,wg(5,2),nil,function()c.can_see=nil we=false end,"'s perception expands.",nil,"'s vision returns to normal")end 
if(type==3)poison(c)
if(type==4)c.exp=flr((c.exp+10)*1.5)
if(type==5)sleep(c)
if type==6 then 
if(not ge)return
gc(function(p,t)t.dj=nil end)end 
if(type==8)c+=2
if type==9 then c.spectral=true local start,duration=turn,wg(20,10)qd(c,duration,function()
if(turn==ef(start,duration-3))sh(c," is fading back.")
end,function()c.spectral=nil if qi(c.pos).solid then sh(c," is stuck in a wall!")
c-=999
end end," can walk through walls.",nil," is solid again.")end if type==10 then 
c.ac+=999
qd(c,wg(7,3),
nil,function()c.ac-=999 end,
" is invincible!",nil," looks vulnerable.")end if type==11 then c.can_see=always_nil qd(c,wg(12,8),nil,function()c.can_see=nil end," is blind!",nil," can see again.")end end function potion:oc(pos)sh(self," shatters!")vh(pos,function(p,t)local c=jg(p)
if(c)self:use(c)
self.sprite=60 sf(cocreate(function()for i=1,3 do self:draw(ci(p))yield()end end))end,false,true)ib(self)end mushroom=color_coded_itm:sc"classname=mushroom,sprite=67,use_sfx=5,color=4,names={1=tasty,2=disgusting,3=deathcap,4=magic},messages={1=that was delicious,2=that was awful,3=you feel deathly ill,4=look at the colors!},colors={1=speckled,3=moldy,6=chrome,8=bleeding,14=lovely,15=fleshy}"mushroom:si()function mushroom:rj(c)local type=self.type 
if(type==1)c+=10
if(type==2)c-=1
if(type==3)c.hp=1
if type==4 then c.fe=true qd(c,wg(15,4),nil,function()c.fe=false end," looks unsteady.",nil,"'s vision clears.")end end scroll=color_coded_itm:sc"classname=scroll,sprite=66,use_sfx=3,flr_mult=2,names={1=movement,2=wealth,3=summoning},messages={1=you are somewhere else,2=riches appear around you,3=you have company!},colors={0=filthy,1=denim,4=tattered,6=faded,8=ominous}"scroll:si()function scroll:rj(c)local type=self.type local ch 
if(type==1)ri(c,oe(nil,-1))
if(type==2)ch="item_table"
if(type==3)ch="spawn_table"
if ch then vh(c.pos,function(p,t)while not fd(t[ch],function(class)if class!=scroll then class(p)return true end end)do end end)end end equipment=item:sc"classname=equipment,bonuses={hitbonus=1}"function equipment:equip(c)local equip_slot,itm=self.equip_slot,c:drop(self,1,point(99,99))local hi=c.hi[equip_slot]
if(hi)hi:remove()
kd(self.bonuses,function(v,k)
c[k]+=v
end)ib(itm)c.hi[equip_slot],itm.ie=itm,c end function equipment:remove()local ie=self.ie ie.hi[self.equip_slot]=nil kd(self.bonuses,function(v,k)
ie[k]-=v
end)ie:drop(self)ie:take(self)end torch=equipment:sc"classname=torch,sprite=64,name=torch,sight_rad=4,color=10,equip_slot=weapon,bonuses={sight_rad=1,dmin_boost=1,dmax_boost=1}"function torch:se(fn)local ke=rectangle(self.pos):expand(self.sight_rad)gc(function(p,t)if p:md(self.pos)<self.sight_rad and los(self.pos,p)then fn(p,t)end end,ke)end function torch:qc()self:se(function(p,t)if not(void<t)then t.kf=t.kf and t.kf+1 or 1 end end)end function torch:ye()self:se(function(p,t)
if(t.kf)t.kf-=1
if(t.kf==0)t.kf=nil
end)end knife=equipment:sc"classname=knife,sprite=68,name=knife,color=6,equip_slot=weapon,throw_sfx=8,dthrown=4,flr_mult=5,bonuses={hit_boost=5,dmin_boost=1,dmax_boost=2}"sword=knife:sc"classname=sword,sprite=69,name=sword,color=6,equip_slot=weapon,dthrown=3,flr_mult=1,bonuses={hit_boost=-10,dmin_boost=3,dmax_boost=6}"tomahawk=knife:sc"classname=tomahawk,sprite=73,name=tomahawk,equip_slot=weapon,dthrown=8,flr_mult=1,bonuses={hit_boost=5,dmin_boost=1,dmax_boost=1}"plate_armor=equipment:sc"classname=plate_armor,sprite=75,name=plate armor,equip_slot=armor,flr_mult=1,bonuses={ac=3}"leather_armor=equipment:sc"classname=leather_armor,sprite=76,name=leather armor,equip_slot=armor,flr_mult=2,bonuses={ac=1}"spiked_armor=equipment:sc"classname=spiked_armor,sprite=77,name=spiked armor,equip_slot=armor,flr_mult=2,bonuses={ac=2,dmin_boost=2}"warded_armor=equipment:sc"classname=warded_armor,sprite=78,name=warded armor,equip_slot=armor,flr_mult=1,bonuses={ac=6}"ring=equipment:sc"classname=ring,sprite=80,name=ring,equip_slot=rings,flr_mult=5,bonuses={ac=1}"creature=entity:sc"classname=creature,sight_rad=4,hp_max=10,exp=2,hitrate=75,min_dmg=0,max_dmg=4,ac=0,dmax_boost=0,dmin_boost=0,hit_boost=0"jb({__add=function(self,x)self:le(x)return self end,__sub=function(self,x)self:le(-x)return self end},creature.me)function creature:tc(ti)entity.tc(self,ti)self.hp,self.turn,self.pe,self.hi=self.hp_max,turn,{},{}
if(self.item_table)self:wj()
end function creature:wj()fd(self.item_table,function(class)local itm=class(self)
if(equipment<itm)itm:equip(self)
end)end function creature:take_turn()if not self.gi and self.pos then function jk()self:take_turn()end local cj,target,guard_pos,sight_rad,path,dest=xj(self,"pos,target,guard_pos,sight_rad,path")if not target and self.bi!=turn and self:can_see(you.pos)and cj:md(you.pos)<sight_rad then self.target=you return jk()end dest=target and target.pos or guard_pos if target and(target.hp<=0 or not self:can_see(dest)and cj:md(dest)>2)then self.target,self.bi=nil,turn return jk()end if dest then local mk=cj:md(dest)if not path or mk<2 and cj:md(path:get(1))>mk and cj!=dest then self.path=qg(cj,dest)end end local d 
if(not(self.path or guard_pos))d=wg(3,0)
self:move(d)end end function creature:zg(c2)return target==c2 or not(self:class()<c2)end function creature:take(itm)for i in all(self.pe)do 
if(i.name==itm.name)then
ib(itm)i:dk(itm.qty)return end end if#self.pe==7 then 
if(self==you)msg"you can't carry any more."
else ib(itm)itm.pos,itm.ie=nil,self add(self.pe,itm)end end function creature:drop(itm,qty,pos)qty=qty or itm.qty pos=pos or self.pos itm:dk(-qty)for e in all(ei(pos))do 
if(e.name==itm.name)e:dk(qty)return e
end local wd=itm.qty>0 and itm:class()()or itm jb(itm,wd)wd.qty,wd.pos,wd.ie=qty,-pos,nil nd(wd)return wd end function creature:move(d)local path=self.path if d or path then local pf=d and point(self.pos):move(d)or-path local dest,bf=qi(pf),jg(pf)if dest and ni(pf)and not bf and(not dest.solid or self.spectral)then 
if(not self.ah and lb>self.pos)self.ah=self.sprite+1
ri(self,pf)
if(rk(self))sfx(0)
else if bf and self:zg(bf)then self:aj(bf)end self.path=nil end 
if(dest and dest.te)dest:te(self)
if(path and#path==0)self.path=nil
end end function creature:le(n)self.hp=min(self.hp_max,self.hp+n)if self.hp<=0 then foreach(self.pe,function(itm)self:drop(itm)end)kd(self.hi,function(itm)self:drop(itm)end)sh(self," died.")ib(self)end end function creature:aj(c2,dmg,hitrate)dmg,hitrate=dmg or max(0,wg(self.max_dmg+self.dmax_boost,self.min_dmg+self.dmin_boost)-c2.ac),hitrate or self.hitrate+self.hit_boost 
if(not self.ah and lb>self.pos)self.ah=self.sprite+2
local fx function rb(ng,xh)sh(self,ng..c2.name..xh)end if wg(100)>hitrate then rb(" missed ","!")fx=1 else c2.target=c1 fx=2 if dmg==0 then rb(" barely hits ",".")return else rb(" hit "," for "..dmg.." damage.")if dmg>=c2.hp then 
if(self==you)kills+=1
self.exp+=c2.exp
end end 
c2-=dmg
end 
if(fx and rk(self))sfx(fx)
end rat=creature:sc"classname=rat,name=rat,sprite=144,hp_max=5,sight_rad=6,flr_mult=-10,item_table={meat=200,knife=10}"kobold=rat:sc"classname=kobold,name=kobold,sprite=131,hp_max=8,exp=4,min_dmg=1,max_dmg=5,ac=1,flr_mult=10,item_table={torch=600,apple=200,knife=400,leather_armor=100}"mantid=rat:sc"classname=mantid,name=mantid,sprite=147,hp_max=12,hitrate=60,min_dmg=6,max_dmg=9,exp=10,flr_mult=10,item_table={potion=800,meat=500}"watcher=mantid:sc"classname=watcher,name=watcher,sight_rad=10,sprite=176,hp_max=20,hitrate=95,min_dmg=3,max_dmg=6,ac=3,exp=20,flr_mult=2,item_table={knife=500,sword=1000,bread=800,potion=400,spiked_armor=200}"function watcher:tc(ti)creature.tc(self,ti)self.guard_pos=-self.pos end player=creature:sc"classname=player,name=rogue,color=7,sprite=128,hp_max=10,hitrate=85,min_dmg=1,max_dmg=5,take_turn=always_nil,item_table={bread=1000,apple=800,meat=200,torch=1000,potion=500,scroll=500}"function player:move(d)
if(not nk)creature.move(self,d)
fk()end tile=kc:sc"classname=tile,solid=true,sprite=nil,color=2"function tile:tc()
if(self.alt_sprite and rnd(100)<5)self.sprite=self.alt_sprite
end function xc()gc(function(p,t)fd(t.item_table,function(class)class(p)return true end)end)end void=tile:sc"classname=void,sprite=62"function void:ld()return self end floor=tile:sc"classname=floor,solid=false,sprite=19,alt_sprite=20,color=4"wall=tile:sc"classname=wall,sprite=16,alt_sprite=17,color=6"dungeon_floor=floor:sc"classname=dungeon_floor,item_table={knife=1,potion=2,scroll=2,mushroom=2,bread=1,plate_armor=0,leather_armor=-2},spawn_table={rat=100,kobold=200,mantid=0,watcher=-20}"dungeon_wall=wall:sc"classname=dungeon_wall"cave_floor=floor:sc"classname=cave_floor,sprite=3,alt_sprite=4,color=0,item_table={torch=20,apple=10,mushroom=50,potion=5,leather_armor=2},spawn_table={rat=400,mantid=-20,kobold=-2}"cave_wall=wall:sc"classname=cave_wall,sprite=0,alt_sprite=1,color=1"temple_floor=floor:sc"classname=temple_floor,sprite=35,alt_sprite=36,color=11,item_table={knife=20,tomahawk=0,sword=0,potion=30,scroll=30,ring=1,spiked_armor=0,warded_armor=-4},spawn_table={kobold=900,mantid=500,watcher=0}"throne=floor:sc"classname=throne,sprite=34,color=11"floor_pedestal=floor:sc"classname=floor_pedestal,sprite=18,color=6"temple_wall=wall:sc"classname=temple_wall,sprite=32,alt_sprite=33,color=12"door=tile:sc"classname=door,sprite=21,color=9,use_sfx=9"function door:te(li)
if(self.solid)use(self,li.pos)
end function door:use()local ji=self.solid and 1 or-1 self.solid=not self.solid 
self.use_sfx+=ji
self.sprite+=ji
self.color+=ji
end temple_door=door:sc"classname=temple_door,sprite=37"cave_secret_door=door:sc"classname=cave_secret_door,sprite=7"dungeon_secret_door=door:sc"classname=dungeon_secret_door,sprite=23"temple_secret_door=door:sc"classname=temple_secret_door,sprite=39"up_stair=tile:sc"classname=up_stair,sprite=5,color=13,solid=false"function up_stair:use()msg"you're not going back"end stair=tile:sc"classname=stair,sprite=6,color=13,solid=false"function stair:use()if qi(you.pos)==self then yi()
j+=1
hf=0 kd(kk,function(cl)if rat<cl then 
cl.hp_max+=2
cl.min_dmg+=1
cl.max_dmg+=1
cl.ai=j end end)gb,hb=point(you.pos),true nd(you)mj()fi()else msg"move closer to descend"end end function fi()local lg=sd"addr=264e,len=634"local jj,range,jh=100-#lg,4,timer()vk,hb,re,rh,hh,bd=df,xj"true,0,0,cave_wall,cave_floor"ob(function()while re<jj do jh()local tb=re>55-j if tb then hh,bd,range=dungeon_wall,dungeon_floor,0 end if ed then while#ed>0 do gb=-ed local t=qi(gb)if t.solid and not(door<t)then if t.gj and sj(gb,floor,false)>1 then ug(gb,door())wf(function(e)ib(e)end,rectangle(gb))else ug(gb,bd())end 
rh+=zb(gb)
end end re,ed=min(jj,flr(rh/#th*(120+j*10))),nil else ne=rectangle()*(tb and 4 or wg(4))if tb then local pos=oe(function(p)return nc(ne+p)and ni(ne+p)end)
if(not pos)re=jj break
ne+=pos
for d=1,4 do local mc=rectangle(ne)while(nc(mc)and th>mc and rnd(10)<7)do ne(mc)mc:expand(1,d)end end hd(ne,hh)
rh+=#ne
ne:expand(-1)hd(ne,bd)ne:expand(1)else 
ne+=gb
end gc(function(p,t)if tb then 
if(sj(p,bd)==1 or not ni(p))t.fixed=true
if(dungeon_wall<t)t.gj=true
if(not t.kf)torch(p)
else if p:md(gb)<=ne.w/2 then ug(p,cave_floor())
rh+=(1+zb(p))
end end end,ne)ed=re<jj and qg(gb,tb and(point(wg(ne.w-2,1),wg(ne.h-2,1))+ne)or oe(always_true),function(p,t,hc)
if(t.fixed or not ni(p))return
return(t.gj and 40 or 0)+((t and t.solid or door<t)and(tg and(5+sj(p,floor)*2)or 10-sj(p,floor)*2+rnd(4))or 0)end,range)end end gc(function(p,t)if door<t and sj(p,door,true)>0 then ug(p,sj(p,wall,true)>1 and dungeon_floor()or dungeon_wall())end end)for i=1,#lg do local ig=lg[i]
if(wb(ig))log(ig)
local ck,dc,class=ig.try,ig.max oe(function(p,t)
ck-=1
if(ck<1)return true
jh()for vg=0,3 do function lh(og,fn)return foreach(og,function(k)if tile<k or entity<k then class=k else k=(#k==4 and rectangle or point)(xj(k))k=(k+p):uc(p,vg)return fn(k,class)end end)end if not lh(ig.val,function(pos,class)return not ni(pos)or not(rectangle<pos)and not(class<qi(pos))or pos.w and not nc(pos,class)end)then lh(ig.bld,function(pos,class)if tile<class then if pos.w then hd(pos,class)else ug(pos,class())end elseif entity<class then class(pos)end end)
dc-=1
if(dc<1)return true
end end end)
re+=1
end ug(you.pos,up_stair())xc()hb,ej,re=xj"false,false,100"return end)end function zb(p)local qb=0 vh(p,function(p,t)if void<t or not ni(p)then ug(p,hh())
qb+=1
end end)return qb end function rd(ae,ce)ue()kh,sg,zj,vk={sprite=28,pos=-you.pos,draw=entity.draw},ae,ce or lb,rc pj()end function bk()kh=nil pj()
if(vk==rc)vk=jd
end function pk(r)
if(wb(r))r=rectangle(r)
rectfill(rg(4,r:z()))rectfill(rg(2,(-r):expand(-1):z()))end msg=queue()function sh(e,oj,pre)if rk(e)and(pre or oj)then pre,oj=pre or"",oj or""msg(pre..e.name..oj)end end function qh()msg.ze,msg.yd=msg.yd or msg.ze,(#msg>0)and-msg end menu=stack:sc"classname=menu,index=1,turn_modded=0"bh=stack()function menu:tc()stack.tc(self)self.pos=rectangle"5,25,4,12"end function mj()dh=-bh pj()
if(not dh and vk==zd)vk=jd
end function ue()while dh do mj()end end function menu:add(name,op,vc)self{name=name,op=op,turn=vc}end function menu:ak()
if(self.xg)self:xg()
if#self>0 then bh(dh)dh=self vk=zd end pj()end function menu:draw()local pos,w=self.pos,0 foreach(self.values,function(v)w=max(w,#v.name*4+14)end)pos.w,pos.h=w+6,6*#self+12 pk(pos)for i=1,#self do local dp=point(2,6*i+2)+pos 
if(i==self.index)spr(31,dp:nj())
print(self:get(i).name,dp.x+9,dp.y,10)
i+=1
end end cb=menu()function cb:xg()while self:get(#self).turn do self:hk()end vh(you.pos,function(p,t)foreach(ei(p),function(e)if item<e then self:add("take "..e.name..(e.qty>1 and"("..e.qty..")"or""),function()you:take(e)self:xg()end,turn)end end)end,false,true)
if(self.index>#self)self.index=#self
end cb:add("inventory",function()inventory:ak()end)cb:add("equipment",function()pd:ak()end)cb:add("knowledge",function()bb:ak()end)cb:add("use",function()ue()rd(function(p)
if(use(qi(p),you))return
for e in all(ei(p))do 
if(use(e,you))return
end msg"you can't use that."end,rectangle(you.pos):expand())end)inventory=menu()function inventory:xg()self.index=1 self:clear()foreach(you.pe,function(itm)self:add("",function()local eb,qj,ph=menu(),itm.name,function()ue()fk()end eb.pos=rectangle"20,60,1,1"if itm.use then eb:add("use "..qj,function()use(itm,you)ph()end)end if equipment<itm then eb:add("equip "..qj,function()itm:equip(you)ph()end)end eb:add("drop "..qj,function()you:drop(itm,1)ph()end)eb:add("throw "..qj,function()ue()rd(function(p)uk(itm,point(you.pos),p,function(hc)you:drop(itm,1,hc)local bf=jg(hc)
if(bf)you:aj(bf,itm.dthrown or 1)
if(itm.oc)itm:oc(hc)
sfx(itm.throw_sfx)fk()end)end,lb)end)eb:ak()end)end)end function inventory:draw()pk"56,20,19,88"for i=1,min(#you.pe,7)do local y1,itm=11+i*12,you.pe[i]itm:draw(point(60,y1))
if(i==self.index)spr(28,60,y1)
print(itm.qty,69,y1+6,10)end end pd=menu()function pd:xg()self.index=1 self:clear()foreach(lc,function(equip_slot)local itm=you.hi[equip_slot]self{op=itm and function()local eb=menu()eb.pos=rectangle"20,60,1,1"eb{name="remove "..itm.name,op=function()itm:remove()self:xg()mj()end}eb:ak()end or always_nil}end)end bb=menu()function bb:xg()self:clear()local cg,ek=sd"armor class:damage:hit rate:,creatures killed:,most exp:,most kills:,deepest floor:",{you.ac,(you.min_dmg+you.dmin_boost).."-"..(you.max_dmg+you.dmax_boost),(you.hitrate+you.hit_boost),kills,nh[1],nh[2],nh[3]}for i=1,#cg do self:add(cg[i]..ek[i],always_nil)end end function pd:draw()sspr(xj"96,96,12,30,56,20")spr(28,58,13+9*self.index)local i=0 foreach(lc,function(u)local itm=you.hi[u]if itm then itm:draw(point(58,22+i))end 
i+=9
end)end function jd()for i=0,3 do 
if(btnp(i))you:move(i)
end 
if(btnp"4")cb:ak()
if(btnp"5")ej=not ej
pj()end function rc()for i=0,3 do if btnp(i)then local pos=(-kh.pos):move(i)if zj>pos and ni(pos)then kh.pos(pos)pj()end end end if btnp"4"then sg(kh.pos)bk()end 
if(btnp"5")msg"cancelled."bk()
end function zd()
if(btnp"0")mj()return
if(btnp"2")then
dh.index-=1
if(dh.index==0)dh.index=#dh
end 
if(btnp"3")dh.index%=#dh dh.index+=1
if btnp"4"or btnp"1"then 
if(dh.index<=#dh)dh:get(dh.index):op()pj()
end 
if(btnp"5")ue()
end function zh()
if(btnp"5")ej=not ej
fk()qh()end function df()
if(hb)return
mb=false vk=jd pj()end function o()
lb-=lb+point(8,8)-you.pos
end function _init()cartdata"phantasos"yi()ad,mg,sf,lb,vk,gb,ej,ok,turn,hf,oi,j,hb,mb,kills,nh,lc=queue(),queue(),queue(),rectangle()*16,df,oe(always_true),xj"false,0,0,0,7,1,true,true,0,{0,0,0},{weapon,armor,rings}"you,xb,vf=player(gb),je(fj(0x2000,0x284)),{}o()local dg=je(fj(0x2284,0x3ca))foreach(dg,function(gk)local pi={}for i=2,#gk do add(pi,gk[i])end vf[#gk[1]]=pi end)fi()msg"travel deeper, rogue."end function _update()if fb(ad)then return end if nk then fb(mg,true)turn=ef(turn,1)if you.hp<=0 then mh,we,vk=true,true,zh end nk=false local exp=you.exp you.hp_max,you.max_dmg,you.hitrate=10+flr(exp/30),player.max_dmg+flr(exp/100),80+exp/100 local zc={exp,kills,j}for i=1,3 do nh[i]=max(zc[i],dget(i))dset(i,nh[i])end elseif btnp()!=0 and not ve then if not mb and#msg>0 then qh()else 
if(msg.yd)qh()
vk()end end end function _draw()ok=ef(ok,1)if mb or hb then sspr(32*(flr((ok%18)/6)),xj"96,32,32,0,0,128,128")
if(ok%9==0)sfx(0)
if(mb)sspr(xj"64,64,64,16,14,0,100,25")
local af="press any key to start"
if(re<100)af="descending:"..re.."%"
local x1=66-#af*2 pk(rectangle(x1,118,#af*4,128))print(af,x1+1,121,10)return end if ve and tj(ve,ok)then ve=nil cls()o()local uj function draw(s)spr(s,(uj*8):nj())end local db,sb={},sd"0=0,1=0,2=1,3=1,4=2,5=1,6=5,7=6,8=2,9=4,10=4,11=3,12=1,13=5,14=8,15=4"for i=1,#xb do local td=xb[i]uj=td[1]local yb=uj+lb local t,key=qi(yb)or void,#uj kd(sb,function(v,k)pal(k,you.fe and wg(16,0)or v)end)if we or not(db[key]or t<void or(you.pos:md(yb)>you.sight_rad and not t.kf)or you.can_see==always_nil)then t.dj=true if not you.fe then pal()end draw(t.sprite)wf(function(e)e:draw()end,rectangle(yb))elseif t.dj then draw(t.sprite)end pal()if t.solid or db[key]then for k=2,#td do db[#td[k]]=true end end end 
if(kh)kh:draw()
pk"8,116,110,10"print("hp:"..you.hp.."/"..you.hp_max.." exp:"..you.exp.." floor "..j,xj"15,119,10")if ej then pk"32,28,69,69"gc(function(p,t)if t.dj or we then local c=t.color if rk(p)then wf(function(e)c=e.color end,rectangle(p))end local x,y=((p*2)+point(38,34)):nj()rectfill(x,y,x+2,y+2,c)end end)end end 
if(fb(sf,true))pj()
pk"2,2,124,14"
if(not msg.yd and#msg>0)qh()
local ze,yd=msg.ze or"",msg.yd or""print(ze,4,4,9)
if(#msg>0)spr(xj"31,120,10")
print(yd,4,10,10)foreach(bh.values,function(m)m:draw()end)
if(dh)dh:draw()
end
__gfx__
12022201120220311202220111111111555155550000000000000000120222010122210000000000000000000000000000000000000000000000000000000000
212002201c1020312120022015551111511113350222200005555550212000201200021000000000000000000000000000000000000000000000000000000000
202110202c103031202110205511551533113133255112000ddddd10202110201200021000000000000000000000000000000000000000000000000000000000
22021020230230212202102011551155533551152ddd120005555220220210202000002000000000000000000000000000000000000000000000000000000000
02021021230c3021020210211115511133553311255552000ddd1210020210212000002000000000000000000000000000000000000000000000000000000000
02021021102c10210202102155111555133333332ddddd0005522110020210212000002000000000000000000000000000000000000000000000000000000000
12021210022c02111202121015555111513335532555555002121220120210202000002000000000000000000000000000000000000000000000000000000000
1202221002222011120222101111111155115511dddddddd00000000120210201000001000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc0c000101111011000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808000000cccc0110000110000100044000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000089aa800cccc0000011110000000001046600000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c9000c0000c0c100011110010000045550000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008aa9800c00cc000111001110000000046666000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808000ccc00cc0011110001000000045555500
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00c00001110110000010046666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc00110111010000000045555555
000007000000000000000000000000000000070000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
262c032600260226042d262c022601260426022d260f201912101a192811171a1a1d262c032601260226022d262c0126022d262c0626012d262c0326042d261f1a1d0e13262c0226002d262c0526002d261d141912262c0626012d261e1f0c1f2010262c0326042d26220c1f0e13101d262c0126022d2d2d262c1f1d24350100
0026180c23350126210c17352c220c1717262c0326012d2611171a1a1d262c0326002d26211a140f262c002602260726062d2d260d170f352c1f10181b171028220c1717262c012602260526062d262c002603260726032d261f10181b17102811171a1a1d262c022603260326022d262c022606260326012d262c0326012601
26062d261f10181b1710280f1a1a1d262c0326022d262c032604260126022d2611171a1a1d281b100f101e1f0c17262c0126042d262c0526042d261f131d1a1910262c0326042d261e1f0c1f2010262c0126042d262c0526042d26220c1f0e13101d262c0326042d2d2d262c1f1d243502000026180c23350126210c17352c21
1a140f262c002602260526052d260e0c211028220c1717262c002601260526012d260e0c21102811171a1a1d262c002600260526012d2d260d170f352c0f201912101a1928220c1717262c002601260526062d260e0c211028220c1717262c002601260526032d260e0c21102811171a1a1d262c012603260326012d262c0126
01260126032d2611171a1a1d281b100f101e1f0c17262c0126012d262c0326012d260f1a1a1d262c022604260126022d260f201912101a192811171a1a1d262c012605260326012d261e1f0c1f2010262c0126012d262c0326012d261f1a180c130c2216262c0326052d26161a0d1a170f262c0126052d2d2d262c1f1d243502
000026180c23350226210c17352c211a140f262c002602260526012d260e0c211028220c1717262c002601260526012d260e0c21102811171a1a1d262c002600260526012d2d260d170f352c0e0c211028220c1717262c002601260526022d2611171a1a1d281b100f101e1f0c17262c0126012d262c0326012d261e1f0c1f20
10262c0126012d262c0326012d2d2d262c1f1d243501000026180c23350226210c17352c11171a1a1d262c002600260326032d2d260d170f352c1f10181b17102811171a1a1d262c002600260326032d2611171a1a1d281b100f101e1f0c17262c002601260326012d262c012600260126032d261e1f0c1f2010262c0126012d
2d2d11171a1a1d352c2c002600260326032d2d2d260d170f352c1f10181b17102811171a1a1d352c2c002600260326032d2d2611171a1a1d281b100f101e1f0c17352c2c002601260326012d262c012600260126032d2d1e1f0c1f2010352c2c0126012d2d2d2d2811171a1a1d26032703260327030624060108070806070507
04070306022400010708060705060405030402030102240f0f09090a0a0b0b0c0c0d0d0e0e24080108070806080508040803080224010e07080609050a040b030c020d24060f0809080a070b070c070d060e240108070806080508040803080208240d0c09080a090b0a0c0b240e0909080a080b080c090d09240d0d09090a0a
0b0b0c0c240d0509080a070b060c0624050e0809070a070b060c060d2404010807070607050604050305022402040708060705060406030524020a0708060905090409030a24050308070706060506042407082408030807080608050804240e0a09080a090b090c090d0a240a0e0809090a090b090c0a0d2407060807240403
080707060605050424040807080608050824010407080607050704060305020524030a070806090509040924060a070924080a080924090f0809080a080b090c090d090e240d0609080a070b070c0724030b07080609050a040a2404050708060705062402000807070606050504050304020301240a09090824040e0809070a
060b060c050d240e0409080a070b060c060d05240307070806080507040724070e0809080a080b070c070d24050b0709060a240a05080709060c150a1c1c170a160e341d12160e1b0c150a1c1c170a160e341a1e0e1e0e24150e17101d11340009240a0f0809080a090b090c090d0a0e240a0709082406050807070624070508
070706240907240201080707060605050404030302240d0a09080a090b090c09240002070806070506040503050204010324050a07080609240b0509070a06240004070806070507040603060205010524010b070806090509040a030a020a240b0809080a0824020d07080609050a040b030c240a0809082408000807080608
0508040803080208012405080708060824000307080607050604060305020501042402020707060605050404030324050c0809070a060b240304070806070506040524030e0809070a060b050c040d240e0c09080a090b0a0c0a0d0b24040907080608050924070c0809080a070b240700080708060805080407030702070124
__sfx__
010124010a1730a1730777306773057730a0732240321403204031f4031c2031e203202032320324203262032820328203222031320319403016030400303003020030b003084030900309403090030a4030a003
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

