//
//  UIViewController.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 27/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import UIKit



extension UIViewController {
    
    /**
        Common function to show error alert
     */
    public func showError(_ str: String) {
        let alertController = UIAlertController(title: "", message: str, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: LocalizedString(key: "movies.actionButton.ok"), style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func didTapNavigationBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
