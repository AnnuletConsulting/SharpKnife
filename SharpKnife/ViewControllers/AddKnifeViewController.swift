import SwiftUI

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
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Knife"
        view.backgroundColor = .white
        setupFields()
        setupButtons()
        setupLayout()
    }

    func setupFields() {
        dateTextField.placeholder = "Purchased Date"
        dateTextField.borderStyle = .roundedRect
        dateTextField.inputView = datePicker

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
        nameTextField.placeholder = "Knife Name"
        nameTextField.borderStyle = .roundedRect

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

    @objc func doneButtonTapped() {
        // Format the selected date and display it in the text field
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
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
