//
//  String+Extensions.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation
import CryptoKit

public extension String {
    
    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
}
