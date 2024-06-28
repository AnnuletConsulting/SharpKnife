import UIKit

class KnivesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, KnifeCellDelegate {
    var knives: [Knife] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Knives"
        view.backgroundColor = .white
        knives = DataStorage.shared.loadKnives()
        setupTableView()
        setupAddButton()
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(KnifeCell.self, forCellReuseIdentifier: "KnifeCell")
        view.addSubview(tableView)
    }

    func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addKnife))
    }

    @objc func addKnife() {
        let addKnifeVC = AddKnifeViewController()
        addKnifeVC.delegate = self
        let navController = UINavigationController(rootViewController: addKnifeVC)
        present(navController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knives.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KnifeCell", for: indexPath) as! KnifeCell
        let knife = knives[indexPath.row]
        cell.configure(with: knife)
        cell.delegate = self
        return cell
    }

    // Swipe actions for editing and deleting
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.confirmDeletion(at: indexPath)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.editKnife(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        let logAction = UIContextualAction(style: .normal, title: "Log") { (action, view, completionHandler) in
            self.viewLog(for: indexPath)
            completionHandler(true)
        }
        logAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, logAction])
    }

    func confirmDeletion(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Knife", message: "Are you sure you want to delete this knife?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            DataStorage.shared.deleteKnife(at: indexPath.row)
            self.knives.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func editKnife(at indexPath: IndexPath) {
        let editKnifeVC = AddKnifeViewController()
        editKnifeVC.delegate = self
        editKnifeVC.knifeToEdit = knives[indexPath.row]
        editKnifeVC.knifeIndex = indexPath.row
        let navController = UINavigationController(rootViewController: editKnifeVC)
        present(navController, animated: true, completion: nil)
    }

    func viewLog(for indexPath: IndexPath) {
        let knife = knives[indexPath.row]
        let logVC = KnifeLogViewController()
        logVC.knife = knife
        navigationController?.pushViewController(logVC, animated: true)
    }

    // KnifeCellDelegate method
    func didTapLogButton(for knife: Knife) {
        let logVC = KnifeLogViewController()
        logVC.knife = knife
        navigationController?.pushViewController(logVC, animated: true)
    }
}

extension KnivesViewController: AddKnifeViewControllerDelegate {
    func didSaveKnife(_ knife: Knife, at index: Int?) {
        if let index = index {
            knives[index] = knife
        } else {
            knives.append(knife)
        }
        DataStorage.shared.saveKnives(knives)
        tableView.reloadData()
    }
}
