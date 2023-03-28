//
//  WelcomeViewController.swift
//

import UIKit

class WelcomeViewController: AppViewController<WelcomeViewModel>, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let header = UILabel()
    let text = UILabel()
    let search = UISearchBar()
    var searchController: UISearchController?
    let addTextField = UITextField()
    let addButton = UIButton()
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        hederSetup()
        textSetup()
        searchSetup()
        setupProductList()
        addTextFieldSetup()
        addButtonSetup()
        let defaults = UserDefaults.standard
        if let savedWords = defaults.object(forKey: "savedWords") as? [String] {
            viewModel.words = savedWords
        }
        viewModel.filteredWords = nil // initialize filteredWords to nil
        collectionView?.reloadData()
    }
    
    func hederSetup() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = Content.search
        header.font = .boldSystemFont(ofSize: 32)
        header.textColor = Design.Color.blue
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
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
    
    func searchSetup() {
        view.addSubview(search)
        search.translatesAutoresizingMaskIntoConstraints = false
        search.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 15).isActive = true
        search.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        search.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        search.placeholder = "Search"
        search.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        search.delegate = self
    }
    
    func addTextFieldSetup() {
        view.addSubview(addTextField)
        addTextField.translatesAutoresizingMaskIntoConstraints = false
        addTextField.placeholder = "Add new word"
        addTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        addTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -110).isActive = true
        addTextField.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 20).isActive = true
        addTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addTextField.borderStyle = .roundedRect
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
    
    func setupProductList() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = -5
        layout.itemSize = CGSize(width: (view.frame.size.width-30)/2, height: 60)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 80).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredWords?.count ?? viewModel.words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.words.count else {
            return
        }
        let word = viewModel.words[indexPath.row]
        let registrationViewController = RegistrationViewController()
        registrationViewController.selectedWord = word
        registrationViewController.synonyms = viewModel.synonyms
        navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
        let word: String
        let synonyms: [String]
        if let filteredWords = viewModel.filteredWords {
            guard indexPath.row < filteredWords.count else {
                return cell
            }
            word = filteredWords[indexPath.row]
        } else {
            guard indexPath.row < viewModel.words.count else {
                return cell
            }
            word = viewModel.words[indexPath.row]
        }
        synonyms = viewModel.synonyms[word] ?? []
        cell.configure(with: word, synonyms: synonyms)
        cell.viewModel = viewModel
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filteredWords = nil // show all words if search text is empty
        } else {
            viewModel.filteredWords = viewModel.words.filter { $0.lowercased().contains(searchText.lowercased()) } // filter the words based on search text
        }
        collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hide the keyboard
    }
    
    @objc func addButtonTapped() {
        let word = addTextField.text ?? ""
        viewModel.addWord(word)
        // Save the updated words array to UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(viewModel.words, forKey: "savedWords")
        collectionView?.reloadData()
        addTextField.text = ""
    }
    
    override func bindViewModel() {
        viewModel = WelcomeViewModel()
        
    }
}



