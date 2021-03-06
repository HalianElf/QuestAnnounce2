
local QuestAnnounce2 = LibStub("AceAddon-3.0"):NewAddon("QuestAnnounce2", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("QuestAnnounce2")

--[[ vars between functions ]]--
local questNum = 0
local questMsg = nil

--[[ The defaults a user without a profile will get. ]]--
local defaults = {
	profile={
		settings = {
			enable = true,
			every = 1,
			sound = true,
			soundNameObj = "PVPFlagCapturedHorde", soundFileObj = "Sound\\Interface\\PVPFlagCapturedHordeMono.ogg",
			soundNameQuest = "PVPFlagCaptured", soundFileQuest = "Sound\\Interface\\PVPFlagCapturedMono.ogg",
			debug = false
		},
		announceTo = {
			chatFrame = true,
			raidWarningFrame = false,
			uiErrorsFrame = false,
		},
		announceIn = {
			say = false,
			party = true,
			guild = false,
			officer = false,
			whisper = false,
			whisperWho = nil,
			toSelf = true,
			selfColor = {r = 1.0, g = 1.0, b = 1.0, hex = "|cffFFFFFF"}
		}
	}
}

--[[ QuestAnnounce2 Initialize ]]--
function QuestAnnounce2:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("QuestAnnounceDB", defaults, true)
	
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
	self.db.RegisterCallback(self, "OnNewProfile", "OnNewProfile")
	
	self:SetupOptions()
end

function QuestAnnounce2:OnEnable()
	--[[ We're looking at the UI_INFO_MESSAGE for quest messages ]]--
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("QUEST_WATCH_UPDATE")
	--self:RegisterEvent("QUEST_LOG_UPDATE")

	self:SendDebugMsg("Addon Enabled :: "..tostring(QuestAnnounce2.db.profile.settings.enable))
end

--[[ Event handlers ]]--
function QuestAnnounce2:QUEST_WATCH_UPDATE(event, questIndex)
	--[[local isComplete = select(6, C_QuestLog.GetInfo(questIndex))
	if (isComplete == nil) then
		isComplete = 0
	end
	QuestAnnounce2:SendDebugMsg("Quest Text: "..isComplete)]]--
	questNum = questIndex
end

function QuestAnnounce2:UI_INFO_MESSAGE(event, id, msg)
	if (msg ~= nil) then
		local questText = gsub(msg, "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$", "%1", 1)
		QuestAnnounce2:SendDebugMsg("Quest Text: "..questText)
		
		if (questText ~= msg) then
			questMsg = msg
		end

		local settings = self.db.profile.settings
	
		if (questNum ~= 0 and questMsg ~= nil) then
			if (settings.enable) then
				QuestAnnounce2:SendDebugMsg("Quest Text: "..questMsg)
				local ii, jj, strItemName, iNumItems, iNumNeeded = string.find(questMsg, "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$")
				local stillNeeded = iNumNeeded - iNumItems
				local isComplete = select(6, C_QuestLog.GetInfo(questNum))
				
				if (isComplete == nil) then
					isComplete = 0
				end
	
				QuestAnnounce2:SendDebugMsg("Item Name: "..strItemName.." :: Num Items: "..iNumItems.." :: Num Needed: "..iNumNeeded.." :: Still Need: "..stillNeeded.." :: Completed: "..isComplete)
				
				if(stillNeeded == 0 and settings.every == 0) then
					if (isComplete == 1) then
						QuestAnnounce2:SendMsg(questMsg..L[" -- QUEST COMPLETE"],1) --quest complete
					else
						QuestAnnounce2:SendMsg(questMsg,2) --objective complete
					end
				elseif(QuestAnnounce2.db.profile.settings.every > 0) then
					local every = math.fmod(iNumItems, settings.every)
					QuestAnnounce2:SendDebugMsg("Every fMod: "..every)
				
					if(every == 0 and stillNeeded > 0) then
						QuestAnnounce2:SendMsg(L["Progress: "]..questMsg,0)
					elseif(stillNeeded == 0) then
						if (isComplete == 1) then
							QuestAnnounce2:SendMsg(questMsg..L[" -- QUEST COMPLETE"],1) --quest complete
						else
							QuestAnnounce2:SendMsg(questMsg,2) --objective complete
						end
					end
				end
				
				questNum = 0
				questMsg = nil
			end
		end
	end
end

--[[function QuestAnnounce2:UNIT_QUEST_LOG_CHANGED(event, unitName)
	local settings = self.db.profile.settings
	
	if (questNum ~= 0 and questMsg ~= nil) then
		if (settings.enable) then
			QuestAnnounce2:SendDebugMsg("Quest Text: "..questMsg)
			local ii, jj, strItemName, iNumItems, iNumNeeded = string.find(questMsg, "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$")
			local stillNeeded = iNumNeeded - iNumItems
			local isComplete = select(6, C_QuestLog.GetInfo(questNum))
			
			if (isComplete == nil) then
				isComplete = 0
			end

			QuestAnnounce2:SendDebugMsg("Item Name: "..strItemName.." :: Num Items: "..iNumItems.." :: Num Needed: "..iNumNeeded.." :: Still Need: "..stillNeeded.." :: Completed: "..isComplete)
			
			if(stillNeeded == 0 and settings.every == 0) then
				if (isComplete == 1) then
					QuestAnnounce2:SendMsg(questMsg..L[" -- QUEST COMPLETE"],1) --quest complete
				else
					QuestAnnounce2:SendMsg(questMsg,2) --objective complete
				end
			elseif(QuestAnnounce2.db.profile.settings.every > 0) then
				local every = math.fmod(iNumItems, settings.every)
				QuestAnnounce2:SendDebugMsg("Every fMod: "..every)
			
				if(every == 0 and stillNeeded > 0) then
					QuestAnnounce2:SendMsg(L["Progress: "]..questMsg,0)
				elseif(stillNeeded == 0) then
					if (isComplete == 1) then
						QuestAnnounce2:SendMsg(questMsg..L[" -- QUEST COMPLETE"],1) --quest complete
					else
						QuestAnnounce2:SendMsg(questMsg,2) --objective complete
					end
				end
			end
			
			questNum = 0
			questMsg = nil
		end
	end
end]]--

function QuestAnnounce2:OnProfileChanged(event, db)
 	self.db.profile = db.profile
end

function QuestAnnounce2:OnProfileReset(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
	self.db.profile = db.profile
end

function QuestAnnounce2:OnNewProfile(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
end

--[[ Sends a debugging message if debug is enabled and we have a message to send ]]--
function QuestAnnounce2:SendDebugMsg(msg)
	if(msg ~= nil and self.db.profile.settings.debug) then
		QuestAnnounce2:Print("DEBUG :: "..msg)
	end
end

--[[ Sends a chat message to the selected chat channels and frames where applicable,
	if we have a message to send; will also send a debugging message if debug is enabled ]]--
function QuestAnnounce2:SendMsg(msg, comp)	
	local announceIn = self.db.profile.announceIn
	local announceTo = self.db.profile.announceTo

	if (msg ~= nil and self.db.profile.settings.enable) then
		if(announceTo.chatFrame) then
			if(announceIn.say) then
				SendChatMessage(msg, "SAY")
				QuestAnnounce2:SendDebugMsg("QuestAnnounce2:SendMsg(SAY) :: "..msg)
			end
		
			--[[ GetNumGroupMembers is group-wide; GetNumSubgroupMembers is confined to your group of 5 ]]--
			--[[ Ref: http://www.wowpedia.org/API_GetNumSubgroupMembers or http://www.wowpedia.org/API_GetNumGroupMembers ]]--	
			if(announceIn.party) then
				if(IsInGroup() and GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0) then
					SendChatMessage(msg, "PARTY")
				end
				
				QuestAnnounce2:SendDebugMsg("QuestAnnounce2:SendMsg(PARTY) :: "..msg)
			end				
		
			if(announceIn.instance) then
				if (IsInInstance() and GetNumSubgroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0) then
					SendChatMessage(msg, "INSTANCE_CHAT")
				end
				
				QuestAnnounce2:SendDebugMsg("QuestAnnounce2:SendMsg(INSTANCE) :: "..msg)
			end				
		
			if(announceIn.guild) then
				if(IsInGuild()) then
					SendChatMessage(msg, "GUILD")
				end
				
				QuestAnnounce2:SendDebugMsg("QuestAnnounce2:SendMsg(GUILD) :: "..msg)
			end
			
			if(announceIn.officer) then
				if(IsInGuild()) then
					SendChatMessage(msg, "OFFICER")
				end
				
				QuestAnnounce2:SendDebugMsg("QuestAnnounce2:SendMsg(OFFICER) :: "..msg)
			end			
				
			if(announceIn.whisper) then
				local who = announceIn.whisperWho
				if(who ~= nil and who ~= "") then
					SendChatMessage(msg, "WHISPER", nil, who)
					QuestAnnounce2:SendDebugMsg("QuestAnnounce2:SendMsg(WHISPER) :: "..who.."-"..msg)
				end
			end
			if(announceIn.toSelf) then
			--if(true) then
				if(not IsInGroup()) then
					print(announceIn.selfColor.hex..msg)
					--print("|cffFFFFFF"..msg)
				end
			end
		end
		
		if(announceTo.raidWarningFrame) then
			RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["RAID_WARNING"])
		end
		
		if(announceTo.uiErrorsFrame) then
			UIErrorsFrame:AddMessage(msg, 1.0, 1.0, 0.0, 7)
		end
		
		if(self.db.profile.settings.sound) then
			if(comp == 1) then
				PlaySoundFile(self.db.profile.settings.soundFileQuest,"Master")
			elseif (comp == 2) then
				PlaySoundFile(self.db.profile.settings.soundFileObj,"Master")
			end
		end
	end
	
	QuestAnnounce2:SendDebugMsg("QuestAnnounce2:SendMsg - "..msg)
end