//
//  Add_TiresVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/23/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Eureka
import ViewRow
import SwiftyJSON
import Alamofire

class Add_TiresVC: FormViewController {

    let session = Session();
    var Tire:JSON = JSON();
    var isEditingTire: Bool = false;
    var delegate:UpdateNewObject!;
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        if (!isEditingTire) {
            self.title = "Add new Tire";
        } else {
            self.title = "Edit Tire";
        }
        
        form
            +++ Section("General")
            <<< TextRow(){ row in
                row.tag = "brand";
                row.title = "Brand"
                if (!isEditingTire) {
                } else {
                    row.value = self.Tire[row.tag!].stringValue;
                }
            }
            <<< ViewRow<Size_TiresV>("size") { (row) in
                row.title = "Size";
                
            }
            .cellSetup { (cell, row) in
                let bundle = Bundle.main;
                let nib = UINib(nibName: "Size_TiresV", bundle: bundle)
                cell.view = nib.instantiate(withOwner: self, options: nil)[0] as? Size_TiresV
                cell.view!.backgroundColor = cell.backgroundColor
                
                if (!self.isEditingTire) {
                    cell.view?.firstTextfield.text = "";
                    cell.view?.secondTextfield.text = "";
                    cell.view?.thirdTextfield.text = "";
                } else {
                    cell.view?.firstTextfield.text = self.Tire["size"]["first"].stringValue;
                    cell.view?.secondTextfield.text = self.Tire["size"]["second"].stringValue;
                    cell.view?.thirdTextfield.text = self.Tire["size"]["third"].stringValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "season";
                row.title = "Season";
                row.options = ["all-season","winter"];
                
                if (!isEditingTire) {
                    row.value = row.options[0]
                } else {
                    row.value = self.Tire[row.tag!].stringValue;
                }
            }
            <<< DecimalRow(){ row in
                row.tag = "stock"
                row.title = "How many?"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .none
                row.formatter = formatter
                if (!isEditingTire) {
                } else {
                    row.value = self.Tire[row.tag!].doubleValue;
                }
                
            }
            
        animateScroll = true
        rowKeyboardSpacing = 20
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        let data = self.form.values();
        
        var first = "";
        var second = "";
        var third = "";
        
        if let resultRow = self.form.rowBy(tag: "size") as? ViewRow<Size_TiresV>,
            let resultView = resultRow.view {
            first = resultView.firstTextfield.text!;
            second = resultView.secondTextfield.text!;
            third = resultView.thirdTextfield.text!;
        }
        
        let size: [String : Any] = [
            "first": first,
            "second": second,
            "third": third
        ]
        
        if (data["brand"] as? String != nil && data["season"] as? String != nil) {
            
            
            var Url = VARS().getApiUrl() + "/tire";
            var Method = HTTPMethod.post;
            if (self.isEditingTire) {
                Method = HTTPMethod.put;
                Url = VARS().getApiUrl() + "/tire/" + self.Tire["_id"].stringValue;
            }
            
            let status = Reach().connectionStatus();
            switch status {
            case .online(.wwan), .online(.wiFi):
                
                let DatatoSend: Parameters = [
                    "enterprise_id": VARS().getEnterprise(),
                    "user_id": session._id,
                    "brand": data["brand"] as! String,
                    "season": data["season"] as! String,
                    "size": size,
                    "stock": data["stock"] as! Double
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
                self.delegate.updateObject(obj: self.Tire);
            }
        }
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    
    

}
