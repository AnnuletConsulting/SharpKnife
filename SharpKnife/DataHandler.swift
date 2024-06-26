func saveLogEntries() {
    let data = try? JSONEncoder().encode(logEntries)
    UserDefaults.standard.set(data, forKey: "logEntries")
}

func loadLogEntries() {
    if let data = UserDefaults.standard.data(forKey: "logEntries"),
       let entries = try? JSONDecoder().decode([LogEntry].self, from: data) {
        logEntries = entries
    }
}
