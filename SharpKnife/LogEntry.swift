import Foundation

struct LogEntry: Codable {
    var date: String
    var knife: String
    var sharpener: String
    var parameters: [String]

    init(date: String, knife: String, sharpener: String, parameters: [String]) {
        self.date = date
        self.knife = knife
        self.sharpener = sharpener
        self.parameters = parameters
    }
}
