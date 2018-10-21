local ObjectManager = Class("ObjectManager");

function ObjectManager:init()
	self.pool = {};
end

function ObjectManager:add(object)
	self.pool[object] = object;
end

function ObjectManager:remove(object)
	self.pool[object] = nil;
end

function ObjectManager:update(dt)
	for k, v in pairs(self.pool) do 
		k:update(dt);
	end 
end

function ObjectManager:draw()
	for k, v in pairs(self.pool) do 
		k:draw(dt);
	end 
end

return ObjectManager;