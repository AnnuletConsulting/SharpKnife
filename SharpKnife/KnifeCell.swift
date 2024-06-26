import UIKit

class KnifeCell: UITableViewCell {
    func configure(with knife: Knife) {
        textLabel?.text = "\(knife.date) - Type: \(knife.type) - Name: \(knife.name)"
        if let imageData = knife.imageData, let image = UIImage(data: imageData) {
            imageView?.image = image
        }
    }
}
