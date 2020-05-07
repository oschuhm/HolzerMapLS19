-- by modelleicher
-- www.ls-modcompany.de
-- 05.01.2019
-- Version 1.0 


animalLimitIncreaser = {};
addModEventListener(animalLimitIncreaser);

function animalLimitIncreaser:loadMap(name)
	AnimalHusbandry.GAME_LIMIT = 32.00000;
	print("New Animal Husbandry Limit: 32");
end;

function animalLimitIncreaser:update(dt)
end
function animalLimitIncreaser:deleteMap()
end;
function animalLimitIncreaser:draw()
end;
function animalLimitIncreaser:mouseEvent(posX, posY, isDown, isUp, button)
end;
function animalLimitIncreaser:keyEvent(unicode, sym, modifier, isDown)
end;



