BlessTheBlizzard = { }

function BlessTheBlizzard:Init()
    hasBlizzardSpell = DoesSpellExist("Blizzard")

    -- name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo("Blizzard")

    if (hasBlizzardSpell) then
        print("YOUR BLIZZARDS ARE BLESSED")
    else
        print("PLAY YOUR MAGE BRUH")
    end

    BlessTheBlizzard:HideGryphons()
end

function BlessTheBlizzard:HideGryphons()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
end

local EventFrame = CreateFrame("frame", "EventFrame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

EventFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		BlessTheBlizzard:Init()
	end
end)
