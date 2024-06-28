//
//  LogEntryDetailCell.swift
//  SharpKnife
//
//  Created by Walt Moorhouse on 6/27/24.
//

import UIKit

class LogEntryDetailCell: UITableViewCell {
    func configure(with logEntry: LogEntry) {
        textLabel?.text = "\(logEntry.date) \(logEntry.sharpener) " + logEntry.parameters.joined(separator: ", ")
    }
}
