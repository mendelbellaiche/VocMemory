//
//  TestWordViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 31/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

class TestWordViewController: UIViewController {

    var group: Group!
    var nbCard: Int!
    
    var words: [Word]?
    
    var goodNumber: Int = 0
    var badNumber: Int = 0
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var flipButton: MyButton!
    @IBOutlet weak var stackButtonCheck: UIStackView!
    
    // MARK: - Lifecyle methods and setup functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nbCard = UserDefaults.standard.integer(forKey: "NUMBER_CARD")

        randomWords()
        initUI()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func randomWords() {
        self.words = self.group.words?.allObjects as? [Word]
        self.words?.shuffle()
        if nbCard! <= self.words!.count {
            self.words = Array(self.words![0..<nbCard])
        }
    }
    
    func initUI() {
        self.stackButtonCheck.alpha = 0
        self.testLabel.text = self.words?.first!.front
    }
    
    func nextWord() {
        
        if self.words!.isEmpty == false {
            self.words!.removeFirst()
        }
        
        if self.words!.isEmpty {
            
            // self.navigationController?.popViewController(animated: true)
            
            displayPopup()
            
        } else {
            self.testLabel.text = self.words?.first!.front
        }
        
    }
    
    @IBAction func flipButtonTapped(_ sender: UIButton) {
        
        if self.words!.isEmpty == false {
            self.testLabel.text = self.words?.first!.back
        }
        
        self.updateButtonGroup(0, 1)
    }
    
    @IBAction func goodButtonTapped(_ sender: UIButton) {
        self.goodNumber += 1
        
        self.updateButtonGroup(1, 0)
        nextWord()
    }
    
    @IBAction func badButtonTapped(_ sender: UIButton) {
        self.badNumber += 1
        
        self.updateButtonGroup(1, 0)
        nextWord()
    }
    
    func updateButtonGroup(_ flipButtonAlpha: CGFloat, _ stackCheckButtonAlpha: CGFloat) {
        self.flipButton.alpha = flipButtonAlpha
        self.stackButtonCheck.alpha = stackCheckButtonAlpha
    }
    
    
    func displayPopup() {
        let total = goodNumber + badNumber
        var percent: Double = Double(goodNumber * 100)
        percent /= Double(total)
        
        let alert = UIAlertController(title: "Score", message: "Score : \(String(format: "%.2f", percent)) %", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
