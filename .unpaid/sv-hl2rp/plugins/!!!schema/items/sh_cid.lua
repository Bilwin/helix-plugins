
ITEM.name = "CID"
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.description = "Идентификационная карта гражданина #%s, выдан для %s."

function ITEM:GetDescription()
	return string.format(self.description, self:GetData("id", "00000"), self:GetData("name", "nobody"))
end
