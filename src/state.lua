local State = Class("State");
function State:init(owner)
end

function State:update(dt)

end

function State:draw()
	
end

function State:enter(owner)
	self.owner = owner;
end

function State:exit()

end

function State:keypressed(key)

end

return State;