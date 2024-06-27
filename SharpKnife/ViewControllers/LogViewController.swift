import UIKit

class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var logEntries: [LogEntry] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log"
        view.backgroundColor = .white
        setupTableView()
        setupAddButton()
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LogEntryCell.self, forCellReuseIdentifier: "LogEntryCell")
        view.addSubview(tableView)
    }

    func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLogEntry))
    }

    @objc func addLogEntry() {
        let addLogVC = AddLogEntryViewController()
        addLogVC.delegate = self
        let navController = UINavigationController(rootViewController: addLogVC)
        present(navController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogEntryCell", for: indexPath) as! LogEntryCell
        let logEntry = logEntries[indexPath.row]
        cell.configure(with: logEntry)
        return cell
    }
}

extension LogViewController: AddLogEntryViewControllerDelegate {
    func didSaveLogEntry(_ logEntry: LogEntry) {
        logEntries.append(logEntry)
        tableView.reloadData()
    }
}

protocol AddLogEntryViewControllerDelegate: AnyObject {
    func didSaveLogEntry(_ logEntry: LogEntry)
}

class AddLogEntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: AddLogEntryViewControllerDelegate?

    let dateTextField = UITextField()
    let knifeTextField = UITextField()
    let sharpenerTextField = UITextField()
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    let datePicker = UIDatePicker()
    let knifePicker = UIPickerView()
    let sharpenerPicker = UIPickerView()

    var knives: [Knife] = DataStorage.shared.loadKnives()
    var sharpeners: [Sharpener] = DataStorage.shared.loadSharpeners()
    var selectedKnife: Knife?
    var selectedSharpener: Sharpener?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Log Entry"
        view.backgroundColor = .white
        setupFields()
        setupButtons()
        setupLayout()
    }

    func setupFields() {
        dateTextField.placeholder = "Date"
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

        knifeTextField.placeholder = "Knife"
        knifeTextField.borderStyle = .roundedRect
        knifeTextField.inputView = knifePicker
        knifePicker.dataSource = self
        knifePicker.delegate = self

        sharpenerTextField.placeholder = "Sharpener"
        sharpenerTextField.borderStyle = .roundedRect
        sharpenerTextField.inputView = sharpenerPicker
        sharpenerPicker.dataSource = self
        sharpenerPicker.delegate = self

        // Add a toolbar with a Done button to dismiss the pickers
        let pickerToolbar = UIToolbar()
        pickerToolbar.sizeToFit()
        let pickerDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonTapped))
        pickerToolbar.setItems([pickerDoneButton], animated: true)
        knifeTextField.inputAccessoryView = pickerToolbar
        sharpenerTextField.inputAccessoryView = pickerToolbar
    }

    func setupButtons() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }

    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [dateTextField, knifeTextField, sharpenerTextField])
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

    @objc func pickerDoneButtonTapped() {
        if knifeTextField.isFirstResponder {
            let selectedRow = knifePicker.selectedRow(inComponent: 0)
            selectedKnife = knives[selectedRow]
            knifeTextField.text = selectedKnife?.name
            knifeTextField.resignFirstResponder()
        } else if sharpenerTextField.isFirstResponder {
            let selectedRow = sharpenerPicker.selectedRow(inComponent: 0)
            selectedSharpener = sharpeners[selectedRow]
            sharpenerTextField.text = selectedSharpener?.type
            sharpenerTextField.resignFirstResponder()
        }
    }

    @objc func save() {
        guard let date = dateTextField.text, !date.isEmpty,
              let knife = selectedKnife,
              let sharpener = selectedSharpener else {
            return
        }

        let logEntry = LogEntry(date: date, knife: knife.name, sharpener: sharpener.type)
        delegate?.didSaveLogEntry(logEntry)
        dismiss(animated: true, completion: nil)
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == knifePicker {
            return knives.count
        } else if pickerView == sharpenerPicker {
            return sharpeners.count
        }
        return 0
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == knifePicker {
            return knives[row].name
        } else if pickerView == sharpenerPicker {
            return sharpeners[row].type
        }
        return nil
    }
}
