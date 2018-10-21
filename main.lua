anim8 = require("lib/anim8");
Class = require("lib/middleclass");
Bump = require("lib/bump");
require("src/battleUtil");
require("src/battleDefine");
ObjectManager = require("src/objectManager");
State = require("src/state");
Player = require("src/player");
Knight = require("src/knight");
Obstacle = require("src/obstacle");
Hitbox = require("src/hitbox");

--全局
g_world = Bump.newWorld(64);	--添加碰撞世界
g_objectManager = ObjectManager();
player = nil;	--主角

function love.load()
	love.graphics.setDefaultFilter( 'nearest', 'nearest');
	player = Player(400,300);
	local knight = Knight(500,300);
	Obstacle(0,300,'assets/sprites/environment/s_wall.png');
end

function love.update(dt)
	g_objectManager:update(dt);
end

function love.draw()
	love.graphics.clear(0.6,0.6,0.6);
	g_objectManager:draw();
end

function love.keypressed( key, isrepeat )
	player:keypressed(key);
end
