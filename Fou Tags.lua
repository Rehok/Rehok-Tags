local E, L, V, P, G = unpack(ElvUI)
local FT = E:NewModule('Fou Tags');
local _G = _G


function FT:NewTags() 

-------------------------------
-- Orignal Code by Hamsda    --
-- https://wago.io/NJKRRlT9W --
-------------------------------

local shortenNumber = function(number)
    if type(number) ~= "number" then
        number = tonumber(number)
    end
    if not number then
        return
    end
    
    local affixes = {
        "",
        "k",
        "m",
        "B",
    }
    
    local affix = 1
    local dec = 0
    local num1 = math.abs(number)
    while num1 >= 1000 and affix < #affixes do
        num1 = num1 / 1000
        affix = affix + 1
    end
    if affix > 1 then
        dec = 2
        local num2 = num1
        while num2 >= 10 do
            num2 = num2 / 10
            dec = dec - 1
        end
    end
    if number < 0 then
        num1 = -num1
    end
    
    return string.format("%."..dec.."f"..affixes[affix], num1)
end
	
-- Displays CurrentHP | Percent --(2.04B | 100)--
_G["ElvUF"].Tags.Events['health:current-percent-fou'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:current-percent-fou'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
		if (status) then
			return status
		else
	local CurrentHealth = UnitHealth(unit)
	local CurrentPercent = (UnitHealth(unit)/UnitHealthMax(unit))*100
	if CurrentPercent > 1 then
		return shortenNumber(CurrentHealth) .. " | " .. format("%.0f", CurrentPercent)
	else
		return shortenNumber(CurrentHealth) .. " | " .. format("%.1f", CurrentPercent)
	end
	end
end
	
-- Displays current HP --(2.04B, 2.04M, 204k, 204)--
_G["ElvUF"].Tags.Events['health:current-fou'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:current-fou'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
		if (status) then
		      	return status
		else
	local CurrentHealth = UnitHealth(unit)
		return shortenNumber(CurrentHealth)
	end
end


-- Displays Percent only --(intended for boss frames)--
_G["ElvUF"].Tags.Events['health:percent-fou'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:percent-fou'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	if (status) then
		return status
	else
	local CurrentPercent = (UnitHealth(unit)/UnitHealthMax(unit))*100
		if CurrentPercent > 1 then
			return format("%.0f", CurrentPercent)
		else
			return format("%.1f", CurrentPercent)
		end
	end
end



-- Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag
_G["ElvUF"].Tags.Events['power:current-fou'] = 'UNIT_POWER UNIT_POWER_FREQUENT'
_G["ElvUF"].Tags.Methods['power:current-fou'] = function(unit) 
	local CurrentPower = UnitPower(unit)
	return shortenNumber(CurrentPower)
end
	
 -- Displays CurrenPower | Percent --(2.04B | 100)--
_G["ElvUF"].Tags.Events['power:current:percent-fou'] = 'UNIT_POWER UNIT_POWER_FREQUENT'
_G["ElvUF"].Tags.Methods['power:current:percent-fou'] = function(unit) 
	local CurrentPower = UnitPower(unit)
	local CurrentPercent = (UnitPower(unit)/UnitPowerMax(unit))*100
			if CurrentPercent > 1 then
		return shortenNumber(CurrentPower) .. " | " .. format("%.0f", CurrentPercent)
	else
		return shortenNumber(CurrentPower) .. " | " .. format("%.1f", CurrentPercent)
	end
end

-- Displays current power --(2.04B, 2.04M, 204k, 204, 0)--
_G["ElvUF"].Tags.Events['power:current-fou'] = 'UNIT_POWER UNIT_POWER_FREQUENT'
_G["ElvUF"].Tags.Methods['power:current-fou'] = function(unit) 
	local CurrentPower = UnitPower(unit)
	if CurrenPower > 0 then
		return shortenNumber(CurrentPower)
	else 
		return ""
end

	
 -- Displays Power Percent
_G["ElvUF"].Tags.Events['power:percent-fou'] = 'UNIT_POWER UNIT_POWER_FREQUENT'
_G["ElvUF"].Tags.Methods['power:percent-fou'] = function(unit) 
local CurrentPercent = (UnitPower(unit)/UnitPowerMax(unit))*100
	return format("%.0f",CurrentPercent)
end


 -- Displays long names better --(First Name Second Name Last Name = F.S Last Name)--
_G["ElvUF"].Tags.Methods['name:short-fou'] = function(unit) 
	local name = UnitName(unit)
		name = name:gsub('(%S+) ',function(t) return t:sub(1,1)..'.' end)
    	return name
	end
end


function FT:Initialize()
	print("|cA708D2ff Fou Tags|r have Initialized. Thank you for using my addon :)")
	FT:NewTags()
end

E:RegisterModule(FT:GetName())