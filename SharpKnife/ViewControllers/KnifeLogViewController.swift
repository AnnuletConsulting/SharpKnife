import UIKit

class KnifeLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var knife: Knife?
    var logEntries: [LogEntry] = []

    let tableView = UITableView()
    let knifeImageView = UIImageView()
    let knifeDetailsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Knife Logs"
        view.backgroundColor = .white

        if let knife = knife {
            logEntries = DataStorage.shared.loadLogEntries().filter { $0.knife == knife.name }
            knifeDetailsLabel.text = "Type: \(knife.type)\nName: \(knife.name)\nPurchased Date: \(knife.date)"
            knifeImageView.image = knife.loadImage()
        }

        setupTableView()
        setupLayout()
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LogEntryCell.self, forCellReuseIdentifier: "LogEntryCell")
    }

    func setupLayout() {
        knifeImageView.translatesAutoresizingMaskIntoConstraints = false
        knifeDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        knifeImageView.contentMode = .scaleAspectFit
        knifeDetailsLabel.numberOfLines = 0

        view.addSubview(knifeImageView)
        view.addSubview(knifeDetailsLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            knifeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            knifeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            knifeImageView.heightAnchor.constraint(equalToConstant: 200),
            knifeImageView.widthAnchor.constraint(equalToConstant: 200),

            knifeDetailsLabel.topAnchor.constraint(equalTo: knifeImageView.bottomAnchor, constant: 10),
            knifeDetailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            knifeDetailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: knifeDetailsLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
