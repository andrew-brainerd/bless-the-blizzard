BlessTheBlizzard = {}

function BlessTheBlizzard:Init()
    hasBlizzardSpell = DoesSpellExist("Blizzard")

    if (hasBlizzardSpell) then
        print("YOUR BLIZZARDS ARE BLESSED")
    else
        print("YOU SHOULD BE A FIREBALLIN MAGE BRUH")
    end

    BlessTheBlizzard:HideGryphons()
end

function BlessTheBlizzard:HideGryphons()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
end

local EventFrame = CreateFrame("frame", "EventFrame")

EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        BlessTheBlizzard:Init()
    elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
        local unit, _, spellId = ...;

        if (spellId == 6141) then
            print("I BLESS THE RAINS DOWN IN AFRICAAAAAAA")
            PlaySoundFile("Interface\\AddOns\\BlessTheBlizzard\\africa.mp3")
        end
    end
end)
