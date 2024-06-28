import UIKit

class LogEntryCell: UITableViewCell {
    func configure(with logEntry: LogEntry) {
        textLabel?.text = "\(logEntry.date) - Knife: \(logEntry.knife) - Sharpener: \(logEntry.sharpener)"
        detailTextLabel?.text = logEntry.parameters.joined(separator: ", ")
    }
}
