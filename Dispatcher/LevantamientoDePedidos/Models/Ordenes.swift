//
//  Ordenes.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 29/05/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import Foundation

class Ordenes {
    
    var _numeroOrden: String!
    var _estatus: String!
    
    var numeroOrden: String {
        return _numeroOrden
    }
    
    var estatus: String {
        return _estatus
    }
    
    init(
        numeroOrden: String,
        estatus: String
    ) {
        self._numeroOrden = numeroOrden
        self._estatus = estatus
    }
    
}
