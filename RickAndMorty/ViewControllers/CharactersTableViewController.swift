//
//  CharactersTableViewController.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.03.2022.
//

import UIKit

class CharactersTableViewController: UITableViewController {
    
    // MARK: private properties
    private var rickAndMorty: RickAndMorty?
    private let searchController = UISearchController(searchResultsController: nil)
    private var filtredCharacter: [Results] = []
    private var searchBarIsEmpty:Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchController()
        fetchData(from: URLS.rickandmortyapi.rawValue)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filtredCharacter.count: rickAndMorty?.results.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterTableViewCell
        
        let result = isFiltering ? filtredCharacter[indexPath.row] : rickAndMorty?.results[indexPath.row]
        cell.configure(with: result)
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let character = isFiltering ? filtredCharacter[indexPath.row]: rickAndMorty?.results[indexPath.row]
        let detailVC = segue.destination as! DetailCharViewController
        detailVC.characterUrl = character?.url
    }
    
    @IBAction func updateData(_ sender: UIBarButtonItem) {
        sender.tag == 1
        ? fetchData(from: rickAndMorty?.info.next ?? "")
        : fetchData(from: rickAndMorty?.info.prev  ?? "")
    }
    
    //MARK: private methods
    private func fetchData(from url: String) {
        NetworkManager.shared.fetchData(from: url) { rickAndMorty in
            self.rickAndMorty = rickAndMorty
            self.tableView.reloadData()
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField  = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    // Setup navigation Bar
    private func setupNavigationBar() {
        title = "Rick and Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        
        let barButton = UIBarButtonItem()
        barButton.tintColor = .cyan
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
        
        
    }
}

extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtredCharacter = rickAndMorty?.results.filter { chracter in
            chracter.name.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
}
