
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
    if math.tointeger(value) < math.tointeger(min) or (max and (math.tointeger(value) > math.tointeger(max)) or false) then
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
        if element[index] == math.tointeger(id) then
            return element;
        end
    end
end
function getArrayElementById(arrRoot, id)
    return getArrayElementBy(arrRoot, "id", id);
end
function destroyArrayElementById(arrRoot, id)
    for elementIndex, element in pairs(arrRoot) do
        if element.id == math.tointeger(id) then
            arrRoot[elementIndex] = nil;
            return true;
        end
    end
    return false;
end
function string.split(str, splitChar)
    local stringSplit = {};
    local charIndex = string.find(str, splitChar);
    while charIndex do
        stringSplit[#stringSplit+1] = string.sub(str, 1, charIndex - 1);
        str = string.sub(str, charIndex + 1);
        charIndex = string.find(str, splitChar);
    end
    stringSplit[#stringSplit+1] = str;
    return stringSplit;
end

function assureColorInBounds(r, g, b, a)
    assureParameterInBounds("r", r, 0, 255);
    assureParameterInBounds("g", g, 0, 255);
    assureParameterInBounds("b", b, 0, 255);
    assureParameterInBounds("a", a, 0, 1);
end