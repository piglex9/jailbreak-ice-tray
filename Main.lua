--alex9#0001

local inst = Instance.new("Hint")
inst.Text = "game might freeze for 30 seconds"

wait(2)
inst:Destroy()

if game.PlaceId ~= 606849621 then return end
local getupvalue = debug.getupvalue or getupvalue or nil
local getupvalues = debug.getupvalues or getupvalues or nil
local setupvalue = debug.setupvalue or setupvalue or nil
local getconstants = debug.getconstants or getconstants or nil
local setconstant = debug.setconstant or setconstant or nil
local getproto = debug.getproto or getproto or nil
local islclosure = islclosure or is_l_closure or nil
local setreadonly = setreadonly or make_writeable or nil
local VERSION = "fork"

local workspace = game:GetService("Workspace")
local repl = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local marketplace = game:GetService("MarketplaceService")
local runss = game:GetService("RunService")
local https = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = players.LocalPlayer
local char = player.Character

local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local anti_kick = getsenv(player.PlayerScripts.LocalScript)
local real_pcall = anti_kick.pcall

anti_kick.pcall = function(f)
    for i,v in next, getupvalues(f) do
        if v == false then
            setupvalue(f,i,true)
        end
        anti_kick.pcall = real_pcall
        break
    end
    return real_pcall(f)
end

local mt = getrawmetatable(game)
local oldnewindex = mt.__newindex
local oldnc = mt.__namecall
setreadonly(mt, false)

local network = getupvalue(require(repl.Module.AlexChassis).SetEvent,1)
local isTeleporting = false
local crashchance = 10

local whitelists = {}
local loop_eject = {}
local toggl = {}
local client = {}
local doors = {}
local sounds = {}
local bruhmodeXD = {}

client.Notify = function(callback)
    return require(game:GetService("ReplicatedStorage").Game.Notification).new(callback)
end

require(repl.Game.ItemSystem.ItemSystem).Fake = function() end
getrenv().nigg = function() return 0/0 end

for i,v in next, require(repl.Resource.Settings).Sounds do
    table.insert(sounds, i)
end

local bread = require(repl.Game.Item.PlasmaPistol).ShootOther
local nigga1 = require(repl.Game.Item.Donut).InputBegan

for i,v in next, getconstants(nigga1) do
    if type(v):match("number") then
        setconstant(nigga1,19,"nigg")
    end
end

for i,v in next, getgc(true) do
    if type(v):match("function") then
        if getfenv(v).script == repl.Module.AlexChassis then
            for i2,v2 in next, getupvalues(v) do
                if type(v2):match("table") and rawget(v2, "OnAction") then
                    client.AutoDrive = v2.OnAction
                end
            end
        end
        if getfenv(v).script == player.PlayerScripts.LocalScript then
            for i2,v2 in next, getupvalues(v) do
                if type(v2):match("table") then
                    if rawget(v2, "IsFlying") then
                        local backup = v2.IsFlying
                        v2.IsFlying = function(...)
                            if toggl.antiragdoll or isTeleporting then
                                return tostring(getfenv(2).script) == "Falling"
                            end
                            return backup(...)
                        end
                    end
                end
            end
            local con = getconstants(v)
            if table.find(con, "Play") and table.find(con, "Source") and table.find(con, "FireServer") then
                client.PlaySounds = v
            end
            if table.find(con, "PlusCash") then
                client.GiveCash = v
            end
            if table.find(con, "OnVehicleExited") then
                client.LeaveVehicle = v
            end
            if table.find(con, "ShouldBreakout") and #con == 3 then
                client.Cops = v
                client.Breakout = getupvalue(getupvalue(client.Cops,3),2)
                client.Pickpocket = getupvalue(getupvalue(client.Cops,2),2)
                client.Arrest = getupvalue(getupvalue(client.Cops,1),7)
            end
            if table.find(con, "SequenceRequireState") then 
                client.OpenDoor = v
            end
            if table.find(con, "Eject") and table.find(con, "MouseButton1Down") then
                client.Eject = getproto(v,1)
            end
        end
        if getfenv(v).script == repl.Game.TeamChooseUI then
            local con = getconstants(v)
            if table.find(con, "delay") and table.find(con, "assert") then
                local proto = getproto(v,6)
                client.changeteam = proto
            end
        end
        if getfenv(v).script == repl.Game.Inventory then
            local con = getconstants(v)
            if table.find(con, "GetLocalVehiclePacket") then
                client.Unequip = v
            end
        end
        if getfenv(v).script == repl.Game.NukeControl then
            local con = getconstants(v)
            if table.find(con, "Nuke") and table.find(con, "Shockwave") then
                client.Nuke = v
            end
        end
    end
    if type(v):match("table") then
        if rawget(v, "MaxHeight") then
            client.MaxHeight = v
        end
        if rawget(v, "GetVehiclePacket") then
            client.gv = v.GetVehiclePacket
        end
        if rawget(v, "Nitro") and rawget(v, "NitroLastMax") then
            client.Nitro = v
        end
        if rawget(v, "Ragdoll") then
            client.rag = v
        end
        if rawget(v, "Part") and type(rawget(v, "Fun")):match("function") then
            if v.Part.Name == "Donut" then
                client.Donut = v.Fun
            elseif v.Part.Name == "JetPackGiver" then
                client.JetpackGiver = v.Fun
            end
        end
        if rawget(v, "Part") and type(rawget(v, "Callback")):match("function") then
            if v.Part.Name == "LiftGate" then
                client.LiftGate = v
            end
            if v.Part.Name == "ExplodeWall" then
                client.ExplodeWall = v
            end
            if v.Part.Name == "SewerHatch" then
                client.SewerHatch = v
            end
        end
        if rawget(v, "OpenFun") and rawget(v, "State") then
            table.insert(doors,v)
        end
        if rawget(v, "ItemData") then
            client.Guns = v.ItemData
        end
    end
end

client.opendoors = (function()
    for i,v in next, getgc() do
        if type(v):match("function") and getfenv(v).script == player.PlayerScripts.LocalScript then
            local con = getconstants(v)
            if table.find(con, "SequenceRequireState") then
                return v
            end
        end
    end
end)()

for i,v in next, getupvalues(require(repl.Game.JetPack.JetPack).Init) do
    if type(v):match("table") and rawget(v, "Equip") then
        client.Jetpack = v
    end
end

local oldr = client.rag.Ragdoll
client.rag.Ragdoll = function(...)
    if toggl.antiragdoll == true then
        return wait(9e9)
    end
    return oldr(...)
end

function checkmus(plr)
    if plr.Position.y < 125 and plr.Position.y > -500 then
        if plr.Position.x < 1150 and plr.Position.x > 900 and plr.Position.z < 1350 and plr.Position.z > 1050 then
            return true
        end
    end
end

function checkbank(plr)
    if plr.Position.y < 19 and plr.Position.y > -750 then
        if plr.Position.x < 250 and plr.Position.x > -150 and plr.Position.z < 1200 and plr.Position.z > 400 then
            return true
        end
    end
    if plr.Position.y < 40 and plr.Position.y > 18 then
        if plr.Position.x < 150 and plr.Position.x > -50 and plr.Position.z < 1000 and plr.Position.z > 600 then
            return true
        end
    end
end

function checkjew(plr)
    if plr.Position.y < 130.37781524658 and plr.Position.y > -500 then
        if plr.Position.x < 179.38104248047 and plr.Position.x > 91.093841552734 and plr.Position.z < 1368.1715087891 and plr.Position.z > 1246.7016601563 then
            return true
        end
    end
end

function checkpowerplant(plr)
    if plr.Position.y < 70 and plr.Position.y > -750 then
        if plr.Position.x < 811 and plr.Position.x > 637 and plr.Position.z < 2407 and plr.Position.z > 2194 then
            return true
        end
    end
end

local vehicles = workspace.Vehicles
local msglock = player.PlayerGui.MainGui.SimpleMessage
local msglockcheck = msglock:GetPropertyChangedSignal("Visible"):connect(function()
    if msglock.Visible then
        getgenv().carlock = true
        msglock.Visible = false
    end
end)

getgenv().usetpmethod2 = false

local function teleport(pos)
    if client.gv() and getgenv().usetpmethod2 == false then
        client.gv().Model:SetPrimaryPartCFrame(pos)
    elseif not client.gv() and getgenv().usetpmethod2 == false then
        isTeleporting = true
        require(repl.Game.ItemSystem.ItemSystem).Unequip()
        repeat wait()
            cars = {}
            getgenv().carlock = false
            getgenv().lookforcar = false
            for i,v in next, vehicles:GetChildren() do
                if v.Name == "Camaro" and v.Seat.Player.Value == false and v:FindFirstChild("Camera") then
                    if v:FindFirstChild("Passenger") then
                        v.Passenger:Destroy()
                    end
                    if checkbank(v.Seat) or checkjew(v.Seat) or checkmus(v.Seat) then
                        wait()
                    else
                        table.insert(cars,v)
                    end
                end
            end
            camaro = cars[math.random(1,#cars)]
            repeat wait()
                player.Character.HumanoidRootPart.CFrame = camaro.Camera.CFrame
                require(repl.Game.Item.Gun).SetLeaning({Config = { Motion = { Hip = { Springs = { ItemOffset = nil, ItemRotation = nil, NeckRotation = nil } } } },SpringItemOffset = {SetTarget = function() end},SpringItemRotation = {SetTarget = function() end},SpringNeckRotation = {SetTarget = function() end},Local = true}, false, false)
                for i,v in next, require(repl.Module.UI).CircleAction.Specs do
                    if v.ValidRoot == camaro and v.IsVehicle == true then
                        v:Callback(true)
                    end
                end
            until client.gv() or getgenv().carlock or getgenv().lookforcar or camaro.Seat.Player.Value == true and camaro.Seat.PlayerName.Value ~= player.Name
        until client.gv()
        client.gv().Model:SetPrimaryPartCFrame(pos + Vector3.new(0,-100,0))
        wait(0.1)
        repeat wait()
            client.LeaveVehicle(client.gv())
        until client.gv() == nil
        wait(0.5)
        for i=1, 3 do
            wait()
            player.Character:SetPrimaryPartCFrame(pos)
        end
        isTeleporting = false
    end
end

local function teleport2(pos)
    if client.gv() and getgenv().usetpmethod2 == true then
        client.gv().Model:SetPrimaryPartCFrame(pos)
    elseif not client.gv() and getgenv().usetpmethod2 == true then
        isTeleporting = true
        require(repl.Game.ItemSystem.ItemSystem).Unequip()
        repeat wait()
            cars = {}
            getgenv().carlock = false
            getgenv().lookforcar = false
            for i,v in next, vehicles:GetChildren() do
                if v.Name == "Camaro" and v.Seat.Player.Value == false and v:FindFirstChild("Camera") then
                    if v:FindFirstChild("Passenger") then
                        v.Passenger:Destroy()
                    end
                    if checkbank(v.Seat) or checkjew(v.Seat) or checkmus(v.Seat) then
                        wait()
                    else
                        table.insert(cars,v)
                    end
                end
            end
            camaro = cars[math.random(1,#cars)]
            repeat wait()
                wait()
                player.Character.HumanoidRootPart.CFrame = camaro.Camera.CFrame
                require(repl.Game.Item.Gun).SetLeaning({Config = { Motion = { Hip = { Springs = { ItemOffset = nil, ItemRotation = nil, NeckRotation = nil } } } },SpringItemOffset = {SetTarget = function() end},SpringItemRotation = {SetTarget = function() end},SpringNeckRotation = {SetTarget = function() end},Local = true}, false, false)
                for i,v in next, require(repl.Module.UI).CircleAction.Specs do
                    if v.ValidRoot == camaro and v.IsVehicle == true then
                        v:Callback(true)
                    end
                end
            until client.gv() or getgenv().carlock or getgenv().lookforcar or camaro.Seat.Player.Value == true and camaro.Seat.PlayerName.Value ~= player.Name
        until client.gv()
        client.gv().Model:SetPrimaryPartCFrame(pos)
        isTeleporting = false
    end
end

local function teleportarrest(pos)
    if client.gv() then
        require(repl.Game.ItemSystem.ItemSystem).Unequip()
        client.gv().Model:SetPrimaryPartCFrame(pos)
        equip("Handcuffs")
    else
        isTeleporting = true
        require(repl.Game.ItemSystem.ItemSystem).Unequip()
        repeat wait()
            cars = {}
            getgenv().carlock = false
            getgenv().lookforcar = false
            for i,v in next, vehicles:GetChildren() do
                if v.Name == "Camaro" and v.Seat.Player.Value == false and v:FindFirstChild("Camera") then
                    if v:FindFirstChild("Passenger") then
                        v.Passenger:Destroy()
                    end
                    if checkbank(v.Seat) or checkjew(v.Seat) or checkmus(v.Seat) then
                        wait()
                    else
                        table.insert(cars,v)
                    end
                end
            end
            camaro = cars[math.random(1,#cars)]
            repeat wait()
                player.Character.HumanoidRootPart.CFrame = camaro.Camera.CFrame
                for i,v in next, require(repl.Module.UI).CircleAction.Specs do
                    if v.ValidRoot == camaro and v.IsVehicle == true then
                        v:Callback(true) 
                    end
                end
                wait()
            until client.gv() or getgenv().carlock or getgenv().lookforcar or camaro.Seat.Player.Value == true and camaro.Seat.PlayerName.Value ~= player.Name
        until client.gv()
        equip("Handcuffs")
        client.gv().Model:SetPrimaryPartCFrame(pos)
        isTeleporting = false
    end
end

local function get_key()
    if tostring(player.Team) == "Police" then return end
    for i,v in next, players:GetPlayers() do
        local oldpos = player.Character.HumanoidRootPart.CFrame
        if tostring(v.Team) == "Police" then
            for i=0, 20 do
                wait()
                player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                client.Pickpocket(v)
            end
            player.Character.HumanoidRootPart.CFrame = oldpos
            break
        end
    end
end

local function equip(name)
    local alex9
    for i,v in next, getgc(true) do
        if type(v):match("table") and rawget(v, "i") and rawget(v, "Frame") and rawget(v, "Name") then
            if v.Name == name then
                alex9 = v
            end
        end
    end
    require(repl.Game.ItemSystem.ItemSystem).Equip(player, alex9)
    return
end

_G.WalkSpeed = 16
_G.JumpPower = 50

mt.__newindex = newcclosure(function(x,y,z)
    if y == "WalkSpeed" then
        if _G.WalkSpeed == 16 then
            return oldnewindex(x,y,z)
        end
        z = _G.WalkSpeed
    end
    return oldnewindex(x,y,z)
end)

local function jumppower(callback)
    _G.JumpPower = callback
    player.Character.Humanoid.JumpPower = tonumber(callback)
end

player.CharacterAdded:connect(function(character)
    character:WaitForChild("Humanoid").WalkSpeed = _G.WalkSpeed
    character:WaitForChild("Humanoid").JumpPower = _G.JumpPower
    if isTeleporting == true then
        isTeleporting = false
    end
end)

player.Character.ChildAdded:connect(function(object)
    if object.Name == "InVehicle" then
        client.gv().Height = _G.CarHeight
        client.gv().TurnSpeed = _G.CarTurnSpeed
        client.gv().GarageEngineSpeed = _G.CarSpeed
        client.gv().GarageBrakes = _G.CarBrakes
    end
end)

--trash fly
local speed_fly2 = 50
local function playerfly()
    function fly(child, arg)
        local folder = Instance.new("Folder")
        folder.Name = "saveGyro"
        local saveGyro = folder
        for i,v in next, child:GetChildren() do
            if v:IsA("BodyGyro") then
                v.Parent = saveGyro
            end
        end
        local bodypos = Instance.new("BodyPosition", child)
        bodypos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodypos.Name = "positioner"
        local bodygyr = Instance.new("BodyGyro", child)
        bodygyr.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodygyr.Name = "rotation"
        local subjcam = camera.CameraSubject
        camera.CameraSubject = child
        local speed = 0
        local keybinds = mouse.KeyDown:connect(function(key)
            if key == "w" then
                if arg then
                    speed = speed_fly2
                else
                    speed = tonumber("-"..tostring(speed_fly2))
                end
            elseif key == "s" then
                if arg then
                    speed = tonumber("-"..tostring(speed_fly2))
                else
                    speed = speed_fly2
                end
            end
        end)
        mouse.KeyUp:connect(function(key)
            if key == "w" then
                speed = 0
            elseif key == "s" then
                speed = 0
            end
        end)
        local arg2 = {}
        arg2.isRun = true
        arg2.Part = child
        arg2.Bind = keybinds
        spawn(function()
            repeat
                local cframe = camera.CFrame
                local pos = child.Position
                local posMag = (pos-cframe.p).Magnitude
                bodypos.Position = (cframe*CFrame.new(0,0,tonumber("-"..tostring(posMag)) + speed)).p + Vector3.new(0,0.2225,0)
                bodygyr.CFrame = cframe
                wait()
            until arg2.isRun==false or toggl.playerfly == false or client.gv()
            if client.gv() then
                toggl.playerfly = false
            end
            bodypos:Remove()
            bodygyr:Remove()
            camera.CameraSubject = subjcam
            for i,v in next, saveGyro:GetChildren() do
                v.Parent = arg2.Part
            end
            arg2.Bind:Disconnect()
        end)
        return arg2
    end
    function carfly(child, arg)
        local folder = Instance.new("Folder")
        folder.Name = "saveGyro"
        local saveGyro = folder
        for i,v in next, child:GetChildren() do
            if v:IsA("BodyGyro") then
                v.Parent = saveGyro
            end
        end
        local bodypos = Instance.new("BodyPosition", child)
        bodypos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodypos.Name = "positioner"
        local bodygyr = Instance.new("BodyGyro", child)
        bodygyr.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodygyr.Name = "rotation"
        local subjcam = camera.CameraSubject
        camera.CameraSubject = child
        local speed = 0
        local keybinds = mouse.KeyDown:connect(function(key)
            if key == "w" then
                if arg then
                    speed = speed_fly2
                else
                    speed = tonumber("-"..tostring(speed_fly2))
                end
            elseif key == "s" then
                if arg then
                    speed = tonumber("-"..tostring(speed_fly2))
                else
                    speed = speed_fly2
                end
            end
        end)
        mouse.KeyUp:connect(function(key)
            if key == "w" then
                speed = 0
            elseif key == "s" then
                speed = 0
            end
        end)
        local arg2 = {}
        arg2.isRun = true
        arg2.Part = child
        arg2.Bind = keybinds
        spawn(function()
            repeat
                local cframe = camera.CFrame
                local pos = child.Position
                local posMag = (pos-cframe.p).Magnitude
                bodypos.Position = (cframe*CFrame.new(0,0,tonumber("-"..tostring(posMag)) + speed)).p + Vector3.new(0,0.2225,0)
                bodygyr.CFrame = cframe
                wait()
            until arg2.isRun==false or camera.CameraSubject~=child or toggl.playerfly == false or not client.gv()
            if not client.gv() and toggl.playerfly == true then
                camera.CameraSubject = subjcam
                fly(player.Character.HumanoidRootPart)
            end
            bodypos:Remove()
            bodygyr:Remove()
            camera.CameraSubject = subjcam
            for i,v in next, saveGyro:GetChildren() do
                v.Parent = arg2.Part
            end
            arg2.Bind:Disconnect()
        end)
        return arg2
    end
    local vehicle = workspace.Vehicles
    function getVehicle()
        for i,v in next, vehicle:GetChildren() do
            if v:FindFirstChild("Seat") and v.Seat:FindFirstChild("PlayerName") and v:FindFirstChild("Engine") then
                if v.Seat.PlayerName.Value == player.Name then
                    return v.Engine, false
                end
            elseif v:FindFirstChild("Seat") and v.Seat:FindFirstChild("PlayerName") and v:FindFirstChild("Model") then
                if v.Seat.PlayerName.Value == player.Name then
                    if v.Model:FindFirstChild("Body") then
                        return v.Model.Body, true
                    end
                end
            end
        end
    end
    if getVehicle() == nil then
        fly(player.Character.HumanoidRootPart)
    elseif getVehicle() ~= nil then
        local veh, veh2 = getVehicle()
        local flyingveh = carfly(veh,veh2)
        if veh2 then
            repeat wait() until veh.Parent.Parent.Seat.PlayerName.Value ~= player.Name
        else
            repeat wait() until veh.Parent.Seat.PlayerName.Value ~= player.Name
        end
        wait(0.1)
        camera.CameraSubject = player
    end
end

local locations = {
    Stores = {
        ['Jewelry Out'] = CFrame.new(156.103851, 18.540699, 1353.72388),
        ['Jewelry In'] = CFrame.new(133.300705, 17.9375954, 1316.42407),
        ['Bank Out'] = CFrame.new(11.6854906, 17.8929214, 788.188171),
        ['Bank In'] = CFrame.new(24.6513691, 19.4347649, 853.291687),
        ['Museum Out'] = CFrame.new(1103.53406, 138.152878, 1246.98511),
        ['Museum In'] = CFrame.new(1071.72, 102.8, 1191.9),
        ['Donut Shop'] = CFrame.new(270.763885, 18.4229183, -1762.90149),
        ['Gas Station'] = CFrame.new(-1584.1051, 18.4732189, 721.38739),
        ['Power Plant'] = CFrame.new(691.559326, 37.6575089, 2362.05591),
    },
    Locations = {
        ['Prison Cells'] = CFrame.new(-1461.07605, -0.318537951, -1824.14917),
        ['Prison Yard'] = CFrame.new(-1219.36316, 17.7750931, -1760.8584),
        ['Prison Sewer'] = CFrame.new(-1050.70667, 0.7002424, -1498.72766),
        ['Prison Parking'] = CFrame.new(-1173.36951, 18.698061, -1533.47656),
        ['Gun Shop'] = CFrame.new(-27.8670673, 17.7929249, -1774.66882),
        ['1M Shop'] = CFrame.new(688,19,-1523),
        ['Volcano Base'] = CFrame.new(1726.72266, 50.4146309, -1745.76196),
        ['City Base'] = CFrame.new(-244.824478, 17.8677788, 1573.81616),
        ['Police HQ1'] = CFrame.new(-1134.69604, 17.9251575, -1586.79395),
        ['Police HQ2'] = CFrame.new(738.103577, 38.1275024, 1134.48059),
        ['Military Base'] = CFrame.new(766.283386, 18.0144463, -324.15921),
        ['Evil Lair'] = CFrame.new(1735.52405, 18.1646328, -1726.05249),
        ['Secret Agent Base'] = CFrame.new(1506.60754, 69.8824005, 1634.42456),
        ['Garage'] = CFrame.new(-336.791779, 18.2407684, 1137.49451),
        ['Glider Shop'] = CFrame.new(137.43399, 18.1547852, -1768.24658),
        ['Lookout'] = CFrame.new(1328.05725, 166.614426, 2609.93457),
        ['Airport'] = CFrame.new(-1227.47449, 64.4552231, 2787.64233),
        ['Boat Cave'] = CFrame.new(1870.72498, 31.4386101, 1896.98865),
        ['Port'] = CFrame.new(-423.029663, 21.2136765, 2023.55713),
        ['Volcano Inside'] = CFrame.new(1704.46484, 25.0370979, -1775.46484),
    },
    Vehicles = {
        ['Prison Camaro'] = CFrame.new(-951.755493, 18.5451126, -1446.42664),
        ['Lamborghini'] = CFrame.new(146.728821, 17.5929279, 774.655396),
        ['Chiron'] = CFrame.new(241.109451, 17.6066723, 1362.49316),
        ['Surus'] = CFrame.new(-1283,18,-1576),
        ['Pickup Truck'] = CFrame.new(-1543.02686, 18.3732185, 721.518494),
        ['Model3'] = CFrame.new(-117.721481, 17.5907402, 547.516052),
        ['Roadster'] = CFrame.new(-122.155197, 18.2636452, 520.741638),
        ['Deja'] = CFrame.new(1032,18,-1076),
        ['Dirtbike'] = CFrame.new(1317,18,-536),
        ['Dune Buggy'] = CFrame.new(580.013916, 17.1554928, -458.795807),
        ['ATV'] = CFrame.new(-1452.651, 24.8182373, 202.176361),
        ['Mustang'] = CFrame.new(-646,37,2316),
        ['Porsche'] = CFrame.new(1111.16809, 101.783577, 1296.94312),
        ['Ambulance'] = CFrame.new(-179.030914, 18.2636738, 1158.46533),
        ['UFO'] = CFrame.new(775.515747, 18.3745003, -142.552948),
        ['SWAT Van'] = CFrame.new(-1356.85388, 17.9232101, -1534.93152),
        ['Wraith'] = CFrame.new(1687.08911, 50.4146309, -1704.4657),
        ['Ferrari'] = CFrame.new(1694.97766, 18.2658329, 276.87796),
        ['Classic'] = CFrame.new(1194.28406, 106.283951, 1176.69458),
        ['Police Motorcycle'] = CFrame.new(-1311,18,-1562),
        ['Firetruck'] = CFrame.new(-967.847168, 33.1665268, 1320.79968),
        ['Jet Skis'] = CFrame.new(-379.247833, 19.2636337, 728.789917),
        ['Cruiser'] = CFrame.new(-280,19,2071),
        ['Little Bird'] = CFrame.new(38.4758072, 216.43457, 847.337891),
        ['Stunt'] = CFrame.new(-1349.34143, 41.5697594, 2803.24512),
        ['Jet Plane'] = CFrame.new(-1577.87366, 41.5697594, 2835.16333)
    },
}

getgenv().loadUI = true
if getgenv().loadUI == true then
    local library, ui_options, togglers = loadstring([[local b={main_color=Color3.fromRGB(155, 100, 142),window_color=Color3.new(0.0823529,0.0862745,0.0901961),min_size=Vector2.new(480,580),default_size=Vector2.new(480,580),toggle_key=Enum.KeyCode.RightShift,can_resize=true}local c={}do local b=game:GetService("CoreGui"):FindFirstChild("icetray3403493693")if b then b:Destroy()end end local d=Instance.new("ScreenGui")local e=Instance.new("Frame")local f=Instance.new("TextLabel")local g=Instance.new("ImageLabel")local h=Instance.new("Frame")local i=Instance.new("Frame")local j=Instance.new("ImageButton")local k=Instance.new("ImageLabel")local l=Instance.new("ImageLabel")local m=Instance.new("Frame")local n=Instance.new("TextLabel")local o=Instance.new("ImageLabel")local p=Instance.new("Frame")local q=Instance.new("UIListLayout")local r=Instance.new("Frame")local s=Instance.new("Frame")local t=Instance.new("UIListLayout")local u=Instance.new("TextBox")local v=Instance.new("ImageLabel")local w=Instance.new("ImageLabel")local x=Instance.new("TextLabel")local y=Instance.new("ImageLabel")local z=Instance.new("TextLabel")local A=Instance.new("TextLabel")local B=Instance.new("TextLabel")local C=Instance.new("ImageLabel")local D=Instance.new("UIListLayout")local E=Instance.new("TextButton")local F=Instance.new("ImageLabel")local G=Instance.new("ImageButton")local H=Instance.new("ScrollingFrame")local I=Instance.new("UIListLayout")local J=Instance.new("ImageLabel")local K=Instance.new("TextButton")local L=Instance.new("ImageLabel")local M=Instance.new("ImageLabel")local N=Instance.new("TextButton")local O=Instance.new("ImageLabel")local P=Instance.new("ImageLabel")local Q=Instance.new("Frame")local R=Instance.new("UIListLayout")local S=Instance.new("TextLabel")local S=Instance.new("ImageLabel")local T=Instance.new("ImageLabel")local U=Instance.new("ImageLabel")local V=Instance.new("ImageLabel")local W=Instance.new("ImageLabel")local X=Instance.new("Frame")local Y=Instance.new("TextButton")local Z=Instance.new("ImageLabel")local undefined=Instance.new("TextLabel")local bc=Instance.new("TextButton")local cc=Instance.new("ImageLabel")local dc=Instance.new("TextButton")local ec=Instance.new("ImageLabel")local fc=Instance.new("TextLabel")local gc=Instance.new("TextButton")local hc=Instance.new("ImageLabel")local ic=Instance.new("Frame")d.Name="icetray3403493693"d.Parent=game:GetService("CoreGui")d.Enabled=false e.Name="Prefabs"e.Parent=d e.BackgroundColor3=Color3.new(1,1,1)e.Size=UDim2.new(0,100,0,100)e.Visible=false f.Name="Label"f.Parent=e f.BackgroundColor3=Color3.new(1,1,1)f.BackgroundTransparency=1 f.Size=UDim2.new(0,200,0,20)f.Font=Enum.Font.GothamSemibold f.Text="Hello, world 123"f.TextColor3=Color3.new(1,1,1)f.TextSize=14 f.TextXAlignment=Enum.TextXAlignment.Left g.Name="Window"g.Parent=e g.Active=true g.BackgroundColor3=Color3.new(1,1,1)g.BackgroundTransparency=1 g.ClipsDescendants=true g.Position=UDim2.new(0,20,0,20)g.Selectable=true g.Size=UDim2.new(0,200,0,200)g.Image="rbxassetid://2851926732"g.ImageColor3=Color3.new(0.0823529,0.0862745,0.0901961)g.ScaleType=Enum.ScaleType.Slice g.SliceCenter=Rect.new(12,12,12,12)h.Name="Resizer"h.Parent=g h.Active=true h.BackgroundColor3=Color3.new(1,1,1)h.BackgroundTransparency=1 h.BorderSizePixel=0 h.Position=UDim2.new(1,-20,1,-20)h.Size=UDim2.new(0,20,0,20)i.Name="Bar"i.Parent=g i.BackgroundColor3=Color3.new(0.160784,0.290196,0.478431)i.BorderSizePixel=0 i.Position=UDim2.new(0,0,0,5)i.Size=UDim2.new(1,0,0,15)j.Name="Toggle"j.Parent=i j.BackgroundColor3=Color3.new(1,1,1)j.BackgroundTransparency=1 j.Position=UDim2.new(0,5,0,-2)j.Rotation=90 j.Size=UDim2.new(0,20,0,20)j.ZIndex=2 j.Image="https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4731371541"k.Name="Base"k.Parent=i k.BackgroundColor3=Color3.new(0.160784,0.290196,0.478431)k.BorderSizePixel=0 k.Position=UDim2.new(0,0,0.800000012,0)k.Size=UDim2.new(1,0,0,10)k.Image="rbxassetid://2851926732"k.ImageColor3=Color3.new(0.160784,0.290196,0.478431)k.ScaleType=Enum.ScaleType.Slice k.SliceCenter=Rect.new(12,12,12,12)l.Name="Top"l.Parent=i l.BackgroundColor3=Color3.new(1,1,1)l.BackgroundTransparency=1 l.Position=UDim2.new(0,0,0,-5)l.Size=UDim2.new(1,0,0,10)l.Image="rbxassetid://2851926732"l.ImageColor3=Color3.new(0.160784,0.290196,0.478431)l.ScaleType=Enum.ScaleType.Slice l.SliceCenter=Rect.new(12,12,12,12)m.Name="Tabs"m.Parent=g m.BackgroundColor3=Color3.new(1,1,1)m.BackgroundTransparency=1 m.Position=UDim2.new(0,15,0,60)m.Size=UDim2.new(1,-30,1,-60)n.Name="Title"n.Parent=g n.BackgroundColor3=Color3.new(1,1,1)n.BackgroundTransparency=1 n.Position=UDim2.new(0,30,0,3)n.Size=UDim2.new(0,200,0,20)n.Font=Enum.Font.GothamBold n.Text="Gamer Time"n.TextColor3=Color3.new(1,1,1)n.TextSize=14 n.TextXAlignment=Enum.TextXAlignment.Left o.Name="TabSelection"o.Parent=g o.BackgroundColor3=Color3.new(1,1,1)o.BackgroundTransparency=1 o.Position=UDim2.new(0,15,0,30)o.Size=UDim2.new(1,-30,0,25)o.Visible=false o.Image="rbxassetid://2851929490"o.ImageColor3=Color3.new(0.145098,0.14902,0.156863)o.ScaleType=Enum.ScaleType.Slice o.SliceCenter=Rect.new(4,4,4,4)p.Name="TabButtons"p.Parent=o p.BackgroundColor3=Color3.new(1,1,1)p.BackgroundTransparency=1 p.Size=UDim2.new(1,0,1,0)q.Parent=p q.FillDirection=Enum.FillDirection.Horizontal q.SortOrder=Enum.SortOrder.LayoutOrder q.Padding=UDim.new(0,2)r.Parent=o r.BackgroundColor3=Color3.new(0.12549,0.227451,0.372549)r.BorderColor3=Color3.new(0.105882,0.164706,0.207843)r.BorderSizePixel=0 r.Position=UDim2.new(0,0,1,0)r.Size=UDim2.new(1,0,0,2)s.Name="Tab"s.Parent=e s.BackgroundColor3=Color3.new(1,1,1)s.BackgroundTransparency=1 s.Size=UDim2.new(1,0,1,0)s.Visible=false t.Parent=s t.SortOrder=Enum.SortOrder.LayoutOrder t.Padding=UDim.new(0,5)u.Parent=e u.BackgroundColor3=Color3.new(1,1,1)u.BackgroundTransparency=1 u.BorderSizePixel=0 u.Size=UDim2.new(1,0,0,20)u.ZIndex=2 u.Font=Enum.Font.GothamSemibold u.PlaceholderColor3=Color3.new(0.698039,0.698039,0.698039)u.PlaceholderText="Input Text"u.Text=""u.TextColor3=Color3.new(0.784314,0.784314,0.784314)u.TextSize=14 v.Name="TextBox_Roundify_4px"v.Parent=u v.BackgroundColor3=Color3.new(1,1,1)v.BackgroundTransparency=1 v.Size=UDim2.new(1,0,1,0)v.Image="rbxassetid://2851929490"v.ImageColor3=Color3.new(0.203922,0.207843,0.219608)v.ScaleType=Enum.ScaleType.Slice v.SliceCenter=Rect.new(4,4,4,4)w.Name="Slider"w.Parent=e w.BackgroundColor3=Color3.new(1,1,1)w.BackgroundTransparency=1 w.Position=UDim2.new(0,0,0.178571433,0)w.Size=UDim2.new(1,0,0,20)w.Image="rbxassetid://2851929490"w.ImageColor3=Color3.new(0.145098,0.14902,0.156863)w.ScaleType=Enum.ScaleType.Slice w.SliceCenter=Rect.new(4,4,4,4)x.Name="Title"x.Parent=w x.BackgroundColor3=Color3.new(1,1,1)x.BackgroundTransparency=1 x.Position=UDim2.new(0.5,0,0.5,-10)x.Size=UDim2.new(0,0,0,20)x.ZIndex=2 x.Font=Enum.Font.GothamBold x.Text="Slider"x.TextColor3=Color3.new(0.784314,0.784314,0.784314)x.TextSize=14 y.Name="Indicator"y.Parent=w y.BackgroundColor3=Color3.new(1,1,1)y.BackgroundTransparency=1 y.Size=UDim2.new(0,0,0,20)y.Image="rbxassetid://2851929490"y.ImageColor3=Color3.new(0.254902,0.262745,0.278431)y.ScaleType=Enum.ScaleType.Slice y.SliceCenter=Rect.new(4,4,4,4)z.Name="Value"z.Parent=w z.BackgroundColor3=Color3.new(1,1,1)z.BackgroundTransparency=1 z.Position=UDim2.new(1,-55,0.5,-10)z.Size=UDim2.new(0,50,0,20)z.Font=Enum.Font.GothamBold z.Text="0%"z.TextColor3=Color3.new(0.784314,0.784314,0.784314)z.TextSize=14 A.Parent=w A.BackgroundColor3=Color3.new(1,1,1)A.BackgroundTransparency=1 A.Position=UDim2.new(1,-20,-0.75,0)A.Size=UDim2.new(0,26,0,50)A.Font=Enum.Font.GothamBold A.Text="]"A.TextColor3=Color3.new(0.627451,0.627451,0.627451)A.TextSize=14 B.Parent=w B.BackgroundColor3=Color3.new(1,1,1)B.BackgroundTransparency=1 B.Position=UDim2.new(1,-65,-0.75,0)B.Size=UDim2.new(0,26,0,50)B.Font=Enum.Font.GothamBold B.Text="["B.TextColor3=Color3.new(0.627451,0.627451,0.627451)B.TextSize=14 C.Name="Circle"C.Parent=e C.BackgroundColor3=Color3.new(1,1,1)C.BackgroundTransparency=1 C.Image="rbxassetid://266543268"C.ImageTransparency=0.5 D.Parent=e D.FillDirection=Enum.FillDirection.Horizontal D.SortOrder=Enum.SortOrder.LayoutOrder D.Padding=UDim.new(0,20)E.Name="Dropdown"E.Parent=e E.BackgroundColor3=Color3.new(1,1,1)E.BackgroundTransparency=1 E.BorderSizePixel=0 E.Position=UDim2.new(-0.055555556,0,0.0833333284,0)E.Size=UDim2.new(0,200,0,20)E.ZIndex=2 E.Font=Enum.Font.GothamBold E.Text="      Dropdown"E.TextColor3=Color3.new(0.784314,0.784314,0.784314)E.TextSize=14 E.TextXAlignment=Enum.TextXAlignment.Left F.Name="Indicator"F.Parent=E F.BackgroundColor3=Color3.new(1,1,1)F.BackgroundTransparency=1 F.Position=UDim2.new(0.899999976,-10,0.100000001,0)F.Rotation=-90 F.Size=UDim2.new(0,15,0,15)F.ZIndex=2 F.Image="https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4744658743"G.Name="Box"G.Parent=E G.BackgroundColor3=Color3.new(1,1,1)G.BackgroundTransparency=1 G.Position=UDim2.new(0,0,0,25)G.Size=UDim2.new(1,0,0,150)G.ZIndex=3 G.Image="rbxassetid://2851929490"G.ImageColor3=Color3.new(0.129412,0.133333,0.141176)G.ScaleType=Enum.ScaleType.Slice G.SliceCenter=Rect.new(4,4,4,4)H.Name="Objects"H.Parent=G H.BackgroundColor3=Color3.new(1,1,1)H.BackgroundTransparency=1 H.BorderSizePixel=0 H.Size=UDim2.new(1,0,1,0)H.ZIndex=3 H.CanvasSize=UDim2.new(0,0,0,0)H.ScrollBarThickness=8 I.Parent=H I.SortOrder=Enum.SortOrder.LayoutOrder J.Name="TextButton_Roundify_4px"J.Parent=E J.BackgroundColor3=Color3.new(1,1,1)J.BackgroundTransparency=1 J.Size=UDim2.new(1,0,1,0)J.Image="rbxassetid://2851929490"J.ImageColor3=Color3.new(0.203922,0.207843,0.219608)J.ScaleType=Enum.ScaleType.Slice J.SliceCenter=Rect.new(4,4,4,4)K.Name="TabButton"K.Parent=e K.BackgroundColor3=Color3.new(0.160784,0.290196,0.478431)K.BackgroundTransparency=1 K.BorderSizePixel=0 K.Position=UDim2.new(0.185185179,0,0,0)K.Size=UDim2.new(0,71,0,20)K.ZIndex=2 K.Font=Enum.Font.GothamSemibold K.Text="Test tab"K.TextColor3=Color3.new(0.784314,0.784314,0.784314)K.TextSize=14 L.Name="TextButton_Roundify_4px"L.Parent=K L.BackgroundColor3=Color3.new(1,1,1)L.BackgroundTransparency=1 L.Size=UDim2.new(1,0,1,0)L.Image="rbxassetid://2851929490"L.ImageColor3=Color3.new(0.203922,0.207843,0.219608)L.ScaleType=Enum.ScaleType.Slice L.SliceCenter=Rect.new(4,4,4,4)M.Name="Folder"M.Parent=e M.BackgroundColor3=Color3.new(1,1,1)M.BackgroundTransparency=1 M.Position=UDim2.new(0,0,0,50)M.Size=UDim2.new(1,0,0,20)M.Image="rbxassetid://2851929490"M.ImageColor3=Color3.new(0.0823529,0.0862745,0.0901961)M.ScaleType=Enum.ScaleType.Slice M.SliceCenter=Rect.new(4,4,4,4)N.Name="Button"N.Parent=M N.BackgroundColor3=Color3.new(0.160784,0.290196,0.478431)N.BackgroundTransparency=1 N.BorderSizePixel=0 N.Size=UDim2.new(1,0,0,20)N.ZIndex=2 N.Font=Enum.Font.GothamSemibold N.Text="      Folder"N.TextColor3=Color3.new(1,1,1)N.TextSize=14 N.TextXAlignment=Enum.TextXAlignment.Left O.Name="TextButton_Roundify_4px"O.Parent=N O.BackgroundColor3=Color3.new(1,1,1)O.BackgroundTransparency=1 O.Size=UDim2.new(1,0,1,0)O.Image="rbxassetid://2851929490"O.ImageColor3=Color3.new(0.160784,0.290196,0.478431)O.ScaleType=Enum.ScaleType.Slice O.SliceCenter=Rect.new(4,4,4,4)P.Name="Toggle"P.Parent=N P.BackgroundColor3=Color3.new(1,1,1)P.BackgroundTransparency=1 P.Position=UDim2.new(0,5,0,0)P.Size=UDim2.new(0,20,0,20)P.Image="https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4731371541"Q.Name="Objects"Q.Parent=M Q.BackgroundColor3=Color3.new(1,1,1)Q.BackgroundTransparency=1 Q.Position=UDim2.new(0,10,0,25)Q.Size=UDim2.new(1,-10,1,-25)Q.Visible=false R.Parent=Q R.SortOrder=Enum.SortOrder.LayoutOrder R.Padding=UDim.new(0,5)S.Name="ColorPicker"S.Parent=e S.BackgroundColor3=Color3.new(1,1,1)S.BackgroundTransparency=1 S.Size=UDim2.new(0,180,0,110)S.Image="rbxassetid://2851929490"S.ImageColor3=Color3.new(0.203922,0.207843,0.219608)S.ScaleType=Enum.ScaleType.Slice S.SliceCenter=Rect.new(4,4,4,4)T.Name="Palette"T.Parent=S T.BackgroundColor3=Color3.new(1,1,1)T.BackgroundTransparency=1 T.Position=UDim2.new(0.0500000007,0,0.0500000007,0)T.Size=UDim2.new(0,100,0,100)T.Image="rbxassetid://698052001"T.ScaleType=Enum.ScaleType.Slice T.SliceCenter=Rect.new(4,4,4,4)U.Name="Indicator"U.Parent=T U.BackgroundColor3=Color3.new(1,1,1)U.BackgroundTransparency=1 U.Size=UDim2.new(0,5,0,5)U.ZIndex=2 U.Image="rbxassetid://2851926732"U.ImageColor3=Color3.new(0,0,0)U.ScaleType=Enum.ScaleType.Slice U.SliceCenter=Rect.new(12,12,12,12)V.Name="Sample"V.Parent=S V.BackgroundColor3=Color3.new(1,1,1)V.BackgroundTransparency=1 V.Position=UDim2.new(0.800000012,0,0.0500000007,0)V.Size=UDim2.new(0,25,0,25)V.Image="rbxassetid://2851929490"V.ScaleType=Enum.ScaleType.Slice V.SliceCenter=Rect.new(4,4,4,4)W.Name="Saturation"W.Parent=S W.BackgroundColor3=Color3.new(1,1,1)W.Position=UDim2.new(0.649999976,0,0.0500000007,0)W.Size=UDim2.new(0,15,0,100)W.Image="rbxassetid://3641079629"X.Name="Indicator"X.Parent=W X.BackgroundColor3=Color3.new(1,1,1)X.BorderSizePixel=0 X.Size=UDim2.new(0,20,0,2)X.ZIndex=2 Y.Name="Switch"Y.Parent=e Y.BackgroundColor3=Color3.new(1,1,1)Y.BackgroundTransparency=1 Y.BorderSizePixel=0 Y.Position=UDim2.new(0.229411766,0,0.20714286,0)Y.Size=UDim2.new(0,20,0,20)Y.ZIndex=2 Y.Font=Enum.Font.SourceSans Y.Text=""Y.TextColor3=Color3.new(1,1,1)Y.TextSize=18 Z.Name="TextButton_Roundify_4px"Z.Parent=Y Z.BackgroundColor3=Color3.new(1,1,1)Z.BackgroundTransparency=1 Z.Size=UDim2.new(1,0,1,0)Z.Image="rbxassetid://2851929490"Z.ImageColor3=Color3.new(0.160784,0.290196,0.478431)Z.ImageTransparency=0.5 Z.ScaleType=Enum.ScaleType.Slice Z.SliceCenter=Rect.new(4,4,4,4)undefined.Name="Title"undefined.Parent=Y undefined.BackgroundColor3=Color3.new(1,1,1)undefined.BackgroundTransparency=1 undefined.Position=UDim2.new(1.20000005,0,0,0)undefined.Size=UDim2.new(0,20,0,20)undefined.Font=Enum.Font.GothamSemibold undefined.Text="Switch"undefined.TextColor3=Color3.new(0.784314,0.784314,0.784314)undefined.TextSize=14 undefined.TextXAlignment=Enum.TextXAlignment.Left bc.Name="Button"bc.Parent=e bc.BackgroundColor3=Color3.new(0.160784,0.290196,0.478431)bc.BackgroundTransparency=1 bc.BorderSizePixel=0 bc.Size=UDim2.new(0,91,0,20)bc.ZIndex=2 bc.Font=Enum.Font.GothamSemibold bc.TextColor3=Color3.new(1,1,1)bc.TextSize=14 cc.Name="TextButton_Roundify_4px"cc.Parent=bc cc.BackgroundColor3=Color3.new(1,1,1)cc.BackgroundTransparency=1 cc.Size=UDim2.new(1,0,1,0)cc.Image="rbxassetid://2851929490"cc.ImageColor3=Color3.new(0.160784,0.290196,0.478431)cc.ScaleType=Enum.ScaleType.Slice cc.SliceCenter=Rect.new(4,4,4,4)dc.Name="DropdownButton"dc.Parent=e dc.BackgroundColor3=Color3.new(0.129412,0.133333,0.141176)dc.BorderSizePixel=0 dc.Size=UDim2.new(1,0,0,20)dc.ZIndex=3 dc.Font=Enum.Font.GothamBold dc.Text="      Button"dc.TextColor3=Color3.new(0.784314,0.784314,0.784314)dc.TextSize=14 dc.TextXAlignment=Enum.TextXAlignment.Left ec.Name="Keybind"ec.Parent=e ec.BackgroundColor3=Color3.new(1,1,1)ec.BackgroundTransparency=1 ec.Size=UDim2.new(0,200,0,20)ec.Image="rbxassetid://2851929490"ec.ImageColor3=Color3.new(0.203922,0.207843,0.219608)ec.ScaleType=Enum.ScaleType.Slice ec.SliceCenter=Rect.new(4,4,4,4)fc.Name="Title"fc.Parent=ec fc.BackgroundColor3=Color3.new(1,1,1)fc.BackgroundTransparency=1 fc.Size=UDim2.new(0,0,1,0)fc.Font=Enum.Font.GothamBold fc.Text="Keybind"fc.TextColor3=Color3.new(0.784314,0.784314,0.784314)fc.TextSize=14 fc.TextXAlignment=Enum.TextXAlignment.Left gc.Name="Input"gc.Parent=ec gc.BackgroundColor3=Color3.new(1,1,1)gc.BackgroundTransparency=1 gc.BorderSizePixel=0 gc.Position=UDim2.new(1,-85,0,2)gc.Size=UDim2.new(0,80,1,-4)gc.ZIndex=2 gc.Font=Enum.Font.GothamSemibold gc.Text="RShift"gc.TextColor3=Color3.new(0.784314,0.784314,0.784314)gc.TextSize=12 gc.TextWrapped=true hc.Name="Input_Roundify_4px"hc.Parent=gc hc.BackgroundColor3=Color3.new(1,1,1)hc.BackgroundTransparency=1 hc.Size=UDim2.new(1,0,1,0)hc.Image="rbxassetid://2851929490"hc.ImageColor3=Color3.new(0.290196,0.294118,0.313726)hc.ScaleType=Enum.ScaleType.Slice hc.SliceCenter=Rect.new(4,4,4,4)ic.Name="Windows"ic.Parent=d ic.BackgroundColor3=Color3.new(1,1,1)ic.BackgroundTransparency=1 ic.Position=UDim2.new(0,20,0,20)ic.Size=UDim2.new(1,20,1,-20)script.Parent=d local e=game:GetService("UserInputService")local f=game:GetService("TweenService")local g=game:GetService("RunService")local h=game:GetService("Players")local h=h.LocalPlayer local h=h:GetMouse()local i=script.Parent:WaitForChild("Prefabs")local j=script.Parent:FindFirstChild("Windows")local k={["binding"]=false}e.InputBegan:Connect(function(c,d)if d then return end if c.KeyCode==(typeof(b.toggle_key)=="EnumItem"and b.toggle_key or Enum.KeyCode.RightShift)then if script.Parent then if not k.binding then script.Parent.Enabled=not script.Parent.Enabled end end end end)local function l(b,c,d)d=d or 0.5 local d=TweenInfo.new(d,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)local b=f:Create(b,d,c)b:Play()end local function f(b,c,d)b,c,d=b/255,c/255,d/255 local e,f=math.max(b,c,d),math.min(b,c,d)local g,h,i i=e local j=e-f if e==0 then h=0 else h=j/e end if e==f then g=0 else if e==b then g=(c-d)/j if c<d then g=g+6 end elseif e==c then g=(d-b)/j+2 elseif e==d then g=(b-c)/j+4 end g=g/6 end return g,h,i end local function m(b,c)local b,c=pcall(function()return b[tostring(c)]end)if b then return c end end local function n(b)return b.TextBounds.X+15 end local function o()return Vector2.new(e:GetMouseLocation().X+1,e:GetMouseLocation().Y-35)end local function p(b,c,d)spawn(function()b.ClipsDescendants=true local e=i:FindFirstChild("Circle"):Clone()e.Parent=b e.ZIndex=1000 local c=c-e.AbsolutePosition.X local d=d-e.AbsolutePosition.Y e.Position=UDim2.new(0,c,0,d)local c=0 if b.AbsoluteSize.X>b.AbsoluteSize.Y then c=b.AbsoluteSize.X*1.5 elseif b.AbsoluteSize.X<b.AbsoluteSize.Y then c=b.AbsoluteSize.Y*1.5 elseif b.AbsoluteSize.X==b.AbsoluteSize.Y then c=b.AbsoluteSize.X*1.5 end e:TweenSizeAndPosition(UDim2.new(0,c,0,c),UDim2.new(0.5,-c/2,0.5,-c/2),"Out","Quad",0.5,false,nil)l(e,{ImageTransparency=1},0.5)wait(0.5)e:Destroy()end)end local q=0 local r={}local function s()local b=i:FindFirstChild("UIListLayout"):Clone()b.Parent=j local c={}for b,b in next,j:GetChildren()do if not b:IsA("UIListLayout")then c[b]=b.AbsolutePosition end end b:Destroy()for b,c in next,c do b.Position=UDim2.new(0,c.X,0,c.Y)end end function r:FormatWindows()s()end function r:Ready()d.Enabled=true end function r:AddWindow(d,r)q=q+1 local s=false local t=true d=tostring(d or"New Window")r=typeof(r)=="table"and r or b r.tween_time=0.1 local b=i:FindFirstChild("Window"):Clone()b.Parent=j b.ImageColor3=r.window_color b:FindFirstChild("Title").Text=d b.Size=UDim2.new(0,r.default_size.X,0,r.default_size.Y)b.ZIndex=b.ZIndex+q*10 function dragify(b)local c local d local e local f local function f(c)Delta=c.Position-e Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+Delta.X,startPos.Y.Scale,startPos.Y.Offset+Delta.Y)game:GetService("TweenService"):Create(b,TweenInfo.new(0.01),{Position=Position}):Play()end b.InputBegan:Connect(function(d)if(d.UserInputType==Enum.UserInputType.MouseButton1 or d.UserInputType==Enum.UserInputType.Touch)and t then c=true e=d.Position startPos=b.Position d.Changed:Connect(function()if d.UserInputState==Enum.UserInputState.End then c=false end end)end end)b.InputChanged:Connect(function(b)if(b.UserInputType==Enum.UserInputType.MouseMovement or b.UserInputType==Enum.UserInputType.Touch)and t then d=b end end)game:GetService("UserInputService").InputChanged:Connect(function(b)if b==d and c and t then f(b)end end)end do local c=b:FindFirstChild("Title")local c=b:FindFirstChild("Bar")local d=c:FindFirstChild("Base")local e=c:FindFirstChild("Top")local b=b:FindFirstChild("TabSelection"):FindFirstChild("Frame")local f=c:FindFirstChild("Toggle")spawn(function()while g.Heartbeat:Wait()do c.BackgroundColor3=r.main_color d.BackgroundColor3=r.main_color d.ImageColor3=r.main_color e.ImageColor3=r.main_color b.BackgroundColor3=r.main_color end end)end local d=b:WaitForChild("Resizer")local j={}dragify(b)do local c=false d.MouseEnter:Connect(function()t=false c=true end)d.MouseLeave:Connect(function()c=false t=true end)local f=false e.InputBegan:Connect(function(e)if e.UserInputType==Enum.UserInputType.MouseButton1 then f=true spawn(function()if c and d.Active and r.can_resize then while f and d.Active and g.Heartbeat:Wait()do local c=o()local d=c.X-b.AbsolutePosition.X local c=c.Y-b.AbsolutePosition.Y if d>=r.min_size.X and c>=r.min_size.Y then l(b,{Size=UDim2.new(0,d,0,c)},r.tween_time)elseif d>=r.min_size.X then l(b,{Size=UDim2.new(0,d,0,r.min_size.Y)},r.tween_time)elseif c>=r.min_size.Y then l(b,{Size=UDim2.new(0,r.min_size.X,0,c)},r.tween_time)else l(b,{Size=UDim2.new(0,r.min_size.X,0,r.min_size.Y)},r.tween_time)end end end end)end end)e.InputEnded:Connect(function(b)if b.UserInputType==Enum.UserInputType.MouseButton1 then f=false end end)end do local c=b:FindFirstChild("Bar"):FindFirstChild("Toggle")local e=true local f=true local g={}local h=b.AbsoluteSize.Y c.MouseButton1Click:Connect(function()if f then f=false if e then g={}for b,b in next,b:FindFirstChild("Tabs"):GetChildren()do g[b]=b.Visible b.Visible=false end d.Active=false h=b.AbsoluteSize.Y l(c,{Rotation=0},r.tween_time)l(b,{Size=UDim2.new(0,b.AbsoluteSize.X,0,26)},r.tween_time)c.Parent:FindFirstChild("Base").Transparency=1 else for b,c in next,g do b.Visible=c end d.Active=true l(c,{Rotation=90},r.tween_time)l(b,{Size=UDim2.new(0,b.AbsoluteSize.X,0,h)},r.tween_time)c.Parent:FindFirstChild("Base").Transparency=0 end e=not e wait(r.tween_time)f=true end end)end do local d=b:FindFirstChild("Tabs")local b=b:FindFirstChild("TabSelection")local m=b:FindFirstChild("TabButtons")do function j:AddTab(j)local u={}j=tostring(j or"New Tab")b.Visible=true local b=i:FindFirstChild("TabButton"):Clone()b.Parent=m b.Text=j b.Size=UDim2.new(0,n(b),0,20)b.ZIndex=b.ZIndex+q*10 b:GetChildren()[1].ZIndex=b:GetChildren()[1].ZIndex+q*10 local j=i:FindFirstChild("Tab"):Clone()j.Parent=d j.ZIndex=j.ZIndex+q*10 local function v()if s then return end for b,b in next,m:GetChildren()do if not b:IsA("UIListLayout")then b:GetChildren()[1].ImageColor3=Color3.fromRGB(52,53,56)l(b,{Size=UDim2.new(0,b.AbsoluteSize.X,0,20)},r.tween_time)end end for b,b in next,d:GetChildren()do b.Visible=false end l(b,{Size=UDim2.new(0,b.AbsoluteSize.X,0,25)},r.tween_time)b:GetChildren()[1].ImageColor3=Color3.fromRGB(73,75,79)j.Visible=true end b.MouseButton1Click:Connect(function()v()end)function u:Show()v()end do function u:Label(b)b=tostring(b or"New Label")local c={}local d=i:FindFirstChild("Label"):Clone()d.Parent=j d.Text=b d.Size=UDim2.new(0,n(d),0,20)d.ZIndex=d.ZIndex+q*10 function c:Set(b)d.Text=b end function c:SetColor(b)d.TextColor3=b end return c,d end function u:Button(b,c)b=tostring(b or"New Button")c=typeof(c)=="function"and c or function()end local d=i:FindFirstChild("Button"):Clone()d.Parent=j d.Text=b d.Size=UDim2.new(0,n(d),0,20)d.ZIndex=d.ZIndex+q*10 d:GetChildren()[1].ZIndex=d:GetChildren()[1].ZIndex+q*10 spawn(function()while true do d:GetChildren()[1].ImageColor3=r.main_color g.Heartbeat:Wait()end end)d.MouseButton1Click:Connect(function()p(d,h.X,h.Y)pcall(c)end)return d end function u:Toggle(b,d)local e={}b=tostring(b or"New Switch")d=typeof(d)=="function"and d or function()end local f=i:FindFirstChild("Switch"):Clone()f.Parent=j f:FindFirstChild("Title").Text=b f:FindFirstChild("Title").ZIndex=f:FindFirstChild("Title").ZIndex+q*10 f.ZIndex=f.ZIndex+q*10 f:GetChildren()[1].ZIndex=f:GetChildren()[1].ZIndex+q*10 spawn(function()while true do f:GetChildren()[1].ImageColor3=r.main_color g.Heartbeat:Wait()end end)local g=false f.MouseButton1Click:Connect(function()g=not g f.Text=g and utf8.char(10003)or""pcall(d,g)end)e.Name=b function e:Set(b)g=typeof(b)=="boolean"and b or false f.Text=g and utf8.char(10003)or""pcall(d,g)end table.insert(c,e)return e,f end function u:Box(b,c,d)b=tostring(b or"New TextBox")c=typeof(c)=="function"and c or function()end d=typeof(d)=="table"and d or{["clear"]=true}d={["clear"]=d.clear==true}local e=i:FindFirstChild("TextBox"):Clone()e.Parent=j e.PlaceholderText=b e.ZIndex=e.ZIndex+q*10 e:GetChildren()[1].ZIndex=e:GetChildren()[1].ZIndex+q*10 e.FocusLost:Connect(function(b)if b then if#e.Text>0 then pcall(c,e.Text)if d.clear then e.Text=""end end end end)return e end function u:Slider(b,c,d)local f={}b=tostring(b or"New Slider")c=typeof(c)=="function"and c or function()end d=typeof(d)=="table"and d or{}d={["min"]=d.min or 0,["max"]=d.max or 100,["readonly"]=d.readonly or false}local h=i:FindFirstChild("Slider"):Clone()h.Parent=j h.ZIndex=h.ZIndex+q*10 local i=h:FindFirstChild("Title")local j=h:FindFirstChild("Indicator")local k=h:FindFirstChild("Value")i.ZIndex=i.ZIndex+q*10 j.ZIndex=j.ZIndex+q*10 k.ZIndex=k.ZIndex+q*10 i.Text=b do local b=false h.MouseEnter:Connect(function()b=true t=false end)h.MouseLeave:Connect(function()b=false t=true end)local i=false e.InputBegan:Connect(function(e)if e.UserInputType==Enum.UserInputType.MouseButton1 then i=true spawn(function()if b and not d.readonly then while i and not s and g.Heartbeat:Wait()do local b=o()local b=(h.AbsoluteSize.X-(h.AbsoluteSize.X-(b.X-h.AbsolutePosition.X)+1))/h.AbsoluteSize.X local e=0 local f=1 local g=e if b>=e and b<=f then g=b elseif b<e then g=e elseif b>f then g=f end l(j,{Size=UDim2.new(g or e,0,0,20)},r.tween_time)local b=math.floor((g or e)*100)local e=d.max local d=d.min local e=e-d local b=math.floor(e/100*b+d)k.Text=tostring(b)pcall(c,b)end end end)end end)e.InputEnded:Connect(function(b)if b.UserInputType==Enum.UserInputType.MouseButton1 then i=false end end)function f:Set(b)b=tonumber(b)or 0 b=(b>=0 and b<=100 and b)/100 l(j,{Size=UDim2.new(b or 0,0,0,20)},r.tween_time)local b=math.floor((b or 0)*100)local e=d.max local d=d.min local e=e-d local b=math.floor(e/100*b+d)k.Text=tostring(b)pcall(c,b)end f:Set(0)end return f,h end function u:Bind(b,c,d)local f={}b=tostring(b or"New Keybind")c=typeof(c)=="function"and c or function()end d=typeof(d)=="table"and d or{}d={["standard"]=d.standard or Enum.KeyCode.RightShift}local g=i:FindFirstChild("Keybind"):Clone()local h=g:FindFirstChild("Input")local i=g:FindFirstChild("Title")g.ZIndex=g.ZIndex+q*10 h.ZIndex=h.ZIndex+q*10 h:GetChildren()[1].ZIndex=h:GetChildren()[1].ZIndex+q*10 i.ZIndex=i.ZIndex+q*10 g.Parent=j i.Text="  "..b g.Size=UDim2.new(0,n(i)+80,0,20)local b={RightControl='RightCtrl',LeftControl='LeftCtrl',LeftShift='LShift',RightShift='RShift',MouseButton1="Mouse1",MouseButton2="Mouse2"}local g=d.standard function f:Set(c)local b=b[c.Name]or c.Name h.Text=b g=c end e.InputBegan:Connect(function(b,d)if k.binding then spawn(function()wait()k.binding=false end)return end if b.KeyCode==g and not d then pcall(c,g)end end)f:Set(d.standard)h.MouseButton1Click:Connect(function()if k.binding then return end h.Text="..."k.binding=true local b,c=e.InputBegan:Wait()f:Set(b.KeyCode)end)return f,g end function u:Dropdown(b,c)local d={}b=tostring(b or"New Dropdown")c=typeof(c)=="function"and c or function()end local e=i:FindFirstChild("Dropdown"):Clone()local f=e:FindFirstChild("Box")local g=f:FindFirstChild("Objects")local h=e:FindFirstChild("Indicator")e.ZIndex=e.ZIndex+q*10 f.ZIndex=f.ZIndex+q*10 g.ZIndex=g.ZIndex+q*10 h.ZIndex=h.ZIndex+q*10 e:GetChildren()[3].ZIndex=e:GetChildren()[3].ZIndex+q*10 e.Parent=j e.Text="      "..b f.Size=UDim2.new(1,0,0,0)local b=false e.MouseButton1Click:Connect(function()b=not b local c=(#g:GetChildren()-1)*20 if#g:GetChildren()-1>=10 then c=10*20 g.CanvasSize=UDim2.new(0,0,(#g:GetChildren()-1)*0.1,0)end if b then if s then return end s=true l(f,{Size=UDim2.new(1,0,0,c)},r.tween_time)l(h,{Rotation=90},r.tween_time)else s=false l(f,{Size=UDim2.new(1,0,0,0)},r.tween_time)l(h,{Rotation=-90},r.tween_time)end end)function d:Add(d)local j={}d=tostring(d or"New Object")local i=i:FindFirstChild("DropdownButton"):Clone()i.Parent=g i.Text=d i.ZIndex=i.ZIndex+q*10 i.MouseEnter:Connect(function()i.BackgroundColor3=r.main_color end)i.MouseLeave:Connect(function()i.BackgroundColor3=Color3.fromRGB(33,34,36)end)if b then local b=(#g:GetChildren()-1)*20 if#g:GetChildren()-1>=10 then b=10*20 g.CanvasSize=UDim2.new(0,0,(#g:GetChildren()-1)*0.1,0)end l(f,{Size=UDim2.new(1,0,0,b)},r.tween_time)end i.MouseButton1Click:Connect(function()if s then e.Text="      [ "..d.." ]"s=false b=false l(f,{Size=UDim2.new(1,0,0,0)},r.tween_time)l(h,{Rotation=-90},r.tween_time)pcall(c,d)end end)function j:Remove()i:Destroy()end return i,j end return d,e end function u:ColorPicker(b)local c={}b=typeof(b)=="function"and b or function()end local d=i:FindFirstChild("ColorPicker"):Clone()d.Parent=j d.ZIndex=d.ZIndex+q*10 local h=d:FindFirstChild("Palette")local i=d:FindFirstChild("Sample")local j=d:FindFirstChild("Saturation")h.ZIndex=h.ZIndex+q*10 i.ZIndex=i.ZIndex+q*10 j.ZIndex=j.ZIndex+q*10 do local d=0 local k=1 local m=1 local function n()local c=Color3.fromHSV(d,k,m)i.ImageColor3=c j.ImageColor3=Color3.fromHSV(d,1,1)pcall(b,c)end do local b=Color3.fromHSV(d,k,m)i.ImageColor3=b j.ImageColor3=Color3.fromHSV(d,1,1)end local p,u=false,false h.MouseEnter:Connect(function()t=false p=true end)h.MouseLeave:Connect(function()t=true p=false end)j.MouseEnter:Connect(function()t=false u=true end)j.MouseLeave:Connect(function()t=true u=false end)local t=h:FindFirstChild("Indicator")local v=j:FindFirstChild("Indicator")t.ZIndex=t.ZIndex+q*10 v.ZIndex=v.ZIndex+q*10 local q=false e.InputBegan:Connect(function(b)if b.UserInputType==Enum.UserInputType.MouseButton1 then q=true spawn(function()while q and p and not s do local b=o()local c=h.AbsoluteSize.X-(b.X-h.AbsolutePosition.X)+1 local b=h.AbsoluteSize.Y-(b.Y-h.AbsolutePosition.Y)+1.5 local e=Color3.fromHSV(c/100,b/100,0)d=c/100 k=b/100 l(t,{Position=UDim2.new(0,math.abs(c-100)-t.AbsoluteSize.X/2,0,math.abs(b-100)-t.AbsoluteSize.Y/2)},r.tween_time)n()g.Heartbeat:Wait()end while q and u and not s do local b=o()local b=h.AbsoluteSize.Y-(b.Y-h.AbsolutePosition.Y)+1.5 m=b/100 l(v,{Position=UDim2.new(0,0,0,math.abs(b-100))},r.tween_time)n()g.Heartbeat:Wait()end end)end end)e.InputEnded:Connect(function(b)if b.UserInputType==Enum.UserInputType.MouseButton1 then q=false end end)function c:Set(c)c=typeof(c)=="Color3"and c or Color3.new(1,1,1)local d,e,e=f(c.r*255,c.g*255,c.b*255)i.ImageColor3=c j.ImageColor3=Color3.fromHSV(d,1,1)pcall(b,c)end end return c,d end end return u,j end end end do for b,b in next,b:GetDescendants()do if m(b,"ZIndex")then b.ZIndex=b.ZIndex+q*10 end end end return j,b end return r,b,c,d]])()
    local window = library:AddWindow("ice tray "..VERSION)    
    local playerwindow = window:AddTab("Player")
    local vehiclewindow = window:AddTab("Vehicle")
    local teleportswindow = window:AddTab("Teleports")
    local combatwindow = window:AddTab("Combat")
    local funwindow = window:AddTab("Fun")
    local miscwindow = window:AddTab("Misc")
    local statuswindow = window:AddTab("Status")
    local uiwindow = window:AddTab("UI")

    local ws = playerwindow:Slider("Walkspeed", function(callback)
        _G.WalkSpeed = callback
        player.Character.Humanoid.WalkSpeed = callback
    end,{
        min = 16,
        max = 100
    })
    local jp = playerwindow:Slider("Jumppower", function(callback)
        jumppower(callback)
    end,{
        min = 50,
        max = 300
    })
    local nc = playerwindow:Toggle("No Clip", function(callback)
        toggl.noclip = callback
    end):Set(toggl.noclip)
    local floating = playerwindow:Toggle("Float", function(callback)
        toggl.floatplayer = callback
    end):Set(toggl.floatplayer)
    local antiragdoll = playerwindow:Toggle("Anti Ragdoll", function(callback)
        toggl.antiragdoll = callback
    end):Set(toggl.antiragdoll)
    local fly = playerwindow:Toggle("Fly", function(callback)
        toggl.playerfly = callback
        if toggl.playerfly == true then
            playerfly()
        end
    end):Set(toggl.playerfly)
    local flyspeed = playerwindow:Slider("Fly Speed", function(callback)
        speed_fly2 = tonumber(callback)
    end,{
        min=50,
        max=100
    })
    local nowait = playerwindow:Toggle("No Wait", function(callback)
        toggl.nowait = callback
    end):Set(toggl.nowait)
    local holdgun = playerwindow:Toggle("Hold gun while crawling", function(callback)
        toggl.crawling = callback
        for i,v in next, getgc(true) do
            if type(v):match("table") and rawget(v, "IsCrawling") then
                runss.Stepped:connect(function()
                    if toggl.crawling == true then
                        v.IsCrawling = false    
                    end
                end)
            end
        end
    end):Set(toggl.crawling)
    local shootasdriver = playerwindow:Toggle("Hold gun while driving", function(callback)
        local bread = require(repl.Game.Vehicle)
        local backup = bread.GetLocalVehiclePacket
        toggl.shootingdriver = callback
        bread.GetLocalVehiclePacket = function(...)
            if toggl.shootingdriver == true then
                return nil
            else
                return backup(...)
            end
            return backup(...)
        end
    end):Set(toggl.shootingdriver)
    local jetpackss = playerwindow:Toggle("Hold gun while flying", function(callback)
        toggl.jetpackss = callback
        local isflfl = require(repl.Game.JetPack.JetPack).IsFlying
        require(repl.Game.JetPack.JetPack).IsFlying = function(...)
            if toggl.jetpackss == true then
                return nil
            else
                return isflfl(...)
            end
            return isflfl(...)
        end
    end):Set(toggl.jetpackss)
    local infjump = playerwindow:Toggle("Infinite Jump", function(callback)
        toggl.infjump = callback
    end):Set(toggl.nowait)
    local teamcooldown = playerwindow:Toggle("Remove Team Cooldown", function(callback)
        toggl.teamchange = callback
        require(repl.Resource.Settings).Time.BetweenTeamChange = callback and 0 or 24
    end):Set(toggl.teamchange)
    local teamcooldown = playerwindow:Toggle("Remove Cell Time", function(callback)
        toggl.celltimes = callback
        require(repl.Resource.Settings).Time.Cell = callback and 0 or 20
    end):Set(toggl.celltimes)
    local team_dropdown = playerwindow:Dropdown("Change Team", function(callback)
        if callback == "Police" then
            setupvalue(client.changeteam,1,1)
            setupvalue(client.changeteam,2,network)
            client.changeteam()
        elseif callback == "Prisoner" then
            setupvalue(client.changeteam,1,0)
            setupvalue(client.changeteam,2,network)
            client.changeteam()
        end
    end)
    team_dropdown:Add("Police")
    team_dropdown:Add("Prisoner")

    vehiclewindow:Slider("Car Height", function(callback)
        _G.CarHeight = tonumber(callback)
        client.gv().Height = tonumber(callback)
    end,{
        ["min"]=3,
        ["max"]=100
    })
    vehiclewindow:Slider("Car Turning Speed", function(callback)
        _G.CarTurnSpeed = tonumber(callback)
        client.gv().TurnSpeed = tonumber(callback)
    end,{
        ["min"]=1,
        ["max"]=20
    })
    vehiclewindow:Slider("Car Speed", function(callback)
        _G.CarSpeed = tonumber(callback)
        client.gv().GarageEngineSpeed = tonumber(callback)
    end,{
        ["min"]=3,
        ["max"]=100
    })
    vehiclewindow:Slider("Car Brakes", function(callback)
        _G.CarBrakes = tonumber(callback)
        client.gv().GarageBrakes = tonumber(callback)
    end,{
        ["min"]=3,
        ["max"]=100
    })
    vehiclewindow:Slider("Plane Speed", function(callback)
        _G.PlaneSpeed = tonumber(callback)
        for i,v in next, getgc(true) do
            if type(v):match("table") and rawget(v, "MAX_THRUST") then
                v.MAX_THRUST = callback
            end
        end
    end,{
        ["min"]=600,
        ["max"]=11000
    })
    local autodrive = vehiclewindow:Toggle("Auto Drive", function(callback)
        toggl.autodrive = callback
        setupvalue(client.AutoDrive,8,callback)
    end):Set(toggl.autodrive)
    local infnitro = vehiclewindow:Toggle("Infinite Nitro", function(callback)
        toggl.infnitro = callback
    end):Set(toggl.infnitro)
    local spamlights = vehiclewindow:Toggle("Spam Carlights", function(callback)
        toggl.carlights = callback
    end):Set(toggl.carlights)
    local alwaysdrift = vehiclewindow:Toggle("Always Drift", function(callback)
        toggl.alwaysdrift = callback
    end):Set(toggl.alwaysdrift)
    local antitirepop = vehiclewindow:Toggle("Anti Tirepop", function(callback)
        toggl.tirepop = callback
    end):Set(toggl.tirepop)
    local injanhorn = vehiclewindow:Toggle("Injanhorn", function(callback)
        toggl.injanhorn = callback
            require(repl.Resource.Settings).Perm.InjanHorn.Id[tostring(player.UserId)] = callback
    end):Set(toggl.injanhorn)
    local heliHeight = vehiclewindow:Toggle("Infinite Heli Height", function(callback)
        toggl.maxheight = callback
        if callback == true then
            client.MaxHeight.MaxHeight = math.huge
        elseif callback == false then
            client.MaxHeight.MaxHeight = 400
        end
    end)
    local removeplaneheight = vehiclewindow:Toggle("Remove Plane Max Height", function(callback)
        toggl.planemax = callback
        for i,v in next, getgc(true) do
            if type(v):match("table") and rawget(v, "HEIGHT_MAX") then
                v.HEIGHT_MAX = callback and 55555 or 1500 
            end
        end
    end):Set(toggl.planemax)
    local jetskiland = vehiclewindow:Toggle("Jetski on land", function(callback)
        toggl.waterheight = callback
        for i,v in next, getgc(true) do
            if type(v):match("table") and rawget(v, "WaterHeight") then
                v.WaterHeight = callback and 112 or -12
            end
        end
    end):Set(toggl.waterheight)

    teleportswindow:Box("Player Name", function(callback)
        for i,v in next, players:GetPlayers() do
            if string.find(string.lower(v.Name), string.lower(tostring(callback))) then
                teleport(v.Character.HumanoidRootPart.CFrame)
                teleport2(v.Character.HumanoidRootPart.CFrame)
            end
        end
    end)
    local methods = teleportswindow:Dropdown("TP Methods", function(select)
        if select == "Under map TP (default)" then
            getgenv().usetpmethod2 = false
        elseif select == "Save car TP" then
            getgenv().usetpmethod2 = true
        end
    end)
    local teleportss = teleportswindow:Dropdown("Stores", function(select)
        if getgenv().usetpmethod2 == true then
            teleport2(locations.Stores[select])
        elseif getgenv().usetpmethod2 == false then
            teleport(locations.Stores[select])
        end
    end)
    local teleportss2 = teleportswindow:Dropdown("Locations", function(select)
        if getgenv().usetpmethod2 == true then
            teleport2(locations.Locations[select])
        elseif getgenv().usetpmethod2 == false then
            teleport(locations.Locations[select])
        end
    end)
    local teleportss3 = teleportswindow:Dropdown("Vehicles", function(select)
        if getgenv().usetpmethod2 == true then
            teleport2(locations.Vehicles[select])
        elseif getgenv().usetpmethod2 == false then
            teleport(locations.Vehicles[select])
        end
    end)
    for i,v in next, locations.Stores do
        teleportss:Add(i)
    end
    for i,v in next, locations.Locations do
        teleportss2:Add(i)
    end
    for i,v in next, locations.Vehicles do
        teleportss3:Add(i)
    end
    methods:Add("Under map TP (default)")
    methods:Add("Save car TP")

    teleportswindow:Button("Teleport to Cargoship", function()
        local ship = workspace:FindFirstChild("CargoShip")
        if not ship then client.Notify({Text="cargoship not on the map"}) end
        local crate = ship and ship.Crates:FindFirstChild("Crate")
        if crate then
            teleport2(crate.Part.CFrame + Vector3.new(0,10,0))
            teleport(crate.Part.CFrame + Vector3.new(0,10,0))
        end
    end)
    teleportswindow:Button("Teleport to Airdrop", function()
        local drop = workspace:FindFirstChild("Drop")
        if not drop then client.Notify({Text = "no airdrops found"}) end
        for i,v in next, drop:GetChildren() do
            if v.Name == "Briefcase" then
                teleport2(v.CFrame)
                teleport(v.CFrame)
            end
        end
    end)

    local inffuel = combatwindow:Toggle("Infinite Jetpack Fuel", function(callback)
        toggl.jetpack = callback
        if toggl.jetpack == false then
            client.Jetpack.LocalMaxFuel = 0
            client.Jetpack.LocalFuel = 0
            client.Jetpack.LocalFuelType = "Standard"
        elseif toggl.jetpack == true then
            client.Jetpack.LocalMaxFuel = math.huge
            client.Jetpack.LocalFuel = math.huge
            client.Jetpack.LocalFuelType = "Rocket"
        end
    end)
    local killaura = combatwindow:Toggle("Kill Aura", function(callback)
        toggl.killaura = callback
        network:FireServer("d115d87f", "PlasmaPistol")
    end)
    local antiarrest = combatwindow:Toggle("Anti Arrest", function(callback)
        toggl.antiarrest = callback
    end):Set(toggl.antiarrest)
    local infammo = combatwindow:Toggle("Infinite Ammo", function(callback)   
        toggl.infinite_ammo = callback
        for i,v in next, repl.Game.ItemConfig:GetChildren() do
            local b = require(v)
            local backupMagSize = b.MagSize
            local backupAmmo = b.AmmoCurrent
            b.MagSize = callback and math.huge or backupMagSize
            b.AmmoCurrent = callback and math.huge or backupAmmo
        end
        for i,v in next, getgc(true) do
            if type(v):match("table") and rawget(v, "AmmoCurrent") then
                local ss = v.AmmoCurrent
                v.AmmoCurrent = callback and math.huge or ss
            end
        end
    end)
    local rapidfire = combatwindow:Toggle("Rapid Fire", function(callback)
        toggl.rapid_fire = callback   
        for i,v in next, repl.Game.ItemConfig:GetChildren() do
            if v.Name ~= "PlasmaPistol" then
                local b = require(v)
                local backupFireFreq = b.FireFreq
                b.FireFreq = callback and 999999 or backupFireFreq
                b.FireAuto = callback
            end
        end
    end)
    local recoil = combatwindow:Toggle("Remove Camera Shake", function(callback)
        toggl.camera_shake = callback
        for i,v in next, repl.Game.ItemConfig:GetChildren() do
            local b = require(v)
            local backupCamShake = b.CamShakeMagnitude
            b.CamShakeMagnitude = callback and -math.huge or backupCamShake
        end
    end)
    local reloading = combatwindow:Toggle("Instant Reload", function(callback)
        toggl.instant_reload = callback
        for i,v in next, repl.Game.ItemConfig:GetChildren() do
            local b = require(v)
            local backupReload = b.ReloadTime
            b.ReloadTime = callback and -math.huge or backupReload
        end
        for i,v in next, getgc(true) do
            if type(v):match("table") and rawget(v, "ReloadTime") then
                local ss = v.ReloadTime
                v.ReloadTime = callback and -math.huge or ss
            end
        end
        local tase = require(repl.Game.Item.Taser).Tase
        require(repl.Game.Item.Taser).Tase = function(self,...)
            self.Config.ReloadTime = -math.huge
            self.Config.ReloadTimeHit = -math.huge
            return tase(self,...)
        end
    end)    
    combatwindow:Button("Give owned guns", function()
        for i,v in next, workspace.Givers:GetChildren() do
            if v.Name == "Guns" then
                fireclickdetector(v.ClickDetector)
            end
        end
        for i,v in next, client.Guns do
            network:FireServer("d115d87f", i)
        end
        wait(0.25)
    end)
    --[[combatwindow:Button("Arrest all (glitchy)", function()
        print("button broke")
        _G.abort = false
        local agd = false
        if not toggl.godmode then
            agd = true
            toggl.godmode = true
        end
        repeat wait()
            for i,v in next, players:GetPlayers() do
                if v.Team == game:GetService("Teams").Criminal then
                    if not v.Character:FindFirstChild("Handcuffs") then
                        if not checkbank(v.Character.HumanoidRootPart) and not checkjew(v.Character.HumanoidRootPart) and not checkmus(v.Character.HumanoidRootPart) and not checkpowerplant(v.Character.HumanoidRootPart) and _G.abort == false then
                            if v.Name ~= "alex9gamingvlogs" then
                                if not table.find(whitelists, v.Name) then
                                    local getCharacter = (v.Character and v.Character:FindFirstChild("InVehicle"))
                                    if getCharacter then
                                        repeat wait()
                                            if not (syn and not OXYGEN_LOADED and not KRNL_LOADED) then
                                                setupvalue(client.Eject,1,network)
                                                setupvalue(client.Eject,2,v.Name)
                                                client.Eject()
                                            else
                                                network:FireServer("aa6ebeaf", v.Name)
                                        until v.Character:FindFirstChild("InVehicle") == nil
                                    end
                                    wait()
                                    repeat wait()
                                        client.Arrest(v)
                                        teleportarrest(v.Character.HumanoidRootPart.CFrame)
                                    until v.Character:FindFirstChild("Handcuffs") or _G.abort == true
                                    wait()
                                end
                            end
                        end
                    else
                        _G.abort = true
                        if agd then
                            agd = false
                            toggl.godmode = false
                        end
                    end
                elseif not v.Team == game:GetService("Teams").Criminal then
                    _G.abort = true
                    if agd then
                        agd = false
                        toggl.godmode = false
                    end
                end
            end
        until _G.abort == true
    end)--]]
    combatwindow:Button("Force Stop", function()
        _G.abort = true
    end)
    
    local givemoney = funwindow:Box("Give Money", function(callback)
        client.GiveCash(tonumber(callback), "this fake pranked jaja :v")
    end)
    local notific = funwindow:Box("Send Notification", function(callback)
        client.Notify({Text=tostring(callback)})
    end)
    local doorsopen = funwindow:Toggle("Open All Doors", function(callback)
        toggl.doors = callback
    end)
    local liftinggate = funwindow:Toggle("Open Lift Gate", function(callback)
        toggl.liftgate = callback
    end)
    local sewerhatche = funwindow:Toggle("Open Sewer Hatch", function(callback)
        toggl.sewerhatch = callback
    end)
    local explodingwall = funwindow:Toggle("Explode Wall", function(callback)
        toggl.explodewall = callback
    end)--[[
    local ejectall = funwindow:Toggle("Eject all", function(callback)
        toggl.eject_all = callback
    end)
    funwindow:Box("Eject Player", function(callback)
        for i,v in next, players:GetPlayers() do
            if string.find(string.lower(v.Name), string.lower(tostring(callback))) then
                if not (syn and not OXYGEN_LOADED and not KRNL_LOADED) then
                    setupvalue(client.Eject,1,network)
                    setupvalue(client.Eject,2,v.Name)
                    client.Eject()
                else
                network:FireServer("aa6ebeaf", v.Name)
            end
        end
    end)
    funwindow:Box("Loop Eject Player", function(callback)
        for i,v in next, players:GetPlayers() do
            if string.find(string.lower(v.Name), string.lower(tostring(callback))) then
                if not table.find(loop_eject, v.Name) then
                    table.insert(loop_eject, v.Name)
                    client.Notify({Text = "Loop ejecting: "..v.Name})
                elseif table.find(loop_eject, v.Name) then
                    table.remove(loop_eject, table.find(loop_eject, v.Name))
                    client.Notify({Text = "Stopped ejecting: "..v.Name})
                end
            end
        end
    end)--]]
    local annoyserver = funwindow:Toggle("Annoy Server", function(callback)
        toggl.annoyserver = callback
    end)
    funwindow:Button("Invisible", function()
        for i,v in next, workspace.Vehicles:GetDescendants() do
            if v.ClassName == "Model" and v.Name == "DuneBuggy" then
                if v:FindFirstChild("Seat") then
                    v.Seat:Destroy()
                end
                teleport(v.Passenger.CFrame + Vector3.new(2,1,0))
                wait(1)
                for i2,v2 in next, require(repl.Module.UI).CircleAction.Specs do
                    if v2.ValidRoot == v then
                        v2:Callback(true)
                        require(repl.Game.Item.Gun).SetLeaning({Config = { Motion = { Hip = { Springs = { ItemOffset = nil, ItemRotation = nil, NeckRotation = nil } } } },SpringItemOffset = {SetTarget = function() end},SpringItemRotation = {SetTarget = function() end},SpringNeckRotation = {SetTarget = function() end},Local = true}, false, false)
                        wait(0.3)
                        client.LeaveVehicle()
                        require(repl.Game.Item.Gun).SetLeaning({Config = { Motion = { Hip = { Springs = { ItemOffset = nil, ItemRotation = nil, NeckRotation = nil } } } },SpringItemOffset = {SetTarget = function() end},SpringItemRotation = {SetTarget = function() end},SpringNeckRotation = {SetTarget = function() end},Local = true}, false, false)
                    end
                end
                break
            end
        end
    end)
    funwindow:Button("Erupt Volcano", function()
        firetouchinterest(player.Character.HumanoidRootPart, workspace.LavaFun.Lavatouch, 0)
        wait()
        firetouchinterest(player.Character.HumanoidRootPart, workspace.LavaFun.Lavatouch, 1)
    end)--[[
    funwindow:Button("Crash nearby players", function()
        game:GetService("RunService").Heartbeat:connect(function()
            for i=0, crashchance do
                client.PlaySounds("Horn", {
                    Source = player.Character,
                    Volume = math.huge,
                    Pitch = -math.huge,
                    Multi = true,
                    MaxTime = 0.1,
                    Looped = true
                }, false)
            end
            wait()
            for i=0, crashchance do
                client.PlaySounds("Horn", {
                    Source = player.Character,
                    Volume = -math.huge,
                    Pitch = math.huge,
                    Multi = true,
                    MaxTime = 0.1,
                    Looped = true
                }, false)
            end
            wait()
        end)
    end)
    funwindow:Slider("Crash Chance", function(num)
        crashchance = tonumber(num)
    end,{
        ["min"]=10,
        ["max"]=1000
    })--]]
    funwindow:Button("Get Keycard", function()
        get_key()
    end)
    funwindow:Button("Open all safes", function()
        local safes = {};
        local safe;
        for i,v in next, getgc(true) do
            if type(v) == "table" and rawget(v, "ListSafes") then
                safe = v
            end
        end
        function updatelistsafes()
            for i=0, #safe.ListSafes do
                safes[i] = safe.ListSafes[i]    
            end
            return safes
        end
        function skipsafe()
            for i,v in next, getreg() do
                if type(v) == "function" and islclosure(v) then
                    for i2,v2 in next, getupvalues(v) do
                        if v2 == 0.12 then
                            setupvalue(v,i2,99999)
                            break
                        end
                    end
                end
            end    
        end
        while safes ~= 0 do
            if _G.stop_opening then return end
            -- tried some stuff here loool ignore plz :D
            for i,v in next, getconstants(safe.SetupUseSafes) do
                if i == 13 then
                    safe.SelectedSafe = table.remove(safes,1)
                    getupvalue(safe.SetupUseSafes,8):FireServer(v, safe.SelectedSafe)
                    skipsafe()
                end
            end
            updatelistsafes()
            wait()
        end
    end)
    local play_sounds = funwindow:Dropdown("Play Sounds", function(callback)
        client.PlaySounds(callback, {
            Source = workspace,
            Volume = math.huge,
            Multi = true,
            MaxTime = 15
        }, false)
    end)
    for i,v in next, sounds do
        play_sounds:Add(v)
    end

    local turretsdisable = miscwindow:Toggle("Disable Turrets", function(callback)
        toggl.disableturrets = callback
    end)
    local clicknuke = miscwindow:Toggle("Click Nuke", function(callback)
        toggl.clicknuke = callback
    end)
    local ctrldestroy = miscwindow:Toggle("CTRL Destroy", function(callback)
        toggl.ctrldestroy = callback
    end)
    miscwindow:Button("Give police clothing", function()
        for i,v in next, workspace.Givers:GetChildren() do
            if v.Name == "Station" then
                if v.Item.Value == "ShirtPolice" then
                    fireclickdetector(v.ClickDetector)
                end
                wait()
                if v.Item.Value == "PantsPolice" then
                    fireclickdetector(v.ClickDetector) 
                end
            end
        end
    end)    
    miscwindow:Button("Remove Clothing", function()
        local hitbox = workspace.ClothingRacks.ClothingRack.Hitbox
        hitbox.ClickDetector.MaxActivationDistance = math.huge
        wait()
        fireclickdetector(hitbox.ClickDetector)
    end)
    miscwindow:Button("Remove Lasers", function()
        for i,v in next, workspace:GetDescendants() do
            if v.Name == "BarbedWire" and not v:IsDescendantOf(workspace.MilitaryIsland) then
                v:Destroy()
            end
        end
    end)
    miscwindow:Button("Equip Jetpack", function()
        client.JetpackGiver()
    end)
    miscwindow:Button("FE Dance", function()
        local party_module = require(repl.Game.Party)
        getupvalues(party_module["Init"])[3]()
    end)
    miscwindow:Button("Anti Lag", function()
        workspace:FindFirstChildOfClass('Terrain').WaterWaveSize = 0
        workspace:FindFirstChildOfClass('Terrain').WaterWaveSpeed = 0
        workspace:FindFirstChildOfClass('Terrain').WaterReflectance = 0
        workspace:FindFirstChildOfClass('Terrain').WaterTransparency = 0
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        for i,v in next, game:GetDescendants() do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
        for i,v in next, game:GetService("Lighting"):GetDescendants() do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
    end)

    local NotifyWhenOpen = statuswindow:Toggle("Notify when open", function(callback)
        toggl.notify = callback
    end)
    local BankLabel = statuswindow:Label("Bank")
    local JewelryLabel = statuswindow:Label("Jewelry")
    local MuseumLabel = statuswindow:Label("Museum")
    local TrainLabel = statuswindow:Label("Train")
    local PowerplantLabel = statuswindow:Label("Powerplant")
    local PlaneLabel = statuswindow:Label("Plane")
    local ShipLabel = statuswindow:Label("Cargoship")
    local AirdropLabel = statuswindow:Label("Airdrop")

    uiwindow:Box("Whitelist player", function(callback)
        for i,v in next, players:GetPlayers() do
            if string.find(string.lower(v.Name), string.lower(tostring(callback))) and not table.find(whitelists, v.Name) then
                client.Notify({Text="Added to whitelist"})
                table.insert(whitelists, v.Name)
            end
        end
    end)
    uiwindow:Box("Unwhitelist player", function(callback)
        for i,v in next, players:GetPlayers() do
            if string.find(string.lower(v.Name), string.lower(tostring(callback))) and table.find(whitelists, v.Name) then
                client.Notify({Text="Removed from whitelist"})
                table.remove(whitelists, table.find(whitelists,v.Name))
            end
        end
    end)
    local color_picker = uiwindow:ColorPicker(function(color)
        ui_options.main_color = color
    end)
    color_picker:Set(ui_options.main_color)
    local blat = uiwindow:Toggle("Rainbow UI", function(callback)
        toggl.rainbowui = callback
        local function randomcolor(x) 
            return math.acos(math.cos(x*math.pi))/math.pi 
        end
        local counter = 0
        spawn(function()
            while toggl.rainbowui == true do
                wait(0.1)
                counter = counter + 0.01
                color_picker:Set(Color3.fromHSV(randomcolor(counter),1,1))
            end
        end)
    end)
    uiwindow:Bind("Toggle GUI key", function(callback)
        ui_options.toggle_key = callback
        toggl.key_ui = callback
    end, {
        ["standard"] = ui_options.toggle_key
    })
    uiwindow:Button("Copy discord link", function()
        client.Notify({Text="copied discord link to clipboard"})
        setclipboard("https://discord.gg/RCghreHSaa")
    end)
    uiwindow:Label("\n\nCredits:\nScripting: alex9#9999\nBasic stuff: stefan#9999")

    local notifications = (function()
        local BankSign = workspace.Banks:FindFirstChildOfClass("Model").Extra.Sign.Decal
        local JewelrySign = workspace.Jewelrys:FindFirstChildOfClass("Model").Extra.Sign.Decal
        local MuseumHole = workspace.Museum.Roof.Hole.Part
        BankSign:GetPropertyChangedSignal("Transparency"):connect(function()
            if BankSign.Transparency ~= 0 then
                if toggl.notify == true then
                    client.Notify({Text = "Bank is open"})
                end
            end
        end)
        JewelrySign:GetPropertyChangedSignal("Transparency"):connect(function()
            if JewelrySign.Transparency ~= 0 then
                if toggl.notify == true then
                    client.Notify({Text = "Jewelry is open"})
                end
            end
        end)
        MuseumHole:GetPropertyChangedSignal("Transparency"):connect(function()
            if MuseumHole.Transparency ~= 0 then
                if toggl.notify == true then
                    client.Notify({Text = "Museum is open"})
                end
            end
        end)
        
        workspace.ChildAdded:connect(function(name)
            if toggl.notify == true then
                if name.Name == "Plane" then
                    client.Notify({Text = "Plane is on the map"})
                end
                if name.Name == "CargoShip" then
                    client.Notify({Text = "Ship is on the map"})    
                end
                if name.Name == "Drop" then
                    client.Notify({Text = "Airdrop is on the map"})
                end
            end
        end)
        workspace.Trains.ChildAdded:connect(function(abc)
            if abc.Name == "SteamEngine" then
                if toggl.notify == true then
                    client.Notify({Text = "Passenger Train is on the map"})
                end
            end
            if abc.Name == "LocomotiveFront" then
                if toggl.notify == true then
                    client.Notify({Text = "Cargo Train is on the map"})
                end
            end
        end)
        workspace.PowerPlant.Piston.Piston.ChildAdded:connect(function(children)
            if children:FindFirstChildOfClass("TouchTransmitter") ~= nil then
                if toggl.notify == true then
                    client.Notify({Text = "Powerplant is open"})
                end
            end
        end)
    end)()
    spawn(function()
        while wait(0.5) do
            if workspace.Banks:FindFirstChildOfClass("Model").Extra.Sign.Decal.Transparency == 0 then
                BankLabel:SetColor(Color3.fromRGB(255,0,0))
            else
                BankLabel:SetColor(Color3.fromRGB(0,255,0))
            end
            if workspace.Jewelrys:FindFirstChildOfClass("Model").Extra.Sign.Decal.Transparency == 0 then
                JewelryLabel:SetColor(Color3.fromRGB(255,0,0))
            else
                JewelryLabel:SetColor(Color3.fromRGB(0,255,0))
            end
            for i,v in next, workspace.Museum.Roof.Hole:GetChildren() do
                if v:FindFirstChildOfClass("Texture") then
                    if v.Transparency == 0 then
                        MuseumLabel:SetColor(Color3.fromRGB(255,0,0))
                    else
                        MuseumLabel:SetColor(Color3.fromRGB(0,255,0))
                    end
                end
            end
            if not workspace:FindFirstChild("Plane") then
                PlaneLabel:SetColor(Color3.fromRGB(255, 0, 0))
            else
                PlaneLabel:SetColor(Color3.fromRGB(0, 255, 0))
            end
            if #workspace.Trains:GetChildren() == 0 then
                TrainLabel:SetColor(Color3.fromRGB(255, 0, 0))
            else
                TrainLabel:SetColor(Color3.fromRGB(0, 255, 0))
            end
            if not workspace:FindFirstChild("CargoShip") then
                ShipLabel:SetColor(Color3.fromRGB(255, 0, 0))
            else
                ShipLabel:SetColor(Color3.fromRGB(0, 255, 0))
            end
            if not workspace:FindFirstChild("Drop") then
                AirdropLabel:SetColor(Color3.fromRGB(255, 0, 0))
            else
                AirdropLabel:SetColor(Color3.fromRGB(0, 255, 0))
            end
            if workspace.PowerPlant.Piston.Piston:FindFirstChildOfClass("TouchTransmitter") ~= nil then
                PowerplantLabel:SetColor(Color3.fromRGB(255,0,0))
            else
                PowerplantLabel:SetColor(Color3.fromRGB(0,255,0))
            end
        end
    end)
    spawn(function()
        spawn(function()
            while runss.Stepped:Wait() do
                if toggl.doors == true then
                    wait(1)
                    for i,v in next, doors do
                        client.opendoors(v)
                    end
                end
                if toggl.liftgate == true then
                    client.LiftGate:Callback(true)
                end
                if toggl.explodewall == true then
                    client.ExplodeWall:Callback(true)
                end
                if toggl.sewerhatch == true then
                    client.SewerHatch:Callback(true)
                end
                if toggl.carlights == true then
                    setupvalue(client.AutoDrive,3,true)
                    wait()
                    setupvalue(client.AutoDrive,3,false)
                end
                if toggl.annoyserver == true then
                    client.PlaySounds("FireworkBang", {
                        Source = workspace,
                        Volume = math.huge,
                        Multi = true
                    }, false)
                    client.PlaySounds("Horn", {
                        Source = workspace,
                        Pitch = math.huge,
                        Volume = math.huge,
                        Multi = true,
                        MaxTime = 0.1
                    }, false)
                end
            end
        end)
        UIS.JumpRequest:connect(function()
            if toggl.infjump == true and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState("Jumping")
            end
        end)
        runss.Stepped:connect(function()
            if toggl.noclip == true and isTeleporting ~= true then
                if player.Character ~= nil then
                    for i,v in next, player.Character:GetChildren() do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
            local ui = require(repl.Module:WaitForChild("UI"))
            if toggl.nowait == true then
                for i,v in next, ui.CircleAction.Specs do
                    if v.Timed == true then	
                        v.Timed = false
                    end
                end
            end
            if toggl.crawling then
                client.crawl = false
            end
            if toggl.floatplayer then
                player.Character.Humanoid:ChangeState(10)
            end
            if toggl.eject_all == true then
                for i,v in next, players:GetPlayers() do
                    if v.Name ~= player.Name and not table.find(whitelists, v.Name) or not table.find(bruhmodeXD, v.Name) then
                        local checkcharacter = v.Character and v.Character:FindFirstChild("InVehicle")
                        if checkcharacter then
                            --if not table.find(bruhmodeXD, v.Name) then
                                if player.Name ~= v.Name then
                                    if not table.find(whitelists, v.Name) then
                                        --[[if not (syn and not OXYGEN_LOADED and not KRNL_LOADED) then
                                            setupvalue(client.Eject,1,network)
                                            setupvalue(client.Eject,2,v.Name)
                                            client.Eject()
                                        else--]]                                            network:FireServer("aa6ebeaf", v.Name)
                                    end
                                end
                            --end
                        end
                    end
                end
            end
            for i,v in next, loop_eject do
                for i2,v2 in next, players:GetPlayers() do
                    if v2.Name == v then
                        if v2.Character and v2.Character:FindFirstChild("InVehicle") then
                            --[[if not (syn and not OXYGEN_LOADED and not KRNL_LOADED) then
                                setupvalue(client.Eject,1,network)
                                setupvalue(client.Eject,2,v.Name)
                                client.Eject()
                            else--]]
                            network:FireServer("aa6ebeaf", v.Name)
                        end
                    end
                end
            end
            local backup = require(repl.Game.Robbery.CargoShip.Turret).Shoot
            require(repl.Game.Robbery.CargoShip.Turret).Shoot = function(...)
                if toggl.disableturrets == true then
                    return wait()
                end
                return backup(...)
            end
            if toggl.antiarrest == true and player.Character:FindFirstChild("Handcuffs") then
      
                player.Character.Humanoid.WalkSpeed = _G.WalkSpeed
                client.Breakout(player)
            end
            if toggl.infnitro == true then
                client.Nitro.Nitro = math.huge
                client.Nitro.NitroLastMax = math.huge
            end
            if toggl.godmode == true and toggl.infdonuts == false or isTeleporting == true then
                local donutz = {Local=true,LastConsumed=0,SpringItemRotation={SetTarget = function() end},Config={Motion={Eat={Springs={ItemRotation={}}},Hip={Springs={ItemRotation = {}}}}},BroadcastInputBegan = function() end}
                local obj = {UserInputType = Enum.UserInputType.MouseButton1}
                donutz.LastConsumed = 0
                client.Donut()
                nigga1(donutz,obj)
            end
            if toggl.infdonuts == true and toggl.godmode == false then
                client.Donut()
            end
            local start_silent = (function()
                local saveUpvalue = getupvalue(bread,2)
                if toggl.killaura == true then
                    v3 = {
                        RayIgnoreNonCollideWithIgnoreList = function(r)
                            function findClosestPlayer()
                                region = {}
                                for i,v in next, players:GetPlayers() do
                                    if v ~= player then
                                        if v.Team ~= player.Team and not table.find(whitelists, v.Name) and not table.find(bruhmodeXD, v.Name) then
                                            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                                                if player.Team ~= v.Team then
                                                    if tostring(v.Team) ~= "Prisoner" then
                                                        table.insert(region, v.Character.HumanoidRootPart)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                local breadposaway = 1000000000
                                for i,v in next, region do
                                    if (v.Position - player.Character.HumanoidRootPart.Position).Magnitude < breadposaway then
                                        breadposaway = (v.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                        currentreg = v    
                                    end
                                end
                                return currentreg
                            end
                            return findClosestPlayer(), findClosestPlayer().Position
                        end
                    }
                    setupvalue(bread,2,v3)
                elseif toggl.killaura == false then
                    setupvalue(bread,2,saveUpvalue)
                end
            end)()
            local ol;
            ol = hookfunction(require(repl.Module.AlexRagdoll).Ragdoll, function(...) -- useless
                if toggl.antiragdoll then
                    return 9e9
                end
                return ol(...)
            end)
            if toggl.killaura == true then
                for i,v in next, player.PlayerGui.HotbarGui.Container:GetChildren() do
                    if v:IsA("ImageButton") and v.Icon.Image == "rbxassetid://4751591788" then
                        for i2,v2 in next, players:GetPlayers() do
                            local check1 = v2.Character and v2.Character:FindFirstChild("HumanoidRootPart")
                            local check2 = v2.Character and v2.Character:FindFirstChild("Humanoid")
                            if v2.Name ~= player.Name and check2 and check2.Health > 0 and tostring(v2.Team) ~= player.Team and tostring(v2.Team) ~= "Prisoner" and check1 and (player.Character.HumanoidRootPart.Position - check1.Position).magnitude < 200 then         
                                if not table.find(whitelists, v2.Name) and not table.find(bruhmodeXD, v2.Name) then 
                                    local niggers = {Tip={Position=player.Character.HumanoidRootPart.Position},SpringItemRotation={Accelerate=function() end},SpringItemOffset={Accelerate=function() end},MousePosition=player.Character.HumanoidRootPart.Position,Config={Range=200,bullet_impact_base=nil},IgnoreList={[1]=player.Name,[3]="Items"},Local = true}
                                    bread(niggers)
                                end
                            end
                        end
                    end
                end
                wait()
            end
            if toggl.tirepop == true then
                if client.gv() then
                    client.gv().TirePopDuration = 0
                end
            end
            if toggl.alwaysdrift == true then
                setupvalue(client.AutoDrive,1,true)
            elseif toggl.alwaysdrift == false then
                setupvalue(client.AutoDrive,1,false)
            end
        end)
        mouse.Button1Down:connect(function()
            if toggl.ctrldestroy == true and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                mouse.Target:Destroy()
            end
            if toggl.clicknuke == true then
                local nukzz = {Nuke={Speed=650,Duration=10,Target=mouse.Hit.p,Origin=Vector3.new(),TimeDilation=1.5},Shockwave={MaxRadius=1000,Duration=10}}
                client.Nuke(nukzz)
            end
        end)
    end)

    playerwindow:Show()
    library:FormatWindows()
    library:Ready()
    client.Notify({Text="Thanks for using ice tray gui"})
end
