//
//  LoginVC.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 03/10/19.
//  Copyright © 2019 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTxt:UITextField!
    @IBOutlet weak var passwordTxt:UITextField!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var vistaSpinner: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    
    let loginAPI = LoginAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vistaSpinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.verificaSesion()
    }
    
    func verificaSesion(){
        if defaults.value(forKey: "token_id") != nil {
            if defaults.value(forKey: "sucursalEscaneada") != nil {
                self.performSegue(withIdentifier: "goToPriceCheck", sender: nil)
            }
        }else{
            print("Sesion no iniciada")
        }
    }
    
    
    @IBAction func loginBtnPRessed(_ sender:Any){
        
        let username = self.usernameTxt.text!
        let password = self.passwordTxt.text!

        if username == "" || password == "" {
            let alerta = SCLAlertView()
            alerta.showWarning("", subTitle: "Debes llenar todos los campos para continuar")

        }else {
            
            self.vistaSpinner.isHidden = false
            self.spinner.startAnimating()
            
            defaults.set(password, forKey: "password")

            self.loginAPI.login(employeeNumber: username, password: password) { (jsonResponse, statusCode) in
                

                switch(statusCode){
                case 200 :
                    self.iteraCognito(jsonResponse, username)
                case 403 :
                    SCLAlertView().showWarning("", subTitle: "No cuentas con permiso para ingresar.")
                default:
                    SCLAlertView().showWarning("", subTitle: "Recibiste el siguiente código desde el servidor \(statusCode), favor de reportarlo a soporte.")
                }

            }

        }
        
    }
    
    func iteraCognito(_ response: JSON, _ username: String){
        
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
                        
                        self.defaults.set(username, forKey: "employee_number")
                        self.defaults.set(tokenId, forKey: "token_id")
                        self.defaults.set(accessToken, forKey: "access_token")
                        self.defaults.set(refreshToken, forKey: "refresh_token")
                        
                        self.getSucursalUsuario(usuario: username)
                        
                    }else {
                        self.vistaSpinner.isHidden = true
                        self.spinner.stopAnimating()
                        SCLAlertView().showError("Ocurrió un error al consultar cognito", subTitle: "")
                    }
                    
                    
                }else{
                    SCLAlertView().showError("No se encontraron valores en esta función", subTitle: "")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }
        
    }
    
    func getSucursalUsuario(usuario:String){
  
        self.loginAPI.getSucursalDeUsuario(usuario: usuario) { (jsonResponse, statusCode) in
            
            self.vistaSpinner.isHidden = true
            self.spinner.stopAnimating()
            
            switch(statusCode){
            case 200:
                if jsonResponse["content"] == "EXITO: CONSULTA REALIZADA CORRECTAMENTE, FAVOR DE VALIDAR LA EXISTENCIA DEL USUARIO O SU ESTADO ACTIVO" {
                    SCLAlertView().showWarning("", subTitle: "\(jsonResponse["content"])")
                }else{
                    self.iteraSucursalUsuario(response: jsonResponse["content"])
                }
                
            break
            case 204:
                SCLAlertView().showWarning("", subTitle: "Usuario no enrolado a tienda")
            break
            default:
                SCLAlertView().showWarning("", subTitle: "Estatus: \(statusCode) favor de reportarlo a soporte.")
            }
            
        }
    }
    
    func getPerfil(){
        
        //self.defaults.set(accessToken, forKey: "access_token")
        let accessToken = "\(self.defaults.value(forKey: "access_token") ?? "")"
        
        self.loginAPI.getPerfilUsuario(accessToken: accessToken) { (jsonResponse, statusCode) in
            
            switch statusCode {
            case 200:
                let response = jsonResponse["response"]
                self.iteraPerfilUsuario(response: response)
                break
            default:
                SCLAlertView().showError("", subTitle: "Obtuve el siguiente estatus en el servicio de perfil empleado: \(statusCode)")
            }
        }
    }
    
    func iteraPerfilUsuario(response:JSON){
        
        if let data = response.description.data(using: String.Encoding.utf8) {
            do {
                let diccionario = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
            
                if let valores = diccionario
                {
                    
                    let atributos = valores["attributes"] as! NSArray
                    
                    for atributo in atributos {
                        let dicAtributo = atributo as! Dictionary<String,Any>
                        if dicAtributo["Name"] as! String == "custom:puesto" {
                            print("Tengo el puesto : \(dicAtributo["Value"] ?? "")")
                            self.defaults.setValue("\(dicAtributo["Value"] ?? "")", forKey: "PerfilUsuario")
                            self.vistaSpinner.isHidden = true
                            self.spinner.stopAnimating()
                            self.performSegue(withIdentifier: "goToPriceCheck", sender: nil)
                        }
                    }
                    
                    
                }else{
                    SCLAlertView().showError("No se encontraron valores en esta función", subTitle: "")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }
        
    }
    
    func iteraSucursalUsuario(response:JSON){
        
        if let data = response.description.data(using: String.Encoding.utf8) {
            do {
                let diccionario = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
            
                if let valores = diccionario
                {
                    if valores["tiendaId"] != nil {
                        let respuesta = valores["tiendaId"] as! String
                        defaults.set(respuesta, forKey: "sucursalEscaneada")
                    }else {
                        self.vistaSpinner.isHidden = true
                        self.spinner.stopAnimating()
                        SCLAlertView().showError("", subTitle: "El valor ID de tienda, está vacío en el servicio, favor de reportarlo con el administrador antes de continuar.")
                    }
                    
                    if valores["nombre"] != nil {
                        let nombreUsuario = valores["nombre"] as! String
                        defaults.setValue(nombreUsuario, forKey: "nombreUsuario")
                    }else {
                        self.vistaSpinner.isHidden = true
                        self.spinner.stopAnimating()
                        SCLAlertView().showError("", subTitle: "El valor nombre de usuario está vacío en el servicio, favor de reportarlo con el administrador.")
                    }
                    
                    if valores["nombreTienda"] != nil {
                        let nombreTienda = valores["nombreTienda"] as! String
                        defaults.setValue(nombreTienda, forKey: "nombreTienda")
                    }else{
                        self.vistaSpinner.isHidden = true
                        self.spinner.stopAnimating()
                        SCLAlertView().showError("", subTitle: "El valor nombre de tienda está vacío en el servicio, favor de reportarlo con el administrador antes de continuar.")
                    }
                    
                    self.getPerfil()
                    
                    
                }else{
                    SCLAlertView().showError("No se encontraron valores en esta función", subTitle: "")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }
        
    }
    
}
