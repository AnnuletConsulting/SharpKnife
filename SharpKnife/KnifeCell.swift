import UIKit

protocol KnifeCellDelegate: AnyObject {
    func didTapLogButton(for knife: Knife)
}

class KnifeCell: UITableViewCell {
    weak var delegate: KnifeCellDelegate?

    private var knife: Knife?

    func configure(with knife: Knife) {
        self.knife = knife
        textLabel?.text = "\(knife.date) - Type: \(knife.type) - Name: \(knife.name)"
        imageView?.image = knife.loadImage()
        setupLogButton()
    }

    private func setupLogButton() {
        let logButton = UIButton(type: .system)
        logButton.setTitle("Log", for: .normal)
        logButton.addTarget(self, action: #selector(logButtonTapped), for: .touchUpInside)
        accessoryView = logButton
    }

    @objc private func logButtonTapped() {
        guard let knife = knife else { return }
        delegate?.didTapLogButton(for: knife)
    }
}
