import UIKit

class SharpenersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sharpeners: [Sharpener] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sharpeners"
        view.backgroundColor = .white
        sharpeners = DataStorage.shared.loadSharpeners()
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

    // Swipe actions for editing and deleting
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.confirmDeletion(at: indexPath)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.editSharpener(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    func confirmDeletion(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Sharpener", message: "Are you sure you want to delete this sharpener?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            DataStorage.shared.deleteSharpener(at: indexPath.row)
            self.sharpeners.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func editSharpener(at indexPath: IndexPath) {
        let editSharpenerVC = AddSharpenerViewController()
        editSharpenerVC.delegate = self
        editSharpenerVC.sharpenerToEdit = sharpeners[indexPath.row]
        editSharpenerVC.sharpenerIndex = indexPath.row
        let navController = UINavigationController(rootViewController: editSharpenerVC)
        present(navController, animated: true, completion: nil)
    }
}

extension SharpenersViewController: AddSharpenerViewControllerDelegate {
    func didSaveSharpener(_ sharpener: Sharpener, at index: Int?) {
        if let index = index {
            sharpeners[index] = sharpener
        } else {
            sharpeners.append(sharpener)
        }
        DataStorage.shared.saveSharpeners(sharpeners)
        tableView.reloadData()
    }
}
