if game.placeId == 89543921138202 then
local RunService = game:GetService("RunService")
pcall(function()
RunService:Set3dRenderingEnabled(false)
end)

local platform = Instance.new("Part")
platform.Anchored = true
platform.Size = Vector3.new(500,2,500)
platform.CFrame = CFrame.new(0,-20,0)
for _, e in pairs(workspace.Map.Zones.Field.Guards:GetChildren()) do e:Destroy() end

while true do
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart", 5)
if not hrp then
task.wait(1)
continue
end

local npcFolder = Workspace:FindFirstChild("Map")
and Workspace.Map:FindFirstChild("Zones")
and Workspace.Map.Zones:FindFirstChild("Field")
and Workspace.Map.Zones.Field:FindFirstChild("NPC")

if not npcFolder then
task.wait(2)
continue
end

local function firePrompt(prompt)
if typeof(fireproximityprompt) == "function" then
fireproximityprompt(prompt)
else
prompt:InputHoldBegin()
task.wait(prompt.HoldDuration)
prompt:InputHoldEnd()
end
end

local foundAny = false

for _, model in ipairs(npcFolder:GetChildren()) do
if model:IsA("Model") then
local promptsFolder = model:FindFirstChild("Prompts")
if promptsFolder me then
local pickupPrompt = promptsFolder:FindFirstChild("Pickup")
if pickupPrompt and pickupPrompt:IsA("ProximityPrompt") then
local rarityText = nil
pcall(function()
rarityText = model.OverheadAttachment.CharacterInfo.Frame.Rarity.Text
end)


if rarityText and rarityText ~= "Common" and rarityText ~= "Uncommon" and rarityText ~= "Rare" then
foundAny = true

pickupPrompt.HoldDuration = 0
pickupPrompt.MaxActivationDistance = 100

local targetPart = (pickupPrompt.Parent:IsA("BasePart") and pickupPrompt.Parent)
or model.PrimaryPart

if targetPart and hrp then
hrp.CFrame = targetPart.CFrame * CFrame.new(0, -5, 0)
task.wait(0.1)

for i = 1, 5 do
firePrompt(pickupPrompt)
task.wait()
end

task.wait()
hrp.CFrame = CFrame.new(-64, 1034, 4)
task.wait()
end
end
end
end
end
end

if not foundAny then
local placeId = game.PlaceId
local currentJobId = game.JobId

print("No qualifying NPCs found — waiting before searching for a new server...")
task.wait(1.5) 

local url = string.format(
"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
placeId
)

local success, result = pcall(function()
return HttpService:JSONDecode(game:HttpGet(url))
end)

if success and result and result.data then
local targetServer = nil
for _, server in ipairs(result.data) do
if server.id ~= currentJobId and server.playing < server.maxPlayers then
targetServer = server.id
break
end
end

if targetServer then
print("New server found! Teleporting...")
task.wait(0.5)
pcall(function()
TeleportService:TeleportToPlaceInstance(placeId, targetServer, player)
end)
task.wait(5)
else
warn("No alternative servers available. Retrying in 3 seconds...")
task.wait(3)
end
else
warn("Failed to fetch server list:", result)
task.wait(3)
end
end

task.wait(0.1)
end
end

