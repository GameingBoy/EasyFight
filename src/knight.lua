local Knight = Class("Knight");

local chaseDistance = 60;

local Idle = Class("Idle",State);
function Idle:init()
	self.image = love.graphics.newImage('assets/sprites/knight/s_knight_idle_strip3.png');
	self.animSpeed = 0.4;
	local g = anim8.newGrid(40, 48, self.image:getWidth(), self.image:getHeight()); -- pauseAtEnd
	self.animation = anim8.newAnimation(g('1-3',1), 1/(constFrame * self.animSpeed));
end

function Idle:update(dt)
	self.animation:update(dt);	
	
	self.owner.isRight = player.x > self.owner.x;
		--简单AI
	if actorDistance(self.owner.x,self.owner.y,player.x,player.y) > chaseDistance then
		self.owner:switchState('run');
	else
		self.owner:switchState('attack');
	end
end

function Idle:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function Idle:enter(owner)
	self.owner = owner;
	self.animation:gotoFrame(1);
end

function Idle:exit()

end

local Run = Class("Run",State);
function Run:init()
	self.image = love.graphics.newImage('assets/sprites/knight/s_knight_walk_strip4.png');
	self.animSpeed = 0.4;
	local g = anim8.newGrid(40, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-4',1), 1/(constFrame * self.animSpeed));
end

function Run:update(dt)
	self.animation:update(dt);
	if actorDistance(self.owner.x,self.owner.y,player.x,player.y) > chaseDistance then
		self.owner:move(self.owner.vx * (self.owner.isRight and 1 or -1),0);
	else
		self.owner:switchState('attack');
	end
end

function Run:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function Run:enter(owner)
	self.owner = owner;
	self.animation:gotoFrame(1);
end

function Run:exit()

end

local Attack = Class("Attack",State);
function Attack:init()
	self.image = love.graphics.newImage('assets/sprites/knight/s_knight_attack_strip12.png');
	self.animSpeed = 0.6;
	local g = anim8.newGrid(80, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-12',1), 1/(constFrame * self.animSpeed),"pauseAtEnd");
end

function Attack:update(dt)
	if self.animation.status == "paused" then --如果动画已经暂停，则恢复到idle状态
		self.owner:switchState('idle');
	else
		self.animation:update(dt);
		if self.animation.position  == 5 and self.isHitbox == false then
			Hitbox(self.owner.x,self.owner.y,24,48,"player",self.owner.isRight,"assets/sprites/skeleton/s_skeleton_attack_one_damage.png",0.2,2,self.owner.atk);
			self.isHitbox = true;
		end
	end
end

function Attack:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function Attack:enter(owner)
	self.owner = owner;
	self.animation:resume();
	self.animation:gotoFrame(1);
	self.isHitbox = false;
end

function Attack:exit()

end

local KnockBack = Class("KnockBack",State);
function KnockBack:init()
	self.image = love.graphics.newImage('assets/sprites/knight/s_knight_hitstun.png');
	self.keepTime = 0.3;
	self.keepCount = 0;
	self.knockBack = 0;
end

function KnockBack:update(dt)
	if self.keepCount >= self.keepTime then --如果动画已经暂停，则恢复到idle状态
		self.owner:switchState('idle');
	else
		self.owner:move((self.owner.isRight and -1 or 1) * lerp(self.knockBack,0,self.keepCount/self.keepTime),0);
		self.keepCount = self.keepCount + dt;
	end
end

function KnockBack:draw()
	love.graphics.draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function KnockBack:enter(owner)
	self.owner = owner;
	self.keepCount = 0;
	self.knockBack = owner.knockBack;
end

function KnockBack:exit()

end

local Dead = Class("Dead",State);
function Dead:init()
	self.image = love.graphics.newImage('assets/sprites/knight/s_knight_die_strip6.png');
	self.animSpeed = 0.4;
	local g = anim8.newGrid(80, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-6',1), 1/(constFrame * self.animSpeed),"pauseAtEnd");
end

function Dead:update(dt)
	if self.animation.status == "paused" then --如果动画已经暂停，则恢复到idle状态
		self.owner:destroy();
	else
		self.animation:update(dt);
	end
end

function Dead:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function Dead:enter(owner)
	self.owner = owner;
	self.animation:resume();
	self.animation:gotoFrame(1);
	
	--播放死亡动画时就不受影响了
	removeCollision(owner);
end

function Dead:exit()

end


function Knight:init(x,y)
	self.x = x;
	self.y = y;
	self.hp = 100;
	self.atk = 8;
	self.vx = 1;
	self.isRight = true;
	self.knockBackSpeed = 0;
	self.scale = constScale;
	self.state = nil;
	self.stateMap = {};
	self.type = 'enemy';
	self.stateMap['idle'] = Idle();
	self.stateMap['run'] = Run();
	self.stateMap['attack'] = Attack();
	self.stateMap['knockBack'] = KnockBack();
	self.stateMap['dead'] = Dead();
	
	addCollisionWithPivot(self,self.x,self.y,40 * self.scale,48 * self.scale,24 * self.scale,48 * self.scale,self.isRight);
	
	--注册到管理器
	g_objectManager:add(self);
	
	self:switchState('idle');
end

function Knight:destroy()
	--从管理器移除
	g_objectManager:remove(self);
end

function Knight:switchState(stateName)
	if self.state then
		self.state:exit();
	end
	local state = self.stateMap[stateName];
	
	if state then
		state:enter(self);
	end
	self.state = state;
end

function Knight:update(dt)
	if self.state then
		self.state:update(dt);
	end
end

function Knight:keypressed(key)
	if self.state then
		self.state:keypressed(key);
	end
end

function Knight:draw()
	if self.state then
		self.state:draw();
	end
	
	--显示碰撞器的位置
	local ox = self.isRight and 24 or (40 - 24);
	love.graphics.rectangle('line',self.x - ox*self.scale,self.y - 48*self.scale,40 * self.scale,48 * self.scale);
end

local function moveFilter(item,other)
	if  other.type == 'wall' then 
		return 'slide'
	else
		return 'cross';
	end
end


function Knight:move(x,y)
	local tx = self.x + x;
	local ty = self.y + y;
	
	local actualX, actualY, cols, len  = moveCollision(self,tx,ty,40 * self.scale,48 * self.scale,24 * self.scale,48 * self.scale,self.isRight,moveFilter);
	
	self.x = actualX;
	self.y = actualY;
end

return Knight
