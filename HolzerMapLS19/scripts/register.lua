
function changetext()
i = g_currentMission.landscapingController.paintGroundTypeIndex
local Painttext = g_i18n:getText("groundtype_"..g_currentMission.landscapingController.groundTypes[i])
g_currentMission.loadingScreen.missionCollaborators.landscapingScreen.paintTextureLabel.text = Painttext
end

LandscapingScreen.displayPaintMaterial = Utils.appendedFunction(LandscapingScreen.displayPaintMaterial, changetext)


