meta.name = 'More Coffins'
meta.version = '0.0.3'
meta.description = 'add coffins to 7-30, 7-70'
meta.author = 'fienestar'
meta.online_safe = true

local function pick(from)
    return from[prng:random(#from)]
end

last_coffin = {0,0}

set_callback(function(ctx)
    if state.level == 29 or state.level == 69 then
        -- the number of orb always zero in POST_ROOM_GENERATION
        -- #get_entities_by_type(ENT_TYPE.ITEM_FLOATING_ORB)

        if get_room_template(last_coffin[1], last_coffin[2], LAYER.FRONT) == ROOM_TEMPLATE.COFFIN_PLAYER_VERTICAL then
            return
        end

        local coffin_candidates = {}
        for rx=0,state.width-1 do
            for ry=0,state.height-1 do
                if get_room_template(rx, ry, LAYER.FRONT) == ROOM_TEMPLATE.SIDE then
                    table.insert(coffin_candidates, {rx, ry})
                end
            end
        end

        local need_coffin_count = 0
        for i=1, state.items.player_count do
            if state.items.player_inventory[i].health == 0 then
                need_coffin_count = need_coffin_count + 1
            end
        end

        if need_coffin_count > #coffin_candidates then
            need_coffin_count = #coffin_candidates
        end

        for i=0, need_coffin_count-1 do
            local pos = pick(coffin_candidates)
            while get_room_template(pos[1], pos[2], LAYER.FRONT) ~= ROOM_TEMPLATE.SIDE do
                pos = pick(coffin_candidates)
            end

            -- coffin code for CO is COFFIN_PLAYER_VERTICAL
            -- NOT COFFIN_PLAYER
            last_coffin = pos
            ctx:set_room_template(pos[1], pos[2], LAYER.FRONT, ROOM_TEMPLATE.COFFIN_PLAYER_VERTICAL)
        end
    end
end, ON.POST_ROOM_GENERATION)