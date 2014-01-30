--[[--------------------------------------------------------------------
	PhanxTooltip
	Simple tooltip modifications.
	Copyright (c) 2011-2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying LICENSE file for more information.
	http://www.wowinterface.com/downloads/info22654-PhanxTooltip.html
	http://wow.curseforge.com/addons/phanxtooltip/
	http://www.curse.com/addons/wow/phanxtooltip
----------------------------------------------------------------------]]

local STATUSBAR = oUFPhanxConfig and oUFPhanxConfig.statusbar or "Interface\\AddOns\\PhanxMedia\\statusbar\\Stone"

------------------------------------------------------------------------

local _, L = ...

local REALM_LABELS = {
	[LE_REALM_RELATION_COALESCED] = FOREIGN_SERVER_LABEL, -- (*) temporarily coaleasced (CRZ)
	--[LE_REALM_RELATION_VIRTUAL] = INTERACTIVE_SERVER_LABEL, -- (#) permanently connected
}

local CORPSE_TOOLTIP = "^" .. gsub(CORPSE_TOOLTIP, "%%s", "(.+)") .. "$"
local PVP_ENABLED = PVP_ENABLED
local SAME_FACTION = UnitFactionGroup("player")
local WILDBATTLEPET_TOOLTIP = "^" .. gsub(TOOLTIP_WILDBATTLEPET_LEVEL_CLASS, "%%s", ".+")

COALESCED_REALM_TOOLTIP = "" -- fuck off

------------------------------------------------------------------------
--	Modify default position

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	self:SetOwner(parent, "ANCHOR_NONE")
	self:ClearAllPoints()
	self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -30, 65)
end)

------------------------------------------------------------------------
--	Modify default colors

TOOLTIP_DEFAULT_COLOR.r = 0.8
TOOLTIP_DEFAULT_COLOR.g = 0.8
TOOLTIP_DEFAULT_COLOR.b = 0.8

TOOLTIP_DEFAULT_BACKGROUND_COLOR.r = 0
TOOLTIP_DEFAULT_BACKGROUND_COLOR.g = 0
TOOLTIP_DEFAULT_BACKGROUND_COLOR.b = 0

do
	local backdrop = GameTooltip:GetBackdrop()
	if backdrop.insets.left == 5 then
		backdrop.insets.left = 3
		backdrop.insets.right = 3
		backdrop.insets.top = 3
		backdrop.insets.bottom = 3
	end
	for _, tooltip in pairs({ GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, EventTraceTooltip, FrameStackTooltip }) do
		tooltip:SetBackdrop(backdrop)
		tooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
		tooltip:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	end
end

------------------------------------------------------------------------
--	Unit colors

local classrgb, classhex = { }, { }

local levelhex = setmetatable({ }, { __index = function(levelhex, level)
	if type(level) ~= "number" then level = UnitLevel("player") end
	local color = GetQuestDifficultyColor(level)
	local hex = format("|cff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
	levelhex[level] = hex
	return hex
end })

local classification = {
	elite = " |cffffcc00" .. L["Elite"] .. "|r",
	rare  = " |cff999999" .. L["Rare"] .. "|r",
	rareelite = " |cff999999" .. L["Rare"] .. "|r |cffffcc00" .. L["Elite"] .. "|r",
	worldboss = " |cffff6666" .. L["Boss"] .. "|r",
}

local unitrgb = {
	    [1] = { 1,   0.2, 0.2 }, -- Hated
	    [2] = { 1,   0.2, 0.2 }, -- Hostile
	    [3] = { 1,   0.6, 0.2 }, -- Unfriendly
	    [4] = { 1,   1,   0.2 }, -- Neutral
	    [5] = { 0.2, 1,   0.2 }, -- Friendly
	    [6] = { 0.2, 1,   0.2 }, -- Honored
	    [7] = { 0.2, 1,   0.2 }, -- Revered
	    [8] = { 0.2, 1,   0.2 }, -- Exalted
	   dead = { 0.6, 0.6, 0.6 },
	offline = { 0.4, 0.4, 0.4 },
	 tapped = { 0.6, 0.6, 0.6 },
}

local unithex = { }
for k, v in pairs(unitrgb) do
	unithex[k] = format("|cff%02x%02x%02x", v[1] * 255, v[2] * 255, v[3] * 255)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LEVEL_UP")
f:SetScript("OnEvent", function(f, event)
	if event == "PLAYER_LOGIN" then
		for k, v in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
			classrgb[k] = { v.r, v.g, v.b }
			classhex[k] = format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
		end
		if CUSTOM_CLASS_COLORS then
			CUSTOM_CLASS_COLORS:RegisterCallback(function()
				for k, v in pairs(CUSTOM_CLASS_COLORS) do
					classrgb[k][1] = v.r
					classrgb[k][2] = v.g
					classrgb[k][3] = v.b
					classhex[k] = format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
				end
			end)
		end
	else
		wipe(levelhex)
	end
end)

------------------------------------------------------------------------
--	Faster access to fontstrings

local left = setmetatable({ }, { __index = function(left, i)
	local line = _G["GameTooltipTextLeft" .. i]
	if line then rawset(left, i, line) end
	return line
end })

local right = setmetatable({ }, { __index = function(right, i)
	local line = _G["GameTooltipTextRight" .. i]
	if line then rawset(right, i, line) end
	return line
end })

------------------------------------------------------------------------
--	Move GameTooltip status bar

do
	local bar = GameTooltipStatusBar
	bar:ClearAllPoints()
	bar:SetPoint("BOTTOMLEFT", 10, 10)
	bar:SetPoint("BOTTOMRIGHT", -10, 10)
	bar:SetHeight(6)

	local addon = strmatch(STATUSBAR, "Interface\\AddOns\\(.-)\\")
	if not addon or select(6, GetAddOnInfo(addon)) ~= "MISSING" then
		bar:SetStatusBarTexture(STATUSBAR)
	end

	GameTooltip.statusBar = bar
end

------------------------------------------------------------------------
--	Add raid target icon to GameTooltip

do
	local icon = GameTooltip:CreateTexture(nil, "OVERLAY")
	icon:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT", -3, -3)
	icon:SetWidth(36)
	icon:SetHeight(36)
	icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	icon:Hide()

	GameTooltip.raidTargetIcon = icon
end

------------------------------------------------------------------------
--	General

hooksecurefunc(GameTooltip, "Show", function(self)
	self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
	if not self:GetItem() and not self:GetUnit() then
		self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	end
	if self.addHeight then
		self.newHeight = self:GetHeight() + self.addHeight
	end
end)

GameTooltip:HookScript("OnHide", function(self)
	self.raidTargetIcon:SetTexture(nil)
	self.raidTargetIcon:Hide()
end)

GameTooltip:HookScript("OnUpdate", function(self, elapsed)
	if not self.currentItem and not self.currentUnit then
		self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
		self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	end

	if self.currentUnit and not UnitExists(self.currentUnit) then
		self:Hide()
	end

	if self.newHeight and abs(self:GetHeight() - self.newHeight) > 0.1 then
		self:SetHeight(self.newHeight)
	end
end)

GameTooltip:HookScript("OnTooltipCleared", function(self)
	self.addHeight, self.newHeight = nil, nil
	self.currentItem, self.currentUnit = nil, nil
end)

------------------------------------------------------------------------
--	Disable fade-out effect

GameTooltip.FadeOut = function(self)
	self:Hide()
end

local f = CreateFrame("Frame")
f:RegisterEvent("CURSOR_UPDATE")
f:SetScript("OnEvent", function()
	if not GameTooltip.currentUnit and GameTooltip:IsShown() and GameTooltip:IsOwned(UIParent) then
		local text = GameTooltipTextLeft1:GetText()
		GameTooltip:Hide()
		GameTooltipTextLeft1:SetText(text)
	end
end)

------------------------------------------------------------------------
--	Units

local playerRealm, playerFaction, playerGuild, playerLevel

GameTooltip:HookScript("OnTooltipSetUnit", function(GameTooltip)
	if not playerRealm then playerRealm = GetRealmName() end
	if not playerFaction then playerFaction = UnitFactionGroup("player") end
	if not playerGuild then playerGuild = GetGuildInfo("player") end
	if not playerLevel then playerLevel = UnitLevel("player") end

	if strmatch(left[1]:GetText(), CORPSE_TOOLTIP) then
		local color = unitrgb.dead
		return left[1]:SetTextColor(color[1], color[2], color[3])
	end

	--------------------------------------------------------------------

	local _, unit = GameTooltip:GetUnit()
	if not unit then
		local mouseFocus = GetMouseFocus()
		unit = mouseFocus and mouseFocus:GetAttribute("unit")
	end
	if not unit and UnitExists("mouseover") then
		unit = "mouseover"
	end
	if not unit then
		return GameTooltip:Hide()
	end
	if unit ~= "mouseover" and UnitIsUnit(unit, "mouseover") then
		unit = "mouseover"
	end
	GameTooltip.currentUnit = unit

	--------------------------------------------------------------------
	--	Reformat existing unit lines

	local line = 1

	if UnitIsPlayer(unit) then

		local name, realm = UnitName(unit)
		local realmLabel = REALM_LABELS[UnitRealmRelationship(unit)] or ""
		if name == UNKNOWN then return end
		if realm == "" or realm == playerRealm then realm = nil end

		local afk = UnitIsAFK(unit) and "AFK" or UnitIsDND(unit) and "DND"

		local class, classEN = UnitClass(unit)
		local chex, crgb = classhex[classEN], classrgb[classEN]
		local cr, cg, cb = crgb[1], crgb[2], crgb[3]

		local level, race, faction = UnitLevel(unit), UnitRace(unit), UnitFactionGroup(unit)
		local lhex = UnitCanAttack("player", unit) and levelhex[level] or "|cffffffff"

		local pvp
		if faction == playerFaction then
			pvp = UnitIsPVPFreeForAll(unit)
		else
			pvp = UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit)
		end
		if pvp then
			local c = unitrgb[2]
			GameTooltip:SetBackdropBorderColor(c[1], c[2], c[3])
		else
			GameTooltip:SetBackdropBorderColor(cr, cg, cb)
		end

		-- Name
		if afk and realm then
			left[line]:SetFormattedText("%s%s %s %s%s|r %s<%s>|r", chex, name, L["of"], realm, realmLabel, unithex.tapped, afk)
		elseif realm then
			left[line]:SetFormattedText("%s%s %s %s%s|r", chex, name, L["of"], realm, realmLabel)
		elseif afk then
			left[line]:SetFormattedText("%s%s|r %s<%s>|r", chex, name, unithex.tapped, afk)
		else
			left[line]:SetFormattedText("%s%s|r", chex, name)
		end
		line = line + 1

		-- Guild
		local guild = GetGuildInfo(unit)
		if guild then
			left[line]:SetFormattedText("%s%s|r", guild == playerGuild and "|cffff88ff" or "|cffffffff", guild)
			line = line + 1
		end

		-- Level, class
		if pvp then
			left[line]:SetFormattedText("%s%d|r %s%s %s|r (%s)", lhex, level, chex, race, class, PVP_ENABLED)
		else
			left[line]:SetFormattedText("%s%d|r %s%s %s|r", lhex, level, chex, race, class)
		end
		line = line + 1

	else

		local name = UnitName(unit)

		local attackable = UnitCanAttack("player", unit)
		local dead = UnitIsDead(unit)
		local tapped = UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)

		local isBattlePet = UnitIsBattlePet(unit)
		local level = isBattlePet and UnitBattlePetLevel(unit) or UnitLevel(unit)
		local class = UnitClassification(unit)
		local ctype = UnitCreatureType(unit)
		local btype = isBattlePet and format(" (%s)", _G["BATTLE_PET_NAME_"..UnitBattlePetType(unit)])
		local lhex = attackable and not isBattlePet and (level > 0 and levelhex[level] or levelhex[100]) or "|cffffffff"

		local uhex, ur, ug, ub
		if dead then
			local c = unitrgb.dead
			uhex, ur, ug, ub = unithex.dead, c[1], c[2], c[3]
		elseif tapped then
			local c = unitrgb.tapped
			uhex, ur, ug, ub = unithex.tapped, c[1], c[2], c[3]
		elseif UnitIsEnemy(unit, "player") then
			local c = unitrgb[2]
			uhex, ur, ug, ub = unithex[1], c[1], c[2], c[3]
		else
			local v = UnitReaction(unit, "player") or 5
			local c = unitrgb[v]
			uhex, ur, ug, ub = unithex[v], c[1], c[2], c[3]
		end
		GameTooltip:SetBackdropBorderColor(ur, ug, ub)

		-- Name
		left[line]:SetFormattedText("%s%s|r", uhex, name or UNKNOWN)
		line = line + 1

		-- Info
		local info = left[line]:GetText()
		if not info then
			-- Tooltip only has one line. Probably a world object. Skip everything else.
			return GameTooltip:Show()
		end
		if not strmatch(info, L["Level"]) or (not strmatch(info, "%d") and not strmatch(info, "??")) then
			-- Skip.
			line = line + 1
		end

		-- Level, type
		if not isBattlePet and ctype == L["Non-combat Pet"] then
			left[line]:SetText(nil)
		else
			if strmatch(info, L["Boss"]) then
				class = "worldboss"
			end
			if ctype == L["Not specified"] then
				ctype = ""
			elseif ctype == L["Non-combat Pet"] then
				ctype = TOOLTIP_BATTLE_PET
			elseif UnitPlayerControlled(unit) then
				ctype = UnitCreatureFamily(unit) or ctype
			end
			left[line]:SetFormattedText("%s%s|r%s %s%s|r%s", lhex, level > 0 and level or "??", classification[class] or "", uhex, ctype or "", btype or "")
			line = line + 1
		end

	end

	--------------------------------------------------------------------
	--	Hide PvP text, same faction name, Blizzard battle pet info

	for i = line, GameTooltip:NumLines() do
		local L = left[i]
		local T = strtrim( L:GetText() or "" )
		if T == "" or T == PVP_ENABLED or T == FACTION_ALLIANCE or T == FACTION_HORDE or strfind(T, WILDBATTLEPET_TOOLTIP) then
			L:SetText(nil)
		end
	end

	--------------------------------------------------------------------
	--	Add target info

	local target = unit .. "target"
	if UnitExists(target) then
		if UnitIsPlayer(target) then
			local name, realm = UnitName(target)

			local class, classEN = UnitClass(target)
			local chex = classhex[classEN]

			if UnitIsUnit(target, "player") then
				GameTooltip:AddLine(format("@ >> %s <<", L["YOU"]), 1, 1, 1)
			elseif realm then
				GameTooltip:AddLine(format("@ %s%s %s %s|r", chex, name, L["of"], realm), 1, 1, 1)
			else
				GameTooltip:AddLine(format("@ %s%s|r", chex, name), 1, 1, 1)
			end
		else
			local name = UnitName(target)

			local uhex
			if UnitIsTapped(target) and not UnitIsTappedByPlayer(target) then
				uhex = unithex.tapped
			elseif UnitIsEnemy(target, "player") then
				uhex = unithex[1]
			else
				uhex = unithex[UnitReaction(target, "player") or 5]
			end

			GameTooltip:AddLine(format("@ %s%s|r", uhex, name), 1, 1, 1)
		end
	end

	--------------------------------------------------------------------
	--	Add raid icon

	local icon = GetRaidTargetIndex(unit)
	if icon then
		SetRaidTargetIconTexture(GameTooltip.raidTargetIcon, icon)
		GameTooltip.raidTargetIcon:Show()
	else
		GameTooltip.raidTargetIcon:Hide()
	end

	--------------------------------------------------------------------
	--	Done

	if UnitHealth(unit) > 0 and not UnitIsDeadOrGhost(unit) then
		GameTooltip.addHeight = 6 + GameTooltip.statusBar:GetHeight()
	end

	GameTooltip:Show()
end)

------------------------------------------------------------------------
--	Items (GameTooltip and ShoppingTooltip1-3)

local function OnTooltipSetItem(self)
	local name, link = self:GetItem()
	if not link then return end
	self.currentItem = link

	local name, _, quality, _, _, type, subType, stackCount, _, icon, sellPrice = GetItemInfo(link)

	if stackCount and stackCount > 1 and self.count then
		self.count:SetText(stackCount)
	end

	local r, g, b
	if type == L["Quest"] then
		r, g, b = 1, 0.82, 0.2
	elseif subType == L["Cooking"] then
		r, g, b = 0.4, 0.73, 1
	elseif subType == L["Companion Pets"] then
		local _, id = C_PetJournal.FindPetIDByName(name)
		if id then
			local _, _, _, _, petQuality = C_PetJournal.GetPetStats(id)
			if petQuality then
				quality = petQuality - 1
			end
		end
	end
	if quality and not r then
		r, g, b = GetItemQualityColor(quality)
	end
	if r then
		self:SetBackdropBorderColor(r, g, b)
		if self.icon then
			self.icon:SetBackdropBorderColor(r, g, b)
		end
	end
end

for _, tooltip in ipairs({ GameTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, ItemRefTooltip }) do
	tooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
end

------------------------------------------------------------------------
--	Items and achievements (ItemRefTooltip)

do
	local icon = CreateFrame("Frame", "$parentIcon", ItemRefTooltip)
	icon:SetPoint("TOPRIGHT", ItemRefTooltip, "TOPLEFT", -8, 0)
	icon:SetWidth(36)
	icon:SetHeight(36)
	ItemRefTooltip.icon = icon

	if PhanxBorder then
		PhanxBorder.AddBorder(icon)
	end

	local iconTex = icon:CreateTexture(nil, "BACKGROUND")
	iconTex:SetAllPoints(true)
	iconTex:SetTexCoord(0.06, 0.94, 0.06, 0.94)
	icon.icon = iconTex

	local check = icon:CreateTexture(nil, "ARTWORK")
	check:SetPoint("BOTTOMRIGHT")
	ItemRefTooltip.check = check

	local count = icon:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	count:SetPoint("BOTTOMRIGHT")
	ItemRefTooltip.count = count

	function icon:SetTexture(texture)
		if texture then
			self:Show()
			self.icon:SetTexture(texture)
		else
			self:Hide()
			self.icon:SetTexture(nil)
		end
	end

	icon:Hide()
end

ItemRefTooltip:HookScript("OnTooltipSetSpell", function(self)
	local _, _, spell = self:GetSpell()
	if not spell then return end
	local _, _, icon = GetSpellInfo(spell)

	self.icon:SetTexture(icon)
end)

hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(self, link)
	if type(link) ~= "string" then return end
	local linkType, id = strmatch(link, "^([^:]+):(%d+)")
	if linkType == "achievement" then
		local id, name, _, accountCompleted, month, day, year, _, _, icon, _, isGuild, characterCompleted, whoCompleted = GetAchievementInfo(id)
		self:SetBackdropBorderColor(1, 0.8, 0, 1)
		self.icon:SetBackdropBorderColor(1, 0.8, 0, 1)
		self.icon:SetTexture(icon)
--[[
		if characterCompleted then
			print("characterCompleted")
			self:AddLine(" ")
			self:AddLine(format(L["Completed on %1$d/%2$d/20%3$d"], month, day, year))
			self:Show()
		elseif whoCompleted then
			print("accountCompleted")
			self:AddLine(" ")
			self:AddLine(format(L["Completed by %1$s on %2$d/%3$d/20%4$d"], whoCompleted, month, day, year))
			self:Show()
		end
]]
	end
end)

ItemRefTooltip:HookScript("OnTooltipCleared", function(self)
	self.icon:SetBackdropBorderColor(1, 1, 1)
	self.icon:SetTexture(nil)
	self.count:SetText(nil)
end)