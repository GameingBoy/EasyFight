local Player = Class("Player");


local Idle = Class("Idle",State);
function Idle:init()
	self.image = love.graphics.newImage('assets/sprites/skeleton/s_skeleton_idle_strip3.png');
	self.animSpeed = 0.4;
	local g = anim8.newGrid(40, 48, self.image:getWidth(), self.image:getHeight()); -- pauseAtEnd
	self.animation = anim8.newAnimation(g('1-3',1), 1/(constFrame * self.animSpeed));
end

function Idle:update(dt)
	self.animation:update(dt);
		
	--如果按下 a d 移动
	local isDown = love.keyboard.isDown;
	if isDown(keyLeft) or isDown(keyRight) then
		self.owner:switchState('run');
	end
	
	if isDown(keyRoll) then		--按空格切换为roll
		self.owner:switchState('roll');
		return;
	end
	
	if isDown(keyAttack) then			--攻击
		self.owner:switchState('attackOne');
		return;
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
	self.image = love.graphics.newImage('assets/sprites/skeleton/s_skeleton_run_strip6.png');
	self.animSpeed = 0.6;
	local g = anim8.newGrid(40, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-6',1), 1/(constFrame * self.animSpeed));
end

function Run:update(dt)
	self.animation:update(dt);
	
	local isDown = love.keyboard.isDown;
	if isDown(keyLeft) then
		self.owner:move(-self.owner.vx,0);
		self.owner.isRight = false;
	elseif isDown(keyRight) then
		self.owner:move(self.owner.vx,0);
		self.owner.isRight = true;
	else
		self.owner:switchState('idle');
	end
	
	if isDown(keyRoll) then		--按空格切换为roll
		self.owner:switchState('roll');
		return;
	end
	
	if isDown(keyAttack) then
		self.owner:switchState('attackOne');
		return;
	end
end

function Run:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function Run:enter(owner)
	self.owner = owner;
	self.animation:gotoFrame(1);
	local isDown = love.keyboard.isDown;
	if isDown(keyLeft) then
		self.owner:move(-self.owner.vx,0);
		self.owner.isRight = false;
	elseif isDown(keyRight) then
		self.owner:move(self.owner.vx,0);
		self.owner.isRight = true;
	else
		print("some error");
	end
end

function Run:exit()

end

local Roll = Class("Roll",State);
function Roll:init()
	self.image = love.graphics.newImage('assets/sprites/skeleton/s_skeleton_roll_strip7.png');
	self.animSpeed = 0.7;
	local g = anim8.newGrid(96, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-7',1), 1/(constFrame * self.animSpeed),"pauseAtEnd");
end

function Roll:update(dt)
	if self.animation.status == "paused" then --如果动画已经暂停，则恢复到idle状态
		self.owner:switchState('idle');
	else
		self.owner:move((self.owner.isRight and 1 or -1) * self.owner.vroll,0);
		self.animation:update(dt);
	end
end

function Roll:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function Roll:enter(owner)
	self.owner = owner;
	self.animation:resume();
	self.animation:gotoFrame(1);
end

function Roll:exit()

end

local AttackOne = Class("AttackOne",State);
function AttackOne:init()
	self.image = love.graphics.newImage('assets/sprites/skeleton/s_skeleton_attack_one_strip5.png');
	self.animSpeed = 0.7;
	self.isHitbox = false;
	local g = anim8.newGrid(64, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-5',1), 1/(constFrame * self.animSpeed),"pauseAtEnd");
end

function AttackOne:update(dt)
	if self.animation.status == "paused" then --如果动画已经暂停，则恢复到idle状态
		self.owner:switchState('idle');
	else
		self.animation:update(dt);
		if self.animation.position  == 1 and self.isHitbox == false then
			Hitbox(self.owner.x,self.owner.y,24,48,"enemy",self.owner.isRight,"assets/sprites/skeleton/s_skeleton_attack_one_damage.png",0.2,2,self.owner.atk);
			self.isHitbox = true;
		end
	end
end

function AttackOne:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function AttackOne:enter(owner)
	self.owner = owner;
	self.animation:resume();
	self.animation:gotoFrame(1);
	self.isHitbox = false;
end

function AttackOne:exit()

end

function AttackOne:keypressed(key)
	if key == keyAttack and animationHitFrameRange(self.animation,2,4) then
		self.owner:switchState('attackTwo');
	end
end

local AttackTwo = Class("AttackTwo",State);
function AttackTwo:init()
	self.image = love.graphics.newImage('assets/sprites/skeleton/s_skeleton_attack_two_strip5.png');
	self.animSpeed = 0.7;
	self.isHitbox = false;
	local g = anim8.newGrid(96, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-5',1), 1/(constFrame * self.animSpeed),"pauseAtEnd");
end

function AttackTwo:update(dt)
	if self.animation.status == "paused" then --如果动画已经暂停，则恢复到idle状态
		self.owner:switchState('idle');
	else
		self.animation:update(dt);
		if self.animation.position  == 2 and self.isHitbox == false then
			Hitbox(self.owner.x,self.owner.y,24,48,"enemy",self.owner.isRight,"assets/sprites/skeleton/s_skeleton_attack_two_damage.png",0.2,2,self.owner.atk);
			self.isHitbox = true;
		end
	end
end

function AttackTwo:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function AttackTwo:enter(owner)
	self.owner = owner;
	self.animation:resume();
	self.animation:gotoFrame(1);
	self.isHitbox = false;
end

function AttackTwo:exit()

end

function AttackTwo:keypressed(key)
	if key == keyAttack and animationHitFrameRange(self.animation,2,4) then
		self.owner:switchState('attackThree');
	end
end

local AttackThree = Class("AttackThree",State);
function AttackThree:init()
	self.image = love.graphics.newImage('assets/sprites/skeleton/s_skeleton_attack_three_strip6.png');
	self.animSpeed = 0.7;
	local g = anim8.newGrid(96, 48, self.image:getWidth(), self.image:getHeight());
	self.animation = anim8.newAnimation(g('1-6',1), 1/(constFrame * self.animSpeed),"pauseAtEnd");
end

function AttackThree:update(dt)
	if self.animation.status == "paused" then --如果动画已经暂停，则恢复到idle状态
		self.owner:switchState('idle');
	else
		self.animation:update(dt);
		if self.animation.position  == 3 and self.isHitbox == false then
			Hitbox(self.owner.x,self.owner.y,24,48,"enemy",self.owner.isRight,"assets/sprites/skeleton/s_skeleton_attack_three_damage.png",0.2,5,self.owner.atk);
			self.isHitbox =true;
		end
	end
end

function AttackThree:draw()
	self.animation:draw(self.image, self.owner.x,self.owner.y,0,(self.owner.isRight and 1 or -1)*self.owner.scale,self.owner.scale,24,48);
end

function AttackThree:enter(owner)
	self.owner = owner;
	self.animation:resume();
	self.animation:gotoFrame(1);
	self.isHitbox = false;
end

function AttackThree:exit()

end


local KnockBack = Class("KnockBack",State);
function KnockBack:init()
	self.image = love.graphics.newImage('assets/sprites/skeleton/s_skeleton_hitstun.png');
	self.keepTime = 0.2;
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



function Player:init(x,y)
	self.x = x;
	self.y = y;
	self.hp = 100;
	self.atk = 8;
	self.vx = 4;
	self.vroll = 6;
	self.isRight = true;
	self.state = nil;
	self.scale = constScale;		--放大倍数
	self.stateMap = {};
	self.type = 'player';
	self.stateMap['idle'] = Idle();
	self.stateMap['run'] = Run();
	self.stateMap['roll'] = Roll();
	self.stateMap['attackOne'] = AttackOne();
	self.stateMap['attackTwo'] = AttackTwo();
	self.stateMap['attackThree'] = AttackThree();
	self.stateMap['knockBack'] = KnockBack();
	
	addCollisionWithPivot(self,self.x,self.y,40 * self.scale,48 * self.scale,24 * self.scale,48 * self.scale,self.isRight);
	
	--注册到管理器
	g_objectManager:add(self);
	
	
	self:switchState('idle');
end

function Player:destroy()
	removeCollision(self);
	g_objectManager:remove(self);
end

function Player:switchState(stateName)
	if self.state then
		self.state:exit();
	end
	local state = self.stateMap[stateName];
	
	if state then
		state:enter(self);
	end
	self.state = state;
end

function Player:update(dt)

	if self.state then
		self.state:update(dt);
	end
end

function Player:keypressed(key)
	if self.state then
		self.state:keypressed(key);
	end
end

function Player:draw()
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

function Player:move(x,y)
	
	local tx = self.x + x;
	local ty = self.y + y;
	
	
	local actualX, actualY, cols, len  = moveCollision(self,tx,ty,40 * self.scale,48 * self.scale,24 * self.scale,48 * self.scale,self.isRight,moveFilter);
	
	self.x = actualX;
	self.y = actualY;
	
end

return Player
