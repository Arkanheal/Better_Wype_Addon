BetterWype = LibStub("AceAddon-3.0"):NewAddon("BetterWype", "AceConsole-3.0", "AceEvent-3.0")

local options = {
	name = "BetterWype",
	handler = BetterWype,
	type = 'group',
	args = {
		msg = {
			type = "input",
			name = "Key"	,
			desc = "Press a random key and press [OK]",
			usage = "<Your message>",
			get = "GetMessage",
			set = "SetMessage",
		},
		rolegroupe = {
			type = "group",
			name = "Roles",
			args = {
				tank = {
					type = "toggle",
					name = "Tank",
					get = "IsTank",
					set = "SetTank",
				},
				DPS_cast = {
					type = "toggle",
					name = "DPS Cast",
					get = "IsDPSCast",
					set = "SetDPSCast",
				},
				DPS_melee = {
					type = "toggle",
					name = "DPS Melee",
					get = "IsDPSMelee",
					set = "SetDPSMelee",
				},
				heal = {
					type = "toggle",
					name = "Healer",
					get = "IsHealer",
					set = "SetHealer",
				},
			},
		},
			
	},
}

local classPlate = { 1, 2, 6 }
local classMail = { 3, 7}
local classLeather = { 4, 10, 11, 12 }
local classCloth = { 5, 8, 9}

local defaults = {
	profile = {
		message = "No Key atm",
		showInChat = false,
		showOnScreen = true,
		tank = false,
		dpscast = false,
		dpsmelee = false,
		healer = false,
	},
}

function BetterWype:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BetterWypeDB", defaults, true)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("BetterWype", options)
	self.optionFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BetterWype","BetterWype")
	self:RegisterChatCommand("betterwype", "ChatCommand")
	BetterWype.message = BetterWype:GetKeyInfo()
	BetterWype.showInChat = false
	BetterWype.showOnScreen = true
end

function BetterWype:OnEnable()
	self:RegisterEvent("BAG_UPDATE")
end

function BetterWype:BAG_UPDATE()
	local _,_, classIndex = UnitClass("player");
	if BetterWype:has_in(classLeather, classIndex) then
		self:Print("You are a leather wearer")
	end
	self:Print(classIndex)
	local keylink = BetterWype:GetKeyInfo()
	if keylink ~= "" then
		BetterWype:SetMessage()
	else
		self:Print("No Keys found in your bags")
	end
end

--Getters && Setters
function BetterWype:GetMessage(info)
	return self.db.profile.message
end

function BetterWype:SetMessage(info)
	self.db.profile.message = BetterWype:GetKeyInfo()
end

function BetterWype:IsTank(info)
	return self.db.profile.tank
end

function BetterWype:SetTank(info, value)
	self.db.profile.tank = value
end

function BetterWype:IsDPSCast(info)
	return self.db.profile.dpscast
end

function BetterWype:SetDPSCast(info, value)
	self.db.profile.dpscast = value
end

function BetterWype:IsDPSMelee(info)
	return self.db.profile.dpsmelee
end

function BetterWype:SetDPSMelee(info,value)
	self.db.profile.dpsmelee = value
end

function BetterWype:IsHealer(info)
	return self.db.profile.healer
end

function BetterWype:SetHealer(info, value)
	self.db.profile.healer = value
end

function BetterWype:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionFrame)
	else
		LibStub("AceConfigCmd-3.0"):HandleCommand(BetterWype, "betterwype", optionFrame, input)
	end
end

--Check if item in list function
function BetterWype:has_in(tab, val)
	for i, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	
	return false
end

--Function got on Re:Keys addon sourcecode (thanks AcidWeb)
function BetterWype:GetKeyInfo()
	local keyLink = "No Keys found"
	for bag = 0, NUM_BAG_SLOTS do
		local bagSlots = GetContainerNumSlots(bag)
		for slot = 1, bagSlots do
			if GetContainerItemID(bag, slot) == 138019 then
				keyLink = GetContainerItemLink(bag, slot)
				break
			end
		end
	end
	return keyLink
end	