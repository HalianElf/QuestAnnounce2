
local QuestAnnounce2 = LibStub("AceAddon-3.0"):GetAddon("QuestAnnounce2")
local L = LibStub("AceLocale-3.0"):GetLocale("QuestAnnounce2")
local LSM = LibStub("LibSharedMedia-3.0")

local options, configOptions = nil, {}
--[[ This options table is used in the GUI config. ]]-- 
local function getOptions() 
	if not options then
		options = {
		    type = "group",
			name ="QuestAnnounce2",			
		    args = {
				general = {
					order = 1,
					type = "group",
					name = "General",
					args = {
						settings = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Settings"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestAnnounce2:SendDebugMsg("getSettings: "..key.." :: "..tostring(QuestAnnounce2.db.profile.settings[key]))
								return QuestAnnounce2.db.profile.settings[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestAnnounce2.db.profile.settings[key] = value
								if(key == "soundNameObj") then
									QuestAnnounce2.db.profile.settings.soundFileObj = LSM:Fetch("sound", QuestAnnounce2.db.profile.settings.soundNameObj)
								elseif(key == "soundNameQuest") then
									QuestAnnounce2.db.profile.settings.soundFileQuest = LSM:Fetch("sound", QuestAnnounce2.db.profile.settings.soundNameQuest)
								end
								QuestAnnounce2:SendDebugMsg("setSettings: "..key.." :: "..tostring(QuestAnnounce2.db.profile.settings[key]))
							end,
							args = {
								enabledesc = {
									order = 1,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestAnnounce2"]
								},
								enable = {
									order = 2,
									type = "toggle",
									name = L["Enable"]
						        },
								everydesc = {
									order = 3,
									type = "description",
									fontSize = "medium",
									name = L["Announce progression every x number of steps (0 will announce on quest objective completion only)"]
								},
								every = {
									order = 4,
									type = "range",
									name = L["Announce Every"],
									min = 0,
									max = 10,
									step = 1
						        },
								sounddesc = {
									order = 5,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestAnnounce2 Sounds"]
									
								},
								soundCompletion = {
									name = "Sounds",
									type = "toggle",
									order = 6,
									width = "half",
								},
								soundNameObj = {
									type = "select",
									dialogControl = 'LSM30_Sound',
									values = AceGUIWidgetLSMlists.sound,
									order = 7,
									name = "Objectives",
								},
								soundNameQuest = {
									type = "select",
									dialogControl = 'LSM30_Sound',
									values = AceGUIWidgetLSMlists.sound,
									order = 8,
									name = "Quests",
								},
								debugdesc = {
									order = 100,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestAnnounce2 Debug Mode"]
								},
								debug = {
									order = 101,
									type = "toggle",
									name = L["Debug"]
						        },
								test = {
									order = 102,
									type = "execute",
									name = "Test Frame Messages",
									func = function() QuestAnnounce2:SendMsg(L["QuestAnnounce2 Test Message"]) end
								}
							}
						},
						announceTo = {
							order = 6,
							type = "group",
							inline = true,
							name = L["Where do you want to make the announcements?"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestAnnounce2:SendDebugMsg("getAnnounceTo: "..key.." :: "..tostring(QuestAnnounce2.db.profile.announceTo[key]))
								return QuestAnnounce2.db.profile.announceTo[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestAnnounce2.db.profile.announceTo[key] = value
								QuestAnnounce2:SendDebugMsg("setAnnounceTo: "..key.." :: "..tostring(QuestAnnounce2.db.profile.announceTo[key]))
							end,
							args = {
								chatFrame = {
									order = 1,
									type = "toggle",
									name = L["Chat Frame"]
								},
								raidWarningFrame = {
									order = 2,
									type = "toggle",
									name = L["Raid Warning Frame"]
								},
								uiErrorsFrame = {
									order = 3,
									type = "toggle",
									name = L["UI Errors Frame"]
								}
							}
						},
						announceIn = {
							order = 7,
							type = "group",
							inline = true,
							name = L["What channels do you want to make the announcements?"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestAnnounce2:SendDebugMsg("getAnnounceIn: "..key.." :: "..tostring(QuestAnnounce2.db.profile.announceIn[key]))
								if (key == "selfColor") then
									return QuestAnnounce2.db.profile.announceIn.selfColor.r, QuestAnnounce2.db.profile.announceIn.selfColor.g, QuestAnnounce2.db.profile.announceIn.selfColor.b, 1.0
								else
									return QuestAnnounce2.db.profile.announceIn[key]
								end
							end,
							set = function(info, ...)
								local key = info.arg or info[#info]
								if (key == "selfColor") then
									QuestAnnounce2.db.profile.announceIn.selfColor.r, QuestAnnounce2.db.profile.announceIn.selfColor.g, QuestAnnounce2.db.profile.announceIn.selfColor.b = ...
									QuestAnnounce2.db.profile.announceIn.selfColor.hex = "|cff"..string.format("%02x%02x%02x", QuestAnnounce2.db.profile.announceIn.selfColor.r * 255, QuestAnnounce2.db.profile.announceIn.selfColor.g * 255, QuestAnnounce2.db.profile.announceIn.selfColor.b * 255) 
								else
									QuestAnnounce2.db.profile.announceIn[key] = ...
								end
								QuestAnnounce2:SendDebugMsg("setAnnounceIn: "..key.." :: "..tostring(QuestAnnounce2.db.profile.announceIn[key]))
							end,
							args = {
								say = {
									order = 1,
									type = "toggle",
									name = L["Say"]
								},
								party = {
									order = 2,
									type = "toggle",
									name = L["Party"]
								},
								instance = {
									order = 3,
									type = "toggle",
									name = L["Instance"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end									
								},								
								guild = {
									order = 4,
									type = "toggle",
									name = L["Guild"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end									
								},
								officer = {
									order = 5,
									type = "toggle",
									name = L["Officer"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								whisper = {
									order = 6,
									type = "toggle",
									name = L["Whisper"],
									width = "half",
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								whisperWho = {
									order = 7,
									type = "input",
									width = "half",
									name = L["Whisper Who"]
								},
								toSelf = {
									order = 8,
									type = "toggle",
									name = "Self",
									width = "half"
								},
								selfColor = {
									order = 9,
									type = "color",
									name = "Self Color",
									--get = function() return QuestAnnounce2.db.profile.selfColor.r, QuestAnnounce2.db.profile.selfColor.g, QuestAnnounce2.db.profile.selfColor.b, 1.0 end,
									--set = function(info, r, g, b, a)
									--	QuestAnnounce2.db.profile.selfColor.r, QuestAnnounce2.db.profile.selfColor.g, QuestAnnounce2.db.profile.selfColor.b = r, g, b
									--	QuestAnnounce2.db.profile.selfColor.hex = "|cff"..string.format("%02x%02x%02x", QuestAnnounce2.db.profile.selfColor.r * 255, QuestAnnounce2.db.profile.selfColor.g * 255, QuestAnnounce2.db.profile.selfColor.b * 255) 
									--	end,
									width = "half"
								}
							}
						}
					}
				}
		    }
		}
		for k,v in pairs(configOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end
	
	return options
end

--Shared Media
LSM:Register("sound", "PVPFlagCapturedHorde","Sound\\Interface\\PVPFlagCapturedHordeMono.ogg")
LSM:Register("sound", "PVPFlagCaptured", "Sound\\Interface\\PVPFlagCapturedMono.ogg")
LSM:Register("sound", "GM ChatWarning", "Sound\\Interface\\GM_ChatWarning.ogg")
LSM:Register("sound", "Hearthstone-QuestAccepted", "Interface\\Addons\\QuestAnnounce2\\Sounds\\Hearthstone-QuestingAdventurer_QuestAccepted.ogg")
LSM:Register("sound", "Hearthstone-QuestFailed", "Interface\\Addons\\QuestAnnounce2\\Sounds\\Hearthstone-QuestingAdventurer_QuestFailed.ogg")

local function openConfig() 
	InterfaceOptionsFrame_OpenToCategory(QuestAnnounce2.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(QuestAnnounce2.optionsFrames.QuestAnnounce2)
	InterfaceOptionsFrame:Raise()
end

function QuestAnnounce2:SetupOptions()
	self.optionsFrames = {}

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("QuestAnnounce2", getOptions)
	self.optionsFrames.QuestAnnounce2 = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuestAnnounce2", nil, nil, "general")

	configOptions["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	self.optionsFrames["Profiles"] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuestAnnounce2", "Profiles", "QuestAnnounce2", "Profiles")

	LibStub("AceConsole-3.0"):RegisterChatCommand("qa", openConfig)
end