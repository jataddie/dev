local VectorN = {}

local setmetatable, ipairs, math, print = setmetatable, ipairs, math, print

_ENV = VectorN

new = function(initialData)
    local obj = setmetatable({}, VectorNMeta)
    for i, v in ipairs(initialData) do
        obj[i] = v
    end
    return obj
end

magnitude = function(self)
    local sum = 0
    for _, v in ipairs(self) do
        sum = sum + v^2
    end
    return math.sqrt(sum)
end

isSameSize = function(self, other)
    return #self == #other
end

dot  = function(self, other)
    if not isSameSize(self, other) then
        return nil
    else
        local sum = 0
        for i, v in ipairs(self) do
            sum = sum + v * other[i]
        end
        return sum
    end
end

toString = function(self)
    local str = "("
    for i, v in ipairs(self) do
        str = str .. v
        if i < #self then
            str = str .. ", "
        end
    end
    str = str .. ")"
    return str
end

add = function(self, other)
    local result = {}
    if #self >= #other then
        for i, v in ipairs(self) do
            if other[i] then
                result[i] = v + other[i]
            else
                result[i] = v
            end
        end
    else
        for i, v in ipairs(other) do
            if self[i] then
                result[i] = v + self[i]
            else
                result[i] = v
            end
        end
    end
    return new(result)
end

sub = function(self, other)
    local result = {}
    if #self >= #other then
        for i, v in ipairs(self) do
            if other[i] then
                result[i] = v - other[i]
            else
                result[i] = v
            end
        end
    else
        for i, v in ipairs(other) do
            if self[i] then
                result[i] = v - self[i]
            else
                result[i] = v
            end
        end
    end
    return new(result)
end

equals = function(self, other)
    if #self ~= #other then
        return false
    end
    for i, v in ipairs(self) do
        if v ~= other[i] then
            return false
        end
    end
    return true
end

VectorNMeta = {
    __index = VectorN,

    __tostring = toString,

    __add = add,

    __sub = sub,

    __eq = equals,

    __concat = function(self, other)
        return toString(self) .. other
    end,

    __call = function(self)
        print(self)
    end
}

return VectorN