-- TODO:
-- Add OOP for buttons

lf = love.filesystem
ls = love.sound
la = love.audio
lp = love.physics
lt = love.thread
li = love.image
lg = love.graphics
lm = love.mouse
width = lg.getWidth()
height = lg.getHeight()

function love.load()
	-- Images
    logo = lg.newImage("assets/images/snail studios logo.png");
    backgroundimage = lg.newImage("assets/images/background placeholder.png");
	titlescreen = lg.newImage("assets/images/title_screen.png")
	playbutton = lg.newImage("assets/images/play button.png")
	optionsbutton = lg.newImage("assets/images/settings button.png")
	castle = lg.newImage("assets/images/castle.png")
	sunnyhut = lg.newImage("assets/images/sunnyhut.png")
	taco = lg.newImage("assets/images/Taco_Guy.png")
	rainbow = lg.newImage("assets/images/rainbow.png")
	sscpeek = lg.newImage("assets/images/tacothoughts.png")
	mainhud = lg.newImage("assets/images/mainhud.png")

	icon = {"assets/images/normalicon.png", "assets/images/enemyicon.png", "assets/images/spbg.png", "assets/images/eks.png", "assets/images/royalknighticon.png", "assets/images/badroyalknighticon.png"}
	unit = {"assets/images/soldier.png", "assets/images/enemyknight.png", "assets/images/spnk.png", "assets/images/spek.png", "assets/images/royalknight.png", "assets/images/badroyalknight.png"}
	bodyparts = {"assets/images/normalesquireleftarm.png", "assets/images/normalesquirehead.png", "assets/images/normalesquirebody.png", "assets/images/normalesquirerightarm.png", "assets/images/normalleftleg.png", "assets/images/normalrightleg.png"}

	-- Audio

	audio3 = love.audio.newSource("assets/sfx/Retro-Night.mp3", "static")
	audio2 = love.audio.newSource("assets/sfx/Dark-winters-night.mp3", "static")
	audio = love.audio.newSource("assets/sfx/Tokyo-bells.mp3", "static")

	sfx1 = love.audio.newSource("assets/sfx/sfx1.mp3", "static")
	sfx2 = love.audio.newSource("assets/sfx/sfx2.mp3", "static")
end

-- Variables

unitX = {100} unitY = {100} unitSelect = {} unitsize = {313, 417} unitspeed = 5 playerspeed = 5
destinationX = {} destinationY = {}
xadd = 0 yadd = 0 direction = "horizontal" maxX = 0 maxY = 0 unitselectednum = 0
easteregg = false eggtimer = 200 introtexttime = 500

mousedrag = 0 mousedragcoord = {} -- x, y, w, h

x = 0 y = 0

--v 0.2.2
movement = {false, false, false, false}

--v 0.2.3
page = "intro"
menuintro = 0
menuoutro = 200

--v 0.2.4
audiotoggle = true

--v 0.2.6.2
sfxplayed = {}

--v 0.2.7
unittype = {0}

--v 0.3
version = love.window.getTitle()
battlemusic = false
battletime = 0

--v 0.3.0.2
code = ""
aa = 1664525
ac = 1013904223
am = math.pow(2, 32)
aseed = 1

function createButton(id, image, x, y, scale, func)
	if mouseX > x - image:getWidth()/2*scale and mouseY > y - image:getHeight()/2*scale and mouseX < x + image:getWidth()/2*scale and mouseY < y + image:getHeight()/2*scale then
		lg.draw(image, x, y, -0.1, scale+0.05, scale+0.05, image:getWidth()/2, image:getHeight()/2)
		if sfxplayed[id] == false and audiotoggle == true then
            sfx1:play()
			sfxplayed[id] = true
        end

		if lm.isDown(1) then
			func()
		end
	else
		lg.draw(image, x, y, 0, scale, scale, image:getWidth()/2, image:getHeight()/2)
		sfxplayed[id] = false
	end
end

function love.draw()
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()

	if page == "intro" then
        if audiotoggle == true then
            audio:setVolume(0.5);
			audio:setLooping(true)
            audio:play();
        end

        lg.setBackgroundColor(0, 0, 0)

        if menuintro < logo:getHeight()*1.1 then
            menuintro = menuintro + 1
        else
            page = "menu"
        end

		lg.setColor(255, 255, 255, 255)
        lg.draw(logo, width/2, height/2, 0, 0.5+menuintro/logo:getWidth()/2, 0.5+menuintro/logo:getHeight()/2, logo:getWidth()/2, logo:getHeight()/2);
		lg.setColor(0, 0, 0, -300 + menuintro/(logo:getHeight()/1.5)*355)
        lg.rectangle("fill", 0, 0, width, height)
		lg.setColor(255, 255, 255, 255)
    end

	if page == "menu" then
		lg.draw(titlescreen, 0, 0, 0, width/titlescreen:getWidth(), height/titlescreen:getHeight())

		sfx1:setVolume(0.7)

		-- Buttons
		createButton(1, playbutton, 150, 190, 0.2, function() page = "game" end)
		createButton(2, optionsbutton, 150, 380, 0.2, function() page = "options" end)
	end
end