import XCTest
@testable import VelvetRoom

class TestRepository_Card:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testNewCardNoColumnThrows() {
        XCTAssertThrowsError(try repository.newCard(Board()))
    }
    
    func testNewCard() {
        let time = Date().timeIntervalSince1970
        let board = Board()
        board.columns = [Column()]
        repository.boards = [board]
        var card:Card!
        XCTAssertNoThrow(try card = repository.newCard(board))
        XCTAssertTrue(card === repository.boards.first!.cards.first!)
        XCTAssertLessThan(time, card.positions.first!.time)
        XCTAssertEqual(0, card.positions.first!.column)
        XCTAssertEqual(0, card.positions.first!.index)
    }
    
    func testNewCardOrdering() {
        let board = Board()
        board.columns = [Column()]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        var cardThird:Card!
        XCTAssertNoThrow(try cardThird = repository.newCard(board))
        XCTAssertEqual(0, cardThird.column)
        XCTAssertEqual(0, cardThird.index)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(1, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(2, cardFirst.index)
    }
    
    func testMove() {
        let board = Board()
        let column = Column()
        board.columns = [column]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        var cardThird:Card!
        XCTAssertNoThrow(try cardThird = repository.newCard(board))
        repository.move(cardThird, board:board, column:column, after:cardFirst)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(0, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(1, cardFirst.index)
        XCTAssertEqual(0, cardThird.column)
        XCTAssertEqual(2, cardThird.index)
    }
    
    func testMoveNoAfter() {
        let board = Board()
        let column = Column()
        board.columns = [column]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        var cardThird:Card!
        XCTAssertNoThrow(try cardThird = repository.newCard(board))
        repository.move(cardFirst, board:board, column:column, after:nil)
        XCTAssertEqual(2, cardSecond.index)
        XCTAssertEqual(0, cardFirst.index)
        XCTAssertEqual(1, cardThird.index)
    }
    
    func testMoveOtherColumn() {
        let board = Board()
        let columnA = Column()
        let columnB = Column()
        board.columns = [columnA, columnB]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        var cardThird:Card!
        XCTAssertNoThrow(try cardThird = repository.newCard(board))
        repository.move(cardThird, board:board, column:columnB, after:nil)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(0, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(1, cardFirst.index)
        XCTAssertEqual(1, cardThird.column)
        XCTAssertEqual(0, cardThird.index)
    }
}
