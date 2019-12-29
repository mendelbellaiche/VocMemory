//
//  ToastUtils.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

class ToastUtils {
    
    static let shared = ToastUtils()
    
     private init() {}
    
    func displayMessage(view: UIViewController, message: String, duration: Double, position: ToastPosition) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .darkGray
        style.verticalPadding = 15
        view.view.makeToast(message, duration: duration, position: position, style: style)
    }
    
    func hideMessage(view: UIViewController) {
        view.view.hideToast()
    }
    
}
