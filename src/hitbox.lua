local Hitbox = Class("Hitbox");

function Hitbox:init(x,y,px,py,target,isRight,image,lifespan,knockBack,damage)
	self.x = x;
	self.y = y;
	self.px = px;
	self.py = py;
	self.target = target;
	self.damage = damage;
	self.image = love.graphics.newImage(image);
	self.w = self.image:getWidth();
	self.h = self.image:getHeight();
	self.isRight = isRight;
	self.type = 'hitbox';
	self.lifespan = lifespan;
	self.knockBack = knockBack;
	self.scale = constScale;		--放大倍数
	self.hited = {};
	self.lifeCount = 0;
	addCollisionWithPivot(self,self.x,self.y,self.w * self.scale,self.h * self.scale,self.px * self.scale,self.py * self.scale,self.isRight);
	
	g_objectManager:add(self);
end

function Hitbox:destroy()
	removeCollision(self);
	g_objectManager:remove(self);
end


function Hitbox:update(dt)
	self.lifeCount = self.lifeCount + dt;
	if self.lifeCount >= self.lifespan then
		self:destroy();
	else
		local actualX, actualY, cols, len = checkCollision(self,self.x,self.y,self.w * self.scale,self.h * self.scale,self.px * self.scale,self.py * self.scale,self.isRight);
		
		if len == 0 then return end;
		
		for i=1,len do
			local other = cols[i].other;
			if other.type == self.target  and self.hited[other] == nil then 
					self.hited[other] = other;
					other.hp = other.hp - self.damage;
					if other.hp <= 0 then
						print("death");
						other:switchState("dead");
					else
						print("hit" .. other.hp);
						other.isRight = not self.isRight;
						other.knockBack = self.knockBack;
						other:switchState("knockBack");
					end
			end
		end
	end
end

function Hitbox:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, (self.isRight and 1 or -1)*self.scale,self.scale, self.px, self.py);
	--显示碰撞器的位置
	local ox = self.isRight and self.px or (self.w - self.px);
	love.graphics.rectangle('line',self.x - ox*self.scale,self.y - self.h*self.scale,self.w * self.scale,self.h * self.scale);
end

return Hitbox
