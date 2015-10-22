//
//  Board.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 22/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import Foundation




///BoardElement - element
enum BoardElement {
    
    case BlankPuzzle
    case NumberPuzzle(Int)
}
extension BoardElement: Equatable { }
    
    func ==(lhs: BoardElement, rhs: BoardElement) -> Bool {
    switch (lhs, rhs) {
        case (.BlankPuzzle, .BlankPuzzle) : return true
        case (let .NumberPuzzle(num1), let .NumberPuzzle(num2)): return num1 == num2
    default: return false
    }
}
/**BlankSpaceMoveType 
Możliwe ruchy dla każdego pustego miejsca - możemy ruszać się w prawo, w lewo, w przód, w dół
*/
enum BlankSpaceMove {
    case Up, Down, Left, Right
}
struct Board: Equatable {
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
    func makeMove(move: BlankSpaceMove) -> Board? {
        guard possibleMoves.contains(move) else { return nil }
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
    ///possibleMoves - zwraca ruchy, ktore jestesmy w stanie wykonac przy takim stanie planszy
    var possibleMoves: [BlankSpaceMove] {
        //Sprawdzamy indeks pola pustego. Unwrapping - jesteśmy pewni że istnieje, zapewniamy to w konstruktorze.
        var moves = [BlankSpaceMove]()
        let indxOfBlank = self.boardElements.indexOf(.BlankPuzzle)!
        let allElements = boardElements.count
        let elementsInRow: Int = Int(sqrt(Double(boardElements.count + 1)))
        if indxOfBlank + elementsInRow < allElements { moves.append(.Up) }
        if indxOfBlank - elementsInRow > -1 { moves.append(.Down) }
        if indxOfBlank % elementsInRow != 0 { moves.append(.Left) }
        if indxOfBlank + 1 % elementsInRow != 0 { moves.append(.Right) }
        
        return moves
    }

}


///Board powinno być Equatable - powinniśmy móc porównać jedną planszę z drugą.

func ==(lhs: Board, rhs: Board) -> Bool {
    let elemsCount = lhs.boardElements.count
    for i in 0..<elemsCount {
        if lhs.boardElements[i] != rhs.boardElements[i] { return false }
    }
    return true
}


