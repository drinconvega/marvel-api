//
//  Request.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation
import RxSwift
import RxCocoa
import JSONDecoder_Keypath

public class RequestObservable {
    private lazy var decoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration:
                                    URLSessionConfiguration.default)
    }
    //MARK: function for URLSession takes
    public func callAPI<ItemModel: Decodable>(request: URLRequest) -> Observable<ItemModel> {
        return Observable.create { observer in
            //create URLSession dataTask
            let task = self.urlSession.dataTask(with: request) { (data,
                                                                  response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            //getting our data from response
                            let items = try self.decoder.decode(ItemModel.self, from: _data, keyPath: "data.results")
                            observer.onNext(items)
                            
                        }else {
                            if error != nil{
                                observer.onError(error!)
                            }else{
                                let error = self.parseError(data: data)
                                observer.onError(error)
                            }
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    public func getImage(request: URLRequest) -> Observable<UIImage?> {
        return Observable.create { observer in
            let task = self.urlSession.dataTask(with: request) { (data,
                                                                  response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let image = UIImage(data: _data)
                            observer.onNext(image)
                            
                        }else {
                            if error != nil{
                                observer.onError(error!)
                            }else{
                                let error = self.parseError(data: data)
                                observer.onError(error)
                            }
                        }
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func parseError(data: Data?) -> Error {
        if let data = data, let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []){
            let errorDict = (jsonArray as? [String:AnyObject])!
            var message = ""
            
            message = (errorDict["message"] ?? errorDict["status"]) as! String
            
            return ErrorResponseModel(message: message, code: "")
        }
        return ErrorResponseModel(message: "Cannot parse error", code: "")
    }
    
}

