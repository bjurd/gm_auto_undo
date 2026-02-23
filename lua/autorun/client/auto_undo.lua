local auto_undo_enabled = CreateClientConVar("auto_undo_enabled", "1", true, true, "Whether or not holding your undo bind will undo faster", 0, 1)
local auto_undo_fire_time = CreateClientConVar("auto_undo_fire_time", "0.75", true, true, "How long undo needs to be pressed before triggering auto-undo (in seconds)", 0.1, 5)
local auto_undo_interval = CreateClientConVar("auto_undo_interval", "0.05", true, true, "Delay between undo repeats (in seconds)", 0.1, 1)

local Active = auto_undo_enabled:GetBool()
local ShouldFire = false

cvars.AddChangeCallback("auto_undo_enabled", function(_, _, New)
	Active = tobool(New)
end)

local FireTimer = 0
local FireIntervalTimer = 0

hook.Add("PlayerButtonDown", "AutoUndo", function(Player, Key) -- PlayerBindPress sucks
	if not IsFirstTimePredicted() then return end
	if Player ~= LocalPlayer() then return end

	local Binding = input.LookupKeyBinding(Key)

	if Binding == "undo" or Binding == "gmod_undo" then
		ShouldFire = true
	end
end)

hook.Add("PlayerButtonUp", "AutoUndo", function(Player, Key)
	if not IsFirstTimePredicted() then return end
	if Player ~= LocalPlayer() then return end

	local Binding = input.LookupKeyBinding(Key)

	if Binding == "undo" or Binding == "gmod_undo" then
		ShouldFire = false
	end
end)

hook.Add("Think", "AutoUndo", function()
	if not Active then return end

	if not ShouldFire then
		FireTimer = 0
		FireIntervalTimer = 0

		return
	end

	local DeltaTime = FrameTime()
	FireTimer = FireTimer + DeltaTime

	if FireTimer < auto_undo_fire_time:GetFloat() then
		FireIntervalTimer = 0

		return
	end

	FireIntervalTimer = FireIntervalTimer + DeltaTime

	if FireIntervalTimer >= auto_undo_interval:GetFloat() then
		RunConsoleCommand("gmod_undo")
		FireIntervalTimer = 0
	end
end)
