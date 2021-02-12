//
//  BaseViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 12/02/2021.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let client = APIClient.shared
    let disposeBag = DisposeBag()
    
    
    private func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorDefault() {
        let alert = UIAlertController(title: "Error", message: "An error has ocurred, please try again later", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
