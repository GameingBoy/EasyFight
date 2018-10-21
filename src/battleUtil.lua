--判断动画是否在想要的帧数
function animationHitFrameRange(animation,from,to)
	return animation.position >= from and animation.position <= to;
end

--获取
function actorDistance(x1,y1,x2,y2)
	return math.sqrt((x1 - x2)^2 + (y1-y2)^2);
end

--创建碰撞体
function addCollisionWithPivot(item,x,y,w,h,px,py,isRight)
	local ox = isRight and px or (w - px);
	g_world:add(item,x - ox,y - py,w,h);
end

--移动碰撞器
function moveCollision(item,x,y,w,h,px,py,isRight,filter)
	local ox = isRight and px or (w - px);
	local dx,dy,cols,len;
	if filter == nil then
	 	dx,dy,cols,len = g_world:move(item,x - ox,y - py);
	else
		dx,dy,cols,len =  g_world:move(item,x - ox,y - py,filter);
	end
	
	return dx + ox,dy + py,cols,len;
end

--检查某一位置
function checkCollision(item,x,y,w,h,px,py,isRight,filter)
	local ox = isRight and px or (w - px);
	local dx,dy,cols,len;
	if filter == nil then
	 	dx,dy,cols,len = g_world:move(item,x - ox,y - py);
	else
		dx,dy,cols,len =  g_world:move(item,x - ox,y - py,filter);
	end
	
	return dx + ox,dy + py,cols,len;
end

--删除碰撞体
function removeCollision(item)
	g_world:remove(item);
end

function lerp(from,to,t)
	return from + (to - from) * t;
end