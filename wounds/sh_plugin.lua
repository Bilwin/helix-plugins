PLUGIN.name     = 'Simple Wounds'
PLUGIN.author   = 'Bilwin'

ix.util.Include('sv_hooks.lua')

ix.char.RegisterVar('bleeding', {
    field       = 'bleeding',
    fieldType   = ix.type.bool,
    default     = false,
    isLocal     = true,
    bNoDisplay  = true
})

ix.char.RegisterVar('fractured', {
    field       = 'fractured',
    fieldType   = ix.type.bool,
    default     = false,
    isLocal     = true,
    bNoDisplay  = true
})