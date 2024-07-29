local myname, ns = ...

local inv = LibStub("AceAddon-3.0"):GetAddon("Inventorian")

local original_FrameCreate = inv.Frame.Create
inv.Frame.Create = function(self, ...)
	local frame = original_FrameCreate(self, ...)

	local presets = CreateFrame("DropdownButton", nil, frame) --, "WowStyle1DropdownTemplate")
	presets:SetSize(32, 32)
	presets:SetPoint("TOPLEFT", 64, -27)
	-- presets:RegisterForClicks("anyUp")

	presets.Icon = presets:CreateTexture(nil, "BACKGROUND")
	presets.Icon:SetAtlas('bags-icon-tradegoods')
	presets.Icon:SetSize(32, 32)
	presets.Icon:SetPoint("TOPLEFT", 0, 0)
	presets.Border = presets:CreateTexture(nil, "ARTWORK")
	presets.Border:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
	presets.Border:SetSize(54, 54)
	presets.Border:SetPoint("TOPLEFT")
	presets.Border:SetDesaturated(true)
	presets.Border:SetAlpha(0.8)
	presets:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]], "ADD")

	-- Base inventorian is: 75, -32
	frame.SearchBox:SetPoint("TOPLEFT", 75 + (32 + 2), -32)

	local doSearch = function(data, event)
		frame.SearchBox:SetText(data)
		return MenuResponse.CloseAll
	end

	presets:SetupMenu(function(owner, rootDescription)
		rootDescription:CreateTitle("Search Presets")
		local quality = rootDescription:CreateButton("Quality")
		for i = 0, #ITEM_QUALITY_COLORS - 1 do
			quality:CreateButton(
				ITEM_QUALITY_COLORS[i].hex .. _G['ITEM_QUALITY' .. i .. '_DESC'],
				doSearch,
				'quality:' .. _G['ITEM_QUALITY' .. i .. '_DESC']:lower()
			)
		end

		local bound = rootDescription:CreateButton("Bound")
		-- Can't search for "is currently soulbound", because it's scanning itemlinks, not the actual container-items
		-- bound:CreateButton(ITEM_SOULBOUND, doSearch, ITEM_SOULBOUND)
		bound:CreateButton(ITEM_BIND_ON_PICKUP, doSearch, "bind:bop")
		bound:CreateButton(ITEM_BIND_ON_EQUIP, doSearch, "bind:boe")
		bound:CreateButton(ITEM_BIND_TO_BNETACCOUNT, doSearch, "bind:boa")
		bound:CreateButton(ITEM_BIND_ON_USE, doSearch, "bind:bou")

		local types = rootDescription:CreateButton("Type")
		types:CreateButton(BAG_FILTER_EQUIPMENT, doSearch, "type:" ..  GetItemClassInfo(Enum.ItemClass.Armor):lower() .. '||' .. 'type:' .. GetItemClassInfo(Enum.ItemClass.Weapon):lower())
		types:CreateButton(GetItemClassInfo(Enum.ItemClass.Armor), doSearch, "type:" .. GetItemClassInfo(Enum.ItemClass.Armor):lower())
		types:CreateButton(GetItemClassInfo(Enum.ItemClass.Weapon), doSearch, "type:" .. GetItemClassInfo(Enum.ItemClass.Weapon):lower())
		types:CreateButton(GetItemClassInfo(Enum.ItemClass.Consumable), doSearch, "type:" .. GetItemClassInfo(Enum.ItemClass.Consumable):lower())
		types:CreateDivider()
		types:CreateButton(PROFESSIONS_USED_IN_COOKING, doSearch, PROFESSIONS_USED_IN_COOKING:lower())
		types:CreateButton(ITEM_BIND_QUEST, doSearch, "bind:quest")
		types:CreateButton(ITEM_UNIQUE, doSearch, "bind:unique")
		types:CreateButton(TOY, doSearch, "desc:toy")
		types:CreateDivider()
		types:CreateButton(ARTIFACT_POWER, doSearch, "desc:artifact power")
		types:CreateButton("Champion Equipment", doSearch, "desc:champion equipment")

		local level = rootDescription:CreateButton("Required level")
		level:CreateButton("Can use", doSearch, 'reqlvl:<=' .. UnitLevel('player'))
		level:CreateButton("Can't use", doSearch, 'reqlvl:>' .. UnitLevel('player'))

		rootDescription:CreateButton("In Equipment Set", doSearch, "set:*")
	end)

	return frame
end
