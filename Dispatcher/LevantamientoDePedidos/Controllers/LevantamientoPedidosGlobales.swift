//
//  LevantamientoPedidosGlobales.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 21/05/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import Foundation
import SwiftyJSON
import SCLAlertView

class LevantamientoPedidosGlobales {
    
    let defaults = UserDefaults.standard
    
    func refrescaToken(completion: @escaping (_ result:Int) -> ()){
        
        let username = UserDefaults.standard.value(forKey: "employee_number") as! String
        let password = UserDefaults.standard.value(forKey: "password") as! String

        LoginAPI().login(employeeNumber: username, password: password) { (jsonResponse, statusCode) in

            switch(statusCode){
            case 200 :
                self.iteraCognito(jsonResponse) { (response) in
                    switch response{
                    case 1:
                        completion(1)
                        break;
                    case 2:
                        completion(2)
                        break;
                    case 3:
                        completion(3)
                        break;
                    default:
                        completion(4)
                    }
                }
            case 403 :
                print("No cuentas con permiso para ingresar")
            default:
                print("No conozco este estatus");
            }

        }
        
    }
    
    func iteraCognito(_ response: JSON,  completion: @escaping (_ statusResult:Int) -> ()){
        
        if let data = response.description.data(using: String.Encoding.utf8) {
            do {
                let diccionario = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
            
                if let valores = diccionario
                {
                    if valores["response"] != nil {
                        let respuesta = valores["response"] as! Dictionary<String,Any>
                        let tokenId =  respuesta["id_token"] as! String
                        let accessToken =  respuesta["access_token"] as! String
                        let refreshToken =  respuesta["refresh_token"] as! String
                        
                        self.defaults.set(tokenId, forKey: "token_id")
                        self.defaults.set(accessToken, forKey: "access_token")
                        self.defaults.set(refreshToken, forKey: "refresh_token")
                        
                        completion(1)
                        
                    }else {
                        completion(2)
                    }
                    
                }else{
                    completion(3)
                }
            } catch let error as NSError {
                print(error)
            }
            
        }
        
    }
    
}
