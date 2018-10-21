local Obstacle = Class("Obstacle");

function Obstacle:init(x,y,image)
	self.x = x;
	self.y = y;
	self.image = love.graphics.newImage(image);
	self.w = self.image:getWidth();
	self.h = self.image:getHeight();
	self.isRight = true;
	self.type = 'wall';
	self.scale = constScale;		--放大倍数
	
	addCollisionWithPivot(self,self.x,self.y,self.w * self.scale,self.h * self.scale,self.w/2 * self.scale,self.h * self.scale,self.isRight);
	
	--注册到管理器
	g_objectManager:add(self);
end

function Obstacle:destroy()
	removeCollision(self);
	
	g_objectManager:remove(self);
end


function Obstacle:update(dt)
	
end

function Obstacle:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, self.scale,self.scale, self.w/2, self.h);
	--显示碰撞器的位置
	love.graphics.rectangle('line',self.x - self.w/2*self.scale,self.y - self.h*self.scale,self.w * self.scale,self.h * self.scale);
end

return Obstacle
