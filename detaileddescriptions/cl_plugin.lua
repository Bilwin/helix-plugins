
local VScale = function(size) return size * (ScrH() / 480.0) end
local SScaleMin = function(size) return math.min(SScale(size), VScale(size)) end

netstream.Hook("ixOpenDetailedDescriptions", function(entity, textEntryData, textEntryDataURL)
	local Frame = vgui.Create("DFrame")
	Frame:SetSize(SScale(150), VScale(250))
	Frame:Center()
	Frame:SetTitle("Detailed Description - " .. entity:Name())
	Frame:MakePopup()

	local List = vgui.Create("DListView", Frame)
	List:Dock( FILL )
	List:DockMargin( 0, 0, 0, SScaleMin(5/2) )
	List:SetMultiSelect(false)

	local textEntry = vgui.Create("DTextEntry", List)
	textEntry:Dock( FILL )
	textEntry:DockMargin( 0, 0, 0, 0 )
	textEntry:SetMultiline(true)
	textEntry:SetVerticalScrollbarEnabled(true)

	textEntry:SetText(textEntryData)

	local DButton = vgui.Create("DButton", List)
	if (textEntryDataURL == "No detailed description found.") then
		DButton:SetDisabled(true)
	else
		DButton:SetTextColor(Color(0, 0, 0, 255))
	end

	DButton:SetText("View Reference Picture")
	DButton:Dock( BOTTOM )
	DButton:DockMargin( 0, 0, 0, 0 )

	DButton.DoClick = function()
		gui.OpenURL(textEntryDataURL)
	end
end)

local detDescData
netstream.Hook('ReturnDetailedDescription', function(data)
	detDescData = data
end)

netstream.Hook("ixSetDetailedDescriptions", function()
	local character = LocalPlayer():GetCharacter()
	netstream.Start('RequestDetailedDescription')
	local Frame = vgui.Create("DFrame")
	Frame:Center()
	Frame:SetPos(Frame:GetPos() - SScale(55), VScale(150), 0)
	Frame:SetSize(SScale(150), VScale(250))
	Frame:SetTitle("Edit Detailed Description")
	Frame:MakePopup()

	local List = vgui.Create("DListView", Frame)
	List:Dock( FILL )
	List:DockMargin( 0, 0, 0, 5 )
	List:SetMultiSelect(false)

	local textEntry = vgui.Create("DTextEntry", List)
	textEntry:Dock( FILL )
	textEntry:DockMargin( 0, 0, 0, 0 )
	textEntry:SetMultiline(true)
	textEntry:SetVerticalScrollbarEnabled(true)
	textEntry:SetText('LOADING....')

	timer.Simple(0.5, function()
		if (character and detDescData) then
			textEntry:SetText(detDescData['text'] or 'ERROR')
		end
	end)

	local DButton = vgui.Create("DButton", List)
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:Dock( BOTTOM )
	DButton:SetText("Edit")
	DButton:SetTextColor(Color(0, 0, 0, 255))
	DButton:SetEnabled(false)
	timer.Simple(0.5, function()
		DButton:SetEnabled(true)
	end)

	local textEntryURL = vgui.Create("DTextEntry", List)
	textEntryURL:Dock( BOTTOM )
	textEntryURL:DockMargin( 0, 0, 0, 0 )
	textEntryURL:SetValue("Reference Image URL")

	Frame.Think = function()
		if (textEntry) and (textEntryURL) then
			if (utf8.len(textEntry:GetValue()) > 3000) or (utf8.len(textEntryURL:GetValue()) > 50) then
				DButton:SetEnabled(false)
			else
				DButton:SetEnabled(true)
			end
		end
	end

	timer.Simple(0.5, function()
		if (character and detDescData) then
			if IsValid(textEntryURL) then
				textEntryURL:SetValue(detDescData['textEntryURL'] or 'ERROR')
				textEntryURL:SetText(detDescData['textEntryURL'] or 'ERROR')
			end
		end
	end)

	DButton.DoClick = function()
		netstream.Start("ixEditDetailedDescriptions", textEntry:GetValue(), textEntryURL:GetValue())
		Frame:Remove()
	end
end)

function PLUGIN:GetPlayerEntityMenu(client, options)
	options["Examine"] = true
end