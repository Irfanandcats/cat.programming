-- * \ Ir's Pivot Mover \ *

--[[

COMMANDS:

.hook <username> : Starts hooking your character onto them.
.stopHook : Stops hooking your character.
.anchor : Slows down the hooked character. ( If using humanoid )
.unanchor : Unanchors your character.

NOTE:

You cannot hook more than one player at a time.
Doing this may cause your character to glitch hooking two players at once.

]]

-- Created by TheRealDeal_CatsWhew

-- services

local players = game:GetService("Players")

-- player

local plr = players.LocalPlayer

--

print("\10\42\32\32\92\92\32\73\114\39\115\32\80\105\118\111\116\32\77\111\118\101\114\32\92\92\32\42\10\10\84\104\97\110\107\115\32\102\111\114\32\117\115\105\110\103\32\116\104\105\115\33\10\73\32\97\112\112\114\101\99\105\97\116\101\32\121\111\117\114\32\115\117\112\112\111\114\116\44\32\112\108\101\97\115\101\32\117\115\101\32\116\104\105\115\32\119\105\116\104\32\99\97\114\101\33\10")

local playerHook, selected
local anchorHooks = {}

plr.Chatted:Connect(function(message)
	if message:match("^%.", 1) then
		local arguments = {}

		message = message:gsub("%.", "")

		for argument in (tostring(message) or ""):gmatch("%S+") do
			table.insert(arguments, argument)
		end

		if arguments[1] == "hook" then
			if typeof(arguments[2]) == "string" then
				local player = players:FindFirstChild(tostring(arguments[2]) or "")

				if typeof(player) == "Instance" and player:IsA("Player") then
					if not (playerHook and selected) then
						selected = player

						playerHook = player.CharacterAdded:Connect(function(char)
							while char do
								if not char then
									break
								end

								if typeof(plr.Character) == "Instance" then
									plr.Character:PivotTo(char:GetPivot())
								end

								game:GetService("RunService").RenderStepped:Wait()

								continue;
							end
						end)
					end
				end
			end
		elseif arguments[1] == "stopHook" then
			if typeof(playerHook) == "RBXScriptConnection" then
				playerHook:Disconnect()
			end
		elseif arguments[1] == "anchor" then
			if typeof(playerHook) == "RBXScriptConnection" then
				selected.CharacterAdded:Connect(function(char)
					local function add(target)
						for i = 1, 300 do
							if not plr.Character or typeof(playerHook) ~= "RBXScriptConnection" then
								table.clear(anchorHooks)
								break;
							end

							local newMotor6D = Instance.new("Motor6D")

							if typeof(target) == "Instance" and target:IsA("Model") then
								local hrp = target:FindFirstChild("HumanoidRootPart")

								if hrp then
									newMotor6D.Part1 = hrp
								end
							end

							local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

							if typeof(hrp) == "Instance" and hrp:IsA("BasePart") then
								newMotor6D.Part0, newMotor6D.Parent = hrp, hrp
							end

							if not table.find(anchorHooks, newMotor6D) then
								table.insert(anchorHooks, newMotor6D)
							end

							game:GetService("RunService").RenderStepped:Wait()
						end
					end

					add(char)
				end)
			end
		elseif arguments[1] == "unanchor" then
			for i = 1, 300 do
				if not plr.Character then
					break;
				end

				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

				if typeof(hrp) == "Instance" and hrp:IsA("BasePart") then
					local motor6d = hrp:FindFirstChildWhichIsA("Motor6D")

					if typeof(motor6d) == "Instance" and table.find(anchorHooks, motor6d) then
						motor6d:Destroy()
					end
				end

				continue;
			end
		end

		table.clear(arguments)
	end
end)
