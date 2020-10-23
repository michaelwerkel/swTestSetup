-- Relative of the working directory, where lua is executed
local lu = require("test.deps.luaunit");
require("test.deps.utility");

-- Uncomment to test vehicle scripts
--require("test.deps.sw_vehicle");
-- Uncomment to test mission scripts
require("test.deps.sw_mission");

-- Path to the source script
require("src.example_script")

-- Needs to be prefixed with "Test"
TestMyFeatures = {};

function TestMyFeatures:testPlayerCommand()

	-- Arrange
	local peerId = testsuite.event.playerJoin(getRandomId(), getRandomId(), "MyPlayerName", true, true);
	
	-- Act
	testsuite.event.playerCommand(peerId, "?hello");

	-- Assert
	lu.assertIsTrue(hello);

end

lu.LuaUnit.run();