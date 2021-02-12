//
//  ListTableViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation
import UIKit
import RxSwift

private let defaultLimit = 100

class ListTableViewController: UITableViewController {
    
    private let client = APIClient.shared
    private let disposeBag = DisposeBag()
    
    var loadIndicator: UIActivityIndicatorView?
    var loadMoreIndicator: UIActivityIndicatorView?
    private var page = Page(limit: defaultLimit, offset: 0)
    private var characterListViewModelVM: CharacterListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.loadIndicator = UIActivityIndicatorView()
        self.loadMoreIndicator = UIActivityIndicatorView()

        self.tableView.backgroundView = self.loadIndicator
        self.tableView.tableFooterView = self.loadMoreIndicator
        
        populateCharacters()
    }
    
}
extension ListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.characterListViewModelVM == nil ? 0: self.characterListViewModelVM.charactersVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTitleCell", for: indexPath) as? ImageTitleCell else {
            fatalError("ImageTitleCell is not found")
        }
        
        let characterVM = self.characterListViewModelVM.characterAt(indexPath.row)
        
        characterVM.name.asDriver(onErrorJustReturn: "")
        .drive(cell.titleLabel.rx.text)
        .disposed(by: disposeBag)
        
        characterVM.image.asDriver(onErrorJustReturn: UIImage(named: "character_default"))
        .drive(cell.leftImageView.rx.image)
        .disposed(by: disposeBag)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CharacterViewController") as! CharacterViewController
        viewController.characterViewModelVM = self.characterListViewModelVM.characterAt(indexPath.row)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            self.page.offset+=defaultLimit
            self.populateCharacters()
        }
    }
}

extension ListTableViewController {
    private func populateCharacters() {
        do{
            self.loadIndicator?.startAnimating()
            try client.getCharacters(page: page).subscribe(
                onNext: { characterResponse in
                    
                    if let _ = self.characterListViewModelVM {
                        let characters = CharacterListViewModel(characterResponse)
                        self.characterListViewModelVM.add(characters)
                    }else{
                        self.characterListViewModelVM = CharacterListViewModel(characterResponse)
                    }
                    
                    DispatchQueue.main.async {
                        self.loadIndicator?.stopAnimating()
                        self.tableView.reloadData()
                    }
                },
                onError: { error in
                    self.loadIndicator?.stopAnimating()
                    self.showErrorDefault()
                    print(error.localizedDescription)
                },
                onCompleted: {
                    print("Completed event.")
                }).disposed(by: disposeBag)
        }
        catch{}
    }
}

extension ListTableViewController {
    private func showErrorDefault() {
        let alert = UIAlertController(title: "Error", message: "An error has ocurred, please try again later", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
