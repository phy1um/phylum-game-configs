require "base/internal/ui/reflexcore"

PhyPhy_ArmorBar01 =
{
};
registerWidget("PhyPhy_ArmorBar01");


-------------------------


function PhyPhy_ArmorBar01:draw()

	-- Figure out if we actually need to draw anything...
	if not shouldShowHUD() then return end;
	
	local player = getPlayer();
	
	-- Options
	local showFrame = true;
	local showIcon = true;
	local flatBar = true;
	local colorNumber = false;
	local colorIcon = false;
	-- Size
	local globalHeight = 200;
	local frameMiddleHeight = globalHeight / 2.0;
	local textOffset;
	--local textWidthLong = globalHeight * 0.907;
	--local textWidthShort = globalHeight * 0.773;
	local textWidthLong = globalHeight * 0.773;
	local textWidthShort = globalHeight * 0.773;
	
	local textHeightOffset = frameMiddleHeight;
	local iconHeight = globalHeight/4;
	
	if showIcon then iconSpacing = 40
	else iconSpacing = 0;
	end
	
	-- Colours
	local frameColor = Color(0,0,0,128);
	local barAlpha = 160;
	local iconAlpha = 32;
	
	local iconColor;
	if player.armorProtection == 0 then iconColor = Color(2,167,46, barAlpha) end
	if player.armorProtection == 1 then iconColor = Color(245,215,50, barAlpha) end
    if player.armorProtection == 2 then iconColor = Color(236,0,0, barAlpha) end
	
	
	-- draw...
	nvgFontSize(globalHeight);
	nvgFontFace(FONT_HUD);
	nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
	
	if player.armor> 100 then
		textOffset = textWidthLong;
	else
		textOffset = textWidthShort;
	end
	
	nvgFillColor(Color(200, 200, 200, 200));
	nvgText(textOffset, 0, player.armor);
	
	if showIcon then
		nvgFillColor(iconColor);
		nvgSvg("internal/ui/icons/armor", 0, 0, iconHeight);
		
		--nvgFontSize(200);
		--nvgFontFace(FONT_HUD);
		--nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
		--nvgFontBlur(0);
		--nvgFillColor(Color(50,50,50,255));
		--nvgText(-200, -200, iconOffset);
		
	end
	
	end