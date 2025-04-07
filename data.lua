-- Rate at which the tiles propogate
local rate = settings.startup["gradual-nuke-destruction-spread-rate"].value


----------
-- Decoratives

local decorative_spawns = table.deepcopy(data.raw["projectile"]["atomic-rocket"].action.action_delivery.target_effects[14])

-- Craeate decorative
data:extend({{
    type = "delayed-active-trigger",
    name = "gradual-nuke-destruction-spawn-decoratives",
    delay = 13 * rate,
    action = {
        type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = decorative_spawns
        }
    }
}})

data.raw["projectile"]["atomic-rocket"].action.action_delivery.target_effects[14] = {
    type = "nested-result",
    action = {
        type = "direct",
        action_delivery = {
            type = "delayed",
            delayed_trigger = "gradual-nuke-destruction-spawn-decoratives"
        }
    }
}

----------
-- "Nauvis" tiles
-- Despite being used on all planets, this is used to convert tiles to fallout on all planets.

-- Custom surface condition to blacklist some planets
data:extend({{
    type = "surface-property",
    name = "gradual-nuke-destruction-blacklist-property",
    default_value = 0.0
}})

-- Mark Vulcanus and Aquilo to skip this 
-- Other mods can opt to add this property to their planets if it applies to them
data.raw["planet"]["vulcanus"].surface_properties["gradual-nuke-destruction-blacklist-property"] = 1.0
data.raw["planet"]["aquilo"].surface_properties["gradual-nuke-destruction-blacklist-property"] = 1.0
-- Space platforms are by default unable to be fallout-ed so no need to check that

-- Apply blacklist
data.raw["explosion"]["nuke-effects-nauvis"].surface_conditions = {
    {
        property = "gradual-nuke-destruction-blacklist-property",
        max = 0.001
    }
}

-- Generate the fallout tiles
for i = 1,12,1 do
    data:extend({{
        type = "delayed-active-trigger",
        name = "gradual-nuke-destruction-delayed-nauvis-"..tostring(i),
        delay = i * rate,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "set-tile",
                    tile_name = "nuclear-ground",
                    tile_collision_mask = {
                        layers = {
                            out_of_map = true
                        }
                    },
                    apply_projection = true,
                    radius = i
                }
            }
        }
    }})
end

data.raw["explosion"]["nuke-effects-nauvis"].created_effect.action_delivery = {}

for i = 1,12,1 do
    data.raw["explosion"]["nuke-effects-nauvis"].created_effect.action_delivery[i] = {
        type = "delayed",
        delayed_trigger = "gradual-nuke-destruction-delayed-nauvis-"..tostring(i)
    }
end


----------
-- Vulcanus tiles

-- Generate the inner delay tiles
for i = 1,8,1 do
    data:extend({{
        type = "delayed-active-trigger",
        name = "gradual-nuke-destruction-delayed-vulcanus-"..tostring(i),
        delay = i * rate,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "set-tile",
                    tile_name = "lava-hot",
                    tile_collision_mask = {
                        layers = {
                            out_of_map = true
                        }
                    },
                    apply_projection = true,
                    radius = i
                }
            }
        }
    }})
end

-- Generate the outer delay tiles, blacklisting the existing lava
for i = 9,12,1 do
    data:extend({{
        type = "delayed-active-trigger",
        name = "gradual-nuke-destruction-delayed-vulcanus-"..tostring(i),
        delay = (8 + i) * rate,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "set-tile",
                    tile_name = "lava",
                    tile_collision_mask = {
                        layers = {
                            water_tile = true
                        }
                    },
                    apply_projection = true,
                    radius = i
                }
            }
        }
    }})
end


data.raw["explosion"]["nuke-effects-vulcanus"].created_effect.action_delivery = {}

for i = 1,12,1 do
    data.raw["explosion"]["nuke-effects-vulcanus"].created_effect.action_delivery[i] = {
        type = "delayed",
        delayed_trigger = "gradual-nuke-destruction-delayed-vulcanus-"..tostring(i)
    }
end

----------
-- Aquilo

-- Generate the inner delay tiles
for i = 1,8,1 do
    data:extend({{
        type = "delayed-active-trigger",
        name = "gradual-nuke-destruction-delayed-aquilo-"..tostring(i),
        delay = i * rate,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "set-tile",
                    tile_name = "ammoniacal-ocean",
                    tile_collision_mask = {
                        layers = {
                            out_of_map = true
                        }
                    },
                    apply_projection = true,
                    radius = i
                }
            }
        }
    }})
end

-- Generate the outer delay tiles, blacklisting the existing ocean
for i = 9,12,1 do
    data:extend({{
        type = "delayed-active-trigger",
        name = "gradual-nuke-destruction-delayed-aquilo-"..tostring(i),
        delay = (8 + i) * rate,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "set-tile",
                    tile_name = "brash-ice",
                    tile_collision_mask = {
                        layers = {
                            water_tile = true
                        }
                    },
                    apply_projection = true,
                    radius = i
                }
            }
        }
    }})
end


data.raw["explosion"]["nuke-effects-aquilo"].created_effect.action_delivery = {}

for i = 1,12,1 do
    data.raw["explosion"]["nuke-effects-aquilo"].created_effect.action_delivery[i] = {
        type = "delayed",
        delayed_trigger = "gradual-nuke-destruction-delayed-aquilo-"..tostring(i)
    }
end

----------
-- Space, this one works by damaging the tile instead
-- Some niche mod interactions could arise if mods have space foundations with thousands of hp

-- Damage the inner delay tiles
for i = 1,8,1 do
    data:extend({{
        type = "delayed-active-trigger",
        name = "gradual-nuke-destruction-delayed-space-"..tostring(i),
        delay = i * rate,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "damage-tile",
                    damage = {
                        amount = 1000,
                        type = "explosion"
                    },
                    radius = i
                }
            }
        }
    }})
end

-- Generate the outer delay tiles, blacklisting the existing ocean
for i = 9,12,1 do
    data:extend({{
        type = "delayed-active-trigger",
        name = "gradual-nuke-destruction-delayed-space-"..tostring(i),
        delay = (8 + i) * rate,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "damage-tile",
                    damage = {
                        amount = 15, -- 50 damage usually, spread out more gradually
                        type = "explosion"
                    },
                    radius = i
                }
            }
        }
    }})
end


data.raw["explosion"]["nuke-effects-space"].created_effect.action_delivery = {}

for i = 1,12,1 do
    data.raw["explosion"]["nuke-effects-space"].created_effect.action_delivery[i] = {
        type = "delayed",
        delayed_trigger = "gradual-nuke-destruction-delayed-space-"..tostring(i)
    }
end