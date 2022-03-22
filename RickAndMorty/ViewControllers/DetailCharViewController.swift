//
//  DetailCharViewController.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.03.2022.
//

import UIKit

class DetailCharViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var characterImageView: UIImageView! {
        didSet{
            characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
        }
    }
    @IBOutlet var descriptionLabel: UILabel!

    // MARK: public properies
    var result: Results?
    var characterUrl: String!

    // MARK: private properies
    private var spinnerView: UIActivityIndicatorView!

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView = showSpinner(in: view)
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }

        NetworkManager.shared.fetchCharacter(from: characterUrl) { result in
            switch result {
            case .success(let result):
                self.result = result
                self.title = result.name
                self.descriptionLabel.text = result.description
                guard let imageData = ImageManager.shared.fetchImage(from: result.image) else {return}
                self.characterImageView.image = UIImage(data: imageData)
                self.spinnerView.stopAnimating()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - private Methods
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true

        view.addSubview(activityIndicator)

        return activityIndicator
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let navigationController = segue.destination as! UINavigationController
         let episodeVC = navigationController.topViewController as! EpisodsTableViewController
        episodeVC.result = result
        
    }
}

