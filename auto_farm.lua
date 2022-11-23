local runservice, plrs, replicated = game:GetService('RunService'), game:GetService('Players'), game:GetService('ReplicatedStorage');
local plr, camera = plrs.LocalPlayer, workspace.CurrentCamera;
local cashiers, drops = workspace.Cashiers, workspace.Ignored.Drop

local utils = {}; do 
    function utils.validate_hp(register)
        local humanoid = register:FindFirstChildOfClass('Humanoid')
        if humanoid then 
            if humanoid.Health > 0 then 
                return true
            end
        end
    end;

    function utils.teleport_register(register)
        if register and register:FindFirstChild('Head') and utils.validate_hp(register) then 
            plr.Character.HumanoidRootPart.CFrame = (register.Open.CFrame * CFrame.new(0,0,2))
        end
    end;
end;

while true do wait()
    for i, register in next, cashiers:GetChildren() do 
        if utils.validate_hp(register) then
            repeat wait() 
            local character = plr.Character or plr.CharacterAdded:Wait()
            local root = character:WaitForChild('HumanoidRootPart')
            local fists = plr.Backpack:FindFirstChild('Combat') or character:FindFirstChild('Combat')
            if not fists then 
                character.Humanoid.Health = 0
                return
            end
            
            utils.teleport_register(register)
            if fists.Parent ~= character then 
                fists.Parent = character 
            end 
            fists:Activate() 
            until not register  or register.Humanoid.Health <= 0
            for i,v in next, drops:GetDescendants() do 
                if v:IsA('ClickDetector') and v.Parent and v.Parent.Name:find('Money') then
                    local character = plr.Character or plr.CharacterAdded:Wait()
                    local root = character:WaitForChild('HumanoidRootPart')
                    if (v.Parent.Position - root.Position).Magnitude <= 18 then 
                        repeat wait() fireclickdetector(v)
                        until not v or not v.Parent
                    end
                end
            end
        end
        wait(1)
    end
end
