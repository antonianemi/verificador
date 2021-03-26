//
//  LevantamientoDePedidosAPI.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 07/02/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LevantamientoDePedidosAPI {
    
    private let prot = "https://"
    
    let restAPI = RestAPI()
    
    //QA
    //URLS
    private let urlAWSQA = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
    private let urlIniciarSesionQA = "https://gbn468tozl.execute-api.us-west-2.amazonaws.com"
    private let urlSucursalesQA = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
    private let urlSucursalUsuarioQA = "https://oj30fwwz9l.execute-api.us-west-2.amazonaws.com"
    
    //Servicios
    private let servicioLoginQA = "qa/signin"
    private let servicioSucursalesXZonaQA = "qa/products/getStockByStoreZone"
    private let servicioPedidoQA = "qa/orders/create"
    private let servicioDataProductoQA = "qa/products/getProduct"
    private let servicioNegadosQA = "qa/products/insertaNegado"
    private let servicioSucursalUsuarioQA = "qa/sucursal/employee"
    
    //PROD
    //URLS
    private let urlAWSProd = "https://nz2ft7pnyk.execute-api.us-west-2.amazonaws.com"
    private let urlIniciarSesionProd = "https://4fg4czyw5k.execute-api.us-west-2.amazonaws.com"
    private let urlSucursalesProd = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
    private let urlSucursalUsuarioProd = "https://te3gamqjag.execute-api.us-west-2.amazonaws.com"
    
    //Servicios
    private let servicioLoginProd = "prd/signin"
    private let servicioSucursalesXZonaProd = "pre-prd/products/getstockskubystore"
    private let servicioPedidoProd = "pre-prd/orders/create"
    private let servicioDataProductoProd = "pre-prd/products/getproduct"
    private let servicioNegadosProd = "pre-prd/products/insertanegado"
    private let servicioSucursalUsuarioProd = "pre_prd/sucursal/employee"
    
    private func urlComposer(path: String, server:Int) -> String {
        
        let myServerPath:String = serverPath(server: server)
        
        let liga = server == 0 ? path : "\(myServerPath)/\(path)"
        
        return liga

    }
    
    public func getProtocolServer() -> String {
        return "\(prot)"
    }
    
    public func serverPath(server:Int) -> String {
//            let protocolServer:String = getProtocolServer()
        switch server {
        case 1:
    //            return "\(protocolServer)://\(urlAWS):\(port)"
            let ligaAws = self.restAPI.ambiente == 0 ? "\(urlAWSQA)" : "\(urlAWSProd)"
            return ligaAws
            
        case 2:
            let ligaSucursales = self.restAPI.ambiente == 0 ? "\(urlSucursalesQA)" : "\(urlSucursalesProd)"
            return ligaSucursales
        default:
            //for complete link only
            return ""
        }
    }
    
    func reportaNegado(busqueda:String, sku:String, pedidoId:String, estilo:String, talla:String, cantidad:String, tipoNegado:String, completion: @escaping (_ response: JSON, _ statusCode: Int) -> ()){
        
        let params = [
            "PedidoId": pedidoId,
            "Busqueda" : busqueda,
            "SkuSAP" : sku,
            "Estilo": estilo,
            "Talla": talla,
            "Cantidad": cantidad,
            "TipoNegadoId": tipoNegado
        ] as Parameters
        
        let servicio = self.restAPI.ambiente == 0 ? self.servicioNegadosQA : self.servicioNegadosProd
        
        self.restAPI.generalRequestConAutorizacion(urlComposer(path: servicio, server: 1), method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
            completion(response, statusCode)
        }
    }
    
    func getSucursalesStockPorZona(tienda:String, skuSap:String, completion: @escaping (_ response: JSON, _ statusCode: Int) -> ()){
        
        let params = [
        "tienda": tienda,
        "skuSap": "\(skuSap)"
        ] as Parameters
        
        let servicio = self.restAPI.ambiente == 0 ? self.servicioSucursalesXZonaQA : self.servicioSucursalesXZonaProd
        
        self.restAPI.generalRequestConAutorizacion(urlComposer(path: servicio, server: 1), method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
            completion(response, statusCode)
        }
        
    }
    
    func getProductData(tienda:String, sku:String, estilo:String, completion: @escaping (_ response: JSON, _ statusCode: Int) -> ()){
        
        var skuNuevo = 0
        var stringSku = ""
        
        if sku.isInt {
            skuNuevo = Int(sku)!
            stringSku = "\(skuNuevo)"
        }else {
            stringSku = sku
        }

        let params = [
            "tienda": tienda,
            "sku": stringSku,
            "estilo":stringSku,
            "EANUPC": stringSku
            ] as Parameters
        
        let servicio = self.restAPI.ambiente == 0 ? self.servicioDataProductoQA : self.servicioDataProductoProd
        
        self.restAPI.generalRequestConAutorizacion(urlComposer(path: servicio, server: 1), method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
            completion(response, statusCode)
        }
        
    }
    
    func getProcesoPedido(producto:Dictionary<String, Any>, tipoAlta:Int, pedidoId:String, asesor:String, tienda:String, completion: @escaping (_ response: JSON, _ statusCode: Int) -> ()){
        
        let params = [
            "TipoAlta": tipoAlta,
            "TicketId": pedidoId,
            "Asesor": asesor,
            "TiendaId": tienda
        ] as Parameters
        
        let servicio = self.restAPI.ambiente == 0 ? self.servicioPedidoQA : self.servicioPedidoProd
        
        self.restAPI.generalRequestConAutorizacion(urlComposer(path: servicio, server: 1), method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
            completion(response, statusCode)
        }
        
    }
    
}
