import UIKit

class SharpenersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var sharpeners: [Sharpener] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadSharpeners()
    }
    
    func loadSharpeners() {
        // Load sharpeners from local storage (UserDefaults or Core Data)
    }
    
    @IBAction func addSharpener(_ sender: Any) {
        // Present popup to add new sharpener
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharpeners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharpenerCell", for: indexPath)
        let sharpener = sharpeners[indexPath.row]
        // Configure cell with sharpener data
        return cell
    }
}
