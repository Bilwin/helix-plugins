
util.AddNetworkString('ixRadio')

net.Receive("ixRadio", function(_, pl)
    	local radio = net.ReadEntity()
    	local songPath = net.ReadString()
    	if !IsValid(radio) and !IsEntity(radio) then return end
    	if radio:GetClass() ~= "ix_radio" then return end

	    if radio:GetPos():DistToSqr( pl:GetPos() ) > 50000 then return end
	    radio:SelectSong( songPath )
end)

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs( ents.FindByClass("ix_radio") ) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("ixRadios", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs( ix.data.Get("ixRadios") or {} ) do
		local dispenser = ents.Create("ix_radio")

		dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
		dispenser:Spawn()
	end
end
