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
        if let vc = segue.destination as? AddWordViewController {
            vc.group = sender as? Group
            vc.delegate = self
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
    
}

extension WordsViewController: WordAddDelegate {
    
    func addArray(with word: Word) {
        self.words?.append(word)
        self.wordsCollectionView.reloadData()
    }
    
}
