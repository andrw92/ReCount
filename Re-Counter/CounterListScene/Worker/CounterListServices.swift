//
//  CounterListServices.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 7/30/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation

enum CounterListServices: ServiceRequest{
    
    case get
    case create(title: String)
    case increment(id: String)
    case decrement(id: String)
    case delete(id: String)
    
    var path: String{
        switch self {
        case .get:
            return "/api/v1/counters"
        case .create, .delete:
            return "/api/v1/counter"
        case .increment:
            return "/api/v1/counter/inc"
        case .decrement:
            return "/api/v1/counter/dec"
        }
    }
    
    var method: HTTPMethods{
        switch self {
        case .get:
            return .get
        case .create, .increment, .decrement:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var headers: [String : String]?{
        return ["Content-Type":"application/json",
                "Accept": "application/json"]
    }
    
    var bodyParams: [String : Any]?{
        switch self {
        case .create(let title):
            return ["title":title]
        case .delete(let id), .decrement(let id), .increment(let id):
            return [ "id":id ]
        case .get:
            return nil
        }
    }
    
    var urlQueryParams: [String : Any]?{
        return nil
    }
    
}
