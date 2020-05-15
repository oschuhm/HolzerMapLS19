----------------------------------------------------------------------------------------------------
-- HolzerMap ItemsLoading SP/MP
----------------------------------------------------------------------------------------------------
-- Purpose:  Automatic loading of items in dependency of single/multiplayer game start
--
-- Copyright (c) [DSA]Floowy, 2020
--
-- Special credits and thanks to [LS-Modcompany]kevink98 for help
----------------------------------------------------------------------------------------------------

HolzerMap = {}
local HolzerMap_mt = Class(HolzerMap, Mission00)

function HolzerMap:new(baseDirectory, customMt, missionCollaborators)
    local mt = customMt
    if mt == nil then
        mt = HolzerMap_mt
    end
    local self = HolzerMap:superClass():new(baseDirectory, mt, missionCollaborators)

    -- Number of additional channels that are used compared to the original setting (2)
    local numAdditionalAngleChannels = 3;

    self.terrainDetailAngleNumChannels = self.terrainDetailAngleNumChannels + numAdditionalAngleChannels;
    self.terrainDetailAngleMaxValue = (2^self.terrainDetailAngleNumChannels) - 1;
    self.sprayLevelFirstChannel = self.sprayLevelFirstChannel + numAdditionalAngleChannels;
    self.plowCounterFirstChannel = self.plowCounterFirstChannel + numAdditionalAngleChannels;
    self.limeCounterFirstChannel = self.limeCounterFirstChannel + numAdditionalAngleChannels;
	self.terrainDetailHeightTypeNumChannels = self.terrainDetailHeightTypeNumChannels + 1;

    return self
end
function HolzerMap:loadMission00Finished()
   if (not self.missionInfo.isValid) and self.missionDynamicInfo.isMultiplayer then
      local modDesc = loadXMLFile("modDesc", self.baseDirectory .. "modDesc.xml")
      local key = "modDesc.maps.map#defaultItemsMPXMLFilename"
      if not hasXMLProperty(modDesc, key) then
         print("ERROR : xmlKey 'defaultItemsMPXMLFilename' not found! ")
      elseif hasXMLProperty(modDesc, key) then
         print("SUCCESS : Multiplayer Items loaded! ")   
      end
      self.missionInfo.itemsXMLLoad  = Utils.getFilename(getXMLString(modDesc, key), self.baseDirectory)

      key = "modDesc.maps.map#defaultVehiclesMPXMLFilename"
      if not hasXMLProperty(modDesc, key) then
         print("ERROR : xmlKey 'defaultVehiclesMPXMLFilename' not found! ")
      elseif hasXMLProperty(modDesc, key) then
         print("SUCCESS : Multiplayer VehicleItems loaded! ")	
      end;
      self.missionInfo.vehiclesXMLLoad  = Utils.getFilename(getXMLString(modDesc, key), self.baseDirectory)
   end
   HolzerMap:superClass().loadMission00Finished(self)
end