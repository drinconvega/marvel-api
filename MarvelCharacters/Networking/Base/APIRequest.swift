//
//  APIRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension APIRequest {
    func request(with baseURL: URL, securityParams: Bool = false) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        if securityParams{
            let defaultParams = self.addDefaultParams()
            components.queryItems = defaultParams.map {
                URLQueryItem(name: String($0), value: String($1))
            }
            
            components.queryItems! += parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }else{
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }
        
        
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func addDefaultParams() -> [String: String]{
        var parameters = [String: String]()
        let privateKey = "60852357c65f202c413098ea1a573eb9c844cb4e"
        let apiKey = "2c03d3e9f4f7486a887411243f43261e"
        let timestamp = String(Date().timeIntervalSince1970)
        
        let hash = String.MD5(string: (timestamp + privateKey + apiKey))
        
        parameters["apikey"] = apiKey
        parameters["ts"] = timestamp
        parameters["hash"] = hash
        
        return parameters
    }
}
