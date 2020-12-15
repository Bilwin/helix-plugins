local CHAR = ix.meta.character

function CHAR:IsBleeding()
    return self:GetData("bIsBleeding") or false
end

function CHAR:IsFractured()
    return self:GetData("bIsFractured") or false
end