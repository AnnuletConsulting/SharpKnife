import UIKit

class KnivesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var knives: [Knife] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Knives"
        view.backgroundColor = .white
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
        tableView.reloadData()
    }
}

protocol AddKnifeViewControllerDelegate: AnyObject {
    func didSaveKnife(_ knife: Knife)
}

class AddKnifeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: AddKnifeViewControllerDelegate?

    let dateTextField = UITextField()
    let typeTextField = UITextField()
    let nameTextField = UITextField()
    let imageView = UIImageView()
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    let imagePickerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Knife"
        view.backgroundColor = .white
        setupFields()
        setupButtons()
    }

    func setupFields() {
        dateTextField.placeholder = "Purchased Date"
        typeTextField.placeholder = "Knife Type"
        nameTextField.placeholder = "Knife Name"

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray

        let stackView = UIStackView(arrangedSubviews: [dateTextField, typeTextField, nameTextField, imageView])
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

        imagePickerButton.setTitle("Pick Image", for: .normal)
        imagePickerButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        view.addSubview(imagePickerButton)

        NSLayoutConstraint.activate([
            imagePickerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            imagePickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupButtons() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        let buttonStackView = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }

    @objc func save() {
        guard let date = dateTextField.text, !date.isEmpty,
              let type = typeTextField.text, !type.isEmpty,
              let name = nameTextField.text, !name.isEmpty,
              let image = imageView.image else {
            return
        }

        let knife = Knife(date: date, type: type, name: name, image: image)
        delegate?.didSaveKnife(knife)
        dismiss(animated: true, completion: nil)
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
