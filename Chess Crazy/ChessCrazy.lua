local ChessCrazy = {}
local setmetatable, ipairs, stringmatch, tonumber, tostring, tableconcat, tableinsert, mathabs, print, io, type, tableremove = 
setmetatable, ipairs, string.match, tonumber, tostring, table.concat, table.insert, math.abs, print, io, type, table.remove
_ENV = nil

--region Spot--
local Spot = {}
    
Spot.rank = nil
Spot.file = nil
Spot.piece = nil
Spot.fileNotation = {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
    "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
    "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
    "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
    "U", "V", "W", "X", "Y", "Z"
}
Spot.inverseFileNotation = {
    ["a"] = 1 , ["b"] = 2 , ["c"] = 3 , ["d"] = 4 , ["e"] = 5 , ["f"] = 6 , ["g"] = 7 , ["h"] = 8 , ["i"] = 9 , ["j"] = 10,
    ["k"] = 11, ["l"] = 12, ["m"] = 13, ["n"] = 14, ["o"] = 15, ["p"] = 16, ["q"] = 17, ["r"] = 18, ["s"] = 19, ["t"] = 20,
    ["u"] = 21, ["v"] = 22, ["w"] = 23, ["x"] = 24, ["y"] = 25, ["z"] = 26,
    ["A"] = 27, ["B"] = 28, ["C"] = 29, ["D"] = 30, ["E"] = 31, ["F"] = 32, ["G"] = 33, ["H"] = 34, ["I"] = 35, ["J"] = 36,
    ["K"] = 37, ["L"] = 38, ["M"] = 39, ["N"] = 40, ["O"] = 41, ["P"] = 42, ["Q"] = 43, ["R"] = 44, ["S"] = 45, ["T"] = 46,
    ["U"] = 47, ["V"] = 48, ["W"] = 49, ["X"] = 50, ["Y"] = 51, ["Z"] = 52
}
function Spot:new(rank, file, piece)
    local obj = setmetatable({}, self)
    obj.rank = rank
    obj.file = file
    if piece and (piece ~= 1) then
        obj.piece = piece
    end
    return obj
end

function Spot:isOpen()
    if self.piece then
        return false
    end
    return true
end

Spot.__index = Spot

function Spot:__tostring()
    return Spot.fileNotation[self.file] .. self.rank
end

function Spot:__eq(other)
    if self.rank == other.rank and self.file == other.file then
        return true
    end
    return false
end
--endregion Spot--

--region King--
local King = {} 

King.color = nil
King.type = "king"
King.moved = false

function King:new(color)
    local obj = setmetatable({}, self)
    obj.color = color
    obj.moved = false
    return obj
end

King.__index = King

function King:__tostring()
    if self.color == "white" then
        return "WK"
    else
        return "BK"
    end
end
--endregion King--

--region Queen--
local Queen = {}

Queen.color = nil
Queen.type = "queen"
Queen.moved = false

function Queen:new(color)
    local obj = setmetatable({}, self)
    obj.color = color
    obj.moved = false
    return obj
end

Queen.__index = Queen

function Queen:__tostring()
    if self.color == "white" then
        return "WQ"
    else
        return "BQ"
    end
end
--endregion Queen--

--region Rook--
local Rook = {}

Rook.color = nil
Rook.type = "rook"
Rook.moved = false

function Rook:new(color)
    local obj = setmetatable({}, self)
    obj.color = color
    obj.moved = false
    return obj
end

Rook.__index = Rook

function Rook:__tostring()
    if self.color == "white" then
        return "WR"
    else
        return "BR"
    end
end
--endregion Rook--

--region Bishop--
local Bishop = {}

Bishop.color = nil
Bishop.type = "bishop"
Bishop.moved = false

function Bishop:new(color)
    local obj = setmetatable({}, self)
    obj.color = color
    obj.moved = false
    return obj
end

Bishop.__index = Bishop

function Bishop:__tostring()
    if self.color == "white" then
        return "WB"
    else
        return "BB"
    end
end
--endregion Bishop--

--region Knight--
local Knight = {}

Knight.color = nil
Knight.type = "knight"
Knight.moved = false

function Knight:new(color)
    local obj = setmetatable({}, self)
    obj.color = color
    obj.moved = false
    return obj
end

Knight.__index = Knight

function Knight:__tostring()
    if self.color == "white" then
        return "WN"
    else
        return "BN"
    end
end
--endregion Knight--

--region Pawn--
local Pawn = {}

Pawn.color = nil
Pawn.type = "pawn"
Pawn.moved = false

function Pawn:new(color)
    local obj = setmetatable({}, self)
    obj.color = color
    obj.moved = false
    return obj
end

Pawn.__index = Pawn

function Pawn:__tostring()
    if self.color == "white" then
        return "WP"
    else
        return "BP"
    end
end
--endregion Pawn--

--region Chessboard--
local Chessboard = {}

Chessboard.width = nil
Chessboard.height = nil

Chessboard.shorthand = {
    ["BK"] = King, ["BQ"] = Queen, ["BB"] = Bishop, ["BN"] = Knight, ["BR"] = Rook, ["BP"] = Pawn, 
    ["WK"] = King, ["WQ"] = Queen, ["WB"] = Bishop, ["WN"] = Knight, ["WR"] = Rook, ["WP"] = Pawn
}

function Chessboard:new(setup)
    local obj = setmetatable({}, self)
    for i = 1, #setup do
        obj[i] = {}
    end
    for rowNum, row in ipairs(setup) do
        for colNum, piece in ipairs(row) do
            if piece == 0 then
                obj[rowNum][colNum] = 0
            else
                obj[rowNum][colNum] = Spot:new(#setup + 1 - rowNum, colNum, piece)
            end
        end
    end

    local width = 0
    for _, row in ipairs(obj) do
        if #row > width then
            width = #row
        end
    end

    obj.height = #obj
    obj.width = width

    return obj
end

function Chessboard:getSpot(rankOrString, file)
    if type(rankOrString) == "string" then
        return self:getSpot(tonumber(rankOrString:match("%d+")), Spot.inverseFileNotation[rankOrString:match("%a")])
    else
        if not self[self.height + 1 - rankOrString] or not self[self.height + 1 - rankOrString][file] then
            return nil
        elseif self[self.height + 1 - rankOrString][file] == 0 then
            return nil
        end
        return self[self.height + 1 - rankOrString][file]
    end
end

function Chessboard:getNumKingsAlive(color)
    local count = 0
    for _, row in ipairs(self) do
        for _, spot in ipairs(row) do
            if spot ~= 0 and spot.piece and spot.piece.color == color and spot.piece.type == "king" then
                count = count + 1
            end
        end
    end
    return count
end

function Chessboard:enhancedToString(possibleMoves)
    local str = ""
    for i, row in ipairs(self) do
        str = str .. self.height + 1 - i .. " "
        if (self.height + 1 - i) < 10 then
            str = str .. " "
        end
        for _, spot in ipairs(row) do
            local possibleMove = false
            if possibleMoves then
                for _, v in ipairs(possibleMoves) do
                    if v == spot then
                        possibleMove = true
                    end
                end
            end
            if spot == 0 then
                str = str .. "    "
            elseif spot:isOpen() and possibleMove then
                str = str .. "(--)"
            elseif spot:isOpen() then
                str = str .. " -- "
            elseif possibleMove then
                str = str .. "(" .. tostring(spot.piece) .. ")"
            else
                str = str .. " " .. tostring(spot.piece) .. " "
            end
        end
        str = str .. "\n"
    end
    str = str .. " "
    for i = 1, self.width do
        str = str .. "   " .. Spot.fileNotation[i]
    end
    return str
end

Chessboard.__index = Chessboard

function Chessboard:__tostring()
    local str = ""
    for i, row in ipairs(self) do
        str = str .. self.height + 1 - i .. " "
        if (self.height + 1 - i) < 10 then
            str = str .. " "
        end
        for _, spot in ipairs(row) do
            if spot == 0 then
                str = str .. "    "
            elseif spot:isOpen() then
                str = str .. " -- "
            else
                str = str .. " " .. tostring(spot.piece) .. " "
            end
        end
        str = str .. "\n"
    end
    str = str .. " "
    for i = 1, self.width do
        str = str .. "   " .. Spot.fileNotation[i]
    end
    return str
end
--endregion Chessboard--

--region Utility--
local Utility = {}

Utility.promotionPieces = setmetatable({["queen"] = Queen, ["rook"] = Rook, ["knight"] = Knight, ["bishop"] = Bishop}, {
    __tostring = function() return
    "| Queen  | \"queen\"\n"..
    "| Rook   | \"rook\"\n"..
    "| Knight | \"knight\"\n"..
    "| Bishop | \"bishop\"\n" end
})

Utility.returnCodes = {
    ["01"] = "Spot does not exist.",
    ["02"] = "No piece selected.",
    ["03"] = "Selected piece of wrong color for current turn.",
    ["04"] = "No possible moves for selected piece.",
    ["05"] = "handleCurrentSpotInput completed successfully.",
    ["06"] = "Cannot move to that spot.",
    ["07"] = "handleFutureSpotInput completed successfully.",
    ["08"] = "Requested log.",
    ["09"] = "User ended.",
    ["10"] = "Go back to piece selection.",
    ["11"] = "Pawn promotion.",
    ["12"] = "In sacrificial check. Must move king."
}

function Utility.isPathBlocked(game, currentSpot, futureSpot)
    local move = {futureSpot.rank - currentSpot.rank, futureSpot.file - currentSpot.file}
    local passedSpots = {}

    if move[2] == 0 then
        if move[1] > 0 then
            for i = 1, mathabs(move[1]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank + i, currentSpot.file)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        else
            for i = 1, mathabs(move[1]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank - i, currentSpot.file)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        end
    elseif move[1] == 0 then
        if move[2] > 0 then
            for i = 1, mathabs(move[2]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank, currentSpot.file + i)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        else
            for i = 1, mathabs(move[2]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank, currentSpot.file - i)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        end
    elseif move[1] > 0 then
        if move[2] > 0 then
            for i = 1, mathabs(move[1]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank + i, currentSpot.file + i)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        else
            for i = 1, mathabs(move[1]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank + i, currentSpot.file - i)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        end
    elseif move[1] < 0 then
        if move[2] > 0 then
            for i = 1, mathabs(move[1]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank - i, currentSpot.file + i)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        else
            for i = 1, mathabs(move[1]) - 1 do
                local passedSpot = game.board:getSpot(currentSpot.rank - i, currentSpot.file - i)
                if passedSpot then
                    tableinsert(passedSpots, passedSpot)
                else
                    return true
                end
            end
        end
    end

    for _, spot in ipairs(passedSpots) do
        if not spot:isOpen() then
            return true
        end
    end
    return false
end

function Utility.getPossibleMoves(game, currentSpot, ignoreCheckingForCheck)

    if not game.settings.checkProtection then
        ignoreCheckingForCheck = true
    end

    local possibleMoves = {}

    if currentSpot.piece.type == "king" then
        
        local possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file + 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file + 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file + 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file - 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file - 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file - 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        if not ignoreCheckingForCheck then
            if currentSpot.piece.color == "white" then
                --Checks if current king position is in check
                local dangerSpots = Utility.getSpotsInCheckFrom(game, "black")
                for _, dangerSpot in ipairs(dangerSpots) do
                    if dangerSpot == currentSpot then
                        goto skipCastling
                    end
                end
            else
                --Checks if current king position is in check
                local dangerSpots = Utility.getSpotsInCheckFrom(game, "white")
                for _, dangerSpot in ipairs(dangerSpots) do
                    if dangerSpot == currentSpot then
                        goto skipCastling
                    end
                end
            end
        end

        --Right castle
        possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file + 2)
        local castlingPieceSpot = game.board:getSpot(currentSpot.rank, currentSpot.file + 3)
        if game.settings.castling and not currentSpot.piece.moved and castlingPieceSpot and castlingPieceSpot.piece and 
        castlingPieceSpot.piece.color == currentSpot.piece.color and not castlingPieceSpot.piece.moved then
            tableinsert(possibleMoves, possibleMove)
        end

        --Left castle
        possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file - 2)
        castlingPieceSpot = game.board:getSpot(currentSpot.rank, currentSpot.file - 4)
        if game.settings.castling and not currentSpot.piece.moved and castlingPieceSpot and castlingPieceSpot.piece and 
        castlingPieceSpot.piece.color == currentSpot.piece.color and not castlingPieceSpot.piece.moved then
            tableinsert(possibleMoves, possibleMove)
        end

        ::skipCastling::
    end

    if currentSpot.piece.type == "queen" then

        local i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank + i, currentSpot.file)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank - i, currentSpot.file)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file + i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file - i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank + i, currentSpot.file + i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank - i, currentSpot.file - i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank + i, currentSpot.file - i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank - i, currentSpot.file + i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end
    end

    if currentSpot.piece.type == "rook" then

        local i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank + i, currentSpot.file)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank - i, currentSpot.file)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file + i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank, currentSpot.file - i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end
    end

    if currentSpot.piece.type == "bishop" then
        
        local i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank + i, currentSpot.file + i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank - i, currentSpot.file - i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank + i, currentSpot.file - i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end

        i = 1
        while 1 do
            local possibleMove = game.board:getSpot(currentSpot.rank - i, currentSpot.file + i)
            if possibleMove then
                tableinsert(possibleMoves, possibleMove)
                i = i + 1
            else
                break
            end
        end
    end

    if currentSpot.piece.type == "knight" then

        local possibleMove = game.board:getSpot(currentSpot.rank + 2, currentSpot.file + 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank + 2, currentSpot.file - 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file + 2)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file + 2)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank - 2, currentSpot.file + 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank - 2, currentSpot.file - 1)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file - 2)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end

        possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file - 2)
        if possibleMove then
            tableinsert(possibleMoves, possibleMove)
        end
    end
    
    if currentSpot.piece.type == "pawn" then
        if currentSpot.piece.color == "white" then
            local possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file)
            if possibleMove and possibleMove:isOpen() then
                tableinsert(possibleMoves, possibleMove)
            end

            --White pawn double move
            possibleMove = game.board:getSpot(currentSpot.rank + 2, currentSpot.file)
            if possibleMove and possibleMove:isOpen() and game.settings.pawnDoubleMove and not currentSpot.piece.moved then
                tableinsert(possibleMoves, possibleMove)
            end

            --White pawn take
            possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file + 1)
            if possibleMove and not possibleMove:isOpen() then
                tableinsert(possibleMoves, possibleMove)
            end

            possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file - 1)
            if possibleMove and not possibleMove:isOpen() then
                tableinsert(possibleMoves, possibleMove)
            end

            --White pawn en passant
            if game.settings.enPassant and #game.log ~= 0 then
                local previousFutureSpotString = stringmatch(game.log[#game.log], "%a%d+$")
                local previousFutureSpot
                local wasPreviousMoveWithAPawn

                --Checks if future move was not a promotion (since it ends in digits instead of "=_")
                if previousFutureSpotString then
                    previousFutureSpot = game.board:getSpot(previousFutureSpotString)
                    if previousFutureSpot.piece.type == "pawn" then
                        wasPreviousMoveWithAPawn = true
                    end

                --Pawn promotion occured last move. wasPreviousMoveWithAPawn = true because previous piece had to be a pawn for promotion.
                else
                    previousFutureSpotString = stringmatch( stringmatch(game.log[#game.log], "%a%d+%a%d+"), "%a%d+$" )
                    previousFutureSpot = game.board:getSpot(previousFutureSpotString)
                    wasPreviousMoveWithAPawn = true
                end

                local previousRankMove = previousFutureSpot.rank - tonumber(stringmatch(game.log[#game.log], "%d+"))
                if previousRankMove == -2 and wasPreviousMoveWithAPawn then
                    possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file + 1)
                    if possibleMove and possibleMove:isOpen() and previousFutureSpot.rank == currentSpot.rank and previousFutureSpot.file == currentSpot.file + 1 then
                        tableinsert(possibleMoves, possibleMove)
                    end

                    possibleMove = game.board:getSpot(currentSpot.rank + 1, currentSpot.file - 1)
                    if possibleMove and possibleMove:isOpen() and previousFutureSpot.rank == currentSpot.rank and previousFutureSpot.file == currentSpot.file - 1 then
                        tableinsert(possibleMoves, possibleMove)
                    end
                end
            end
        else
            local possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file)
            if possibleMove and possibleMove:isOpen() then
                tableinsert(possibleMoves, possibleMove)
            end

            --Black pawn double move
            possibleMove = game.board:getSpot(currentSpot.rank - 2, currentSpot.file)
            if possibleMove and possibleMove:isOpen() and game.settings.pawnDoubleMove and not currentSpot.piece.moved then
                tableinsert(possibleMoves, possibleMove)
            end

            --Black pawn take
            possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file + 1)
            if possibleMove and not possibleMove:isOpen() then
                tableinsert(possibleMoves, possibleMove)
            end

            possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file - 1)
            if possibleMove and not possibleMove:isOpen() then
                tableinsert(possibleMoves, possibleMove)
            end

            --Black pawn en passant
            if game.settings.enPassant and #game.log ~= 0 then
                local previousFutureSpotString = stringmatch(game.log[#game.log], "%a%d+$")
                local previousFutureSpot
                local wasPreviousMoveWithAPawn

                --Checks if future move was not a promotion (since it ends in digits instead of "=_")
                if previousFutureSpotString then
                    previousFutureSpot = game.board:getSpot(previousFutureSpotString)
                    if previousFutureSpot.piece.type == "pawn" then
                        wasPreviousMoveWithAPawn = true
                    end

                --Pawn promotion occured last move. wasPreviousMoveWithAPawn = true because previous piece had to be a pawn for promotion.
                else
                    previousFutureSpotString = stringmatch( stringmatch(game.log[#game.log], "%a%d+%a%d+"), "%a%d+$" )
                    previousFutureSpot = game.board:getSpot(previousFutureSpotString)
                    wasPreviousMoveWithAPawn = true
                end

                local previousRankMove = previousFutureSpot.rank - tonumber(stringmatch(game.log[#game.log], "%d+"))
                if previousRankMove == 2 and wasPreviousMoveWithAPawn then
                    possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file + 1)
                    if possibleMove and possibleMove:isOpen() and previousFutureSpot.rank == currentSpot.rank and previousFutureSpot.file == currentSpot.file + 1 then
                        tableinsert(possibleMoves, possibleMove)
                    end

                    possibleMove = game.board:getSpot(currentSpot.rank - 1, currentSpot.file - 1)
                    if possibleMove and possibleMove:isOpen() and previousFutureSpot.rank == currentSpot.rank and previousFutureSpot.file == currentSpot.file - 1 then
                        tableinsert(possibleMoves, possibleMove)
                    end
                end
            end
        end
    end
    
    --Checks if move would be ontop of friendly
    local markedForRemoval = {}
    for i, futureSpot in ipairs(possibleMoves) do
        if not futureSpot:isOpen() and futureSpot.piece.color == currentSpot.piece.color then
            tableinsert(markedForRemoval, i)
        end
    end
    local numRemoved = 0
    for _, i in ipairs(markedForRemoval) do
        tableremove(possibleMoves, i - numRemoved)
        numRemoved = numRemoved + 1
    end

    --Checks if move would go through other pieces (not knight because phases through)
    if currentSpot.piece.type ~= "knight" then
        local markedForRemoval = {}
        for i, futureSpot in ipairs(possibleMoves) do
            if Utility.isPathBlocked(game, currentSpot, futureSpot) then
                tableinsert(markedForRemoval, i)
            end
        end
        local numRemoved = 0
        for _, i in ipairs(markedForRemoval) do
            tableremove(possibleMoves, i - numRemoved)
            numRemoved = numRemoved + 1
        end
    end

    --Makes sure king is not put in check with move
    if not ignoreCheckingForCheck then

        --Makes sure king is not moving through a checked space when castling
        if currentSpot.piece.type == "king" then
            local markedForRemoval = {}
            for i, futureSpot in ipairs(possibleMoves) do
                local fileMove = futureSpot.file - currentSpot.file

                if fileMove == 2 then
                    local spotToCheck = game.board:getSpot(currentSpot.rank, currentSpot.file + 1)
                    local dangerColor

                    if currentSpot.piece.color == "white" then
                        dangerColor = "black"
                    else
                        dangerColor = "white"
                    end

                    if Utility.isSpotInCheckFrom(game, spotToCheck, dangerColor) then
                        tableinsert(markedForRemoval, i)
                    end
                elseif fileMove == -2 then
                    local spotToCheck = game.board:getSpot(currentSpot.rank, currentSpot.file - 1)
                    local dangerColor

                    if currentSpot.piece.color == "white" then
                        dangerColor = "black"
                    else
                        dangerColor = "white"
                    end

                    if Utility.isSpotInCheckFrom(game, spotToCheck, dangerColor) then
                        tableinsert(markedForRemoval, i)
                    end
                end
            end
            local numRemoved = 0
            for _, i in ipairs(markedForRemoval) do
                tableremove(possibleMoves, i - numRemoved)
                numRemoved = numRemoved + 1
            end
        end

        --Creates a copy of the game to simulate a move and check if the king would be put in check
        local markedForRemoval = {}
        for i, futureSpot in ipairs(possibleMoves) do
            local gameCopy = ChessCrazy:loadGame(game.saveState)
            local currentSpotCopy = gameCopy.board:getSpot(tostring(currentSpot))
            local futureSpotCopy = gameCopy.board:getSpot(tostring(futureSpot))
            Utility.move(gameCopy, currentSpotCopy, futureSpotCopy)

            if currentSpot.piece.color == "white" then
                local dangerSpots = Utility.getSpotsInCheckFrom(gameCopy, "black")
                for _, dangerSpot in ipairs(dangerSpots) do
                    if dangerSpot.piece and dangerSpot.piece.type == "king" and dangerSpot.piece.color == "white" then
                        tableinsert(markedForRemoval, i)
                    end
                end
            else
                local dangerSpots = Utility.getSpotsInCheckFrom(gameCopy, "white")
                for _, dangerSpot in ipairs(dangerSpots) do
                    if dangerSpot.piece and dangerSpot.piece.type == "king" and dangerSpot.piece.color == "black" then
                        tableinsert(markedForRemoval, i)
                    end
                end
            end
        end
        local numRemoved = 0
        for _, i in ipairs(markedForRemoval) do
            tableremove(possibleMoves, i - numRemoved)
            numRemoved = numRemoved + 1
        end
    end
    return possibleMoves
end

function Utility.addToLostPieces(game, piece)
    if piece.color == "white" then
        tableinsert(game.lostWhitePieces, piece)
    else
        tableinsert(game.lostBlackPieces, piece)
    end
end

function Utility.move(game, currentSpot, futureSpot)

    if currentSpot.piece.type == "pawn" then
        
        if futureSpot:isOpen() then
            --En passant
            if futureSpot.file ~= currentSpot.file then
                futureSpot.piece = currentSpot.piece
                futureSpot.piece.moved = true
                currentSpot.piece = nil

                if futureSpot.piece.color == "white" then
                    local deadSpot = game.board:getSpot(futureSpot.rank - 1, futureSpot.file)
                    Utility.addToLostPieces(game, deadSpot.piece)
                    deadSpot.piece = nil
                else
                    local deadSpot = game.board:getSpot(futureSpot.rank + 1, futureSpot.file)
                    Utility.addToLostPieces(game, deadSpot.piece)
                    deadSpot.piece = nil
                end

            --Not en passant (just regular forward 1 or 2)
            else
                futureSpot.piece = currentSpot.piece
                futureSpot.piece.moved = true
                currentSpot.piece = nil
            end
        else
            Utility.addToLostPieces(game, futureSpot.piece)
            futureSpot.piece = currentSpot.piece
            futureSpot.piece.moved = true
            currentSpot.piece = nil
        end

        --Check for pawn promotion
        if futureSpot.piece.color == "white" and futureSpot.rank == game.board.height then
            return "11"
        elseif futureSpot.piece.color ~= "white" and futureSpot.rank == 1 then
            return "11"
        end

    elseif currentSpot.piece.type == "king" then
        
        --Castling
        local fileMove = futureSpot.file - currentSpot.file

        --Rightside castle
        if fileMove == 2 then
            local middleSpot = game.board:getSpot(currentSpot.rank, currentSpot.file + 1)
            local castlingPieceSpot = game.board:getSpot(currentSpot.rank, currentSpot.file + 3)

            middleSpot.piece = castlingPieceSpot.piece
            castlingPieceSpot.piece = nil
            middleSpot.moved = true
            futureSpot.piece = currentSpot.piece
            futureSpot.piece.moved = true
            currentSpot.piece = nil

        --Leftside castle
        elseif fileMove == -2 then
            local middleSpot = game.board:getSpot(currentSpot.rank, currentSpot.file - 1)
            local castlingPieceSpot = game.board:getSpot(currentSpot.rank, currentSpot.file - 4)

            middleSpot.piece = castlingPieceSpot.piece
            castlingPieceSpot.piece = nil
            middleSpot.moved = true
            futureSpot.piece = currentSpot.piece
            futureSpot.piece.moved = true
            currentSpot.piece = nil

        --Taking enemy piece
        elseif not futureSpot:isOpen() then
            Utility.addToLostPieces(game, futureSpot.piece)
            futureSpot.piece = currentSpot.piece
            futureSpot.piece.moved = true
            currentSpot.piece = nil

        --Moving to open space
        else
            futureSpot.piece = currentSpot.piece
            futureSpot.piece.moved = true
            currentSpot.piece = nil
        end

    else --All other pieces

        if not futureSpot:isOpen() then
            Utility.addToLostPieces(game, futureSpot.piece)
            futureSpot.piece = currentSpot.piece
            futureSpot.piece.moved = true
            currentSpot.piece = nil
        else
            futureSpot.piece = currentSpot.piece
            futureSpot.piece.moved = true
            currentSpot.piece = nil
        end
    end

    --Logs move
    tableinsert(game.log, tostring(currentSpot) .. tostring(futureSpot))
end

function Utility.handleCurrentSpotInput(game, isInSacrificalCheck)
    if game.turn == "white" then
        io.write("\nSelect spot (white's turn): ")
    else
        io.write("\nSelect spot (black's turn): ")
    end

    local input = io.read()
    if input == "log" then
        return "08"
    elseif input == "end" then
        return "09"
    end

    local currentSpot = game.board:getSpot(input)

    if not currentSpot then
        return "01"
    end

    if not currentSpot.piece then
        return "02"
    end

    if currentSpot.piece.color ~= game.turn then
        return "03"
    end

    if isInSacrificalCheck and currentSpot.piece.type ~= "king" then
        return "12"
    end

    --If in sacrificial check, then ignore checking for check (3rd argument)
    local possibleSpots = Utility.getPossibleMoves(game, currentSpot, isInSacrificalCheck)

    if #possibleSpots == 0 then
        return "04"
    end

    return "05", currentSpot, possibleSpots
end

function Utility.handleFutureSpotInput(game, currentSpot, possibleSpots)
    if game.turn == "white" then
        io.write("\nMove to (white's turn): ")
    else
        io.write("\nMove to (black's turn): ")
    end

    local input = io.read()
    if input == "log" then
        return "08"
    elseif input == "end" then
        return "09"
    elseif input == "back" then
        return "10"
    end

    local futureSpot = game.board:getSpot(input)

    if not futureSpot then
        return "01"
    end

    local futureSpotPossible = false
    for _, spot in ipairs(possibleSpots) do
        if futureSpot == spot then
            futureSpotPossible = true
            break
        end
    end
    if not futureSpotPossible then
        return "06"
    end

    --Runs move and then checks for pawn promotion (code 11)
    if Utility.move(game, currentSpot, futureSpot) == "11" then
        return "11", futureSpot
    end

    return "07"
end

function Utility.tableToSetup(table)

    --Build setup object
    local setup = {}
    for i = 1, #table do
        setup[i] = {}
    end
    for rowNum, row in ipairs(table) do
        for colNum, notation in ipairs(row) do
            if notation == 0 or notation == 1 then
                setup[rowNum][colNum] = notation
            else
                if stringmatch(notation, "%a") == "W" then
                    setup[rowNum][colNum] = Chessboard.shorthand[notation]:new("white")
                else
                    setup[rowNum][colNum] = Chessboard.shorthand[notation]:new("black")
                end
            end
        end
    end

    return setup
end

function Utility.getSpotsInCheckFrom(game, color)
    local spotsInCheck = {}
    for _, row in ipairs(game.board) do
        for _, spot in ipairs(row) do
            if spot ~= 0 and spot.piece and spot.piece.color == color then
                local possibleMoves = Utility.getPossibleMoves(game, spot, true)
                for _, moveSpot in ipairs(possibleMoves) do

                    --Removes duplicates
                    local isNewSpot = true
                    for _, checkSpot in ipairs(spotsInCheck) do
                        if checkSpot == moveSpot then
                            isNewSpot = false
                        end
                    end
                    if isNewSpot then
                        tableinsert(spotsInCheck, moveSpot)
                    end
                end
            end
        end
    end
    return spotsInCheck
end

function Utility.isSpotInCheckFrom(game, spot, color)

    local dangerSpots = Utility.getSpotsInCheckFrom(game, color)
    for _, dangerSpot in ipairs(dangerSpots) do
        if dangerSpot == spot then
            return true
        end
    end
    return false
end

function Utility.isInCheck(game)
    local dangerSpots
    if game.turn == "white" then
        dangerSpots =  Utility.getSpotsInCheckFrom(game, "black")
    else
        dangerSpots =  Utility.getSpotsInCheckFrom(game, "white")
    end
    for _, dangerSpot in ipairs(dangerSpots) do
        if dangerSpot.piece and dangerSpot.piece.color == game.turn and dangerSpot.piece.type == "king" then
            return true
        end
    end
    return false
end

function Utility.getNumKingsAliveOfColor(game, color)
    local count = 0
    for _, row in ipairs(game.board) do
        for _, spot in ipairs(row) do
            if spot ~= 0 and spot.piece and spot.piece.color == color and spot.piece.type == "king" then
                count = count + 1
            end
        end
    end
    return count
end

function Utility.canCurrentTurnMove(game)
    for _, row in ipairs(game.board) do
        for _, spot in ipairs(row) do
            if spot ~= 0 and spot.piece and spot.piece.color == game.turn then
                if #Utility.getPossibleMoves(game, spot) ~= 0 then
                    return true
                end
            end
        end
    end
    return false
end

function Utility.isDrawByRepitition(game)
    if #game.log < 6 then
        return false
    end
    local last6Moves = {
        game.log[#game.log - 5], game.log[#game.log - 4], game.log[#game.log - 3], 
        game.log[#game.log - 2], game.log[#game.log - 1], game.log[#game.log]
    }
    if last6Moves[1] == last6Moves[5] and last6Moves[2] == last6Moves[6] then
        return true
    end
    return false
end
--endregion Utility--

--region ChessCrazy--
ChessCrazy.stdSetup = {
    {"BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"},
    {"BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"},
    {1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1},
    {"WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"},
    {"WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"}
}

ChessCrazy.premadeSetups = {
    megaSized = {
        {"BQ", "BR", "BR", "BN", "BN", "BB", "BQ", "BR", "BN", "BN", "BB", "BB", "BQ", "BK", "BB", "BB", "BN", "BN", "BR", "BQ", "BB", "BN", "BN", "BR", "BR", "BQ"},
        {"BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {"WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"},
        {"WQ", "WR", "WR", "WN", "WN", "WB", "WQ", "WR", "WN", "WN", "WB", "WB", "WQ", "WK", "WB", "WB", "WN", "WN", "WR", "WQ", "WB", "WN", "WN", "WR", "WR", "WQ"}
    },
    donut = {
        {"BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"},
        {"BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"},
        {1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 0, 0, 1, 1, 1},
        {1, 1, 1, 0, 0, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1},
        {"WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"},
        {"WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"}
    },
}

ChessCrazy.stdSettings = {
    pawnDoubleMove = true,
    castling = true,
    enPassant = true,
    checkProtection = true,
    drawByRepitition = true,
    startingTurn = "white"
}

function ChessCrazy:newGame(tableSetup, settings)
    local game = setmetatable({}, self)
    local setup = Utility.tableToSetup(tableSetup)

    game.board = Chessboard:new(setup)
    game.winner = nil

    game.settings = settings
    game.turn = game.settings.startingTurn

    game.log = setmetatable({}, {__tostring = function(self) return "<" .. tableconcat(self, ", ") .. ">"; end})
    game.saveState = {log = game.log, tableSetup = tableSetup, settings = settings}

    game.lostWhitePieces = setmetatable({}, {
        __tostring = function(self) 
            local str = "Lost white pieces: "
            for _, v in ipairs(self) do
                str = str .. tostring(v) .. " "
            end
            return str;
        end
    })
    game.lostBlackPieces = setmetatable({}, {
        __tostring = function(self) 
            local str = "Lost black pieces: "
            for _, v in ipairs(self) do
                str = str .. tostring(v) .. " "
            end
            return str; 
        end
    })

    return game
end

function ChessCrazy:play()
    while 1 do
        print("--------------------------------------------------")
        print(self.board)

        if self.winner then
            return
        end

        if self.settings.drawByRepitition and Utility.isDrawByRepitition(self) then
            self.winner = "draw"
            return
        end

        local sacrificalCheck = false
        if self.settings.checkProtection then

            local inCheck = Utility.isInCheck(self)
            local currentTurnCanMove = Utility.canCurrentTurnMove(self)
            local numKingsAlive = Utility.getNumKingsAliveOfColor(self, self.turn)

            --Sacrificial check
            if inCheck and not currentTurnCanMove and numKingsAlive > 1 then
                print("You are in sacrifical check. You must move a king.")
                sacrificalCheck = true
            
            --Checkmate
            elseif inCheck and not currentTurnCanMove then
                if self.turn == "white" then
                    self.winner = "black"
                    return
                else
                    self.winner = "white"
                    return
                end
                return

            --Stalemate
            elseif not currentTurnCanMove then
                self.winner = "draw"
                return

            --Check
            elseif inCheck then
                print("You are in check.")
            end

        else
            if Utility.getNumKingsAliveOfColor(self, self.turn) == 0 then
                if self.turn == "white" then
                    self.winner = "black"
                    return
                else
                    self.winner = "white"
                    return
                end
            end
        end
        
        ::top1::
        local returnCode, currentSpot, possibleSpots = Utility.handleCurrentSpotInput(self, sacrificalCheck)
        if returnCode ~= "05" then
            if returnCode == "08" then
                print(self.log)
                print(self.lostBlackPieces)
                print(self.lostWhitePieces)
                goto top1
            elseif returnCode == "09" then
                print("Ended by user.")
                break
            end
            print(Utility.returnCodes[returnCode] .. " Try again.")
            print()
            goto top1
        end

        print(self.board:enhancedToString(possibleSpots))

        ::top2::
        --Usually only need returnCode. ppFutureSpot is for pawn promotion.
        local returnCode, ppFutureSpot = Utility.handleFutureSpotInput(self, currentSpot, possibleSpots)
        if returnCode ~= "07" then
            if returnCode == "08" then
                print(self.log)
                print(self.lostBlackPieces)
                print(self.lostWhitePieces)
                goto top2
            elseif returnCode == "09" then
                print("Ended by user.")
                break
            elseif returnCode == "10" then
                goto top1
            elseif returnCode == "11" and ppFutureSpot then
                print(tostring(Utility.promotionPieces))
                io.write("\nPromote pawn to: ")
                --Sets futureSpot piece to selected promotion piece with same color
                ppFutureSpot.piece = Utility.promotionPieces[io.read()]:new(ppFutureSpot.piece.color)
                ppFutureSpot.piece.moved = true
                --Updates the log
                tableinsert(self.log, tostring(currentSpot) .. tostring(ppFutureSpot) .. "=" .. stringmatch(tostring(ppFutureSpot.piece), "%a$"))
            else
                print(Utility.returnCodes[returnCode] .. " Try again.")
                print()
                goto top2
            end
        end

        if self.turn == "white" then
            self.turn = "black"
        else
            self.turn = "white"
        end
    end
end

function ChessCrazy:loadGame(saveState)
    local game = ChessCrazy:newGame(saveState.tableSetup, saveState.settings)

    for _, v in ipairs(saveState.log) do

        local move = stringmatch(v, "%a%d+%a%d+")
        local currentSpot = game.board:getSpot(stringmatch(move, "%a%d+"))
        local futureSpot = game.board:getSpot(stringmatch(move, "%a%d+$"))

        local ppPiece = stringmatch(v, "=%a")
        if ppPiece then
            ppPiece = stringmatch(ppPiece, "%a")
            if ppPiece == "Q" then
                ppPiece = Queen
            elseif ppPiece == "R" then
                ppPiece = Rook
            elseif ppPiece == "N" then
                ppPiece = Knight
            elseif ppPiece == "B" then
                ppPiece = Bishop
            end
        end

        if Utility.move(game, currentSpot, futureSpot) == "11" and futureSpot then
            --Sets futureSpot piece to selected promotion piece with same color
            futureSpot.piece = ppPiece:new(futureSpot.piece.color)
            futureSpot.piece.moved = true
            --Updates the log
            tableinsert(game.log, tostring(currentSpot) .. tostring(futureSpot) .. "=" .. stringmatch(tostring(futureSpot.piece), "%a$"))
        end

        if game.turn == "white" then
            game.turn = "black"
        else
            game.turn = "white"
        end
    end
    return game
end

ChessCrazy.__index = ChessCrazy

function ChessCrazy:__tostring()
    local str = "--------------------------------------------------\n"
    str = str .. tostring(self.board) .. "\n\n"

    str = str .. "Current turn: " .. self.turn .. "\n"
    str = str .. tostring(self.lostBlackPieces) .. "\n"
    str = str .. tostring(self.lostWhitePieces) .. "\n\n"

    str = str .. "--Settings--\n"
    str = str .. "Pawn double move: " .. tostring(self.settings.pawnDoubleMove) .. "\n"
    str = str .. "Castling: " .. tostring(self.settings.castling) .. "\n"
    str = str .. "En Passant: " .. tostring(self.settings.enPassant) .. "\n"
    str = str .. "Pawn protection: " .. tostring(self.settings.pawnProtection) .. "\n"
    str = str .. "Starting turn: " .. tostring(self.settings.startingTurn) .. "\n\n"

    str = str .. "--Log--" .. "\n"
    str = str .. tostring(self.log) .. "\n"
    str = str .. "--------------------------------------------------\n"
    return str
end
--endregion ChessCrazy--

return ChessCrazy
