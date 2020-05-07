-- 
-- setAnimalCapacity
-- 
-- @Interface: --
-- @Author: LS-Modcompany / kevink98
-- @Date: 07.04.2019
-- @Version: 1.2.0.0
-- 
-- @Support: LS-Modcompany
-- 
-- Changelog:
--		
-- 	v1.2.0.0 (07.04.2019):
-- 		- set capacities
--		
-- 	v1.1.0.0 (14.01.2019):
-- 		- add parameters for all animalTypes
--		
-- 	v1.0.0.0 (09.01.2019):
-- 		- initial fs19 (kevink98)
-- 
-- Notes:
-- 
-- 
-- ToDo:
-- 		- Load values from xml (gc)
-- 

SetAnimalCapacity = {};
SetAnimalCapacity.parameters = {};

--		Change parameters here:				water		straw		food		foodSpillage 	pallets		manue		liquidManure 	milk
SetAnimalCapacity.parameters["CHICKEN"] = 	{5000, 		5000, 		5000, 		5000, 			5000, 		10000, 		10000, 			10000};
SetAnimalCapacity.parameters["COW"] = 		{7000, 		9000, 		20000, 		5000, 			5000, 		200000, 	200000, 		10000};
SetAnimalCapacity.parameters["SHEEP"] = 	{5000, 		5000, 		5000, 		5000, 			5000, 		10000, 		10000, 			10000};
SetAnimalCapacity.parameters["PIG"] = 		{7000, 		9000, 		10000, 		5000, 			5000, 		200000, 	200000, 		10000};
SetAnimalCapacity.parameters["HORSE"] = 	{5000, 		5000, 		5000, 		5000, 			5000, 		50000, 		10000, 			10000};

function SetAnimalCapacity:updateAnimalParameters()
    local averageWaterUsagePerDay = 0.0;
    local averageStrawUsagePerDay = 0.0;
    local averageFoodUsagePerDay = 0.0;
    local averageFoodSpillageProductionPerDay = 0.0;
    local averagePalletsProductionPerDay = 0.0;
    local averageManureProductionPerDay = 0.0;
    local averageLiquidManureProductionPerDay = 0.0;
    local averageMilkProductionPerDay = 0.0;
	
    for _, animal in ipairs(self.animals) do
        local subType = animal:getSubType();
        local input  = subType.input;
        local output  = subType.output;
        averageWaterUsagePerDay = averageWaterUsagePerDay + input.waterPerDay;
        averageStrawUsagePerDay = averageStrawUsagePerDay + input.strawPerDay;
        averageFoodUsagePerDay = averageFoodUsagePerDay + input.foodPerDay;
        averageFoodSpillageProductionPerDay = averageFoodSpillageProductionPerDay + output.foodSpillagePerDay;
        averagePalletsProductionPerDay = averagePalletsProductionPerDay + output.palletsPerDay;
        averageManureProductionPerDay = averageManureProductionPerDay + output.manurePerDay;
        averageLiquidManureProductionPerDay = averageLiquidManureProductionPerDay + output.liquidManurePerDay;
        averageMilkProductionPerDay = averageMilkProductionPerDay + output.milkPerDay;
    end
	
    local numAnimals = #self.animals;
	self.owner:setModuleParameters("water", SetAnimalCapacity.parameters[self.animalType][1], averageWaterUsagePerDay / numAnimals);
    self.owner:setModuleParameters("straw", SetAnimalCapacity.parameters[self.animalType][2], averageStrawUsagePerDay / numAnimals);
    self.owner:setModuleParameters("food", SetAnimalCapacity.parameters[self.animalType][3], averageFoodUsagePerDay / numAnimals);
    self.owner:setModuleParameters("foodSpillage", SetAnimalCapacity.parameters[self.animalType][4], averageFoodSpillageProductionPerDay / numAnimals);
    self.owner:setModuleParameters("pallets", SetAnimalCapacity.parameters[self.animalType][5], averagePalletsProductionPerDay / numAnimals);
    self.owner:setModuleParameters("manure", SetAnimalCapacity.parameters[self.animalType][6], averageManureProductionPerDay / numAnimals);
    self.owner:setModuleParameters("liquidManure", SetAnimalCapacity.parameters[self.animalType][7], averageLiquidManureProductionPerDay / numAnimals);
    self.owner:setModuleParameters("milk", SetAnimalCapacity.parameters[self.animalType][8], averageMilkProductionPerDay / numAnimals);
end

HusbandryModuleAnimal.updateAnimalParameters = Utils.overwrittenFunction(HusbandryModuleAnimal.updateAnimalParameters, SetAnimalCapacity.updateAnimalParameters);