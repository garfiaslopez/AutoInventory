//
//  Add_ReminderVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/21/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON

class Add_ReminderVC: FormViewController {

    let session = Session();
    var Object:JSON = JSON();
    var isEditingObject: Bool = false;
    var delegate:UpdateNewObject!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        if (!isEditingObject) {
            self.title = "Add new Reminder";
        } else {
            self.title = "Edit Reminder";
        }
        
        form
            +++ Section("What do you need to remember?")
            <<< TextAreaRow(){ row in
                row.tag = "denomination"
                if (!isEditingObject) {
                } else {
                    if (self.Object["car_id"] == JSON.null) {
                        row.value = self.Object["denomination"].stringValue;

                    } else {
                        let folio = self.Object["car_id"]["folio_text"].stringValue;
                        let make = self.Object["car_id"]["make"].stringValue;
                        let brand = self.Object["car_id"]["brand"].stringValue;
                        let year = self.Object["car_id"]["year"].stringValue;
                        let model = self.Object["car_id"]["model"].stringValue;
                        let km = self.Object["car_id"]["kilometers"].stringValue;
                        row.value = "Deliver car \(folio) - make: \(make), brand: \(brand), model: \(model), km: \(km) and year: \(year)";
                    }
                }
            }
            +++ Section("I will remind you on...")
            <<< DateRow(){ row in
                row.tag = "date";
                row.title = "Date";
                if (!isEditingObject) {
                    row.value = Date();
                } else {
                    row.value = Formatter().ParseMomentDate(self.Object["date"].stringValue);
                }
            }
        animateScroll = true
        rowKeyboardSpacing = 20

    }
    
    @IBAction func save(_ sender: Any) {
        
        let data = self.form.values();
        
        if (data["denomination"] as? String != nil && data["date"] as? Date != nil) {
            
            var Url = VARS().getApiUrl() + "/pending";
            var Method = HTTPMethod.post;
            if (self.isEditingObject) {
                Method = HTTPMethod.put;
                Url = VARS().getApiUrl() + "/pending/" + self.Object["_id"].stringValue;
            }
            
            let status = Reach().connectionStatus();
            
            switch status {
            case .online(.wwan), .online(.wiFi):
                
                let DatatoSend: Parameters = [
                    "enterprise_id": VARS().getEnterprise(),
                    "user_id": session._id,
                    "denomination": data["denomination"] as! String,
                    "date": (data["date"] as! Date).forServer
                ];
                
                let headers = [
                    "Authorization": self.session.token
                ];
                
                Alamofire.request(Url, method: Method, parameters: DatatoSend, encoding: JSONEncoding.default,  headers: headers).responseJSON { response in
                    if response.result.isSuccess {
                        let data = JSON(data: response.data!);
                        if(data["success"] == true) {
                            self.alertAndDismiss(data["message"].stringValue, Mensaje: "");
                        }else{
                            self.alerta("Oops!", Mensaje: data["message"].stringValue );
                        }
                    }else{
                        self.alerta("Oops!", Mensaje: (response.result.error?.localizedDescription)!);
                    }
                }
            case .unknown, .offline:
                self.alerta("Oops!", Mensaje: "No internet connection.");
            }
        } else {
            self.alerta("Error", Mensaje: "Empty values");
        }
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
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
            if (self.delegate != nil) {
                self.delegate.updateObject(obj: self.Object);
            }
        }
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    
}
