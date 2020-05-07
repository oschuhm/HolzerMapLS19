--
-- EnhancedWeighStation
--
-- @Interface: 1.3.0.1 (b4007)
-- @Author: LS-Modcompany / GtX
-- @Date: 24.03.2019
-- @Version: 1.0.0.0
--
-- @Support: https://ls-modcompany.com
--
-- Changelog:
--
-- 	v1.0.0.0 (24.03.2019):
-- 		- initial fs19
--
-- Notes:
--	Based on original code / idea by GIANTS Software GmbH.
--	Fixes error when bales are in the trigger and adds support for log weights.
-- 	Adds support for placeable 'WeighStation'.
--
--


EnhancedWeighStation = {};
local EnhancedWeighStation_mt = Class(EnhancedWeighStation);

function EnhancedWeighStation.onCreate(id)
	g_currentMission:addNonUpdateable(EnhancedWeighStation:new(id));
end;

function EnhancedWeighStation:new(triggerId)
	local self = {};
	setmetatable(self, EnhancedWeighStation_mt);

	if triggerId ~= nil then
		self:load(triggerId);
	end;

	return self;
end;

function EnhancedWeighStation:load(triggerId, displayNumbers, showZero)
	self.triggerId = triggerId;
	addTrigger(triggerId, "triggerCallback", self);

	self.isEnabled = true;
	self.triggerVehicles = {};
	self.triggerObjects = {};

	if displayNumbers ~= nil then
		self.displayNumbers = displayNumbers;
		self.showZero = showZero;
	else
		local weightDisplayIndex = getUserAttribute(triggerId, "weightDisplayIndex");
		if weightDisplayIndex ~= nil then
			self.displayNumbers = I3DUtil.indexToObject(triggerId, weightDisplayIndex);
			self.showZero = Utils.getNoNil(getUserAttribute(triggerId, "weightDisplayShowZero"), true);
		end;
	end;

	self:updateDisplayNumbers(0)

	return self.displayNumbers ~= nil;
end;

function EnhancedWeighStation:delete()
	if self.triggerId ~= nil then
		removeTrigger(self.triggerId);
		self.triggerId = nil;
	end;
end;

function EnhancedWeighStation:updateDisplayNumbers(mass)
	if self.displayNumbers ~= nil then
		I3DUtil.setNumberShaderByValue(self.displayNumbers, math.floor(mass), 0, self.showZero);
	end;
end;

function EnhancedWeighStation:updateWeight()
	local mass = 0;

	for vehicle, _ in pairs (self.triggerVehicles) do
		mass = mass + vehicle:getTotalMass()
	end;

	for object, _ in pairs (self.triggerObjects) do
		mass = mass + getMass(object);
	end;

	self:updateDisplayNumbers(mass * 1000);
end;

function EnhancedWeighStation:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
	if self.isEnabled and (onEnter or onLeave) then
		local vehicle, object;

		local nodeToObject = g_currentMission.nodeToObject[otherId];
		if nodeToObject ~= nil then
			if nodeToObject.getTotalMass ~= nil then
				vehicle = nodeToObject; -- Vehicles
			else
				if nodeToObject.isa ~= nil and nodeToObject:isa(Bale) then
					object = otherId; -- Bales
				end;
			end;
		else
			if getHasClassId(otherId, ClassIds.MESH_SPLIT_SHAPE) then
				object = otherId; -- Logs
			end;
		end;

		if onEnter then
			if vehicle ~= nil then
				if self.triggerVehicles[vehicle] == nil then
					self.triggerVehicles[vehicle] = 0;
				end;
				self.triggerVehicles[vehicle] = self.triggerVehicles[vehicle] + 1;
			elseif object ~= nil then
				if self.triggerObjects[object] == nil then
					self.triggerObjects[object] = 0;
				end;
				self.triggerObjects[object] = self.triggerObjects[object] + 1;
			end;
		else
			if vehicle ~= nil then
				self.triggerVehicles[vehicle] = self.triggerVehicles[vehicle] - 1;
				if self.triggerVehicles[vehicle] == 0 then
					self.triggerVehicles[vehicle] = nil;
				end;
			elseif object ~= nil then
				self.triggerObjects[object] = self.triggerObjects[object] - 1;
				if self.triggerObjects[object] == 0 then
					self.triggerObjects[object] = nil;
				end;
			end;
		end;

		self:updateWeight();
	end;
end;

if g_modManager:isModMap(g_currentModName) then
	print("  Register modOnCreate: EnhancedWeighStation");
	g_onCreateUtil.addOnCreateFunction("EnhancedWeighStation", EnhancedWeighStation.onCreate);
end;

-- local placeablePath = g_currentModDirectory .. "scripts/WeighStationPlaceable.lua";
-- if fileExists(placeablePath) then
	-- g_placeableTypeManager:addPlaceableType("WeighStationPlaceable", "WeighStationPlaceable", placeablePath);
-- end;



