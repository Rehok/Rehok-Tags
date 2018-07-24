local E, L, V, P, G = unpack(ElvUI)
local rTag = E:NewModule("rTags");
local _G = _G

-- For rememberence sake you can /dump rStringTable
rStringTable = {
	"health:current-percent-r",
	"health:current-r",
	"health:percent-r",
	"power:current:percent-r",
	"power:current-r",
	"power:percent-r",
	"name:short-r",
}
function rTag:NewTags()

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
_G["ElvUF"].Tags.Events['health:current-percent-r'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
_G["ElvUF"].Tags.Methods['health:current-percent-r'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
		if (status) then
			return status
		else
	local CurrentHealth = UnitHealth(unit)
	local CurrentPercent = (UnitHealth(unit)/UnitHealthMax(unit))*100
	if CurrentPercent > 1 then
		return shortenNumber(CurrentHealth) .. " | " .. Round(CurrentPercent)
	else
		return shortenNumber(CurrentHealth) .. " | " .. format("%.1f", CurrentPercent)
	end
	end
end

-- Displays current HP --(2.04B, 2.04M, 204k, 204)--
_G["ElvUF"].Tags.Events['health:current-r'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
_G["ElvUF"].Tags.Methods['health:current-r'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
		if (status) then
		      	return status
		else
	local CurrentHealth = UnitHealth(unit)
		return shortenNumber(CurrentHealth)
	end
end


-- Displays Percent only --(intended for boss frames)--
_G["ElvUF"].Tags.Events['health:percent-r'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
_G["ElvUF"].Tags.Methods['health:percent-r'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	if (status) then
		return status
	else
	local CurrentPercent = (UnitHealth(unit)/UnitHealthMax(unit))*100
		if CurrentPercent > 1 then
			return Round(CurrentPercent)
		else
			return format("%.1f", CurrentPercent)
		end
	end
end


 -- Displays CurrenPower | Percent --(2.04B | 100)--
_G["ElvUF"].Tags.Events['power:current-percent-r'] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT"
_G["ElvUF"].Tags.Methods['power:current-percent-r'] = function(unit)
	local CurrentPower = UnitPower(unit)
	local CurrentPercent = (UnitPower(unit)/UnitPowerMax(unit))*100
  local PowerMax = UnitPowerMax(unit)
			if CurrentPercent > 1 and  PowerMax > 0 then
		return shortenNumber(CurrentPower) .. " | " .. Round(CurrentPercent)
	else
		return shortenNumber(CurrentPower) .. " | " .. Round(CurrentPercent)
	end
end

-- Displays current power --(2.04B, 2.04M, 204k, 204, 0)--
_G["ElvUF"].Tags.Events['power:current-r'] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT"
_G["ElvUF"].Tags.Methods['power:current-r'] = function(unit)
	local CurrentPower = UnitPower(unit)
	if CurrentPower > 0 then -- Some mobs have -1 as power, Don"t show if they have this
		return shortenNumber(CurrentPower)
	else
		return ""
  end
end


 -- Displays Power Percent
_G["ElvUF"].Tags.Events['power:percent-r'] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT"
_G["ElvUF"].Tags.Methods['power:percent-r'] = function(unit)
local CurrentPercent = (UnitPower(unit)/UnitPowerMax(unit))*100
local PowerMax = UnitPowerMax(unit)
  if PowerMax > 0 then
	return Round(CurrentPercent)
  end
end


 -- Displays long names better --(First Name Second Name Last Name = F.S Last Name)--
_G["ElvUF"].Tags.Methods['name:short-r'] = function(unit)
	local name = UnitName(unit)
		name = name:gsub("(%S+) ",function(t) return t:sub(1,1).."." end)
    	return name
	end
end


function rTag:Initialize()
	print("|cFFFF00E0 rTags|r have Initialized. Thank you for using my addon :)")
	rTag:NewTags()
end

E:RegisterModule(rTag:GetName())
