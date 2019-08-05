//
//  RemoteCounterListLoader.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 7/30/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation

//Implementacion del loader para obtener info de la nube
class RemoteCounterListLoader: CounterListLoader{
    
    private let enviroment: Enviroment
    private let client: HTTPClient
    
    typealias Result = CounterListLoader.Result
    
    init(enviroment: Enviroment = Enviroment(), client: HTTPClient){
        self.enviroment = enviroment
        self.client = client
    }
    
    func get(completion: @escaping(Result)-> Void){
        let service = CounterListServices.get
        executeRequest(with: service, completion: completion)
    }
    
    func create(title: String, completion: @escaping (Result) -> Void) {
        let service = CounterListServices.create(title: title)
        executeRequest(with: service, completion: completion)
    }
    
    func delete(counterId: String, completion: @escaping (Result) -> Void) {
        let service = CounterListServices.delete(id: counterId)
        executeRequest(with: service, completion: completion)
    }
    
    func increment(counterId: String, completion: @escaping (Result) -> Void) {
        let service = CounterListServices.increment(id: counterId)
        executeRequest(with: service, completion: completion)
    }
    
    func decrement(counterId: String, completion: @escaping (Result) -> Void) {
        let service = CounterListServices.decrement(id: counterId)
        executeRequest(with: service, completion: completion)
    }
    
    private func executeRequest(with service: ServiceRequest, completion: @escaping (Result)->Void){
        
        let request = URLRequest.init(service: service, enviroment: enviroment)
        client.executeRequest(request: request) { [weak self] result in
            guard self != nil else { return }
            switch result{
            case let .success(data, response):
                completion(RemoteCounterListLoader.map(data, from: response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
      
        do {
            let items = try RemoteCounterMapper.map(data, from: response)
          
            if items.containsNil(){
                return .failure(NetworkError.invalidData)
            }
           
            return .success(items.toModels())
       
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteCounter {
    
    func containsNil()-> Bool{
        for element in self{
            if element.count == nil { return true }
            if element.title == nil { return true }
            if element.id == nil { return true }
        }
        return false
    }
    
    func toModels() -> [Counter] {
        return map{
            Counter(id: $0.id!, title: $0.title!, count: $0.count!)
        }
    }
}
