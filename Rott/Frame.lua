
local framePrefix = "Rott_Frame_"
rott_frame_reset_command = "/rottfr"


function rott_createFrame(name, xo, yo)
	local rott_frame = CreateFrame("Frame", framePrefix .. name, UIParent)
	rott_frame:SetWidth(16)
	rott_frame:SetHeight(16)
	rott_frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", xo, yo);
	
	rott_frame:SetBackdrop({
		bgFile = "Interface\\Addons\\Rott\\white16x16", tile = true, tileSize = 16,
		edgeFile = "Interface\\Addons\\Rott\\white16x16", edgeSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	});
	rott_frame:SetBackdropBorderColor(0,0,0,0);
	rott_frame:SetBackdropColor(0,0,0,1);
	
	local fs = rott_frame:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	fs:SetAllPoints();
	
	--print("Made a new frame with name: " .. name)
	
end


function rott_setFrameColor(name, red, green, blue)
	local frame = getglobal(framePrefix .. name)
	frame:SetBackdropColor(red,green,blue, 1);
	--print("set frame to: " .. red .. green .. blue)
end

function rott_resetFrames() --set the frames back to black
	rott_setFrameColor("Main", 0, 0, 0)
	rott_setFrameColor("Key", 0, 0, 0)
	rott_setFrameColor("Key2", 0, 0, 0)
	rott_setFrameColor("Key3", 0, 0, 0)
	--rott_setFrameColor("Movement", 0, 0, 0)
end

function rott_frame_OnLoad()
	print("rott_frame_OnLoad called")
	rott_createFrame("Main", 0, 0)
	rott_createFrame("Key", 16, 0)
	rott_createFrame("Key2", 32, 0)
	rott_createFrame("Key3", 48, 0)
	--rott_createFrame("Movement", 64, 0)
	
	rott_resetFrames()
	
	
	SLASH_ROTTFRAME1 = rott_frame_reset_command
	function SlashCmdList.ROTTFRAME(msg, editbox)
		rott_resetFrames()
		rott_profileList[rott_currentProfile].rotation()
	end
	
end