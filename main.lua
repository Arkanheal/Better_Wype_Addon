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
		showInChat = {
			type = "toggle",
			name = "Show in Chat",
			desc = "Toggles the display of the message in the chat window.",
			get = "IsShowInChat",
			set = "ToggleShowInChat",
		},
		showOnScreen = {
			type = "toggle",
			name = "Show on Screen",
			desc = "Toggles the display of the message in the chat window.",
			get = "IsShowOnScreen",
			set = "ToggleShowOnScreen",
		},
	},
}

local defaults = {
	profile = {
		message = "Welcome Home!",
		showInChat = false,
		showOnScreen = true,
	},
}

function BetterWype:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BetterWypeDB", defaults, true)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("BetterWype", options)
	self.optionFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BetterWype","BetterWype")
	self:RegisterChatCommand("betterwype", "ChatCommand")
	BetterWype.message = "Welcome home!"
	BetterWype.showInChat = false
	BetterWype.showOnScreen = true
end

function BetterWype:OnEnable()
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
end

function BetterWype:ZONE_CHANGED()
	local HS_loc = GetBindLocation()
	HS_loc = HS_loc:lower()
	local player_Subloc = GetSubZoneText()
	player_Subloc = player_Subloc:lower()
	if HS_loc == player_Subloc then
		if self.showInChat then
			self:Print(self.message)
		end
		
		if self.showOnScreen then
			UIErrorsFrame:AddMessage(self.message, 1.0, 1.0, 5.0)
		end
	end
end

function BetterWype:ZONE_CHANGED_INDOORS()
	local HS_loc = GetBindLocation()
	HS_loc = HS_loc:lower()
	local player_Subloc = GetSubZoneText()
	player_Subloc = player_Subloc:lower()
	if HS_loc == player_Subloc then
		if self.db.profile.showInChat then
			self:Print(self.db.profile.message)
		end
		
		if self.db.profile.showOnScreen then
			UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 5.0)
		end
	end
end

function BetterWype:GetMessage(info)
	return self.db.profile.message
end

function BetterWype:SetMessage(info, newValue)
	self.db.profile.message = newValue
end

function BetterWype:IsShowInChat(info)
	return self.db.profile.showInChat
end

function BetterWype:ToggleShowInChat(info, value)
	self.db.profile.showInChat = value
end

function BetterWype:IsShowOnScreen(info)
	return self.db.profile.showOnScreen
end

function BetterWype:ToggleShowOnScreen(info, value)
	self.db.profile.showOnScreen = value
end

function BetterWype:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionFrame)
	else
		LibStub("AceConfigCmd-3.0"):HandleCommand(BetterWype, "betterwype", optionFrame, input)
	end
end
