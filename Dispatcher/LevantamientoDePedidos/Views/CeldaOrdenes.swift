//
//  CeldaOrdenes.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 29/05/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import UIKit

class CeldaOrdenes: UICollectionViewCell {
 
    @IBOutlet weak var etiquetaNumeroOrden:UILabel!
    @IBOutlet weak var etiquetaEstatus:UILabel!
    
    var orden: Ordenes!
    
    func configuraCelda(bloqueOrden:Ordenes){
        self.orden = bloqueOrden
        self.etiquetaNumeroOrden.text = bloqueOrden.numeroOrden
        self.etiquetaEstatus.text = bloqueOrden.estatus
    }
    
}
