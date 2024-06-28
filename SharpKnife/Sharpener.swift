import Foundation

struct Sharpener: Codable {
    var date: String
    var type: String
    var parameters: [String]

    init(date: String, type: String, parameters: [String]) {
        self.date = date
        self.type = type
        self.parameters = parameters
    }
}
