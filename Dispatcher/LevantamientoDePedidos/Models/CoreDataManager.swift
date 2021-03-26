//
//  CoreDataManager.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 02/06/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let container : NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "ModeloArticulos")
        
        setupDatabase()
    }
    
    private func setupDatabase() {
    
        container.loadPersistentStores { (desc, error) in
            
        if let error = error {
            print("Error loading store \(desc) — \(error)")
            return
        }
            print("Database ready!")
        }
    }
    
    func createOrder(
        orderNumber:String,
        upc: String,
        escaneado:Bool,
        estilo:String,
        genero: String,
        nombre: String,
        precio: String,
        sku: String,
        stock: String,
        talla: String,
        completion: @escaping() -> Void){
        
        let context = container.viewContext
        
        let order = Orders(context: context)
        order.orderNumber = orderNumber
        order.orderStatus = "En Proceso"
        
        let article = Article(context: context)
        article.orderNumber = orderNumber
        article.upc = upc
        article.escaneado = escaneado
        article.estilo = estilo
        article.genero = genero
        article.nombre = nombre
        article.precio = precio
        article.sku = sku
        article.stock = stock
        article.talla = talla
        article.belongsTo = order
        
        do {
            try context.save()
            print("orden \(orderNumber) guardada")
            completion()
        } catch {
         
          print("Error al guardar numero de orden — \(error)")
        }
        
    }
    
    func getOrders() -> [Orders] {
        
        
        let fetchRequest : NSFetchRequest<Orders> = Orders.fetchRequest()
           do {
               let result = try container.viewContext.fetch(fetchRequest)
               return result
           } catch {
               print("El error obteniendo usuario(s) \(error)")
            }
        
            return []
        
    }
    
    func getArticles(orderNumber:String) -> [Article] {
        
        let fetchRequest : NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "orderNumber == %@", orderNumber)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error raro")
        }
        
        return []
        
    }
    
    func checkOrderExistance(orderNumber:String) -> Bool {
        let fetchRequest : NSFetchRequest<Orders> = Orders.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "orderNumber == %@", orderNumber)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            if result.count == 0 {
                return false
            }
            return true
        } catch {
            print("Error raro")
        }
        
        return false
    }
    
    func insertArticleToOrder(
        orderNumber:String,
        upc: String,
        escaneado:Bool,
        estilo:String,
        genero: String,
        nombre: String,
        precio: String,
        sku: String,
        stock: String,
        talla: String
    ) {
        
        let context = container.viewContext
        
        let article = Article(context: context)
        article.orderNumber = orderNumber
        article.upc = upc
        article.escaneado = escaneado
        article.estilo = estilo
        article.genero = genero
        article.nombre = nombre
        article.precio = precio
        article.sku = sku
        article.stock = stock
        article.talla = talla
        
        do {
            try context.save()
            print("Articulo guardado")
        } catch {
         
          print("Error al guardar articulo — \(error)")
        }
        
    }

}

