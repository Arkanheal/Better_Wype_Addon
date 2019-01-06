BetterWype = LibStub("AceAddon-3.0"):NewAddon("BetterWype", "AceConsole-3.0", "AceEvent-3.0")

local options = {
	name = "BetterWype",
	handler = BetterWype,
	type = 'group',
	args = {
		msg = {
			type = "input",
			name = "Message",
			desc = "The message to be displayed",
			usage = "<Your message>",
			get = "GetMessage",
			set = "SetMessage",
		},
	},
}

function BetterWype:OnInitialize()
	LibStub("AceConfig-3.0":RegisterOptionsTable("BetterWype", options)
	self.optionFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BetterWype","BetterWype")
	self:RegisterChatCommand("betterwype", "ChatCommand")
	self:RegisterChatCommand("bw", "ChatCommand")
	BetterWype.message = "Welcome home!"
end

function BetterWype:OnEnable()
	self:RegisterEvent("ZONE_CHANGED")
end

function BetterWype:ZONE_CHANGED()
	if GetBindLocation() == GetSubZoneText() then
		self:Print(self.message)
	end
end

function BetterWype:GetMessage(info)
	return self.message
end

function BetterWype:SetMessage(info, newValue)
	self.message = newValue
end

function BetterWype:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	else
		LibStub("AceConfigCmd-3.0"):HandleCommand("bw", "BetterWype", input)
	end
end
