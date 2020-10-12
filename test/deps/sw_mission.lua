server = {};
server.mapObjects = {};
server.peers = {};
server.vehicles = {};
server.playlists = {};
server.objects = {};

--[[ http://www.cplusplus.com/reference/cstdio/printf/ ]]
function printf(s,...)
    return io.write(s:format(...));
end

function assureParameterInBounds(name, value, min, max)
    if value < min or (max and (value > max) or true) then
        error(name .. " out of bounds.");
    end
end
function assureNotNil(name, value)
    if not value then
        error(name .. " doesn't exist.");
    end
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
function getArrayElementById(arrRoot, id)
    for elementIndex = 1, #arrRoot do
        if arrRoot[elementIndex].id == id then
            return arrRoot[elementIndex];
        end
    end
end
function getArrayElementById(arrRoot, id)
    for elementIndex = 1, #arrRoot do
        if arrRoot[elementIndex].id == id then
            return arrRoot[elementIndex];
        end
    end
end
function destroyArrayElementById(arrRoot, id)
    for elementIndex = 1, #arrRoot do
        if arrRoot[elementIndex].id == id then
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
    printf("Whispering peer %d with '%s'", peer_id, message);
end
function server.notify(peer_id, title, message, NOTIFICATION_TYPE)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("NOTIFICATION_TYPE", NOTIFICATION_TYPE, 0, 9);
    printf("Notifiing peer %d with '%s', '%s', %d", peer_id, title, message, NOTIFICATION_TYPE)
end
function server.getMapID()
    return getRandomId();
end
function server.removeMapID(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    server.mapObjects[peer_id][ui_id] = nil;
end
function server.addMapObject(peer_id, ui_id, POSITION_TYPE, MARKER_TYPE, x, y, z, parent_local_x, parent_local_y, parent_local_z, vehicle_id, object_id, label, vehicle_parent_id, radius, hover_label)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    assureParameterInBounds("POSITION_TYPE", POSITION_TYPE, 0, 2);
    assureParameterInBounds("MARKER_TYPE", MARKER_TYPE, 0, 8);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    getOrSetArr(server.mapObjects[peer_id[ui_id]], "mapObject");
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
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    server.mapObjects[peer_id][ui_id].mapObject = nil;
end
function server.addMapLabel(peer_id, ui_id, LABEL_TYPE, name, x, y, z)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    assureParameterInBounds("LABEL_TYPE", LABEL_TYPE, 0, 14);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    getOrSetArr(server.mapObjects[peer_id[ui_id]], "label");
    server.mapObjects[peer_id][ui_id].label.LABEL_TYPE = LABEL_TYPE;
    server.mapObjects[peer_id][ui_id].label.name = name;
    server.mapObjects[peer_id][ui_id].mapObject.x = x;
    server.mapObjects[peer_id][ui_id].mapObject.y = y;
    server.mapObjects[peer_id][ui_id].mapObject.z = z;
end
function server.removeMapLabel(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    server.mapObjects[peer_id][ui_id].label = nil;
end
function server.addMapLine(peer_id, ui_id, start_matrix, end_matrix, width)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    getOrSetArr(server.mapObjects[peer_id[ui_id]], "line");
    server.mapObjects[peer_id][ui_id].line.start_matrix = start_matrix;
    server.mapObjects[peer_id][ui_id].line.end_matrix = end_matrix;
    server.mapObjects[peer_id][ui_id].line.width = width;
end
function server.removeMapLine(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    server.mapObjects[peer_id][ui_id].line = nil;
end
function server.setPopup(peer_id, ui_id, name, is_show, text, x, y, z, is_worldspace, render_distance)
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
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
    assureParameterInBounds("peer_id", peer_id, -1);
    assureParameterInBounds("ui_id", ui_id, -1);
    server.mapObjects[peer_id][ui_id].popup = nil;
end
function server.createPopup(peer_id, ui_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    getOrSetArr(server.mapObjects, peer_id)
    getOrSetArr(server.mapObjects[peer_id], ui_id);
    getOrSetArr(server.mapObjects[peer_id[ui_id]], "popup");
end

--Player
function server.test_setPlayerName(peer_id, name)
    assureParameterInBounds("peer_id", peer_id, -1);
    getOrSetArr(server.peer, peer_id);
    for index = 1, #server.peers do
        if server.peers[peer_id].id == peer_id then
            server.peers[peer_id].name = name;
            break;
        end
    end
end
function server.getPlayerName(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    return peer and peer.name or nil;
end
function server.getPlayers()
    return server.peers;
end
function server.test_setPlayerPos(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, -1);
    getOrSetArr(server.peer, index);
    local peer = getArrayElementById(server.peers, peer_id);
    peer.pos = matrix;
end
function server.getPlayerPos(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    return peer and peer.pos or nil;
end
function server.teleportPlayer(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    peer.pos = matrix;
end
function server.killPlayer(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    printf("Killed peer id %d", peer_id);
end
function server.setSeated(peer_id, vehicle_id, seat_name)
    assureParameterInBounds("peer_id", peer_id, -1);
    printf("Seated peer id %d in %d on %s", peer_id, vehicle_id, seat_name)
end
function server.test_setPlayerLookDirection(peer_id, lookDirection)
    getOrSetArr(server.peer, peer_id);
    local peer = getArrayElementById(server.peers, peer_id);
    peer.lookDirection = lookDirection;
end
function server.getPlayerLookDirection(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    local peer = getArrayElementById(server.peers, peer_id);
    return peer and peer.lookDirection or nil;
end

--Vehicle
function server.spawnVehicle(matrix, playlist_index, component_id)
    assureParameterInBounds("playlist_index", playlist_index, 1);
    local vehicleIndex = #server.vehicles + 1;
    getOrSetArr(server.vehicles, vehicleIndex);
    server.vehicles[vehicleIndex].id = server.getRandomId();
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].component_id = component_id;
    server.vehicles[vehicleIndex].playlist_index = playlist_index;
    return server.vehicles[vehicleIndex].id;
end
function server.spawnVehicleSavefile(matrix, save_name)
    local vehicleIndex = #server.vehicles + 1;
    getOrSetArr(server.vehicles, vehicleIndex);
    server.vehicles[vehicleIndex].id = server.getRandomId();
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].save_name = save_name;
    return server.vehicles[vehicleIndex].id;
end
function server.despawnVehicle(vehicle_id, is_instant)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    destroyArrayElementById(server.vehicles, vehicle_id);
end
function server.test_setVehiclePos(vehicle_id, voxelX, voxelY, voxelZ)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    vehicle.voxelX = voxel_x;
    vehicle.voxelY = voxel_y;
    vehicle.voxelZ = voxel_z;
end
function server.getVehiclePos(vehicle_id, voxel_x, voxel_y, voxel_z)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    return vehicle.pos;
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
    return vehicle.pos;
end
function server.cleanVehicles()
    server.vehicles = {};
end
function server.pressVehicleButton(vehicle_id, button_name)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
    printf("Button '%s' of vehicle '%d' has been pressed.", button_name, vehicle_id);
end
function server.test_setVehicleFireCount(vehicle_id, count)
    assureParameterInBounds("vehicle_id", vehicle_id, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
    assureNotNil("vehicle", vehicle);
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
    printf("Tooltip for vehicle '%d' set to '%s'", vehicle_id, text);
end
function server.test_setVehicleSimulating(vehicleId, simulating)
    assureParameterInBounds("vehicleId", vehicleId, 1);
    local vehicle = getArrayElementById(server.vehicles, vehicle_id);
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
        if server.playlists[playListIndex] == name then
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
    for locationIndex = 1, server.playlists[playlist_index].locations do
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
    printf("Location %d of playlist $d spawned.", locationIndex, currentPlaylistIndex);
end
function server.spawnMissionLocation(matrix, playlist_index, location_index)
    assureParameterInBounds("playlist_index", playlist_index, 1);
    server.playlists[playlist_index].locations[location_index].pos = matrix;
    server.playlists[playlist_index].locations[location_index].spawned = true;
    --TODO: Return random matrix if matrix is 0,0,0
    return matrix;
end
function server.getPlaylistPath(playlist_name, is_rom)
    local playlistIndex = server.getPlaylistIndexByName(playlist_name);
    assureNotNil("playlistIndex", playlistIndex);
    local playList = server.playlists[playListIndex];
    assureNotNil("playList", playList);
    return playList.filePath;
end
function server.spawnObject(matrix, OBJECT_TYPE)
    assureParameterInBounds("OBJECT_TYPE", OBJECT_TYPE, 0, 63);
    printf("Object '%d' spawned at " .. matrix, OBJECT_TYPE);
end
function server.getObjectPos(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local object = getArrayElementById(server.objects, object_id);
    assureNotNil("object", object);
    return object.is_found, objects.pos;
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
    return characterId;
end
function server.spawnAnimal(matrix, animal_type, scale)
    -- Animal Types are not documented, trial and error needed
    assureParameterInBounds("animal_type", animal_type, 1);
    local characterId = getRandomId();
    local characterIndex = #server.objects + 1;
    getOrSetArr(server.objects, characterIndex);
    server.objects[characterIndex].id = characterId;
    server.objects[characterIndex].outfit_id = outfit_id;
    server.objects[characterIndex].pos = matrix;
    return characterId;
end
function server.despawnCharacter(object_id, is_instant)
    assureParameterInBounds("object_id", object_id, 1);
    destroyArrayElementById(server.objects, object_id);
end
function server.getCharacterData(object_id)
    assureParameterInBounds("object_id", object_id, 1);
    local character = getArrayElementById(server.objects, object_id);
    
end
function server.setCharacterData(object_id, hp, is_interactable)
end
function server.setCharacterItem(object_id, slot, EQUIPMENT_ID, is_active)
end
function server.getTutorial()
end
function server.getZones(tags)
end
function server.isInZone(matrix, zone_display_name)
end
function server.spawnMissionObject(matrix, playlist_index, location_index, object_index)
end
function server.despawnMissionObject(object_id, is_instant)
end
function server.getPlaylistCount()
end
function server.getPlaylistData(playlist_index)
end
function server.getLocationData(playlist_index, location_index)
end
function server.getLocationObjectData(playlist_index, location_index, object_index)
end
function server.setFireData(object_id, is_lit, is_explosive)
end
function server.getFireData(object_id)
end
function server.getOceanTransform(matrix, min_search_range, max_search_range)
end
function server.isInTransformArea(matrix_object, matrix_zone, zone_x, zone_y, zone_z)
end

--Game
function server.setGameSetting(GAME_SETTING, value)
end
function server.getGameSettings()
end
function server.setCurrency(money, research)
end
function server.getCurrency()
end
function server.getResearchPoints()
end
function server.getDateValue()
end
function server.getTimeMillisec()
end
function server.getTilePurchased(matrix)
end