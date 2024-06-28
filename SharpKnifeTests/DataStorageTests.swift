import XCTest
@testable import SharpKnife

class DataStorageTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Clear the storage before each test
        DataStorage.shared.saveKnives([])
        DataStorage.shared.saveSharpeners([])
        DataStorage.shared.saveLogEntries([])
    }

    func testSaveAndLoadKnives() throws {
        let knife = Knife(date: "2022-01-01", type: "Chef's Knife", name: "Wusthof", image: nil)
        DataStorage.shared.saveKnives([knife])
        
        let loadedKnives = DataStorage.shared.loadKnives()
        XCTAssertEqual(loadedKnives.count, 1)
        XCTAssertEqual(loadedKnives.first?.name, "Wusthof")
    }

    func testSaveAndLoadSharpeners() throws {
        let sharpener = Sharpener(date: "2022-01-01", type: "Whetstone", parameters: ["Grit: 1000"])
        DataStorage.shared.saveSharpeners([sharpener])
        
        let loadedSharpeners = DataStorage.shared.loadSharpeners()
        XCTAssertEqual(loadedSharpeners.count, 1)
        XCTAssertEqual(loadedSharpeners.first?.type, "Whetstone")
    }

    func testSaveAndLoadLogEntries() throws {
        let logEntry = LogEntry(date: "2022-01-01", knife: "Wusthof", sharpener: "Whetstone", parameters: ["Grit: 1000"])
        DataStorage.shared.saveLogEntries([logEntry])
        
        let loadedLogEntries = DataStorage.shared.loadLogEntries()
        XCTAssertEqual(loadedLogEntries.count, 1)
        XCTAssertEqual(loadedLogEntries.first?.knife, "Wusthof")
    }
}
