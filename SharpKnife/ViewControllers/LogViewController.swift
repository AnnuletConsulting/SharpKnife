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

class AddLogEntryViewController: UIViewController {
    weak var delegate: AddLogEntryViewControllerDelegate?

    let dateTextField = UITextField()
    let knifeTextField = UITextField()
    let sharpenerTextField = UITextField()
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Log Entry"
        view.backgroundColor = .white
        setupFields()
        setupButtons()
    }

    func setupFields() {
        dateTextField.placeholder = "Date"
        knifeTextField.placeholder = "Knife"
        sharpenerTextField.placeholder = "Sharpener"

        let stackView = UIStackView(arrangedSubviews: [dateTextField, knifeTextField, sharpenerTextField])
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
    }

    func setupButtons() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func save() {
        guard let date = dateTextField.text, !date.isEmpty,
              let knife = knifeTextField.text, !knife.isEmpty,
              let sharpener = sharpenerTextField.text, !sharpener.isEmpty else {
            return
        }

        let logEntry = LogEntry(date: date, knife: knife, sharpener: sharpener)
        delegate?.didSaveLogEntry(logEntry)
        dismiss(animated: true, completion: nil)
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
