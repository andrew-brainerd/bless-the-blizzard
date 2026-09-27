BlessTheBlizzard = {}

-- Ranks were removed in Cataclysm; Blizzard is a single spell ID in MoP
local BLIZZARD_SPELL_ID = 10

function BlessTheBlizzard:Init()
    if (IsPlayerSpell(BLIZZARD_SPELL_ID)) then
        print("YOUR BLIZZARDS ARE BLESSED")
    end
end

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
EventFrame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        BlessTheBlizzard:Init()
    elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
        local _, _, spellId = ...;

        if (spellId == BLIZZARD_SPELL_ID) then
            PlayMusic("Interface\AddOns\BlessTheBlizzard\africa.mp3")
        end
    elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        local _, _, spellId = ...;

        if (spellId == BLIZZARD_SPELL_ID) then
            StopMusic()
        end
    end
end)
