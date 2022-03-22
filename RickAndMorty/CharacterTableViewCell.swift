//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.03.2022.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView! {
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

        DispatchQueue.global().async {
            guard let stringUrl = resulst?.image else {return}
            guard let imageUrl = URL(string: stringUrl) else {return}
            guard let imageData = try? Data(contentsOf: imageUrl) else {return}
            DispatchQueue.main.async {
                self.cellImageView.image = UIImage(data: imageData)
            }
        }
    }
}
