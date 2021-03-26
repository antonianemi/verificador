//
//  ViewController.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 8/14/19.
//  Copyright © 2019 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON
import iOSDropDown
import CoreData

class ViewController: UIViewController, firstStepProcessProtocol, ScannerResultProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var nombreSucursal:UILabel!
    @IBOutlet weak var vistaDetalleProducto: UIView!
    @IBOutlet weak var vistaSpinner: UIView!
    @IBOutlet weak var indicadorDeActividad: UIActivityIndicatorView!
    @IBOutlet weak var precioPromocion: UILabel!
    @IBOutlet weak var imagenPrueba: UIImageView!
    @IBOutlet weak var nombreProductoLbl: UILabel!
    @IBOutlet weak var estiloLbl:UILabel!
    @IBOutlet weak var generoLbl:UILabel!
    @IBOutlet weak var precioLista:UILabel!
    @IBOutlet weak var tallaLbl:UILabel!
    
    private let manager = CoreDataManager()
    
    var arregloPedidos = [String]()
    
    var arregloArticulos = [Articulos]()
    var articles: [NSManagedObject] = []
    
    var arregloSucursales:[String] = []
    
    var scannedCode:String!
    
    var arregloTallasOtro:[String] = []
    var arregloTallas:[String] = []
    var arregloTallasValor:[String] = []
    var arregloTallasValorId:[Int] = []
    var diccionarioNombres: Dictionary<String, Any> = [:]
    
    var diccionarioSAP: Dictionary<String,Any>! = [:]
    
    var tallaSeleccionada = ""
    
    var diccionarioSAPSeleccionado: Dictionary<String, Any> = [:]
    
    var estiloEscaneado = ""
    
    var tallaTextoSeleccionado = ""
    
    var cantidadNube = 0
    
    var nombreSeleccionado = ""
    
    var indexPathSeleccionado = 0
    
    var pickingMode = false
    
    var valorTotalSAPPrecio = ""
    
    var valorTotalSKUsSap = ""
    
    let defaults = UserDefaults.standard
    
    var tienda:String = ""
    
    var ticketEnProceso = true
    
    var estiloEncontrado = ""
    
    var tipoBusquedaDetalleArticulo = "0"
    
    var articuloEncontrado = false
    
    var articuloAgregado = true
    
    var pedidoActual = ""
    
    let levantamientoDePedidosAPI = LevantamientoDePedidosAPI()
    let metodosGlobales = LevantamientoPedidosGlobales()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.pedidoActual == "" {
            self.performSegue(withIdentifier: "goToFirstStep", sender: nil)
        }else{
            if self.pedidoActual == "1" {
                self.performSegue(withIdentifier: "goToScannerProcess", sender: nil)
            }
        }
        
        
        
//        if lastOrderSaved == nil && self.pedidoActual == ""{
//            self.performSegue(withIdentifier: "goToFirstStep", sender: nil)
//            return
//        }else if lastOrderSaved != nil && self.pedidoActual == ""{
//            self.performSegue(withIdentifier: "goToOrders", sender: nil)
//        }

        self.tienda = defaults.value(forKey: "nombreTienda") as! String
        self.nombreSucursal.text = "\(self.tienda)"

        self.vistaSpinner.isHidden = true
        self.indicadorDeActividad.isHidden = true

        self.vistaDetalleProducto.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func saveOrderInfo(_ orderNumber: String) {
        
        self.pedidoActual = orderNumber
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToFirstStep":
            let processStartVC: ProcessStartVC = segue.destination as! ProcessStartVC
            processStartVC.firstStepDelegate = self
        case "goToScannerProcess":
            let scannerProcessVC: ScannerProcessVC = segue.destination as! ScannerProcessVC
            scannerProcessVC.scannerDelegate = self
        default:
            print("I do not recognize this movement")
        }
    }
    
    func getScannedCode(code: String) {
        
        self.pedidoActual = "2"
        self.getProduct(code)
        
    }
    
    func getProduct(_ scannedCode: String){
        
//        if articuloAgregado == false{SCLAlertView().showWarning("", subTitle: "Debes agregar el artículo en el resumen antes de continuar.")}else{}
        
        self.vistaSpinner.isHidden = false
        self.indicadorDeActividad.isHidden = false
        self.indicadorDeActividad.startAnimating()
        
        let tiendaId = "\(defaults.value(forKey: "sucursalEscaneada") ?? "")"
        
        self.levantamientoDePedidosAPI.getProductData(tienda: tiendaId, sku: scannedCode, estilo: scannedCode) { (responseJSON, responseStatusCode)  in
            
            self.indicadorDeActividad.stopAnimating()
            self.vistaSpinner.isHidden = true
            
            self.articuloAgregado = true
                
            switch responseStatusCode {
            case 200 :
                let contenido = responseJSON["content"]
                if contenido == "EXITO: CONSULTA REALIZADA CORRECTAMENTE, NO SE ENCONTRO EL ARTICULO BUSCADO" {
                    SCLAlertView().showWarning("No se encontró el artículo buscado.", subTitle: "")
                }else {
                    self.articuloAgregado = false
                    self.iteraContenido(contenido: contenido)
                }
                break;
            case 204 :
                SCLAlertView().showWarning("", subTitle: "\(responseJSON["content"])")
                break;
            case 401 :
                self.metodosGlobales.refrescaToken { (result) in
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
                break;
            case 403 :
                SCLAlertView().showError("No cuentas con permiso para acceder a esta información", subTitle: "")
            case 500 :
                SCLAlertView().showError("Server error", subTitle: "")
            case 504:
                SCLAlertView().showWarning("Timeout exception \(responseStatusCode).", subTitle: "")
            default:
                SCLAlertView().showWarning("Obtuviste el siguiente estatus : \(responseStatusCode), reportalo a departamento de soporte.", subTitle: "")
            }
        }
    }
    
    func iteraContenido(contenido: JSON){
        
        print(contenido.description)
        if contenido.description == "null" {
            SCLAlertView().showWarning("", subTitle: "Artículo no encontrado")
            return
        }
        if let data = contenido.description.data(using: String.Encoding.utf8) {
            
            do {
                
                let diccionario = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
            
                if let valores = diccionario
                {
                    self.arregloTallasOtro.removeAll()
                    self.arregloSucursales.removeAll()
                    let estilo = valores["estilo"] as! String
                    self.estiloEncontrado = estilo
                    let dd =  valores["sap-info"] as! String
                    self.iteraVAloresSAP(resultado: dd)
                    let tallas = valores["tallas"] as! Dictionary<String,Any>
                    let decodedData = NSData(base64Encoded: valores["img"] as! String, options: [])
                    if let data = decodedData {
                        let decodedimage = UIImage(data: data as Data)
                        self.imagenPrueba.image = decodedimage
                    } else {
                        print("error with decodedData")
                    }
//                    let imgData = UIImage(data: Data(base64Encoded: valores["img"] as! String)!)
                    
                    let nombres = valores["articulos"] as! Dictionary<String,Any>
                    self.iteraNombres(nombres)
                    self.llenaValoresProducto()
                    
                    //Precio promocion
                    let precioPromocion = getPrecioPromocion(valores as! [String : AnyObject])
                    
                    self.precioPromocion.text = precioPromocion
                    
                    
                    
                }else{
                    SCLAlertView().showError("No se encontraron valores en esta función", subTitle: "")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }else{
            SCLAlertView().showWarning("", subTitle: "Artículo no encontrado")
        }
        
    }
    
    func getPrecioPromocion(_ valores:[String:AnyObject])->String{
        guard let value = valores["precio-promocion"] as? String else{
            return ""
        }
        return value
    }
    
    func iteraNombres(_ nombres:Dictionary<String,Any>){
        self.diccionarioNombres.removeAll()
        for nombre in nombres {
            self.diccionarioNombres[nombre.key] = nombre.value
        }
    }
    
    func iteraVAloresSAP(resultado:String){
        
        do {
          let con = try JSONSerialization.jsonObject(with: resultado.data(using: .utf8)!, options: []) as! [String:Any]
            
            for item in con {
                let llave = item.key
                let valor = item.value
                self.diccionarioSAP[llave] = valor
            }
            
        } catch {
           print(error)
        }
        
    }
    
    func llenaValoresProducto(){
        
        self.vistaDetalleProducto.isHidden = false
        
        var contador = 0
        self.diccionarioSAPSeleccionado = self.diccionarioSAP.values.first as! Dictionary<String,Any>
        for item in self.diccionarioSAPSeleccionado {
            switch item.key {
            case "STOCK_TOTAL":
                let stockString = String(describing:item.value)
                let splitString = stockString.split(separator: ".", maxSplits: 2, omittingEmptySubsequences: true)
                self.cantidadNube = Int(splitString[0])!
            break
            case "STOCK_TOTAL_INC_TICKET_NPROC":
                self.valorTotalSAPPrecio = "\(item.value)"
            break
            case "TEXTO_GENERO":
                
            break
            case "STOCK_EN_TICKET":
                self.valorTotalSKUsSap = "\(item.value)"
            break
            default:
            break
            }
            contador = contador + 1
            if contador == self.diccionarioSAPSeleccionado.count {
                let precioSAP:Double = Double(self.valorTotalSAPPrecio)!
                let cantidadStockSAP:Double = Double(self.valorTotalSKUsSap)!
                let precioResultado = precioSAP / cantidadStockSAP
                self.precioLista.text = "$\(preparePriceToTwoDigits(precioResultado))"
                self.nombreSeleccionado = self.diccionarioNombres.values.first as! String
                self.nombreProductoLbl.text = self.nombreSeleccionado

                self.estiloLbl.text = " MODELO: \(self.estiloEncontrado)"
            }
        }
    }

    func preparePriceToTwoDigits(_ value:Double)->Double{
        return Double(round(100 * value) / 100)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func openScannerBtnPressed() {
        
//        self.test()
//        self.estiloEscaneado = "537384-090"
//        self.getProduct("537384-090")
                self.arregloTallas = []
                self.arregloTallasValor = []
                self.arregloTallasValorId = []
                self.diccionarioNombres = [:]
                self.diccionarioSAP = [:]
                self.tallaSeleccionada = ""
                self.diccionarioSAPSeleccionado = [:]
                self.estiloEscaneado = ""
                self.tallaTextoSeleccionado = ""
                self.cantidadNube = 0
                self.nombreSeleccionado = ""
                self.indexPathSeleccionado = 0
                self.pickingMode = false
                self.valorTotalSAPPrecio = ""
                self.valorTotalSKUsSap = ""
                
                self.vistaDetalleProducto.isHidden = true

            self.performSegue(withIdentifier: "goToScannerProcess", sender: nil)
    }
    
    @IBAction func openScanner(_ sender: Any) {
        self.openScannerBtnPressed()
    }
    
    
}
