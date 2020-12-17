
return {
    name = "Blindness",
    description = "A complete loss of one of your five senses",
    canGetRandomly = true,
    immuneFactions = { FACTION_MPF, FACTION_OTA },

    functionsIsClientside = true,
    OnCall = [[
        local function blind()
            alpha = math.abs(math.cos(RealTime() * .5) * 255)
            draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), ColorAlpha(Color(0,0,0), alpha))
        end
        hook.Add("HUDPaint", "Diseases_blindness", blind)
    ]],
    OnEnd = [[
        hook.Remove("HUDPaint", "Diseases_blindness")
    ]]
}
