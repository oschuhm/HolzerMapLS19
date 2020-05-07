clipDistanceControl = {}

local clipDistanceControl_mt = Class(clipDistanceControl)

function clipDistanceControl.onCreate(id)
    g_currentMission:addNonUpdateable(clipDistanceControl:new(id))
end
  
function clipDistanceControl:new(id, customMt)

	if (g_currentMission.CDC_savedDistances == nil) then
		g_currentMission.CDC_savedDistances = {}
	end

	local self = {}
	if (customMt ~= nil) then
		setmetatable(self, customMt)
	else
		setmetatable(self, clipDistanceControl_mt)
	end

	self.triggerId = id
	addTrigger(id, "clipDistanceControlCallback", self)
	
	self.savedCD = {}
	self.innerClipDistance = Utils.getNoNil(getUserAttribute(id, "innerClipDistance"), 100)

	return self
end

function clipDistanceControl:delete()
	if (self.triggerId ~= nil) then
		removeTrigger(self.triggerId)
	end
end

function clipDistanceControl:clipDistanceControlCallback(triggerId, otherId, onEnter, onLeave, onStay, otherShapeId)

	local vehicle = g_currentMission.nodeToObject[otherId]

	
	local gcmData = g_currentMission.CDC_savedDistances

	if (vehicle ~= nil) then


		if (onEnter) then
		
			local cd = getClipDistance(otherId)

			if (cd ~= nil and self.savedCD[otherId] == nil) then
			
				if (gcmData[otherId] == nil) then
				
					gcmData[otherId] = cd
				end
			
				self.savedCD[otherId] = cd
			
				setClipDistance(otherId, self.innerClipDistance)

			end
		end

		if (onLeave) then
			
			local cd = gcmData[otherId]

			if (cd ~= nil) then
				self.savedCD[otherId] = nil
				gcmData[otherId] = nil
				setClipDistance(otherId, cd)
			end
		end
	end
end

g_onCreateUtil.addOnCreateFunction("clipDistanceControl", clipDistanceControl.onCreate)