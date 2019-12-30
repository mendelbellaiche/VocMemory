//
//  EditWordViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 30/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData



class EditWordViewController: UIViewController {

    var word: Word!
    
    weak var delegate: WordDelegate?
    
    var front: Bool = true
    
    var frontText: String = ""
    var backText: String = ""
    var favoris: Bool = false
    
    @IBOutlet weak var favoriButton: UIBarButtonItem!
    @IBOutlet weak var contentTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTV.delegate = self
        
        updateUI()
    }
    
    func updateUI() {
        
        self.frontText = self.word.front!
        self.backText = self.word.back!
        self.favoris = self.word.favoris

        self.navigationItem.title = self.frontText
        self.contentTV.text = self.frontText
        self.favoriButton.image = (self.favoris) ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        self.contentTV.becomeFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        CoreDataHelper.shared.updateWord(id: word.id!, front: self.frontText, back: self.backText, favori: self.favoris) { (word, error) in
            
            ToastUtils.shared.displayMessage(view: self, message: "Word updated", duration: 3.0, position: .center)
            
            self.word.front = self.frontText
            self.word.back = self.backText
            self.word.favoris = self.favoris
            self.delegate?.updateArray(with: self.word.id!, front: self.frontText, back: self.backText, favori: self.favoris)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func favoriButtonTapped(_ sender: UIBarButtonItem) {
        self.favoris = !self.favoris
        self.favoriButton.image = (self.favoris) ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        CoreDataHelper.shared.deleteWord(word: self.word) { error in
            if error != nil {
                ToastUtils.shared.displayMessage(view: self, message: "Error while deleting the word", duration: 3.0, position: .center)
            }
            self.delegate?.addArray(with: word)
            self.delegate?.removeArray(with: word)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func changeValue(_ sender: UISegmentedControl) {
        self.contentTV.text = sender.selectedSegmentIndex == 0 ? "\(self.frontText)" : "\(self.backText)"
        self.front = sender.selectedSegmentIndex == 0 ? true : false
    }

}

extension EditWordViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if self.front {
            self.frontText = textView.text
        } else {
            self.backText = textView.text
        }
    }
    
}
