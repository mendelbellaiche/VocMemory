//
//  WordsViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

class WordsViewController: UIViewController {

    var group: Group!
    var words: [Word]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.words = CoreDataHelper.shared.readWord(group: self.group)
        
    }
    
    func setup(group: Group) {
        self.group = group
        self.navigationItem.title = self.group.title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
