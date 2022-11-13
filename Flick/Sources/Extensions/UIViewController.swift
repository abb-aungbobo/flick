//
//  UIViewController.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit

extension UIViewController {
    func showErrorAlert(error: AppError) {
        let alertController = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(dismiss)
        present(alertController, animated: true)
    }
}
