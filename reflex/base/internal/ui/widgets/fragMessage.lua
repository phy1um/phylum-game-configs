require "base/internal/ui/reflexcore"

fragMessage =
{
	canPosition = true;
	userData = {};
};
registerWidget("fragMessage");


-------------------------

function fragMessage:initialize()
	self.userData = loadUserData();
	widgetCreateConsoleVariable("font_r", "int", 255);
	widgetCreateConsoleVariable("font_g", "int", 255);
	widgetCreateConsoleVariable("font_b", "int", 255);
	widgetCreateConsoleVariable("font_size", "float", 52);
	
end


function fragMessage:draw()

	if not shouldShowHUD() then return end;
	
	local text_col = Color(
		widgetGetConsoleVariable("font_r"),
		widgetGetConsoleVariable("font_g"),
		widgetGetConsoleVariable("font_b"),
		255
	);
	
	local font_size = widgetGetConsoleVariable("font_size");
	
	local frag_msg = "YOU FRAGGED "
	local target = "phylum"
	
	frag_msg = frag_msg .. target
	local msg_pos = nvgTextBounds(frag_msg)
	local string_xpos = msg_pos.maxx
	
	-- draw time string
	nvgFontFace("oswald-bold");
	nvgFontSize(font_size);
	nvgFontBlur(0);
	--nvgTextLetterSpacing(10);
	nvgTextAlign(NVG_ALIGN_MIDDLE, NVG_ALIGN_MIDDLE);
	
	nvgFillColor(Color(0,0,0,255));
	nvgText(string_xpos*1.5 + 4, 4, frag_msg);
	nvgFillColor(text_col);
	nvgText(string_xpos*1.5, 0, frag_msg);

end