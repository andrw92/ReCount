//
//  RemoteCounterMapper.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 7/30/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation

class RemoteCounterMapper{
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteCounter] {
        guard response.statusCode == 200,
            let items = try? JSONDecoder().decode([RemoteCounter].self, from: data) else {
                throw NetworkError.invalidData
        }
        return items
    }
}

