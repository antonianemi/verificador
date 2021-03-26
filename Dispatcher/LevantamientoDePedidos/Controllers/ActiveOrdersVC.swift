//
//  ActiveOrdersVC.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 29/05/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON

protocol protocoloOrdenes {
    func ordenSeleccionada(orden:Ordenes, proceso:Int)
}

class ActiveOrdersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var coleccionOrdenes:UICollectionView!
    
    private let manager = CoreDataManager()
    
    var arregloOrdenes = [Ordenes]()
    
    var delegadoOrdenes: protocoloOrdenes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orders = manager.getOrders()
        
        for order in orders {
            let orderNumber = order.orderNumber!
            let orderStatus = order.orderStatus!
            let orderObject = Ordenes(numeroOrden: orderNumber, estatus: orderStatus)
            self.arregloOrdenes.append(orderObject)
        }

        self.coleccionOrdenes.delegate = self
        self.coleccionOrdenes.dataSource = self
    }
    
    // MARK: CollectionView Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arregloOrdenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let orden = arregloOrdenes[indexPath.row]
        
        let cell = self.coleccionOrdenes.dequeueReusableCell(withReuseIdentifier: "celdaOrdenes", for: indexPath) as! CeldaOrdenes
        
        cell.configuraCelda(bloqueOrden: orden)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ordenSeleccionada = self.arregloOrdenes[indexPath.row]
        self.delegadoOrdenes?.ordenSeleccionada(orden: ordenSeleccionada, proceso:1)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 350, height: 116)
    }
    
    // MARK: Action buttons

    @IBAction func newOrderBtnPressed(_ sender:Any){
        
        let levantamientosApi = LevantamientoDePedidosAPI()
        let metodosGlobales = LevantamientoPedidosGlobales()
        let defaults = UserDefaults.standard
        
        let empleado:String = (defaults.value(forKey: "employee_number") as? String)!
        let tienda = defaults.value(forKey: "sucursalEscaneada") as! String
        
        let dict: Dictionary<String,Any> = [:]
        
        levantamientosApi.getProcesoPedido(producto:dict, tipoAlta: 1, pedidoId: "1", asesor: empleado, tienda: tienda ) { (jsonResponse, statusCode) in

            switch(statusCode){
            case 200 :
                let contenido = jsonResponse["content"]
                self.iteraNumeroPedido(contenido: contenido)
                SCLAlertView().showNotice("Paso 1", subTitle: "Escanea etiqueta de producto ó ingresa el estilo manualmente.")
            case 403 :
                SCLAlertView().showError("No cuentas con permiso para consultar esta función.", subTitle: "")
            case 401 :
                metodosGlobales.refrescaToken { (result) in
                    switch result {
                    case 1:
                        SCLAlertView().showWarning("Sesión actualizada, por favor inténtelo nuevamente.", subTitle: "")
                        break;
                    case 2:
                        SCLAlertView().showError("Ocurrió un error al consultar cognito", subTitle: "")
                        break;
                    case 3:
                        SCLAlertView().showError("No se encontraron valores en esta función", subTitle: "")
                        break;
                    default :
                        SCLAlertView().showError("", subTitle: "Obtuviste el siguiente código \(result), por favor reportalo al administrador del sistema.")
                    }
                }
            default:
                print("Obtuve el siguiente status code : \(statusCode)")
            }
        }
        
    }
    
    @IBAction func refreshOrdersInformationBtnPressed(_ sender:Any){
        
    }
    
    func iteraNumeroPedido(contenido:JSON){
            print(contenido)
            if let data = contenido.description.data(using: String.Encoding.utf8) {
                do {
                    let diccionario = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                
                    if let valores = diccionario
                    {
                        let numeroPedido:String = "\(valores["PEDIDO"]!)"
                        let orden = Ordenes(numeroOrden: numeroPedido, estatus: "En Proceso")
                        self.delegadoOrdenes?.ordenSeleccionada(orden: orden, proceso:2)
                        self.dismiss(animated: true, completion: nil)
                        
                    }else{
                        SCLAlertView().showError("Ocurrió un error al obtener el contenido del contador pedidos.", subTitle: "")
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            }
    }
}
