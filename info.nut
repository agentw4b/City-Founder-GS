require("version.nut");

class TownFounderClass extends GSInfo {
	function GetAuthor()		{ return "Agentw4b_CZ"; }
	function GetName()			{ return "City Founder GS"; }
	function GetDescription() 	{ return "City Founder GS is for founding towns."; }
	function GetVersion()		{ return SELF_VERSION; }
	function GetDate()			{ return "2020-4-15"; }
	function CreateInstance()	{ return "TownFounderClass"; }
	function GetShortName()		{ return "CFGS"; } 
	function GetAPIVersion()	{ return "1.2"; }
	function GetURL()			{ return "https://www.tt-forums.net/viewtopic.php?f=65&t=82795"; }

	function GetSettings() {
    AddSetting({name = "Switch", description = "This gamescript will end: ", easy_value = 0, medium_value = 0, hard_value = 0, custom_value = 0, flags = CONFIG_BOOLEAN + CONFIG_DEVELOPER });    
    AddSetting({name = "Debug", description = "Logging", easy_value = 1, medium_value = 1, hard_value = 1, custom_value = 1, flags = CONFIG_BOOLEAN + CONFIG_INGAME });
		AddSetting({name = "Debug_level", description = "Logging level", min_value = 1, max_value = 3, easy_value = 1, medium_value = 2, hard_value = 3, custom_value = 1, flags = CONFIG_INGAME });
		AddLabels("Debug_level", {_1 = "1: Small", _2 = "2: Medium", _3 = "3: Large" } );
    AddSetting({name = "Count", description = "How many cities do you want to add ?", min_value = 1, max_value = 100000, easy_value = 200, medium_value = 200, hard_value = 200, custom_value = 200, flags = CONFIG_NONE});
    AddSetting({name = "When", description = "How many days to wait for a new city to be established ?", min_value = 1, max_value = 36500, easy_value = 15, medium_value = 15, hard_value = 15, custom_value = 15, flags = CONFIG_INGAME});
    AddSetting({name = "Citysize", description = "City size", min_value = 1, max_value = 4, easy_value = 1, medium_value = 2, hard_value = 3, custom_value = 1, flags = CONFIG_INGAME });
		AddLabels("Citysize", {_1 = "1: Random", _2 = "2: Small", _3 = "3: Medium", _4 = "4: Large" } );
    AddSetting({name = "Roadlayout", description = "Road Layout", min_value = 1, max_value = 5, easy_value = 1, medium_value = 2, hard_value = 3, custom_value = 1, flags = CONFIG_INGAME });
		AddLabels("Roadlayout", {_1 = "1: Random", _2 = "2: Original", _3 = "3: Better Roads", _4 = "4: 2x2", _5 = "5: 3x3" } );
    AddSetting({name = "City", description = "City", min_value = 1, max_value = 3, easy_value = 1, medium_value = 2, hard_value = 3, custom_value = 1, flags = CONFIG_INGAME });
		AddLabels("City", {_1 = "1: Random", _2 = "2: Yes", _3 = "3: No" } );
    AddSetting({name = "Probability", description = "The probability that the village will turn into a city (%)", min_value = 1, max_value = 100, easy_value = 50, medium_value = 50, hard_value = 50, custom_value = 50, flags = CONFIG_INGAME});
    AddSetting({name = "View", description = "Viewport of the new city", easy_value = 0, medium_value = 0, hard_value = 0, custom_value = 0, flags = CONFIG_BOOLEAN + CONFIG_INGAME });
    AddSetting({name = "Welcome", description = "Should a welcome message appear for new companies ?", easy_value = 1, medium_value = 1, hard_value = 1, custom_value = 1, flags = CONFIG_BOOLEAN + CONFIG_INGAME });

    
	}
}

RegisterGS(TownFounderClass());

 