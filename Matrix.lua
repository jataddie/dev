local Matrix = {}

local setmetatable, ipairs, type, print = setmetatable, ipairs, type, print

_ENV = Matrix

new = function(initialData)
    local obj = setmetatable({}, MatrixMeta)
    for i, v in ipairs(initialData) do
            obj[i] = v
    end
    return obj
end

isSameSize = function(self, other)
    if #self == #other then
        if #self[1] == #other[1] then
            return true
        end
    end
    return false
end

id = function(size)
    local identity = {}
    for i = 1, size do
        local row = {}
        for j = 1, size do
            if i == j then
                row[j] = 1
            else
                row[j] = 0
            end
        end
        identity[i] = row
    end
    return new(identity)
end

isSquare = function(self)
    return #self == #self[1]
end

add = function(self, other)
    if not isSameSize(self, other) then
        return nil
    else
        local result = {}
        for i, row in ipairs(self) do
            local newRow = {}
            for j, val in ipairs(row) do
                newRow[j] = val + other[i][j]
            end
            result[i] = newRow
        end
        return new(result)
    end
end

sub = function(self, other)
    if not isSameSize(self, other) then
        return nil
    else
        local result = {}
        for i, row in ipairs(self) do
            local newRow = {}
            for j, val in ipairs(row) do
                newRow[j] = val - other[i][j]
            end
            result[i] = newRow
        end
        return new(result)
    end
end

equals = function(self, other)
    if not isSameSize(self, other) then
        return false
    else
        for i, row in ipairs(self) do
            for j, val in ipairs(row) do
                if val ~= other[i][j] then
                    return false
                end
            end
        end
        return true
    end
end

multiply = function(self, other)
    if type(other) == "number" then
        local result = {}
        for i, row in ipairs(self) do
            local newRow = {}
            for j, val in ipairs(row) do
                newRow[j] = val * other
            end
            result[i] = newRow
        end
        return new(result)
    else
        if #self[1] ~= #other then
            return nil
        else
            local result = {}
            for selfRow = 1, #self do
                local newRow = {}
                for otherCol = 1, #other[1] do
                    local sum = 0
                    for selfCol = 1, #self[selfRow] do
                        sum = sum + self[selfRow][selfCol] * other[selfCol][otherCol]
                    end
                    newRow[otherCol] = sum
                end
                result[selfRow] = newRow
            end
            return new(result)
        end
    end
end

toString = function(self)
    local str = "["
    for i, row in ipairs(self) do
        if i > 1 then
            str = str .. " ["
        else
            str = str .. "["
        end
        for j, val in ipairs(row) do
            str = str .. val
            if j < #row then
                str = str .. ", "
            end
        end
        if i < #self then
            str = str .. "],\n"
        else
            str = str .. "]"
        end
    end
    str = str .. "]"
    return str
end

pow = function(self, exp)
    if exp < 1 then
        return nil
    elseif exp == 1 then
        return self
    elseif not self:isSquare() then
        return nil
    else
        local result = self
        for _ = 2, exp do
            result = MatrixMeta.__mul(result, self)
        end
        return result
    end
end

MatrixMeta = {
    __index = Matrix,

    __tostring = toString,

    __add = add,

    __sub = sub,

    __eq = equals,

    __mul = multiply,

    __pow = pow,

    __concat = function(self, other)
        return toString(self) .. other
    end,

    __call = function(self)
        print(self)
    end
}

id2 = new{
    {1, 0},
    {0, 1}
}

id3 = new{
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1}
}

return Matrix