require "base/internal/ui/reflexcore"

Phy_BigClock =
{
	canPosition = true;
	userData = {};
};
registerWidget("Phy_BigClock");


-------------------------

function Phy_BigClock:initialize()
	self.userData = loadUserData();
	
	widgetCreateConsoleVariable("width", "int", 220);
	widgetCreateConsoleVariable("height", "int", 100);
	widgetCreateConsoleVariable("bg_r", "int", 0);
	widgetCreateConsoleVariable("bg_g", "int", 102);
	widgetCreateConsoleVariable("bg_b", "int", 204);
	widgetCreateConsoleVariable("bg_a", "int", 64);
	widgetCreateConsoleVariable("font_size", "float", 52);
	widgetCreateConsoleVariable("time_padding", "int", 20);
	
end


function Phy_BigClock:draw()

	if not shouldShowHUD() then return end;

	
	local text_col = Color(255,255,255,255);
	local box_col = Color(0,0,0,0);
	box_col.r =  widgetGetConsoleVariable("bg_r");
	box_col.g =  widgetGetConsoleVariable("bg_g");
	box_col.b =  widgetGetConsoleVariable("bg_b");
	box_col.a =  widgetGetConsoleVariable("bg_a");
	
	local box_width = widgetGetConsoleVariable("width");
	local box_height = widgetGetConsoleVariable("height");
	
	local font_size = widgetGetConsoleVariable("font_size");
	local font_pad = widgetGetConsoleVariable("time_padding");
	
	-- get time
	local time_string = "00:00";
	if (world.gameState == GAME_STATE_ACTIVE) or (world.gameState == GAME_STATE_ROUNDACTIVE) then
		local t = FormatTime(world.gameTime);
		time_string = string.format("%02d:%02d", t.minutes, t.seconds);
		
	end
	
	--local box_width = nvgTextBounds(time_string).maxx;
	
	-- draw bg
	nvgBeginPath();
	nvgRect(0,0,box_width,box_height);
	nvgFillColor(box_col);
	nvgFill();
	
	-- draw time string
	nvgFontFace("roboto-bold");
	nvgFontSize(font_size);
	nvgFontBlur(0);
	--nvgTextLetterSpacing(10);
	nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);
	nvgFillColor(text_col);
	nvgText(font_pad, box_height/2, time_string);
	
	
end