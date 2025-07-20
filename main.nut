
/** Import SuperLib for GameScript **/
import("util.superlib", "SuperLib", 40);
//Result <- SuperLib.Result;
Log <- SuperLib.Log;
Helper <- SuperLib.Helper;
//Tile <- SuperLib.Tile;
//Direction <- SuperLib.Direction;
//Town <- SuperLib.Town;
//Industry <- SuperLib.Industry;
Story <- SuperLib.Story;


/** Import other source code files **/
require("version.nut"); // get SELF_VERSION
//require("some_file.nut");
//..


class TownFounderClass extends GSController 
{
	_loaded_data = null;
	_loaded_from_version = null;
	_init_done = null;

	
	constructor()
	{
		this._init_done = false;
		this._loaded_data = null;
		this._loaded_from_version = null;
	}
}


function TownFounderClass::Start()
{
	
	if (Helper.HasWorldGenBug()) GSController.Sleep(1);
	this.Init();
  GSController.Sleep(1);
  
	// Game has now started and if it is a single player game,
	// company 0 exist and is the human company.
  
   local days = this.GetSetting("When");
   local count = this.GetSetting("Count");
   local initcount = GSTown.GetTownCount();
   local finallycount = initcount + count;
   local timer = days;
   local counter = count;
   local founderswitch = true;
   local notfounded = true
   
	// Main Game Script loop
	local last_loop_date = GSDate.GetCurrentDate();
  
  
	while (!this.GetSetting("Switch")) {
        
		local loop_start_tick = GSController.GetTick();

		// Handle incoming messages from OpenTTD
		this.HandleEvents();

		// Reached new year/month/day?
		local current_date = GSDate.GetCurrentDate();
		if (last_loop_date != null) {
			local year = GSDate.GetYear(current_date);
			local month = GSDate.GetMonth(current_date);
			if (year != GSDate.GetYear(last_loop_date)) {
				this.EndOfYear();
			}
			if (month != GSDate.GetMonth(last_loop_date)) {
				this.EndOfMonth();
			}
      if (last_loop_date != current_date) {
      this.EndOfDay();
        timer = timer - 1;
				if (timer <= 0) {
          if (counter != 0) {
	  notfounded = true;
          notfounded = this.Founder(0, notfounded);
          counter = counter - 1;
          } else {
            if (this.GetSetting("Debug") && founderswitch) {
               founderswitch = false;
               GSLog.Info("----------------------------------------------------------------------------------------------------------------------------------------------------------------");
               GSLog.Info("The establishment of new cities was over. If you still have the Logging setting turned on, only cities based on computer players will now appear in the listing.");
               GSLog.Info("----------------------------------------------------------------------------------------------------------------------------------------------------------------");
            } 
            }
        
        timer = days;
        }
       days = this.GetSetting("When");
			}
		}
		last_loop_date = current_date;
	
		// Loop with a frequency of five days
		local ticks_used = GSController.GetTick() - loop_start_tick;
		GSController.Sleep(max(1, 74 - ticks_used));
   
	}
    GSLog.Info("---------------------------------------------------");      
    GSController.Break("This gamescript is complete.") ;  
    GSLog.Info("---------------------------------------------------");
           
}


function TownFounderClass::Init()
{
	if (this._loaded_data != null) {
		
	} else {
		
	}

	this._init_done = true;
	this._loaded_data = null; 
}


function TownFounderClass::HandleEvents()
{
	if(GSEventController.IsEventWaiting()) {
		local ev = GSEventController.GetNextEvent();
		if (ev == null) return;

		local ev_type = ev.GetEventType();
		switch (ev_type) {
      case GSEvent.ET_TOWN_FOUNDED: {
        local town_founded_event = GSEventTownFounded.Convert(ev);
        local townid = town_founded_event.GetTownID();
        if (this.GetSetting("Debug")) {
        this.WriteTown(townid); 
          }
        break
        
      }
			case GSEvent.ET_COMPANY_NEW: {
				local company_event = GSEventCompanyNew.Convert(ev);
				local company_id = company_event.GetCompanyID();    

				// Welcome the new company
        
				if (this.GetSetting("Welcome")){
        Story.ShowMessage(company_id, GSText(GSText.STR_WELCOME, company_id));
        }
        
        if (this.GetSetting("Debug")) {this.ListTown()
        
        }  
			  break	
      
			}

		}
	}
}


function TownFounderClass::EndOfDay()
{
    
     
}

function TownFounderClass::EndOfMonth()
{

}
/*
 * Called by our main loop when a new year has been reached.
 */
function TownFounderClass::EndOfYear()
{
}

function TownFounderClass::Save()
{
	Log.Info("Saving data to savegame", Log.LVL_INFO);

	if (!this._init_done) {
		return this._loaded_data != null ? this._loaded_data : {};
	}

	return { 
		some_data = null,
	
	};
}


function TownFounderClass::Load(version, tbl)
{
	Log.Info("Loading data from savegame made with version " + version + " of the game script", Log.LVL_INFO);
	
	this._loaded_data = {}
   	foreach(key, val in tbl) {
		this._loaded_data.rawset(key, val);
	}

	this._loaded_from_version = version;
	if (this.GetSetting("Debug")) {this.ListTown()
        
        }  
}
function TownFounderClass::Founder(name, notfounded)
{

    
    local c = this.GetSetting("Citysize");
    local r = this.GetSetting("Roadlayout");
    local b = this.GetSetting("City");
    local bool = true;
    c = c - 2;
    if (c < 0) {
      c = GSBase.RandRange(3);
       }
    
    r = r - 2;
    if (r < 0) {
      r = GSBase.RandRange(4);
      }
    
    switch (b) {
    case 1: {
    bool =  GSBase.Chance(this.GetSetting("Probability") , 100);	    
    break;
    }
    case 2: {
      bool = true;
      break;
    }
    case 3: {
     bool = false;
     break;
    }
     }
    
    
    local tileindex = 0;
    local x = 0
    local y = 0
    while (notfounded) {
      x = GSBase.RandRange(GSMap.GetMapSizeX());
      y = GSBase.RandRange(GSMap.GetMapSizeY());
      tileindex = GSMap.GetTileIndex(x,y);
      notfounded = GSTown.FoundTown (tileindex, c , bool, r , name);
      
      notfounded = !notfounded;
      if (GSError.GetLastError() == GSError.ERR_NAME_IS_NOT_UNIQUE) { 
		notfounded = false;
 		return notfounded;
		break;
	} 
    }
    if (this.GetSetting("View")) { 
    GSViewport.ScrollTo(tileindex);}    
    
}

function TownFounderClass::ListTown()
{
local towncount = GSTown.GetTownCount();
        GSLog.Info("---------------------------------------------------");  
        GSLog.Info("Number of cities at start of game: " + towncount);
        GSLog.Info("List of existing cities: ");
        GSLog.Info("---------------------------------------------------");
        local list = GSTownList();
        list.Sort(GSList.SORT_BY_ITEM, true);  
        foreach(townId, _ in list) {
          this.WriteTown(townId);
          }
          
        GSLog.Info("---------------------------------------------------");
        GSLog.Info("Newly created cities: "); 
        GSLog.Info("---------------------------------------------------");
}

function TownFounderClass::WriteTown(townid)
{
  local writetown = townid + 1 + ". " + GSTown.GetName(townid);
  local cityexist = GSTown.IsCity(townid);
  local iscity = "";
  local houses = GSTown.GetHouseCount(townid);
  local population = GSTown.GetPopulation(townid);
  	
  
  switch (cityexist) {
    case true: {
      iscity = ", (is city) ";	    
      break;
    }
    case false: {
      iscity = ", (is not city) ";	   
      break;
    }
     }
   
  switch (this.GetSetting("Debug_level")) {
    case 1: {
      
      break;
    }
    case 2: {
      writetown = writetown + iscity + " , X = " +  GSMap.GetTileX(GSTown.GetLocation(townid)) + " , Y = " +   GSMap.GetTileY(GSTown.GetLocation(townid));
      break;
    }
    case 3: {
      writetown = writetown + iscity + ", has " + houses + " houses and " + population + " population " +" , X = " +  GSMap.GetTileX(GSTown.GetLocation(townid)) + " , Y = " +   GSMap.GetTileY(GSTown.GetLocation(townid));
      break;
    }
     }
  
 GSLog.Info(writetown);
 
}
