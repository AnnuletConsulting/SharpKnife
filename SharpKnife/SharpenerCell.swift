import UIKit

class SharpenerCell: UITableViewCell {
    func configure(with sharpener: Sharpener) {
        textLabel?.text = "\(sharpener.date) - Type: \(sharpener.type)"
        detailTextLabel?.text = sharpener.parameters.joined(separator: ", ")
    }
}
