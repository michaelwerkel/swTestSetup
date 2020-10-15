local lu = require("test.deps.luaunit");

require("test.deps.sw_vehicle");
require("src.example_script")

function test_exampleScript()

    async.test_setHttpGetCallback(function(port, request)
        return "Hallo, Welt!";
    end);

    onTick(123);

end

os.exit(lu.LuaUnit.run());