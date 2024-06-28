import UIKit

class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var logEntries: [LogEntry] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log"
        view.backgroundColor = .white
        logEntries = DataStorage.shared.loadLogEntries()
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

    // Swipe actions for editing and deleting
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.confirmDeletion(at: indexPath)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.editLogEntry(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    func confirmDeletion(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Log Entry", message: "Are you sure you want to delete this log entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            DataStorage.shared.deleteLogEntry(at: indexPath.row)
            self.logEntries.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func editLogEntry(at indexPath: IndexPath) {
        let editLogVC = AddLogEntryViewController()
        editLogVC.delegate = self
        editLogVC.logEntryToEdit = logEntries[indexPath.row]
        editLogVC.logEntryIndex = indexPath.row
        let navController = UINavigationController(rootViewController: editLogVC)
        present(navController, animated: true, completion: nil)
    }
}

extension LogViewController: AddLogEntryViewControllerDelegate {
    func didSaveLogEntry(_ logEntry: LogEntry, at index: Int?) {
        if let index = index {
            logEntries[index] = logEntry
        } else {
            logEntries.append(logEntry)
        }
        DataStorage.shared.saveLogEntries(logEntries)
        tableView.reloadData()
    }
}
