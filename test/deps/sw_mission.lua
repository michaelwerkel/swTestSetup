server = {};
server.mapObjects = {};
server.peers = {};
server.vehicles = {};

--[[ http://www.cplusplus.com/reference/cstdio/printf/ ]]
function printf(s,...)
    return io.write(s:format(...));
end

function assureParameterInBounds(name, value, min, max)
    if value < min or (max and (value > max) or true) then
        error(name .. " out of bounds.");
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
        end
    end
end
function server.getPlayerName(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    for index = 1, #server.peers do
        if server.peers[i].id == peer_id then
            return server.peers[i].name;
        end
    end
    return nil;
end
function server.getPlayers()
    return server.peers;
end
function server.test_setPlayerPos(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, -1);
    getOrSetArr(server.peer, index);
    for index = 1, #server.peers do
        if server.peers[peer_id].id == peer_id then
            server.peers[peer_id].pos = matrix;
        end
    end
end
function server.getPlayerPos(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    for index = 1, #server.peers do
        if server.peers[peer_id].id == peer_id then
            return server.peers[peer_id].pos;
        end
    end
    return nil;
end
function server.teleportPlayer(peer_id, matrix)
    assureParameterInBounds("peer_id", peer_id, -1);
    for i = 1, #server.peers do
        if server.peers[i].id == peer_id then
            server.peers[i].pos = matrix;
        end
    end
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
    for i = 1, #server.peers do
        if server.peers[i].id == peer_id then
            server.peers[i].lookDirection = lookDirection;
        end
    end
end
function server.getPlayerLookDirection(peer_id)
    assureParameterInBounds("peer_id", peer_id, -1);
    for i = 1, #server.peers do
        if server.peers[i].id == peer_id then
            return server.peers[i].lookDirection;
        end
    end
    return nil;
end

--Vehicle
function server.spawnVehicle(matrix, playlist_index, component_id)
    assureParameterInBounds("playlist_index", playlist_index, 1);
    local vehicleIndex = #server.vehicles;
    getOrSetArr(server.vehicles, vehicleIndex);
    server.vehicles[vehicleIndex].id = server.getRandomId();
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].component_id = component_id;
    server.vehicles[vehicleIndex].playlist_index = playlist_index;
    return server.vehicles[vehicleIndex].id;
end
function server.spawnVehicleSavefile(matrix, save_name)
    local vehicleIndex = #server.vehicles;
    getOrSetArr(server.vehicles, vehicleIndex);
    server.vehicles[vehicleIndex].id = server.getRandomId();
    server.vehicles[vehicleIndex].pos = matrix;
    server.vehicles[vehicleIndex].save_name = save_name;
    return server.vehicles[vehicleIndex].id;
end
function server.despawnVehicle(vehicle_id, is_instant)
    assureParameterInBounds("vehicle_id", vehicle_id, 1)
    for playListId = 1, #server.vehicles do
        server.vehicles[playListId][vehicle_id] = nil;
    end
end
function server.test_setVehiclePos(vehicle_id, voxelX, voxelY, voxelZ)
    for i = 1, #server.vehicles do
        
    end
end
function server.getVehiclePos(vehicle_id, voxel_x, voxel_y, voxel_z)

end
function server.getVehicleName(vehicle_id)
end
function server.teleportVehicle(matrix, vehicle_id)
end
function server.cleanVehicles()
end
function server.pressVehicleButton(vehicle_id, button_name)
end
function server.getVehicleFireCount(vehicle_id)
end
function server.setVehicleTooltip(vehicle_id, text)
end
function server.getVehicleSimulating(vehicle_id)
end
function server.setVehicleTransponder(vehicle_id, is_active)
end
function server.setVehicleEditable(vehicle_id, is_editable)
end

--Mission
function server.getPlaylistIndexByName(name)
end
function server.getPlaylistIndexCurrent()
end
function server.getLocationIndexByName(playlist_index, name)
end
function server.spawnThisPlaylistMissionLocation(name)
end
function server.spawnMissionLocation(matrix, playlist_index, location_index) 
end
function server.getPlaylistPath(playlist_name, is_rom)
end
function server.spawnObject(matrix, OBJECT_TYPE)
end
function server.getObjectPos(object_id)
end
function server.spawnFire(matrix, size, magnitude, is_lit, is_initialzied, is_explosive, parent_vehicle_id, explosion_magnitude)
end
function server.despawnObject(object_id, is_instant)
end
function server.spawnCharacter(matrix, outfit_id)
end
function server.spawnAnimal(matrix, animal_type, scale)
end
function server.despawnCharacter(object_id, is_instant)
end
function server.getCharacterData(object_id)
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