--[[--------------------------------------------------------------------
	PhanxTooltip
	Simple tooltip modifications.
	Copyright (c) 2011-2014 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying LICENSE file for more information.
	http://www.wowinterface.com/downloads/info22654-PhanxTooltip.html
	http://wow.curseforge.com/addons/phanxtooltip/
	http://www.curse.com/addons/wow/phanxtooltip
----------------------------------------------------------------------]]

local _, L = ...

setmetatable(L, { __index = function(L, k)
	local v = tostring(k)
	L[k] = v
	return v
end })

L["Companion Pets"] = select(3, GetAuctionItemSubClasses(9))
L["Cooking"] = select(5, GetAuctionItemSubClasses(6))
L["Quest"] = select(10, GetAuctionItemClasses())

local GAME_LOCALE = GetLocale()

if GAME_LOCALE == "deDE" then

	L["Level"] = "Stufe" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "Haustierstufe" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "Wildtier"
	L["Humanoid"] = "Humanoid"
	L["Non-combat Pet"] = "Haustier"
	L["Not specified"] = "Nicht spezifiziert"
	L["Wild Pet"] = "Ungezähmtes Tier"
	L["Boss"] = "Chef"
	L["Elite"] = "Elite"
	L["Rare"] = "Rar"
	L["YOU"] = "EUCH"
	L["of"] = "von"
	L["Completed on %1$d/%2$d/20%3$d"] = "Erzielt am %2$d.%1$d.20%3$02d"
	L["Completed by %1$s on %2$d/%3$d/2020%4d"] = "Erzielt von %1$s am %3$d.%2$d.20%4$02d"

elseif GAME_LOCALE == "esES" then

	L["Level"] = "Nivel" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "nivel" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "Bestia"
	L["Humanoid"] = "Humanoide"
	L["Non-combat Pet"] = "Mascota no combatiente"
	L["Not specified"] = "No especificado"
	L["Wild Pet"] = "Mascota salvaje" -- needs check
	L["Boss"] = "Jefe"
	L["Elite"] = "Élite"
	L["Rare"] = "Raro"
	L["YOU"] = "TI"
	L["of"] = "de"
	L["Completed on %1$d/%2$d/%3$d"] = "Completado el %2$d/%1$d/20%3$02d"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "Completado por %1$s el %3$d/%2$d/20%4$02d"

elseif GAME_LOCALE == "esMX" then

	L["Level"] = "Nivel" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "nivel" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "Bestia"
	L["Humanoid"] = "Humanoide"
	L["Non-combat Pet"] = "Mascota mansa"
	L["Not specified"] = "Sin especificar"
	L["Wild Pet"] = "Mascota salvaje" -- needs check
	L["Boss"] = "Jefe"
	L["Elite"] = "Élite"
	L["Rare"] = "Raro"
	L["YOU"] = "TI"
	L["of"] = "de"
	L["Completed on %1$d/%2$d/%3$d"] = "Completado el %2$d/%1$d/20%3$02d"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "Completado por %1$s el %3$d/%2$d/20%4$02d"

elseif GAME_LOCALE == "frFR" then

	L["Level"] = "[Nn]iveau" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "niveau" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "Bête"
	L["Humanoid"] = "Humanoïde"
	L["Non-combat Pet"] = "Familier pacifique"
	L["Not specified"] = "Non spécifié"
	L["Wild Pet"] = "Mascotte sauvage" -- needs check
	L["Boss"] = "Chef"
	L["Elite"] = "Élite"
	L["Rare"] = "Raro"
	L["YOU"] = "VOUS"
	L["of"] = "de"
	L["Completed on %1$d/%2$d/%3$d"] = "Accompli le %2$d/%1$d/20%3$02d"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "Accompli par %1$s le %3$d/%2$d/20%4$02d"

elseif GAME_LOCALE == "itIT" then

	L["Level"] = "[Ll]ivello" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "livello" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "Tipo Bestiale"
	L["Humanoid"] = "Tipo Umanoide"
	L["Non-combat Pet"] = "Animale Non combattente"
	L["Not specified"] = "Non Specificato"
	L["Wild Pet"] = "Mascotte selvatica" -- needs check
	L["Boss"] = "Capo"
	L["Elite"] = "Elite"
	L["Rare"] = "Raro"
	L["YOU"] = "VOI"
	L["of"] = "di"
	L["Completed on %1$d/%2$d/%3$d"] = "Compiuta il %2$d/%1$d/20%3$02d"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "Compiuta da %1$s il %3$d/%2$d/20%4$02d"

elseif GAME_LOCALE == "ptBR" then

	L["Level"] = "[Nn]ível" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "Nível" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Boss"] = " %(Chefe%)"
	L["Beast"] = "Fera"
	L["Humanoid"] = "Humanoide"
	L["Non-combat Pet"] = "Mascote não-combatente"
	L["Not specified"] = "Não especificado"
	L["Wild Pet"] = "Mascote Selvagem" -- needs check
	L["Boss"] = "Chefe"
	L["Elite"] = "Elite"
	L["Rare"] = "Raro"
	L["YOU"] = "VOCÊ"
	L["of"] = "de"
	L["Completed on %1$d/%2$d/%3$d"] = "Obtida em %2$d/%1$d/20%3$02d"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "Obtida por %1$s em %3$d/%2$d/20%4$02d"

elseif GAME_LOCALE == "ruRU" then

	L["Level"] = "[Уу]рове?н[ья]" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "уровня" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "Животное"
	L["Humanoid"] = "Гуманоид"
	L["Non-combat Pet"] = "Спутник"
	L["Not specified"] = "Не указано"
	L["Wild Pet"] = "Дикий питомец" -- needs check
	L["Boss"] = "Босс"
	L["Elite"] = "Элита"
	L["Rare"] = "Редкий"
	L["YOU"] = "ВАС"
	L["of"] = "из"
	L["Completed on %1$d/%2$d/%3$d"] = "Получено %2$d/%1$d/20%3$02d"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "Получено |3-4(%1$s) %3$d/%2$d/20%4$02d"

elseif GAME_LOCALE == "koKR" then

	L["Level"] = "레벨" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "레벨" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "야수"
	L["Humanoid"] = "인간형"
	L["Non-combat Pet"] = "애완동물"
	L["Not specified"] = "기타"
	L["Wild Pet"] = "" -- TODO
	L["Boss"] = "우두머리"
	L["Elite"] = "정예"
	L["Rare"] = "희귀"
	L["YOU"] = "당신"
	L["of"] = "으로"
	L["Completed on %1$d/%2$d/%3$d"] = "획득 %3$02d/%2$d/%1$02d"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "%1$s 획득 %2$d/%3$d/20%4$02d"

elseif GAME_LOCALE == "zhCN" then

	L["Level"] = "等级" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "宠物等级" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "野兽"
	L["Humanoid"] = "人型生物"
	L["Non-combat Pet"] = "非战斗宠物"
	L["Not specified"] = "未指定"
	L["Wild Pet"] = "" -- TODO
	L["Boss"] = "首领"
	L["Elite"] = "精英"
	L["Rare"] = "稀有"
	L["YOU"] = "你"
	L["of"] = "的"
	L["Completed on %1$d/%2$d/%3$d"] = "%2$d/%3$d/20%4$02d获得了"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "%s在%2$d/%3$d/20%4$02d获得了"

elseif GAME_LOCALE == "zhTW" then

	L["Level"] = "等級" -- see TOOLTIP_UNIT_LEVEL
	L["Pet Level"] = "寵物等級" -- see TOOLTIP_WILDBATTLEPET_LEVEL_CLASS
	L["Beast"] = "野獸"
	L["Humanoid"] = "人型生物"
	L["Non-combat Pet"] = "非戰鬥寵物"
	L["Not specified"] = "不明"
	L["Wild Pet"] = "" -- TODO
	L["Boss"] = "首領"
	L["Elite"] = "精英"
	L["Rare"] = "稀有"
	L["YOU"] = "你"
	L["of"] = "的"
	L["Completed on %1$d/%2$d/%3$d"] = "於20%4$02d年%2$d月%3$d日達成"
	L["Completed by %1$s on %2$d/%3$d/20%4d"] = "由%s於20%4$02d年%2$d月%3$d日達成"

end