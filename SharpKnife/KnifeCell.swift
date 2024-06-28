import UIKit

class KnifeCell: UITableViewCell {
    func configure(with knife: Knife) {
        textLabel?.text = "\(knife.date) - Type: \(knife.type) - Name: \(knife.name)"
        imageView?.image = knife.loadImage()
    }
}
