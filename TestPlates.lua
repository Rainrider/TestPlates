local OnUpdate = function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed >= 2 then
		local highlight = self.highlight
		local par = highlight:GetParent()
		print("parent", par:IsShown(), par:IsVisible(), par:IsMouseEnabled())
		print("highlight", highlight:IsShown(), highlight:IsVisible())
		self.elapsed = 0
	end
end

local ModPlate = function(self, frameName)
	local barFrame, nameFrame = self:GetChildren()
	local _, _, highlight = barFrame:GetRegions()
	self.highlight = highlight
---[[
	local bg = self:CreateTexture(nil, highlight:GetDrawLayer())
	bg:SetPoint(highlight:GetPoint(1))
	bg:SetPoint(highlight:GetPoint(2))
	bg:SetTexture(highlight:GetTexture())
	bg:SetBlendMode(highlight:GetBlendMode())
--]]
	self:SetScript("OnUpdate", OnUpdate)

	self.elapsed = 0
end

local CheckFrames = function(num, ...)
	for i = 1, num do
		local frame = select(i, ...)
		local frameName = frame:GetName()
		if frameName and frameName:find("NamePlate%d") and not frame.done then
			ModPlate(frame, frameName)
			frame.done = true
		end
	end
end

local numKids = 0
local lastUpdate = 0
local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 0.1 then
		local newNumKids = WorldFrame:GetNumChildren()

		if newNumKids ~= numKids then
			CheckFrames(newNumKids, WorldFrame:GetChildren())

			numKids = newNumKids
		end
		lastUpdate = 0
	end
end)