//
//  Sucursales.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 21/10/19.
//  Copyright © 2019 Innovasport-Dispatcher. All rights reserved.
//

import Foundation

class Sucursales {
    
    var _nombre: String!
    var _cantStock: String!
    var _telefono: String!
    var _direccion: String!
    
    var nombre: String {
        return _nombre
    }
    
    var cantStock: String {
        return _cantStock
    }
    
    var telefono: String {
        return _telefono
    }
        
    var direccion: String {
        return _direccion
    }
    
    init(
        nombre: String,
        catnStock: String,
        telefono: String,
        direccion: String
    ) {
        self._nombre = nombre
        self._cantStock = cantStock
        self._telefono = telefono
        self._direccion = direccion
    }
    
}
