local modMatrix = require("test.deps.mod_matrix");
require("test.deps.utility");

g_savedata = {};

server = {};
server.mapObjects = {};
server.peers = {};
server.vehicles = {};
server.playlists = {};
server.objects = {};
server.zones = {};
server.gameSettings = {};
server.gameSettings.settings = {};
server.gameSettings.GAME_SETTINGS = {
    "third_person",
    "third_person_vehicle",
    "vehicle_damage",
    "player_damage",
    "npc_damage",
    "sharks",
    "fast_travel",
    "teleport_vehicle",
    "rogue_mode",
    "auto_refuel",
    "megalodon",
    "map_show_players",
    "map_show_vehicles",
    "show_3d_waypoints",
    "show_name_plates",
    "day_night_length", -- currently cannot be written to
    "sunrise", -- currently cannot be written to
    "sunset", -- currently cannot be written to
    "infinite_money",
    "settings_menu",
    "unlock_all_islands",
    "infinite_batteries",
    "infinite_fuel",
    "engine_overheating",
    "no_clip",
    "map_teleport",
    "cleanup_veicle",
    "clear_fow", -- clear fog of war
    "vehicle_spawning",
    "photo_mode",
    "respawning",
    "settings_menu_lock",
    "despawn_on_leave", -- despawn player characters on leave
    "unlock_all_components"
};
server.tiles = {};
matrix = {};

testsuite = {
    event = {},
    test = {}
}

--UI

--- Sends a chat message
---@param name string
---@param message string
---@param peer_id integer | "optional and defaults to -1 for al peers"
---@return nil
function server.announce(name, message, peer_id)
    peer_id = peer_id and peer_id or -1
    if peer_id == -1 then
        printf("Announcing '%s' to all peers with '%s'", name, message);
    else
        local peer = getArrayElementById(server.peers, peer_id);
        assureNotNil("peer", peer);
        printf("Announcing '%s' to peer %d ('%s') with '%s'", name, peer_id, (peer.name or ""), message);
    end
end
--[[
-- Removed on v1.0.19
function server.whisper(peer_id, message)
    assureParameterInBounds("peer_id", peer_id, -1);
    if peer_id == -1 then
        printf("Whispering all peers with '%s'", message);
    else
        local peer = getArrayElementById(server.peers, peer_id);
        assureNotNil("peer", peer);
        printf("Whispering peer %d with '%s'", peer_id, message);
    end
end
]]
--- Sends a pop up notification to the specified peer(s)
---@param peer_id integer
---@param title string
---@param message string
---@param NOTIFICATION_TYPE integer
---@return nil
function server.notify(peer_id, title, message, NOTIFICATION_TYPE)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("NOTIFICATION_TYPE", NOTIFICATION_TYPE, 0, 9);
    if peer_id == -1 then
        printf("Notifying all peers with '%s', '%s', %d", title, message, NOTIFICATION_TYPE)
    else
        local peer = getArrayElementById(server.peers, peer_id);
        assureNotNil("peer", peer);
        printf("Notifying peer %d ('%s') with '%s', '%s', %d", peer_id, (peer.name or ""), title, message, NOTIFICATION_TYPE)
    end
end
--- Returns a unique UI id number for use with all other UI functions. The UI ID can be used to track, edit and clean UI elements up.
---@return integer
function server.getMapID()
    local ui_id = getRandomId();
    if #server.mapObjects == 0 then
        error("No mapObjects added.")
    end
    for _, uiIds in pairs(server.mapObjects) do
        uiIds[ui_id] = {};
    end
    return ui_id;
end
--- Removes all UI with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
---@return nil
function server.removeMapID(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureNotNil("server.mapObjects[peer_id]", server.mapObjects[peer_id])
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id] = nil;
end
--[[
    Both y parameters removed on v1.0.21

    function server.addMapObject(peer_id, ui_id, POSITION_TYPE, MARKER_TYPE, x, y, z, parent_local_x, parent_local_y, parent_local_z, vehicle_id, object_id, label, vehicle_parent_id, radius, hover_label)
]]
--- Add a map marker for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
---@param POSITION_TYPE integer if set to 1 or 2, (vehicle or object) then the marker will track the object/vehicle
---@param MARKER_TYPE integer
---@param x integer represent the worldspace location of the marker on the map
---@param z integer represent the worldspace location of the marker on the map
---@param parent_local_x integer marker position offset
---@param parent_local_z integer marker position offset 
---@param vehicle_id integer
---@param object_id integer
---@param label string
---@param vehicle_parent_id integer
---@param radius integer
---@param hover_label string
function server.addMapObject(peer_id, ui_id, POSITION_TYPE, MARKER_TYPE, x, z, parent_local_x, parent_local_z, vehicle_id, object_id, label, vehicle_parent_id, radius, hover_label)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    assureParameterInBounds("POSITION_TYPE", POSITION_TYPE, 0, 2);
    assureParameterInBounds("MARKER_TYPE", MARKER_TYPE, 0, 8);
    getOrSetArr(server.mapObjects, peer_id);
    server.mapObjects[peer_id][ui_id] = {};
    server.mapObjects[peer_id][ui_id].mapObject = {};
    server.mapObjects[peer_id][ui_id].mapObject.POSITION_TYPE = POSITION_TYPE;
    server.mapObjects[peer_id][ui_id].mapObject.MARKER_TYPE = MARKER_TYPE;
    server.mapObjects[peer_id][ui_id].mapObject.x = x;
    server.mapObjects[peer_id][ui_id].mapObject.z = z;
    server.mapObjects[peer_id][ui_id].mapObject.parent_local_x = parent_local_x;
    server.mapObjects[peer_id][ui_id].mapObject.parent_local_z = parent_local_z;
    server.mapObjects[peer_id][ui_id].mapObject.vehicle_id = vehicle_id;
    server.mapObjects[peer_id][ui_id].mapObject.object_id = object_id;
    server.mapObjects[peer_id][ui_id].mapObject.label = label;
    server.mapObjects[peer_id][ui_id].mapObject.vehicle_parent_id = vehicle_parent_id;
    server.mapObjects[peer_id][ui_id].mapObject.radius = radius;
    server.mapObjects[peer_id][ui_id].mapObject.hover_label = hover_label;
end

--- Removes a map object with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
function server.removeMapObject(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].mapObject = nil;
end
--[[
Parameter y removed on v1.0.21

function server.addMapLabel(peer_id, ui_id, LABEL_TYPE, name, x, y, z)
]]
--- Add a map label for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
---@param LABEL_TYPE integer
---@param name string
---@param x integer represent the worldspace location of the marker on the map 
---@param z integer represent the worldspace location of the marker on the map
function server.addMapLabel(peer_id, ui_id, LABEL_TYPE, name, x, z)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    assureParameterInBounds("LABEL_TYPE", LABEL_TYPE, 0, 14);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    getOrSetArr(server.mapObjects[peer_id][ui_id], "label");
    server.mapObjects[peer_id][ui_id].label.LABEL_TYPE = LABEL_TYPE;
    server.mapObjects[peer_id][ui_id].label.name = name;
    server.mapObjects[peer_id][ui_id].mapObject.x = x;
    server.mapObjects[peer_id][ui_id].mapObject.z = z;
end
--- Removes a map label with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
function server.removeMapLabel(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].label = nil;
end
--- Adds a map line between two world space matrices with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
---@param start_matrix matrix
---@param end_matrix matrix
---@param width integer
function server.addMapLine(peer_id, ui_id, start_matrix, end_matrix, width)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    getOrSetArr(server.mapObjects[peer_id][ui_id], "line");
    server.mapObjects[peer_id][ui_id].line.start_matrix = start_matrix;
    server.mapObjects[peer_id][ui_id].line.end_matrix = end_matrix;
    server.mapObjects[peer_id][ui_id].line.width = width;
end
--- Removes a map line with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
function server.removeMapLine(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].line = nil;
end
--[[
    Parameter is_worldspace removed on v1.0.21
    function server.setPopup(peer_id, ui_id, name, is_show, text, x, y, z, is_worldspace, render_distance)
]]
--- Creates a popup to the world/screen with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
---@param name string
---@param is_show boolean
---@param text string
---@param x integer
---@param y integer
---@param z integer
---@param render_distance integer If set to 0 then the popup will always render.
function server.setPopup(peer_id, ui_id, name, is_show, text, x, y, z, render_distance)
    createPopup(peer_id, ui_id);
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    if server.mapObjects[peer_id][ui_id].popup == nil then
        error("Popup " .. peer_id ..  "/" .. ui_id .. " needs to be created first.");
    end
    server.mapObjects[peer_id][ui_id].popup.name = name;
    server.mapObjects[peer_id][ui_id].popup.is_show = is_show;
    server.mapObjects[peer_id][ui_id].popup.text = text;
    server.mapObjects[peer_id][ui_id].popup.x = x;
    server.mapObjects[peer_id][ui_id].popup.y = y;
    server.mapObjects[peer_id][ui_id].popup.z = z;
    server.mapObjects[peer_id][ui_id].popup.render_distance = render_distance;
end
--- Removes a popup with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
function server.removePopup(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].popup = nil;
end
--- Creates a popup to the screen with the specified UI ID for the specified peer(s).
---@param peer_id integer
---@param ui_id integer
---@param name string
---@param is_show boolean
---@param text string
---@param horizontal_offset integer Ranges from -1, -1 (Bottom left), to 1,1 (Top Right).
---@param vertical_offset integer Ranges from -1, -1 (Bottom left), to 1,1 (Top Right).
function server.setPopupScreen(peer_id, ui_id, name, is_show, text, horizontal_offset, vertical_offset)
    createPopup(peer_id, ui_id);
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    server.mapObjects[peer_id][ui_id].popup.name = name;
    server.mapObjects[peer_id][ui_id].popup.is_show = is_show;
    server.mapObjects[peer_id][ui_id].popup.text = text;
    server.mapObjects[peer_id][ui_id].popup.horizontal_offset = horizontal_offset;
    server.mapObjects[peer_id][ui_id].popup.vertical_offset = vertical_offset;
end
--[[
Integrated into setPopup?
Not showing up in in-game documentation anymore since v1.0.21

function server.createPopup(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    server.mapObjects[peer_id][ui_id].popup = {};
end
]]

--Player
function testsuite.test.setPlayerName(peer_id, name)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.name = name;
end
--- Returns the player name of the specified peer as it appears to the server.
---@param peer_id integer
function server.getPlayerName(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    if peer then
        return peer.name, true;
    else
        return nil, false;
    end
end
--- Returns a table containing info on all connected players. I. e. "{ [peer_index] = { ["id"] = peer_id, ["name"] = name, ["admin"] = is_admin, ["auth"] = is_auth, ["steam_id"] = steam_id }}"
---@return table
function server.getPlayers()
    return server.peers;
end
function testsuite.test.setPlayerPos(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    peer.pos = matrix;
end
--- Gets the world position of a specified peer as a matrix.
---@param peer_id integer
---@return matrix, boolean
function server.getPlayerPos(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    if peer then
        return peer.pos, true;
    else
        return nil, false;
    end
end
--[[
Renamed to setPlayerPos on v1.0.21

function server.teleportPlayer(peer_id, matrix)
]]
--- Teleports the specified player to the target world position.
---@param peer_id integer
---@param matrix matrix
function server.setPlayerPos(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.pos = matrix;
    return true;
end
--[[
Has been reworked on v1.0.21

function server.killPlayer(peer_id)
]]
--- Kills the target character.
---@param object_id integer
function server.killCharacter(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    character.hp = 0;
    character.is_incapacitated = true;
    printf("Killed character id %d", object_id);
end
--[[
Has been reworked on v1.0.21

    function server.setSeated(peer_id, vehicle_id, seat_name)
]]
--- Sets the target character to be seated in the first seat with the specified name found on the specified vehicle.
---@param object_id integer
---@param vehicle_id integer
---@param seat_name string
function server.setCharacterSeated(object_id, vehicle_id, seat_name)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    getOrSetArr(vehicle, "seats");
    vehicle.seats[seat_name] = object_id;
    printf("Seated peer id %d in %d on %s", object_id, vehicle_id, (vehicle.name or ""), seat_name)
end
function testsuite.test.setPlayerLookDirection(peer_id, lookDirection)
    getOrSetArr(server.peers, peer_id);
    local peer = getArrayElementById(server.peers, peer_id);
    peer.lookDirection = lookDirection;
end
--- Returns the forward vector of the specified player's camera.
---@param peer_id integer
function server.getPlayerLookDirection(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    return peer.lookDirection, true;
end
--- Gets a specified player's character object id.
---@param peer_id integer
function server.getPlayerCharacterID(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    return peer.characterId;
end
--- Revives the target character.
---@param object_id integer
function server.reviveCharacter(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    character.hp = 1;
    character.is_incapacitated = false;
    printf("Revived character id %d", object_id);
end

--Vehicle
--- Spawns a vehicle component from a specified playlist. See getLocationComponentData for info on how to get component_id.
---@param matrix matrix
---@param playlist_index integer
---@param component_id integer
function server.spawnVehicle(matrix, playlist_index, component_id)
    assureParameterInBounds("playlist_index", playlist_index, 1);
    assureParameterInBounds("component_id", component_id, 1);
    local playList = server.playlists[playlist_index];
    assureNotNil("playList", playList);
    local vehicleIndex = #server.vehicles + 1;
    local vehicleId = getRandomId();
    getOrSetArr(server.vehicles, vehicleIndex);
    addTableVehicleAttributes(server.vehicles[vehicleIndex]);
    server.vehicles[vehicleIndex].id = vehicleId;
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].component_id = component_id;
    server.vehicles[vehicleIndex].playlist_index = playlist_index;
    return vehicleId, true;
end
--- Spawns a vehicle from local appdata (%appdata% on Windows, data folder for servers) using its file name. 
---@param matrix matrix
---@param save_name string
function server.spawnVehicleSavefile(matrix, save_name)
    local vehicleIndex = #server.vehicles + 1;
    local vehicleId = getRandomId();
    getOrSetArr(server.vehicles, vehicleIndex);
    addTableVehicleAttributes(server.vehicles[vehicleIndex]);
    server.vehicles[vehicleIndex].id = vehicleId;
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].save_name = save_name;
    server.vehicles[vehicleIndex].name = save_name;
    return vehicleId, true;
end
--- Sets a vehicle to despawn when out of a player's range.
---@param vehicle_id integer
---@param is_instant boolean If set, the vehicle will instantly despawn no matter the player's proximity.
function server.despawnVehicle(vehicle_id, is_instant)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicleId", vehicle);
    destroyArrayElementById(server.vehicles, vehicle_id);
    printf("Despawned vehicle %d ('%s') %s", vehicle_id, (vehicle.name or ""), (is_instant and "instantly" or ""))
    return true;
end
function testsuite.test.setVehiclePos(vehicle_id, matrix)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.pos = matrix;
end
--- Gets the world position of a vehicle. Voxel positions can be passed to get the world position of that voxel (defaults to 0,0,0 for vehicle origin).
---@param vehicle_id integer
---@param voxel_x integer
---@param voxel_y integer
---@param voxel_z integer
function server.getVehiclePos(vehicle_id, voxel_x, voxel_y, voxel_z)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    if voxel_x and voxel_y and voxel_z then
        error("Voxel Position are not implemented yet.");
    else
        return vehicle.pos, true;
    end
end
--- Gets a vehicle's file name.
---@param vehicle_id integer
function server.getVehicleName(vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.name, true;
end
--[[
Renamed to setVehiclePos on v1.0.21

function server.teleportVehicle(matrix, vehicle_id)
]]
--- Teleports the specified vehicle to the target world position.
---@param matrix matrix
---@param vehicle_id integer
function server.setVehiclePos(matrix, vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.pos = matrix;
    return true;
end
--- Cleans up all player spawned vehicles.
function server.cleanVehicles()
    server.vehicles = {};
end
--- Applies a press action to the first button of the specified name found on the specified vehicle.
---@param vehicle_id integer
---@param button_name string
function server.pressVehicleButton(vehicle_id, button_name)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.buttons[button_name] = true;
    printf("Button '%s' of vehicle '%d' ('%s') has been pressed.", button_name, vehicle_id, (vehicle.name or ""));
end
--- Returns the state of the first button of the specified name found on the specified vehicle.
---@param vehicle_id integer
---@param button_name string
function server.getVehicleButton(vehicle_id, button_name)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.buttons[button_name];
end
function testsuite.test.setVehicleFireCount(vehicle_id, count)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.fireCount = count;
end
--- Gets the number of burning surfaces on a specified vehicle.
---@param vehicle_id integer
function server.getVehicleFireCount(vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.fireCount;
end
--- Sets the default block tooltip of a vehicle to display some text. Blocks with unique tooltips (e.g. buttons) will override this tooltip.
---@param vehicle_id integer
---@param text string
function server.setVehicleTooltip(vehicle_id, text)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.toolTip = text;
end
function testsuite.test.setVehicleSimulating(vehicleId, simulating)
    assureParameterInBounds("vehicleId", vehicleId, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicleId);
    assureNotNil("vehicle", vehicle);
    vehicle.simulating = simulating;
end
--- Returns whether the specified vehicle has finished loading and is simulating.
---@param vehicle_id integer
function server.getVehicleSimulating(vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.simulating;
end
--- Sets a vehicle's global transponder to active. (All vehicles have a global transponder that can be active even if a vehicle is not loaded)-
---@param vehicle_id integer
---@param is_active boolean
function server.setVehicleTransponder(vehicle_id, is_active)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.transponderActive = is_active;
end
--- Sets a vehicle to be editable by players. If a vehicle is spawned by a script it will not have a parent workbench until edited by one (Edit vehicle in zone).
---@param vehicle_id integer
---@param is_editable boolean
function server.setVehicleEditable(vehicle_id, is_editable)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.editable = is_editable;
end
--- Overrides the inputs to the first seat of the specified name found on the specified vehicle. A seated player will prevent overrides.
---@param vehicle_id integer
---@param seat_name string
---@param axis_w number
---@param axis_d number
---@param axis_up number
---@param axis_right number
---@param button1 boolean
---@param button2 boolean
---@param button3 boolean
---@param button4 boolean
---@param button5 boolean
---@param button6 boolean
function server.setVehicleSeat(vehicle_id, seat_name, axis_w, axis_d, axis_up, axis_right, button1, button2, button3, button4, button5, button6)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    local seat = getOrSetArr(vehicle.seats, seat_name);
    seat.axis_w = axis_w;
    seat.axis_d = axis_d;
    seat.axis_up = axis_up;
    seat.axis_right = axis_right;
    seat.button1 = button1;
    seat.button2 = button2;
    seat.button3 = button3;
    seat.button4 = button4;
    seat.button5 = button5;
    seat.button6 = button6;
end

--Mission
--- Gets the internal index of an active playlist by its name (useful if you want to spawn components from another script).
---@param name string
function server.getPlaylistIndexByName(name)
    for playListIndex = 1, #server.playlists do
        if server.playlists[playListIndex].name == name then
            return playListIndex, true;
        end
    end
    return nil, false;
end
function testsuite.test.setPlaylistIndexCurrent(currentPlaylistIndex)
    server.playlists.currentPlaylistIndex = currentPlaylistIndex;
end
--- Gets the internal index of this playlist.
function server.getPlaylistIndexCurrent()
    return server.playlists.currentPlaylistIndex;
end
--- Gets the internal index of a location in the specified playlist by its name (this index is local to the playlist).
---@param playlist_index integer
---@param name string
function server.getLocationIndexByName(playlist_index, name)
    assureParameterInBounds("playlist_index", playlist_index, 1);
    getOrSetArr(server.playlists[playlist_index].locations, {});
    for locationIndex = 1, #server.playlists[playlist_index].locations do
        if server.playlists[playlist_index].locations[locationIndex].name == name then
            return locationIndex, true;
        end
    end
    return nil, false;
end
--- Directly spawns a location by its name from the current  playlist.
---@param name string
function server.spawnThisPlaylistMissionLocation(name)
    local currentPlaylistIndex = server.getPlaylistIndexCurrent();
    assureNotNil("currentPlaylistIndex", currentPlaylistIndex);
    local locationIndex = server.getLocationIndexByName(currentPlaylistIndex, name);
    assureNotNil("locationIndex", locationIndex);
    server.playlists[currentPlaylistIndex].locations[locationIndex].spawned = true;
    printf("Location %d of playlist %d spawned.", locationIndex, currentPlaylistIndex);
    return true;
end
--- Spawns the specified mission location from the specified mission playlist at the specified world coordinates.
---@param matrix matrix A matrix with x,y,z = 0,0,0 will spawn the location at a random location of the tile's type (useful for spawning missions on specified files).
---@param playlist_index integer
---@param location_index integer
function server.spawnMissionLocation(matrix, playlist_index, location_index)
    assureNotNil("matrix", matrix);
    assureParameterInBounds("playlist_index", playlist_index, 1);
    assureParameterInBounds("location_index", location_index, 1);
    if matrix[1] == 0 and matrix[2] == 0 and matrix[3] == 0 then
        matrix = modMatrix.random(matrix);
    end
    local missionLocation = server.playlists[playlist_index].locations[location_index];
    missionLocation.pos = matrix;
    missionLocation.spawned = true;
    return matrix, true;
end
--- Gets the filepath of a playlist.
---@param playlist_name string
---@param is_rom boolean will only be true for DEV playlists stored in the rom folder.
function server.getPlaylistPath(playlist_name, is_rom)
    local playlistIndex = server.getPlaylistIndexByName(playlist_name);
    assureNotNil("playlistIndex", playlistIndex);
    local playList = server.playlists[playlistIndex];
    assureNotNil("playList", playList);
    return playList.filePath, true;
end
--- Spawn the specified object at the specified world position.
---@param matrix matrix
---@param OBJECT_TYPE integer
function server.spawnObject(matrix, OBJECT_TYPE)
    assureParameterInBounds("OBJECT_TYPE", OBJECT_TYPE, 0, 63);
    local objectIndex = #server.objects + 1;
    local objectId = getRandomId();
    getOrSetArr(server.objects, objectIndex);
    server.objects[objectIndex].id = objectId;
    server.objects[objectIndex].type = OBJECT_TYPE;
    server.objects[objectIndex].is_found = false;
    server.objects[objectIndex].pos = matrix;
    return objectId, true;
end
--- Get the world position of a specified object. Returns false if the object cannot be found.
---@param object_id integer
---@return matrix, boolean
function server.getObjectPos(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local object = getArrayElementById(server.objects, object_id);
    assureNotNil("object", object);
    return  object.pos, true;
end
--- Sets the world position of a specified object. Returns false if the object cannot be found.
---@param object_id integer
---@param matrix matrix
---@return boolean
function server.setObjectPos(object_id, matrix)
    assureParameterInBounds("object_id", object_id, 1);
    assureNotNil("matrix", matrix);
    local object = getArrayElementById(server.objects, object_id);
    assureNotNil("object", object);
    object.pos = matrix;
    return true;
end
--[[
Parameter is_initialzied has been removed on v1.0.21

function server.spawnFire(matrix, size, magnitude, is_lit, is_initialzied, is_explosive, parent_vehicle_id, explosion_magnitude)
]]
--- Spawns a world fire at the specified world position matrix.
---@param matrix matrix
---@param size integer
---@param magnitude integer
---@param is_lit boolean
---@param is_explosive boolean
---@param parent_vehicle_id integer should be 0 if the fire should not move relative to a vehicle.
---@param explosion_magnitude integer
function server.spawnFire(matrix, size, magnitude, is_lit, is_explosive, parent_vehicle_id, explosion_magnitude)
    assureParameterInBounds("parent_vehicle_id", parent_vehicle_id, 1);
    local objectIndex = #server.objects + 1;
    local objectId = getRandomId();
    getOrSetArr(server.objects, objectIndex);
    server.objects[objectIndex].id = objectId;
    server.objects[objectIndex].pos = matrix;
    server.objects[objectIndex].size = size;
    server.objects[objectIndex].magnitude = magnitude;
    server.objects[objectIndex].is_lit = is_lit;
    server.objects[objectIndex].is_explosive = is_explosive;
    server.objects[objectIndex].parent_vehicle_id = parent_vehicle_id;
    server.objects[objectIndex].explosion_magnitude = explosion_magnitude;
    return objectId, true;
end
--- Despawns the specified object when it is out of a player's range.
---@param object_id integer
---@param is_instant boolean will instantly despawn the object.
function server.despawnObject(object_id, is_instant)
    assureParameterInBounds("object_id", object_id, 1);
    destroyArrayElementById(server.objects, object_id);
    return true;
end
--- Spawns a character object.
---@param matrix matrix world position
---@param outfit_id integer optional outfit
function server.spawnCharacter(matrix, outfit_id)
    assureParameterInBounds("outfit_id", outfit_id, 0, 11);
    local characterId = getRandomId();
    local characterIndex = #server.objects + 1;
    getOrSetArr(server.objects, characterIndex);
    server.objects[characterIndex].id = characterId;
    server.objects[characterIndex].outfit_id = outfit_id;
    server.objects[characterIndex].pos = matrix;
    server.objects[characterIndex].is_incapacitated = false;
    server.objects[characterIndex].hp = 1;
    return characterId, true;
end
--- Spawns an animal at the specified world position.
---@param matrix matrix
---@param animal_type integer
---@param scale integer
function server.spawnAnimal(matrix, animal_type, scale)
    assureParameterInBounds("animal_type", animal_type, 1, 5);
    local objectId = getRandomId();
    local objectIndex = #server.objects + 1;
    getOrSetArr(server.objects, objectIndex);
    server.objects[objectIndex].id = objectId;
    server.objects[objectIndex].pos = matrix;
    server.objects[objectIndex].animal_type = animal_type;
    server.objects[objectIndex].scale = scale;
    return objectId, true;
end
--[[
Removed on v1.0.21

function server.despawnCharacter(object_id, is_instant)
    assureParameterInBounds("object_id", object_id, 1);
    destroyArrayElementById(server.objects, object_id);
end
]]
--- Gets character data for a specified character object.
---@param object_id integer
function server.getCharacterData(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    return character.hp, character.pos, character.is_incapacitated, character.hp == 0, character.is_interactable;
end
--- Sets character data for a specified character object. Non-interactable characters are frozen in place and cannot be moved.
---@param object_id integer
---@param hp number
---@param is_interactable boolean has no effect on player characters.
function server.setCharacterData(object_id, hp, is_interactable)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    character.hp = hp;
    character.is_interactable = is_interactable;
end
--- Sets the item slot data for a specified character object.
---@param object_id integer
---@param slot integer
---@param EQUIPMENT_ID integer
---@param is_active boolean
function server.setCharacterItem(object_id, slot, EQUIPMENT_ID, is_active)
    assureParameterInBounds("object_id", object_id, 1);
    assureParameterInBounds("slot", slot, 1, 6);
    assureParameterInBounds("EQUIPMENT_ID", EQUIPMENT_ID, 0, 27);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    getOrSetArr(character, "inventory");
    character.inventory[slot] = EQUIPMENT_ID;
    if is_active then
        character.activeSlot = slot;
    end
    printf("Character '%d' has item '%d' on slot %d and it's %s", object_id, EQUIPMENT_ID, slot, (is_active and "active" or "not active"));
end
--- Gets the item in the specified slot for a specified character object.
---@param object_id integer
---@param SLOT_NUMBER integer
function server.getCharacterItem(object_id, SLOT_NUMBER)
    assureParameterInBounds("object_id", object_id, 1);
    assureParameterInBounds("slot", SLOT_NUMBER, 1, 6);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    return character.inventory[SLOT_NUMBER];
end
--- Gets whether the game considers the tutorial active (default missions check this before they spawn).
function server.getTutorial()
    return server.playlists.tutorial and server.playlists.tutorial or false;
end
--- Sets whether the game considers the tutorial as active (useful if you are marking your own tutorial).
function server.setTutorial()
    server.playlists.tutorial = true;
end
--- Gets a table of all active environment mods zones when no tags were specified. Will return matching ones when tags were specified.
function server.getZones(...)
    local tags = {...};
    local resultTags = {};
    for zoneIndex = 1, #server.zones do
        for tagIndex = 1, #server.zones[zoneIndex].tags do
            local tag = server.zones[zoneIndex].tags[tagIndex];
            for formalTagIndex = 1, #tags do
                local formalTag = tags[formalTagIndex];
                if formalTag == tag then
                    resultTags[#resultTags + 1] = server.zones[zoneIndex];
                end
            end
        end
        return resultTags;
    end
end
--- Returns whether the specified world transform is within an environment mod zone that matches the display name.
---@param matrix matrix
---@param zone_display_name string
function server.isInZone(matrix, zone_display_name)
    -- TODO
    error("Matrix not implemented yet.");
end
--[[
Renamed on v1.0.21

function server.spawnMissionObject(matrix, playlist_index, location_index, object_index)
]]
--- Spawns the component (object/vehicle) at the specified component index at the specified location at the specified index. I.e. "{ ["name"] = name, ["display_name"] = display_name, ["type"] = TYPE_STRING, ["transform"] = matrix, ["id"] = object_id/vehicle_id }"
function server.spawnMissionComponent(matrix, playlist_index, location_index, object_index)
    assureNotNil("matrix", matrix);
    assureNotNil("server.playlists[playlist_index]", server.playlists[playlist_index]);
    assureNotNil("server.playlists[playlist_index].locations[location_index]", server.playlists[playlist_index].locations[location_index]);
    local objectId = server.playlists[playlist_index].locations[location_index].objects[object_index];
    assureNotNil("objectId", objectId);
    local object = getArrayElementById(server.objects, objectId);
    assureNotNil("object", object);
    object.spawned = true;
    printf("Spawned object %d of playlist %d and its location %d", object_index, playlist_index, location_index);
    return object.id, true;
end
--[[
Removed on v1.0.21

function server.despawnMissionObject(object_id, is_instant)
    local object = getArrayElementById(server.objects, object_id);
    assureNotNil("object", object);
    object.spawned = false;
    printf("Despawned object with id %d %s", object_id, (is_instant and "instantly" or ""));
end
]]
--- Gets the number of active playlists.
function server.getPlaylistCount()
    return #server.playlists;
end
--- Gets the table of playlist data for the specified location at the specified playlist_index. I.e. "{ ["name"] = name, ["path_id"] = folder_path, ["file_store"] = is_app_data, ["location_count"] = location_count }"
---@param playlist_index integer
function server.getPlaylistData(playlist_index)
    return server.playlists[playlist_index];
end
--- Gets the table of location data for the specified location at the specified playlist_index. I.e. "{ ["name"] = name, ["tile"] = tile_filename, ["env_spawn_count"] = spawn_count, ["env_mod"] = is_env_mod, ["component_count"] = component_count }"
---@param playlist_index integer
---@param location_index integer
function server.getLocationData(playlist_index, location_index)
    return server.playlists[playlist_index].locations[location_index], true;
end
--- Gets the table of component (object/vehicle) data for the specified component at the specified location at the specified playlist_index. I.e. "{ ["name"] = name, ["display_name"] = display_name, ["type"] = TYPE_STRING, ["id"] = component_id, ["dynamic_object_type"] = OBJECT_TYPE, ["tags"] = { [i] = tag }, ["transform"] = matrix, ["character_outfit_type"] = OUTFIT_TYPE }"
function server.getLocationComponentData(playlist_index, location_index, object_index)
    assureNotNil("server.playlists[playlist_index]", server.playlists[playlist_index]);
    assureNotNil("server.playlists[playlist_index].locations[location_index]", server.playlists[playlist_index].locations[location_index]);
    local objectId = server.playlists[playlist_index].locations[location_index].objects[object_index];
    assureNotNil("objectId", objectId);
    local object = getArrayElementById(server.objects, objectId);
    assureNotNil("object", object);
    return object, true;
end
--- Sets data for a world fire using its object_id.
---@param object_id integer
---@param is_lit boolean
---@param is_explosive boolean
function server.setFireData(object_id, is_lit, is_explosive)
    assureParameterInBounds("object_id", object_id, 1)
    local fire = getArrayElementById(server.objects, object_id);
    assureNotNil("fire", fire);
    fire.is_lit = is_lit;
    fire.is_explosive = is_explosive;
end
--- Gets data for a world fire using its object_id.
---@param object_id integer
function server.getFireData(object_id)
    assureParameterInBounds("object_id", object_id, 1)
    local fire = getArrayElementById(server.objects, object_id);
    assureNotNil("fire", fire);
    return fire.is_lit;
end
--- returns the world position of a random ocean tile within the selected search range
---@param matrix matrix
---@param min_search_range integer
---@param max_search_range integer
function server.getOceanTransform(matrix, min_search_range, max_search_range)
    -- TODO
    error("Matrix not implemented yet.");
end
--- returns whether the object transform is within a custom zone of the selected size
---@param matrix_object matrix
---@param matrix_zone matrix
---@param zone_x integer
---@param zone_y integer
---@param zone_z integer
function server.isInTransformArea(matrix_object, matrix_zone, zone_x, zone_y, zone_z)
    -- TODO
    error("Matrix not implemented yet.");
end

--Game
--- Sets a game setting.
---@param GAME_SETTING integer
---@param value any
function server.setGameSetting(GAME_SETTING, value)
    assureValueInArray(server.gameSettings.GAME_SETTINGS, GAME_SETTING);
    server.gameSettings.settings[GAME_SETTING] = value;
end
--- Returns a table of the game settings indexed by the GAME_SETTING string, this can be accessed inline eg. server.getGameSettings().third_person
function server.getGameSettings()
    return server.gameSettings.settings;
end
--- Sets the game money balance and research points.
function server.setCurrency(money, research)
    server.gameSettings.money = money;
    server.gameSettings.research = research;
end
--- Gets the game money balance.
function server.getCurrency()
    return server.gameSettings.money;
end
--- Gets the game reearch points.
function server.getResearchPoints()
    return server.gameSettings.research;
end
function testsuite.test.setDateValue(value)
    server.gameSettings.date = value;
end
--- Gets the number of days since game start.
function server.getDateValue()
    return server.gameSettings.date;
end
--- Getst the system time in ms (can be used for random seeding).
function server.getTimeMillisec()
    return os.time();
end
--- Returns whether the tile at the given world coordinates is player owned.
function testsuite.test.setTilePurchased(matrix, purchased)
    local tileIndex = #server.tiles + 1;
    getOrSetArr(server.tiles, tileIndex);
    server.tiles[tileIndex].purchased = purchased;
    server.tiles[tileIndex].matrix = matrix;
end
function server.getTilePurchased(matrix)
    error("Matrix not implemented.");
end
--[[Set callback to httpReply to make the script answer.]]
function testsuite.test.setHttpGetCallback(callback)
    server.httpGetCallback = callback;
end
--- Sends a HTTP GET request.
---@param port integer
---@param request_body string
function server.httpGet(port, request_body)
    if server.httpGetCallback then
        return server.httpGetCallback(port, request_body);
    end
end

-- admin
-- added with v1.0
--- Bans a player
---@param peer_id integer
function server.banPlayer(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.isBanned = true;
    printf("Banned id %d ('%s')", peer_id, (peer.name or ""));
end
--- Kicks a player
---@param peer_id integer
function server.kickPlayer(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.gotKicked = true;
    printf("Kicked id %d ('%s')", peer_id, (peer.name or ""));
end
--- Gives a player admin privileges.
---@param peer_id integer
function server.addAdmin(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.admin = true;
    printf("Added id %d ('%s') to adminlist", peer_id, (peer.name or ""));
end
--- Removes a player's admin priviledges.
---@param peer_id integer
function server.removeAdmin(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.admin = false;
    printf("Removed id %d ('%s') from adminlist", peer_id, (peer.name or ""));
end
--- Authorizes the player to use the workbenches.
---@param peer_id integer
function server.addAuth(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.auth = true;
    printf("Added id %d ('%s') to authlist", peer_id, (peer.name or ""));
end
--- Removes a player's authorization to use the workbenches.
---@param peer_id integer
function server.removeAuth(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.auth = false;
    printf("Removed id %d ('%s') from authlist", peer_id, (peer.name or ""));
end

-- Matrix
function matrix:new()
    obj = obj or {};
    setmetatable(obj, self);
    self.__index = self;

    return obj;
end
function matrix.multiply(matrix1, matrix2)
    local mulMatrix = modMatrix.mul(matrix1, matrix2);
    return mulMatrix;
end
function matrix.invert(matrix)
    local invMatrix = modMatrix.invert(matrix);
    return invMatrix;
end
function matrix.transpose(matrix)
    local transMatrix = modMatrix.transpose(matrix);
    return transMatrix;
end
function matrix.identity()
    local identMatrix = modMatrix:new(3, "I");
    return identMatrix;
end
function matrix:rotationX(radians)
end
function matrix:rotationY(radians)
end
function matrix:rotationZ(radians)
end
function matrix.translation(x,y,z)
    return {x, y, z};
end
function matrix.position(matrix)
    return matrix[1], matrix[2], matrix[3];
end
function matrix.distance(matrix1, matrix2)
    local distMatrix = modMatrix.sub(matrix1, matrix2);
    local poweredMatrix = modMatrix.pow(distMatrix, 2);
    distMatrix = modMatrix.sqrt(poweredMatrix);
    return distMatrix;
end

-- Simulation

function testsuite.event.onFireExtinguished(fire_x,fire_y,fire_z)
    if onFireExtinguished then
        onFireExtinguished(fire_x,fire_y,fire_z);
    end
end
--[[
Renamed on v1.0.21

function testsuite.event.onSpawnMissionObject(object_id, name, TYPE_STRING, playlist_index)
]]
function testsuite.event.onSpawnMissionComponent(object_id, name, TYPE_STRING, playlist_index)
    if onSpawnMissionObject then
        onSpawnMissionObject(object_id, name, TYPE_STRING, playlist_index);
    end
end
function testsuite.event.onVehicleDespawn(vehicle_id, peer_id)
    if onVehicleDespawn then
        onVehicleDespawn(vehicle_id, peer_id);
    end
end
function testsuite.event.onVehicleTeleport(vehicle_id, peer_id, x, y, z)
    if onVehicleTeleport then
        onVehicleTeleport(vehicle_id, peer_id, x, y, z);
    end
end
function testsuite.event.onToggleMap(peer_id, is_open)
    if onToggleMap then
        onToggleMap(peer_id, is_open)
    end
end
function testsuite.event.onPlayerRespawn(peer_id)
    if onPlayerRespawn then
        onPlayerRespawn(peer_id)
    end
end
function testsuite.event.onPlayerSit(peer_id, vehicle_id, seat_name)
    if onPlayerSit then
        onPlayerSit(peer_id, vehicle_id, seat_name);
    end
end
function testsuite.event.onTick()
    if onTick then
        onTick()
    end
end
function testsuite.event.worldCreate(creatingWorld)
    if onCreate then
        onCreate(creatingWorld);
    end
end
function testsuite.event.worldExit()
    if onDestroy then
        onDestroy()
    end
end
function testsuite.event.playerCommand(player_peer_id, command)
    local peer = getArrayElementById(server.peers, player_peer_id);
    assureNotNil("peer", peer);
    printf("Peer %d ('%s') ran command '%s'", player_peer_id, (peer.name or ""), command);
    local commandSplit = string.split(command, " ");
    if onCustomCommand then
        onCustomCommand(command, player_peer_id, peer.admin, peer.auth, table.unpack(commandSplit));
    end
end
function testsuite.event.chatMessage(player_peer_id, message)
    local peer = getArrayElementById(server.peers, player_peer_id);
    assureNotNil("peer", peer);
    if onChatMessage then
        onChatMessage(player_peer_id, peer.name, message);
    end
end
function testsuite.event.playerJoin(steam_id, peerId, name, isAdmin, isAuthed)
    if #server.peers == 0 then
        server.peers[1] = {
            id = 0,
            name = "Server",
            steam_id = "90071992547409920"
        };
        if onPlayerJoin then
            onPlayerJoin(server.peers[1].steam_id, server.peers[1].name, 0, true, true);
        end
    end
    local peerIndex = #server.peers + 1;
    local peer = getOrSetArr(server.peers, peerIndex);
    peer.id = peerId;
    peer.steam_id = steam_id;
    peer.name = name;
    peer.admin = isAdmin;
    peer.auth = isAuthed;
    peer.pos = {getRandomId(), getRandomId(), getRandomId()};
    peer.characterId = server.spawnCharacter(peer.pos, getRandomId(0, 11));
    server.announce("[Server]", peer.name .. " joined the game", -1);
    server.notify(peerId, "JOINED", "There are " .. (#server.peers - 1) .. " players connected", 7);
    if onPlayerJoin then
        onPlayerJoin(peer.steam_id, peer.name, peer.id, peer.admin, peer.auth);
    end
    return peerId;
end
function testsuite.event.playerLeave(peer_id)
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    if onPlayerLeave then
        onPlayerLeave(peer.steam_id, peer.name, peer.id, peer.admin, peer.auth);
    end
    server.announce("[Server]", peer.name .. " left the game", -1);
    destroyArrayElementById(server.peers, peer_id);
end
function testsuite.event.playerDie(peer_id)
    local peer = getArrayElementById(server.peers);
    if onPlayerDie then
        onPlayerDie(peer.steam_id, peer.name, peer.id, peer.admin, peer.auth);
    end
end
function testsuite.event.vehicleSpawn(peer_id, vehicleName, x, y, z, cost)
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    if not peer.auth then
        printf("%d ('%s') Workbench: You must be authorized to use workbench.", peer_id, (peer.name or ""));
        return;
    end
    local vehicleId = getRandomId();
    local vehicleIndex = #server.vehicles + 1;
    local vehicle = getOrSetArr(server.vehicles, vehicleIndex);
    vehicle.id = vehicleId;
    vehicle.owner = peer_id;
    vehicle.name = vehicleName;
    vehicle.pos = {x, y, z};
    vehicle.cost = cost;
    if onVehicleSpawn then
        onVehicleSpawn(vehicleId, peer_id, x, y, z, cost);
    end
    return vehicleId;
end
function testsuite.event.playerTeleportVehicle(peer_id, vehicle_id, x, y, z)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.pos = {x, y, z};
    if onVehicleTeleport then
        onVehicleTeleport(vehicle_id, peer_id, x, y, z);
    end
end
--[[
    The v1.0.21 update states this event is in the server table,
    which means the testsuite would need a rework.
]]
function testsuite.event.onCharacterSit(peer_id, vehicle_id, seat_name)
    local peerCharaterId = server.getPlayerCharacterID(peer_id);
    server.setCharacterSeated(peerCharaterId, vehicle_id, seat_name);
    if onCharacterSit then
        onCharacterSit(peer_id, vehicle_id, seat_name)
    end
end