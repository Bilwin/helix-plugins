
PLUGIN.name = "CP Jobs"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Даёт возможность брать работу ГэО без вайтЛиста, с помощью NPC"

ix.util.Include("sh_cmds.lua")
ix.util.Include("sv_plugin.lua")

ix.ranks.Create('cdt', {
	name = 'Кадет',
	description = "Кадет гражданский обороны, только что вступил в ряды Гражданской Обороны и не имеет никаких привилегий",
	xp = 0,
	armband_code = "(255,255,255)_2_(255,0,0,255)_1_(255,255,255,255)_0",
	hide = true,
	CanTransfer = false
})

if CLIENT then
	netstream.Hook("ixCPRecruitOpen", function()
		vgui.Create("ixCP_Recruit")
	end)

	net.Receive("ixCombineDisplayUpdate", function(len)
		local boolean = net.ReadBool()
		if boolean then
			vgui.Create("ixCombineDisplay")
		else
			if IsValid(ix.gui.combine) then
				ix.gui.combine:Remove()
			end
		end
	end)
end