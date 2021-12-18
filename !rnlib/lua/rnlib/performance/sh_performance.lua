
hook.Add('InitPostEntity', 'rnlib.performance', function()
    local physData 	= physenv.GetPerformanceSettings()
        physData.MaxVelocity 						= 1000
        physData.MaxCollisionChecksPerTimestep		= 10000
        physData.MaxCollisionsPerObjectPerTimestep 	= 2
        physData.MaxAngularVelocity					= 3636
	physenv.SetPerformanceSettings(physData)
end)

if SERVER then
    hook.Add('PlayerInitialSpawn', 'rnlib.performance', function(client)
        netstream.Start(client, 'rnlib.performance')
    end)
end

if CLIENT then
    local cmds = {
        ['gmod_mcore_test'] = 1,
        ['r_queued_ropes'] = 1,
        ['cl_threaded_bone_setup'] = 1,
        ['cl_threaded_client_leaf_system'] = 1,
        ['mat_queue_mode'] = -1,
        ['r_threaded_client_shadow_manager'] = 1,
        ['r_threaded_particles'] = 1,
        ['r_threaded_renderables'] = 1,
        ['mat_fastspecular'] = 0,
        ['studio_queue_mode'] = 1,

        -- network
        ['rate'] = 2097152,
        ['cl_updaterate'] = 22,
        ['net_maxfragments'] = 1792
    }

    netstream.Hook('rnlib.performance', function()
        for c, v in pairs(cmds) do
            RunConsoleCommand(c, v)
            rnlib.p('PERF > "%s" value changed to "%s"', c, v)
        end

        hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
        hook.Remove("RenderScreenspaceEffects", "RenderBloom")
        hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
        hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
        hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
        hook.Remove("RenderScreenspaceEffects", "RenderSobel")
        hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
        hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
        hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
        hook.Remove("RenderScene", "RenderStereoscopy")
        hook.Remove("RenderScene", "RenderSuperDoF")
        hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
        hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
        hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
        hook.Remove("PostRender", "RenderFrameBlend")
        hook.Remove("PreRender", "PreRenderFrameBlend")
        hook.Remove("Think", "DOFThink")
        hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
        hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
        hook.Remove("PostDrawEffects", "RenderWidgets")
        hook.Remove("PostDrawEffects", "RenderHalos")
    end)
end