//
//  SortOptions.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/3/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation

//Tambien se puede anidar un enum privado que tenga los titulos y retornar una propiedad computada llamada title, pero para mantenerlo simple asigné directamente el titulo al rawValue del enum
enum SortOptionsForCounterList: String, CaseIterable{

    case countDescending = "Higher count value"
    case countAscending = "Lower count value"
    case titleAscending = "Title from A to Z"
    case titleDescending = "Title from Z to A"

}
