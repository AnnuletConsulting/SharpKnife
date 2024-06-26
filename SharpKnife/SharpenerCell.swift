import UIKit

class SharpenerCell: UITableViewCell {
    func configure(with sharpener: Sharpener) {
        textLabel?.text = "\(sharpener.date) - Type: \(sharpener.type)"
        detailTextLabel?.text = sharpener.parameters.map { "\($0.0): \($0.1)" }.joined(separator: ", ")
    }
}
