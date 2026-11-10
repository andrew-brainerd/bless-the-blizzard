-- Blizzard spell IDs: 10 in MoP; ranks 1-6 in Forever
local BLIZZARD_SPELL_IDS = {
    [10] = true,
    [6141] = true,
    [8427] = true,
    [10185] = true,
    [10186] = true,
    [10187] = true,
}

local function KnowsBlizzard()
    for spellId in pairs(BLIZZARD_SPELL_IDS) do
        if (IsPlayerSpell(spellId)) then
            return true
        end
    end
    return false
end

local playing = false

local function IsSecret(value)
    return issecretvalue ~= nil and issecretvalue(value)
end

local function IsBlizzard(spellId)
    if (IsSecret(spellId)) then
        spellId = select(8, UnitChannelInfo("player"))
        if (IsSecret(spellId)) then
            return false
        end
    end
    return BLIZZARD_SPELL_IDS[spellId] == true
end

local function Announce()
    if (KnowsBlizzard()) then
        print("YOUR BLIZZARDS ARE BLESSED")
    end
end

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
EventFrame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        Announce()
    elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
        local _, _, spellId = ...;

        if (IsBlizzard(spellId)) then
            PlayMusic("Interface\\AddOns\\BlessTheBlizzard\\africa.mp3")
            playing = true
        end
    elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        if (playing) then
            StopMusic()
            playing = false
        end
    end
end)
