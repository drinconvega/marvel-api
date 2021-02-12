//
//  CharacterViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation
import RxSwift
import RxCocoa

class CharacterListViewModel {
    var charactersVM: [CharacterViewModel]
    
    init(_ characters: [Character]) {
        self.charactersVM = characters.compactMap(CharacterViewModel.init)
    }
}

extension CharacterListViewModel {
    
    public func add(_ charactersToAdd: CharacterListViewModel) {
        self.charactersVM.append(contentsOf: charactersToAdd.charactersVM)
    }
    
}

extension CharacterListViewModel {
    
    func characterAt(_ index: Int) -> CharacterViewModel {
        return self.charactersVM[index]
    }
}

class CharacterViewModel {
    
    private let client = APIClient.shared
    private let disposeBag = DisposeBag()
    
    let character: Character
    
    init(_ character: Character) {
        self.character = character
    }
    
}

extension CharacterViewModel {
    
    var id: Observable<String> {
        return Observable<String>.just(String(character.characterId))
    }
    
    var name: Observable<String> {
        return Observable<String>.just(character.name)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(character.description)
    }
    
    var imageURL: Observable<String> {
        return Observable<String>.just(character.thumbnailUrl)
    }
    
    var image: Observable<UIImage?> {
        return Observable<UIImage?>.create { observer in
            do{
                try self.client.getImage(url: self.character.thumbnailUrl).subscribe(onNext: { (image) in
                    observer.onNext(image)
                }).disposed(by: self.disposeBag)
            
            }catch{
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
