//
//  Add_Container_InventoryVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/21/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Eureka
import SwiftyJSON
import Alamofire


class Add_Container_InventoryVC: UIViewController {

    var form : Add_InventoryVC!;
    let session = Session();
    
    @IBOutlet weak var formController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fc = segue.destination as? Add_InventoryVC {
            self.form = fc;
        }
    }
    
    func alerta(_ Titulo:String,Mensaje:String){
        let alertController = UIAlertController(title: Titulo, message:
            Mensaje, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertAndDismiss(_ Titulo:String,Mensaje:String){
        let alertController = UIAlertController(title: Titulo, message:
            Mensaje, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil);
        }
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }

}
