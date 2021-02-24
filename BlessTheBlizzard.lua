BlessTheBlizzard = { }

function BlessTheBlizzard:Init()
    hasBlizzardSpell = DoesSpellExist("Blizzard")

    -- name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo("Blizzard")

    if hasBlizzardSpell then
        print("Your Blizzards will be blessed!")
    else
        print("PLAY YOUR MAGE BRUH")
    end

    BlessTheBlizzard:HideGryphons()
end

function BlessTheBlizzard:HideGryphons()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
end

BlessTheBlizzard:Init()
