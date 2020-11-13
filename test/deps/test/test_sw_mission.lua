local lu = require("test.deps.luaunit");
require("test.deps.sw_mission");

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
--[[
function TestSW:testWhisper()
    --Arrange
    local peerId = server.event_playerJoin(123, getRandomId(), "ActionedPlayer", false, false);
    
    --Act
    server.whisper(peerId, "Hi");
end
]]
function TestSW:testNotify()
    --Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", false, false);
    
    --Act
    server.notify(peerId, "Welcome!", "Hello dude!", 4);
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

    -- Act
    server.removePopup(1, uiId);

    -- Assert
    lu.assertIsTrue(server.mapObjects[1][uiId].popup == nil);
end
--[[
createPopup has been removed on v1.0.21

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
]]
function TestSW:testGetPlayerName()
    -- Arrange
    server.peers[1] = {
        ["id"] = 1
    };
    testsuite.test.setPlayerName(1, "ActionedPlayer");

    -- Act
    local playerName = server.getPlayerName(1);

    -- Assert
    lu.assertEquals("ActionedPlayer", playerName);
end
function TestSW:testGetPlayers()
    -- Arrange
    local peerId = testsuite.event.playerJoin(getRandomId(), getRandomId(), "ActionedPlayer", true, true);

    -- Act
    local players = server.getPlayers();

    -- Assert
    lu.assertEquals(#players, 2);
end
function TestSW:testGetPlayerPos()
    -- Arrange
    server.peers[1] = {
        ["id"] = 123
    };

    testsuite.test.setPlayerPos(123, {x = 123, y = 123, z = 123});

    -- Act
    local matrix = server.getPlayerPos(123);

    -- Assert
    lu.assertTableContains(matrix, 123);
end
function TestSW:testSetPlayerPos()
    -- Arrange
    server.peers[123] = {
        ["id"] = 1
    };

    -- Act
    server.setPlayerPos(1, {x = 1, y = 2, z = 3});

    -- Assert
    lu.assertTableContains(server.peers[123].pos, 3);
end
function TestSW:testKillCharacter()
    -- Arrange
    local peerId = testsuite.event.playerJoin(getRandomId(), getRandomId(), "ActionedPlayer", true, true);
    local characterId = server.getPlayerCharacterID(peerId);

    -- Act
    server.killCharacter(characterId);

    -- Assert
    local character = getArrayElementById(server.objects, characterId);
    lu.assertEquals(character.hp, 0);
    lu.assertIsTrue(character.is_incapacitated)
end
function TestSW:testReviveCharacter()
    -- Arrange
    local peerId = testsuite.event.playerJoin(getRandomId(), getRandomId(), "ActionedPlayer", true, true);
    local characterId = server.getPlayerCharacterID(peerId);
    server.killCharacter(characterId);

    -- Act
    server.reviveCharacter(characterId);

    -- Assert
    local character = getArrayElementById(server.objects, characterId);
    lu.assertEquals(character.hp, 1);
    lu.assertIsFalse(character.is_incapacitated)
end
function TestSW:testSetCharacterSeated()
    -- Arrange
    local peerId = testsuite.event.playerJoin(getRandomId(), getRandomId(), "ActionedPlayer", true, true);
    local vehicleId = testsuite.event.vehicleSpawn(peerId, "Police", 0, 0, 0);
    local characterId = server.getPlayerCharacterID(peerId);

    -- Act
    server.setCharacterSeated(characterId, vehicleId, "Pilot");

    -- Assert
    local vehicle = getArrayElementById(server.vehicles, vehicleId);
    lu.assertEquals(vehicle.seats.Pilot, characterId);
end
function TestSW:testGetPlayerLookDirection()
    -- Arrange
    local user1 = testsuite.event.playerJoin(getRandomId(), getRandomId(), "ActionedPlayer", true, true);

    testsuite.test.setPlayerLookDirection(user1, {x = 1, y = 2, z = 3});

    -- Act
    local lookDirection = server.getPlayerLookDirection(user1);

    -- Assert
    lu.assertTableContains(lookDirection, 3);
end
function TestSW:testGetPlayerCharacterId()
    -- Arrange
    local user1 = testsuite.event.playerJoin(getRandomId(), 123, "ActionedPlayer", true, true);

    -- Act
    local characterId = server.getPlayerCharacterID(123);

    -- Assert
    lu.assertIsTrue(characterId >= 1);
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
    server.despawnVehicle(vehicleId, true);

    -- Assert
    lu.assertIsNil(server.vehicles[1]);
end
function TestSW:testGetVehiclePos()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    local vehiclePos = {x = 4, y = 5, z = 6};
    testsuite.test.setVehiclePos(vehicleId, vehiclePos);

    -- Act
    local matrix = server.getVehiclePos(vehicleId);

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
function TestSW:testSetVehiclePos()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    server.vehicles[1].pos = {x = 1, y = 2, z = 3};
    local newPos = {x = 4, y = 5, z = 6};

    -- Act
    --server.teleportVehicle(newPos, vehicleId);
    server.setVehiclePos(newPos, vehicleId);

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
function TestSW:testGetVehicleButton()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    server.pressVehicleButton(vehicleId, "MyButton");

    -- Act
    local pressed = server.getVehicleButton(vehicleId, "MyButton");

    -- Assert
    local vehicle = getArrayElementById(server.vehicles, vehicleId);
    lu.assertEquals(pressed, vehicle.buttons.MyButton);
end
function TestSW:testPressVehicleButton()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.pressVehicleButton(vehicleId, "MyButton");

    -- Assert
    local vehicle = getArrayElementById(server.vehicles, vehicleId);
    lu.assertIsTrue(vehicle.buttons.MyButton);
end
function TestSW:testGetVehicleFireCount()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");
    testsuite.test.setVehicleFireCount(vehicleId, 2);

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
function TestSW:testSetVehicleSeatButton()
    -- Arrange
    local vehicleId = server.spawnVehicleSavefile({x = 1, y = 2, z = 3}, "vehicle.xml");

    -- Act
    server.setVehicleSeat(vehicleId, "MySeat", 0, 0, 0, 0, true);

    -- Assert
    local vehicle = getArrayElementById(server.vehicles, vehicleId);
    lu.assertIsTrue(true, vehicle.seats.MySeat.button1);
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
    local pos, success = server.getObjectPos(objectId);

    -- Assert
    lu.assertEquals(success, true);
    lu.assertEquals(pos, objectPos);
end
function TestSW:testSpawnFire()
    -- Act
    local fireId = server.spawnFire({x = 1, y = 2, z = 3}, 2, 3, false, false, 1, 4);

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
--[[
Removed on v1.0.21

function TestSW:testDespawnCharacter()
    -- Arrange
    local objectId = server.spawnCharacter({x = 1, y = 2, z = 3}, 7);

    -- Act
    server.despawnCharacter(objectId, true);

    -- Assert
    lu.assertIsNil(server.objects[1]);
end
]]
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
function TestSW:testGetCharacterItem()
    -- Arrange
    local objectId = server.spawnCharacter({x = 1, y = 2, z = 3}, 7);
    server.setCharacterItem(objectId, 3, 17, false);

    -- Act
    local equipmentId = server.getCharacterItem(objectId, 3);

    -- Arrange
    lu.assertEquals(equipmentId, 17);
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
function TestSW:testSpawnMissionComponent()
    -- Arrange
    --TODO: simplify
    server.objects[1] = {
        id = 123
    }
    server.playlists[1] = {
        locations = {
            [1] = {
                objects = {
                    [1] = 123
                }
            }
        }
    }

    -- Act
    local objectId = server.spawnMissionComponent({0, 0, 0}, 1, 1, 1);

    -- Assert
    lu.assertIsTrue(server.objects[1].spawned);
end
--[[
Removed on v1.0.21

function TestSW:testDespawnMissionObject()
    -- Arrange
    server.objects = {
        [1] = {
            id = 123
        }
    }
    server.playlists[1] = {
        locations = {
            [1] = {
                objects = {
                    [1] = 123
                }
            }
        }
    }

    local objectId = server.spawnMissionObject({0, 0, 0}, 1, 1, 1);

    -- Act
    server.despawnMissionObject(objectId, true);

    -- Assert
    lu.assertIsFalse(server.objects[1].spawned);
end
]]
function TestSW:testGetLocationObjectData()
    -- Arrange
    server.objects = {
        [1] = {
            id = 123
        }
    }
    server.playlists[1] = {
        locations = {
            [1] = {
                objects = {
                    [1] = 123
                }
            }
        }
    }
    local objectId = server.spawnMissionComponent({0, 0, 0}, 1, 1, 1);

    -- Act
    local objectData = server.getLocationComponentData(1, 1, 1);

    -- Assert
    lu.assertIsTrue(objectData.spawned);
end
function TestSW:testSetFireData()
    -- Arrange
    local fireId = server.spawnFire({x = 1, y = 2, z = 3}, 2, 3, false, false, 1, 4);

    -- Act
    server.setFireData(fireId, true, false);

    -- Assert
    lu.assertIsTrue(server.objects[1].is_lit);
end
function TestSW:testGetFireData()
    -- Arrange
    local fireId = server.spawnFire({x = 1, y = 2, z = 3}, 2, 3, false, false, 1, 4);
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
    testsuite.test.setTilePurchased({x = 1, y = 2, z = 3});

    -- Act
    local purchased = server.getTilePurchased({x = 1, y = 2, z = 3});

    -- Assert
    lu.assertIsTrue(purchased);
end

function TestSW:test_event_playerJoin()

    -- Arrange
    -- Act
    testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);

    -- Assert
    lu.assertEquals(server.peers[2].steam_id, 123);
end
function TestSW:test_event_playerLeave()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);

    -- Act
    testsuite.event.playerLeave(peerId);

    -- Assert
    lu.assertIsNil(server.peers[2]);
end
function TestSW:test_event_vehicleSpawn()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);

    -- Act
    local vehicleId = testsuite.event.vehicleSpawn(peerId, "AP's Vehicle", 0, 0, 0);

    -- Assert
    lu.assertEquals(server.vehicles[1].owner, peerId);
end
function TestSW:test_event_playerTeleportVehicle()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);
    local vehicleId = testsuite.event.vehicleSpawn(peerId, "AP's Vehicle", 1, 2, 3);

    -- Act
    testsuite.event.playerTeleportVehicle(peerId, vehicleId, 4, 5, 6);

    -- Assert
    lu.assertItemsEquals(server.vehicles[1].pos, {4, 5, 6});
end
function TestSW:test_event_playerCommand()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);
    function onCustomCommand(message, user_id, is_admin, is_auth, command, ...)
        -- Assert
        lu.assertEquals(command, "?myCommand");
    end

    -- Act
    testsuite.event.playerCommand(peerId, "?myCommand");
end

function TestSW:test_banPlayer()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);

    -- Act
    server.banPlayer(peerId);

    -- Assert
    local peer = getArrayElementById(server.peers, peerId);
    lu.assertIsTrue(peer.isBanned);
end
function TestSW:test_kickPlayer()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);

    -- Act
    server.kickPlayer(peerId);

    -- Assert
    local peer = getArrayElementById(server.peers, peerId);
    lu.assertIsTrue(peer.gotKicked);
end
function TestSW:test_addAdmin()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);

    -- Act
    server.addAdmin(peerId);

    -- Assert
    local peer = getArrayElementById(server.peers, peerId);
    lu.assertIsTrue(peer.admin);
end
function TestSW:test_removeAdmin()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);
    server.addAdmin(peerId);

    -- Act
    server.removeAdmin(peerId);

    -- Assert
    local peer = getArrayElementById(server.peers, peerId);
    lu.assertIsFalse(peer.admin);
end
function TestSW:test_addAuth()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);

    -- Act
    server.addAuth(peerId);

    -- Assert
    local peer = getArrayElementById(server.peers, peerId);
    lu.assertIsTrue(peer.auth);
end
function TestSW:test_removeAuth()
    -- Arrange
    local peerId = testsuite.event.playerJoin(123, getRandomId(), "ActionedPlayer", true, true);
    server.addAuth(peerId);

    -- Act
    server.removeAuth(peerId);

    -- Assert
    local peer = getArrayElementById(server.peers, peerId);
    lu.assertIsFalse(peer.auth);
end

--[[
    Bugfixes
]]
function TestSW:test_bugfix_stringSplit_prefixSuffixSpaces()

    -- Arrange
    local myString = " Hello, World! ";

    -- Act
    local splitString = string.split(myString, " ");

    -- Assert
    lu.assertEquals(#splitString, 2);

end

local runner = lu.LuaUnit.new();
os.exit(runner:run());