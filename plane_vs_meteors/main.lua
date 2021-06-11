GAME_OVER = false
METEORS_MAX = 12

-- Main WidxMeteorow
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
  shootArray = {},

  move = function (self)
    if love.keyboard.isDown('w') and self.y > 0 then
      self.y = self.y - 1
    elseif love.keyboard.isDown('s') and self.y < (MainWindow.height - self.height) then
      self.y = self.y + 1
    elseif love.keyboard.isDown('a') and self.x > 0 then
      self.x = self.x - 1
    elseif love.keyboard.isDown('d') and self.x < (MainWindow.width - self.width) then
      self.x = self.x + 1
    end
  end,

  shoot = function (self)
    ShootSound:play()

    local newShoot = {
      x = self.x + self.width / 2 - 6,
      y = self.y,
      width = 16,
      height = 16
    }

    table.insert(self.shootArray, newShoot)
  end,

  shootMove = function (self)
    for idxShoot = #self.shootArray, 1, -1 do
      if self.shootArray[idxShoot].y > 0 then
        self.shootArray[idxShoot].y = self.shootArray[idxShoot].y - 1
      else
        table.remove(self.shootArray, idxShoot)
      end
    end
  end,

  shootColide = function (self)
    for idxShoot = #self.shootArray, 1, -1 do
      local itemShoot = self.shootArray[idxShoot]
      for idxMeteor = #MeteorsArray, 1, -1 do
        local itemxMeteor = MeteorsArray[idxMeteor]
        if Colision(itemShoot.x, itemShoot.y, itemShoot.width, itemShoot.height,
        itemxMeteor.x, itemxMeteor.y, itemxMeteor.width, itemxMeteor.height) then
          table.remove(self.shootArray, idxShoot)
          table.remove(MeteorsArray, idxMeteor)
          break
        end
      end
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

  colisionCheck = function ()
    for k, meteor in pairs(MeteorsArray) do
      if Colision(meteor.x, meteor.y, meteor.width, meteor.height, 
      Plane.x, Plane.y, Plane.width, Plane.height) then
        Plane:destroy()
      end
    end

  end
}

function Colision(x1, y1, w1, h1, x2, y2, w2, h2)
  return (x2 < x1 + w1) and (x1 < x2 + w2)
     and (y1 < y2 + h2) and (y2 < y1 + h1)
end

local function DrawArray(list, image)
  for k, value in pairs(list) do
    love.graphics.draw(image, value.x, value.y)
  end
end

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
    Plane:shootMove()
    Meteor:colisionCheck()
    Plane:shootColide()
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'space' and not GAME_OVER then
    Plane:shoot()
  end
end

function love.draw()
  love.graphics.draw(BackgroundImage, 0, 0)
  love.graphics.draw(PlaneImage, Plane.x, Plane.y)

  DrawArray(MeteorsArray, MeteoroImage)
  DrawArray(Plane.shootArray, ShootImage)
end