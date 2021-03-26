//
//  LoginApi.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 07/02/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginAPI {
    
    let restApi = RestAPI()
    private let prot = "https://"
    
    //QA
    //URLS
    private let urlAWSQA = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
    private let urlIniciarSesionQA = "https://gbn468tozl.execute-api.us-west-2.amazonaws.com"
    private let urlSucursalUsuarioQA = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
    
    //Servicios
    private let servicioLoginQA = "qa/signin"
    private let servicioSucursalUsuarioQA = "qa/sucursal/employee"
    
    //PROD
    //URLS
    private let urlAWSProd = "https://nz2ft7pnyk.execute-api.us-west-2.amazonaws.com"
    private let urlIniciarSesionProd = "https://4fg4czyw5k.execute-api.us-west-2.amazonaws.com"
    private let urlSucursalUsuarioProd = "https://nz2ft7pnyk.execute-api.us-west-2.amazonaws.com"
    
    //Servicios
    private let servicioLoginProd = "prd/signin"
    private let servicioSucursalUsuarioProd = "pre-prd/sucursal/employee"
    
    
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
        case 3:
            let ligaInicioSesion = self.restApi.ambiente == 0 ? "\(urlIniciarSesionQA)" : "\(urlIniciarSesionProd)"
            return ligaInicioSesion
        case 4:
            let ligaSucursalUsuario = self.restApi.ambiente == 0 ? "\(urlSucursalUsuarioQA)" : "\(urlSucursalUsuarioProd)"
            return ligaSucursalUsuario
        default:
            //for complete link only
            return ""
        }
    }
    
    func login(employeeNumber:String, password:String, completion: @escaping (_ response: JSON, _ statusCode: Int) -> ()){
            
        let poolId = self.restApi.ambiente == 0 ? self.restApi.userPoolIdQA : self.restApi.userPoolIdProd
        let clientID = self.restApi.ambiente == 0 ? self.restApi.clientIdQA : self.restApi.clientIdProd
            
            let params = [
                "username":employeeNumber,
                "password": password,
    //            "idAplicacion":"74",
                "user_pool_id": poolId,
                "client_id": clientID
            ] as Parameters
        
            let json = JSON(arrayLiteral: [
                "username":employeeNumber,
                "password": password,
    //            "idAplicacion":"74",
                "user_pool_id": poolId,
                "client_id": clientID
            ])
        
            print(json)
            
            let servicio = self.restApi.ambiente == 0 ? self.servicioLoginQA : self.servicioLoginProd
            
            self.restApi.generalRequest(urlComposer(path: servicio, server: 3), method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
                completion(response, statusCode)
            }
    }
    
    func getSucursalDeUsuario(usuario:String, completion: @escaping (_ response: JSON, _ statusCode: Int) -> ()){
        
        let params = [
            "numEmpleado": "\(usuario)"
        ] as Parameters
        
        let servicio = self.restApi.ambiente == 0 ? self.servicioSucursalUsuarioQA : self.servicioSucursalUsuarioProd
        
        self.restApi.generalRequestConAutorizacion(urlComposer(path: servicio, server: 4), method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
            completion(response, statusCode)
        }
    }
    
    func getPerfilUsuario(accessToken:String, completion: @escaping (_ response:JSON, _ statusCode: Int) -> ()){
        
        let params = [
            "access_token": "\(accessToken)"
        ] as Parameters
        
        let servicio = self.restApi.ambiente == 0 ? "https://gbn468tozl.execute-api.us-west-2.amazonaws.com/qa/getuserprofile" : "https://4fg4czyw5k.execute-api.us-west-2.amazonaws.com/prd/getuserprofile"
        
        self.restApi.generalRequestConAutorizacion(servicio, method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
            completion(response, statusCode)
        }
        
    }
    
    func test(completion: @escaping (_ response: JSON, _ statusCode: Int) -> ()){
        
        let params = [
            "operation-type": 2,
            "IWA_ESTRUCTURA": [
              "SUMA": 1,
              "RESTA": 2,
              "MULT": 3,
              "DIV": 4,
              "CADENA": "String 5",
              "FLOTANTE": 0.62,
              "ENTERO": 8
            ],
            "OPERADOR": "+",
            "VARIABLE1": 10,
            "VARIABLE2": 11,
            "EIT_TABLE": [
              [
                "SUMA": 12,
                "RESTA": 13,
                "MULT": 14,
                "DIV": 15,
                "CADENA": "String 16",
                "FLOTANTE": 170,
                "ENTERO": 19
              ],
              [
                "SUMA": 20,
                "RESTA": 21,
                "MULT": 22,
                "DIV": 23,
                "CADENA": "String 24",
                "FLOTANTE": 0.251,
                "ENTERO": 27
              ]
            ]
        ] as Parameters
        
        let servicio = "https://nkbv89h18e.execute-api.us-west-2.amazonaws.com/dev/sap/picking/genericinterface"
        
        self.restApi.generalRequest(servicio, method: .post, parameters: params, encoding: JSONEncoding.default, xApiKey: "") { (jsonResponse, StatusCode) in
            completion(jsonResponse, StatusCode)
        }
        
//        self.restApi.generalRequestConAutorizacion(urlComposer(path: servicio, server: 4), method: .post, parameters: params, encoding: JSONEncoding.default) { response, statusCode in
//            completion(response, statusCode)
//        }
        
    }
    
}
