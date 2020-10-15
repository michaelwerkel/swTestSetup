local modMatrix = require("test/deps/mod_matrix");

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

-- [[ http://lua-users.org/wiki/SleepFunction ]]
local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

--[[ http://www.cplusplus.com/reference/cstdio/printf/ ]]
function printf(s,...)
    return print(s:format(...));
end

function assureNotNil(name, value)
    if not value then
        error(name .. " doesn't exist.");
    end
end
function assureParameterInBounds(name, value, min, max)
    assureNotNil("min", min);
    if value < min or (max and (value > max) or false) then
        error(name .. " out of bounds.");
    end
end
function assureValueInArray(arrRoot, value)
    for i = 1, #arrRoot do
        if arrRoot[i] == value then
            return true
        end
    end
    error(string.format("'%s' not in array.", value));
end
function getOrSetArr(root, index)
    if root[index] then
        return root[index];
    else
        root[index] = {};
        return root[index];
    end
end
function getRandomId()
    return math.random(1, 999999);
end
function getArrayElementBy(arrRoot, index, id)
    for _, element in pairs(arrRoot) do
        if element[index] == id then
            return element;
        end
    end
end
function getArrayElementById(arrRoot, id)
    return getArrayElementBy(arrRoot, "id", id);
end
function destroyArrayElementById(arrRoot, id)
    for elementIndex, element in pairs(arrRoot) do
        if element.id == id then
            arrRoot[elementIndex] = nil;
            return true;
        end
    end
    return false;
end

--UI
function server.announce(name, message)
    printf("Announcing '%s' with '%s'", name, message);
end
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
function server.notify(peer_id, title, message, NOTIFICATION_TYPE)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("NOTIFICATION_TYPE", NOTIFICATION_TYPE, 0, 9);
    if peer_id == -1 then
        printf("Notifying all peers with '%s', '%s', %d", title, message, NOTIFICATION_TYPE)
    else
        local peer = getArrayElementById(server.peers, peer_id);
        assureNotNil("peer", peer);
        printf("Notifying peer %d with '%s', '%s', %d", peer_id, title, message, NOTIFICATION_TYPE)
    end
end
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
function server.removeMapID(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureNotNil("server.mapObjects[peer_id]", server.mapObjects[peer_id])
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id] = nil;
end
function server.addMapObject(peer_id, ui_id, POSITION_TYPE, MARKER_TYPE, x, y, z, parent_local_x, parent_local_y, parent_local_z, vehicle_id, object_id, label, vehicle_parent_id, radius, hover_label)
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
    server.mapObjects[peer_id][ui_id].mapObject.y = y;
    server.mapObjects[peer_id][ui_id].mapObject.z = z;
    server.mapObjects[peer_id][ui_id].mapObject.parent_local_x = parent_local_x;
    server.mapObjects[peer_id][ui_id].mapObject.parent_local_y = parent_local_y;
    server.mapObjects[peer_id][ui_id].mapObject.parent_local_z = parent_local_z;
    server.mapObjects[peer_id][ui_id].mapObject.vehicle_id = vehicle_id;
    server.mapObjects[peer_id][ui_id].mapObject.object_id = object_id;
    server.mapObjects[peer_id][ui_id].mapObject.label = label;
    server.mapObjects[peer_id][ui_id].mapObject.vehicle_parent_id = vehicle_parent_id;
    server.mapObjects[peer_id][ui_id].mapObject.radius = radius;
    server.mapObjects[peer_id][ui_id].mapObject.hover_label = hover_label;
end
function server.removeMapObject(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].mapObject = nil;
end
function server.addMapLabel(peer_id, ui_id, LABEL_TYPE, name, x, y, z)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    assureParameterInBounds("LABEL_TYPE", LABEL_TYPE, 0, 14);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    getOrSetArr(server.mapObjects[peer_id][ui_id], "label");
    server.mapObjects[peer_id][ui_id].label.LABEL_TYPE = LABEL_TYPE;
    server.mapObjects[peer_id][ui_id].label.name = name;
    server.mapObjects[peer_id][ui_id].mapObject.x = x;
    server.mapObjects[peer_id][ui_id].mapObject.y = y;
    server.mapObjects[peer_id][ui_id].mapObject.z = z;
end
function server.removeMapLabel(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].label = nil;
end
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
function server.removeMapLine(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].line = nil;
end
function server.setPopup(peer_id, ui_id, name, is_show, text, x, y, z, is_worldspace, render_distance)
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
    server.mapObjects[peer_id][ui_id].popup.is_worldspace = is_worldspace;
    server.mapObjects[peer_id][ui_id].popup.render_distance = render_distance;
end
function server.removePopup(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    assureParameterInBounds("ui_id", ui_id, 1);
    server.mapObjects[peer_id][ui_id].popup = nil;
end
function server.createPopup(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    server.mapObjects[peer_id][ui_id].popup = {};
end

--Player
function server.test_setPlayerName(peer_id, name)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.name = name;
end
function server.getPlayerName(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    return peer and peer.name or nil;
end
function server.getPlayers()
    return server.peers;
end
function server.test_setPlayerPos(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    peer.pos = matrix;
end
function server.getPlayerPos(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    return peer and peer.pos or nil;
end
function server.teleportPlayer(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.pos = matrix;
end
function server.killPlayer(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.hp = 0;
    printf("Killed peer id %d", peer_id);
end
function server.setSeated(peer_id, vehicle_id, seat_name)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    getOrSetArr(vehicle, "seats");
    vehicle.seats[seat_name] = peer_id;
    printf("Seated peer id %d in %d on %s", peer_id, vehicle_id, seat_name)
end
function server.test_setPlayerLookDirection(peer_id, lookDirection)
    getOrSetArr(server.peers, peer_id);
    local peer = getArrayElementById(server.peers, peer_id);
    peer.lookDirection = lookDirection;
end
function server.getPlayerLookDirection(peer_id)
    assureParameterInBounds("peer_id", peer_id, 1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    return peer.lookDirection;
end

--Vehicle
function server.spawnVehicle(matrix, playlist_index, component_id)
    assureParameterInBounds("playlist_index", playlist_index, 1);
    assureParameterInBounds("component_id", component_id, 1);
    local playList = server.playlists[playlist_index];
    assureNotNil("playList", playList);
    local vehicleIndex = #server.vehicles + 1;
    local vehicleId = getRandomId();
    getOrSetArr(server.vehicles, vehicleIndex);
    server.vehicles[vehicleIndex].id = vehicleId;
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].component_id = component_id;
    server.vehicles[vehicleIndex].playlist_index = playlist_index;
    return vehicleId;
end
function server.spawnVehicleSavefile(matrix, save_name)
    local vehicleIndex = #server.vehicles + 1;
    local vehicleId = getRandomId();
    getOrSetArr(server.vehicles, vehicleIndex);
    server.vehicles[vehicleIndex].id = vehicleId;
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].save_name = save_name;
    return vehicleId;
end
function server.despawnVehicle(vehicle_id, is_instant)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    destroyArrayElementById(server.vehicles, vehicle_id);
end
function server.test_setVehiclePos(vehicle_id, matrix)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.pos = matrix;
end
function server.getVehiclePos(vehicle_id, voxel_x, voxel_y, voxel_z)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    if voxel_x and voxel_y and voxel_z then
        error("Voxel Position are not implemented yet.");
    else
        return vehicle.pos;
    end
end
function server.getVehicleName(vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.name;
end
function server.teleportVehicle(matrix, vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.pos = matrix;
end
function server.cleanVehicles()
    server.vehicles = {};
end
function server.pressVehicleButton(vehicle_id, button_name)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    -- TODO: Make testable
    printf("Button '%s' of vehicle '%d' has been pressed.", button_name, vehicle_id);
end
function server.test_setVehicleFireCount(vehicle_id, count)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.fireCount = count;
end
function server.getVehicleFireCount(vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.fireCount;
end
function server.setVehicleTooltip(vehicle_id, text)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.toolTip = text;
end
function server.test_setVehicleSimulating(vehicleId, simulating)
    assureParameterInBounds("vehicleId", vehicleId, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicleId);
    assureNotNil("vehicle", vehicle);
    vehicle.simulating = simulating;
end
function server.getVehicleSimulating(vehicle_id)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.simulating;
end
function server.setVehicleTransponder(vehicle_id, is_active)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.transponderActive = is_active;
end
function server.setVehicleEditable(vehicle_id, is_editable)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.editable = is_editable;
end

--Mission
function server.getPlaylistIndexByName(name)
    for playListIndex = 1, #server.playlists do
        if server.playlists[playListIndex].name == name then
            return playListIndex;
        end
    end
end
function server.test_setPlaylistIndexCurrent(currentPlaylistIndex)
    server.playlists.currentPlaylistIndex = currentPlaylistIndex;
end
function server.getPlaylistIndexCurrent()
    return server.playlists.currentPlaylistIndex;
end
function server.getLocationIndexByName(playlist_index, name)
    assureParameterInBounds("playlist_index", playlist_index, 1);
    getOrSetArr(server.playlists[playlist_index].locations, {});
    for locationIndex = 1, #server.playlists[playlist_index].locations do
        if server.playlists[playlist_index].locations[locationIndex].name == name then
            return locationIndex;
        end
    end
end
function server.spawnThisPlaylistMissionLocation(name)
    local currentPlaylistIndex = server.getPlaylistIndexCurrent();
    assureNotNil("currentPlaylistIndex", currentPlaylistIndex);
    local locationIndex = server.getLocationIndexByName(currentPlaylistIndex, name);
    assureNotNil("locationIndex", locationIndex);
    server.playlists[currentPlaylistIndex].locations[locationIndex].spawned = true;
    printf("Location %d of playlist %d spawned.", locationIndex, currentPlaylistIndex);
end
function server.spawnMissionLocation(matrix, playlist_index, location_index)
    assureNotNil("matrix", matrix);
    assureParameterInBounds("playlist_index", playlist_index, 1);
    assureParameterInBounds("location_index", location_index, 1);
    if matrix[1] == 0 and matrix[2] == 0 and matrix[3] == 0 then
        matrix = modMatrix.random(matrix);
    end
    server.playlists[playlist_index].locations[location_index].pos = matrix;
    server.playlists[playlist_index].locations[location_index].spawned = true;
    return matrix;
end
function server.getPlaylistPath(playlist_name, is_rom)
    local playlistIndex = server.getPlaylistIndexByName(playlist_name);
    assureNotNil("playlistIndex", playlistIndex);
    local playList = server.playlists[playlistIndex];
    assureNotNil("playList", playList);
    return playList.filePath;
end
function server.spawnObject(matrix, OBJECT_TYPE)
    assureParameterInBounds("OBJECT_TYPE", OBJECT_TYPE, 0, 63);
    local objectIndex = #server.objects + 1;
    local objectId = getRandomId();
    getOrSetArr(server.objects, objectIndex);
    server.objects[objectIndex].id = objectId;
    server.objects[objectIndex].type = OBJECT_TYPE;
    server.objects[objectIndex].is_found = false;
    server.objects[objectIndex].pos = matrix;
    return objectId;
end
function server.getObjectPos(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local object = getArrayElementById(server.objects, object_id);
    assureNotNil("object", object);
    return object.is_found, object.pos;
end
function server.spawnFire(matrix, size, magnitude, is_lit, is_initialzied, is_explosive, parent_vehicle_id, explosion_magnitude)
    assureParameterInBounds("parent_vehicle_id", parent_vehicle_id, 1);
    local objectIndex = #server.objects + 1;
    local objectId = getRandomId();
    getOrSetArr(server.objects, objectIndex);
    server.objects[objectIndex].id = objectId;
    server.objects[objectIndex].pos = matrix;
    server.objects[objectIndex].size = size;
    server.objects[objectIndex].magnitude = magnitude;
    server.objects[objectIndex].is_lit = is_lit;
    server.objects[objectIndex].is_initialized = is_initialzied;
    server.objects[objectIndex].is_explosive = is_explosive;
    server.objects[objectIndex].parent_vehicle_id = parent_vehicle_id;
    server.objects[objectIndex].explosion_magnitude = explosion_magnitude;
    return objectId;
end
function server.despawnObject(object_id, is_instant)
    assureParameterInBounds("object_id", object_id, 1);
    destroyArrayElementById(server.objects, object_id);
end
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
    return characterId;
end
function server.spawnAnimal(matrix, animal_type, scale)
    assureParameterInBounds("animal_type", animal_type, 1, 5);
    local objectId = getRandomId();
    local objectIndex = #server.objects + 1;
    getOrSetArr(server.objects, objectIndex);
    server.objects[objectIndex].id = objectId;
    server.objects[objectIndex].pos = matrix;
    server.objects[objectIndex].animal_type = animal_type;
    server.objects[objectIndex].scale = scale;
    return objectId;
end
function server.despawnCharacter(object_id, is_instant)
    assureParameterInBounds("object_id", object_id, 1);
    destroyArrayElementById(server.objects, object_id);
end
function server.getCharacterData(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    return character.hp, character.pos, character.is_incapacitated, character.hp == 0;
end
function server.setCharacterData(object_id, hp, is_interactable)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    assureNotNil("character", character);
    character.hp = hp;
    character.is_interactable = is_interactable;
end
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
    printf("Character '%d' has item '%d' on slot %d and it's " .. (is_active and "active" or "not active"), object_id, EQUIPMENT_ID, slot);
end
function server.getTutorial()
    return server.playlists.tutorial and server.playlists.tutorial or false;
end
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
function server.isInZone(matrix, zone_display_name)
    -- TODO
    error("Matrix not implemented yet.");
end
function server.spawnMissionObject(matrix, playlist_index, location_index, object_index)
    assureNotNil("matrix", matrix);
    assureNotNil("server.playlists[playlist_index]", server.playlists[playlist_index]);
    assureNotNil("server.playlists[playlist_index].locations[location_index]", server.playlists[playlist_index].locations[location_index]);
    local objectId = server.playlists[playlist_index].locations[location_index].objects[object_index];
    assureNotNil("objectId", objectId);
    local object = getArrayElementById(server.objects, objectId);
    assureNotNil("object", object);
    object.spawned = true;
    printf("Spawned object %d of playlist %d and its location %d", object_index, playlist_index, location_index);
    return object.id;
end
function server.despawnMissionObject(object_id, is_instant)
    local object = getArrayElementById(server.objects, object_id);
    assureNotNil("object", object);
    object.spawned = false;
    printf("Despawned object with id %d" .. (is_instant and "instantly" or ""), object_id);
end
function server.getPlaylistCount()
    return #server.playlists;
end
function server.getPlaylistData(playlist_index)
    return server.playlists[playlist_index];
end
function server.getLocationData(playlist_index, location_index)
    return server.playlists[playlist_index].locations[location_index];
end
function server.getLocationObjectData(playlist_index, location_index, object_index)
    assureNotNil("matrix", matrix);
    assureNotNil("server.playlists[playlist_index]", server.playlists[playlist_index]);
    assureNotNil("server.playlists[playlist_index].locations[location_index]", server.playlists[playlist_index].locations[location_index]);
    local objectId = server.playlists[playlist_index].locations[location_index].objects[object_index];
    assureNotNil("objectId", objectId);
    local object = getArrayElementById(server.objects, objectId);
    assureNotNil("object", object);
    return object;
end
function server.setFireData(object_id, is_lit, is_explosive)
    assureParameterInBounds("object_id", object_id, 1)
    local fire = getArrayElementById(server.objects, object_id);
    assureNotNil("fire", fire);
    fire.is_lit = is_lit;
    fire.is_explosive = is_explosive;
end
function server.getFireData(object_id)
    assureParameterInBounds("object_id", object_id, 1)
    local fire = getArrayElementById(server.objects, object_id);
    assureNotNil("fire", fire);
    return fire.is_lit;
end
function server.getOceanTransform(matrix, min_search_range, max_search_range)
    -- TODO
    error("Matrix not implemented yet.");
end
function server.isInTransformArea(matrix_object, matrix_zone, zone_x, zone_y, zone_z)
    -- TODO
    error("Matrix not implemented yet.");
end

--Game
function server.setGameSetting(GAME_SETTING, value)
    assureValueInArray(server.gameSettings.GAME_SETTINGS, GAME_SETTING);
    server.gameSettings.settings[GAME_SETTING] = value;
end
function server.getGameSettings()
    return server.gameSettings.settings;
end
function server.setCurrency(money, research)
    server.gameSettings.money = money;
    server.gameSettings.research = research;
end
function server.getCurrency()
    return server.gameSettings.money;
end
function server.getResearchPoints()
    return server.gameSettings.research;
end
function server.test_setDateValue(value)
    server.gameSettings.date = value;
end
function server.getDateValue()
    return server.gameSettings.date;
end
function server.getTimeMillisec()
    return os.time();
end
function server.test_setTilePurchased(matrix, purchased)
    local tileIndex = #server.tiles + 1;
    getOrSetArr(server.tiles, tileIndex);
    server.tiles[tileIndex].purchased = purchased;
    server.tiles[tileIndex].matrix = matrix;
end
function server.getTilePurchased(matrix)
    error("Matrix not implemented.");
end
--[[Set callback to httpReply to make the script answer.]]
function server.test_setHttpGetCallback(callback)
    server.httpGetCallback = callback;
end
function server.httpGet(port, request_body)
    if server.httpGetCallback then
        return server.httpGetCallback(port, request_body);
    end
end

-- admin
-- added with v1.0
function server.banPlayer(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.isBanned = true;
end
function server.kickPlayer(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.gotKicked = true;
end
function server.addAdmin(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.admin = true;
end
function server.removeAdmin(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.admin = false;
end
function server.addAuth(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.auth = true;
end
function server.removeAuth(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    peer.auth = false;
end

function matrix.multiply(matrix1, matrix2)
    return modMatrix.mul(matrix1, matrix2);
end
function matrix.invert(matrix)
    return modMatrix.invert(matrix);
end
function matrix.transpose(matrix)
    return modMatrix.transpose(matrix);
end
function matrix.identity()
end
function matrix.rotationX(radians)
end
function matrix.rotationY(radians)
end
function matrix.rotationZ(radians)
end
function matrix.translation(x,y,z)
    return {x, y, z};
end
function matrix.position(matrix)
    return matrix[1], matrix[2], matrix[3];
end
function matrix.distance(matrix1, matrix2)
end

-- Simulation

function server.event_worldCreate(creatingWorld)
    if onCreate then
        onCreate(creatingWorld);
    end
end
function server.event_worldExit()
    if onDestroy then
        onDestroy()
    end
end
function server.event_playerCommand(player_peer_id, chat_command)
    local peer = getArrayElementById(server.peers, player_peer_id);
    assureNotNil("peer", peer);
    local commandSplit = {};
    string.gsub(chat_command, " ", function(c)
        table.insert(commandSplit, c);
    end);
    if onCustomCommand then
        onCustomCommand("", player_peer_id, peer.admin, peer.auth, table.unpack(commandSplit));
    end
end
function server.event_chatMessage(player_peer_id, message)
    local peer = getArrayElementById(server.peers, player_peer_id);
    assureNotNil("peer", peer);
    if onChatMessage then
        onChatMessage(peer.name, message);
    end
end
function server.event_playerJoin(steamid, peerId, name, isAdmin, isAuthed)
    if #server.peers == 0 then
        server.peers[1] = {
            id = 0,
            name = "Server",
            steamid = "90071992547409920"
        };
        if onPlayerJoin then
            onPlayerJoin(server.peers[1].steamid, server.peers[1].name, 0, true, true);
        end
    end
    local peerIndex = #server.peers + 1;
    local peer = getOrSetArr(server.peers, peerIndex);
    peer.id = peerId;
    peer.steamid = steamid;
    peer.name = name;
    peer.admin = isAdmin;
    peer.auth = isAuthed;
    peer.pos = {getRandomId(), getRandomId(), getRandomId()};
    server.notify(-1, "[Server]", peer.name .. " joined the game", 5);
    if onPlayerJoin then
        onPlayerJoin(peer.steamid, peer.name, peer.id, peer.admin, peer.auth);
    end
    return peerId;
end
function server.event_playerLeave(peer_id)
    local peer = getArrayElementById(server.peers, peer_id);
    assureNotNil("peer", peer);
    if onPlayerLeave then
        onPlayerLeave(peer.steamid, peer.name, peer.id, peer.admin, peer.auth);
    end
    server.notify(-1, "[Server]", peer.name .. " left the game", 6);
    destroyArrayElementById(server.peers, peer_id);
end
function server.event_playerDie(peer_id)
    local peer = getArrayElementById(server.peers);
    if onPlayerDie then
        onPlayerDie(peer.steamid, peer.name, peer.id, peer.admin, peer.auth);
    end
end
function server.event_vehicleSpawn(peer_id, vehicleName, x, y, z)
    local vehicleId = getRandomId();
    local vehicleIndex = #server.vehicles + 1;
    local vehicle = getOrSetArr(server.vehicles, vehicleIndex);
    vehicle.id = vehicleId;
    vehicle.owner = peer_id;
    vehicle.name = vehicleName;
    vehicle.pos = {x, y, z};
    if onVehicleSpawn then
        onVehicleSpawn(vehicleId, peer_id, x, y, z);
    end
    return vehicleId;
end
function server.event_playerTeleportVehicle(peer_id, vehicle_id, x, y, z)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.pos = {x, y, z};
    if onVehicleTeleport then
        onVehicleTeleport(vehicle_id, peer_id, x, y, z);
    end
end
