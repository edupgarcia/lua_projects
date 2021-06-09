GAME_OVER = false
METEORS_MAX = 12

-- Main Window
MainWindow = {
  width = 320,
  height = 480,
  resizable = false,
  title = '14 bis vs meteoros'
}

-- Áudio
Sounds = {
  background = 'audios/background.wav',
  explosion = 'audios/explosion.wav',
  game_over = 'audios/game_over.wav',
  shoot = 'audios/shoot.wav',
  winner = 'audios/winner.wav'
}

-- Images
Images = {
  background = 'images/background.png',
  explosion = 'images/explosion.png',
  game_over = 'images/game_over.png',
  meteor = 'images/meteor.png',
  plane = 'images/14bis.png',
  shoot = 'images/shoot.png',
  winner = 'images/winner.png'
}

-- Avião
Plane = {
  image = Images.plane,
  width = 56,
  height = 62,
  x = MainWindow.width / 2 - 64 / 2,
  y = MainWindow.height - 64,

  move = function (self)
    if love.keyboard.isDown('w') and self.y > 0 then
      self.y = self.y - 1
    end

    if love.keyboard.isDown('s') and self.y < (MainWindow.height - self.height) then
      self.y = self.y + 1
    end

    if love.keyboard.isDown('a') and self.x > 0 then
      self.x = self.x - 1
    end

    if love.keyboard.isDown('d') and self.x < (MainWindow.width - self.width) then
      self.x = self.x + 1
    end
  end,

  destroy = function (self)
    PlaneImage = love.graphics.newImage(Images.explosion)
    self.width = 61
    self.height = 63

    love.graphics.draw(PlaneImage, Plane.x, Plane.y)

    BackgroundSound:stop()
    ExplosionSound:play()
    Game_overSound:play()

    GAME_OVER = true
  end
}

-- Meteors
MeteorsArray = {}

Meteor = {
  create = function ()
    local meteoro = {
      x = math.random(MainWindow.width),
      y = -20,
      width = 50,
      height = 44,
      peso = math.random(3),
      deslocamento_horizontal = math.random(-1, 1)
    }

    table.insert(MeteorsArray, meteoro)
  end,

  move = function ()
    for k, meteor in pairs(MeteorsArray) do
      meteor.y = meteor.y + meteor.peso
      meteor.x = meteor.x + meteor.deslocamento_horizontal
    end
  end,

  remove = function ()
    for i = #MeteorsArray, 1, -1 do
      if MeteorsArray[i].y > MainWindow.height then
        table.remove(MeteorsArray, i)
      end
    end
  end,

  colision = function ()
    for k, meteor in pairs(MeteorsArray) do
      if Plane.x < meteor.x + meteor.width
      and meteor.x < Plane.x + Plane.width
      and meteor.y < Plane.y + Plane.height
      and Plane.y < meteor.y + meteor.height then
        Plane:destroy()
      end
    end

  end
}

-- Load some default values for our rectangle.
function love.load()
  love.window.setMode(MainWindow.width, MainWindow.height, {resizable = MainWindow.resizable})
  love.window.setTitle(MainWindow.title)

  BackgroundImage = love.graphics.newImage(Images.background)
  -- ExplosionImage = love.graphics.newImage(Images.explosion)
  GameOverImage = love.graphics.newImage(Images.game_over)
  MeteoroImage = love.graphics.newImage(Images.meteor)
  PlaneImage = love.graphics.newImage(Images.plane)
  ShootImage = love.graphics.newImage(Images.shoot)
  WinnerImage = love.graphics.newImage(Images.winner)

  BackgroundSound = love.audio.newSource(Sounds.background, 'static')
  ShootSound = love.audio.newSource(Sounds.shoot, 'static')
  ExplosionSound = love.audio.newSource(Sounds.explosion, 'static')
  Game_overSound = love.audio.newSource(Sounds.game_over, 'static')
  WinnerSound = love.audio.newSource(Sounds.winner, 'static')

  BackgroundSound:setLooping(true)
  BackgroundSound:play()

  math.randomseed(os.time())
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
  if not GAME_OVER then
    if love.keyboard.isDown('w', 's', 'a', 'd') then
      Plane:move()
    end

    Meteor:remove()

    if #MeteorsArray < METEORS_MAX then
      Meteor:create()
    end

    Meteor:move()

    -- ChecaColisoes()
    Meteor:colision()
  end
end

-- Draw a coloured rectangle.
function love.draw()
  -- In versions prior to 11.0, color component values are (0, 102, 102)
  -- love.graphics.setColor(0, 0.4, 0.4)
  -- love.graphics.rectangle("fill", x, y, w, h)

  love.graphics.draw(BackgroundImage, 0, 0)
  love.graphics.draw(PlaneImage, Plane.x, Plane.y)

  for k, meteoro in pairs(MeteorsArray) do
    love.graphics.draw(MeteoroImage, meteoro.x, meteoro.y)
  end
end