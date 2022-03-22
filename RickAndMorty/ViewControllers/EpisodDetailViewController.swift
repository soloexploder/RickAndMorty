//
//  EpisodDetailViewController.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.03.2022.
//

import UIKit

class EpisodDetailViewController: UIViewController {
    
    @IBOutlet var episodeDescripLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var episodeUrl: String!
    var episode: Episode?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        
        NetworkManager.shared.fetchEpisode(from: episodeUrl) { result in
            switch result {
            case .success(let episode):
                self.episode = episode
                self.title = episode.episode
                self.episodeDescripLabel.text = episode.description
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }

    }
        
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailCharViewController
        detailVC.characterUrl = sender as? String
    }
}

    //MARK: Table view data source
extension EpisodDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episode?.characters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodDetail", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = episode?.characters[indexPath.row]
        content.textProperties.color = .white
        content.textProperties.font = UIFont.boldSystemFont(ofSize: 17)
        cell.contentConfiguration = content
        
        return cell
    }
}

    //MARK: Table view delegate
extension EpisodDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let characterUrl = episode?.characters[indexPath.row]
        performSegue(withIdentifier: "showChar", sender: characterUrl)
    }
}
