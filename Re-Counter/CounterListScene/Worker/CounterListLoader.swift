//
//  CounterLoader.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 7/30/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation


//Interfaz generica, en algún punto se puede incluir un loader que se alimente de otra manera, por ejemplo de core data.
protocol CounterListLoader {
    
    typealias Result = Swift.Result< [Counter], Error>
    
    func get(completion: @escaping(Result) -> Void)
    func create(title: String, completion: @escaping (Result) -> Void)
    func delete(counterId: String, completion: @escaping (Result) -> Void)
    func increment(counterId: String, completion: @escaping (Result) -> Void)
    func decrement(counterId: String, completion: @escaping (Result) -> Void)
}
