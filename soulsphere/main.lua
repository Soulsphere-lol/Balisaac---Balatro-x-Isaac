SMODS.Atlas({
    key = "CustomJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomJokers2", 
    path = "CustomJokers2.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "custom_enhancers", 
    path = "custom_enhancers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})


SMODS.Enhancement {
    key = "poisoned",
    atlas = 'custom_enhancers',
    pos = { 
        x = 0, 
        y = 0 
    },
    config = {
        mult = 0, 
        extra = {  
            mult_mod = 1 
        }
    },
    loc_txt = {
        ['name'] = "Poisoned",
        ['text'] = {
            "This card gains +#2# {C:red}Mult{}",
            "when scored",
            "{C:inactive}(Currently{}{C:red} +#1# Mult{}{C:inactive}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.mult, card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.ability.mult = card.ability.mult + card.ability.extra.mult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT
                }
        end
    end,
}
        
        
    

SMODS.Joker{ --TheSadOnion
    name = "The Sad Onion",
    key = "j_bali_sadonion",
    config = {
        extra  = {
            hands = 2
        }
    },
    loc_txt = {
        ['name'] = 'The Sad Onion',
        ['text'] = {
           '+2 {C:blue}hands{}'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

   loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end,
}


SMODS.Joker{ --TheInnerEye
    name = "The Inner Eye",
    key = "j_bali_innereye",
    config = {
        extra = {
            repetitions = 1,
            type = 'Three of a Kind'
        }
    },
    loc_txt = {
        ['name'] = 'The Inner Eye',
        ['text'] = {
            'If played {C:blue}hand{} contains',
            'a {C:attention}Three of a Kind{},',
            'retrigger all {C:attention}scored{} cards'
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions, localize(card.ability.extra.type, 'poker_hands' ) } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and next(context.poker_hands["Three of a Kind"]) then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}
    

SMODS.Joker{ --SpoonBender
    name = "Spoon Bender",
    key = "j_bali_spoonbender",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = "Spoon Bender",
        ['text'] = {
            "The lowest ranked {C:attention}scored{} card",
            "gives {C:attention}half{} of it's value",
            "as {X:red,C:white}XMult{}"
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    cost = 5,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
         if context.individual and context.cardarea == G.play and not context.end_of_round then
            local temp_Mult, temp_ID = 15, 15
            local raised_card = nil
            for i = 1, #context.scoring_hand do
                if temp_ID >= context.scoring_hand[i].base.id and not SMODS.has_no_rank(G.play.cards[i]) then
                    temp_Mult = context.scoring_hand[i].base.nominal
                    temp_ID = context.scoring_hand[i].base.id
                    raised_card = context.scoring_hand[i]
                end
            end
            if raised_card == context.other_card then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        Xmult = 0.5 * temp_Mult
                    }
                end
            end
        end
    end
}


SMODS.Joker{ --CricketsHead
    name = "Cricket's Head",
    key = "j_bali_cricketshead",
    config = {
        extra = {
            d_size = 2
        }
    },
    loc_txt = {
        ['name'] = "Cricket's Head",
        ['text'] = {
             "+2 {C:red}discards{}"
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.d_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
        ease_discard(-card.ability.extra.d_size)
    end,
}


SMODS.Joker{ --MyReflection
    name = "My Reflection",
    key = "j_bali_myreflection",
    config = {
        extra = {
            odds = 4,
            repetitions = 1
        }
    },
    loc_txt = {
        ['name'] = "My Reflection",
        ['text'] = {
            "{C:green}1{} in {C:green}4{} chance to",
            "{C:attention}retrigger{} a scored card"
        }
    },
    pos = {
        x = 4,
        y = 0
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and
            pseudorandom('skallywobble') < G.GAME.probabilities.normal / card.ability.extra.odds then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end,
    }


SMODS.Joker{ --NumberOne
    name = "Number One",
    key = "j_bali_numberone",
    config = {
        extra = {
            mult = 0,
            mult_mod = 1,
            suit = "Diamonds"
        }
    },
    loc_txt = {
        ['name'] = "Number One",
        ['text'] = {
            "This Joker gains {C:red}+#2# Mult{}",
            "for each scored {C:diamonds}Diamond{} card",
            "{s:0.85}{C:inactive}(Currently {C:red}+#1# Mult{}{}{}{s:0.85}{C:inactive}){}{}"
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.suit } }
    end,
    calculate = function(self, card, context)
        if context.individual and not context.blueprint and not context.other_card.debuff and context.cardarea == G.play and
        context.other_card:is_suit(card.ability.extra.suit) then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}


SMODS.Joker{ --BloodOfTheMartyr
    name = "Blood Of The Martyr",
    key = "j_bali_bloodmartyr",
    config = {
        extra = {
            xmult = 1.25,
            suit = "Hearts"
        }
    },
    loc_txt = {
        ['name'] = "Blood Of The Martyr",
        ['text'] = {
            "All {C:Hearts}Heart{} cards held in hand",
            "each give {X:red,C:white}#1#X{} {C:red}Mult{}"
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.suit } }
    end,
    calculate = function(self, card, context)
         if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:is_suit(card.ability.extra.suit) then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
        end
    end,
}


SMODS.Joker{ --BrotherBobby
    name = "Brother Bobby",
    key = "j_bali_brotherbob",
    config = {
        extra = {
            suit = "Clubs"
        }
    },
    loc_txt = {
        ['name'] = "Brother Bobby",
        ['text'] = {
            "When {C:attention}Blind{} is selected,",
            "create a random {C:Clubs}#1#{} card",
            "and add it to your hand"
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.suit } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local _card = SMODS.create_card { set = "Base", suit = card.ability.extra.suit, area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            _card.playing_card = G.playing_card
            table.insert(G.playing_cards, _card)

            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:emplace(_card)
                    _card:start_materialize()
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    if context.blueprint_card then
                        context.blueprint_card:juice_up()
                    else
                        card:juice_up()
                    end
                    return true
                end
            }))
            SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
            return nil, true -- This is for Joker retrigger purposes
        end
    end,
}


SMODS.Joker{ --Skatole
    name = "Skatole",
    key = "j_bali_skatole",
    config = {
        extra = {
            type = "Three of a Kind"
        }
    },
    loc_txt = {
        ['name'] = "Skatole",
        ['text'] = {
            "If last hand of Blind",
            "contains a {C:attention}Three Of A Kind{},",
            "create a {C:attention}random card{} and add it to your deck"
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            local _card = SMODS.create_card { set = "Base", area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            _card.playing_card = G.playing_card
            table.insert(G.playing_cards, _card)

            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:emplace(_card)
                    _card:start_materialize()
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    if context.blueprint_card then
                        context.blueprint_card:juice_up()
                    else
                        card:juice_up()
                    end
                    return true
                end
            }))
            SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
            return nil, true -- This is for Joker retrigger purposes
        end
    end,
}


SMODS.Joker{ --HaloOfFlies
    name = "Halo Of Flies",
    key = "j_bali_haloflies",
    config = {
        extra = {
            odds = 8
        }
    },
    loc_txt = {
        ['name'] = "Halo Of Flies",
        ['text'] = {
            "{C:green}1{} in {C:green}#1#{} chance to",
            "disable the current {C:attention}Boss Blind{}"
        }
    },
    pos = {
        x = 4,
        y = 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.odds
              
            }
        }
    end,

    add_to_deck = function(self, card)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            if pseudorandom("halo_of_flies") < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.GAME.blind:disable()
                play_sound("timpani")
                SMODS.calculate_effect({ message = localize("ph_boss_disabled")}, card)
            end
        end
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and G.GAME.blind.boss then
            if pseudorandom("halo_of_flies") < G.GAME.probabilities.normal / card.ability.extra.odds then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.GAME.blind:disable()
                                        play_sound("timpani")
                                        delay(0.4)
                                        return true
                                    end
                                }))
                                SMODS.calculate_effect({ message = localize("ph_boss_disabled")}, card)
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}
--credit to The2ndLastJedi for the code above ^

SMODS.Joker { --1UP
    name = "1-UP",
    key = "j_bali_1up",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = "1-UP",
        ['text'] = {
            "{C:green}Extra life{}"
        }
    },
    pos = {
        x = 0,
        y = 2
    },
    soul_pos = {
        x = 1,
        y = 2
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and context.main_eval then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve()
                    play_sound("1up_save")
                    return true
                end
            }))
            return {
                message = localize('k_saved_ex'),
                saved = 'ph_1_up',
                colour = G.C.RED
            }
        end
    end,
}


SMODS.Joker{ --MagicMushroom
    name = "Magic Mushroom",
    key = "j_bali_magicmush",
    config = {
        extra = {
            hands = 1,
            d_size = 1,
            h_size = 1
        }
    },
    loc_txt = {
        ['name'] = "Magic Mushroom",
        ['text'] = {
            "+#2# {C:red}discard{},",
            "+#1# {C:blue}hand{},",
            "+#3# {C:gold}hand size{}"
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    cost = 5,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands, card.ability.extra.d_size, card.ability.extra.h_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    G.hand:change_size(-card.ability.extra.h_size)
    end
}


SMODS.Joker{ --TheVirus
    name = "The Virus",
    key = "j_bali_thevirus",
    config = {
        extra = {
            odds = 4
        }
    },
    loc_txt = {
        ['name'] = "The Virus",
        ['text'] = {
            "{C:green}1{} in {C:green}5{} chance to",
            "{C:green,T:poisoned}Poison{} all scored cards"
        }
    },
    pos = {
        x = 3,
        y = 2
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_balisaac_poisoned
    end,
    calculate = function(self, card, context)
        if pseudorandom("lavirus") < G.GAME.probabilities.normal / card.ability.extra.odds then
            if context.before and context.main_eval and not context.blueprint then
            for _, scored_card in ipairs(context.scoring_hand) do
            scored_card:set_ability('m_balisaac_poisoned', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end
}


SMODS.Joker{ --RoidRage
    name = "Roid Rage",
    key = "j_bali_roidrage",
    config = {
        extra = {
            mult = 35,
            mult_mod = 5,
            base_mult = 35
        }
    },
    loc_txt = {
        ['name'] = "Roid Rage",
        ['text'] = {
            "{C:red}+#1# Mult{}, {C:red}-#2# Mult{} per",
            "scored face card",
            "{s:0. 85,C:inactive}Resets when blind is selected{}"   
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
                return {
                    message = localize('k_roidrage'),
                    colour = G.C.GREEN
                }
        end
        if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
        end
        if context.first_hand_drawn then
            card.ability.extra.mult = card.ability.extra.base_mult
        end
    end
}


SMODS.Joker{ --<3
    name = "<3",
    key = "j_bali_heart",
    config = {
        extra = {
            suit = "Hearts",
            xmult = 2
        }
    },
    loc_txt = {
        ['name'] = "<3",
        ['text'] = {
            "{C:attention}Ace{} of {C:red}Hearts{} and {C:attention}2{} of {C:red}Hearts{}",
            "give {X:red,C:white}#2#X{} {C:red}Mult{}"
        }
    },
    pos = {
        x = 0,
        y = 3
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.suit, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) and
                 (context.other_card:get_id() == 14 or context.other_card:get_id() == 2) then
                    return {
                        Xmult = card.ability.extra.xmult
                    }
                end
            end
}


SMODS.Joker{ --RawLiver
    name = "Raw Liver",
    key = "j_bali_rawliver",
    config = {
        extra = {
            chips = 35,
            suit = "Clubs"
        }
    },
    loc_txt = {
        ['name'] = "Raw Liver",
        ['text'] =  {
            "All {C:Clubs}Club{} cards give",
            "{C:chips}+#1# Chips{}"
        }
    },
    pos = {
        x = 1,
        y = 3
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.suit } }
    end,
    calculate = function(self, card, context)
        if context.individual and not context.blueprint and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then
                return {
                    chips = card.ability.extra.chips
                }
        end
    end
}


SMODS.Joker{ --SkeletonKey
    name = "Skeleton Key",
    key = "j_bali_skelekey",
    config = {
        extra = {
            h_size = 10,
            h_mod = 1
        }
    },
    loc_txt = {
        ['name'] = "Skeleton Key",
        ['text'] = {
            "{C:gold}+#1# hand size,",
            "-#2# hand size per {C:blue}hand played{}"
        }
    },
    pos = {
        x = 2,
        y = 3
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.h_size, card.ability.extra.h_mod } }
    end,
    calculate = function(self, card, context)
        if context.after and context.main_eval and not context.blueprint then
           if card.ability.extra.h_size - card.ability.extra.h_mod <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('glass4')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = localize('k_broken'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.h_size = card.ability.extra.h_size - card.ability.extra.h_mod
                G.hand:change_size(-card.ability.extra.h_mod)
                return {
                    message = localize { type = 'variable', key = 'a_handsize_minus', vars = { card.ability.extra.h_mod } },
                    colour = G.C.FILTER
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end
}


SMODS.Joker{ --ADollar
    name = "A Dollar",
    key = "j_bali_dollar",
    config = {
        extra = {
            price = 95,
            dollar_rounds = 0,
            total_rounds = 3,
            rounds_left = 3
        }    
    },
    loc_txt = {
        ['name'] = "A Dollar",
        ['text'] = {
            "After {C:attention}#4#{} rounds, sell this card",
            "for {C:gold}$100{}"
        }
    },
    pos = {
        x = 3,
        y = 3
    },
    cost = 10,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.price, card.ability.extra.dollar_rounds, card.ability.extra.total_rounds, card.ability.extra.rounds_left } }
        end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.dollar_rounds = card.ability.extra.dollar_rounds + 1
            card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.dollar_rounds == card.ability.extra.total_rounds then
                    card.ability.extra_value = card.ability.extra.price
                    card:set_cost(card.ability.extra.price)
                    local eval = function(card) return not card.REMOVED end
                    juice_card_until(card, eval, true)
                end
        end
    end
}


SMODS.Joker{ --Boom!
    name = "Boom!",    
    key = "j_bali_boom",
    config = {
        extra = {
            d_size = 4,
            discards = 60
        }    
    },
    loc_txt = {
        ['name'] = "Boom!",
        ['text'] = {
            "{C:red}+#1# Discards{}, {C:attention}self-destructs{}",
            "after {C:red}#2#{} discards"
        }
    },
    pos = {
        x = 4,
        y = 3
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.d_size, card.ability.extra.discards } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
        ease_discard(-card.ability.extra.d_size)
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and not context.other_card.debuff then
            card.ability.extra.discards = card.ability.extra.discards - 1
            if card.ability.extra.discards == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('kaboom')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = localize('k_boom'),
                    colour = G.C.FILTER
                }
            end
        end
    end
}


SMODS.Joker{ --Transendence
    name = "Transendence",
    key = "j_bali_trans",
    config = {
        extra = {
            xmult = 1.5,
            face = false,
            number = false
        }
    },
    loc_txt = {
        ['name'] = "Transendence",
        ['text'] = {
            "{X:red,C:white}1.5X{} Mult if both a",
            "{C:attention}face card{} and a {C:attention}7{} are scored"
        },
        ['unlock'] = {
            "Win {C:attention}3{} runs"
        }
    },
    pos = {
        x = 0,
        y = 4
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            card.ability.extra.face = true
        end
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 then
            card.ability.extra.number = true
        end
        if card.ability.extra.number and card.ability.extra.face then
            if context.joker_main then
                card.ability.extra.face = false
                card.ability.extra.number = false
                return {
                    xmult = card.ability.extra.xmult
                }
                end
        end
    end,
    check_for_unlock = function(self, args)
        if G.PROFILES[G.SETTINGS.profile].career_stats.c_wins >= 3 then
            unlock_card(self)
        end
            return false
    end
}


SMODS.Joker{ --TheCompass
    name = "The Compass",
    key = "j_bali_compass",
    config = {
        extra = {
            mult = 40,
            mult_mod = 10
        }
    },
    loc_txt = {
        ['name'] = "The Compass",
        ['text'] = {
            "{C:red}+#1# Mult{}, -{C:red}10{} Mult",
            "when skipping a {C:attention}Blind{}"
        }
    },
    pos = {
        x = 1,
        y = 4
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.mult - (card.ability.extra.mult_mod * G.GAME.skips) } 
        }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
                if card.ability.extra.mult == 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('glass1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    card:remove()
                                    return true
                                end
                            }))
                        return true
                        end
                    }))
                    return {
                        message = localize('k_roidrage'),
                        colour = G.C.MULT
                    }
                end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end 
    end
}


SMODS.Joker{ --Lunch
    name = "Lunch",
    key = "j_bali_lunch",
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.1
        }
    },
    loc_txt = {
        ['name'] = "Lunch",
        ['text'] = {
            "{X:red,C:white}X#2#{} {C:red}Mult{} per card",
            "{C:red}Discarded{} {C:attention}this round{}",
            "{C:inactive}(Currently{} {X:red,C:white}X#1#{} {C:inactive}Mult{})"
        }
    },
    pos = {
        x = 2,
        y = 4
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
        end
        if context.pre_discard then card.ability.active = true end
        if context.hand_drawn and card.ability.active then
        card.ability.active = nil
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.end_of_round and not context.game_over and context.main_eval then
            card.ability.extra.xmult = 1
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}


SMODS.Joker{ --Dinner
    name = "Dinner",
    key = "j_bali_dinner",
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.2
        }
    },
    loc_txt = {
        ['name'] = "Dinner",
        ['text'] = {
            "{X:red,C:white}X#2#{} {C:red}Mult{} per",
            "{C:attention}card scored{} this round",
            "{C:inactive}(Currently {}{X:red,C:white}X#1#{} {C:inactive}Mult){}"
        }
    },
    pos = {
        x = 3,
        y = 4
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.end_of_round and not context.game_over and context.main_eval then
            card.ability.extra.xmult = 1
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}


SMODS.Joker{ --Dessert
    name = "Dessert",
    key =  "j_bali_dessert",
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.05
        }
    },
    loc_txt = {
        ['name'] = "Dessert",
        ['text'] = {
            "{X:red,C:white}X0.05{} {C:red}Mult{} per remaining",
            "card in {C:attention}deck{}",
            "{C:inactive}(Currently{} {X:red,C:white}X#1#{} {C:inactive}Mult){}"
        }
    },
    pos = {
        x = 4,
        y = 4
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod, card.ability.extra.xmult_mod * ((G.deck and G.deck.cards) and #G.deck.cards or 52) }
        }
    end,
    calculate = function(self, card, context)
        if context.hand_drawn then
            card.ability.extra.xmult = 1 + card.ability.extra.xmult_mod * #G.deck.cards
        end
        if context.joker_main then
            return{
                xmult = card.ability.extra.xmult
            }
        end
    end
}


SMODS.Joker{ --Breakfast
    name = "Breakfast",
    key = "j_bali_breakfast",
    config = {
        extra = {
            chips = 0
        }
    },
    loc_txt = {
        ['name'] = "Breakfast",
        ['text'] = {
            "Permanently gain {C:blue}+1 Chips{} for",
            "every card scored",
            "{C:inactive}(Currently{} {C:blue}+#1#{} {C:inactive}Chips)"
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers2',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + 1
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}


SMODS.Joker{ --RottenMeat
    name = "Rotten Meat",
    key = "j_bali_rotten",
    config = {
        extra = {
            mult = 0
        }
    },
    loc_txt = {
        ['name'] = "Rotten Meat",
        ['text'] = {
            "Permanently gain {C:red}+1 Mult{} for",
            "every card Discarded",
            "{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult)"
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers2',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + 1
        end
        if context.pre_discard then card.ability.active = true end
        if context.hand_drawn and card.ability.active then
        card.ability.active = nil
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}


SMODS.Joker{ --WoodenSpoon
    name = 'Wooden Spoon',
    key = 'j_bali_spoon',
    config = {
        extra = {
            xmult = 2,
            suit = "Spades"
        }
    },
    loc_txt = {
        ['name'] = "Wooden Spoon",
        ['text'] = {
            "{X:red,C:white}X#1#{}{C:red} Mult{} if hand includes",
            "a {C:Spades}Spade{} card"
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers2',

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.suit }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
           for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card:is_suit(card.ability.extra.suit) then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    end
}