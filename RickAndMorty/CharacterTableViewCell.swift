//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.03.2022.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: CharacteImageView! {
        didSet{
            cellImageView.contentMode = .scaleAspectFit
            cellImageView.clipsToBounds = true
            cellImageView.layer.cornerRadius = cellImageView.bounds.height / 2
            cellImageView.backgroundColor = .white
        }
    }
    
    @IBOutlet var nameLabel: UILabel!
    
    func configure(with resulst: Results?) {
        self.nameLabel.text = resulst?.name
        cellImageView.fetchImage(from: resulst?.image ?? "")
    }
}
