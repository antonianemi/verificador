//
//  AmazonAPIS3.swift
//  Dispatcher
//
//  Created by Innovasport on 12/10/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AmazonAPIS3 {
    
    let restAPI = RestAPI()
    private let prot = "https://"
    
    let ligaQACredencialesS3 = "https://gbn468tozl.execute-api.us-west-2.amazonaws.com"
    let servicioCredencialesS3 = "qa/getcredentials"
    
    private func urlComposer(path: String, server:Int) -> String {
            
        let myServerPath:String = serverPath(server: server)
        
        let liga = server == 0 ? path : "\(myServerPath)/\(path)"
        
        return liga

    }
    
    public func getProtocolServer() -> String {
        return "\(prot)"
    }
    
    public func serverPath(server:Int) -> String {
//        let protocolServer:String = getProtocolServer()
        switch server {
        case 1:
            let ligaGeneral = self.restAPI.ambiente == 0 ? "\(ligaQACredencialesS3)" : "\(ligaQACredencialesS3)"
            return ligaGeneral
        default:
            //for complete link only
            return ""
        }
    }
    
    func peticionDeCredencialesS3(
        encodedFile:String,
        pedido:String,
        completion: @escaping (_ response:JSON, _ statusCode: Int) -> () )
    {
        
        let fechaHoy = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        let diaStr = "\(fechaHoy.day!)".count == 1 ? "0\(fechaHoy.day!)" : "\(fechaHoy.day!)"
        let mesStr = "\(fechaHoy.month!)".count == 1 ? "0\(fechaHoy.month!)" : "\(fechaHoy.month!)"
        let yearStr = "\(fechaHoy.year!)"
        
        let params = [
          "acuse" : encodedFile,
          "año": yearStr,
          "mes":mesStr,
          "nombre": "Acuse\(pedido).pdf",
          "dia": diaStr
        ]
        
        let servicio = self.restAPI.ambiente == 0 ? "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com/dev/receipts/uploadpdf" : "https://nz2ft7pnyk.execute-api.us-west-2.amazonaws.com/pre-prd/receipts/uploadpdf"
        
        self.restAPI.generalRequestConAutorizacion(servicio, method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
            completion(response, statusCode)
        }
    }
    
}
