import UIKit

class SharpenersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sharpeners: [Sharpener] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sharpeners"
        view.backgroundColor = .white
        setupTableView()
        setupAddButton()
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SharpenerCell.self, forCellReuseIdentifier: "SharpenerCell")
        view.addSubview(tableView)
    }

    func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSharpener))
    }

    @objc func addSharpener() {
        let addSharpenerVC = AddSharpenerViewController()
        addSharpenerVC.delegate = self
        let navController = UINavigationController(rootViewController: addSharpenerVC)
        present(navController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharpeners.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharpenerCell", for: indexPath) as! SharpenerCell
        let sharpener = sharpeners[indexPath.row]
        cell.configure(with: sharpener)
        return cell
    }
}

extension SharpenersViewController: AddSharpenerViewControllerDelegate {
    func didSaveSharpener(_ sharpener: Sharpener) {
        sharpeners.append(sharpener)
        tableView.reloadData()
    }
}

protocol AddSharpenerViewControllerDelegate: AnyObject {
    func didSaveSharpener(_ sharpener: Sharpener)
}

class AddSharpenerViewController: UIViewController {
    weak var delegate: AddSharpenerViewControllerDelegate?

    let dateTextField = UITextField()
    let typeTextField = UITextField()
    let parametersTableView = UITableView()
    var parameters: [(String, String)] = []
    let addParameterButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Sharpener"
        view.backgroundColor = .white
        setupFields()
        setupButtons()
    }

    func setupFields() {
        dateTextField.placeholder = "Purchased Date"
        typeTextField.placeholder = "Sharpener Type"

        let stackView = UIStackView(arrangedSubviews: [dateTextField, typeTextField, parametersTableView, addParameterButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        parametersTableView.dataSource = self
        parametersTableView.delegate = self
        parametersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ParameterCell")
        parametersTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        addParameterButton.setTitle("Add Parameter", for: .normal)
        addParameterButton.addTarget(self, action: #selector(addParameter), for: .touchUpInside)
    }

    func setupButtons() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        let buttonStackView = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: addParameterButton.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func addParameter() {
        let alert = UIAlertController(title: "Add Parameter", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Key"
        }
        alert.addTextField { textField in
            textField.placeholder = "Value"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let key = alert.textFields?[0].text, !key.isEmpty,
                  let value = alert.textFields?[1].text, !value.isEmpty else {
                return
            }
            self?.parameters.append((key, value))
            self?.parametersTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc func save() {
        guard let date = dateTextField.text, !date.isEmpty,
              let type = typeTextField.text, !type.isEmpty else {
            return
        }

        let sharpener = Sharpener(date: date, type: type, parameters: parameters)
        delegate?.didSaveSharpener(sharpener)
        dismiss(animated: true, completion: nil)
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddSharpenerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParameterCell", for: indexPath)
        let parameter = parameters[indexPath.row]
        cell.textLabel?.text = "\(parameter.0): \(parameter.1)"
        return cell
    }
}
