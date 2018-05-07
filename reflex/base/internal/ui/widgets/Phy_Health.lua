require "base/internal/ui/reflexcore"

Phy_Health =
{
};
registerWidget("Phy_Health");


-------------------------

function Phy_Health:initialize()
	self.userData = loadUserData();
	
	widgetCreateConsoleVariable("alpha", "int", 255);
	widgetCreateConsoleVariable("height", "int", 200);
	
end


function Phy_Health:draw()

	-- Figure out if we actually need to draw anything...
	if not shouldShowHUD() then return end;
	
	local player = getPlayer();
	-- Size
	local textHeight = widgetGetConsoleVariable("height");
	local iconHeight = textHeight/8;

	
	-- Colours
	local barAlpha = widgetGetConsoleVariable("alpha");
	local iconAlpha = 32;
	
	local col_mega = Color(180, 111, 255, barAlpha);
	
	local textColor;
	if player.health > 100 then textColor = Color(60, 180, 220, barAlpha) end
	if player.health <= 100 then textColor = Color(240, 240, 240, barAlpha) end
	if player.health <= 60 then textColor =  Color(230, 190, 70, barAlpha) end
	if player.health <= 30 then textColor =  Color(230, 20, 20, barAlpha) end
	
	
	-- draw...
	local player_health_str = string.format("%03d", player.health);
	
	if player.hasMega then
		nvgFillColor(col_mega);
		nvgSvg("internal/ui/icons/health", 0, 0, iconHeight)
	else 
		nvgFillColor(textColor);
	end
	
	nvgFontSize(textHeight);
	nvgFontFace(FONT_HUD);
	nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);
	nvgFontBlur(0);
	nvgText(iconHeight, 0, player_health_str);
	
	end