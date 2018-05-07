require "base/internal/ui/reflexcore"

Phy_Armor =
{
};
registerWidget("Phy_Armor");


-------------------------

function Phy_Armor:initialize()
	self.userData = loadUserData();
	
	widgetCreateConsoleVariable("alpha", "int", 255);
	widgetCreateConsoleVariable("height", "int", 200);
	
end


function Phy_Armor:draw()

	-- Figure out if we actually need to draw anything...
	if not shouldShowHUD() then return end;
	
	local player = getPlayer();
	-- Size
	local textHeight = widgetGetConsoleVariable("height");
	-- Colours
	local barAlpha = widgetGetConsoleVariable("alpha");

	local textColor;
	if player.armorProtection == 0 then textColor = Color(110, 232, 89, barAlpha) end
	if player.armorProtection == 1 then textColor = Color(232, 210, 89, barAlpha) end
	if player.armorProtection == 2 then textColor = Color(232, 89, 89, barAlpha) end
	if player.armor == 0 then textColor = Color(100, 100, 100, barAlpha) end
	
	
	-- draw...
	local player_armor_str = string.format("%03d", player.armor);

	
	nvgFillColor(textColor);
	nvgFontSize(textHeight);
	nvgFontFace(FONT_HUD);
	nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);
	nvgFontBlur(0);
	nvgText(0, 0, player_armor_str);
	
end