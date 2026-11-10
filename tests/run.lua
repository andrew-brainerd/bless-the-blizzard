-- Drives BlessTheBlizzard.lua against stubbed WoW globals; run from the repo root with lua51
local SECRET = {}
local fails, ran = 0, 0

local function check(name, cond)
    ran = ran + 1
    if not cond then
        fails = fails + 1
        io.write("FAIL " .. name .. "\n")
    end
end

local function boot(opts)
    opts = opts or {}
    local state = { plays = 0, stops = 0, printed = {}, timers = {}, events = {} }
    local frame

    CreateFrame = function()
        frame = {}
        function frame:RegisterEvent(e) state.events[e] = true end
        function frame:RegisterUnitEvent(e) state.events[e] = true end
        function frame:UnregisterEvent(e) state.events[e] = nil end
        function frame:SetScript(_, fn) self.onEvent = fn end
        return frame
    end
    PlayMusic = function(path) state.plays = state.plays + 1; state.path = path end
    StopMusic = function() state.stops = state.stops + 1 end
    IsPlayerSpell = function(id) return id == (opts.known or 10) end
    UnitClass = function() return "Mage", opts.class or "MAGE" end
    UnitChannelInfo = function()
        if state.channel ~= nil then
            return "Blizzard", "", 0, 0, 0, false, false, state.channel
        end
    end
    issecretvalue = opts.noSecretApi and nil or function(v) return v == SECRET end
    print = function(msg) state.printed[#state.printed + 1] = msg end
    C_Timer = { After = function(_, fn) state.timers[#state.timers + 1] = fn end }
    SlashCmdList = {}

    assert(loadfile("BlessTheBlizzard.lua"))("BlessTheBlizzard", {})

    function state.fire(event, ...)
        if state.events[event] then
            frame.onEvent(frame, event, ...)
        end
    end
    function state.start(spellId, channelId)
        state.channel = channelId
        state.fire("UNIT_SPELLCAST_CHANNEL_START", "player", "cast", spellId)
    end
    function state.stop(spellId)
        state.channel = nil
        state.fire("UNIT_SPELLCAST_CHANNEL_STOP", "player", "cast", spellId)
    end
    function state.login()
        state.fire("PLAYER_LOGIN")
        state.fire("PLAYER_ENTERING_WORLD", true, false)
    end
    return state
end

-- Start and stop
local s = boot()
s.login()
s.start(10, 10)
check("Blizzard channel plays the track", s.plays == 1)
check("track path keeps its backslashes", s.path == "Interface\\AddOns\\BlessTheBlizzard\\africa.mp3")
s.stop(10)
check("channel end stops the track", s.stops == 1)
s.stop(10)
check("a second stop does nothing", s.stops == 1)

s = boot()
s.login()
s.start(10185, 10185)
check("Forever rank 4 plays", s.plays == 1)

-- Another spell
s = boot()
s.login()
s.start(5143, 5143)
check("Arcane Missiles doesn't play", s.plays == 0)
s.stop(5143)
check("stopping another channel leaves music alone", s.stops == 0)

s = boot()
s.login()
s.start(10, 10)
s.stop(SECRET)
check("stop with a secret spell ID still stops our track", s.stops == 1)

-- Secret spell ID
s = boot()
s.login()
local ok, err = pcall(s.start, SECRET, 10)
check("secret spell ID doesn't error: " .. tostring(err), ok)
check("secret spell ID falls back to UnitChannelInfo", s.plays == 1)
s.stop(SECRET)
check("fallback-started track stops", s.stops == 1)

s = boot()
s.login()
ok, err = pcall(s.start, SECRET, SECRET)
check("secret spell ID and channel info doesn't error: " .. tostring(err), ok)
check("secret everywhere plays nothing", s.plays == 0)
s.stop(SECRET)
check("secret everywhere stops nothing", s.stops == 0)

s = boot({ noSecretApi = true })
s.login()
ok, err = pcall(s.start, 10, 10)
check("no issecretvalue (MoP) doesn't error: " .. tostring(err), ok)
check("no issecretvalue (MoP) still plays", s.plays == 1)

-- Non-mage
s = boot({ class = "WARRIOR" })
s.login()
check("non-mage registers no channel events", not s.events.UNIT_SPELLCAST_CHANNEL_START and not s.events.UNIT_SPELLCAST_CHANNEL_STOP)
s.start(10, 10)
s.stop(10)
check("non-mage plays and stops nothing", s.plays == 0 and s.stops == 0)
check("non-mage prints nothing", #s.printed == 0)

-- Login message
s = boot()
s.login()
check("login message prints", s.printed[1] == "YOUR BLIZZARDS ARE BLESSED")
s.fire("PLAYER_ENTERING_WORLD", false, false)
check("login message prints once per session", #s.printed == 1)

s = boot({ known = 0 })
s.login()
check("no message without Blizzard", #s.printed == 0)

-- /btb test
s = boot()
s.login()
SlashCmdList.BLESSTHEBLIZZARD("test")
check("/btb test plays", s.plays == 1)
check("/btb test schedules a stop", #s.timers == 1)
s.timers[1]()
check("/btb test stops after the timer", s.stops == 1)

s = boot()
s.login()
SlashCmdList.BLESSTHEBLIZZARD("test")
s.stop(5143)
check("a channel stop during the test stops it", s.stops == 1)
s.start(10, 10)
s.timers[1]()
check("test timer leaves a later Blizzard channel playing", s.stops == 1)
s.stop(10)
check("the Blizzard channel still stops its track", s.stops == 2)

s = boot()
SlashCmdList.BLESSTHEBLIZZARD("")
check("/btb with no argument prints usage", s.plays == 0 and #s.printed == 1)

io.write(string.format("%d checks, %d failed\n", ran, fails))
os.exit(fails == 0 and 0 or 1)
