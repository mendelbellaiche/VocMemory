//
//  AddWordViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

enum Memorisation {
    case fail
    case hard
    case medium
    case easy
    case neutral
}

protocol WordDelegate : class {
    
    func addArray(with word: Word)
    func removeArray(with word: Word)
    func updateArray(with id: UUID, front: String, back: String, favori: Bool, lastDate: Date)
}

class AddWordViewController: UIViewController {

    @IBOutlet weak var favoriButton: UIBarButtonItem!
    @IBOutlet weak var contentTV: UITextView!
    
    var front: Bool = true
    
    var frontText: String = ""
    var backText: String = ""
    var favoris: Bool = false
    
    var group: Group!
    
    weak var delegate: WordDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTV.delegate = self
        print(Memorisation.easy)
        print(Memorisation.medium)
        print(Memorisation.hard)
        print(Memorisation.fail)
        
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
        CoreDataHelper.shared.createWord(group: group, id: UUID(), front: self.frontText, back: self.backText, favori: self.favoris) { (word, error) in
            
            if error != nil { return }
            self.delegate?.addArray(with: word)
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriButtonTapped(_ sender: UIBarButtonItem) {
        
        self.favoris = !self.favoris
        
        if self.favoris {
            self.favoriButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            self.favoriButton.image = UIImage(systemName: "bookmark")
        }
        
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
