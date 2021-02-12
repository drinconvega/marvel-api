//
//  GetImageRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 12/02/2021.
//

import Foundation

class GetImageRequest: APIRequest {
    var method = RequestType.GET
    var path = ""
    var parameters = [String: String]()

    init() {}
}
