//
//  EpisodsTableViewController.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.03.2022.
//

import UIKit

class EpisodsTableViewController: UITableViewController {
    
    var result: Results!
    var episodes: [Episode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 0.7
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.episode.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episode", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let episodeURL = result.episode[indexPath.row]
        content.textProperties.color = .white
        content.textProperties.font = UIFont.boldSystemFont(ofSize: 17)
        NetworkManager.shared.fetchEpisode(from: episodeURL) { result in
            switch result {
            case .success(let episode):
                self.episodes.append(episode)
                content.text = episode.name
                cell.contentConfiguration = content
            case .failure(let error):
                print(error)
            }
        }
       

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeUrl = result.episode[indexPath.row]
        performSegue(withIdentifier: "showEpisode", sender: episodeUrl)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let episodeVC = segue.destination as! EpisodDetailViewController
        episodeVC.episodeUrl = sender as? String
    }
    

}
