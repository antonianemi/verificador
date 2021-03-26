//
//  RestApi.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 12/09/19.
//  Copyright © 2019 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class RestAPI {
    
    //MARK: Variable que determina los ambientes en la app
    let ambiente = 0
    
    //Parametros de cognito QA
    let userPoolIdQA = "us-west-2_fzjOLj9au"
    let clientIdQA = "4mr2tc5tdc1qigqs5ajsn4cik1"
    //Parametros de cognito Prod
    let userPoolIdProd = "us-west-2_uHLSTGQuE"
    let clientIdProd = "q3h9k1vnfdqnj5geoln5klcom"

    private let port = "8282"                                   //Production 8084 / Test 8083
    private typealias JSONStandard = [String: AnyObject]
    
    func generalRequestConAutorizacionEspecial(_ uri: String, method: HTTPMethod? = .get, parameters: Parameters? = [:], encoding: ParameterEncoding? = URLEncoding.default, xApiKey: String = "", completion: @escaping (_ responseValue: JSON, _ statusCode: Int) -> ()){
        
        let tokenId = UserDefaults.standard.string(forKey: "token_id")!
        
        var headers: HTTPHeaders = ["Accept": "application/json, text/plain, */*",
                                    "Accept-Encoding": "gzip, deflate, sdch, br",
                                    "Accept-Language": "es-ES,es;q=0.8",
                                    "Cache-Control":"no-cache",
                                    "Connection": "keep-alive",
                                    "Pragma" : "no-cache",
                                    "Authorization": tokenId]
        
        if (!(parameters?.isEmpty)!) {
            headers["Content-Type"] = "application/json"
        }
        
        var alamoFireManager : SessionManager?
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        
        alamoFireManager!.request(uri, method: method!, parameters: parameters!, encoding: encoding!, headers: headers).responseJSON { (responseData) -> Void in
            
            let statusCode = responseData.response != nil ? responseData.response!.statusCode : 0
            
             if ((responseData.result.value) != nil) {
                let responseValue = JSON(responseData.result.value!)
                completion(responseValue, statusCode)
            } else {
                switch statusCode{
                case 204:
                    let errors = ["errors" : ["No data received"]]
                    let responseValue = JSON(errors)
                    let errorsString = String(describing: responseValue["errors"][0])
                    print("Received a: \(errorsString)")
                    completion(responseValue, statusCode)
                default:
                    let errors = ["errors" : ["Can't reach server, verify your internet connection"]]
                    let responseValue = JSON(errors)
                    let errorsString = String(describing: responseValue["errors"][0])
                    print("Received a: \(errorsString)")
                    completion(responseValue, statusCode)
                }
            }
        }
        
    }

    
    func generalRequestConAutorizacion(_ uri: String, method: HTTPMethod? = .get, parameters: Parameters? = [:], encoding: ParameterEncoding? = URLEncoding.default, xApiKey: String = "", completion: @escaping (_ responseValue: JSON, _ statusCode: Int) -> ()) {
        
        let tokenId = UserDefaults.standard.string(forKey: "token_id")!
        
        var headers: HTTPHeaders = ["Accept": "application/json, text/plain, */*",
                                    "Accept-Encoding": "gzip, deflate, sdch, br",
                                    "Accept-Language": "es-ES,es;q=0.8",
                                    "Cache-Control":"no-cache",
                                    "Connection": "keep-alive",
                                    "Pragma" : "no-cache",
                                    "Authorization": tokenId]
        
        if (!(parameters?.isEmpty)!) {
            headers["Content-Type"] = "application/json"
        }
        
        Alamofire.request(uri, method: method!, parameters: parameters!, encoding: encoding!, headers: headers).responseJSON { (responseData) -> Void in
            
            let statusCode = responseData.response != nil ? responseData.response!.statusCode : 0
            
             if ((responseData.result.value) != nil) {
                let responseValue = JSON(responseData.result.value!)
                completion(responseValue, statusCode)
            } else {
                switch statusCode{
                case 204:
                    let errors = ["errors" : ["No data received"]]
                    let responseValue = JSON(errors)
                    let errorsString = String(describing: responseValue["errors"][0])
                    print("Received a: \(errorsString)")
                    completion(responseValue, statusCode)
                default:
                    let errors = ["errors" : ["Can't reach server, verify your internet connection"]]
                    let responseValue = JSON(errors)
                    let errorsString = String(describing: responseValue["errors"][0])
                    print("Received a: \(errorsString)")
                    completion(responseValue, statusCode)
                }
            }
        }
    }
    
    func generalRequest(_ uri: String, method: HTTPMethod? = .post, parameters: Parameters? = [:], encoding: ParameterEncoding? = URLEncoding.default, xApiKey: String = "", completion: @escaping (_ responseValue: JSON, _ statusCode: Int) -> ()) {
        
        var headers: HTTPHeaders = ["Accept": "application/json, text/plain, */*",
                                    "Accept-Encoding": "gzip, deflate, sdch, br",
                                    "Accept-Language": "es-ES,es;q=0.8",
                                    "Cache-Control":"no-cache",
                                    "Connection": "keep-alive",
                                    "Pragma" : "no-cache"]
        
        if (!(parameters?.isEmpty)!) {
            headers["Content-Type"] = "application/json"
        }
        
        Alamofire.request(uri, method: method!, parameters: parameters!, encoding: encoding!, headers: headers).responseJSON { (responseData) -> Void in
            
            let statusCode = responseData.response != nil ? responseData.response!.statusCode : 0
            
             if ((responseData.result.value) != nil) {
                let responseValue = JSON(responseData.result.value!)
                completion(responseValue, statusCode)
            } else {
                switch statusCode{
                case 204:
                    let errors = ["errors" : ["No data received"]]
                    let responseValue = JSON(errors)
                    let errorsString = String(describing: responseValue["errors"][0])
                    print("Received a: \(errorsString)")
                    completion(responseValue, statusCode)
                default:
                    let errors = ["errors" : ["Can't reach server, verify your internet connection"]]
                    let responseValue = JSON(errors)
                    let errorsString = String(describing: responseValue["errors"][0])
                    print("Received a: \(errorsString)")
                    completion(responseValue, statusCode)
                }
            }
        }
    }
    
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

//    //QA
//    //URLS
//    private let urlAWSQA = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
//    private let urlIniciarSesionQA = "https://gbn468tozl.execute-api.us-west-2.amazonaws.com"
//    private let urlSucursalesQA = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
//    private let urlSucursalUsuarioQA = "https://oj30fwwz9l.execute-api.us-west-2.amazonaws.com"
//    //Servicios
//    private let servicioLoginQA = "qa/signin"
//    private let servicioSucursalesXZonaQA = "qa/products/getStockByStoreZone"
//    private let servicioPedidoQA = "qa/orders/create"
//    private let servicioDataProductoQA = "qa/products/getProduct"
//    private let servicioNegadosQA = "qa/products/insertaNegado"
//    private let servicioSucursalUsuarioQA = "qa/sucursal/employee"
    
//    //PROD
//    //URLS
//    private let urlAWSProd = "https://nz2ft7pnyk.execute-api.us-west-2.amazonaws.com"
//    private let urlIniciarSesionProd = "https://4fg4czyw5k.execute-api.us-west-2.amazonaws.com"
//    private let urlSucursalesProd = "https://lyxgzns0i6.execute-api.us-west-2.amazonaws.com"
//    private let urlSucursalUsuarioProd = "https://te3gamqjag.execute-api.us-west-2.amazonaws.com"
//    //Servicios
//    private let servicioLoginProd = "prd/signin"
//    private let servicioSucursalesXZonaProd = "pre-prd/products/getstockskubystore"
//    private let servicioPedidoProd = "pre-prd/orders/neworder"
//    private let servicioDataProductoProd = "pre-prd/products/getinfoarticle"
//    private let servicioNegadosProd = "pre-prd/products/newdenied"
//    private let servicioSucursalUsuarioProd = "pre_prd/sucursal/employee"
