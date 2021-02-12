//
//  ErrorResponse.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 12/02/2021.
//

import Foundation

struct ErrorResponseModel : Error {
    var message : String
    var code : String
}

extension ErrorResponseModel: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}
