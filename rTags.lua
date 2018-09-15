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

local exemptPowerType = {

}
function rTag:NewTags()

-------------------------------
-- Orignal Code by Hamsda    --
-- https://wago.io/NJKRRlT9W --
-------------------------------

local shortenNumber = function(number, significant)
    if type(number) ~= "number" then
        number = tonumber(number)
    end
    if not number then
        return
    end
    
    if type(significant) ~= "number" then
        significant = tonumber(significant)
    end
    significant = significant or 3
    
    local affixes = {
        "k",
        "m",
        "b",
        "t",
    }
    affixes[0] = ""
    
    local log, floor, max, abs = math.log, math.floor, math.max, math.abs
    
    local powerTen = floor(log(abs(number)) / log(10)) --get the log base 10
    powerTen = powerTen < 0 and 0 or powerTen --catch negative powers for numbers with an absolute value below 1
    local affix = floor(powerTen / 3) --every third power of ten (so thousands) results in a new affix
    local divNum = number / 1000^affix --get the "new" number by division with the floored amounts
    local before = powerTen%3 + 1 --determine how many digits before the .
    local after = max(0, significant - before) --and how many digits after
    
    return string.format(string.format("%%.%df%s", after, affixes[affix]), divNum)
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
		return shortenNumber(CurrentHealth, 2) .. " | " .. Round(CurrentPercent)
	else
		return shortenNumber(CurrentHealth, 2) .. " | " .. format("%.1f", CurrentPercent)
	end
	end
end

-- Displays CurrentHP - Percent --(2.04B - 100), This is so i don't need 2 tags and display dead - dead --
_G["ElvUF"].Tags.Events['health:current-percent-rClean'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
_G["ElvUF"].Tags.Methods['health:current-percent-rClean'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
		if (status) then
			return status
		else
	local CurrentHealth = UnitHealth(unit)
	local CurrentPercent = (UnitHealth(unit)/UnitHealthMax(unit))*100
	if CurrentPercent <= 99.99 then
		return shortenNumber(CurrentHealth, 2) .. " - " .. Round(CurrentPercent)
	else
		return shortenNumber(CurrentHealth, 2)
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
		return shortenNumber(CurrentHealth, 2)
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
			return Round(CurrentPercent)
		
	end
end


 -- Displays CurrentPower | Percent --(2.04B | 100)--
_G["ElvUF"].Tags.Events['power:current-percent-r'] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT"
_G["ElvUF"].Tags.Methods['power:current-percent-r'] = function(unit)
	local CurrentPower = UnitPower(unit)
	local CurrentPercent = (UnitPower(unit)/UnitPowerMax(unit))*100
 	local PowerMax = UnitPowerMax(unit)
			if CurrentPercent > 1 and  PowerMax > 0 then
		return shortenNumber(CurrentPower, 0) .. " | " .. Round(CurrentPercent)
	else
		return shortenNumber(CurrentPower, 0) .. " | " .. Round(CurrentPercent)
	end
end

-- Displays current power --(2b, 2m, 204k, 204, `0)--
_G["ElvUF"].Tags.Events['power:current-r'] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT"
_G["ElvUF"].Tags.Methods['power:current-r'] = function(unit)
	local CurrentPower = UnitPower(unit)
	if CurrentPower > 0 then -- Some mobs have -1 as power, Don"t show if they have this
		return shortenNumber(CurrentPower, 0)
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


-- Displays name to 10 chars (Requested by Urthearso <3)
_G["ElvUF"].Tags.Methods['name:veryshort-r'] = function(unit)
	local name = UnitName(unit)
		name = name:gsub("(%S+) ",function(t) return t:sub(1,1).."." end)
    	return string.sub(name, 1, 10)
	end
end

-- Displays Percent only (Requested by Ither)
_G["ElvUF"].Tags.Events['health:percent-ither'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
_G["ElvUF"].Tags.Methods['health:percent-ither'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	if (status) then
		return status
	else
	local CurrentPercent = (UnitHealth(unit)/UnitHealthMax(unit))*100
		if CurrentPercent <= 99.99 then
			return Round(CurrentPercent)
		end
	end
end

function rTag:Initialize()
	print("|cFFFF00E0 rTags|r have Initialized. Thank you for using my addon :)")
	rTag:NewTags()
end

E:RegisterModule(rTag:GetName())
