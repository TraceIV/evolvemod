/*-------------------------------------------------------------------------------------------------------------------------
	Provides chat commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Chat Commands"
PLUGIN.Description = "Provides chat commands to run plugins."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

function PLUGIN:GetCommand( msg )
	return string.match( msg, "%w+" )
end

function PLUGIN:GetArguments( msg )
	local i, char, prevChar, nextChar
	local args = {}
	local buffer = ""
	local ignores = false
	
	for i = #self:GetCommand( msg ) + 3, #msg do
		char = string.sub( msg, i, i )
		prevChar = string.sub( msg, i - 1, i - 1 )
		nextChar = string.sub( msg, i + 1, i + 1 )
		
		if ( char == " " and !ignores and #buffer > 0 ) then
			table.insert( args, buffer )
			buffer = ""
		elseif ( char == "\"" and ( i == #self:GetCommand( msg ) + 3 or prevChar != "\\" ) ) then
			ignores = !ignores
			if ( !ignores ) then
				table.insert( args, buffer )
				buffer = ""
			end
		elseif ( char != "\\" or nextChar != "\"" ) then
			buffer = buffer .. char
		end
	end
	
	if ( #buffer > 0 ) then
		table.insert( args, buffer )
	end
	
	return args
end

function PLUGIN:PlayerSay( ply, msg )
	if ( string.Left( msg, 1 ) == "!" ) then
		local command = self:GetCommand( msg )
		local args = self:GetArguments( msg )
		
		for _, plugin in pairs( evolve.plugins ) do
			if ( plugin.ChatCommand == string.lower( command or "" ) ) then
				res, ret = pcall( plugin.Call, plugin, ply, args )
				
				if ( !res ) then
					evolve:Notify( evolve.colors.red, "Plugin '" .. plugin.Title .. "' failed with error:" )
					evolve:Notify( evolve.colors.red, ret )
				end
				
				return ""
			end
		end
		
		evolve:Notify( ply, evolve.colors.red, "Unknown command '" .. ( command or "" ) .. "'." )
	end
end

evolve:RegisterPlugin( PLUGIN )