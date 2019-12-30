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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = word.front
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
