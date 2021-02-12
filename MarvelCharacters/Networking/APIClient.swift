//
//  APIClient.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation
import RxCocoa
import RxSwift

class APIClient {
    static var shared = APIClient()
    private let baseURL = URL(string: "https://gateway.marvel.com:443/v1/public/")!
    
    lazy var requestObservable = RequestObservable(config: .default)
    
    func getCharacters(page: Page) throws -> Observable<[Character]> {
        let reqObj = GetCharactersRequest()
        reqObj.parameters["limit"] = String(page.limit)
        reqObj.parameters["offset"] = String(page.offset)
        let request = reqObj.request(with: self.baseURL, securityParams: true)
        return requestObservable.callAPI(request: request)
    }
    
    func getCharacter(id: String) throws -> Observable<Character> {
        let request = GetCharacterRequest(id: id).request(with: self.baseURL, securityParams: true)
        return requestObservable.callAPI(request: request)
    }
    
    func getImage(url: String) throws -> Observable<UIImage?> {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.GET.rawValue
        return requestObservable.getImage(request: request)
    }
    
}
