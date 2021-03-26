//
//  ProcessStartVC.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 21/05/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON

protocol firstStepProcessProtocol {
    func saveOrderInfo(_ orderNumber:String)
}

class ProcessStartVC: UIViewController {
    
    @IBOutlet weak var startView:UIView!
    
    var firstStepDelegate: firstStepProcessProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func startProcessBtnPRessed(_ sender:Any){
        
        self.firstStepDelegate?.saveOrderInfo("1")
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
}
