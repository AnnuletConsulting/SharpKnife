import UIKit

protocol AddKnifeViewControllerDelegate: AnyObject {
    func didSaveKnife(_ knife: Knife, at index: Int?)
}

class AddKnifeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: AddKnifeViewControllerDelegate?

    var knifeToEdit: Knife?
    var knifeIndex: Int?

    let dateTextField = UITextField()
    let typeTextField = UITextField()
    let nameTextField = UITextField()
    let imageView = UIImageView()
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    let imagePickerButton = UIButton(type: .system)
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = knifeToEdit == nil ? "Add Knife" : "Edit Knife"
        view.backgroundColor = .white
        setupFields()
        setupButtons()
        setupLayout()

        if let knife = knifeToEdit {
            dateTextField.text = knife.date
            typeTextField.text = knife.type
            nameTextField.text = knife.name
            imageView.image = knife.loadImage()
        }
    }

    func setupFields() {
        dateTextField.placeholder = "Purchased Date"
        dateTextField.borderStyle = .roundedRect
        dateTextField.inputView = datePicker
        dateTextField.accessibilityIdentifier = "Purchased Date"
        addDoneButtonOnKeyboard(to: dateTextField)

        // Set up the date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        // Add a toolbar with a Done button to dismiss the date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar

        typeTextField.placeholder = "Knife Type"
        typeTextField.borderStyle = .roundedRect
        typeTextField.accessibilityIdentifier = "Knife Type"
        addDoneButtonOnKeyboard(to: typeTextField)

        nameTextField.placeholder = "Knife Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.accessibilityIdentifier = "Knife Name"
        addDoneButtonOnKeyboard(to: nameTextField)

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray

        imagePickerButton.setTitle("Pick Image", for: .normal)
        imagePickerButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }

    func setupButtons() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }

    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [dateTextField, typeTextField, nameTextField, imageView, imagePickerButton])
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

            imageView.heightAnchor.constraint(equalToConstant: 200),

            buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func addDoneButtonOnKeyboard(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
        view.endEditing(true)
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
              let name = nameTextField.text, !name.isEmpty else {
            return
        }

        let knife = Knife(date: date, type: type, name: name, image: imageView.image)
        delegate?.didSaveKnife(knife, at: knifeIndex)
        dismiss(animated: true, completion: nil)
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
