local lu = require("test/deps/luaunit");

require("test/deps/sw_mission");

TestSW = {};

function TestSW:setUp()
    server.mapObjects = {};
    server.peers = {};
    server.vehicles = {};
    server.playlists = {};
    server.objects = {};
    server.zones = {};
    server.gameSettings.settings = {};
end
function TestSW:testAnnounce()
    server.announce("Playerjoin", "Player myPlayerName joined.");
end
function TestSW:testWhisper()
    --Arrange
    server.peers[1] = {};
    
    --Act
    server.whisper(1, "Hi");
end
function TestSW:testNotify()
    --Arrange
    server.peers[1] = {};
    
    --Act
    server.notify(1, "Welcome!", "Hello dude!", 4);
end
function TestSW:testGetMapID()
    --Arrange
    server.mapObjects[1] = {};

    -- Act
    local result = server.getMapID();

    -- Assert
    lu.assertIsTrue(result >= 1);
    lu.assertIsTrue(result <= 999999);
end
function TestSW:testRemoveMapID()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();
    server.mapObjects[1][uiId] = {};

    -- Act
    server.removeMapID(1, uiId);

    -- Assert
    lu.assertEquals(#server.mapObjects[1], 0);
end
function TestSW:testAddMapObject()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    -- Act
    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].mapObject ~= nil);
end
function TestSW:testRemoveMapObject()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");

    -- Act
    server.removeMapObject(1, uiId);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].mapObject == nil);
end
function TestSW:testAddMapLabel()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");

    -- Act
    server.addMapLabel(1, uiId, 0, "MyLabel", 123, 123, 123);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].label ~= nil);
end
function TestSW:testRemoveMapLabel()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");
    server.addMapLabel(1, uiId, 0, "MyLabel", 123, 123, 123);

    -- Act
    server.removeMapLabel(1, uiId);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].label == nil);
end
function TestSW:testAddMapLine()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");

    -- Act
    server.addMapLine(1, uiId, {}, {}, 2);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].line ~= nil);
end
function TestSW:testRemoveMapLine()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");
    server.addMapLine(1, uiId, {}, {}, 2);

    -- Act
    server.removeMapLine(1, uiId);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].line == nil);
end
function TestSW:testSetPopUp()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");
    server.createPopup(1, uiId);

    -- Act
    server.setPopup(1, uiId, "MyPopup", true, "MyPopUpText", 123, 123, 123, false, 321);

    -- Assert
    lu.assertEquals(server.mapObjects[1][uiId].popup.name, "MyPopup");
end
function TestSW:testRemovePopUp()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");
    server.createPopup(1, uiId);

    -- Act
    server.removePopup(1, uiId);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].popup == nil);
end
function TestSW:testCreatePopup()
    --Arrange
    server.mapObjects[1] = {};
    local uiId = server.getMapID();

    server.addMapObject(1, uiId, 2, 6, 123, 123, 123, 0, 0, 0, 23, 23, "MyMapObject", 12, 166, "Rescue plz");

    -- Act
    server.createPopup(1, uiId);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].popup ~= nil);
end
function TestSW:testGetPlayerName()
    -- Arrange
    server.peers[1] = {
        ["id"] = 1
    };
    server.test_setPlayerName(1, "ActionedPlayer");

    -- Act
    local playerName = server.getPlayerName(1);

    -- Assert
    lu.assertEquals("ActionedPlayer", playerName);
end
function TestSW:testGetPlayers()
    -- Arrange
    server.peers[1] = {
        ["id"] = 123
    }

    -- Act
    local players = server.getPlayers();

    -- Assert
    lu.assertEquals(#players, 1);
end
function TestSW:testGetPlayerPos()
    -- Arrange
    server.peers[1] = {
        ["id"] = 123
    };

    server.test_setPlayerPos(123, {x = 123, y = 123, z = 123});

    -- Act
    local matrix = server.getPlayerPos(123);

    -- Assert
    lu.assertTableContains(matrix, 123);
end
function TestSW:testTeleportPlayer()
    -- Arrange
    server.peers[123] = {
        ["id"] = 1
    };

    -- Act
    server.teleportPlayer(1, {x = 1, y = 2, z = 3});

    -- Assert
    lu.assertTableContains(server.peers[123].pos, 3);
end
function TestSW:testKillPlayer()
    -- Arrange
    server.peers[1] = {
        ["id"] = 1
    };

    -- Act
    server.killPlayer(1);
end
function TestSW:testSetSeated()
    -- Arrange
    server.peers[1] = {
        ["id"] = 1
    };
    server.vehicles[1] = {
        ["id"] = 23
    };

    -- Act
    server.setSeated(1, 23, "Pilot");
end
function TestSW:testGetPlayerLookDirection()
    -- Arrange
    server.peers[1] = {
        ["id"] = 1
    };

    server.test_setPlayerLookDirection(1, {x = 1, y = 2, z = 3});

    -- Act
    local lookDirection = server.getPlayerLookDirection(1);

    -- Assert
    lu.assertTableContains(lookDirection, 3);
end
function TestSW:testSpawnVehicle()
    -- Arrange
    server.playlists[123] = {};

    -- Act
    local vehicleId = server.spawnVehicle({x = 1, y = 2, z = 3}, 123, 3);

    -- Assert
    lu.assertIsTrue(vehicleId >= 1);
    lu.assertIsTrue(vehicleId <= 999999);
end
function TestSW:testSpawnVehicleSaveFile()
    -- Act
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Assert
    lu.assertNotIsNil(server.vehicles[1]);
    lu.assertIsTrue(vehicleId >= 1);
    lu.assertIsTrue(vehicleId <= 999999);
end
function TestSW:testDespawnVehicle()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.despawnVehicle(vehicleId, false);

    -- Assert
    lu.assertIsNil(server.vehicles[1]);
end
function TestSW:testGetVehiclePos()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    local vehiclePos = {x = 4, y = 5, z = 6};
    server.test_setVehiclePos(vehicleId, 1, 1, 1, vehiclePos);

    -- Act
    local matrix = server.getVehiclePos(vehicleId, 1, 1, 1);

    -- Assert
    lu.assertEquals(matrix, vehiclePos);
end
function TestSW:testGetVehicleName()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    server.vehicles[1].name = "MyVehicle";

    -- Act
    local vehicleName = server.getVehicleName(vehicleId);

    -- Assert
    lu.assertEquals(vehicleName, "MyVehicle");
end
function TestSW:testTeleportVehicle()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    server.vehicles[1].pos = {x = 1, y = 2, z = 3};
    local newPos = {x = 4, y = 5, z = 6};

    -- Act
    server.teleportVehicle(newPos, vehicleId);

    -- Assert
    lu.assertEquals(server.vehicles[1].pos, newPos);
end
function TestSW:testCleanVehicles()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.cleanVehicles();
    
    -- Assert
    lu.assertIsNil(server.vehicles[1]);
end
function TestSW:testPressVehicleButton()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.pressVehicleButton(vehicleId, "MyButton");
end
function TestSW:testGetVehicleFireCount()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    server.test_setVehicleFireCount(vehicleId, 2);

    -- Act
    local fireCount = server.getVehicleFireCount(vehicleId);

    -- Assert
    lu.assertEquals(fireCount, 2);
end
function TestSW:testSetVehicleToolTip()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.setVehicleTooltip(vehicleId, "MyToolTip");

    -- Assert
    lu.assertEquals(server.vehicles[1].toolTip, "MyToolTip");
end
function TestSW:testGetVehicleSimulating()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    server.vehicles[1].simulating = true;

    -- Act
    local simulating = server.getVehicleSimulating(vehicleId);

    -- Assert
    lu.assertEquals(simulating, true);
end
function TestSW:testSetVehicleTransponder()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.setVehicleTransponder(vehicleId, true);

    -- Assert
    lu.assertEquals(server.vehicles[1].transponderActive, true);
end
function TestSW:testSetVehicleEditable()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.setVehicleEditable(vehicleId, false);

    -- Assert
    lu.assertEquals(server.vehicles[1].editable, false);
end

function TestSW:testGetPlaylistIndexByName()
    -- Arrange
    server.playlists[1] = {
        name = "MyPlaylist"
    };

    -- Act
    local index = server.getPlaylistIndexByName("MyPlaylist");

    -- Assert
    lu.assertEquals(index, 1);
end
function TestSW:testGetLocationIndexByName()
    -- Arrange
    server.playlists[1] = {
        name = "MyPlaylist",
        locations = {
            [1] = {
                name = "MyLocation"
            }
        }
    };

    -- Act
    local index = server.getLocationIndexByName(1, "MyLocation");

    -- Assert
    lu.assertEquals(index, 1);
end
function TestSW:testSpawnThisPlaylistMissionLocation()
    -- Arrange
    server.playlists.currentPlaylistIndex = 1;
    server.playlists[1] = {
        name = "MyPlaylist",
        locations = {
            [1] = {
                name = "MyLocation"
            }
        }
    };

    -- Act
    server.spawnThisPlaylistMissionLocation("MyLocation");

    -- Assert
    lu.assertIsTrue(server.playlists[1].locations[1].spawned);
end
function TestSW:testSpawnMissionLocation()
    error("Matrix object not implemented");
end
function TestSW:testGetPlaylistPath()
    -- Arrange
    local playlistPath = "./MyPlaylist.xml";
    server.playlists[1] = {
        name = "MyPlaylist",
        filePath = playlistPath;
    };

    -- Act
    local resultPlaylistPath = server.getPlaylistPath("MyPlaylist", false);

    -- Assert
    lu.assertEquals(resultPlaylistPath, playlistPath);
end
function TestSW:testSpawnObject()
    server.spawnObject({x = 1, y = 2, z = 3}, 9);
end
function TestSW:testGetObjectPos()
    -- Act
    local objectId = server.spawnObject({x = 1, y = 2, z = 3}, 21);

    -- Assert
    lu.assertEquals(server.objects[1].type, 21);

end
function TestSW:testGetObjectPos()
    -- Arrange
    local objectPos = {x = 1, y = 2, z = 3};
    local objectId = server.spawnObject(objectPos, 21);

    -- Assert
    local found, pos = server.getObjectPos(objectId);

    -- Assert
    lu.assertEquals(found, false);
    lu.assertEquals(pos, objectPos);
end
function TestSW:testSpawnFire()
    -- Act
    local fireId = server.spawnFire({x = 1, y = 2, z = 3}, 2, 3, false, false, false, 1, 4);

    -- Assert
    lu.assertNotIsNil(server.objects[1])
end
function TestSW:testDespawnObject()
    -- Arrange
    local objectId = server.spawnObject({x = 1, y = 2, z = 3}, 21);

    -- Act
    server.despawnObject(objectId, true);

    -- Assert
    lu.assertIsNil(server.objects[1])
end
function TestSW:testSpawnCharacter()
    -- Act
    local objectId = server.spawnCharacter({x = 1, y = 2, z = 3}, 7);

    -- Assert
    lu.assertEquals(server.objects[1].outfit_id, 7);
end
function TestSW:testSpawnAnimal()
    -- Act
    local objectId = server.spawnAnimal({x = 1, y = 2, z = 3}, 1);

    -- Assert
    lu.assertEquals(server.objects[1].animal_type, 1);
end
function TestSW:testDespawnCharacter()
    -- Arrange
    local objectId = server.spawnCharacter({x = 1, y = 2, z = 3}, 7);

    -- Act
    server.despawnCharacter(objectId, true);

    -- Assert
    lu.assertIsNil(server.objects[1]);
end
function TestSW:testGetCharacterData()
    -- Arrange
    local objectId = server.spawnCharacter({x = 1, y = 2, z = 3}, 7);

    -- Act
    local hp, pos, incapacitated, dead = server.getCharacterData(objectId);

    -- Arrange
    lu.assertEquals(hp, 1);
end
function TestSW:testSetCharacterData()
    -- Arrange
    local objectId = server.spawnCharacter({x = 1, y = 2, z = 3}, 7);

    -- Act
    server.setCharacterData(objectId, .5, true);

    -- Arrange
    lu.assertEquals(server.objects[1].hp, .5);
end
function TestSW:testSetCharacterItem()
    -- Arrange
    local objectId = server.spawnCharacter({x = 1, y = 2, z = 3}, 7);

    -- Act
    server.setCharacterItem(objectId, 3, 17, false);

    -- Arrange
    lu.assertEquals(server.objects[1].inventory[3], 17);
end
function TestSW:testGetZones()
    -- Arrange
    server.zones[1] = {
        tags = {
            "CoolCar"
        }
    }
    -- Act
    local zones = server.getZones("AnotherTag", "CoolCar");

    -- Assert
    lu.assertEquals(zones[1].tags[1], server.zones[1].tags[1]);
end
function TestSW:testIsInZone()
    server.isInZone()
end
function TestSW:testSpawnMissionObject()
    server.spawnMissionObject();
end
function TestSW:testDespawnMissionObject()
    server.despawnMissionObject();
end
function TestSW:testGetLocationObjectData()
    server.getLocationObjectData();
end
function TestSW:testSetFireData()
    -- Arrange
    local fireId = server.spawnFire({x = 1, y = 2, z = 3}, 2, 3, false, false, false, 1, 4);

    -- Act
    server.setFireData(fireId, true, false);

    -- Assert
    lu.assertIsTrue(server.objects[1].is_lit);
end
function TestSW:testGetFireData()
    -- Arrange
    local fireId = server.spawnFire({x = 1, y = 2, z = 3}, 2, 3, false, false, false, 1, 4);
    server.setFireData(fireId, true, false);

    -- Act
    local lit = server.getFireData(fireId);

    -- Assert
    lu.assertIsTrue(lit);
end
function TestSW:testGetOceanTransform()
    server.getOceanTransform()
end
function TestSW:testIsInTransformArea()
    server.isInTransformArea()
end
function TestSW:testSetGameSetting()
    -- Act
    server.setGameSetting("despawn_on_leave", true);

    -- Assert
    lu.assertIsTrue(server.gameSettings.settings["despawn_on_leave"])
end
function TestSW:testSetCurrency()
    -- Act
    server.setCurrency(112, 113);

    --Assert
    lu.assertEquals(server.gameSettings.money, 112);
    lu.assertEquals(server.gameSettings.research, 113);
end
function TestSW:testGetTilePurchased()
    -- Arrange
    server.test_setTilePurchased({x = 1, y = 2, z = 3});

    -- Act
    local purchased = server.getTilePurchased({x = 1, y = 2, z = 3});

    -- Assert
    lu.assertIsTrue(purchased);
end

local runner = lu.LuaUnit.new();
os.exit(runner:run());