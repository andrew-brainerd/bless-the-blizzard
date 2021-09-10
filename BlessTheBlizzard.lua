BlessTheBlizzard = {}

function BlessTheBlizzard:Init()
    hasBlizzardSpell = DoesSpellExist("Blizzard")

    if (hasBlizzardSpell) then
        print("YOUR BLIZZARDS ARE BLESSED")
    end
end

local EventFrame = CreateFrame("frame", "EventFrame")

EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
EventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        BlessTheBlizzard:Init()
    elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
        local _, _, spellId = ...;

        if (spellId == 27085) then
            PlayMusic("Interface\\AddOns\\BlessTheBlizzard\\africa.mp3")
        end
    elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        local _, _, spellId = ...;

        if (spellId == 27085) then
            StopMusic()
        end
    end
end)
