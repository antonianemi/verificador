//
//  Articulos.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 01/10/19.
//  Copyright © 2019 Innovasport-Dispatcher. All rights reserved.
//

import Foundation

class Articulos {
    
    var _estilo:        String!
    var _nombre:        String!
    var _precio:        String!
    var _talla:         String!
    var _cantidadStock: String!
    var _genero:        String!
    var _escaneado:     Bool!
    var _sku:           String!
    var _articulo:      String!
    var _busqueda:      String!
    
    var estilo: String {
        return _estilo
    }
    
    var nombre: String {
        return _nombre
    }
    
    var precio: String {
        return _precio
    }
    
    var talla: String {
        return _talla
    }
    
    var cantidadStock: String {
        return _cantidadStock
    }
    
    var genero: String {
        return _genero
    }
    
    var escaneado: Bool {
        return _escaneado
    }
    
    var sku: String {
        return _sku
    }
    
    var articulo: String {
        return _articulo
    }
    
    var busqueda: String {
        return _busqueda
    }
    
    init(
        estilo:         String,
        nombre:         String,
        precio:         String,
        talla:          String,
        cantidadStock:  String,
        genero:         String,
        escaneado:      Bool,
        sku:            String,
        articulo:       String,
        busqueda:       String
    ) {
        self._estilo        = estilo
        self._nombre        = nombre
        self._precio        = precio
        self._talla         = talla
        self._cantidadStock = cantidadStock
        self._genero        = genero
        self._escaneado     = escaneado
        self._sku           = sku
        self._articulo      = articulo
        self._busqueda      = busqueda
    }
    
    init(coder aDecoder: NSCoder!) {
        self._estilo = aDecoder.decodeObject(forKey: "Estilo") as? String
        self._nombre = aDecoder.decodeObject(forKey: "Nombre") as? String
        self._precio = aDecoder.decodeObject(forKey: "Precio") as? String
        self._talla  = aDecoder.decodeObject(forKey: "Talla")  as? String
        self._cantidadStock = aDecoder.decodeObject(forKey: "CantidadStock") as? String
        self._genero = aDecoder.decodeObject(forKey: "Genero") as? String
        self._escaneado = aDecoder.decodeObject(forKey: "Escaneado") as? Bool
        self._sku = aDecoder.decodeObject(forKey: "Sku") as? String
        self._articulo = aDecoder.decodeObject(forKey: "Articulo") as? String
        self._busqueda = aDecoder.decodeObject(forKey: "Busqueda") as? String
    }
    
    func initWithCoder(aDecoder: NSCoder) -> Articulos {
        self._estilo = aDecoder.decodeObject(forKey: "Estilo") as? String
        self._nombre = aDecoder.decodeObject(forKey: "Nombre") as? String
        self._precio = aDecoder.decodeObject(forKey: "Precio") as? String
        self._talla  = aDecoder.decodeObject(forKey: "Talla")  as? String
        self._cantidadStock = aDecoder.decodeObject(forKey: "CantidadStock") as? String
        self._genero = aDecoder.decodeObject(forKey: "Genero") as? String
        self._escaneado = aDecoder.decodeObject(forKey: "Escaneado") as? Bool
        self._sku = aDecoder.decodeObject(forKey: "Sku") as? String
        self._articulo = aDecoder.decodeObject(forKey: "Articulo") as? String
        self._busqueda = aDecoder.decodeObject(forKey: "Busqueda") as? String
        return self
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encode(_estilo, forKey:"Estilo")
        aCoder.encode(_nombre, forKey:"Nombre")
        aCoder.encode(_precio, forKey:"Precio")
        aCoder.encode(_talla, forKey:"Talla")
        aCoder.encode(_cantidadStock, forKey:"CantidadStock")
        aCoder.encode(_genero, forKey:"Genero")
        aCoder.encode(_escaneado, forKey:"Escaneado")
        aCoder.encode(_sku, forKey:"Sku")
        aCoder.encode(_articulo, forKey:"Articulo")
        aCoder.encode(_busqueda, forKey:"Busqueda")
    }
}
