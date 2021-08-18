
local PLUGIN = PLUGIN

function PLUGIN:InitializedPlugins()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Russian"
        LANGUAGE.uniqueID = "language_ru"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ru.png"
        LANGUAGE.format = "%s speaks in russian \"%s\""
        LANGUAGE.formatUnknown = "%s says something in russian"

        LANGUAGE.formatWhispering = "%s whispers in russian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in russian"

        LANGUAGE.formatYelling = "%s yelling in russian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in russian"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "German"
        LANGUAGE.uniqueID = "language_ger"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/de.png"
        LANGUAGE.format = "%s speaks in german \"%s\""
        LANGUAGE.formatUnknown = "%s says something in german"

        LANGUAGE.formatWhispering = "%s whispers in german \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in german"

        LANGUAGE.formatYelling = "%s yelling in german \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in german"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Bulgarian"
        LANGUAGE.uniqueID = "language_bg"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/bg.png"
        LANGUAGE.format = "%s speaks in bulgarian \"%s\""
        LANGUAGE.formatUnknown = "%s says something in bulgarian"

        LANGUAGE.formatWhispering = "%s whispers in bulgarian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in bulgarian"

        LANGUAGE.formatYelling = "%s yelling in bulgarian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in bulgarian"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Arabic"
        LANGUAGE.uniqueID = "language_ara"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/sa.png"
        LANGUAGE.format = "%s speaks in arabic \"%s\""
        LANGUAGE.formatUnknown = "%s says something in arabic"

        LANGUAGE.formatWhispering = "%s whispers in arabic \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in arabic"

        LANGUAGE.formatYelling = "%s yelling in arabic \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in arabic"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Vortigese"
        LANGUAGE.uniqueID = "language_vo"
        LANGUAGE.category = "Off-Human"
        LANGUAGE.chatIcon = "icon16/bullet_star.png"
        LANGUAGE.format = "%s speaks in vortigese \"%s\""
        LANGUAGE.formatUnknown = "%s says something in vortigese"

        LANGUAGE.formatWhispering = "%s whispers in vortigese \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in vortigese"

        LANGUAGE.formatYelling = "%s yelling in vortigese \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in vortigese"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Xenian"
        LANGUAGE.uniqueID = "language_xen"
        LANGUAGE.category = "Off-Human"
        LANGUAGE.chatIcon = "icon16/flag_red.png"
        LANGUAGE.format = "%s speaks in xenian \"%s\""
        LANGUAGE.formatUnknown = "%s says something in xenian"

        LANGUAGE.formatWhispering = "%s whispers in xenian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in xenian"

        LANGUAGE.formatYelling = "%s yelling in xenian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in xenian"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Hindi"
        LANGUAGE.uniqueID = "language_hin"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/in.png"
        LANGUAGE.format = "%s speaks in hindi \"%s\""
        LANGUAGE.formatUnknown = "%s says something in hindi"

        LANGUAGE.formatWhispering = "%s whispers in hindi \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in hindi"

        LANGUAGE.formatYelling = "%s yelling in hindi \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in hindi"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Bengali"
        LANGUAGE.uniqueID = "language_ben"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/bd.png"
        LANGUAGE.format = "%s speaks in bengali \"%s\""
        LANGUAGE.formatUnknown = "%s says something in bengali"

        LANGUAGE.formatWhispering = "%s whispers in bengali \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in bengali"

        LANGUAGE.formatYelling = "%s yelling in bengali \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in bengali"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Italian"
        LANGUAGE.uniqueID = "language_ita"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/it.png"
        LANGUAGE.format = "%s speaks in italian \"%s\""
        LANGUAGE.formatUnknown = "%s says something in italian"

        LANGUAGE.formatWhispering = "%s whispers in italian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in italian"

        LANGUAGE.formatYelling = "%s yelling in italian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in italian"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Japanese"
        LANGUAGE.uniqueID = "language_jap"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/jp.png"
        LANGUAGE.format = "%s speaks in japanese \"%s\""
        LANGUAGE.formatUnknown = "%s says something in japanese"

        LANGUAGE.formatWhispering = "%s whispers in japanese \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in japanese"

        LANGUAGE.formatYelling = "%s yelling in japanese \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in japanese"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Portuguese"
        LANGUAGE.uniqueID = "language_por"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/pt.png"
        LANGUAGE.format = "%s speaks in portuguese \"%s\""
        LANGUAGE.formatUnknown = "%s says something in portuguese"

        LANGUAGE.formatWhispering = "%s whispers in portuguese \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in portuguese"

        LANGUAGE.formatYelling = "%s yelling in portuguese \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in portuguese"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Spanish"
        LANGUAGE.uniqueID = "language_spa"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/es.png"
        LANGUAGE.format = "%s speaks in spanish \"%s\""
        LANGUAGE.formatUnknown = "%s says something in spanish"

        LANGUAGE.formatWhispering = "%s whispers in spanish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in spanish"

        LANGUAGE.formatYelling = "%s yelling in spanish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in spanish"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Farsi"
        LANGUAGE.uniqueID = "language_far"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ir.png"
        LANGUAGE.format = "%s speaks in farsi \"%s\""
        LANGUAGE.formatUnknown = "%s says something in farsi"

        LANGUAGE.formatWhispering = "%s whispers in farsi \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in farsi"

        LANGUAGE.formatYelling = "%s yelling in farsi \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in farsi"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Malay"
        LANGUAGE.uniqueID = "language_mal"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/my.png"
        LANGUAGE.format = "%s speaks in malay \"%s\""
        LANGUAGE.formatUnknown = "%s says something in malay"

        LANGUAGE.formatWhispering = "%s whispers in malay \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in malay"

        LANGUAGE.formatYelling = "%s yelling in malay \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in malay"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Swahili"
        LANGUAGE.uniqueID = "language_swa"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ke.png"
        LANGUAGE.format = "%s speaks in swahili \"%s\""
        LANGUAGE.formatUnknown = "%s says something in swahili"

        LANGUAGE.formatWhispering = "%s whispers in swahili \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in swahili"

        LANGUAGE.formatYelling = "%s yelling in swahili \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in swahili"
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Urdu"
        LANGUAGE.uniqueID = "language_urd"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ly.png"
        LANGUAGE.format = "%s speaks in urdu \"%s\""
        LANGUAGE.formatUnknown = "%s says something in urdu"

        LANGUAGE.formatWhispering = "%s whispers in urdu \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in urdu"

        LANGUAGE.formatYelling = "%s yelling in urdu \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in urdu"
    LANGUAGE:Register()
end