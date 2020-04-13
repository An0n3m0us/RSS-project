-- TODO:
-- Add OOP for buttons

la = love.audio
lf = love.filesystem
lg = love.graphics
li = love.image
lk = love.keyboard
lm = love.mouse
lp = love.physics
ls = love.sound
lt = love.thread
lw = love.window
width = lg.getWidth()
height = lg.getHeight()

function love.load()
    -- Images
    logo = lg.newImage("assets/images/snail studios logo.png")
    backgroundimage = lg.newImage("assets/images/background placeholder.png")
    titlescreen = lg.newImage("assets/images/title_screen.png")
    playbutton = lg.newImage("assets/images/play button.png")
    settingsbutton = lg.newImage("assets/images/settings button.png")
    castle = lg.newImage("assets/images/castle.png")
    sunnyhut = lg.newImage("assets/images/sunnyhut.png")
    taco = lg.newImage("assets/images/Taco_Guy.png")
    rainbow = lg.newImage("assets/images/rainbow.png")
    sscpeek = lg.newImage("assets/images/tacothoughts.png")
    mainhud = lg.newImage("assets/images/mainhud.png")

    icon = {
        lg.newImage("assets/images/normalicon.png"),
        lg.newImage("assets/images/enemyicon.png"),
        lg.newImage("assets/images/spbg.png"),
        lg.newImage("assets/images/eks.png"),
        lg.newImage("assets/images/royalknighticon.png"),
        lg.newImage("assets/images/badroyalknighticon.png")
    }
    unit = {
        lg.newImage("assets/images/soldier.png"),
        lg.newImage("assets/images/enemyknight.png"),
        lg.newImage("assets/images/spnk.png"),
        lg.newImage("assets/images/spek.png"),
        lg.newImage("assets/images/royalknight.png"),
        lg.newImage("assets/images/badroyalknight.png")
    }
    bodyparts = {
        lg.newImage("assets/images/normalesquireleftarm.png"),
        lg.newImage("assets/images/normalesquirehead.png"),
        lg.newImage("assets/images/normalesquirebody.png"),
        lg.newImage("assets/images/normalesquirerightarm.png"),
        lg.newImage("assets/images/normalleftleg.png"),
        lg.newImage("assets/images/normalrightleg.png")
    }

    -- Audio
    audio3 = la.newSource("assets/sfx/Retro-Night.mp3", "static")
    audio2 = la.newSource("assets/sfx/Dark-winters-night.mp3", "static")
    audio = la.newSource("assets/sfx/Tokyo-bells.mp3", "static")

    sfx1 = la.newSource("assets/sfx/sfx1.mp3", "static")
    sfx2 = la.newSource("assets/sfx/sfx2.mp3", "static")

    settingsfont = lg.newFont(36)
    settingsfont2 = lg.newFont(50)
    gamefont = lg.newFont((width + height)/100)
    introfont = lg.newFont((width+height)/25)
end

-- Variables

unitX = {100}
unitY = {100}
unitSelect = {}
unitsize = {313, 417}
unitspeed = 5
playerspeed = 5
destinationX = {0}
destinationY = {0}
xadd = 0
yadd = 0
direction = "horizontal"
maxX = 0
maxY = 0
unitselectednum = 0
easteregg = false
eggtimer = 200
introtexttime = 500

mousedrag = 0
mousedragcoord = {} -- x, y, w, h

x = 0
y = 0

--v 0.2.3
page = "intro"
menuintro = 0
menuoutro = 200

--v 0.2.4
audiotoggle = true

--v 0.2.6.2
sfxplayed = {false, false}

--v 0.2.7
unittype = {0}

--v 0.3
version = lw.getTitle()
battlemusic = false
battletime = 0

--v 0.3.0.2
code = ""
aa = 1664525
ac = 1013904223
am = math.pow(2, 32)
aseed = 1

--v a0.3.1
selectedunits = 0
unitpanelgraphic = function(x, y, w, h, ID)
    --background panel
    --image(icon[unittype[ID]], x, y, w, h)
    lg.draw(icon[unittype[ID]], x, y, 0, w, h, icon[unittype[ID]]:getWidth() / 2, icon[unittype[ID]]:getHeight() / 2)

    --health bar!
    strokeWeight(1)
    fill(100, 0, 0)
    rect(x + width / 200, y + height / 100, w - width / 100, h / 10)
    fill(255, 0, 0)
    rect(
        x + width / 200,
        y + height / 100,
        (w - width / 100) * (unithealth[ID] / unitmaxhealth[round((unittype[ID] - 1) / 2)]),
        h / 10
    )

    --health text
    fill(0)
    textAlign(CENTER, CENTER)

    if h > 100 then
        textSize(14)
    end
    if h < 100 and h > 10 then
        textSize(10)
    end

    text(
        unithealth[ID] + "/" + unitmaxhealth[round((unittype[ID] - 1) / 2)],
        x + width / 200 + (w - width / 100) / 2,
        y + height / 100 + h / 20
    )

    if h > 100 then
        textSize((width + height) / 250)
    end
    if h < 100 and h > 10 then
        textSize((width + height) / 300)
    end

    fill(150, 150, 0)
    text(unitname[round((unittype[ID] - 1) / 2)], x + width / 200 + (w - width / 100) / 2, y + height / 100 + h / 5)
end

IDredirect = {}
unithealth = {10}
ocatwords = ""

--v a0.4
attacked = {}
attackcooldown = {}

--v a0.5.2
mpd = false

--v a0.5.3
unitmaxhealth = {10, 50, 20}

--v a0.6
paused = false
unitname = {"Esquire", "Knight", "Royal Esquire"}

--v a0.7
ar = {-1} --rotation position
ad = {false} --direction
as = {0.1} --animation speed
zoom = 2 --self explanatory

unitanimation = {"idle"}

t1a = {-15, 0, -3, -10, 0, 0}
t2a = {-38, -63, 0, -42, 68, 70}
ra = {0, 0, 0, 0, 0, 0}
ixa = {-114 / 2, -52 / 2, -52 / 2, -48 / 2, -30 / 2, -38 / 2}
iya = {-40 / 2, -90 / 2, -134 / 2, -28 / 2, -10 / 2, -20 / 2}
iwa = {131, 57, 52, 41, 62, 61}
iha = {165, 62, 134, 115, 107, 116}

bodypart = function(t1, t2, r, l, ix, iy, iw, ih)
    lg.push()
    lg.translate(-10, -42)
    lg.setPointSize(10)
    lg.points(0, 0)
    lg.draw(l, -48/2, -28/2, math.rad(r), iw/l:getWidth(), ih/l:getHeight())

    lg.setColor(1, 1, 1, 1)
    lg.rectangle("fill", 50, 50, 50, 50)
    lg.rotate(5)
    lg.rectangle("fill", 50, 50, 50, 50)
    lg.pop()
end

function love.keypressed(key)
    code = code .. key

    if page == "game" then
        if paused == false then
            if tonumber(key) ~= nil then
                if tonumber(key) > 0 and tonumber(key) < 7 then
                    unitX[#unitX] = mouseX + x
                    unitY[#unitY] = mouseY + y
                    unittype[#unittype] = tonumber(key) - 1
                    unithealth[#unithealth] = unitmaxhealth[math.floor(((tonumber(key) - 2) / 2) + 0.5)]
                    ar[#ar] = -1
                    ad[#ad] = false
                    as[#as] = 0.1
                    zoom = 1
                    unitanimation[#unitanimation] = "idle"
                end
            end
        end
    end
end

function love.update(dt)
    if page == "game" then
        if paused == false then
            if lk.isDown("w") then
                y = y - playerspeed
            end
            if lk.isDown("a") then
                x = x - playerspeed
            end
            if lk.isDown("s") then
                y = y + playerspeed
            end
            if lk.isDown("d") then
                x = x + playerspeed
            end
        end

        -- Escape
        if lk.isDown("p") then
            if paused == true then
                paused = false
            else
                paused = true
            end
        end

        -- Return to menu
        if paused == true then
            if lk.isDown("m") then
                page = "menu"
                paused = false
            end
        end
    end
end

--[[
buttons = {}
function createButton(id, image, x, y, scale, func)
	if buttons[tostring(id)] == nil then
		buttons[tostring(id)] = {sfx1 = false, sfx2 = false}
	end

	-- print(y) -- Why are both values printed and used?
	if mouseX > (x - (image:getWidth()*scale)/2) and mouseY > (y - (image:getHeight()*scale)/2)
	and mouseX < (x + (image:getWidth()*scale)/2) and mouseY < (y + (image:getHeight()*scale)/2) then
		lg.draw(image, x, y, -0.1, scale+0.05, scale+0.05, image:getWidth()/2, image:getHeight()/2)
		if buttons[tostring(id)].sfx1 == false and audiotoggle == true then
            sfx1:play()
			buttons[tostring(id)].sfx1 = true
        end

		if lm.isDown(1) then
			if buttons[tostring(id)].sfx2 == false and audiotoggle == true then
		        sfx2:play()
				buttons[tostring(id)].sfx2 = true
		    end
			func()
		else
			buttons[tostring(id)].sfx2 = false
		end
	else
		lg.draw(image, x, y, 0, scale, scale, image:getWidth()/2, image:getHeight()/2)
		buttons[tostring(id)].sfx1 = false
	end
end
--]]


function love.draw()
    mouseX = lm.getX()
    mouseY = lm.getY()

    -- Settings page
    if page == "settings" then
        lg.setBackgroundColor(0, 0, 0)
        lg.setFont(settingsfont)

        -- Glow effect
        for glowy = 1, 25 do
            lg.setColor(1, 1, 1, 1 / 255)
            lg.ellipse("fill", mouseX, mouseY, glowy * 20, glowy * 20)
        end

        -- "Yes" button
        if
            mouseX > width / 5 and mouseY > (9 * height) / 20 and mouseX < (3 * width) / 10 and
                mouseY < (11 * height) / 20
         then
            lg.setColor(100 / 255, 100 / 255, 100 / 255)

            -- Check if mouse clicked
            if lm.isDown(1) then
                page = "menu"
                audiotoggle = true
                audio:play()
            end
        else
            lg.setColor(50 / 255, 50 / 255, 50 / 255)
        end
        lg.rectangle("fill", width / 5, (9 * height) / 20, width / 10, height / 10)

        -- "No" button
        if
            mouseX > (7 * width) / 20 and mouseY > (9 * height) / 20 and mouseX < (4 * width) / 5 and
                mouseY < (11 * height) / 20
         then
            lg.setColor(100 / 255, 100 / 255, 100 / 255)

            -- Check if mouse clicked
            if lm.isDown(1) then
                page = "menu"
                audiotoggle = false
                audio:stop()
                audio2:stop()
            end
        else
            lg.setColor(50 / 255, 50 / 255, 50 / 255)
        end
        lg.rectangle("fill", (7 * width) / 10, (9 * height) / 20, width / 10, height / 10)

        lg.setColor(1, 1, 1)
        lg.printf("Yes", -width / 4, height / 2 - 21.5, width, "center")
        lg.printf("No", width / 4, height / 2 - 21.5, width, "center")

        lg.setFont(settingsfont2)
        lg.printf("Do you want audio?", 0, height / 4 - 22, width, "center")

        lg.setFont(settingsfont)
    end

    if page == "intro" then
        -- Set BGM
        if lm.isDown(1) then
            page = "menu"
        end
        if audiotoggle == true then
            audio:setVolume(0.5)
            audio:setLooping(true)
            audio:play()
        end

        lg.setBackgroundColor(0, 0, 0)

        -- Check if intro is done
        if menuintro < logo:getHeight() * 1.1 then
            menuintro = menuintro + 1
        else
            page = "menu"
        end

        -- Logo
        lg.setColor(1, 1, 1)
        lg.draw(logo, width / 2, height / 2, 0, 0.5 + menuintro / logo:getWidth() / 2, 0.5 + menuintro / logo:getHeight() / 2, logo:getWidth() / 2, logo:getHeight() / 2)

        -- Fade out
        lg.setColor(0, 0, 0, (-300 + menuintro / (logo:getHeight() / 1.5) * 355) / 255)
        lg.rectangle("fill", 0, 0, width, height)
        lg.setColor(1, 1, 1)
    end

    -- Menu page
    if page == "menu" then
        lg.draw(titlescreen, 0, 0, 0, width / titlescreen:getWidth(), height / titlescreen:getHeight())

        sfx1:setVolume(0.7)
        sfx2:setVolume(0.5)

        --createButton(1, playbutton, 150, 190, 0.2, function() page = "game" end)
        --createButton(2, settingsbutton, 150, 380, 0.2, function() page = "settings" end)

        -- Play button
        -- Check if mouse over
        if
            mouseX > width / 12 and mouseY > height / 4.6 and mouseX < width / 12 + width / 6 and
                mouseY < height / 4.6 + height / 7
         then
            lg.draw(playbutton, 150, 190, -0.1, 0.25, 0.25, playbutton:getWidth() / 2, playbutton:getHeight() / 2)

            -- Check if sound is enabled
            if sfxplayed[1] == false and audiotoggle == true then
                sfx1:play()
                sfxplayed[1] = true
            end

            -- Check if mouse clicked
            if lm.isDown(1) then
                page = "game"

                -- Play sound
                if audiotoggle == true then
                    sfx2:play()
                end

                -- Random something
                for nmbgen = 0, 1000 do
                    aseed = math.floor(((aa * aseed + ac) % am) + 0.5)
                end
            end
        else
            lg.draw(playbutton, 150, 190, 0, 0.2, 0.2, playbutton:getWidth() / 2, playbutton:getHeight() / 2)
            sfxplayed[1] = false
        end

        -- Settings button
        -- Check if mouse over
        if
            mouseX > width / 12 and mouseY > height / 1.9 and mouseX < width / 12 + width / 6 and
                mouseY < height / 1.9 + height / 7
         then
            lg.draw(settingsbutton, 150, 380, -0.1, 0.25, 0.25, settingsbutton:getWidth() / 2, settingsbutton:getHeight() / 2)

            -- Check if sound is enabled
            if sfxplayed[2] == false and audiotoggle == true then
                sfx1:play()
                sfxplayed[2] = true
            end

            -- Check if mouse clicked
            if lm.isDown(1) then
                page = "settings"

                -- Play sound
                if audiotoggle == true then
                    sfx2:play()
                end
            end
        else
            lg.draw(settingsbutton, 150, 380, 0, 0.2, 0.2, settingsbutton:getWidth() / 2, settingsbutton:getHeight() / 2)
            sfxplayed[2] = false
        end
    end

    -- Game page
    if page == "game" then
        -- "Main settings"
        if "main settings" then
            audio:setVolume(0.5)
            audio2:setVolume(0.5)

            -- Check if sound is enabled
            if audiotoggle == true then
                if battlemusic == true then
                    audio2:play()
                    audio:pause()
                    if battletime < 600 then
                        battletime = battletime + 1
                    else
                        battlemusic = false
                    end
                else
                    audio:play()
                    audio2:pause()
                end
            end

            -- Background
            lg.setBackgroundColor(100 / 255, 100 / 255, 100 / 255)

            -- General settings
            --stroke(50) -- MIGHT NEED CHANGING
            lg.setLineWidth(10)
            lg.setLineStyle("smooth")
            lg.setFont(gamefont)
        end

        if "map" then
            lg.draw(backgroundimage, -x, -y, 0, width / backgroundimage:getWidth(), height / backgroundimage:getHeight())
            lg.draw(castle, width - x, -y, 0, width / castle:getWidth(), height / castle:getHeight())
            lg.draw(sunnyhut, -width / 2 - x, -y, 0, width / sunnyhut:getWidth() / 2, height / sunnyhut:getHeight())
            --lg.printf(aseed, width*10 - x, -y, width, "center")
        end

        -- Version
        if introtexttime > 0 then
            introtexttime = introtexttime - 1
            lg.setColor(0, 0, 0, introtexttime/255)
            lg.printf("Last Major: Ported to the Löve2D engine!", 0, height/4 - 70, width, "center")
            lg.setFont(introfont)
            lg.printf(version .. ":\n\n", 0, height/4 - 150, width, "center")
            lg.setColor(1, 1, 1, 1)
        end

        -- Drawing the units!
        for drawunit = 1, #unitX do
            -- Movement
            if (destinationX[drawunit] > 0 or destinationX[drawunit] < 0) and paused == false then
                unitX[drawunit] = unitX[drawunit] + unitspeed*(destinationX[drawunit] - unitX[drawunit])/(math.abs(destinationX[drawunit] - unitX[drawunit]) + math.abs(destinationY[drawunit] - unitY[drawunit]))
                unitY[drawunit] = unitY[drawunit] + unitspeed*(destinationY[drawunit] - unitY[drawunit])/(math.abs(destinationX[drawunit] - unitX[drawunit]) + math.abs(destinationY[drawunit] - unitY[drawunit]))
                unitanimation[drawunit] = "walk"
            end

            if math.abs(unitX[drawunit] - destinationX[drawunit]) < unitspeed and math.abs(unitY[drawunit] - destinationY[drawunit]) < unitspeed then
                destinationX[drawunit] = ""
                destinationY[drawunit] = ""
                unitanimation[drawunit] = "idle"
            end

            -- Animation logic
            if ar[drawunit] > 1 then
                ad[drawunit] = false
            end
            if ar[drawunit] < -1 then
                ad[drawunit] = true
            end
            if ad[drawunit] == true then
                ar[drawunit] = ar[drawunit] + as[drawunit]
            end
            if ad[drawunit] == false then
                ar[drawunit] = ar[drawunit] - as[drawunit]
            end

            --unit draw
            if unitSelect[drawunit] == true then
                lg.setColor(0, 1, 1, 100/255)
            else
                lg.setColor(0, 0, 0, 0)
            end
                
            --selection thing
            lg.rectangle("line", unitX[drawunit] - x - unitsize[1]/8, unitY[drawunit] - y - unitsize[2]/4, unitsize[1]/4, unitsize[2]/2)

            lg.setColor(1, 1, 1)

            --actual unit drawing!
            if unittype[drawunit] > 0 then
                lg.draw(unit[unittype[drawunit]], unitX[drawunit] - x - unitsize[1]/4, unitY[drawunit] - y - unitsize[2]/4, unitsize[1]/2, unitsize[2]/2)
            else
                lg.push()
                lg.translate(unitX[drawunit] - x, unitY[drawunit] - y) -- Coordinates

                --animation!
                if unitanimation[drawunit] == "walk" then
                    as[drawunit] = 0.1
                    --rotate(ar[drawunit]/50)
                    ra[1] = ar[drawunit]/30
                    ra[2] = ar[drawunit]/30
                    ra[3] = ar[drawunit]/100
                    ra[4] = -ar[drawunit]/10
                    ra[5] = -ar[drawunit]
                    ra[6] = ar[drawunit]
                end
                if unitanimation[drawunit] == "idle" then
                    as[drawunit] = 0.03
                    lg.rotate(math.rad(ar[drawunit]/100))
                    ra[1] = ar[drawunit]/50 -- L_ARM
                    ra[2] = ar[drawunit]/50 -- HEAD
                    ra[3] = 0 -- BODY?
                    ra[4] = -ar[drawunit]/50 -- R_ARM
                    ra[5] = -ar[drawunit]/50 -- L_LEG
                    ra[6] = -ar[drawunit]/50 -- R_LEG
                end
                
                for bpd = 1, 1 do -- 6
                    --bodypart(t1a[bpd]/zoom, t2a[bpd]/zoom, ra[bpd], bodyparts[bpd], ixa[bpd]/zoom, iya[bpd]/zoom, iwa[bpd]/zoom, iha[bpd]/zoom)
                    bodypart(t1a[bpd], t2a[bpd], ra[bpd], bodyparts[bpd], ixa[bpd], iya[bpd], iwa[bpd], iha[bpd])
                end
                lg.pop()
            end

            --destination flag
            if destinationX[drawunit] > 0 or destinationX[drawunit] < 0 then
                lg.setColor(0, 0, 0)
                lg.setFont(gamefont)
                lg.printf(drawunit, destinationX[drawunit] - x, destinationY[drawunit] - y, width, "center")
            end

            --castle achievement!
            if unitX[drawunit] > width and unitY[drawunit] > 0 and unitX[drawunit] < width*2 and unitY[drawunit] < height then
                easteregg = true
            end
            
            --dying system!
            for collision = 1, #unitX do
                if unitX[drawunit] + unitsize[1]/4 > unitX[collision] and unitY[drawunit] + unitsize[2]/4 > unitY[collision] and unitX[drawunit] - unitsize[1]/4 < unitX[collision] and unitY[drawunit] - unitsize[2]/4 < unitY[collision] and unittype[drawunit]%2 ~= unittype[collision]%2 and paused == false then
                    if attacked[drawunit] ~= true then
                        unithealth[collision] = unithealth[collision] - 1
                        attacked[drawunit] = true
                        attackcooldown[drawunit] = 50
                    end
                    if unithealth[drawunit] < 2 then
                        unitX.splice(drawunit, 1)
                        unitY.splice(drawunit, 1)
                        unittype.splice(drawunit, 1)
                        destinationX.splice(drawunit, 1)
                        destinationY.splice(drawunit, 1)
                        unitSelect.splice(drawunit, 1)
                        unithealth.splice(drawunit, 1)
                    end

                    battlemusic = true
                    battletime = 0

                    if attackcooldown[drawunit] > 0 then
                        attackcooldown[drawunit] = attackcooldown[drawunit] - 1
                    else
                        attacked[drawunit] = false
                    end
                end
            end
        end
    end
end

