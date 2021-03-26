//
//  CeldaArticulos.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 02/10/19.
//  Copyright © 2019 Innovasport-Dispatcher. All rights reserved.
//

import UIKit

class CeldaArticulos: UITableViewCell {
    
    @IBOutlet weak var nombreArticuloLbl:UILabel!
    @IBOutlet weak var precioArticuloLbl:UILabel!
    @IBOutlet weak var vistaPickeo:UIView!
    @IBOutlet weak var tallaArticuloLbl:UILabel!
    
    let articulo = [Articulos]()
    
    func configuraCelda(article:Articulos){
        
        self.nombreArticuloLbl.text = article.nombre
        self.precioArticuloLbl.text = "$\(article.precio)"
        self.tallaArticuloLbl.text = article.talla
        if article.escaneado == true {
            self.vistaPickeo.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        }else{
            self.vistaPickeo.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }
    
}
