import UIKit

class KnivesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        return cell
    }
}

extension KnivesViewController: AddKnifeViewControllerDelegate {
    func didSaveKnife(_ knife: Knife) {
        knives.append(knife)
        DataStorage.shared.saveKnives(knives)
        tableView.reloadData()
    }
}
