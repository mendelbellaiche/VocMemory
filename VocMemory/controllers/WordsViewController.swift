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

class WordsViewController: UIViewController {

    var group: Group!
    var words: [Word]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.words = CoreDataHelper.shared.readWord(group: self.group)
        
        for word in self.words! {
            print(word.front)
            print(word.back)
            
        }
    }
    
    func setup(group: Group) {
        self.group = group
        self.navigationItem.title = self.group.title
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddWordViewController {
            vc.group = sender as? Group
        }
    }
    

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: ADD_WORD_SEGUE_ID, sender: self.group)
    }
}
