--[[--------------------------------------------------------------------
	PhanxTooltip
	Simple tooltip modifications.
	Copyright (c) 2011-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying LICENSE file for more information.
----------------------------------------------------------------------]]
--	Items and achievements (ItemRefTooltip)

do
	local iconframe = CreateFrame("Frame", "$parentIcon", ItemRefTooltip)
	iconframe:SetPoint("TOPRIGHT", ItemRefTooltip, "TOPLEFT", -8, 0)
	iconframe:SetWidth(36)
	iconframe:SetHeight(36)

	if PhanxBorder then
		PhanxBorder.AddBorder(iconframe)
	end

	local icon = iconframe:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints(true)
	icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)

	icon.frame = iconframe

	local check = iconframe:CreateTexture(nil, "ARTWORK")
	check:SetPoint("BOTTOMRIGHT")

	local count = iconframe:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	count:SetPoint("BOTTOMRIGHT")

	ItemRefTooltip.icon = icon
	ItemRefTooltip.check = check
	ItemRefTooltip.count = count
end

ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
	local name, link = self:GetItem()
	if not link then return end
	self.currentItem = link

	local name, _, quality, _, _, type, subType, stackCount, _, icon, sellPrice = GetItemInfo(link)

	self.icon:SetTexture(icon)

	if stackCount and stackCount > 1 then
		self.count:SetText(stackCount)
	end

	local r, g, b
	if type == "Quest" then
		r, g, b = 1, 0.82, 0.2
	elseif subType == "Cooking" then
		r, g, b = 0.4, 0.73, 1
	elseif subType == "Companion Pets" then
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
		self.icon.frame:SetBackdropBorderColor(r, g, b)
	end
end)

ItemRefTooltip:HookScript("OnTooltipSetSpell", function(self)
	local _, _, spell = self:GetSpell()
	if not spell then return end

	local _, _, icon = GetSpellInfo(spell)

	self.icon:SetTexture(icon)
end)

hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(self, link)
	if type(link) ~= "string" then return end
	local linkType, id = link:match("^([^:]+):(%d+)")
	--print("Link type:", linkType, id)
	if linkType == "achievement" then
		local _, name, points, completed, month, day, year, description, flags, icon, reward = GetAchievementInfo(id)
		--print("Linked achievement:", id, name)

		self.icon:SetTexture(icon)

		self.icon.frame:SetBackdropBorderColor(1, 0.8, 0, 1)
		self:SetBackdropBorderColor(1, 0.8, 0, 1)
	--[[
		if points > 0 then
			self.count:SetText(points)
		end
	]]
	end
end)

ItemRefTooltip:HookScript("OnTooltipCleared", function(self)
	self.icon.frame:SetBackdropBorderColor(1, 1, 1)
	self.icon:SetTexture(nil)
	self.count:SetText(nil)
end)