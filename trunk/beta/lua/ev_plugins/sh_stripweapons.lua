/*-------------------------------------------------------------------------------------------------------------------------
	Strip a player's weapons
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Strip Weapons"
PLUGIN.Description = "Strip a player's weapons."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "strip"
PLUGIN.Usage = "[players]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply )
		if ( !ply:IsValid() and #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		
		for _, pl in ipairs( pls ) do
			pl:StripWeapons()
		end
		
		if ( #pls > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has stripped the weapons of ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "strip", unpack( players ) )
	else
		return "Strip weapons", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )