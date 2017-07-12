//
//  Board.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 22/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import Foundation

enum BoardElement: CustomStringConvertible {
    
    case blankPuzzle
    case numberPuzzle(UInt8)
    
    var description: String {
        switch self {
        case .blankPuzzle: return "_"
        case .numberPuzzle(let val): return "\(val)"
        }
    }
}
extension BoardElement: Equatable { }
    
    func ==(lhs: BoardElement, rhs: BoardElement) -> Bool {
    switch (lhs, rhs) {
        case (.blankPuzzle, .blankPuzzle) : return true
        case (let .numberPuzzle(num1), let .numberPuzzle(num2)): return num1 == num2
    default: return false
    }
}

struct Heuristics {
    
    typealias BoardHeuristics = (Board, Board) -> Float
    static var badHeuristic: BoardHeuristics = {(_, _) -> Float in
        return 1.0
    }
    static var quiteGoodHeuristic: BoardHeuristics = { (boardStart, boardGoal) -> Float in
        let result = boardStart.boardElements.enumerated().reduce(0) { (result, current) in
            let addition = current.1 == boardGoal.boardElements[current.0] ? 1 : 0
            return result + addition
        }
        return Float(16 - result)
    }
    static var manhattanDistanceHeuristic: BoardHeuristics = { (boardStart, boardGoal) -> Float in
        return Float(boardStart.sumOfDistances(to: boardGoal))
    }
}



/**BlankSpaceMoveType 
Możliwe ruchy dla każdego pustego miejsca - możemy ruszać się w prawo, w lewo, w przód, w dół
*/
enum BlankSpaceMove {
    case Up, Down, Left, Right
}
struct Board: Equatable, Hashable {
    let boardElements: [BoardElement]

    init(elements: [[BoardElement]]) {
        assert(elements.count == 4, "Number of columns should be 4")
        for element in elements {
            assert(element.count == 4, "Number of elements in each column should be 4")
        }
        boardElements = elements.flatMap { $0 }
        //Sprawdzamy jeszcze, czy istnieje blank Puzzle
        let indx = boardElements.index (where: { (element) -> Bool in
            element == BoardElement.blankPuzzle
        })
        assert(indx != nil, "Powinniśmy dostać blank puzzle gdzieś w planszy.")
    }
    private init(elementsInSingleDArray: [BoardElement]) {
        boardElements = elementsInSingleDArray
    }
    ///makeMove: Przyjmuje ruch, zwraca kolejną tablicę po wykonanym ruchu.
    func make(move: BlankSpaceMove) -> Board {
        guard possibleMoves.contains(move) else { fatalError("Should got one of the possible moves...")}
        var newArr = boardElements
        let indxOfBlank = self.boardElements.index(of: .blankPuzzle)!
        let elementsInRow: Int = Int(sqrt(Double(boardElements.count + 1)))
        let indxOfPuzzleToMoveWith = { Void -> Int in
            switch move {
            case .Up: return indxOfBlank - elementsInRow
            case .Down: return indxOfBlank + elementsInRow
            case .Right : return indxOfBlank + 1
            case .Left: return indxOfBlank - 1
            }
        }()
        swap(&newArr[indxOfBlank], &newArr[indxOfPuzzleToMoveWith])
        return Board(elementsInSingleDArray: newArr)
    }
    ///Kolejnosc - Up, Down, Left, Right
    ///possibleMoves - zwraca ruchy, ktore jestesmy w stanie wykonac przy takim stanie planszy
    var possibleMoves: [BlankSpaceMove] {
        //Sprawdzamy indeks pola pustego. Unwrapping - jesteśmy pewni że istnieje, zapewniamy to w konstruktorze.
        var moves = [BlankSpaceMove]()
        let indxOfBlank = self.boardElements.index(of: .blankPuzzle)!
        let allElements = boardElements.count
        let elementsInRow: Int = Int(sqrt(Double(boardElements.count + 1)))
        if indxOfBlank - elementsInRow > -1 { moves.append(.Up) }
        if indxOfBlank + elementsInRow < allElements { moves.append(.Down) }
        if indxOfBlank % elementsInRow != 0 { moves.append(.Left) }
        if (indxOfBlank + 1) % elementsInRow != 0 { moves.append(.Right) }
        
        return moves
    }
    var hashValue: Int {
        var str = ""
        for elem in boardElements {
            switch elem {
            case .blankPuzzle : str += ("O")
            case .numberPuzzle(let val): str += "\(val)"
            }
        }
        return str.hashValue
    }

}

extension Board {
    func standardGeneratorFunction(parentBoard: Board?) -> [(Board, BlankSpaceMove)] {
        let mapped = self.possibleMoves.map {
            return (self.make(move: $0), $0)
            }
        
        if let parentBoard = parentBoard {
            return mapped.filter { (board, move) -> Bool in
                board != parentBoard
            }
        } else {
            return mapped
        }
    }
}

extension Board {
    
    private func rowAndColumn(for indx: Int, gridSize: Int) -> (Int, Int) {
        let row = Int(Double(indx) / Double(gridSize))
        let column = indx % gridSize
        return (row, column)
    }
    private func distance(from indx1: Int, toIndx indx2: Int, withGridSize gridSize: Int) -> Int {
        let (firstRow, firstColumn) = rowAndColumn(for: indx1, gridSize: gridSize)
        let (secondRow, secondColumn) = rowAndColumn(for: indx2, gridSize: gridSize)
        return abs(firstRow - secondRow) + abs(firstColumn - secondColumn)
    }

    func sumOfDistances(to otherBoard: Board) -> Int {
        var sumOfDistances: Int = 0
        for (i, elem ) in self.boardElements.enumerated() {
            guard let otherIndx = otherBoard.boardElements.index(of: elem) else { fatalError("elements should match") }
            sumOfDistances += distance(from: i, toIndx: otherIndx, withGridSize: 4)
        }
        return sumOfDistances
        
        
    }
}
extension Board : ExpressibleByArrayLiteral {

    init(arrayLiteral elements: String...) {
        guard elements.all ({
            return Int($0) != nil || $0 == "_" })
         else { fatalError("wrong elements") }
        // TODO: Add erorr checking(exactly one blank puzzle)
        self.boardElements = elements.map {
            if let intValue = Int($0) { return BoardElement.numberPuzzle(UInt8(intValue)) }
            else { return BoardElement.blankPuzzle }
        }
    }
}

func == (lhs: Board, rhs: Board) -> Bool {
    let elemsCount = lhs.boardElements.count
    for i in 0..<elemsCount where lhs.boardElements[i] != rhs.boardElements[i]{
        return false
    }
    return true
}
