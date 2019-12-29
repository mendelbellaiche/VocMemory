//
//  WordCollectionViewCell.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var favoriImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(content: String, favori: Bool) {
        
        updateUI()
        
        self.contentLabel.text = content
        self.favoriImageView.image = favori ? UIImage(systemName: "bookmark") : nil
    }
    
    func updateUI() {
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
}
