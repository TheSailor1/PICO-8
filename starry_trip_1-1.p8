pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- stargazing on the star train
-- from "starry trip"
-- ral schutz

-- original music distributed 
-- under cc by-sa 4.0 deed
-- https://creativecommons.org/licenses/by-sa/4.0/


-- album, a music visualizer
-- by bikibird
-- for the pico-8 new music jam
-- record function based on code by packbat.

-- 1. add sfxes/music patterns.
-- 2. add meta-data to tab 2.

-- list of visualizers and suggested palettes
-- see comments in tab 2 for more info

-- bubble
-- cover
-- harp: {[0]=0,130,141,13,12,140,1,131,3,139,11,138,135,10,9,137}
-- piano_roll
-- ripples
-- stars

-->8
-- visualizers
function bubble()
    -- bubble is formed from map 0,0,16,16
    local delta,collapse_rate=0,tune.collapse_rate and tune.collapse_rate or .4
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    while true do
        _cover()
        if #events>1 then
            if new_flag  then
                for i=1,4 do
                    if events[#events][i].hold then
                        --delta-=1
                    else   
                        delta+=1 
                    end
                end
            end
            local r=flr(35+delta) --+sqrt(high-low)*4 +delta
            delta=delta<=0 and 0 or delta-collapse_rate
            local rsquare=r*r
            local ysquare,newx
            local x,y=r,0
            while (y<=x) do
                tline(63-x,63+y,63+x,63+y,1,16*y/r,7/x)
                tline(63-x,63-y,63+x,63-y,1,16*y/r,7/x)
                tline(63-y,63+x,63+y,63+x,1,16*x/r,7/y)
                tline(63-y,64-x,63+y,64-x,1,16*x/r,7/y)
                y+=1
                ysquare=y*y
                newx=x+1
                if (newx)*(newx)+(ysquare) <= rsquare then
                    x=newx
                else
                    if (x)*(x)+(ysquare) <= rsquare then
                    else
                        x-=1
                    end   
                end
            end
            local t_left=palt(left,false)
            local t_right=palt(right,false)
            if left>-1 then
                circ(63,64,r,left)
            end
            if right>-1 then
                circ(64,63,r,right)
            end
            palt(left,t_left)
            palt(left,t_right)

        end
        display_credits()
        yield()
    end
end

function cover()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    while true do 
        _cover()
        display_credits()
        yield()
    end
end
function _cover()
    local background =tune.background
    if background then
        if background==-1 then
            map(0,0)
        else
            cls(background)
        end
    end
end
function harp()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local offset=tune.offset or 0
    local spacing=tune.spacing or 2
    local width,height=spacing,128
    if type(spacing)=="table" then width,height=unpack(spacing) end
    while true do
        _cover()
        local t_left=palt(left,false)
        local t_right=palt(right,false)
        if #events>0 then
        for i=1,4 do
                local pitch=events[#events][i].pitch
                local x=(pitch+offset)*width
                if events[#events][i].volume >0 then
                    line(x,0,x,127,pitch_colors[pitch%12])
                    if left>-1 then
                        line(x-1,0,x-1,127,left)
                    end
                    if right>-1 then
                        line(x+1,0,x+1,127,right)
                    end
                end
            end 
        end   
        palt(left,t_left)
        palt(right,t_right)
        display_credits()
        yield()
    end

end
function stars()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local offset=tune.offset or 0
    local spacing=tune.spacing or 16
    local starfield={}
    for i=0,7 do
        for j=0,7 do
            add(starfield,{j*16+16-rnd(16),127*spacing/16-(i*spacing+spacing-rnd(spacing))})
        end
    end
    while true do
        _cover()
        rectfill(0,0,127,127*spacing/16,0)
        for star in all(starfield) do
            pset(star[1],star[2],13)    
        end
        if #events>0 then
            for i=1,4 do
                local pitch=events[#events][i].pitch
                local volume=events[#events][i].volume
                if volume >0 then 
                    local star=starfield[pitch+1+offset]
                    local x,y=star[1],star[2]
                    if volume <3 then
                        pset(x,y,7) 
                    elseif volume <5 then
                        line(x-1,y,x+1,y,13)
                        line(x,y-1,x,y+1,13)
                        pset(x,y,7) 
                    else
                        pset(x-1,y-1,12)
                        pset(x+1,y+1,12)
                        pset(x-1,y+1,11)
                        pset(x+1,y-1,11)
                        line(x-2,y,x+2,y,7) 
                        line(x,y-2,x,y+2,7) 
                        pset(x-3,y,14)
                        pset(x+3,y,15)
                        pset(x,y-3,9)
                        pset(x,y+3,10)
                        pset(x-4,y,5)
                        pset(x+4,y,5)
                        pset(x,y-4,5)
                        pset(x,y+4,5)
                    end
                end
            end 
        end   
        display_credits()    
    yield()  
    end
end
function ripples()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local offset=tune.offset or 0
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local foreground=tune.foreground or {12,12,12,12}
    local spacing=tune.spacing or 16
    local water=tune.background>-1 and tune.background or 0
    local horizon=127-127*spacing/16
    local rings={}
    for i=0,7 do
        for j=0,7 do
            add(rings,{x=j*16+16-rnd(16),y=127-(i*spacing+spacing-rnd(spacing)),radius=rnd{spacing-5,spacing-3,spacing+1},pitch=i*8+j})
        end
    end
    
    while true do
        _cover()
        if horizon>0 then
            rectfill(0,127-127*spacing/16,127,127,water)
        end
        local transparency=palt(left,false)
        local vibrations={}
        for ring in all(rings) do
            if #events>0 then
                local shadow=true
                for i=1,4 do
                    if events[#events][i].volume > 0 then
                        local pitch=events[#events][i].pitch+1+offset
                        if ring.pitch==pitch then
                        shadow=false 
                        end
                    end
                end
                if shadow then
                    if left>-1 then
                        circ(ring.x,ring.y,ring.radius-5,left)
                    end
                else
                    add(vibrations,{ring.x,ring.y,ring.radius+rnd(2)-1})
                    
                end
            end   
        end
        local c=1
        for vibe in all(vibrations) do
            color(foreground[c])
            circ(unpack(vibe))
            c+=1
        end
        palt(left,transparency)
        display_credits()
        yield()  
    end
end
function piano_roll()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local offset=tune.offset or 0
    local spacing=tune.spacing or 2
    local foreground=tune.foreground or {8,8,8,8}
    local pitches={}
    while true do
        _cover()
        local t_left=palt(left,false)
        local t_right=palt(right,false)
        if #events>0 and (stat(46)>-1 or stat(47)>-1 or stat(48)>-1 or stat(49)>-1)then
            local event =events[#events]
            add(pitches,{
                event[1].volume>0 and event[1].pitch or -1,
                event[2].volume>0 and event[2].pitch or -1,
                event[3].volume>0 and event[3].pitch or -1,
                event[4].volume>0 and event[4].pitch or -1})
            if (#pitches>128) deli(pitches,1)
            for i=1,#pitches do
                local tracks=pitches[i] 
                local y=128-#pitches+i   
                for j=1,4 do
                    if tracks[j]>-1 then
                        local x=(tracks[j]+offset)*spacing  -- *spacing
                        pset(x,y,foreground[j])
                        if left>-1 then
                            pset(x-1,y,left)
                        end
                        if right>-1 then
                            pset(x+1,y,right)
                        end
                    end
                end
            end
        end

        palt(left,t_left)
        palt(right,t_right)
        display_credits()
        yield()  
    end
end
-->8
-- tunes
-- visualizers: -- bubble, cover, harp, piano_roll, ripples, stars
-- there are many options to customize.
-- see https://www.lexaloffle.com/bbs/?tid=55641&tkey=nJgBghT3cHfLF3diOmaf for details.
tunes=
{
    {
        pattern=0,  --music pattern number to play
        title="stargazing on the star train", 
        credit="ral schutz", 
        visualizer=stars, -- bubble, cover, harp, piano_roll, ripples, stars
        background=129, --background color, -1 for sprite sheet
    				palette={
    					[0]=129,
    					[4]=7,
    					[5]=136,
    					[6]=137,
    					[7]=135
    				},
    				foreground={4,5,6,7} 
    },
--  {
--    etc.
--  },
}

-->8
-- custom instruments
-- pitch shift for custom instruments

instruments=
{
    [0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,
    [8]=0, --custom instrument 0
    [9]=0, --custom instrument 1
    [10]=0, --custom instrument 2
    [11]=0, --custom instrument 3
    [12]=0, --custom instrument 4
    [13]=0, --custom instrument 5
    [14]=0, --custom instrument 6
    [15]=0, --custom instrument 7
}

-->8
-- init
function _init()
    frame=0
    sfx_addr = 0x3200
    left,right,up,down,fire1,fire2=0,1,2,3,4,5
    pitch_colors={[0]=  4,  11,  6,  13,  8,  15,  10,  5,  12,  7,  14, 9}
    track=1
    tune=tunes[track]
    visualize=cocreate(tune.visualizer)
    credits=true
    play_tune()
end
function play_tune()
    music(-1)
    events={}
    music(tune.pattern)
end

-->8
-- update
function _update()
    if btnp(right) then 
        track+=1
        if (track>#tunes)track=1
        tune=tunes[track]
        visualize=cocreate(tune.visualizer)
        credits=true
        play_tune()
    elseif btnp(left) then
        track-=1
        if (track<1)track=#tunes
        tune=tunes[track]
        visualize=cocreate(tune.visualizer)
        credits=true
        play_tune()
    elseif btnp(up) then
        credits=false
    elseif btnp(down) then
        credits=true
    elseif btnp(fire1) or btnp(fire2) then
        events={}
        visualize=cocreate(tune.visualizer)
        play_tune()
    end
    frame+=1
    get_notes()
end

function get_notes()
    --First byte / Low 8 bits--     w	w	p	p	p	p	p	p
    --Second byte / High 8 bits--   c	e	e	e	v	v	v	w
    local sfx_indices={stat(46),stat(47),stat(48),stat(49)}
    local note_indices={stat(50),stat(51),stat(52),stat(53) }
    local sounds={}
    local pitch,volume,effect,intstrument,hold
    new_flag=new_event(sfx_indices,note_indices) 
    if new_flag then
        for i=1,4 do
            if sfx_indices[i]>-1 then
                local addr= sfx_addr+sfx_indices[i]*68+note_indices[i]*2
                local byte1, byte2 =peek(addr),peek(addr+1)

                pitch=byte1 & 0x3f
                volume=(byte2&0x0e)\2
                effect=(byte2&0x70)\16
                instrument=(byte2&0x80)\16+(byte2&0x01)*4+byte1\64
                if instrument > 7 then --custom instrument
                    pitch+=instruments[instrument] --transpose pitch if necessary
                end
            else
                pitch,volume,effect,instrument,hold=-1,0,-1,-1
            end
            
            if #events>0 and pitch==events[#events][i].pitch then
                hold=true
            else
                hold=false
            end 
            add(sounds,{pitch=pitch,volume=volume,effect=effect,instrument=instrument,hold=hold})
        end
        add(events,sounds)
        events[#events].sfx_indices=sfx_indices
        events[#events].note_indices=note_indices
        if #events>128 then
            deli(events,1)
        end
    end
    return new_flag
end

function new_event(sfx_indices,note_indices)
    local result=false
    if #events==0 then
        for i=1,4 do
            if sfx_indices[i]>-1 then
                result=true
                break
            end
        end
    else
        for i=1,4 do
            if note_indices[i] !=events[#events].note_indices[i] then
                result=true
                break
            end
            if sfx_indices[i] !=events[#events].sfx_indices[i] then
                result=true
                break
            end
        end
    end
    return result
end
-- record function based on code by packbat
function record(pattern,repeats,fadeout)
    --export with fadeout and repeats
    extcmd("audio_rec")
    pattern=pattern or 0--set to beginning of song
    repeats=repeats or 1--number of loops before fadeout
    fadeout=fadeout or 5000--in milliseconds, max 32767
    print("recording")
    music(pattern)--start music
    for i_r=1,repeats+1 do
        print("recording... "..i_r)
        flip()
        repeat
            flip()
        until stat(55)>stat(54)-pattern or not stat(57)--loop detection
        --stat(55)=number of patterns played
        --stat(54)=current pattern number
        --if number of patterns played exceeds number of patterns advanced,
        --song has looped
        
        pattern=stat(54)-stat(55)--reset to detect next repeat
    end
    music(-1,fadeout)
    repeat
        flip()
    until not stat(57)--when playing, stat(57)==true
    extcmd("audio_end")
    print("recorded; check desktop.")
end
-->8
-- draw
function _draw()
    cls()
    local status, err = coresume(visualize)
    if not status then
        cls()
        stop(err)
    end
end
function display_credits()
    if credits then
        local credit,title=tune.credit,tune.title
        outline_print(title,1,1)
        outline_print(credit,1,7)
    end
end
function outline_print(text,x,y)
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local c=tune.text or 7
    local t_left=palt(left,false)
    local t_right=palt(right,false)
    if left >-1 then
        print(text,x,y-1,left)
        print(text,x-1,y,left)
        print(text,x-1,y-1,left)
    end
    if right>-1 then
        print(text,x,y+1,right)
        print(text,x+1,y,right)
        print(text,x+1,y+1,right)
    end
    print(text,x,y,c)
    palt(left,t_left)
    palt(right,t_right)
end

__gfx__
11c5963c311cc33dc1361cd11cc3c3cc3cc322d1c111c111c111d111d1216d111cdccdbcc11d63222d1499424222112122212222222122122212242249999445
1c14adc3cc1dc3cdc1cc13d11cc3cc3cc3cc14d1d1c111c1111cd1c1c12cdd31cdd6bdcc111ddc2d2d1249422222111c12212122122222212212142222494a44
1c14abcc3d13dc3dc13cc1dc1c3c3c3cc33c1453dc11c1c1c11cd1c1d21cadd1ccdb6dbccc114d1d2dd14942222111c11c12c11111d122221dd2121122249994
c11a6d3c3dc1c3cd3dc1c1d11cc3cc33cccb325cd31c1d11c11cd11cd21c41cc3dcc6dbccd11d6c221d1494420211dc11c1c1c6f66ddc112d21ddc1dcd224494
31dabdc3cd31dc33cd1cc1c11cc3cc3ccbccc1251c11cc11c11dd1c1d2164111cd3c3b6cc3c1ddd1d2d124942221cc1cc1dcd44d5d4996c11d1211c111d22499
1c4963c3dcd1c3ccd1c1c1dc1cddbcc33c3c314d1dc11c11c11cd1ccd2cdd1ccc53c6d6bcc511461521d14942211111cc2d642d1c112dd9ac1ddd1ddcc112249
1c4abc33c3d1cd3c31c1cc11c1ccbcc3ccc3c14d1dc11c11c11dc11cd2c911c3cdcbd6bcc3cc1d6c252d15944221c12cdddd51dd21c1121de9c11d1111cc1229
1da5cc3c31c1dd3cc3c1c11c1ccbc3c3cbccb3223dc11c11c1cd11cd22341ccc3dddbc6bcc1c114d1d2dd1494211c21dda41d2222221c1122daf11dddd1c11d4
1dab3c3cd3cd3dc33c11cc1c1c3dcbcc3cc3cc12c1c31c11c11d1c1c21cd11cc36ccab66bcc3c1d632d1d1244221c21d645c12111121ccc1d2d4fc11d21cc112
c446c33ddc1d1cc3cc11c11c1c36dcbcc3cbcc1451dd1c11c1cd11cd1d6dd1ccd4abccb6c3cc311ed1d5cd244421c21c9111c11cdc11111cc111d9611d21ccd1
1dadcbccd1cc13d3cdc1cc1c1c1c6bc3ccbc3c3253cd1c11c11c11cd2c41c3cb6dac6d6b6cbcc11d6c221d144421c116d21cd1c11ccccc1c12c12deac1d11cc1
1dad3c3c11c311cd3dc11c1d1c1c6bdcb3ccbcc12d5c11c11ccd11dd1d41dcdcabadd66b6cbc1c1d4d132dd24421c1d42d111dc11cc111c11c11c21e9c1221cc
1446cbcc31ccc2d3c3c1ccc1c1c366bccbcc3cc1431cd1c111cd1cc116d1cc9cdda3566ab6c63cc1d6d1d1d14441116e11c11c1c1c11cc1cccc11c11d961d11d
c4abcdbc31c311c3cd3c11d1c1c3d6b6cbc3cb332dcdc111c1cd11c2c4c1cc3b6ba6166baadbdc1114d1d2dd1442c1642c1c1cc1c1cc111c121c12c12d4ac2d2
c4963c3dcccdc13d3ddcc3d1c1cc5da6bcc3cccc155dd1c111cc11c1d21ccbcc6dac16db66acc3cc1d6c151d1242116d2111c111cc11cc1cc1cccc1c12de9c12
c49bc3cd331d31dcc5d3ccd1d11ccdb66bc3bcbc123dc111c1dc11d1fd3cdc3b6a363a53a1d6bcc31196c221d24411a4211cc1ccc1cc11c1cc11cc1cc111d961
daadbccbcc3dc1d3ddd3dc11cc1dc3dcdbcccbcc12c3c111c1dc1c1c411ccbc6daabca1cd36accbcc1dd31d1d124216d111c11c1cc1ccc1c11cc1c111cc12dea
54abdcbd3c3d11dc5dad3cc31d1c31c36ab63ccb32d3ddc11cdd1c1de1cc3c63aad63acc4dcaaccdcc146c25dd122164d21c1cccccdcddccccc1ccccc11c121e
4aadbcc33cdd11c3dd33dd3dcc1dc11cd6b6c36cc21cd1c111dc1d1ddcc3cdbcaabac43caacbdb6bc31d431d1dc241dad2c1ccddcdd66b66d6d6ddc1cc1ccc12
d94abcdc33cd11cddddddcd31c1cc11c366bc3bc311cdd111cd11c1ad1ccb6aa4bad3acda93d6ac6ccc1d6c2d1d142cd4211ccd3ccbcccb66ba66aaddcc1c1cc
49abc3dc3cdc11cd5dd33cdc1cd131c1cdb663ccc523dc111cd1c1c41ccbca94a6646c3cbdcabd6bbcc319d151dc221a411ccdcc1cc3ca6cc3dddcccd69dcc1c
44a5bccbdc331cc3ddd3c3d3c1dcd1c1d6bddc3cb32ddc111cd1c1de1cc3db669babb6466b6996a6c6bc1d6c2d1d12164d1cdc3cc3c9cbdddd3cd3dddddcca6c
99abcdbc33e11dd3ddbcc5dc31c1dc1ccdadbccbcc233c1111c1c1d41cbc6bcbada656c9ba9b5ab6ab6ccd46312dc21dad1c6c3ccdacddd1ccccccccc33dddcd
9b9a3c6b3cd1dcc3dc63c33cc1c1dc1d3d6b663cdb1dcd11ccd1c1de3cccabcc9a5dacbd649a69aadb66c3dac1d1d121642cc3ccabcd1ccc11111cc3cc1ccc3d
994bcb6c3cc1d3cc33cd3cc1d1c1dc1dcadb66bccc11dd111cd1d1dd1c63a6369bab69b9aadaa599aa6bbc146121dc21dad1dc6b6cd1cc1cc1ccc11ccccc1ccc
49aacbdc3d11cc3c3dddc3cd3cd1cc33cdab6dbcbbd1cd1c1cc1dcd4dcccbccaaaddb96c33cbb6ab99daaccdac1dcd12c441ccbfc21c1cc1c11ccc11c11cdc11
49bdcbcc3d1dc3ddd33c33cdc1dcd1dcdab66bcccc11cdc11c1cdcd43cbdacb9bad6acdddccd2dddaadacac1461d1d12169dc66ddd1cccdcccc1cccccc1c11c1
4aadb6d3c31dcd53c1ccc1dd3dc1dc3ca4ab66bcbc31dd31cc11dcd4ccdcaccadda4c25ccddccccd1cabc36cdac11dc1164dc6bbdccdcc3ccc3ccc31ccc1cc11
44abcdbcdc1dcd3cd33c3cd53c1c35d3aadb66dbccd1cddc1cd1c3dd3cab6bbaa3ac5c133ccbdc3ccddda6bd14d1dcd12cad366cd1cc3c66bc6bccbcccdcc1cc
49adb6d3d3c33ddcd3cc11ccd5c3dcddb9adb66bcbc13dd11cd1dcd5c3cc6c463addc33ccc3ccb631c32dac6cdac11d11164c6dddcdcc3ccbcc6cb666bcccd6c
49b6b6bcd3dcca3dc31c1cc15d1dc1ddaa5a6ba6dc31cddc11c1d3653c3b6baada3dcc3dcbcc3c63cc1cddbdc59c12dc11643c6d3cc3cccbccb6cccb666bccbc
99abcd63d3dc343cc1c1dd5dc3cddc3b9abad6b66bc1ddbd1cdcd1ddcc366c4b6ddc3cc3cc3c3c63cc1ccddcbc4d1dcdc1de3d6dc3cc3ccb6f66b6c6cbf6666c
a4aa36bcddd3ddcb3cdd3dc33ddbdcd5a94adb66bdc1dddcc1d1d1bdcbccb6ab9ddcc3dc3cd3ccbac1cc1cdadc4acd1d11c9dcddcc3666b66aba6b666a6bccb6
99badb633dcc5bcc1ddc336ccc4d6b3daabaddaa6bbddd3d11dcc1ddcc3bcaad4cd3ccbcc3cc6b663cc3c32ccbd9c11d1c14d6653cccaa6ba66aac6abfa6aa66
99a5b66c3d3ddc33cd3cc1111cd5dcdb999baabaddcc13cc31ccd1d5cbccdad5adc31cdc63c6bcd6b3ccc1cda634d1ddc11fdcddd366ba6aab6aa6d6aa6a6bda
ab9dbcd3dcc5d3ccd33dc1cc1c33cddb9a99da6ba6bb2cdd31cd3dcd33ccbad4ddcc1ccbdcb636cbaccc3cc2ccc461dc1116d362ccd66aa6aa9aaaaba6aaaaa6
4a9b66b3dc53dc35dddc3d11cdc13dcd944aab9ada6c31ddc1cd1dc5c3ccd9b4c23c3c66bc6bc6b6acc3cc3cddbdacdcd116ddddc3c6aba9a9b9abaaadad4a99
49abdd63dc5dbc1ddc3dcccc3cddcd33a9ba49b6abd6b1cd31cd1d3d3c3cb96dcdc31cc36bbdcab6abcc3cc3dd6d91d1d116dcdd3c6aaa44a4dd499faaa6a9ad
a94bab6dbcdbc33cd33c3ddadbdd53dca999b99aa5a6c13ddc1dcdc41ccd446d3d1c1ccbc6acba6adaccbcc3dc634cd1c11cedddc6aaba9dd6cc6ddd4a6baa4a
94aadbddbdcd33dc3ccdaaaa999dcddc3499999baabad33dc31c331dc33ca4dddd1ccdb66aacaadabacb6c3cd3639c11611c46cd36aa44c6d6baa66cddaaada9
49badbcd6dddc1cd3ddab44444449bd4ca44ab9994aadc1ddd1cdc14cccd9dddbddc3c6aab9cbaaad96b6c3ccddc4d1cd1cdddddcaa44636acaadaaabcd99aa4
9994b6ddb5d6b1dc3ca9944d31cc54add3a94994baabad1cddc1dc14c33d4dadd2cc3d699b9daa5aba66b6c3c2dc9dd1d11cd6dccbafd36aaaacadac9fdd9aa4
9a5aabd6bdddb3dddba44d511c11cc2464db9999999aab3ddd31dc1dc3cd9dddddc3d3aa9ba9caaadab6aa63cddc9ddcd1cdddddad6d366ac99dabaaadad4aa4
9949b6dbdd6d3ddc3a49411ccccc31c246dda44a4ab4aac1ddc1dc5d3cc44dad32dccaad996abdba6ab6abcd3d6c4d3dd11cd6dddaad6ba9a99a96d9aa4deaa4
999badacd4bdd3cdba44d11c13c3ccc3d4dbc994a999bad1cd3c3cdd1cd48d6ddddccab694a94caaa9d66a3ccddc9d1cd1cddddcdb4c6adaada949adaaa6d4ae
9949abdbd6dbcd3c69443cccc1cc13c31d46dd944b999ab3ddc13cd51cd44d6bdddc3baaa4ab366b9ababac3cddc4d1cd11dcdd66adc6aa4ada99adaad9add9a
49499ab6db6bdd3da94d11c1dcc3ccccc1c4bdd99994a99c3ddc1ddd3c644d6dbdddcdd99496cba9daca6adc3dd39c1cd1cdcddab4caa4d9949a6a9aba96d4da
4a9b94bacddc3dc3a44d1cdc11cc1331c31c8dda44a95a9b16d3cdddc3a44d6ddd2cc3aadcb6aa994abdabaccdcc931cd1cdddc665faaadcccca9b9aaada6de9
d999496bddbd3ddba94dd3c1cc3ccccc1cc1d4db9994aa9a3ddc1d3d3c64dd6bddd1cdabadaa949449a6aa4cbdd3a1ccd1cdcdda9d6aadcbcbcc9999a4aaad4a
a49a49abad6bddcd94423cc11cc33cc3c3cc1d4dd9944ab4dcd31cddccd44d64ddddc1daada9494a4a9dbaaccddc61d1d1c4ddb6d6ba9cba6a9644f9a94d96da
a49b994abddbcd3ba942cd3cc3d6abdcbc31dc2dd999a9a9b3dc1cdd3b694d6addddccda9b9444444496aa9cbddd3cccd1cddd6ada6aa4a644dafd4e9a9669d9
a949949ad6bddddc9944dc31ccab666bd6c3c1d4dd944999d1dd3dddcca44d65dddd2dc39a44eac6aa66b9accd6d3dc3dc3ddd646649addddddddf4e499daaad
a44a495abadddb3c99442cc3c3dabcb6dbcc11c4dd999b99a3cd3c3d3ca249dadddddccd944996aab66ba94cc2d91d1cd1ccd66badabdedddddddd6f4e9dd6ad
a499959adabd63cda4448dc3cdcdc3cdabcc3c1d4da4999943dd3ccd1c6ad4cabc2ddd1c954e4ba9d6a9a4abcdc6cc1cccdddd966ad2ddddddddcdddede9d96a
495b99945abdd3ddb99442c1caa33c3cadcbcc1c4dd9949993cd3d3d3cb669b6c5ddddcc96449ada6a5449acd53ddc3cd3d6d6dbad2ddc1d112121ddde8e94f9
a994949abdad6bdcd9444edc3dada6c36ab63c1c44d994a943ddcdc31ccbdaddbddddddd5a44eada924e4aacdddcdb1dcddbda66dedcd22c2dc1dd12dde29a46
a5994499d6abddddba94442c1db6badbcaddc3cc2dd949b99c3d3cd3cdccb6a36ddddddcd4e4496a2d8e49acdbddda1dccdd6dba8dc222211c1221dd1deed946
9a44a4a4bba65ac3dca944edcd36bac636b6c3c324da49994bd6c3cd33bbdcaddadddddcd49de9d922e944acddddc9cdc3ddb69ddd222211dc12d121d1deee96
4a4994999daa3ddd56b9444d1cccdadbdbadcc3cd4d6494a4ddd3c3dd3ddddbacb6d2dddc4a224a44e49499cddca3acdcdcd6dded22221d1cc11cd221dcd8d9e
499599599b6addabcdb99488c3dbaac6acabc3c1d4da49994bcdbcdddddddcdd4dadcdddc49dd8f49e49949cddddd6cd3c6daaddd2211dc11c1d1c1221ddee94
49a44994a9b9a3ddddca944edcd6a9bda366cc33d4d64994463d63ddb2ddd2dcadd63dddc44ed8624e9af9adcbfbdbcdbd6cdd2d221dd1c1dc11c2222d1dede9
24a4a49499da9b66b3da94442cdab4a6bacbbccc24d694994bddc3ddc22edddd6db6ddddc494d2ee44a4995ddcde4c6d6cdb6ded2211dc1cddc1c222221ce8e9
244a949959ab9add36db944e2dd9adaa9ba6d3c32edd949446ddbcddd2edded164badddddd46f248e949246dddbdd6dbd6d6add22c11d1d1cc11c222222cde4a
d2499449949a59cdbdd6b944edc9ab94d4a36cc3d4dd99944d3d63cdd22eedddd6d6ddddcd99d9ad2998eebdc6ddddd6dd6b68d22c1cc1c11c11d222222dee89
d244a944959ba9b6ddddb9948dc49446bc4abc3c28ad4944e63d63ddd2edd8dddddad3dddc9464a2e4e4d2d6dbd6b6dadb66ddd211cd11ddd1dc1222221ddee4
ddd449949499a9ddabddda94dd34949a6bfad3cd2edb94944d3ddcd3d8ddeedddddd6ddddc49a4ad448edddcd6ddddd6d6da2dd211c1c1cc11cc122222cdee49
cd2449994944a4abdaddba942dd444699bd4dbc6246d9499edcdd3ddd2ed2edddd6bd63dddda4462e4e2ddd6ddad6adbd66ddd22d1c1c11c11cc112212cd8ee9
cdd244944949a94add6bcd94edd4969954aaa6ddd4d644992ddbdcdd2de8deddeddd5adddcd94aa2e88ddd66ddddddd6d6addd2211cc1cc1cccc11d2d1deede9
436d244a94949b99bdaddba44dd49da4d69d4bcdd4daa449dd36ddbd28ed2ed8ddddc6d2ddda4a622e4ddddddb6daddb6d64d2222cc11c11cccc12d1cdded8e9
4dcdd2d9944999999bd636a44dd94da4aba4aac3d9ddd9498ccbddddd288deddddd6dd6dddc4a4a229e92d6d6dddd6dd6addd2211cc1cccccccc11dcddddeed9
493bd244994449a49bdad3d94dd94a94aa94a4cc4465a4992ddcddbdde8e22eeddddd363ddc4a4a4d9e9a2d6d6d6badb66dd22211cc111cccdcb1d1cdddde8d4
49ad6d2e499494999addddb9d2d94944aaba49bcd46d69492cdbdddd24e82ed8dddd6daddd1da4a9d24e4ed6dd6b666d6dd222c11ccc1c6c66cc1ccddddeeeee
4949cdd24499449b99bd63c94dc944a9b99d946dd4d5a4492dcdddbde48e48deeddd6dadddcc994add98e44d6da6ddaddd22211cc1c1c666b661c3ddedd8e49d
949493dd2e99499949ddbcd94dd94949a99aaba3d4ad69942ddcdd632e44e82ded2ddd6c3ddd44aa8d84e42e8dddddddd2225c1c4dcc4aa66bcdb6ddddeee49e
499a4d6d2449445a99addb694dd4494499b9949cdd44a4498c3cdb6d84ee48ed8dddca36d2dcd49a4de4ee2dddddddd22242c11dcc149aaa3dcdddded8ede4ae
444444b6d2449949949bd6da4dd944a49a99b99cc84df9942ddcdd6d244e482deedddfdadddcd49a48d88e2deddc222244221cccd169a9ac3bf6dddeeedde9ef
cc34e49c42de9449949addbd42c9499d499a4993c29da444ed36bdddd4e44e8eddeddddacdddc4994edde8ddddd22444842c1cc4cc4999bcdadaddde8de849e9
3c3c4d4add249944994bd6da4dd9494d49abaa4a32eda498ddddd6dbe489e88d28dddd4dcdddc49ad2eddd8eddc12444221c1cf434e99acda64cd8ededde9e4e
cdbcd4d93ad24949949addd642c4499a29994a44c24649e22dcdb6ddd44e448edeeddcacaddd1df92d8dedd8ddddd12121c16a4c68e99cdd6ddddedd8ee84ef9
66d3c4444ddd89449949ddb692d49999d9a4ba99c286a4d1ddd6bdddd9e44e82eddeddddac1dcd4a4ddedddc8ddddc3ddcc39ed1dd8edba6d4cdeddede8fd4ed
ba6bc49a9c4d44949949add692c44aa4d9a9a944cd4444d1ddc6bc6dd44e8e82edded26ddbcddc49e88dddddd8ddeddddcdd4dddddeec4694cddded8d99ed9de
d6a3a4494cad2e994994addb9dd9496aa494ba99c2ef44e1ddddbcddd94e82e8dededddfcddd2c49a4aeddddde82dcdcd5cddcceddedda4ecddedeee4afd9ede
49dd44999ddd24944944ad6692c929ab49a9a944c224d9e1ddcdd6bdd444e448eddeded4caddddd6a496d488ee4eddddcd3ddc1dcd8cde4cddddded89ed98de4
449a44994bca249449949dbd92d92496a449ba99bde8da4cddddb66d39ee4ee28ddedddadacddcd49a4aaafaa999ddd8cddddcddddedd9dcdddddde4ed9ecde8
444ad4499ac4dd99449d96d692c9de4da499a5946d246d95ddbd6badd44e484e8deedddddac3ddd464a4999a994dddddcddddcc1cdddd9dccdddede4ee4dd8ee
44e464949ac5d24949449add92c9224aa499ba94ac2edd9ddddddcddd9e4e8e28ddeeddd4dcdddcda9d49e99dcddd8dddcddd3ccdddeddedddddde4ee2ddeedd
88449e449dcbd29949e44add9dd44e49d599a944ac284d9d3d6db6ddd44e484eededdedd966dddcda4ea494a44de8dedcddcdc1cd2cde8e2ddde8ee4dddeede8
4ee4464499cddd49444946dd92da4d446494da444c2e4d9dcdddddb6dd94e8e28deddedd66a3dd1caa4a4d999e82edddc1dddcdcdeddddde8ee4de2ddddedddd
8448446499cbd249e944eadda2c49dd8ad94aa4a9dd44d9ddddddacddd49e28eddeddedd4cacc2dd6a4a4d94a4eed8dddddcc3dcddeddeedddddddddddedddee
2e4e489d44dcd29944994adda2d692c24d9994494ac2864dd6bd6ddbd644e8e28deddeedad9c3ddcca4dade99e8deedecdddc3dcdd4deeddedddddedddeddedd
e824e44ad9a3dd44e494e4dda2dd9ddd8644994a49c2edadd6dddadd6d9e82e8ddeededd46acddd36644994992ed8dddcdddccdc2c6dd8eddeeddededceddeee
28e48e24f44cd29949944addbedd4ddc2e49e99a49dd8d6ddddbddbdd694e84deddedded4bacdddcdaa4ea2e9ede8dddcd5dc3dcdd4ddeedddeededdc1dede84
d82d88de9d9ddd944499e9dd64dd92dd86d4d9499d9c29d4dad6d66dd6494e8ededed8ec466c3ddcd6a44e94944e8dddcdddccdcddded449deddeeeedededee9
6d2e2e82464bd2494e9449db64d644e44f82d494949dd4dadd6d6b4ddd9a42e8ddeddedd46ac3ddcdaa94d9e99e8dddccd3dc3dc4ddde9ee4ddeddedddede4f6
da4d88d24adcde49449949dda4db6da44e28e2499a4ac26d4ddddd6dadac9e8ddededeec464cdddcdda9e4e894eddddc1d3dccdcdddde9aaf4dededeedde8a63
dadd4e84ea2dd2994e94896d64dcc394e4e82de499446d8dadd6a5ddb46b4e2ededee2dde6abcddc46aa44e29e8ddddccdcdc3dc4d6d4ea9a4dcdededdee963c
6bad44e42adcd2494499e4dda4dcca42a449dcd494a49c24dfd5dd6646d64e8ddede8eddd6b6dddcddaa44e9e4eddedcdd3dccdcdddde9aa9aeddddede446bcd
d6ad284e24dddd994e4944fdd4dd3a2ed49444e99a44eac2edad66b46a3c9d8deeddded9693ddddc56694de929edddcc1dcd3cdc2ddde9a99a4c8dece8f6bcdd
49ddd4e84a4ddd494894496dd92d6424e8e9ea444a94d46d24dda46ddadca4dededdedced9cddddddd649ddde4ed2ec1ddcdcc5cdd6d8aa9aa4ecdd2e96bcddc
d6bd9e44e94ddd994e9489dd642d6dd94489d94e999e499dddeddd666bbfc48ededdedd96adcdddc3aaddd9d49edddccdddc33dcd3dde49aa9a9dcd846bcdcdd
49ad448e24fdd4944494e9ddd9dddbde8ed944e49944e84ecd2e4addd6b369ddeeddec4a9cdcdddc5a9dee9de4edddc1dddcccdcddedde9aada44ee4fbcddddd
ddadd8d2e9d4dd9e4e94846dd92ddd4e44894e49994e84de4dcd286d3dd6be8eddeeddedad3ddddc54ad84ade98dddccdddc33dcddaddd99aaaa4daadcccdddd
ddc42e8d8ad4de4448948edb6e8dddddf44f99499994de824eacd2edd66b64e8ededd469c6cddddc3e9e4ad9d4eddc13dd6c3cdcc5ddce949adaa6a3ccdcdddd
46d9d28d44cdd894e49e8466442ddddda8444e9944e2d8e8d826dd286d3d6ad8dedc4adabddddddc54ae9a4e9e2dddccdbdc3cd3ddfddd9999aaadbccdcddddd
cd4ddde84fddd4984e49846dde8dddcd4ee49e994e2d8edd8ed2dddde636dbe8eddde69cdcddddcc349aad949eddcdc3dddc3cdccdfdd2999dcbbccdccdddddd
dd4d8ed846ddd49e44e92edda4ddddded48e4294de8d2e6d8d48e6c28d369c98ddded9c4bdddddc13daa9dd4e8ddcdcddbdcdc1cdd9ddd9e6bbcc3cd1ddddddd
d4dd8dd8adddd84e449489dda82dedddda2ee49e8924999aded82addd866ad4eede4aaddcdedddcc3daad9e4eddddc1dd36c3dccdddded9dbc3cccdcdddddddd
8dddede2dddd2494e4e984d642eddcddd64824e42ee4e8da2e2ee46cd8cdd69dddd69c63dddddcd1bdaad4ee8ddddccdd3dccd3cddeddeda3cc3cddddddddddd
ddddde24fddd844e9444e4d648dddddc4d4ed9e9d484ed84d8d48edc286dad4dda69ca3cddddcc1c36aad44eddccd1cddcd3cdcc2cddd96bcccddcdcdddcdddd
edddde84addde4e489e88ad68ddedddc9d49844ede4994e8eddee2dcdd6ddd9d6d9d6dc2deddc1cc3da9dee8dddddccd4dcbcd3c836dd9dc3cc1ccccdddddddd
ddddee2d6dd2844e944e4ada2deddcdc9de4e94e82e6da4642e8486dddde4ddda64cdbddddccc1c3b6a9d4edddddccddbdcc3dcc8d6dedbcc1cc1dddddcddddd
ddded84fddd2e48e449e8d692deddddc4d4489ed846ddd99edde4d6dded6ddeddadfbcdddccdccc33da4e8ede2ddc1de3dcdcd3cdd6d46c3cccdddddddcddddd
dded8e4addd284e44e48edd9dedddcdd9de9d48e4dddd4f42ed899cdd8dd9fdada6dcddddddc1cc3b69de2dd4cdddcddbdc3dccddd6d9dc3cc1cdddddcdddddc
dd84d46dddde44e84e9846d48eddddcd4de92ee4edd6c2dee9de46dddedee436a36bcdddddcc1cc3b69d4eedddddcdd3dcc3dc3d3dddf3ccdcc1dddddcdddddd
d8eddfadddd84e8e4e4e9dd4e8ddddc9dda4e9286ddc6dd44a94addd8da4ddada6dcdddddcc1cc33fa9ee8eddddc1ed3dc3cdcc8dc6de3cc1ccddddccddddddc
2224ea3dddd2e84e4498fda8deddcdd4d6e429e2de4c62e9ea4e6dded66f4cafdd3cddddddcc1cc3dad4e2dedcc1dddbdccdd3cddcd46bccc1ccdddccddddddd
2eedacddddd8e84e4e48ada2d8deddd64de48ed8dd8c64d9e446c2ded6d44daaddcdddddcc1ccc3969de8ededccc4dbcc3cdc3dcdddfd3cc1cc1ddcddcdddcdd
d44acddddd88ed88e4eedda2eeddcdda4e92e48edd26e4de946dd26d6dd6da6debcddddcc1cc13b69d4e2ddd1c1ddfbdcc14ccd3cbd9bcccc1ccddddccdcccdc
8d6c653ddd8ed8e44e486a4ededdd6492ee29ed4ddedd49996cd86d6da6ddaaddccdddddcc1cc3a69deedddcccc4db3dcdcdcddbcddf3cc3cc1cddcdc1dddcdd
24cadddddde82e8e44e4d682eeddced4d48e48d6dde62ee4f3d86ddfa6bddaddbcc2cddcc1cc3569d4e2dddc2dddfbcc33dc3cddcdee3ccc1cccddcddccdcddd
ed63dcddded8e28e4e84da8d2eddddd9eed8eddd8ddde949ddedddadbadd6a6d3cddccdcc1c356ad4eddedccdcddb3dccc4c3cc5dd9dc3cccc1dcc1cdddddccd
4ddd3dddded8ee28e4e964ed8ddeddd44ed48e8dedd6ee96ddd6b66d6addaddbccddcdc1cc3bfad4e8dddcc1dddeb3dc3ddc3c36deebccc3ccc1cddccdcddcc1
dd6cddeddee28e2ee48ed4e8eddecd64e2e4e8dddd6e449c2d66dddaddd6a6d3cddcc1cc33bf95ee2dddcc1ccdebbdc3cdc3bc3dd4bcc3cc1ccc1dcc1ddccdcc
dd3dddddd8ee28e84eedae28ddddddd9ed84d8dddd6e496dd66496a6acdadebccd1ccccc336a4de2dddcc1cddd6b3c3cddcbccbdeebcc3ccc1cccdddccdccdc1
ddcddeddde8e82ee288d628eddedcdde8de8dedddddde9cdda8e296ddd9adbcc2cc1cc13b6adde8eddcdcd3cdebbdcdc2c3b3bcd9dcbcc3cc1cc1cdcc1dccdcc
dcddddddedd8e2e8ee46a2deddedcdd9dde2ecdcddee962d62ee4dfddad6dccdc1cccc3bead2ee2dcc1cd3dddabc33cdc3bbc3bde3bcccc1ccc1ccdccc1cc1dc
ddddddedee2ede8e4e4de2edddedcdeedd4de2d8ecd49dd682eedddda9dbcd1ccdc1c3beadd8deddccdc3cdd6b3c3cddc3bb3cdd6cc3cc3cccc1cc1dc1ccccdd
cdddddddee8ddee2e8d688ddedddcdd8dd8eddeddf996dd6dde4ddaa46bcdccdcc33bf69d4deeddcc13cdddeb3c3ccdc3bbbcbb663cc3cc1c1ccccccdccddccc
__label__
h111111111111111h111111111111111111hh111hhhhh111111hhhhh111111111111hhhhh111111111111111hhhh1111111111111111111hhhhhhhhhhhhhhhhh
11nn1nnn1nnn1nnn11nn1nnn1nnn1nnn1nn111nn1hhh11nn1nn1hhhh1nnn1n1n1nnn1hhh11nn1nnn1nnn1nnn1hhh1nnn1nnn1nnn1nnn1nn1hhhhhhhhhhhhhhhh
1n1111n11n1n1n1n1n111n1n111n11n11n1n1n111hhh1n1n1n1n1hhhh1n11n1n1n111hhh1n1111n11n1n1n1n1hhhh1n11n1n1n1n11n11n1n1hhhhhhhhhhhhhhh
1nnn11n11nnn1nn11n111nnn11n111n11n1n1n11hhhh1n1n1n1n1hhhh1n11nnn1nn1hhhh1nnn11n11nnn1nn11hhhh1n11nn11nnn11n11n1n1hhhhhhhhhhhhhhh
111n11n11n1n1n1n1n1n1n1n1n1111n11n1n1n1n1hhh1n1n1n1n1hhhh1n11n1n1n11hhhh111n11n11n1n1n1n1hhhh1n11n1n1n1n11n11n1n1hhhhhhhhhhhhhhh
1nn111n11n1n1n1n1nnn1n1n1nnn1nnn1n1n1nnn1hhh1nn11n1n1hhhh1n11n1n1nnn1hhh1nn111n11n1n1n1n1hhhh1n11n1n1n1n1nnn1n1n1hhhhhhhhhhhhhhh
11111111111111111111111111111111111111111hhhh111h1111hhhhh11h11111111hhhh111hh11h11111111hhhhh11h1111111111111111hhhhhhhhhhhhhhh
1nnn1nnn1n1hhhhh11nn11nn1n1n1n1n1nnn1nnn1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
1n1n1n1n1n1hhhhh1n111n111n1n1n1n11n1111n1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
1nn11nnn1n1hhhhh1nnn1n1h1nnn1n1n11n111n11hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhh
1n1n1n1n1n11hhhh111n1n111n1n1n1n11n11n11hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
1n1n1n1n1nnn1hhh1nn111nn1n1n11nn11n11nnn1hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
h111111111111hhhh111hh1111111h111h11h1111hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhdhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhohhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh9hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhnhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhcnbhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhoennnnnfohhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhbnchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhnhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhohhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhh
hhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhdhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhohhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh9hhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhnhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhcnbhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhoennnnnfohhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhbnchhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhnhhhhhhhhhhhhhhhhhhdhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhahhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhohhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhdhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhdhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh

__map__
100102030405060708090a0b0c0d0e0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
101112131415161718191a1b1c1d1e1f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
202122232425262728292a2b2c2d2e2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303132333435363738393a3b3c3d3e3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404142434445464748494a4b4c4d4e4f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
505152535455565758595a5b5c5d5e5f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
606162636465666768696a6b6c6d6e6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
707172737475767778797a7b7c7d7e7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
808182838485868788898a8b8c8d8e8f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
909192939495969798999a9b9c9d9e9f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0a1a2a3a4a5a6a7a8a9aaabacadaeaf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0b1b2b3b4b5b6b7b8b9babbbcbdbebf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c2c3c4c5c6c7c8c9cacbcccdcecf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d2d3d4d5d6d7d8d9dadbdcdddedf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e1e2e3e4e5e6e7e8e9eaebecedeeef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100010005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010801031805018130181200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010405081815018040180401803018030180301803018030180001800018000180001800018000180001800018000180001800018000280002800028000280000000000000280002800028000280002800028000
490801031805018131181210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001b05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000001d050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011700002690400900009000090026934269302a9342a9303193431932319323193231932319303295432950319543195032954329502f9642f96031964319602a9342a9322a9322a9322a9322a9322a9322a930
01170000128601286000000000000000000000000000000013a3013a3013a3013a3507a4007a4007a4007a4007a4007a4007a4007a4515a6015a6015a6015a650ea300ea300ea300ea300ea300ea300ea300ea35
011700000090000900009000090026944269402a9442a94028944289422894228942289422894026944269402394423942239422394026944269402a9442a9402894428942289422894228942289422894228940
0117000002a7000a0000a0000a0000a0000a0000a0000a0010a4010a4010a4010a4010a4010a4010a4010a4512a4012a4012a4012a4012a4012a4012a4012a4513a4013a4013a4013a4013a4013a4013a4013a45
0017000034b3000900009000090026934269302a9342a9303193431932319323193231932319303295432950319543195032954329502f9642f96031964319602a9342a9322a9322a9322a9322a9322a9322a930
0017000000a0000a0000a0000a0000a0000a0000a0000a0013a3013a3013a3013a3507a4007a4007a4007a4516a5016a5016a5016a5515a6015a6015a6015a650ea300ea300ea300ea300ea300ea300ea300ea35
001700000090000900009000090026944269402a9442a940289442894228942289422894228940269442694025944259422594225940219442194221942219402394423942239422394223942239422394223940
001700000ba7000a0000a0000a0000a0000a0000a0000a0013a4013a4013a4013a4013a4013a4013a4013a4513a4013a4013a4013a4013a4013a4013a4013a4506a4006a4006a4006a4006a4006a4006a4006a45
001700000000000000000000000000000000000000000000170401704017040170401704017040170401704016040160401604016040160401604016040160401004010040100401004010040100401004010040
011700002a97400900009000090026934269302a9342a9303193431930009000090000900009003294432942329423294031954009002f9640090031964009002a9342a9322a9322a93000900009000090000900
0017000012a4012a4500a0000a0000a0000a0000a0000a0013a3013a3507a3007a3517a4017a4017a4017a4515a5015a5509a5009a5513a6013a6013a6013a6517a3017a3502a3002a3515a3015a3015a3015a35
011700000000000000000000000000000000000000000000000000000000000000001a0401a0401a0401a040000000000000000000001c0601c0601c0601c060000000000000000000001a0301a0301a0301a030
0117000036b002fb002fb002ab0026934269302a9342a93028934289322893228932289322893026934269302393423932239322393026934269302a9342a9302893428932289322893228932289322893228930
0017000018a3018a3502a3002a3512a3012a3012a3012a3507a3007a3007a3007a3512a3012a3012a3012a3502a3002a3002a3002a3512a3012a3012a3012a3509a3009a3009a3009a3513a3013a3013a3013a35
001700000000000000000000000018030180301803018030000000000000000000001703017030170301703000000000000000000000170301703017030170300000000000000000000019030190301903019030
0017000004a3004a3004a3004a3512a3012a3012a3012a3513a3013a3507a4007a4517a4017a4017a4017a4515a5015a5509a5009a5513a6013a6013a6013a6517a3017a3502a3002a3515a3015a3015a3015a35
001700000000000000000000000018030180301803018030000000000000000000001a0401a0401a0401a040000000000000000000001c0601c0601c0601c060000000000000000000001a0301a0301a0301a030
001700000090000900009000090026934269302a9342a930289342893228932289322893228930269342693025934259322593225930219342193221932219302393423932239322393223932239322393223930
0017000018a3018a3502a3002a3512a3012a3012a3012a3507a3007a3007a3007a3512a3012a3012a3012a3507a3007a3007a3007a3512a3012a3012a3012a3512a3012a3506a3006a3517a3017a3017a3017a35
00170000000000000000000000001803018030180301803000000000000000000000170301703017030170300000000000000000000016030160301603016030000000000000000000001c0301c0301c0301c030
011708002a14500000000000000000000000000000000000014000140001400014000140001400014000140001400014000140001400014000140001400014000140001400014000140001400014000140001400
001700003694500900009000090000900009000090000900009000090000900009000090000900009000090000900009000090000900009000090000900009000090000900009000090000900009000090000900
912d000028134281251c114001001c1341c1201c1150010028134281251c114001001c13426134281342a13426134261251a114001001a1341a1201a1150010026134261251a114001001a1341a1352a1342a135
002d00000090012940199400090019940199401994012940009001294019940009001994019940199401294000900109401794000900179401794017940109400090010940179400090017940179401794010940
002d00000204002040020400204002040020400204002040020400204002040020400204002040020400204000040000400004000040000400004000040000400004000040000400004000040000400004000040
912d000028134281251a1141a1051a1341a1201a1150010028134281251a1141a1051c13426134281342a1342d1442d1251c1441c1251c1141c1101c115001002d1442d125341353410038145381003810000100
001700003193431932319323193231932319303295432950319543195032954329502f9642f96031964319602a9342a9322a9322a9322a9322a9322a9322a9300090000900009000090028934289302b9342b930
012d000000900129401794000900179401794017940129400090012940179400090012940129401294000900009001494015940009001594015940159400090000900009003db353d9003bb453b9003b90000900
002d00000704007040070400704007040070400704007040070400704007040070400704007040070400704009040090400904009040090400904009040090400904009040090400904009040090400904009040
912d0000301343012518114181001813418120181101810530134301251811418100181242d134341343213431144311151a144321142f1442f1202f115311442d1442d1151a1441a1152d1442d1202d11500100
002d00000090000900139401394013940139401394013940009000090013940139401394013940139401394000900009001594015940159401594015940159400090000900149401494014940149400393003930
002d0000080400804008040080400804008040080400804008040080400804008040080400804008040080400b0400b0400b0400b0400b0400b0400b0400b0400b0400b0400b0400b0400b0400b0400b0400b040
912d00002b1442b1302b1202b1102b1202b1102b1202b1152d1442d1302d1202d1153b1243911436124341142614426130261202611026120261102612026115261442613026120261150010000100261342a134
012d000034b5034b3034b2034b1034b2034b1034b001cb0234b5034b3034b1034b2000b0000b0000b0000b0032b5032b2032b2032b2032b2032b2032b2032b202fb502fb302fb202fb1001b0001b0001b0001b00
002d00001094010940109401094004940049400e9400e9401294012940129401294014940149401494014940159401594015940159400994009940009000090000900009000c9400c94009940099400093000930
001700001303013030070400704017040170401704017040150501505009050090501306013060130601306017030170300203002030150301503015030150301803018030020300203012030120301203012030
001700001aa401aa401aa401aa4000a0000a0000a0000a001ca601ca601ca601ca6000a0000a0000a0000a001aa301aa301aa301aa3000a0000a0000a0000a0018a3018a3018a3018a3000a0000a0000a0000a00
001718002a9342a9322a9322a9322a9322a9322a9322a9302a9342a93028934289302693426930289342893026934269322693226932269322693226932269300190001900019000190001900019000190001900
011718001303013030070300703017030170301703017030150301503009030090301303013030130301303006030060300603006030120301203012030120301280012800014000140001400014000140001400
001718001aa301aa301aa301aa3000a0000a0000a0000a001ca301ca301ca301ca3000a0000a0000a0000a0019a3019a3019a3019a3001a0001a0001a0001a0001a0001a0001a0001a0001a0001a0001a0001a00
__music__
01 48480908
00 4a4a0b0a
00 4c4c0d0c
00 4e0e0f10
00 51111213
00 54141516
00 4c0c1718
00 59191a1b
00 5c5d1c1d
00 5e1e1f20
00 61212324
00 65252627
00 68292a28
00 622b2c22
02 6d2e2f2d

