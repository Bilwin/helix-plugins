
PLUGIN.name = 'ViewBob'
PLUGIN.schema = 'Any'
PLUGIN.version = 1.0

if CLIENT then
    local ViewBobTime = 0
    local ViewBobIntensity = 1
    local BobEyeFocus = 512
    local rateScaleFac = math.pi
    local rate_up = 4 * rateScaleFac
    local scale_up = 0.3
    local rate_right = 2 * rateScaleFac
    local scale_right = 0.3
    local LastCalcViewBob = 0
    local sv_cheats_cv = GetConVar("sv_cheats")
    local host_timescale_cv = GetConVar("host_timescale")
    local AngularCompensation = 1
    local MinimumFocus = 128

	ix.option.Add("cbobIntensity", ix.type.number, 1, {
		category = "ViewBob", min = 0.1, max = 1, decimals = 1
	})

	ix.option.Add("cbobCompensation", ix.type.number, 1, {
		category = "ViewBob", min = 0.1, max = 1, decimals = 1
	})

	ix.option.Add("disablevbob", ix.type.bool, false, {
		category = "ViewBob"
	})

    local function Viewbob(pos, ang, time, intensity)
        local ply = GetViewEntity()
        if not IsValid(ply) then return end
        if not ply:IsPlayer() then return end
        if ply:GetLocalVar("bIsHoldingObject", false) then return end
        --if ix.option.Get("thirdpersonEnabled", false) then return end
        local eang = ply:EyeAngles()
        local up = eang:Up()
        local ri = eang:Right()
        local opos = pos * 1
        local tr = ply:GetEyeTraceNoCursor()
        if not tr then return end
        if not tr.HitPos then return end
        local ldist = tr.HitPos:Distance(pos)
        local delta = math.min(SysTime() - LastCalcViewBob, FrameTime(), 1 / 30)

        if sv_cheats_cv:GetBool() then
            delta = delta * host_timescale_cv:GetFloat()
        end

        delta = delta * game.GetTimeScale()
        LastCalcViewBob = SysTime()

        if ldist <= 0 then
            local e = ply:GetEyeTraceNoCursor().Entity

            if not (IsValid(e) and not e:IsWorld()) then
                e = nil
            end

            ldist = util.QuickTrace(pos, eang:Forward() * 999999, {ply, e}).HitPos:Distance(pos)
        end

        ldist = math.max(ldist, MinimumFocus)
        BobEyeFocus = math.Approach(BobEyeFocus, ldist, (ldist - BobEyeFocus) * delta * 5)
        pos:Add(up * math.sin((time + 0.5) * rate_up) * scale_up * intensity * -7)
        pos:Add(ri * math.sin((time + 0.5) * rate_right) * scale_right * intensity * -7)
        local tpos = opos + BobEyeFocus * eang:Forward()
        local oang = eang * 1
        local nang = (tpos - pos):GetNormalized():Angle()
        eang:Normalize()
        nang:Normalize()
        local vfac = math.Clamp(1 - math.pow(math.abs(oang.p) / 90, 3), 0, 1) * (math.Clamp(ldist / 196, 0, 1) * 0.7 + 0.3) * AngularCompensation * ix.option.Get('cbobCompensation', 1)
        ang.y = ang.y - math.Clamp(math.AngleDifference(eang.y, nang.y), -2, 2) * vfac
        ang.p = ang.p - math.Clamp(math.AngleDifference(eang.p, nang.p), -2, 2) * vfac

        return pos, ang
    end

    local function AirWalkScale(ply)
        return ply:IsOnGround() and 1 or 0.2
    end

    function PLUGIN:PreRender()
        local ply = GetViewEntity()
        if not IsValid(ply) then return end
        if not ply:IsPlayer() then return end
        if ply:InVehicle() then return end
        if (IsValid(ix.gui.characterMenu)) then return end
        if (IsValid(pace.editorMenu)) then return end
        if (IsValid(ply.ixScanner)) then return end
        if ix.option.Get("thirdpersonEnabled", false) then return end
        if ix.option.Get("disablevbob", false) then return end
        if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
        local rawVel = ply:GetVelocity()
        local velocity = math.max(rawVel:Length2D() * AirWalkScale(ply) - rawVel.z * 0.5, 0)
        local rate = math.Clamp(math.sqrt(velocity / ply:GetRunSpeed()) * 1.75, 0.15, 2)
        ViewBobTime = ViewBobTime + FrameTime() * rate
        ViewBobIntensity = 0.15 + velocity / ply:GetRunSpeed()
    end

    local ISCALC = false

    function PLUGIN:CalcView(ply, pos, ang, ...)
        if IsValid(ply) and ply:InVehicle() then return end
        if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
        if (IsValid(pace.editorMenu)) then return end
        if (IsValid(ply.ixScanner)) then return end
        if ISCALC then return end
        ISCALC = true
        local tmptbl = hook.Run("CalcView", ply, pos, ang, ...) or {}
        ISCALC = false
        tmptbl.origin = tmptbl.origin or pos
        tmptbl.angles = tmptbl.angles or ang
        tmptbl.fov = tmptbl.fov or fov
        tmptbl.origin, tmptbl.angles = Viewbob(tmptbl.origin, tmptbl.angles, ViewBobTime, ViewBobIntensity * ix.option.Get('cbobIntensity', 1))

        return tmptbl
    end

    local ISCALCVM = false

    function PLUGIN:CalcViewModelView(wep, vm, oPos, oAng, pos, ang, ...)
        if ISCALCVM then return end
        ISCALCVM = true
        local tPos, tAng = hook.Run("CalcViewModelView", wep, vm, oPos, oAng, pos, ang, ...)
        ISCALCVM = false
        pos = tPos or pos
        ang = tAng or ang
        pos, ang = Viewbob(pos, ang, ViewBobTime, ViewBobIntensity * ix.option.Get('cbobIntensity', 1))

        return pos, ang
    end
end