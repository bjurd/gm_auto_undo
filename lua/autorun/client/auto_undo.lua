local auto_undo_enabled = CreateClientConVar("auto_undo_enabled", "1", true, true, "Whether or not holding your undo bind will undo faster", 0, 1)
local auto_undo_fire_time = CreateClientConVar("auto_undo_fire_time", "0.75", true, true, "How long undo needs to be pressed before triggering auto-undo (in seconds)", 0.1, 5)
local auto_undo_interval = CreateClientConVar("auto_undo_interval", "0.05", true, true, "Delay between undo repeats (in seconds)", 0.1, 1)

local FireTimer = 0
local FireIntervalTimer = 0

hook.Add("Think", "AutoUndo", function()
	if not auto_undo_enabled:GetBool() then return end

	local UndoBind = input.LookupBinding("undo", true)
	local GMODUndoBind = input.LookupBinding("gmod_undo", true)

	local UndoKey = UndoBind and input.GetKeyCode(UndoBind) or nil
	local GMODUndoKey = GMODUndoBind and input.GetKeyCode(GMODUndoBind) or nil

	local IsDown = (UndoKey and input.IsButtonDown(UndoKey) or false) or (GMODUndoKey and input.IsButtonDown(GMODUndoKey) or false)

	if not IsDown then
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
