//
//  GetCharacterUseCase.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation

class GetCharacterRequest: APIRequest {
    var method = RequestType.GET
    var path = "characters/"
    var parameters = [String: String]()

    init(id: String) {
        path = self.path + id
    }
}
