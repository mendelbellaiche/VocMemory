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
    
    var frontText: String = ""
    var backText: String = ""
    var favori: Bool = false
    
    var group: Group!
    
    weak var delegate: WordAddDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentTV.becomeFirstResponder()
    }

    @IBAction func changeValue(_ sender: UISegmentedControl) {
        self.contentTV.text = sender.selectedSegmentIndex == 0 ? "\(self.frontText)" : "\(self.backText)"
        self.front = sender.selectedSegmentIndex == 0 ? true : false
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        /*CoreDataHelper.shared.createWord(group: group, front: self.frontText, back: self.backText) { (word, error) in
            self.delegate?.addArray(with: word)
        }*/
        
        CoreDataHelper.shared.createWord(group: group, front: self.frontText, back: self.backText, favori: self.favori) { (word, error) in
            
            if error != nil { return }
            self.delegate?.addArray(with: word)
            
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddWordViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if self.front {
            self.frontText = textView.text
        } else {
            self.backText = textView.text
        }
    }
    
}
