import UIKit

protocol AddSharpenerViewControllerDelegate: AnyObject {
    func didSaveSharpener(_ sharpener: Sharpener, at index: Int?)
}

class AddSharpenerViewController: UIViewController {
    weak var delegate: AddSharpenerViewControllerDelegate?

    var sharpenerToEdit: Sharpener?
    var sharpenerIndex: Int?

    let dateTextField = UITextField()
    let typeTextField = UITextField()
    let parametersTableView = UITableView()
    var parameters: [(String, String)] = []
    let addParameterButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sharpenerToEdit == nil ? "Add Sharpener" : "Edit Sharpener"
        view.backgroundColor = .white
        setupFields()
        setupButtons()
        setupLayout()

        if let sharpener = sharpenerToEdit {
            dateTextField.text = sharpener.date
            typeTextField.text = sharpener.type
            parameters = sharpener.parameters
            parametersTableView.reloadData()
        }
    }

    func setupFields() {
        dateTextField.placeholder = "Purchased Date"
        dateTextField.borderStyle = .roundedRect
        dateTextField.inputView = datePicker

        // Set up the date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        // Add a toolbar with a Done button to dismiss the date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar

        typeTextField.placeholder = "Sharpener Type"
        typeTextField.borderStyle = .roundedRect

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
    }

    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [dateTextField, typeTextField, parametersTableView, addParameterButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let buttonStackView = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func doneButtonTapped() {
        // Format the selected date and display it in the text field
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
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
        delegate?.didSaveSharpener(sharpener, at: sharpenerIndex)
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
