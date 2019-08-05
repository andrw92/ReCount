//
//  Counter.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 7/30/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation

//Un modelo que nos servira para parsear la respuesta del server
struct RemoteCounter: Codable{
    let id: String?
    let title: String?
    let count: Int?
}
