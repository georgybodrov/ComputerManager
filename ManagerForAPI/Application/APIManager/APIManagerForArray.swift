//
//  APIManagerForArray.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 15.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation

/*

protocol APIManagerForSimilarComputer {
    var sessionConfiguration: URLSessionConfiguration { get } //Конфигурация сессии. Свойство, которое мы должны будем реализовать
    var session: URLSession { get } //Создаём сессию на основе sessionConfiguration
    
    //Ниже написаны 2 метода, которы позволяют получить данные
    
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> Array<T>?, completionHandler: @escaping (APIResult<T>) -> Void)
    
}

//Когда подписываемся под протокол с расширением, то получаемся дефолтную реализацию из расширения
extension APIManagerForSimilarComputer {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        print("-------------")
        print("start test download SC")
        print("-------------")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            //Проверяем пришли ли данные в формате HTTP
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: GEONetworkingErrorDomain, code: 100, userInfo: userInfo)
                
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> Array<T>?, completionHandler: @escaping (APIResult<Array<T>>) -> Void) {
        
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async(execute: {
                guard let json = json else {
                    if let error = error {
                        completionHandler(.Failure(error))
                    }
                    return
                }
                
                if let value = parse(json) {
                    completionHandler(.Success(value))
                } else {
                    let error = NSError(domain: GEONetworkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(.Failure(error))
                }
                
            })
        }
        dataTask.resume()
    }
    
}

*/


