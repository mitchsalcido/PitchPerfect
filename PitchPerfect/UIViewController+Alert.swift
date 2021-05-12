//
//  UIViewController+Alert.swift
//  PitchPerfect
//
//  Created by 1203 Broadway on 5/11/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ error: LocalizedError) {
        
        let alert = UIAlertController(title: error.errorDescription,
                                      message: error.failureReason,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: error.recoverySuggestion, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
