//
//  CharacterViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation
import UIKit
import RxSwift


class CharacterViewController: BaseViewController {
    
    @IBOutlet weak var detailImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    public var characterViewModelVM: CharacterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.characterViewModelVM.name.asDriver(onErrorJustReturn: "")
        .drive(nameLabel.rx.text)
        .disposed(by: disposeBag)
        
        self.characterViewModelVM.description.asDriver(onErrorJustReturn: "")
        .drive(descriptionTextField.rx.text)
        .disposed(by: disposeBag)
        
        self.characterViewModelVM.image.asDriver(onErrorJustReturn: UIImage(named: "character_default"))
        .drive(detailImgView.rx.image)
        .disposed(by: disposeBag)
    }
}
