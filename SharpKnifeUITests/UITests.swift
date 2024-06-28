import XCTest

class UITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddKnife() throws {
        app.tabBars.buttons["Knives"].tap()
        app.buttons["Add"].tap()

        let dateField = app.textFields["Purchased Date"]
        XCTAssertTrue(dateField.exists, "The 'Purchased Date' text field does not exist")
        dateField.tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2022")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let typeField = app.textFields["Knife Type"]
        XCTAssertTrue(typeField.exists, "The 'Knife Type' text field does not exist")
        typeField.tap()
        typeField.typeText("Chef's Knife")
        app.toolbars["Toolbar"].buttons["Done"].tap() // Dismiss the keyboard
        
        let nameField = app.textFields["Knife Name"]
        XCTAssertTrue(nameField.exists, "The 'Knife Name' text field does not exist")
        nameField.tap()
        nameField.typeText("Wusthof")
        app.toolbars["Toolbar"].buttons["Done"].tap() // Dismiss the keyboard
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "The 'Save' button does not exist")
        saveButton.scrollToElement()
        saveButton.tap()
        
        let knifeCell = app.tables.cells.staticTexts["Wusthof"]
        XCTAssertTrue(knifeCell.exists, "The knife cell with name 'Wusthof' does not exist")
    }

    func testAddSharpener() throws {
        app.tabBars.buttons["Sharpeners"].tap()
        app.buttons["Add"].tap()

        let dateField = app.textFields["Purchased Date"]
        XCTAssertTrue(dateField.exists, "The 'Purchased Date' text field does not exist")
        dateField.tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2022")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let typeField = app.textFields["Sharpener Type"]
        XCTAssertTrue(typeField.exists, "The 'Sharpener Type' text field does not exist")
        typeField.tap()
        typeField.typeText("Whetstone")
        app.toolbars["Toolbar"].buttons["Done"].tap() // Dismiss the keyboard
        
        app.buttons["Add Parameter"].tap()
        
        let parameterField = app.alerts.textFields["Parameter"]
        XCTAssertTrue(parameterField.exists, "The 'Parameter' text field in alert does not exist")
        parameterField.tap()
        parameterField.typeText("Grit: 1000")
        
        app.alerts.buttons["Add"].tap()
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "The 'Save' button does not exist")
        saveButton.scrollToElement()
        saveButton.tap()
        
        let sharpenerCell = app.tables.cells.staticTexts["Whetstone"]
        XCTAssertTrue(sharpenerCell.exists, "The sharpener cell with type 'Whetstone' does not exist")
    }

    func testAddLogEntry() throws {
        app.tabBars.buttons["Log"].tap()
        app.buttons["Add"].tap()

        let dateField = app.textFields["Date"]
        XCTAssertTrue(dateField.exists, "The 'Date' text field does not exist")
        dateField.tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2022")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let knifeField = app.textFields["Knife"]
        XCTAssertTrue(knifeField.exists, "The 'Knife' text field does not exist")
        knifeField.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Wusthof")
        app.toolbars["Toolbar"].buttons["Done"].tap() // Dismiss the picker
        
        let sharpenerField = app.textFields["Sharpener"]
        XCTAssertTrue(sharpenerField.exists, "The 'Sharpener' text field does not exist")
        sharpenerField.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Whetstone")
        app.toolbars["Toolbar"].buttons["Done"].tap() // Dismiss the picker
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "The 'Save' button does not exist")
        saveButton.scrollToElement()
        saveButton.tap()
        
        let logEntryCell = app.tables.cells.staticTexts["2022-01-01"]
        XCTAssertTrue(logEntryCell.exists, "The log entry cell with date '2022-01-01' does not exist")
    }
}

extension XCUIElement {
    func scrollToElement() {
        while !self.isHittable {
            XCUIApplication().swipeUp()
        }
    }
}
