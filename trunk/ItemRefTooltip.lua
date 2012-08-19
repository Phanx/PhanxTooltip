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
	local _, item = self:GetItem()
	if not item then return end

	local name, _, rarity, _, _, _, _, stackCount, _, icon, sellPrice = GetItemInfo(item)

	self.icon:SetTexture(icon)

	if rarity then
		local r, g, b, hex = GetItemQualityColor(rarity)
		self:SetBackdropBorderColor(r, g, b)
		self.icon.frame:SetBackdropBorderColor(r, g, b)
	end

	if stackCount and stackCount > 1 then
		self.count:SetText(stackCount)
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