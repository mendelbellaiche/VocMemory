//
//  WordsViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

let ADD_WORD_SEGUE_ID = "addWordSegue"
let EDIT_WORD_SEGUE_ID = "editWordSegue"
let WORD_CELL = "wordCell"

class WordsViewController: UIViewController {

    var group: Group!
    var words: [Word]?
    
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.words = CoreDataHelper.shared.readWord(group: self.group)
        
        self.wordsCollectionView.delegate = self
        self.wordsCollectionView.dataSource = self
        
    }
    
    func setup(group: Group) {
        self.group = group
        self.navigationItem.title = self.group.title
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ADD_WORD_SEGUE_ID {
            if let vc = segue.destination as? AddWordViewController {
                vc.group = sender as? Group
                vc.delegate = self
            }
        }
        if segue.identifier == EDIT_WORD_SEGUE_ID {
            if let vc = segue.destination as? EditWordViewController {
                vc.word = sender as? Word
                vc.delegate = self
            }
        }
        
    }
    

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: ADD_WORD_SEGUE_ID, sender: self.group)
    }
}

extension WordsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.words!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WORD_CELL, for: indexPath) as! WordCollectionViewCell
        let word = self.words![indexPath.row]
        cell.configure(content: word.front!, favori: word.favoris)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let word = self.words![indexPath.row]
        self.performSegue(withIdentifier: EDIT_WORD_SEGUE_ID, sender: word)
    }
    
}

extension WordsViewController: WordDelegate {
    
    func removeArray(with word: Word) {
        self.words = self.words?.filter() { $0 !== word }
        self.wordsCollectionView.reloadData()
    }
    
    
    func addArray(with word: Word) {
        self.words?.append(word)
        self.wordsCollectionView.reloadData()
    }
    
}
