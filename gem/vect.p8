pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
end

function _update60()
end

function _draw()
	cls(0)
	tentacle()
end
-->8
-- drawing


--parse table from string

function ptstr(s)
	local data={}
	local wip=''
	for i=1,#s do
		r=sub(s,i,i)
		if(r==',') then
			add(data,wip+0)
			wip=''
		else
			wip=wip..r
		end
	end
	add(data,wip+0)
	return data
end

--polygon

function poly(r,c,p)
	local t=ptstr(r)
	--based off alienryderflex.com/polygon_fill
	--t=table x1,y1,x2,y2...
	--c=colors (hex)
	--p=pattern
	local pc=#t/2
	local px={}
	local py={}
	local my=127--miny
	local xy=0  --maxy
	--split out xy lookups
	for i=1,#t-1,2 do
		add(px,t[i])
		add(py,t[i+1])
		if(t[i+1]<my) my=t[i+1]
		if(t[i+1]>xy) xy=t[i+1]
		if(i<#t-2) then
			if(p) fillp(p)
			line(t[i],t[i+1],t[i+2],t[i+3],c)
			fillp()
			--yield()
		end
	end
	--scan down the screen
	for y=my,xy do
		local nx={}
		--build a list of nodes
 	local n=0
 	local j=pc
 	for i=1,pc do
 		if((py[i]<y and py[j]>=y)
 			or(py[j]<y and py[i]>=y)) then
 			add(nx,(px[i]+(y-py[i])/(py[j]-py[i])*(px[j]-px[i])))
 		end
 		j=i
 	end
 	--bubblesort nodes
 	local k=1
 	while(k<#nx) do
 		if(nx[k]>nx[k+1]) then
 			nx[k],nx[k+1]=nx[k+1],nx[k]
 			if(k>1) then
 				k-=1
 			end
 		else
 			k+=1
 		end
 	end
 	--fill the pixels
 	for l=1,#nx-1,2 do
 		local d=nx[l]
 		local e=nx[l+1]
 		if(d>=127) break
 		if(e>0) then
 			if(d<0) d=0
 			if(e>127) e=127
 			if(p) fillp(p)
 			line(d,y,e,y,c)
 			fillp()
 		end
 	end
 end
 --yield()
end

--polyline

function pline(r,c,p)
	local t=ptstr(r)
	for i=1,#t-2,2 do
		if(p) fillp(p)
		line(
			t[i],
			t[i+1],
			t[i+2],
			t[i+3],
			c
		)
		fillp()
	end
	--yield()
end


function tentacle()
 poly('39,127,79,127,82,119,84,113,82,106,77,99,69,93,63,88,60,78,61,73,63,69,67,65,72,60,78,55,82,50,81,41,77,38,72,37,72,40,75,43,76,46,71,50,66,54,57,63,51,68,47,77,43,85,42,99,45,102,51,107,53,111,53,116,49,121,45,124', 0x78, 0)
 poly('37,127,40,126,43,124,47,121,51,118,52,114,52,110,51,108,47,104,44,101,41,98,41,94,41,89,42,85,44,80,44,86,44,90,45,95,48,99,51,102,55,106,57,109,58,114,58,118,56,122,53,125,50,127', 0x72, 0)
 poly('64,68,68,64,72,61,76,57,79,55,81,52,82,49,82,46,81,41,79,40,79,42,79,46,78,51,75,54,71,59,68,61,65,64,64,66', 0x7e, 0)
 poly('74,119,75,115,76,113,77,110,80,110,81,113,81,116,79,119,77,123,75,123', 0x71, 0)
 poly('66,121,68,119,69,116,71,113,71,110,69,109,66,111,64,114,63,117,63,120,63,122', 0x71, 0)
 poly('73,100,72,97,70,95,68,94,67,96,68,98,70,101,72,102', 0x71, 0)
 poly('65,101,63,98,62,96,59,94,57,95,57,98,59,100,61,102,63,104,64,104', 0x71, 0)
 poly('61,87,60,85,60,83,59,81,57,81,57,84,58,86,59,88', 0x71, 0)
 poly('53,85,54,83,54,81,53,79,51,80,51,84,51,86', 0x71, 0)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
