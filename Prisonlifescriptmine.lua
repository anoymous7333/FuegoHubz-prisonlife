-- Fuegohubz GUI
-- Bring to you by fuegohubz 
-- Enjoy the script!

print("=== Fuegohubz GUI Loading ===")

-- Load WabiSabi UI
loadstring(game:HttpGet("https://scripts.wabisabi.mom/wabi-sabi-ui-lib.lua"))()
local Library = WabiSabi

local Window = Library:CreateWindow({
    Title = "Fuegohubz",
    SubTitle = "Utility + Combat",
    Size = Vector2.new(580, 440),
    ConfigName = "Fuegohubz_Config",
    MinimizeKey = "8",
    Translucent = true,
    AutoStep = true,
})

----------------------------------------------------------
-- Utility Tab
----------------------------------------------------------

local Utility = Window:AddTab({ Title = "Utility", Icon = "settings" })
local u = Utility:AddSection("Teleports")

-- Direct teleports
u:AddButton({ Title = "Teleport to Yard", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(750,97,2451) end })
u:AddButton({ Title = "Teleport to Armory", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(851,99,2235) end })
u:AddButton({ Title = "Teleport to Prison", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(910,97,2450) end })
u:AddButton({ Title = "Teleport to Criminal Base", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-920,95,2138) end })

u:AddLabel("⚠️ Don't teleport too often — it may reset you. If it does, wait 1+ minute.")

----------------------------------------------------------
-- Fly Function
----------------------------------------------------------

local f = Utility:AddSection("Fly")

local flying = false
local speed = 50
local maxspeed = 1000
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}

local function Fly()
    local plr = game.Players.LocalPlayer
    local torso = plr.Character:FindFirstChild("HumanoidRootPart")
    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = torso.CFrame

    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    repeat task.wait()
        plr.Character.Humanoid.PlatformStand = true

        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = speed + .5 + (speed/maxspeed)
            if speed > maxspeed then speed = maxspeed end
        elseif speed ~= 0 then
            speed = speed - 1
            if speed < 0 then speed = 0 else speed = 50 end
        end

        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) +
            ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif speed ~= 0 then
            bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) +
            ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * speed
        else
            bv.velocity = Vector3.new(0,0.1,0)
        end

        bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(
            -math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed), 0, 0
        )
    until not flying

    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    bg:Destroy()
    bv:Destroy()
    plr.Character.Humanoid.PlatformStand = false
    speed = 50
end

-- Toggle Fly
f:AddToggle({
    Id = "flytoggle",
    Title = "Fly (Press E to toggle)",
    Default = false,
    Callback = function(v)
        local plr = game.Players.LocalPlayer
        local mouse = plr:GetMouse()

        if v then
            mouse.KeyDown:Connect(function(key)
                key = key:lower()

                if key == "e" then
                    flying = not flying
                    if flying then Fly() end

                elseif key == "w" then ctrl.f = 1
                elseif key == "s" then ctrl.b = -1
                elseif key == "a" then ctrl.l = -1
                elseif key == "d" then ctrl.r = 1

                end
            end)
        else
            flying = false
        end
    end
})
