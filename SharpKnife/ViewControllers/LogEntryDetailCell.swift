import UIKit

class LogEntryDetailCell: UITableViewCell {
    func configure(with logEntry: LogEntry) {
        guard let sharpener = DataStorage.shared.loadSharpeners().first(where: { $0.type == logEntry.sharpener }) else {
            textLabel?.text = "\(logEntry.date) - Sharpener: \(logEntry.sharpener) " + logEntry.parameters.joined(separator: ", ")
            return
        }
        
        var displayText = "\(logEntry.date) - Sharpener: \(logEntry.sharpener)\n"
        for (index, parameter) in logEntry.parameters.enumerated() {
            var seperator = ", "
            if (index + 1 == sharpener.parameters.count) {
                seperator = ""
            }
            if index < sharpener.parameters.count {
                displayText += "\(sharpener.parameters[index]): \(parameter)" + seperator
            } else {
                displayText += "\(parameter)" + seperator
            }
        }

        textLabel?.numberOfLines = 0 // Allow multiline
        textLabel?.text = displayText.trimmingCharacters(in: .whitespacesAndNewlines)
        setupConstraints()
    }

    private func setupConstraints() {
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        if let textLabel = textLabel {
            NSLayoutConstraint.activate([
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
    }
}
