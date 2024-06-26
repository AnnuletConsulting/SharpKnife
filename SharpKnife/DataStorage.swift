import Foundation

class DataStorage {
    static let shared = DataStorage()

    private let logEntriesKey = "logEntriesKey"
    private let knivesKey = "knivesKey"
    private let sharpenersKey = "sharpenersKey"

    private init() {}

    // Save log entries
    func saveLogEntries(_ logEntries: [LogEntry]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(logEntries) {
            UserDefaults.standard.set(encoded, forKey: logEntriesKey)
        }
    }

    // Load log entries
    func loadLogEntries() -> [LogEntry] {
        if let savedData = UserDefaults.standard.data(forKey: logEntriesKey) {
            let decoder = JSONDecoder()
            if let loadedLogEntries = try? decoder.decode([LogEntry].self, from: savedData) {
                return loadedLogEntries
            }
        }
        return []
    }

    // Save knives
    func saveKnives(_ knives: [Knife]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(knives) {
            UserDefaults.standard.set(encoded, forKey: knivesKey)
        }
    }

    // Load knives
    func loadKnives() -> [Knife] {
        if let savedData = UserDefaults.standard.data(forKey: knivesKey) {
            let decoder = JSONDecoder()
            if let loadedKnives = try? decoder.decode([Knife].self, from: savedData) {
                return loadedKnives
            }
        }
        return []
    }

    // Save sharpeners
    func saveSharpeners(_ sharpeners: [Sharpener]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sharpeners) {
            UserDefaults.standard.set(encoded, forKey: sharpenersKey)
        }
    }

    // Load sharpeners
    func loadSharpeners() -> [Sharpener] {
        if let savedData = UserDefaults.standard.data(forKey: sharpenersKey) {
            let decoder = JSONDecoder()
            if let loadedSharpeners = try? decoder.decode([Sharpener].self, from: savedData) {
                return loadedSharpeners
            }
        }
        return []
    }
}
