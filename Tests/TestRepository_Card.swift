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
        XCTAssertEqual(0, card.position.0)
        XCTAssertEqual(0, card.position.1)
    }
}