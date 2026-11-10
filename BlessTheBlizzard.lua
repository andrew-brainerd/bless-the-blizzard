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

local MUSIC_PATH = "Interface\\AddOns\\BlessTheBlizzard\\africa.mp3"
local TEST_SECONDS = 6

local playing = false
local playId = 0

local function Play()
    PlayMusic(MUSIC_PATH)
    playing = true
    playId = playId + 1
end

local function Stop()
    if (playing) then
        StopMusic()
        playing = false
    end
end

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

EventFrame:RegisterEvent("PLAYER_LOGIN")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_LOGIN") then
        local _, class = UnitClass("player")
        self:UnregisterEvent("PLAYER_LOGIN")
        if (class ~= "MAGE") then
            return
        end
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
        self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
    elseif (event == "PLAYER_ENTERING_WORLD") then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        Announce()
    elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
        local _, _, spellId = ...;

        if (IsBlizzard(spellId)) then
            Play()
        end
    elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        Stop()
    end
end)

SLASH_BLESSTHEBLIZZARD1 = "/btb"
SlashCmdList.BLESSTHEBLIZZARD = function(msg)
    local command = string.lower(msg or ""):match("^%s*(%S*)")
    if (command == "test") then
        Play()
        local id = playId
        print("Bless The Blizzard: playing the track for " .. TEST_SECONDS .. " seconds on the Music channel. Turn up Music volume if you hear nothing.")
        C_Timer.After(TEST_SECONDS, function()
            if (playId == id) then
                Stop()
            end
        end)
    else
        print("Bless The Blizzard: /btb test plays the track briefly so you can check your volume.")
    end
end
