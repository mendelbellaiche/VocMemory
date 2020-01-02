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
let TEST_WORD_SEGUE_ID = "testWordSegue"
let WORD_CELL = "wordCell"

protocol WordDelegate : class {
    
    func addArray(with word: Word)
    func removeArray(with word: Word)
    func updateArray(with id: UUID, front: String, back: String, favori: Bool, lastDate: Date)
    
}

class WordsViewController: UIViewController {

    var group: Group!
    var words: [Word]?
    
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    
    // MARK: - Lifecyle methods and setup functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.words = CoreDataHelper.shared.readWord(id: self.group.id!)
        
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
        if segue.identifier == TEST_WORD_SEGUE_ID {
            if let vc = segue.destination as? TestWordViewController {
                vc.group = sender as? Group
                //vc.delegate = self
            }
        }
        
    }
    
    // MARK: - Buttons Action methods

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: ADD_WORD_SEGUE_ID, sender: self.group)
    }
    
    @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: TEST_WORD_SEGUE_ID, sender: self.group)
    }
    
}

// MARK: - Collection protocol methods

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

// MARK: - WordDelegate protocol methods

extension WordsViewController: WordDelegate {

    func removeArray(with word: Word) {
        self.words = self.words?.filter() { $0 !== word }
        self.wordsCollectionView.reloadData()
    }
    
    
    func addArray(with word: Word) {
        self.words?.append(word)
        self.wordsCollectionView.reloadData()
    }
    
    func updateArray(with id: UUID, front: String, back: String, favori: Bool, lastDate: Date) {
        
        let words = self.words?.filter() { $0.id == id }
        if let word = words?.first {
            word.front = front
            word.back = back
            word.favoris = favori
            word.lastDate = lastDate
        }
        
        self.words?.sort(by: { (w1, w2) in
            w1.lastDate!.compare(w2.lastDate!) == .orderedDescending
        })
        
        self.wordsCollectionView.reloadData()
        
    }

}
