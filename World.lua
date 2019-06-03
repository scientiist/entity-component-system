local Entity = require("core/BaseEntity")

local debug = true


local World = {
	entities = {},
	systems = {},

}

function World:register(system)
	table.insert(self.systems, system)
	return system
end


function World:getAllWith(requires)

	local matched = {}
	for idx, entity in pairs(self.entities) do
			
		local matches = true
		for j = 1, #requires do
			if ent:get(j) == nil then
				matches = false
			end
		end
		if matches then table.insert(matched, ent) end
	end
	return matched
end

function World:assemble(components)

	local ent = self:create()

	for index, value in pairs(components) do
		assert(type(value) == 'table', "World:assemble() requires a table of tables, dumbass.")
		assert(#value > 0)

		local fn = value[1]
		assert(type(fn) == 'function')

		if #value == 1 then
			ent:add(fn())
		else
			local args = {}
			for i = 2, #value do
				table.insert(args, value[i])
			end
			ent:add(fn(unpack(args)))
		end
	end
	return ent
end

function World:create()
	local entity = Entity.new()

	table.insert(self.entities, entity)

	return entity
end

function World:update(dt)
	for i = #self.entities, 1, -1 do
		local entity = self.entities[i]

		if entity.remove then

			for _, system in pairs(self.systems) do
				if system:match(entity) then
					system:destroy(entity)
				end
			end
			table.remove(self.entities, i)
		else
			for i, system in pairs(self.systems) do
				if system:match(entity) then
					if entity.loaded == false then
						system:load(entity)
					end
					system:update(dt, entity)
				end
			end
			entity.loaded = true
		end
	end
end


function World:draw()
	for idx, entity in pairs(self.entities) do
		for i, system in pairs(self.systems) do
			if system:match(entity) then
				system:draw(entity)
			end
		end
	end

	if debug then
		love.graphics.setColor(1, 1, 1)
		
		local formatString = "ECS World\n"..
							 "systems: "..(#self.systems).."\n"..
							 "entities: "..(#self.entities).."\n"

		love.graphics.print(formatString, 5, 5)
		
	end
end


return World