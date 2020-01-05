//
//  ParametersViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 02/01/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import UIKit

class ParametersViewController: UIViewController {

    @IBOutlet weak var fiveButton: MyButton!
    @IBOutlet weak var tenButton: MyButton!
    @IBOutlet weak var twentyButton: MyButton!
    @IBOutlet weak var fiftyButton: MyButton!
    
    weak var delegate: GroupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nbCard = UserDefaults.standard.integer(forKey: "NUMBER_CARD")
        switch nbCard {
            case 5:
                selectButton(self.fiveButton)
            case 10:
                selectButton(self.tenButton)
            case 20:
                selectButton(self.twentyButton)
            case 50:
                selectButton(self.fiftyButton)
            default:
                selectButton(self.fiveButton)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func initUI() {
        initButton(self.fiveButton)
        initButton(self.tenButton)
        initButton(self.twentyButton)
        initButton(self.fiftyButton)
    }
    
    func initButton(_ sender: UIButton) {
        sender.backgroundColor = .white
        sender.tintColor = .systemBlue
    }
    
    func selectButton(_ sender: UIButton) {
        sender.backgroundColor = .systemBlue
        sender.tintColor = .white
    }
    
    @IBAction func changeNumberCardButtonTapped(_ sender: UIButton) {
        initUI()
        selectButton(sender)
        UserDefaults.standard.set(Int(sender.titleLabel!.text!), forKey: "NUMBER_CARD")
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let resetAlertview = UIAlertController(title: "Reset", message: "Are you sure to reset the application?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Reset", style: .destructive, handler: { alert in
            self.initUI()
            self.selectButton(self.fiveButton)
            
            CoreDataHelper.shared.deleteAllWord() { error in
                if error != nil { return }
                
                CoreDataHelper.shared.deleteAllGroup() { error in
                    if error != nil { return }
                    self.delegate?.resetArray()
                    UserDefaults.standard.set(5, forKey: "NUMBER_CARD")
                    ToastUtils.shared.displayMessage(view: self,
                                                     message: "Reset successfully !",
                                                     duration: 3.0,
                                                     position: .center)
                }
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        resetAlertview.addAction(okAction)
        resetAlertview.addAction(cancelAction)
        self.present(resetAlertview, animated: true, completion: nil)
    }

}
