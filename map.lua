-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--1) 게임에 사용될 랜덤함수 미리 초기화
   math.randomseed(os.time())
--2) widget 라이브러리 추가(아래서 사용할 것임)
local widget = require("widget")
--3) 점수 변수 선언
local score = 0
--4) GUI 요소들 선언 
local background
local gameUI = {}
local viewUI = {}
local playerUI = {}
local buttonUI = {}
local p = {}
local r =1
--local temp
function scene:create( event )
   local sceneGroup = self.view
   --local win1 = composer.getVariable("win1")
   r = composer.getVariable("r") --스테이지 넘버 받고
   print(r)
   -- 배경화면
   background = display.newImageRect("mapImage/mapImage.png", display.contentWidth, display.contentHeight)
   background.x, background.y = display.contentWidth/2, display.contentHeight/2

   
   local kimbap = {}
   for i=1, 5, 1 do
	   kimbap[i] = display.newImageRect("mapImage/kimbap.png", 127, 128)
	   kimbap[i].x, kimbap[i].y = display.contentWidth/2-267.564216-267.564216 + (267.564216 * (i-1)) , display.contentHeight/2
	   kimbap[i].alpha = 0
	end
	kimbap[1].alpha = 1

	--오른쪽 보는 트럭
   gameUI[1] = display.newImageRect("mapImage/truck.png", 201, 118)
   gameUI[1].x, gameUI[1].y = kimbap[r].x, display.contentHeight/2-80
   gameUI[1].alpha = 1
   --왼쪽보는 트럭
   gameUI[2] = display.newImageRect("mapImage/truck2.png", 201, 118)
   gameUI[2].x, gameUI[2].y = kimbap[r].x, display.contentHeight/2-80
   gameUI[2].alpha = 0

   for i=1, 2, 1 do
   	--gameUI[i].x = display.contentWidth/2 -267.564216-267.564216 + (267.564216 * (r-1))
   end

   local road = {}--길
   for i=1, 5, 1 do
	   road[i] = display.newImageRect("mapImage/road.png", 257, 67)
	   road[i].x, road[i].y = kimbap[i].x+267.564216/2 ,display.contentHeight/2
	   road[i].alpha = 0
	end
	--road[0].alpha = 0
	road[5].alpha = 0
	road[1].alpha = 1--처음 맵을 켜는 시점은 첫판을 깬 이후
	for i=1, r, 1 do
		road[i].alpha = 1
		kimbap[i].alpha = 1
	end
   -- 9)함수 작성
   for i = -100, 100, 1 do
       p[i] = 0
   end
   --p[r][c] = 1
	kimbap[1].alpha = 1
	--[[if win1 == 1 then
		print(win1)
		
	end]]
	function roadOn( n )
		-- body
		road[n].alpha = 1
	end
   function moveScene()
      -- body
     if p[1] == 1 then
      	--composer.removeScene("map")
         composer.gotoScene("counter")--stage1
      elseif p[2] == 1 then
      	--gameUI[1].x, gameUI[1].y = kimbap[2].x, display.contentHeight/2-80
      	--composer.setVariable("r1", r) 
      	print("들어간 스테이지 " .. r)
      	roadOn(r)
      	--composer.removeScene("map")
        composer.gotoScene("counter2")--두번째 스테이지 파일에 연결했다 가정
        
      elseif p[3] == 1 then
         composer.gotoScene("counter3")--세번째 스테이지라고 가정
     elseif p[4] == 1 then
     	composer.gotoScene("counter4")
     elseif p[5] == 1 then
     	composer.gotoScene("counter5")
      end

   end
   -- inputEvent - 버튼을 눌렀을때 실행되는 함수
   function inputEvent( event )

      if event.target.name == "L" then
         --if gameUI[2].alpha == 0 then
            gameUI[1].alpha = 0
            gameUI[2].alpha = 1
            --print(r.."/"..c)
            if road[r-1].alpha == 1 and r~=1 then
	            p[r]  = 0
	            r = r-1
	            p[r]  = 1
	            --print(r,c)
	         --end
	            transition.to(gameUI[1], {time = 300, x = (gameUI[1].x -267.564216)})
	            transition.to(gameUI[2], {time = 300, x = (gameUI[2].x -267.564216)})
	        else

	        end
      elseif event.target.name == "R" then
         --if gameUI[1].alpha == 0 then
            gameUI[1].alpha = 1
            gameUI[2].alpha = 0
            if road[r].alpha == 1 and r ~= 5 then--끝에서 누르면 아무일도 일어나지 않도록
	            p[r]  = 0
	            r= r+1
	            p[r]  = 1
	         --end
	            transition.to(gameUI[1], {time = 300, x = gameUI[1].x +267.564216})
	            transition.to(gameUI[2], {time = 300, x = (gameUI[2].x +267.564216)})

	        end
      --[[elseif event.target.name == "T" then
      		if road[r+1].alpha == 1 then
	            p[r][c]  = 0
	            c = c+1
	            p[r][c]  = 1

	            transition.to(gameUI[1], {time = 300, y = gameUI[1].y -267.564216})
	            transition.to(gameUI[2], {time = 300, y = (gameUI[2].y -267.564216)})
	        end
      elseif event.target.name == "B" then
            if road[r+1].alpha == 1 then
	            p[r][c]  = 0
	            c = c -1
	            p[r][c]  = 1

	            transition.to(gameUI[1], {time = 300, y = gameUI[1].y +267.564216})
	            transition.to(gameUI[2], {time = 300, y = (gameUI[2].y +267.564216)})
	        end]]
      elseif event.target.name == "C" then
      	--print(r.."/")
      	--composer.setVariable(r, r) 
         if gameUI[1].alpha == 1 then
            moveScene()
           -- print(1)
         elseif gameUI[2].alpha == 1 then
            moveScene()
         end
      end
   end


   -- 8) 버튼 이미지 삽입 및 함수연결
   buttonUI[5] = widget.newButton({ 
      defaultFile = "mapImage/input_C.png", overFile = "mapImage/input_C_over.png", 
      width = 100, height = 100, onPress = inputEvent 
   })
   buttonUI[5].x, buttonUI[5].y =  display.contentWidth-150, display.contentHeight-150
   buttonUI[5].name = "C"
   buttonUI[1] = widget.newButton({
      defaultFile = "mapImage/input_L.png", overFile = "mapImage/input_L_over.png",
      width = 75, height = 150, onPress = inputEvent -- 버튼을 누르면 inputEvent
   })
   buttonUI[1].x, buttonUI[1].y =  buttonUI[5].x-70, buttonUI[5].y
   buttonUI[1].name = "L"

   buttonUI[2] = widget.newButton({ 
      defaultFile = "mapImage/input_R.png", overFile = "mapImage/input_R_over.png", 
      width = 75, height = 150, onPress = inputEvent 
   })
   buttonUI[2].x, buttonUI[2].y =  buttonUI[5].x+70,buttonUI[5].y
   buttonUI[2].name = "R"

   buttonUI[3] = widget.newButton({ 
      defaultFile = "mapImage/input_T.png", overFile = "mapImage/input_T_over.png",
      width = 150, height = 75, onPress = inputEvent 
   })
   buttonUI[3].x, buttonUI[3].y =  buttonUI[5].x, buttonUI[5].y-70
   buttonUI[3].name = "T"

   buttonUI[4] = widget.newButton({ 
      defaultFile = "mapImage/input_B.png", overFile = "mapImage/input_B_over.png", 
      width = 150, height = 75, onPress = inputEvent 
   })
   buttonUI[4].x, buttonUI[4].y = buttonUI[5].x, buttonUI[5].y+70
   buttonUI[4].name = "B"

   

   -- 10)마지막으로 sceneGroup:insert
   sceneGroup:insert(background)
   for i=1, 4, 1 do sceneGroup:insert(road[i]) end
   for i=1, 5,1 do sceneGroup:insert(kimbap[i]) end
   sceneGroup:insert(gameUI[1])
   sceneGroup:insert(gameUI[2])
   for i = 1, 5, 1 do
      sceneGroup:insert(buttonUI[i])
   end

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
      composer.removeScene("map")
      -- e.g. stop timers, stop animation, unload sounds, etc.)
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