//
//  AddWordViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

protocol WordAddDelegate : class {
    func addArray(with word: Word)
}

class AddWordViewController: UIViewController {

    @IBOutlet weak var contentTV: UITextView!
    
    var front:Bool = true
    
    var frontText: String = "front"
    var backText: String = "back"
    
    var group: Group!
    
    weak var delegate: WordAddDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeValue(_ sender: UISegmentedControl) {
        self.contentTV.text = sender.selectedSegmentIndex == 0 ? "\(self.frontText)" : "\(self.backText)"
        self.front = sender.selectedSegmentIndex == 0 ? true : false
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        CoreDataHelper.shared.createWord(group: group, front: self.frontText, back: self.backText) { (word, error) in
            self.delegate?.addArray(with: word)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
