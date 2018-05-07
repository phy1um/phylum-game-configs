require "base/internal/ui/reflexcore"

Phy_Ammo =
{
};
registerWidget("Phy_Ammo");


--------------
--------------

function Phy_Ammo:initialize()
	-- blah blah
	widgetCreateConsoleVariable("width", "int", 100);
	widgetCreateConsoleVariable("height", "int", 40);
	widgetCreateConsoleVariable("icon_radius", "int", 32);
	widgetCreateConsoleVariable("left_pad", "int", 20);
	widgetCreateConsoleVariable("red_zero", "int", 1);
	widgetCreateConsoleVariable("low_value_1", "int", 10);
	widgetCreateConsoleVariable("low_value_2", "int", 65);
	widgetCreateConsoleVariable("bg_alpha", "int", 199);
	widgetCreateConsoleVariable("bg_draw", "int", 1);
	widgetCreateConsoleVariable("font_size", "int", 30);
	widgetCreateConsoleVariable("font_big_size", "int", 40);
end


function Phy_Ammo:draw()

	if not shouldShowHUD() then return end;
	local player = getPlayer();
	
	-- get the weapon info we need, copied from the default
	local weaponIndexSelected = player.weaponIndexSelected;
	local weapon = player.weapons[weaponIndexSelected];
	local ammo = weapon.ammo;
	
	-- get values from the console
	local width = widgetGetConsoleVariable("width");
	local height = widgetGetConsoleVariable("height");
	local bg_alpha = widgetGetConsoleVariable("bg_alpha");
	-- bool to control background rectangle drawing
	local bg_draw = false;
	if widgetGetConsoleVariable("bg_draw") == 1 then bg_draw = true end
	
	-- these will make sense later
	local low_1 = widgetGetConsoleVariable("low_value_1");
	local low_2 = widgetGetConsoleVariable("low_value_2");
	
	local icon_size = widgetGetConsoleVariable("icon_radius");
	local left_pad = widgetGetConsoleVariable("left_pad");
	
	local low_ammo_col = Color(230, 100, 0, 255);
	local text_col = Color(255, 255, 255, 255);
	local text_size = widgetGetConsoleVariable("font_size");
	local text_zero_size = widgetGetConsoleVariable("font_big_size");
	
	local red_zero = false;
	-- bool for if we do a big red 0 when we run out of ammo
	if widgetGetConsoleVariable("red_zero") == 1 then red_zero = true end
	
	-- if we don't have ammo, don't draw it!
	if weaponIndexSelected == 1 or isRaceMode() then ammo = " " end
	
	-- get the icon
	local svg_name = "internal/ui/icons/weapon" .. weaponIndexSelected;
	-- and the colour but maybe not like this?
	local icon_color = player.weapons[weaponIndexSelected].color;
	
	-- if we need a rectangle...
	if bg_draw then
		-- draw a rectangle
		nvgBeginPath();
		nvgRoundedRect(0, 0, width, height, 5);
		nvgFillColor(Color(0,0,0,bg_alpha));
		nvgFill();
	end
	
	-- get ammo text colour based on ammo count AND weapon out
	if weaponIndexSelected == 5 or weaponIndexSelected == 7 then
		if ammo < low_2 then text_col = low_ammo_col end
	end
	-- ...
	if weaponIndexSelected == 2 or  weaponIndexSelected == 3 or weaponIndexSelected == 4 
		or  weaponIndexSelected == 6 or  weaponIndexSelected == 8 then
		if ammo < low_1 then text_col = low_ammo_col end
	end
	
	-- if we're out of ammo draw a fucking big red 0
	if red_zero and ammo == 0 then 
		text_col = Color(255, 0, 0, 255);
		text_size = text_zero_size;
	end
	
	-- this should be right to set the colour yeah??
	nvgFillColor(icon_color);
	nvgSvg(svg_name, left_pad, height/2 + 1, icon_size);
	
	-- draw the ammo text
	nvgFontBlur(0);
	nvgFillColor(text_col);
	nvgFontSize(text_size);
	nvgFontFace(FONT_HUD);
	nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);
	
	nvgText(left_pad + icon_size + 10, height/2 + 1, ammo);
end