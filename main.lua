push=require 'push'
Class=require 'class'

require 'paddle'
require 'ball'
WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=243

PADDLE_TIME=200

function love.load()
	math.randomseed(os.time())
	love.window.setTitle('Pong ')
	smallfont=love.graphics.newFont('font.ttf',8)
	scorefont=love.graphics.newFont('font.ttf',32)
  victoryfont=love.graphics.newFont('font.ttf',12)
	love.graphics.setFont(smallfont)

  sound={
    ['tap']=love.audio.newSource('tap.wav','static')
  }

	love.graphics.setDefaultFilter('nearest','nearest')
	push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
			fullscreen = false;
			resizable = false;
			vsync = true;
	})
	player1score=0
	player2score=0
	player1=paddle(10,30,5,20)
	player2=paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-30,5,20)
	ball=ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,4,4)
	ball:reset()

	gamestate= 'start'
end
function love.keypressed(key)
	if key== 'escape' then
	love.event.quit()
  
    elseif key== 'enter' or key == 'return' then
   	if gamestate=='start' then
   		gamestate='play'
      player1score=0
      player2score=0
   	else
   	   gamestate='start'	
       ball:reset()
	    player1score=0
      player2score=0
   end
   end
end
function love.draw()
	push:apply('start')

	love.graphics.clear(40/255,45/255,52/255,255/255)
	player1:render()
	player2:render()
	ball:render()
	love.graphics.setFont(smallfont)
	love.graphics.printf(
		'Crack PONG',
		0,
		20,
		VIRTUAL_WIDTH,
		'center')
   
  love.graphics.setFont(smallfont)
  love.graphics.printf(
    'Made by Yash Deokate',
    0,
    VIRTUAL_HEIGHT-10,
    VIRTUAL_WIDTH,
    'center')


    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(player1score),VIRTUAL_WIDTH/2-50,VIRTUAL_HEIGHT/3)
	love.graphics.print(tostring(player2score),VIRTUAL_WIDTH/2+30,VIRTUAL_HEIGHT/3)
	
  if gamestate=='win' then
    ball:reset()
    love.graphics.setFont(victoryfont)
    love.graphics.printf('Player ' .. tostring(winnner) .. ' Wins !!',0,40,VIRTUAL_WIDTH,'center')
  end  
  push:apply('end')
end
function love.update(dt)
	player1:update(dt)
	player2:update(dt)


   if ball.x<0 then
      player2score=player2score+1
      ball:reset()
   end

   if ball.x>VIRTUAL_WIDTH then
      player1score=player1score+1
      ball:reset()
   end   



	if love.keyboard.isDown('w') then
		player1.dy = -PADDLE_TIME
    elseif love.keyboard.isDown('s') then
        player1.dy=PADDLE_TIME
    else
        player1.dy=0     
    end

    if	love.keyboard.isDown('up') then
    	 player2.dy= -PADDLE_TIME
    elseif love.keyboard.isDown('down') then
         player2.dy=PADDLE_TIME
    else 
       player2.dy=0     
    end
    if gamestate=='play' then
    ball:update(dt)
    end     
    	 
     if gamestate=='play' then
      if ball:collides(player1) then
      	ball.dx= -ball.dx*1.03
      	ball.x=player1.x + 5

      	 if ball.dy<0 then
      	 	ball.dy= -math.random(10,150)
      	 else
      	    ball.dy= math.random(10,150)
      	 end
        sound['tap']:play() 
      end    	
      if ball:collides(player2) then
      	ball.dx= -ball.dx*1.03
      	ball.x=player2.x - 5

      	 if ball.dy<0 then
      	 	ball.dy= -math.random(10,150)
      	 else
      	    ball.dy= math.random(10,150)
      	 end
          sound['tap']:play() 
      end 

      if ball.y<=0 then
        ball.y=0
        ball.dy=-ball.dy
         sound['tap']:play() 
      end

      if ball.y>= VIRTUAL_HEIGHT-4 then
        ball.y=VIRTUAL_HEIGHT-4
        ball.dy= -ball.dy
         sound['tap']:play() 
      end    	
    end 
  
    if player1score==10 then
      winnner=1
      gamestate='win' 
    elseif player2score==10 then
      winnner=2
      gamestate='win'
    end   
    if gamestate=='play' then
    if ball.x<=VIRTUAL_WIDTH/2 then
      player2.y=math.random(0,VIRTUAL_HEIGHT-30)
    elseif ball.x>VIRTUAL_WIDTH/2 then
      player1.y=math.random(0,VIRTUAL_HEIGHT-30)
    end
  end

end