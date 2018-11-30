# pieces:
#
# 1 = white, 2 = black
#
# 0 = King
# 1 = Queen
# 2 = Rook
# 3 = Bishop
# 4 = Knight
# 5 = Pawn
#
# 00 - 63 = square on board (0 = a1, ..., 7 = h1, 8 = a2, ..., 63 = h8)
#
# for example: 1355 = a black Bishop on h7
#
# all pieces on the board will be stored in the list "pieces" with this code
#
# starting position:

#boardstate:
#
# 1 = white to move
# 2 = black to move
#
# 00-63 = square of en passant
#
# 0 = white can castle short
# 1 = white cant caste short
#
# 0 = white can castle long
# 1 = white cant caste long
#
# 0 = black can castle short
# 1 = black cant caste short
#
# 0 = black can castle long
# 1 = black cant caste long
#
# 00 - 99 = number of plies since last capture or pawn move
#
# for example: 216111101 = black to move, white just played a4 all castles are still available and the last pawn move or capture was one ply ago

mutable struct Board
        pieces
        boardstate
        piecekeys
end

struct Move
        rows
        cols
end

struct Piecemove
        oldsquare
        newsquare
end

white_pawnmoves = [[Move(1,0), Move(2,0)], [Move(1, -1)], [Move(1, 1)]]
black_pawnmoves = [[Move(-1,0), Move(-2,0)], [Move(-1, -1)], [Move(-1, 1)]]
knightmoves = [[Move(2, -1)], [Move(2, 1)], [Move(1, 2)], [Move(-1, 2)], [Move(-2, 1)], [Move(-2, -1)], [Move(-1, -2)], [Move(1, -2)]]
bishopmoves = [[Move(1, 1), Move(2, 2), Move(3, 3), Move(4, 4), Move(5, 5), Move(6, 6), Move(7, 7)],
                [Move(-1, 1), Move(-2, 2), Move(-3, 3), Move(-4, 4), Move(-5, 5), Move(-6, 6), Move(-7, 7)],
                [Move(-1, -1), Move(-2, -2), Move(-3, -3), Move(-4, -4), Move(-5, -5), Move(-6, -6), Move(-7, -7)],
                [Move(1, -1), Move(2, -2), Move(3, -3), Move(4, -4), Move(5, -5), Move(6, -6), Move(7, -7)]]
rookmoves = [[Move(1, 0), Move(2, 0), Move(3, 0), Move(4, 0), Move(5, 0), Move(6, 0), Move(7, 0)],
                [Move(0, 1), Move(0, 2), Move(0, 3), Move(0, 4), Move(0, 5), Move(0, 6), Move(0, 7)],
                [Move(-1, 0), Move(-2, 0), Move(-3, 0), Move(-4, 0), Move(-5, 0), Move(-6, 0), Move(-7, 0)],
                [Move(0, -1), Move(0, -2), Move(0, -3), Move(0, -4), Move(0, -5), Move(0, -6), Move(0, -7)]]
queenmoves = [[Move(1, 1), Move(2, 2), Move(3, 3), Move(4, 4), Move(5, 5), Move(6, 6), Move(7, 7)],
                [Move(-1, 1), Move(-2, 2), Move(-3, 3), Move(-4, 4), Move(-5, 5), Move(-6, 6), Move(-7, 7)],
                [Move(-1, -1), Move(-2, -2), Move(-3, -3), Move(-4, -4), Move(-5, -5), Move(-6, -6), Move(-7, -7)],
                [Move(1, -1), Move(2, -2), Move(3, -3), Move(4, -4), Move(5, -5), Move(6, -6), Move(7, -7)],
                [Move(1, 0), Move(2, 0), Move(3, 0), Move(4, 0), Move(5, 0), Move(6, 0), Move(7, 0)],
                [Move(0, 1), Move(0, 2), Move(0, 3), Move(0, 4), Move(0, 5), Move(0, 6), Move(0, 7)],
                [Move(-1, 0), Move(-2, 0), Move(-3, 0), Move(-4, 0), Move(-5, 0), Move(-6, 0), Move(-7, 0)],
                [Move(0, -1), Move(0, -2), Move(0, -3), Move(0, -4), Move(0, -5), Move(0, -6), Move(0, -7)]]
kingmoves = [[Move(1, 0)], [Move(1, 1)], [Move(0, 1)], [Move(-1, 1)], [Move(-1, 0)], [Move(-1, -1)], [Move(0, -1)], [Move(1, -1)]]

piecemoves = Dict("15" => white_pawnmoves, "25" => black_pawnmoves, "14" => knightmoves, "13" => bishopmoves, "12" => rookmoves, "11" => queenmoves, "10" => kingmoves, "24" => knightmoves, "23" => bishopmoves, "22" => rookmoves, "21" => queenmoves, "20" => kingmoves)

board = Board([1004, 1103, 1200, 1207, 1302, 1305, 1401, 1406, 1508, 1509, 1510, 1511, 1512, 1513, 1514, 1515, 2060, 2159, 2256, 2263, 2358, 2361, 2457, 2462, 2548, 2549, 2550, 2551, 2552, 2553, 2554, 2555], 199111100, Dict("10" => "K", "11" => "Q", "12" => "R", "13" => "B", "14" => "N", "15" => "P", "20" => "k", "21" => "q", "22" => "r", "23" => "b", "24" => "n", "25" => "p"))
#board = Board([1107], 199111100, Dict("10" => "K", "11" => "Q", "12" => "R", "13" => "B", "14" => "N", "15" => "P", "20" => "k", "21" => "q", "22" => "r", "23" => "b", "24" => "n", "25" => "p"))

# returns the en passant square
function en_passant_square(board)
        return parse(Int64, string(board.boardstate)[3:4])
end

# changes side to move and updates 50 move rule counter
function next_move(board)
        if side_to_move(board) == 1
                board.boardstate += 10000000
        else
                board.boardstate -= 10000000
        end
        board.boardstate += 1
end

# returns the color to move
function side_to_move(board)
        return parse(Int64, string(board.boardstate)[1])
end

# returns type of piece
function piece_type(piece)
        return Int((piece - (piece % 100)) / 100)
end

# returns square of piece
function piece_square(piece)
        return piece % 100
end

# print the board
function show_board(board)
        boardstring = ""
        for row in 0:7
                for col in 0:7
                        haspiece = false
                        for piece in board.pieces
                                square = piece_square(piece)
                                piecekey = board.piecekeys[string(piece_type(piece))]
                                if 8*(7-row)+col == square
                                        boardstring *= piecekey
                                        boardstring *= " "
                                        haspiece = true
                                end
                        end
                        if !haspiece
                                boardstring *= ". "
                        end
                end
                boardstring *= "\n"
        end
        print(boardstring)
end

# returns color of piece
function piece_color(piece)
        return Int((piece - (piece % 1000)) / 1000)
end

# returns color of piecetype
function piecetype_color(piecetype)
        return Int((piecetype - (piecetype % 10)) / 10)
end

# returns the piece that is on the specified square (-1 if its empty)
function piecetype_on_square(board, square)
        for piece in board.pieces
                if piece_square(piece) == square
                        return piece_type(piece)
                end
        end
        return -1
end

# converts number of square into coordinates
function coordinate_from_square(square)
        col = square % 8
        row = Int((square - col) / 8)
        return [row, col]
end

# converts coordinates into number of square
function square_from_coordinates(coordinates)
        square = 8 * coordinates[1] + coordinates[2]
end

# returns if there is a piece of the specified color on the specified square
function is_occupied_by_color(board, square, color)
        on_square = piecetype_on_square(board, square)
        if on_square != -1 && color == piecetype_color(on_square)
                return true
        else
                return false
        end
end

# returns the new square after a piece has moved
function square_from_move_if_in_bounds(oldsquare, move::Move)
        oldcoordinates = coordinate_from_square(oldsquare)
        if (oldcoordinates[1] + move.rows) < 0 || (oldcoordinates[1] + move.rows) > 7 || (oldcoordinates[2] + move.cols) < 0 || (oldcoordinates[2] + move.cols) > 7
                return oldsquare
        else
                return oldsquare += 8 * move.rows + move.cols
        end
end

# returns all squares a piece could move to
function possible_moves(board, piece)
        color = piece_color(piece)
        square = piece_square(piece)
        piecetype = piece_type(piece)
        moves = Piecemove[]
        for movegroup in piecemoves[string(piecetype)]
                is_blocked = false
                for move in movegroup
                        if piecetype == 15
                                if move.cols == -1 && piecetype_color(piecetype_on_square(board, square+7)) != 2 && en_passant_square(board) != square+7
                                        continue
                                elseif move.cols == 1 && piecetype_color(piecetype_on_square(board, square+9)) != 2 && en_passant_square(board) != square+9
                                        continue
                                end
                        elseif piecetype == 25
                                if move.cols == -1 && piecetype_color(piecetype_on_square(board, square-9)) != 2 && en_passant_square(board) != square-9
                                        continue
                                elseif move.cols == 1 && piecetype_color(piecetype_on_square(board, square-7)) != 2 && en_passant_square(board) != square-7
                                        continue
                                end
                        end
                        newsquare = square_from_move_if_in_bounds(square, move)
                        if newsquare != square && newsquare >= 0 && newsquare <= 63 && !is_occupied_by_color(board, newsquare, color) && !is_blocked
                                push!(moves, Piecemove(square, newsquare))
                        else
                                is_blocked = true
                        end
                end
        end
        return moves
end

# calculate all existing moves in a position
function generate_legal_moves(board)
        all_moves = Piecemove[]
        for piece in board.pieces
                if piece_color(piece) != side_to_move(board)
                        continue
                end
                for legal_move in possible_moves(board, piece)
                        push!(all_moves, legal_move)
                end
        end
        return all_moves
end

# change the board by making a move
function make_move(board, move::Piecemove)
        newpiecetype = -1
        for piece in board.pieces
                square = piece_square(piece)
                print(square)
                print(move.oldsquare)
                if square == move.oldsquare
                        newpiecetype = piece_type(piece)
                        filter!(x -> x ≠ piece, board.pieces)
                elseif square == move.newsquare
                        filter!(x -> x ≠ piece, board.pieces)
                end
        end
        newpiece = 100 * newpiecetype + move.newsquare
        push!(board.pieces, newpiece)
        next_move(board)
        show_board(board)
end
