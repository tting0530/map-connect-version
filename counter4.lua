-----------------------------------------------------------------------------------------
--
-- counter4.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- 랜덤함수
math.randomseed(os.time())

-- 라이브러리
local widget = require("widget")
local physics = require("physics")

-- 음악
local backgroundMusic = audio.loadStream( "music/counter.mp3" )
local clickMusic = audio.loadStream( "music/click.mp3" )
local denyMusic = audio.loadStream( "music/deny.wav" )
local calcKimbapMusic = audio.loadStream( "music/calcKimbap.mp3" )

local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=0, fadein=2000 } )
-- 변수
money = 0

-- GUI
local background = {} -- 1:초등학교, 2:트럭
local leftUI = {} -- 1:체력, 2:얼굴, 3:금액표시창, 4:금액표시
local rightUI = {} -- 1:환경설정, 2:레시피토글, 3:화면전환, 4:레시피오픈
local gameUI = {} -- 1:저금통, 2:저금통금액표시, 3:탁상달력,
local orderUI = {} -- 1:주문말풍선, 2:주문글, 3:주문수락, 4:주문거절
local person = {} -- 초등학생1, 초등학생2, 초등학생3
local kimbap = {}

function scene:create( event )
	local sceneGroup = self.view

	--추가 현재 스테이지 넘버를 levelup씬에 넘겨줌
	local stageNum = 4
	composer.setVariable("stageNum", stageNum)

	background[1] = display.newImageRect("img/elementaryschool.png", 1250, 460)
	background[1].x, background[1].y = display.contentWidth/2, 290
	background[2] = display.newImageRect("img/truck.png", display.contentWidth, display.contentHeight)
	background[2].x, background[2].y = display.contentWidth/2, display.contentHeight/2

	leftUI[1] = display.newImageRect("img/hp.png", 300, 30)
	leftUI[1].x, leftUI[1].y = 220, 40
	leftUI[2] = display.newImageRect("img/mara.png", 60, 60)
	leftUI[2].x, leftUI[2].y = 50, 40
	leftUI[3] = display.newImageRect("img/money.png", 350, 60)
	leftUI[3].x, leftUI[3].y = 200, 100
	leftUI[4] = display.newText("0원", 180, 107, "굴림")
	leftUI[4].text = string.format("%d원", money)
	leftUI[4].size = 30
	leftUI[4]:setFillColor(0)

	rightUI[1] = display.newImageRect("img/setting.png", 70, 70)
	rightUI[1].x, rightUI[1].y = display.contentWidth - 50, 50
	rightUI[2] = display.newImageRect("img/recipe.png", 70, 70)
	rightUI[2].x, rightUI[2].y = display.contentWidth - 120, 50
	rightUI[3] = display.newImageRect("img/arrow.png", 70, 70)
	rightUI[3].x, rightUI[3].y = display.contentWidth - 190, 50
	rightUI[4] = display.newImageRect("img/recipe_over.png", 300, 200)
	rightUI[4].x, rightUI[4].y = display.contentWidth - 180, 200
	rightUI[4].alpha = 0
	
	--추가--맵에서 없어지게 하기위함
	composer.setVariable("leftUI[2]", leftUI[2])
	composer.setVariable("rightUI[1]", rightUI[1])
	composer.setVariable("rightUI[2]", rightUI[2])

	gameUI[1] = display.newImageRect("img/bank.png", 160, 120)
	gameUI[1].x, gameUI[1].y = display.contentWidth - 130, display.contentHeight - 100
	gameUI[2] = display.newText("", display.contentWidth - 130, display.contentHeight - 165, "굴림")
	gameUI[2].size = 30
	gameUI[2]:setFillColor(0)
	gameUI[2].alpha = 1
	gameUI[3] = display.newImageRect("img/calendar.png", 130, 130)
	gameUI[3].x, gameUI[3].y = 130, display.contentHeight - 100

	orderUI[1] = display.newImageRect("img/bubble.png", 500, 250)
	orderUI[1].x, orderUI[1].y = 850, 250
	orderUI[2] = display.newImageRect("img/accept.png", 110, 50)
	orderUI[2].x, orderUI[2].y = 780, 300
	orderUI[3] = display.newImageRect("img/deny.png", 110, 45)
	orderUI[3].x, orderUI[3].y = 900, 301
	orderUI[4] = display.newText("마라선생님! \n꼬마김밥 주세요.", 850, 220, "굴림")
	orderUI[4].size = 30
	orderUI[4]:setFillColor(0)
	orderUI[5] = display.newText("마라선생님! \n김치김밥 주세요.", 850, 220, "굴림")
	orderUI[5].size = 30
	orderUI[5]:setFillColor(0)
	orderUI[6] = display.newText("마라선생님! \n참치김밥 주세요.", 850, 220, "굴림")
	orderUI[6].size = 30
	orderUI[6]:setFillColor(0)
	orderUI[7] = display.newText("마라선생님! \n새우김밥 주세요.", 850, 220, "굴림")
	orderUI[7].size = 30
	orderUI[7]:setFillColor(0)
	for i = 1, 7, 1 do orderUI[i].alpha = 0 end

	person[1] = display.newImageRect("img/person1.png", 175, 205)
	person[2] = display.newImageRect("img/person2.png", 175, 205)
	person[3] = display.newImageRect("img/person3.png", 175, 205)
	for i = 1, 3, 1 do 
		person[i].x, person[i].y = 500, 418
		person[i].alpha = 0 
	end

	kimbap[1] = display.newImageRect("img/kimbap1.png", 300, 100)
	kimbap[2] = display.newImageRect("img/kimbap2.png", 300, 100)
	kimbap[3] = display.newImageRect("img/kimbap3.png", 300, 100)
	kimbap[4] = display.newImageRect("img/kimbap4.png", 300, 100)
	for i = 1, 4, 1 do
		kimbap[i].x, kimbap[i].y = display.contentWidth/2, display.contentHeight - 100
		kimbap[i].alpha = 0
		kimbap[i].name = i
	end


	-- [[함수]]
	local function playClickMusic()
		local clickMusicChannel = audio.play( clickMusic, { channel=2, loops=0} )
	end

	local function playClacKimbap()
		local calcKimbapMusicChannel = audio.play( calcKimbapMusic, { channel=2, loops=0} )
	end

	local function playDenyMusic()
		local denyMusicChannel = audio.play( denyMusic, { channel=2, loops=0} )
	end

	local function pauseBG()
		audio.pause( backgroundMusicChannel)
	end

	local function openRecipe()
		playClickMusic()
		rightUI[4].alpha = 1
	end

	local function closeRecipe()
		playClickMusic()
		rightUI[4].alpha = 0
	end

	function hp() -- 체력감소함수
		if leftUI[1].width <= 0 then
			pauseBG()
			composer.gotoScene("levelup")
		end
		leftUI[1].width = leftUI[1].width - 10
		leftUI[1].x = leftUI[1].x - 5
	end

	timer.performWithDelay(1000, hp, 31)

	local function toCook() -- 조리화면으로 이동
		for i = 1, 4, 1 do kimbap[i].alpha = 0 end -- 조리화면으로 이동하면 카운터에 놓인 김밥은 사라짐
		composer.setVariable("money", money)
		composer.gotoScene("cook4")
	end

	local function delAll() -- 주문 거절 시 모든게 사라졌다가 1.5초후에 다시 등장
		for i = 1, 7, 1 do orderUI[i].alpha = 0 end
		for i = 1, 3, 1 do person[i].alpha = 0 end
		timer.performWithDelay(1500, customer, 1)
	end

	function putKimbap(event) -- cook scene에서도 쓸 수 있게 local이 아닌 전역 함수
		kimbap[event.target.name].alpha = 1
	end

	function calcCook() -- cook.lua에서 이루어진 돈계산 모두 반영
		leftUI[4].text = string.format("%d원", money)
	end

	local function calcBank(m) -- 저금통 계산
		gameUI[2].text = string.format("+%d원", m)
		gameUI[2].alpha = 1
		transition.to(gameUI[2], {time = 1000, alpha = 0})
	end

	function calcKimbap(event)
		event.target.alpha = 0

		if orderUI[4].alpha == 1 and event.target == kimbap[1] then -- 1:꼬마김밥일 때
			playClacKimbap()
			money = money + 1500
			calcBank(1500)
			leftUI[4].text = string.format("%d원", money)
		elseif orderUI[5].alpha == 1 and event.target == kimbap[2] then -- 2:김치김밥일 때
			playClacKimbap()
			money = money + 2500
			calcBank(2500)
			leftUI[4].text = string.format("%d원", money)
		elseif orderUI[6].alpha == 1 and event.target == kimbap[3] then -- 3:참치김밥일 때
			playClacKimbap()
			money = money + 3000
			calcBank(3000)
			leftUI[4].text = string.format("%d원", money)
		elseif orderUI[7].alpha == 1 and event.target == kimbap[4] then -- 4:새우김밥일 때
			playClacKimbap()
			money = money + 3500
			calcBank(3500)
			leftUI[4].text = string.format("%d원", money)
		else
			print("메뉴 틀림")
		end
		
		calcCounter()
	end

	local function order() -- 주문창, 주문내용, 수락/거절 버튼 뜸
		for i = 1, 3, 1 do orderUI[i].alpha = 1 end
		orderUI[math.random(4,7)].alpha = 1
	end

	local function denyOrder()
		playDenyMusic()
		delAll()
	end

	local function acceptOrder()
		playClickMusic()
		for i = 2, 3, 1 do orderUI[i].alpha = 0 end
		toCook()
	end

	function customer()
		person[math.random(1,3)].alpha = 1
		order()
	end

	-- 초기화
	
	timer.performWithDelay(1000, customer, 1)

	-- 이벤트 등록
	rightUI[1]:addEventListener("tap", pauseBG)
	rightUI[3]:addEventListener("tap", toCook)
	rightUI[2]:addEventListener("tap", openRecipe)
	rightUI[4]:addEventListener("tap", closeRecipe)
	orderUI[3]:addEventListener("tap", denyOrder)
	orderUI[2]:addEventListener("tap", acceptOrder)
	for i = 1, 4, 1 do kimbap[i]:addEventListener("tap", calcKimbap) end
	for i = 1, 4, 1 do kimbap[i]:addEventListener("tap", delAll) end

	-- 장면 삽입
	for i = 1, 2, 1 do sceneGroup:insert(background[i]) end
	for i = 1, 3, 1 do sceneGroup:insert(gameUI[i]) end
	sceneGroup:insert(rightUI[3])
	for i = 1, 3, 1 do sceneGroup:insert(person[i]) end
	sceneGroup:insert(leftUI[3])
	sceneGroup:insert(leftUI[4])
	for i = 1, 4, 1 do sceneGroup:insert(kimbap[i]) end
	for i = 1, 7, 1 do sceneGroup:insert(orderUI[i]) end
end



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then
		-- e.g. start timers, begin animation, play audio, etc.
	end   
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		--추가
		--안넣을 경우 씬이 뒤에 남아있음 = 플레이했던 판 다시 플레이 못함
		--composer.removeScene("counter4")
	elseif phase == "did" then
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene