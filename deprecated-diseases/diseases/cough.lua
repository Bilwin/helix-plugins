
return {
    name = "Cough",
    description = "A regular cough, generally not dangerous at all",
    canGetRandomly = true,
    immuneFactions = { FACTION_MPF, FACTION_OTA },

    OnCall = function( pl )
        pl:_SetTimer( "diseaseCough::" .. pl:SteamID64(), 30, 0, function()
            pl:EmitSound( "ambient/voices/cough" .. math.random(1, 4) .. ".wav" )
            pl:ScreenFade( SCREENFADE.IN, Color(0, 0, 0, 200), 0.3, 0 )
            ix.chat.Send( pl, "me", "coughs" )

            for k, v in pairs( ents.FindInSphere(pl:GetPos(), 500) ) do
                if ( IsValid(v) and v:IsPlayer() and v:GetCharacter() and math.random(1,20) > 17 ) then
                    ix.Diseases:InfectPlayer( v, "cough" )
                end
            end
        end )
        pl:_SetSimpleTimer( 60 * 15, function()
            ix.Diseases.Loaded["cough"].OnEnd(pl)
        end )
    end,

    OnEnd = function( pl )
        if pl:_TimerExists( "diseaseCough::" .. pl:SteamID64() ) then
            pl:_RemoveTimer( "diseaseCough::" .. pl:SteamID64() )
        end
    end
}
