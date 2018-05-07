require "base/internal/ui/reflexcore"

Phy_Weapons = {
	canPosition = true;
};
registerWidget("Phy_Weapons");

function Phy_Weapons:initialize()
	
	--widgetCreateConsoleVariable()
	widgetCreateConsoleVariable("elem_width", "int", 38);
	widgetCreateConsoleVariable("elem_height", "int", 16);
	widgetCreateConsoleVariable("elem_space", "int", 5);
	widgetCreateConsoleVariable("bg_alpha", "int", 120);
	widgetCreateConsoleVariable("icon_size", "int", 10);
	widgetCreateConsoleVariable("text_size", "int", 12);
	widgetCreateConsoleVariable("draw_bg", "int", 1);
	widgetCreateConsoleVariable("draw_axe", "int", 0);
	
end

function Phy_Weapons:draw()

	if not shouldShowHUD() then return end;
	local player = getPlayer();
	
	local elem_width = widgetGetConsoleVariable("elem_width");
	local elem_height = widgetGetConsoleVariable("elem_height");
	local elem_space = widgetGetConsoleVariable("elem_space");
	
	local bg_alpha = widgetGetConsoleVariable("bg_alpha");
	local bg_colour = nil;
	
	if widgetGetConsoleVariable("draw_bg") == 1 then 
		bg_color = Color(20, 20, 20, bg_alpha) end
		
	local icon_size = widgetGetConsoleVariable("icon_size");
	local text_size = widgetGetConsoleVariable("text_size");
	
	local draw_axe = false;
	if widgetGetConsoleVariable("draw_axe") == 1 then
		draw_axe = true end
		
	local wx = 0;
	local wy = 0;
	for weapon_index = 1, 8 do
		if weapon_index == 1 and draw_axe == false then
			goto continue
		end
		
		drawWeaponElem(wx, wy, elem_width, elem_height, bg_color,
			icon_size, text_size, weapon_index, player.weapons[weapon_index]);
		
		
		::continue::
		wy = wy + elem_height + elem_space;
	end
	
end



function drawWeaponElem(x, y, w, h, bg, r, t, wi, wep)
	
	local w_icon = "internal/ui/icons/weapon" ..wi;
	-- draw background
	if bg then
		nvgBeginPath();
		nvgRoundedRect(x, y, w, h, 3);
		nvgFillColor(bg);
		nvgFill();
	end
	
	-- if we don't have the gun
	if not wep.pickedup then
		-- draw the icon in grey
		-- and no number
		nvgFillColor(Color(128, 128, 128, 255));
		nvgSvg(w_icon, x + r+ r/2, (y+y+h)/2 + 1, r);
		
	else
		-- draw colour icon
		nvgFillColor(wep.color);
		nvgSvg(w_icon, x + r + r/2, (y+y+h)/2 + 1, r);
		-- draw ammo text
		nvgFontSize(t);
		nvgFontFace(FONT_HUD);
		nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);
		nvgFontBlur(0);
		nvgFillColor(Color(255,255,255,255));
		nvgText(x + r+r+r, (y+y+h)/2 + 1, wep.ammo);
	end

end