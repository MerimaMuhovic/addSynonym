import UIKit
import Bond

class RegistrationViewController: AppViewController<RegistrationViewModel>, UITableViewDataSource, UITableViewDelegate {
    let header = UILabel()
    let text = UILabel()
    var selectedWord: String?
    let addTextField = UITextField()
    let addButton = UIButton()
    let tableView = UITableView()
    var synonyms: [String: [String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel = RegistrationViewModel()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        viewModel.synonymsDidUpdate.observeNext { [weak self] _ in
            // Unwrap the optional array and update the synonyms property with the synonyms for the selected word from the RegistrationViewModel
            if let synonymsArray = self?.viewModel.synonyms.value[self?.selectedWord ?? ""] {
                self?.synonyms = [self?.selectedWord ?? "": synonymsArray]
            }
            self?.tableView.reloadData()
        }.dispose(in: bag)
    }
    
    func setup() {
        hederSetup()
        textSetup()
        setupTable()
        addTextFieldSetup()
        addButtonSetup()
    }
    
    func hederSetup() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "Selected word: \(selectedWord ?? " ")"
        header.font = .boldSystemFont(ofSize: 32)
        header.textColor = Design.Color.blue
        header.numberOfLines = 2
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        header.numberOfLines = 3
    }
    
    func textSetup() {
        view.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = Content.headerText
        text.font = .boldSystemFont(ofSize: 18)
        text.numberOfLines = 2
        text.textColor = Design.Color.blue
        text.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15).isActive = true
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
    }
    
    func addTextFieldSetup() {
        view.addSubview(addTextField)
        addTextField.translatesAutoresizingMaskIntoConstraints = false
        addTextField.placeholder = "Add new word"
        addTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        addTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -110).isActive = true
        addTextField.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 20).isActive = true
        addTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addTextField.borderStyle = .roundedRect
        addTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        addButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    func addButtonSetup() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = Design.Color.blue
        addButton.layer.cornerRadius = 10
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        addButton.bottomAnchor.constraint(equalTo: addTextField.bottomAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: addTextField.widthAnchor, multiplier: 0.25).isActive = true
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        guard let newSynonym = addTextField.text else { return }
        do {
            try viewModel.addSynonym(newSynonym, toWord: selectedWord!)
            tableView.reloadData()
            addTextField.text = ""
        } catch {
            print("Error adding synonym: \(error.localizedDescription)")
        }
    }
    
    func setupTable() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 70).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.synonyms.value[selectedWord ?? ""]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell

        guard let synonyms = viewModel.synonyms.value[selectedWord ?? ""] else {
            return cell
        }
        cell.configure(with: synonyms[indexPath.row])
        
        // Set the onDeleteSynonym closure on the cell
        cell.onDeleteSynonym = { [weak self] in
            guard let strongSelf = self else { return }
            let synonym = synonyms[indexPath.row]
            do {
                try strongSelf.viewModel.removeSynonym(synonym, fromWord: strongSelf.selectedWord!)
                tableView.reloadData()
            } catch {
                print("Error removing synonym: \(error.localizedDescription)")
            }
        }
        
        return cell
    }

    
    override func bindViewModel() {
    }
}
