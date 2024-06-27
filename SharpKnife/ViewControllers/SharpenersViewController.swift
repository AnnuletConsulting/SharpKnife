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
