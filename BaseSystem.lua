return {
    new = function(requires)
        assert(type(requires) == 'table')

        local system = {
            requires = requires
        }

        function system:match(entity)
            for idx, requirement in pairs(self.requires) do
                if entity:get(requirement) == nil then
                    return false
                end
            end
            return true
        end

        function system:load(entity) end
        function system:update(delta, entity) end
        function system:draw(entity) end
        function system:ui_draw(entity) end
        function system:destroy(entity) end

        return system
    end
}