//
//  EtiquetasVC.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 18/08/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import SimplePDF
import PDFKit
import SCLAlertView
import AVFoundation

class EtiquetasVC {

    
    func imprimeTicketInfo(_ arregloTickets:NSArray, _ empresa:String) -> UIImage {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var monto = 0.0
        var iva = 0.0
        var total = 0.0
        var pedido = ""
//        var calleNumero = ""
//        var colonia = ""
//        var ciudad = ""
//        var cp = ""
        var telefono = ""
        var nombre = ""
        var sucursal = ""
        
        let primerSet = arregloTickets[0] as! Dictionary<String,Any>
        pedido = "\(primerSet["VBELN"] ?? "")"
//        calleNumero = "\(primerSet["STREET_HOUSE_NUM1"] ?? "")"
//        colonia = "\(primerSet["CITY2"] ?? "")"
//        ciudad = "\(primerSet["CITY1"] ?? "")"
//        cp = "\(primerSet["POST_CODE1"] ?? "")"
        telefono = "\(primerSet["TEL_NUMBER"] ?? "")"
        nombre = "\(primerSet["KUNNRX"] ?? "")"
        sucursal = "\(primerSet["WERKS_NAME1"] ?? "")"
        
        let fechaHoy = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        let diaStr = "\(fechaHoy.day!)".count == 1 ? "0\(fechaHoy.day!)" : "\(fechaHoy.day!)"
        let mesStr = "\(fechaHoy.month!)".count == 1 ? "0\(fechaHoy.month!)" : "\(fechaHoy.month!)"
        let fecha = "\(diaStr)/\(mesStr)/\(fechaHoy.year!)"
        
        let a4PaperSize = CGSize(width: 320, height: 1000)
        let pdf = SimplePDF(pageSize: a4PaperSize)
        
        // load test image
        var image:UIImage!
        
        switch empresa {
        case "Innovasport":
            image = UIImage(named: "LOGOTIPO")
        case "Culto":
            image = UIImage(named: "culto_LogoHeader")
        case "Innvictus":
            image = UIImage(named: "innvictusTop")
        default:
            image = UIImage(named: "Ameh")
        }

        pdf.setContentAlignment(.center)
        pdf.addImage(image)
//        pdf.addText("INNOVASPORT LOGO", font: UIFont(name: "BigNoodleTitling", size:8)!, textColor: UIColor.black)
        pdf.addLineSpace(5)
        pdf.setContentAlignment(.left)
        pdf.addText("Sucursal: \(sucursal)", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.addLineSpace(2)
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("No Ticket: \(pedido)", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("FECHA: \(fecha)", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        pdf.addLineSeparator(height: 1)
        pdf.addLineSpace(8)
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("Código", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.setContentAlignment(.center)
        pdf.addText("Descripción", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("Precio", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        
        pdf.addLineSpace(8)
        
        // MARK: PRODUCTOS
        
        for set in arregloTickets {
            
            let arreglo = set as! Dictionary<String,Any>
            let cantidadString = arreglo["ZMENG"] as! String //Cantidad por posición
            let cantidadTrimmed = cantidadString.trimmingCharacters(in: .whitespacesAndNewlines)
            let cantidadDouble = Double(cantidadTrimmed)!
            let cantidadInt = Int(cantidadDouble)
            let sku = arreglo["MATNR"] as! String
            let skuInt = Int(sku)
            let montoProducto = arreglo["NETWR_PVTA"] as! String
            let montoTrimmed = montoProducto.trimmingCharacters(in: .whitespacesAndNewlines)
            let doubleMontoProducto = Double(montoTrimmed)
            let ivaString = arreglo["MWSBP"] as! String
            let ivaTrimmed = ivaString.trimmingCharacters(in: .whitespacesAndNewlines)
            let ivaDouble = Double(ivaTrimmed)!
            iva += ivaDouble
            monto += doubleMontoProducto!
            
            let desc = arreglo["MAKTX"] as! String
            let split = desc.split(separator: ",")
            let descCorta = split[0]
            
            let precioUnitario = doubleMontoProducto! / cantidadDouble
            let precioUnitarioLimpio = Double(round(1000*precioUnitario)/1000)
            
            pdf.beginHorizontalArrangement()
            pdf.setContentAlignment(.left)
            pdf.addText("\(String(describing: skuInt!))", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
            pdf.setContentAlignment(.center)
            pdf.addText("\(descCorta)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
            pdf.setContentAlignment(.right)
            pdf.addText("$\(String(describing: doubleMontoProducto!))", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
            pdf.endHorizontalArrangement()
            pdf.setContentAlignment(.center)
            pdf.addText("\(cantidadInt) x ($\(precioUnitarioLimpio))", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
            pdf.addLineSpace(2)
        }
        
        
        // MARK: TERMINA PRODUCTOS
        
        pdf.addLineSpace(5)
        
        // MARK: Comienza Monto
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("Monto:", font: UIFont(name: "Arial Rounded MT Bold", size:11)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("$\(monto)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        // MARK: Termina Monto
        
        // MARK: Comienza IVA
        let ivaLimpio = Double(round(1000*iva)/1000)
        
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("IVA:", font: UIFont(name: "Arial Rounded MT Bold", size:11)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("$\(ivaLimpio)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        // MARK: Termina IVA
        
        total = monto + iva
        
        let totalLimpio = Double(round(1000*total)/1000)
        
        // MARK: Comienza Total
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("Total:", font: UIFont(name: "Arial Rounded MT Bold", size:11)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("$\(totalLimpio)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        // MARK: Termina Total
        
        pdf.addLineSeparator(height: 1)
        pdf.addLineSpace(5)
        
        pdf.setContentAlignment(.left)
        
        pdf.addText("Datos del cliente", font: UIFont(name: "Arial Rounded MT Bold", size:15)!, textColor: UIColor.black)
        pdf.addLineSpace(5)
        
        pdf.addText("Nombre: \(nombre)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
//        pdf.addText("Direccion : \(calleNumero)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
//        pdf.addText("Colonia : \(colonia)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
//        pdf.addText("Ciudad : \(ciudad)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
//        pdf.addText("CP. \(cp)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
        pdf.addText("Teléfono: \(telefono)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        
        pdf.addLineSeparator(height: 1)
        pdf.addLineSpace(5)
        
        pdf.setContentAlignment(.center)
        pdf.addText("Gracias por tu compra", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
        
        pdf.addLineSpace(5)
        switch empresa {
        case "Innovasport":
            pdf.addText("En caso de requerir un cambio o devolución, comunicate a nuestro centro de atencion a clientes (55)47772222 o vía correo a: contactanos@innovasport.com indicando el numero de pedido.", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
            
            pdf.addLineSpace(3)
            
            pdf.addText("Genera tu factura en: www.innovasport.com/facturacion", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
        case "Innvictus":
            pdf.addText("En caso de requerir un cambio o devolución, comunicate a nuestro centro de atencion a clientes (55)88802222 o vía correo a: contactanos@innvicuts.com indicando el numero de pedido.", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
            
            pdf.addLineSpace(3)
            
            pdf.addText("Genera tu factura en: www.innvictus.com/facturacion", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
        case "Culto":
            pdf.addText("En caso de requerir un cambio o devolución, comunicate a nuestro centro de atencion a clientes (55)47741010 o vía correo a: contactanos@cultofutbol.com indicando el numero de pedido.", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
            
            pdf.addLineSpace(3)
            
            pdf.addText("Genera tu factura en: www.cultofutbol.com/facturacion", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
        default:
            pdf.addText("En caso de requerir un cambio o devolución, comunicate a nuestro centro de atencion a clientes (55)47501777 o vía correo a: contactanos@ameshop.com.mx indicando el numero de pedido.", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
            
            pdf.addLineSpace(3)
            
            pdf.addText("Genera tu factura en: www.ameshop.com.mx/facturacion", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
        }
        
        
        // load test image
        var imageFooter:UIImage!
        
        switch empresa {
        case "Innovasport":
            imageFooter = UIImage(named: "innvictusBottom")
        case "Culto":
            imageFooter = UIImage(named: "culto_LogoFooter")
            pdf.setContentAlignment(.center)
            pdf.addImage(imageFooter)
        case "Innvictus":
            imageFooter = UIImage(named: "innvictusBottom")
            pdf.setContentAlignment(.center)
            pdf.addImage(imageFooter)
        default:
            imageFooter = UIImage(named: "Amef")
        }

        pdf.addLineSpace(5)
        
//        let barcodeImage = UIImage(named: "barcodeExample")
//
//        pdf.addImage(barcodeImage!)
        
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let fileName = "ticket.pdf"
            let documentsFileName = documentDirectories + "/" + fileName
            
            let pdfData = pdf.generatePDFdata()
            do{
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
                print("\nThe generated pdf can be found at:")
                print("\n\t\(documentsFileName)\n")
                let imagen = self.convertPDFPageToImage(page: 1, pathLocation: documentsFileName)
                
                let url = URL(fileURLWithPath: documentsFileName)

                let vistaPDF = PDFView()

                if let document = PDFDocument(url: url) {
                    vistaPDF.autoScales = true
                    vistaPDF.displayMode = .singlePageContinuous
                    vistaPDF.displayDirection = .vertical
                    vistaPDF.document = document
                }
//                 MARK: Bloque de impresión Ticket
                if UIPrintInteractionController.canPrint(url) {
                    let printInfo = UIPrintInfo(dictionary: nil)
//                    printInfo.jobName = imageURL.lastPathComponent
                    printInfo.outputType = .photo

                    let printController = UIPrintInteractionController.shared
                    printController.printInfo = printInfo
                    printController.showsNumberOfCopies = false

                    printController.printingItem = url

                    printController.present(animated: true, completionHandler: nil)
                }
                return imagen

            }catch{
                print(error)
                return UIImage(named: "LOGOTIPO")!
            }
        }
        
        return UIImage(named: "LOGOTIPO")!
        
    }

    
    func imprimeStickersInfo(_ arregloStickers:NSArray) -> UIImage{
        
        let a4PaperSize = CGSize(width: 200, height: 550)
                let pdf = SimplePDF(pageSize: a4PaperSize)

        pdf.setContentAlignment(.center)
                
        for sticker in arregloStickers {
            
            pdf.addLineSeparator(height: 2)
            let info = sticker as! Dictionary<String,Any>
            
            let pedidoCompleto = "\(info["pedido"] ?? "")"
            let splitPedido = pedidoCompleto.components(separatedBy: "0166")
            var segundoParametro = splitPedido[1]
            let tienda = UserDefaults.standard.value(forKey: "sucursalEscaneada") as! String
            segundoParametro.insert(contentsOf: tienda, at: segundoParametro.startIndex)
            while segundoParametro.count < 11 {
                segundoParametro.insert("0", at: segundoParametro.startIndex)
            }
            let pedidoFinal = "\(segundoParametro)"
            
            pdf.addLineSpace(4)
            pdf.addText("\(info["nombre"] ?? "")", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
            pdf.addText(pedidoFinal, font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
            pdf.addLineSpace(8)
            pdf.addText("UBICACIÓN: \(info["ubicacion"] ?? "")", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
            pdf.addLineSpace(8)
            pdf.addText("EMPAQUE: \(info["empaque"] ?? "")", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
            pdf.addLineSpace(8)
            
            let barcode = UIImage(barcode: pedidoFinal)!
            pdf.addImage(barcode)
            
            pdf.addLineSpace(1)
            pdf.addText(pedidoFinal, font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
            pdf.addLineSpace(4)
            pdf.addLineSeparator(height: 2)
            
            pdf.addLineSpace(10)
            
        }
                
                
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let fileName = "stickers.pdf"
            let documentsFileName = documentDirectories + "/" + fileName
            
            let pdfData = pdf.generatePDFdata()
            do{
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
                
                let url = URL(fileURLWithPath: documentsFileName)

                let imagen = self.convertPDFPageToImage(page: 1, pathLocation: documentsFileName)
                return imagen
                
            }catch{
                print(error)
                return UIImage(named: "LOGOTIPO")!
            }
        }
        
        return UIImage(named: "LOGOTIPO")!
    }
    
    func imprimePDFEntregaInfo(pedido:String, recibe:String, identificacion:String, numeroId:String, firma:UIImage) -> URL{
        var url:URL = URL(fileURLWithPath: "")
        let fechaHoy = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        let diaStr = "\(fechaHoy.day!)".count == 1 ? "0\(fechaHoy.day!)" : "\(fechaHoy.day!)"
        let mesStr = "\(fechaHoy.month!)".count == 1 ? "0\(fechaHoy.month!)" : "\(fechaHoy.month!)"
        let fecha = "\(diaStr)/\(mesStr)/\(fechaHoy.year!)"
        
        let a4PaperSize = CGSize(width: 500, height: 550)
                let pdf = SimplePDF(pageSize: a4PaperSize)

//        pdf.setContentAlignment(.center)
//        let image = UIImage(named: "LOGOTIPO")!
//        pdf.addImage(image)
        
        pdf.setContentAlignment(.left)
                
        pdf.addLineSeparator(height: 2)
        pdf.addLineSpace(4)
        
        pdf.addText("Confirmación de pedido recibido", font: UIFont(name: "BigNoodleTitling", size:20)!, textColor: UIColor.black)
        
        pdf.addLineSpace(4)
        pdf.addText("Pedido: \(pedido)", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
        pdf.addText("Fecha recibido: \(fecha)", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
        pdf.addLineSpace(4)
        
        pdf.addText("\(recibe)", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
        pdf.addText("tipo de identificacion: \(identificacion)", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
        pdf.addText("numero de identificacion: \(numeroId)", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
        
        pdf.addLineSpace(4)
        pdf.addText("Firma :", font: UIFont(name: "BigNoodleTitling", size:15)!, textColor: UIColor.black)
        pdf.addLineSpace(2)
        
        pdf.addImage(firma)
        
        pdf.addLineSpace(3)
        pdf.addLineSeparator(height: 2)
                
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let fileName = "entrega.pdf"
            let documentsFileName = documentDirectories + "/" + fileName
            
            let pdfData = pdf.generatePDFdata()
            do{
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
                
                url = URL(fileURLWithPath: documentsFileName)
                
                

                if UIPrintInteractionController.canPrint(url) {
                  let printInfo = UIPrintInfo(dictionary: nil)
                  printInfo.outputType = .photo

                    let printController = UIPrintInteractionController.shared
                  printController.printInfo = printInfo
                  printController.showsNumberOfCopies = false

                  printController.printingItem = url

                    printController.present(animated: true, completionHandler: nil)
                }
                
                

            }catch{
                print(error)
            }
        }
        
        return url

    }
    
    
    func convertPDFPageToImage(page:Int, pathLocation:String) -> UIImage {

        do {

            let pdfdata = try NSData(contentsOfFile: pathLocation, options: NSData.ReadingOptions.init(rawValue: 0))

            let pdfData = pdfdata as CFData
            let provider:CGDataProvider = CGDataProvider(data: pdfData)!
            let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
            let pdfPage:CGPDFPage = pdfDoc.page(at: page)!
            var pageRect:CGRect = pdfPage.getBoxRect(.mediaBox)
            pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)

            print("\(pageRect.width) by \(pageRect.height)")

            UIGraphicsBeginImageContext(pageRect.size)
            let context:CGContext = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(pdfPage)
            context.restoreGState()
            let pdfImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            let imagenDeRegreso:UIImage = pdfImage
            
            return imagenDeRegreso
//            self.printerCon.printNormal(2, data: " ")
//            self.printerCon.printBitmap(2, image: pdfImage, width: self.printerCon.recLineWidth, alignment: -1, brightness: 10, compressType: 1, dithering: true)
//
//            printerCon.close()

        }
        catch {
            
            return UIImage(named: "LOGOTIPO")!

        }

    }
    
    func printerTest() -> UIImage{
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let monto = 0.0
        let iva = 0.0
        var total = 0.0
        let pedido = ""
//        var calleNumero = ""
//        var colonia = ""
//        var ciudad = ""
//        var cp = ""
        let telefono = ""
        let nombre = ""
        let sucursal = ""
        
        
        let fechaHoy = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        let diaStr = "\(fechaHoy.day!)".count == 1 ? "0\(fechaHoy.day!)" : "\(fechaHoy.day!)"
        let mesStr = "\(fechaHoy.month!)".count == 1 ? "0\(fechaHoy.month!)" : "\(fechaHoy.month!)"
        let fecha = "\(diaStr)/\(mesStr)/\(fechaHoy.year!)"
        
        let a4PaperSize = CGSize(width: 320, height: 1000)
        let pdf = SimplePDF(pageSize: a4PaperSize)
        
        // load test image
        var image:UIImage!
        
        image = UIImage(named: "LOGOTIPO")

        pdf.setContentAlignment(.center)
        pdf.addImage(image)
//        pdf.addText("INNOVASPORT LOGO", font: UIFont(name: "BigNoodleTitling", size:8)!, textColor: UIColor.black)
        pdf.addLineSpace(5)
        pdf.setContentAlignment(.left)
        pdf.addText("Sucursal: \(sucursal)", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.addLineSpace(2)
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("No Ticket: \(pedido)", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("FECHA: \(fecha)", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        pdf.addLineSeparator(height: 1)
        pdf.addLineSpace(8)
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("Código", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.setContentAlignment(.center)
        pdf.addText("Descripción", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("Precio", font: UIFont(name: "Arial Rounded MT Bold", size:13)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        
        pdf.addLineSpace(8)
        
        // MARK: PRODUCTOS
        
        
        
        
        // MARK: TERMINA PRODUCTOS
        
        pdf.addLineSpace(5)
        
        // MARK: Comienza Monto
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("Monto:", font: UIFont(name: "Arial Rounded MT Bold", size:11)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("$\(monto)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        // MARK: Termina Monto
        
        // MARK: Comienza IVA
        let ivaLimpio = Double(round(1000*iva)/1000)
        
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("IVA:", font: UIFont(name: "Arial Rounded MT Bold", size:11)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("$\(ivaLimpio)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        // MARK: Termina IVA
        
        total = monto + iva
        
        let totalLimpio = Double(round(1000*total)/1000)
        
        // MARK: Comienza Total
        pdf.beginHorizontalArrangement()
        pdf.setContentAlignment(.left)
        pdf.addText("Total:", font: UIFont(name: "Arial Rounded MT Bold", size:11)!, textColor: UIColor.black)
        pdf.setContentAlignment(.right)
        pdf.addText("$\(totalLimpio)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        pdf.endHorizontalArrangement()
        // MARK: Termina Total
        
        pdf.addLineSeparator(height: 1)
        pdf.addLineSpace(5)
        
        pdf.setContentAlignment(.left)
        
        pdf.addText("Datos del cliente", font: UIFont(name: "Arial Rounded MT Bold", size:15)!, textColor: UIColor.black)
        pdf.addLineSpace(5)
        
        pdf.addText("Nombre: \(nombre)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
//        pdf.addText("Direccion : \(calleNumero)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
//        pdf.addText("Colonia : \(colonia)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
//        pdf.addText("Ciudad : \(ciudad)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
//        pdf.addText("CP. \(cp)", font: UIFont(name: "BigNoodleTitling", size:7)!, textColor: UIColor.black)
        pdf.addText("Teléfono: \(telefono)", font: UIFont(name: "Arial", size:11)!, textColor: UIColor.black)
        
        pdf.addLineSeparator(height: 1)
        pdf.addLineSpace(5)
        
        pdf.setContentAlignment(.center)
        pdf.addText("Gracias por tu compra", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
        
        pdf.addLineSpace(5)
        
        pdf.addText("En caso de requerir un cambio o devolución, comunicate a nuestro centro de atencion a clientes (55)47772222 o vía correo a: contactanos@innovasport.com indicando el numero de pedido.", font: UIFont(name: "Arial", size:13)!, textColor: UIColor.black)
        
        pdf.addLineSpace(3)

        // load test image
        var imageFooter:UIImage!
        
        imageFooter = UIImage(named: "innvictusBottom")

        pdf.addLineSpace(5)
        
//        let barcodeImage = UIImage(named: "barcodeExample")
//
//        pdf.addImage(barcodeImage!)
        
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let fileName = "ticket.pdf"
            let documentsFileName = documentDirectories + "/" + fileName
            
            let pdfData = pdf.generatePDFdata()
            do{
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
                print("\nThe generated pdf can be found at:")
                print("\n\t\(documentsFileName)\n")
                let imagen = self.convertPDFPageToImage(page: 1, pathLocation: documentsFileName)
                
//                let url = URL(fileURLWithPath: documentsFileName)
                
//                let vistaPDF = PDFView()
//
//                if let document = PDFDocument(url: url) {
//                    vistaPDF.autoScales = true
//                    vistaPDF.displayMode = .singlePageContinuous
//                    vistaPDF.displayDirection = .vertical
//                    vistaPDF.document = document
//                }
////                 MARK: Bloque de impresión Ticket
//                if UIPrintInteractionController.canPrint(url) {
//                    let printInfo = UIPrintInfo(dictionary: nil)
////                    printInfo.jobName = imageURL.lastPathComponent
//                    printInfo.outputType = .photo
//
//                    let printController = UIPrintInteractionController.shared
//                    printController.printInfo = printInfo
//                    printController.showsNumberOfCopies = false
//
//                    printController.printingItem = url
//
//                    printController.present(animated: true, completionHandler: nil)
//                }
                return imagen

            }catch{
                print(error)
                return UIImage(named: "LOGOTIPO")!
            }
        }
        
        return UIImage(named: "LOGOTIPO")!
        
    }

}

extension UIImage {

    convenience init?(barcode: String) {
        let data = barcode.data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }
        self.init(ciImage: ciImage)
    }

}
