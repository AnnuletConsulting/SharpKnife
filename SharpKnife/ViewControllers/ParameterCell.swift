import UIKit

class ParameterCell: UITableViewCell {
    private let parameterLabel = UILabel()
    private let deleteButton = UIButton(type: .system)

    var deleteAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with parameter: String, deleteAction: @escaping () -> Void) {
        parameterLabel.text = parameter
        self.deleteAction = deleteAction
    }

    private func setupViews() {
        parameterLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        contentView.addSubview(parameterLabel)
        contentView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            parameterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            parameterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
}
