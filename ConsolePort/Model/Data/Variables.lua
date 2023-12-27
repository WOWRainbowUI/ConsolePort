-- Consts
local STICK_SELECT = {'Movement', 'Camera', 'Gyro'};
local MODID_SELECT = {'SHIFT', 'CTRL', 'ALT'};
local MODID_EXTEND = {'SHIFT', 'CTRL', 'ALT', 'CTRL-SHIFT', 'ALT-SHIFT', 'ALT-CTRL'};
local ADVANCED_OPT = RED_FONT_COLOR:WrapTextInColorCode(ADVANCED_OPTIONS);
local BINDINGS_OPT = '按鈕綁定' -- KEY_BINDINGS_MAC or 'Bindings';

-- Helpers
local BLUE = GenerateClosure(ColorMixin.WrapTextInColorCode, BLUE_FONT_COLOR)
local unpack, _, db = unpack, ...; _ = CPAPI.Define; db.Data();
------------------------------------------------------------------------------------------------------------
-- Default cvar data (global)
------------------------------------------------------------------------------------------------------------
db:Register('Variables', {
	showAdvancedSettings = {Bool(false);
		name = '所有設定';
		desc = '顯示所有可供調整的設定。';
		hide = true;
	};
	useCharacterSettings = {Bool(false);
		name = '角色專用';
		desc = '此角色使用角色專用的設定。';
		hide = true;
	};
	--------------------------------------------------------------------------------------------------------
	_'十字線';
	--------------------------------------------------------------------------------------------------------
	crosshairEnable = _{Bool(true);
		name = '啟用';
		desc = '啟用十字線讓你能夠保持看見隱藏的中心點游標位置。';
		note = '和 [@cursor] 巨集一起使用，只要點一下便能在標線處放置法術。';
	};
	crosshairSizeX = _{Number(24, 1, true);
		name = '寬度';
		desc = '十字線的寬度，以像素比例為單位。';
		advd = true;
	};
	crosshairSizeY = _{Number(24, 1, true);
		name = '高度';
		desc = '十字線的高度，以像素比例為單位。';
		advd = true;
	};
	crosshairCenter = _{Number(0.2, 0.05, true);
		name = '中心空隙';
		desc = '相當於十字線的整體大小。';
		advd = true;
	};
	crosshairThickness = _{Number(2, 0.025, true);
		name = '粗細';
		desc = '十字線的粗細，以像素比例為單位。';
		note = '數值小於 2 會呈現交錯，也可能不會。';
		advd = true;
	};
	crosshairColor = _{Color('ff00fcff');
		name = '顏色';
		desc = '十字線的顏色。';
	};
	--------------------------------------------------------------------------------------------------------
	_'Movement';
	--------------------------------------------------------------------------------------------------------
	mvmtAnalog = _{Bool(true);
		name = '類比移動';
		desc = '根據搖桿的角度做類比式的連續移動。';
		note = '停用此選項來使用傳統的分散式移動控制。';
	};
	mvmtStrafeAngleTravel = _{Range(tonumber(GetCVar('GamePadFaceMovementMaxAngle')) or 115, 5, 0, 180);
		name = '面向搖桿移動最大角度 (平時)';
		desc = '控制角色何時要從面向前方變成面向搖桿移動的方向，這是與正前方相差的角度。';
		note = '設為 0 時，會永遠面向搖桿移動的方向。\n設為最大值時，永遠不會面向搖桿移動的方向。';
	};
	mvmtStrafeAngleCombat = _{Range(tonumber(GetCVar('GamePadFaceMovementMaxAngleCombat')) or 115, 5, 0, 180);
		name = '面向搖桿移動最大角度 (戰鬥)';
		desc = '控制戰鬥中，角色何時要從面向前方變成面向搖桿移動的方向，這是與正前方相差的角度。';
		note = '設為 0 時，會永遠面向搖桿移動的方向。\n設為最大值時，永遠不會面向搖桿移動的方向。';
	};
	mvmtRunThreshold = _{Range(tonumber(GetCVar('GamePadRunThreshold')) or 0.5, 0.05, 0, 1);
		name = '跑步 / 走路的分界點';
		desc = '控制角色何時要從走路變成跑步。以您的總移動搖桿半徑的分數表示。';
	};
	mvmtTurnWithCamera = _{Map(tonumber(GetCVar('GamePadTurnWithCamera')) or 2, {[0] = NEVER, [1] = 'In Combat', [2] = ALWAYS});
		name = '角色隨鏡頭轉向';
		desc = '轉動鏡頭角度時，也要轉動角色的面向。';
	};
	mvmtStrafeAngleTravelMacro = _{String(nil);
		name = '面向搖桿移動的巨集條件 (平時)';
		desc = '用於取代平時面向搖桿移動最大角度的巨集條件。';
		note = '格式為...\n'
			.. BLUE'[條件] 角度; nil'
			.. '\n...使用分號分隔每個條件/角度， "nil" 表示不取代。';
		advd = true;
	};
	mvmtStrafeAngleCombatMacro = _{String(nil);
		name = '面向搖桿移動的巨集條件 (戰鬥)';
		desc = '用於取代戰鬥中面向搖桿移動最大角度的巨集條件。';
		note = '格式為...\n'
			.. BLUE'[條件] 角度; nil'
			.. '\n...使用分號分隔每個條件/角度， "nil" 表示不取代。';
		advd = true;
	};
	--------------------------------------------------------------------------------------------------------
	_( MOUSE_LABEL ); -- Mouse
	--------------------------------------------------------------------------------------------------------
	mouseHandlingEnabled = _{Bool(true);
		name = '啟用滑鼠處理';
		desc = '模擬滑鼠左右鍵時啟用自訂的滑鼠處理方式，自動切換游標和逾時。';
		note = '停用時，也會一併停用自動隱藏游標，以及切換把游標固定在中心點或自由移動。';
		advd = true;
	};
	mouseHandlingReversed = _{Bool(false);
		name = '反轉滑鼠處理';
		desc = '模擬的滑鼠左鍵切換中心點固定模式，而不是自由移動模式。模擬的滑鼠右鍵切換自由移動模式，而不是中心點固定模式。',
		note = '和 '..BLUE(INTERACT_ON_LEFT_CLICK_TEXT)..' 一起使用讓左鍵點擊和右鍵類似，並且不會有不小心進入戰鬥的風險。',
		advd = true;
	};
	mouseFreeCursorReticle = _{Map(0, {[0] = OFF, [1] = VIDEO_OPTIONS_ENABLED, [2] = TARGET});
		name = '游標瞄準';
		desc = '自由移動游標來瞄準，而不是將游標固定在中心點。';
		note = '游標瞄準就是放放地板技能。';
	};
	mouseHideCursorOnMovement = _{Bool(false);
		name = '移動時隱藏游標';
		desc = '開始移動時隱藏滑鼠游標，如果沒有其他阻擾的話。';
		note = '需要將 "設定 > 搖桿輸入時隱藏游標" 設為 "無"。';
	};
	mouseAlwaysCentered = _{Bool(false);
		name = '總是顯示滑鼠游標';
		desc = '控制鏡頭時，永遠將游標保持顯示在中心點。';
	};
	mouseShowCenterTooltip = _{Bool(true);
		name = '中心點游標顯示浮動提示資訊';
		desc = '游標在中心點時，顯示游標指向的目標的浮動提示資訊。';
	};
	mouseAutoControlPickup = _{Bool(true);
		name = '拾取時自動控制游標';
		desc = '拾取物品時，自動控制游標。';
		advc = true;
	};
	mouseAutoClearCenter = _{Number(2.0, 0.25, true);
		name = '自動隱藏游標';
		desc = '幾秒後要自動隱藏中心點的游標。';
		advd = true;
	};
	mouseFreeCursorEnableTime = _{Number(0.15, 0.05, true);
		name = '切換成自由移動游標';
		desc = '幾秒後要啟用自由移動游標。';
		note = '需要有足夠長的時間可以按下和放開按鈕。';
		advd = true;
	};
	doubleTapTimeout = _{Number(0.25, 0.05, true);
		name = '快速按兩下的時間';
		desc = '快速按兩下所選的輔助按鈕來切換顯示滑鼠游標的時間範圍。';
		advd = true;
	};
	doubleTapModifier = _{Select('<無>', '<無>', unpack(MODID_SELECT));
		name = '快速按兩下的輔助按鈕';
		desc = '快速按兩下哪個輔助按鈕時要切換顯示滑鼠游標。';
	};
	--------------------------------------------------------------------------------------------------------
	_'環形選單';
	--------------------------------------------------------------------------------------------------------
	radialStickySelect = _{Bool(false);
		name = '黏住選取項目';
		desc = '選擇環形中的項目後會將它黏住，直到選擇另一個項目。';
	};
	radialClearFocusTime = _{Number(0.5, 0.025);
		name = '自動隱藏環形選單';
		desc = '搖桿輸入過後幾秒要取消環形選單。';
	};
	radialScale = _{Number(1, 0.025, true);
		name = '選單縮放大小';
		desc = '所有環形選單的縮放大小，相對於整體介面縮放。';
		advd = true;
	};
	radialPreferredSize = _{Number(500, 25, true);
		name = '環形選單大小';
		desc = '環形選單的大小，以像素為單位。';
		advd = true;
	};
	radialActionDeadzone = _{Range(0.5, 0.05, 0, 1);
		name = '盲區';
		desc = '簡易環形選單的盲區。';
	};
	radialCosineDelta = _{Delta(1);
		name = '對調方向';
		desc = '搖桿方向和環形選擇區域的互動方式。';
		note = '+ 普通\n- 反轉';
		advd = true;
	};
	radialPrimaryStick = _{Select('Movement', unpack(STICK_SELECT));
		name = '主要搖桿';
		desc = '用來操作環形選單動作的搖桿。';
		note = '請確認所選擇的搖桿不會和其他按鍵設定衝突。';
	};
	radialRemoveButton = _{Button('PADRSHOULDER');
		name = '移除按鈕';
		desc = '從可編輯的環形選單中移除所選項目的按鈕。';
	};
	--------------------------------------------------------------------------------------------------------
	_'環形鍵盤';
	--------------------------------------------------------------------------------------------------------
	keyboardEnable = _{Bool(false);
		name = 'Enable';
		desc = '啟用畫面上的環形鍵盤，可以用來輸入文字。';
	};
	--------------------------------------------------------------------------------------------------------
	_'團隊游標';
	--------------------------------------------------------------------------------------------------------
	raidCursorScale = _{Number(1, 0.1);
		name = '縮放大小';
		desc = '游標的縮放大小。';
	};
	raidCursorMode = _{Map(1, {'重新導向', '專注目標', TARGET}),
		name = '選取目標模式';
		desc = '更改團隊游標如何取得目標。重新導向和專注目標模式將會在不改變當前目標的情況下對團隊游標指向的對象施放法術。';
		note = '基本的重新導向無法施放巨集或是對友方和敵方都可施放的法術，請使用選取目標或專注目標模式搭配 [@focus] 巨集來控制其行為。';
	};
	raidCursorModifier = _{Select('<無>', '<無>', unpack(MODID_EXTEND));
		name = '輔助鍵';
		desc = '要按下哪個輔助鍵，讓移動按鈕可以移動游標。';
		note = '正在使用游標時，組合按鈕中所設定的按鈕將無法使用。\n\n每個按鈕都可以設定輔助鍵。';
	};
	raidCursorUp = _{Button('PADDUP', true);
		name = '往上移動';
		desc = '將游標往上移動的按鈕。';
		advd = true;
	};
	raidCursorDown = _{Button('PADDDOWN', true);
		name = '往下移動';
		desc = '將游標往下移動的按鈕。';
		advd = true;
	};
	raidCursorLeft = _{Button('PADDLEFT', true);
		name = '往左移動';
		desc = '將游標往左移動的按鈕。';
		advd = true;
	};
	raidCursorRight = _{Button('PADDRIGHT', true);
		name = '往右移動';
		desc = '將游標往右移動的按鈕。';
		advd = true;
	};
	raidCursorFilter = _{String(nil);
		name = '過濾條件';
		desc = '用過濾條件來尋找團隊游標框架。';
		note = BLUE'node' .. ' 是目前正在審查的框架。';
		advd = true;
	};
	raidCursorWrapDisable = _{Bool(false);
		name = 'Disable Wrapping';
		desc = 'Prevent the cursor from wrapping when navigating.';
		advd = true;
	};
	--------------------------------------------------------------------------------------------------------
	_'介面游標';
	--------------------------------------------------------------------------------------------------------
	UIenableCursor = _{Bool(true);
		name = ENABLE;
		desc = '啟用介面游標。停用時會使用滑鼠操作的介面互動方式。';
	};
	UIWrapDisable = _{Bool(false);
		name = 'Disable Wrapping';
		desc = 'Prevent the cursor from wrapping when navigating.';
		advd = true;
	};
	--------------------------------------------------------------------------------------------------------
	_'單位快速鍵';
	--------------------------------------------------------------------------------------------------------
	unitHotkeyFocusMode = _{Bool(false);
		name = '使用專注目標模式';
		desc = '快速鍵會控制你的專注目標，而不是當前目標。';
	};
	unitHotkeyDefaultMode = _{Bool(false);
		name = '預設使用 '..BLUE(GetBindingName('TARGETNEARESTENEMY'));
		desc = '沒有選取目標時，快速鍵使用 '..BLUE(GetBindingName('TARGETNEARESTENEMY'))..'。';
	};
	unitHotkeyNamePlates = _{Bool(true);
		name = '在名條上顯示';
		desc = '在可作用的名條上顯示快速鍵提示。';
	};
	unitHotkeyGhostMode = _{Bool(false);
		name = '總是顯示';
		desc = '選取目標後，會在單位框架附近顯示快速鍵提示。';
	};
	unitHotkeyGhostAlpha = _{Number(0.5, 0.05, true);
		name = '無作用時的透明度';
		desc = '選取目標後，單位框架上無作用的快速鍵提示的透明度。';
	};
	unitHotkeySize = _{Number(CPAPI.IsClassicEraVersion and 32 or 24, 1);
		name = '大小';
		desc = '單位快速鍵的大小，以像素為單位。';
	};
	unitHotkeyOffsetX = _{Number(0, 1, true);
		name = '水平位置偏移';
		desc = '快速鍵提示的水平位置偏移，以像素為單位。';
		advd = true;
	};
	unitHotkeyOffsetY = _{Number(0, 1, true);
		name = '垂直位置偏移';
		desc = '快速鍵提示的垂直位置偏移，以像素為單位。';
		advd = true;
	};
	unitHotkeyTokens = _{String('party1-4; player; raid1-40; boss1-4; arena1-5; party1-4pet; raid1-40target');
		name = '可互動單位';
		desc = '設定可互動單位的條件，每種類型使用分號分隔。';
		note = 'E.g. '..BLUE('party1-4')..'; '..BLUE('player')..' will match party1, party2, party3, party4, and player.';
		advd = true;
	};
	unitHotkeySet = _{Select('Dynamic', 'Dynamic', 'Left', 'Right', 'Custom');
		name = '按鈕組合';
		desc = '單位快速鍵所使用的按鈕組合。';
		note = 'Dynamic 會使用不會和 '..BLUE'L[目標單位框架 (按住)]'..' 衝突的按鈕綁定。';
	};
	unitHotkeyButton1 = _{Button('PAD1');
		name = '組合按鈕 1';
		desc = '組合快速鍵 1 使用的按鈕。';
		note = '需要選擇 '..BLUE'按鈕組合'..' > '..BLUE'L[Custom]'..' 以便單獨控制每個按鈕。';
	};
	unitHotkeyButton2 = _{Button('PAD2');
		name = '組合按鈕 2';
		desc = '組合快速鍵 2 使用的按鈕。';
		note = '需要選擇 '..BLUE'按鈕組合'..' > '..BLUE'L[Custom]'..' 以便單獨控制每個按鈕。';
	};
	unitHotkeyButton3 = _{Button('PAD3');
		name = '組合按鈕 3';
		desc = '組合快速鍵 3 使用的按鈕。';
		note = '需要選擇 '..BLUE'按鈕組合'..' > '..BLUE'L[Custom]'..' 以便單獨控制每個按鈕。';
	};
	unitHotkeyButton4 = _{Button('PAD4');
		name = '組合按鈕 4';
		desc = '組合快速鍵 4 使用的按鈕。';
		note = '需要選擇 '..BLUE'按鈕組合'..' > '..BLUE'L[Custom]'..' 以便單獨控制每個按鈕。';
	};
	--------------------------------------------------------------------------------------------------------
	_( ACCESSIBILITY_LABEL ); -- Accessibility
	--------------------------------------------------------------------------------------------------------
	autoExtra = _{Bool(true);
		name = '自動加入任務道具';
		desc = '自動將已追蹤的任務物品和額外技能加入到主要工具環。';
	};
	autoSellJunk = _{Bool(true);
		name = '自動賣垃圾';
		desc = '和商人互動時自動賣出垃圾。';
	};
	UIscale = _{Number(1, 0.025, true);
		name = '整體縮放大小';
		desc = '縮放大部分的 ConsolePort 框架，相對於使用者介面縮放大小。';
		note = '快捷列的縮放大小是另外設定的。';
		advd = true;
	};
	--------------------------------------------------------------------------------------------------------
	_'電量';
	--------------------------------------------------------------------------------------------------------
	powerLevelShow = _{Bool(false);
		name = '顯示電量';
		desc = '顯示目前所使用的搖桿的電量。';
		note = '不支援使用藍牙連接的 Xbox 控制器，需要 Xbox 無線轉接器。';
	};
	powerLevelShowIcon = _{Bool(true);
		name = '顯示類型圖示';
		desc = '在目前所使用的搖桿電量旁邊顯示圖示。';
		note = '類型為 PlayStation、Xbox 或通用。';
	};
	powerLevelShowText = _{Bool(true);
		name = '顯示狀態文字';
		desc = '顯示目前所使用的搖桿電量的狀態文字。';
		note = '嚴重、低、中、高、有線/正在充電或未知/未連接。';
	};
	--------------------------------------------------------------------------------------------------------
	_( BINDINGS_OPT ); -- Bindings
	--------------------------------------------------------------------------------------------------------
	bindingOverlapEnable = _{Bool(false);
		name = '允許多重按鈕設定';
		desc = '允許設定多個連擊技到相同的按鈕。';
		advd = true;
	};
	bindingAllowSticks = _{Bool(false);
		name = '允許設定旋轉搖桿';
		desc = '讓搖桿的旋轉方向也能夠當成按鈕來設定功能';
		advd = true;
	};
	bindingShowExtraBars = _{Bool(false);
		name = '顯示所有快捷列';
		desc = '沒有姿勢形態的角色會顯示額外快捷列的設定。';
		advd = true;
	};
	bindingDisableQuickAssign = _{Bool(false);
		name = '停用快速指派';
		desc = '使用搖桿快捷列時，停用未設定按鈕組合的快速指派。';
		note = '需要重新載入介面。';
		advd = true;
	};
	bindingShowSpellMenuGrid = _{Bool(true);
		name = '選取法術時顯示快捷列格子';
		desc = '用游標選取法術時顯示快捷列的格子。';
	};
	disableHotkeyRendering = _{Bool(false);
		name = '不要顯示快速鍵';
		desc = '停用一般快捷列上風格化的快速鍵。';
		advd = true;
	};
	useAtlasIcons = _{Bool(not CPAPI.IsClassicEraVersion);
		name = '使用預設的快速鍵圖示';
		desc = '使用預設的快速鍵圖示，而不是 ConsolePort 提供的自訂圖示';
		note = '需要重新載入介面。';
		hide = CPAPI.IsClassicEraVersion;
	};
	emulatePADPADDLE1 = _{Pseudokey('none');
		name = '模擬 '..(KEY_PADPADDLE1 or '扳片 1');
		desc = '模擬扳片 1 按鈕的鍵盤按鍵。';
	};
	emulatePADPADDLE2 = _{Pseudokey('none');
		name = '模擬 '..(KEY_PADPADDLE2 or '扳片 2');
		desc = '模擬扳片 2 按鈕的鍵盤按鍵。';
	};
	emulatePADPADDLE3 = _{Pseudokey('none');
		name = '模擬 '..(KEY_PADPADDLE3 or '扳片 3');
		desc = '模擬扳片 3 按鈕的鍵盤按鍵。';
	};
	emulatePADPADDLE4 = _{Pseudokey('none');
		name = '模擬 '..(KEY_PADPADDLE4 or '扳片 4');
		desc = '模擬扳片 4 按鈕的鍵盤按鍵。';
	};
	interactButton = _{Button('PAD1', true):Set('none', true);
		name = '點擊用的按鈕';
		desc = '符合給定條件時用來點擊的按鈕或組合，其他時候則是一般的按鈕綁定。';
		note = '十字線搭配搖桿上方按鈕，可以很流暢且精準的互動。會點擊十字線或游標的位置。';
	};
	interactCondition = _{String('[vehicleui] nil; [@target,noharm][@target,noexists][@target,harm,dead] TURNORACTION; nil');
		name = '點擊啟用條件';
		desc = '啟用點擊用的按鈕的巨集判斷條件。沒有敵方目標時，預設條件會點擊滑鼠右鍵。';
		note = '格式為...\n'
			.. BLUE'[condition] bindingID; nil'
			.. '\n...使用分號來分隔每個判斷條件/按鈕設定，"nil" 表示不要切換按鈕。';
		advd = true;
	};
	--------------------------------------------------------------------------------------------------------
	_( ADVANCED_OPT ); -- Advanced
	--------------------------------------------------------------------------------------------------------
	actionPageCondition = _{String(nil);
		name = '切換快捷列條件';
		desc = '用巨集判斷條件來切換快捷列。';
		advd = true;
	};
	actionPageResponse = _{String(nil);
		name = '切換快捷列回應';
		desc = '對自訂處理條件做出的回應。';
		advd = true;
	};
	classFileOverride = _{String(nil);
		name = '其他佈景主題';
		desc = '用來取代職業佈景主題的介面風格。';
		advd = true;
	};
})  --------------------------------------------------------------------------------------------------------
