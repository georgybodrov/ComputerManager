//
//  APIManager.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 25.09.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

/*
 Интерфейс для работы с сетью
 */


import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

protocol JSONDecodable {
    init?(JSON: [String: Any])
}

protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

//Когда подписываемся под протокол, обязуемся выполнить все его методы и св-ва
protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get } //Конфигурация сессии. Свойство, которое мы должны будем реализовать
    var session: URLSession { get } //Создаём сессию на основе sessionConfiguration
    
    //Ниже написаны 2 метода, которы позволяют получить данные
    // 1. Вызываем метод fetch
    //    2. Передаём в него запрос "request"
    //    3. Затем запрос попадает внутрь функции "JSONTaskWith"
    //    4. В "JSONTaskWith" срабатывает "completionHandler"
    //    5. По завершении которого мы получаем ([String: AnyObject]?, HTTPURLResponse?, Error?)
    //    6. Затем мы пытаемся преобразавать полученные данные в формат <T> в "parse"(у "fetch")
    //    7. Если это удаётся, то срабатывает "completionHandler"(у "fetch"), который в свою очередь передаёт либо ошибку, либо текущий экземпляр нашего ответа или ошибку
    
    
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
    
}

//Когда подписываемся под протокол с расширением, то получаемся дефолтную реализацию из расширения
extension APIManager {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        
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
    
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        
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
