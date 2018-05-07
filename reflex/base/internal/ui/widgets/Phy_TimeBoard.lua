--------------------------------------------------------------------------------
-- This is an official Reflex script. Do not modify.
--
-- If you wish to customize this widget, please:
--  * clone this file to a new file
--  * rename the widget MyWidget
--  * set this widget to not visible (via options menu)
--  * set your new widget to visible (via options menu)
--
--------------------------------------------------------------------------------

require "base/internal/ui/reflexcore"

Phy_TimeBoard =
{
	canPosition = false
};
registerWidget("Phy_TimeBoard");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function sortByScore(a, b)
	-- sort by state first, so we get editor/specs at bottom
	if a.state ~= b.state then
		return a.state < b.state;
	end

	-- sort by score next
	if a.score ~= b.score then
		return a.score > b.score;
	end

	-- otherwise, sort by name (so we don't get random sorting if two players have same score)
	return a.name < b.name;
end

local function sortForRaceMode(a, b)
	-- sort by state first, so we get editor/specs at bottom
	if a.state ~= b.state then
		return a.state < b.state;
	end

	-- 0 (not finish) we want at bottom
	local ascore = a.score;
	local bscore = b.score;
	if ascore == 0 then ascore = 1000000000; end
	if bscore == 0 then bscore = 1000000000; end

	-- sort by score next
	-- (LOWER IS BETTER)
	if ascore ~= bscore then
		return ascore < bscore;
	end

	-- otherwise, sort by name (so we don't get random sorting if two players have same score)
	return a.name < b.name;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function DrawRow(x, y, name, state, lag, pl, colorFirst, colorRest)
	
	nvgFontSize(30);
	nvgFontFace(FONT_HUD);
	nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);

	local strings = {};
	strings[1] = name;
	strings[2] = state;
	strings[3] = lag;
	strings[4] = pl;

	local offsets = {};
	offsets[1] = 10;
	offsets[2] = 240;
	offsets[3] = 350;
	offsets[4] = 410;

	for i = 1,4 do
		local text = strings[i];
		local px = x + offsets[i];
		local col = (i == 1) and colorFirst or colorRest;

		-- bg
		nvgFontBlur(2);
		nvgFillColor(Color(0, 0, 0));
		nvgText(px, y + 1, text);

		-- foreground
		nvgFontBlur(0);
		nvgFillColor(col);
		nvgText(px, y, text);
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Phy_TimeBoard:draw()
	
    -- Early out if HUD shouldn't be shown.
    --if not shouldShowHUD() then return end;
	if not showScores and world.gameState ~= GAME_STATE_GAMEOVER then return end;
	if replayName == "menu" then return end;
	
	-- inspect gamemode
	local gameMode = gamemodes[world.gameModeIndex];
	if not gameMode then return end;

	local colScores = Color(190, 170, 170);
	local colBorder = Color(150, 150, 150, 150);
	local rowHeight = 30;

	-- discover connected players
	local connectedPlayerCount = 0;
	local connectedPlayers = {};
	for k, v in pairs(players) do
		if v.connected then
			connectedPlayerCount = connectedPlayerCount + 1;
			connectedPlayers[connectedPlayerCount] = v;
		end
	end

	-- discover local player
	local localPlayer = players[playerIndexLocalPlayer];
	if not localPlayer then return end;

	-- count rows, this is actually a bit of a pain if it's a team game!
	local rows = 0;
	if gameMode.hasTeams then
		local teamRows = {};
		teamRows[1] = 0;
		teamRows[2] = 0;
		for index = 1, connectedPlayerCount do
			local player = connectedPlayers[index];
			if player.state == PLAYER_STATE_INGAME then
				teamRows[player.team] = teamRows[player.team] + 1;
			else
				rows = rows + 1;
			end
		end
		rows = rows + math.max(teamRows[1], teamRows[2]);

		-- extra row for team score
		rows = rows + 1;
	else
		rows = connectedPlayerCount;
	end

	local normalWidth = 450;
	local w = gameMode.hasTeams and normalWidth * 2 or normalWidth;
	local h = (rows+1)*rowHeight+10;

	local x = -w/2;
	local y = -h/2 - viewport.height/5;

	-- draw bg
	nvgBeginPath();
	nvgRoundedRect(x, y, w, h, 10);
	nvgFillColor(Color(34+10, 36+10, 40+10, 150));
	nvgFill();
	nvgStrokeColor(colBorder);
	nvgStroke();
	
	-- behind header
	nvgBeginPath();	
	nvgRoundedRect(x+4, y+4, w-8, 33, 10);
	nvgFillColor(Color(34+20, 36+20, 40+20, 50));
	nvgFill();
	
	-- draw header
	local gameState = "Game ON";
	if world.gameState == GAME_STATE_WARMUP then gameState = "Warmup" end;
	if world.gameState == GAME_STATE_GAMEOVER then gameState = "Game Over"; end;
	local iy = y + 20;
	DrawRow(x, iy, gameMode.name, gameState, "Lag", "PL", Color(130, 200, 240), Color(100, 200, 190));
	iy = iy + rowHeight;

	-- draw separator
	nvgBeginPath();
	nvgMoveTo(x, iy-16);
	nvgLineTo(x + w, iy-16);
	nvgStrokeColor(colBorder);
	nvgStroke();
	
	-- sort players by score
	if gameMode.shortName == "race" then
		table.sort(connectedPlayers, sortForRaceMode);
	else
		table.sort(connectedPlayers, sortByScore);
	end

	-- teams header
	if gameMode.hasTeams then
		DrawRow(x, iy, world.teams[1].name, world.teams[1].score, "", "", Color(180, 180, 190), colScores);
		DrawRow(x+normalWidth, iy, world.teams[2].name, world.teams[2].score, "", "", Color(180, 180, 190), colScores);
		
		iy = iy + rowHeight;
	end

	-- draw players
	local foundNonPlayerType = false;
	local teamy = {};
	teamy[1] = iy;
	teamy[2] = iy;
	for index = 1, connectedPlayerCount do
		local player = connectedPlayers[index];
		
		local state = player.score;
		
		if gameMode.shortName == "race" then
			if player.score == 0 then
				state = "(no finish)";
			else
				state = FormatTimeToDecimalTime(player.score);
			end
		end

		if world.gameState == GAME_STATE_WARMUP then
			if gameMode.requiresReadyUp then
				state = player.ready and "(Ready)" or "(Notready)";
			else
				state = "(Warmup)";
			end
		end

		local playerIsFriendly = (player == localPlayer);
		if gameMode.hasTeams then
			playerIsFriendly = player.team == localPlayer.team;
		end

		local team = gameMode.hasTeams and player.team or 1;

		-- pull team colours from engine
		local colName = teamColors[player.team];

		-- soon as we get past our players, we put everyone on the left (team 1)
		if player.state ~= PLAYER_STATE_INGAME then
			team = 1;

			-- is this our first spec/editor
			if not foundNonPlayerType then
				teamy[1] = math.max(teamy[1], teamy[2]) + 4;

				-- draw separator
				nvgBeginPath();
				nvgMoveTo(x, teamy[1]-16);
				nvgLineTo(x + w, teamy[1]-16);
				nvgStrokeColor(colBorder);
				nvgStroke();

				foundNonPlayerType = true;
			end
		end
		
		-- display spec/queued/editors specially
		-- (we'll change color if they're spec/queue/editor etc)
		if player.state == PLAYER_STATE_SPECTATOR then
			colName = Color(210, 210, 210);
			state = "(Spec)";
		end
		if player.state == PLAYER_STATE_EDITOR then
			colName = Color(210, 210, 210);
			state = "(Editor)";
		end
		if player.state == PLAYER_STATE_QUEUED then
			colName = Color(210, 210, 210);
			state = "(Queued "..player.queuePosition..")";
		end

		local py = teamy[team];
		local px = x + normalWidth * (team-1);
		local name = player.name;
		if player.isReferee then
			name = "(ref) " .. name;
		end
		DrawRow(px, py, name, state, player.latency, player.packetLoss, colName, colScores);
		teamy[team] = teamy[team] + rowHeight;
		
		-- extra bit
		nvgFillColor(Color(255,255,255,255));
		nvgFontFace("roboto-bold");
		nvgFontSize(60);
		nvgFontBlur(0);
		--nvgTextLetterSpacing(10);
		nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
		local time_string = "00:00";
		if (world.gameState == GAME_STATE_ACTIVE) or (world.gameState == GAME_STATE_ROUNDACTIVE) then
			local t = FormatTime(world.gameTime);
			time_string = string.format("%02d:%02d", t.minutes, t.seconds);
			
		end
		nvgText(0, -400, time_string);
	end
end
