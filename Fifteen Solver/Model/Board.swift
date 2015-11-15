//
//  Board.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 22/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import Foundation




///BoardElement - element
enum BoardElement: CustomStringConvertible {
    
    case BlankPuzzle
    case NumberPuzzle(UInt8)
    
    var description: String {
        switch self {
        case .BlankPuzzle: return "_"
        case .NumberPuzzle(let val): return "\(val)"
        }
    }
}
extension BoardElement: Equatable { }
    
    func ==(lhs: BoardElement, rhs: BoardElement) -> Bool {
    switch (lhs, rhs) {
        case (.BlankPuzzle, .BlankPuzzle) : return true
        case (let .NumberPuzzle(num1), let .NumberPuzzle(num2)): return num1 == num2
    default: return false
    }
}

struct Heuristics {
    
    typealias BoardHeuristics = (Board, Board) -> Float
    static var badHeuristic: BoardHeuristics = {(_, _) -> Float in
        return 1.0
    }
    static var quiteGoodHeuristic: BoardHeuristics = { (boardStart, boardGoal) -> Float in
        var numberOfCompatibles: Int = 0
        for (ind,elem) in boardStart.boardElements.enumerate() {
            if elem == boardGoal.boardElements[ind] { numberOfCompatibles += 1 }
        }
        return Float(16 - numberOfCompatibles)
        
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
    
    ///Inicjalizujemy z tablicą dwuwymiarową(łatwiejsze do wyobrażenia. Ukrywamy implementację(pojedyncza tablica)
    
    //TODO : Zamienić asserty zwracaniem nila :) - failable constructor
    init(elements: [[BoardElement]]) {
        assert(elements.count == 4, "Liczba kolumn powinna wynosić 4!")
        for element in elements {
            assert(element.count == 4, "Liczba elementów we wierszu powinna wynosić 4!")
        }
        boardElements = elements.flatMap { $0 }
        //Sprawdzamy jeszcze, czy istnieje blank Puzzle
        let indx = boardElements.indexOf { (element) -> Bool in
            element == BoardElement.BlankPuzzle
        }
        assert(indx != nil, "Powinniśmy dostać blank puzzle gdzieś w planszy.")
    }
    private init(elementsInSingleDArray: [BoardElement]) {
        boardElements = elementsInSingleDArray
    }
    ///makeMove: Przyjmuje ruch, zwraca kolejną tablicę po wykonanym ruchu.
    func makeMove(move: BlankSpaceMove) -> Board {
        guard possibleMoves.contains(move) else { fatalError("Should got one of the possible moves...")}
        var newArr = boardElements
        let indxOfBlank = self.boardElements.indexOf(.BlankPuzzle)!
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
        let indxOfBlank = self.boardElements.indexOf(.BlankPuzzle)!
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
            case .BlankPuzzle : str += ("O")
            case .NumberPuzzle(let val): str += "\(val)"
            }
        }
        return str.hashValue
    }

}

extension Board {
    func standardGeneratorFunction(parentBoard: Board?) -> [(Board, BlankSpaceMove)] {
        let mapped = self.possibleMoves.map {
            return (self.makeMove($0), $0)
            }
        
        if let parentBoard = parentBoard {
            return mapped.filter { (board, move) -> Bool in
                board != parentBoard
            }
        }
        else {
            return mapped
        }
    }
}

extension Board {
    
    private func rowAndColumnForIndex(indx: Int, gridSize: Int) -> (Int, Int) {
        let row = Int(Double(indx) / Double(gridSize))
        let column = indx % gridSize
        return (row, column)
    }
    private func distanceFromIndx(indx1: Int, toIndx indx2: Int, withGridSize gridSize: Int) -> Int {
        let (firstRow, firstColumn) = rowAndColumnForIndex(indx1, gridSize: gridSize)
        let (secondRow, secondColumn) = rowAndColumnForIndex(indx2, gridSize: gridSize)
        return abs(firstRow - secondRow) + abs(firstColumn - secondColumn)
    }
    
    
    
    func sumOfDistancesToOtherBoard(otherBoard: Board) -> Int {
        var sumOfDistances: Int = 0
        for (i, elem ) in self.boardElements.enumerate() {
            guard let otherIndx = otherBoard.boardElements.indexOf(elem) else { fatalError("elements should match") }
            sumOfDistances += distanceFromIndx(i, toIndx: otherIndx, withGridSize: 4)
        }
        return sumOfDistances
        
        
    }
}
extension Board : ArrayLiteralConvertible {

    init(arrayLiteral elements: String...) {
        guard elements.all ({
            return Int($0) != nil || $0 == "_" })
         else { fatalError("wrong elements") }
        // TODO: Add erorr checking(exactly one blank puzzle)
        self.boardElements = elements.map {
            if let intValue = Int($0) { return BoardElement.NumberPuzzle(UInt8(intValue)) }
            else { return BoardElement.BlankPuzzle }
        }
    }
}




///Board powinno być Equatable - powinniśmy móc porównać jedną planszę z drugą.

func ==(lhs: Board, rhs: Board) -> Bool {
    let elemsCount = lhs.boardElements.count
    for i in 0..<elemsCount where lhs.boardElements[i] != rhs.boardElements[i]{
        return false
    }
    return true
}


