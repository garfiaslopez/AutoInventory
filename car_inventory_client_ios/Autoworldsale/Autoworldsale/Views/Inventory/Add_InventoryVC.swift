//
//  Add_InventoryVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/21/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Eureka
import ColorPickerRow
import SwiftyJSON
import Alamofire
import ViewRow

protocol UpdateNewObject {
    func updateObject(obj: JSON);
}

class Add_InventoryVC: FormViewController {
    
    let session = Session();
    var Car:JSON = JSON();
    var isEditingCar: Bool = false;
    var delegate:UpdateNewObject!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!isEditingCar) {
            self.title = "Add new car";
        } else {
            self.title = "Edit Car";
        }
        
        form
            +++ Section("General")
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "year";
                row.title = "Year";
                var opts: [String] = [];
                for year in 1990..<2019 {
                    opts.append("\(year)");
                }
                row.options = opts.reversed();
                if (!isEditingCar) {
                    row.value = row.options[0]
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "make";
                row.title = "Make";
                row.options = VARS().getCars();
                if (!isEditingCar) {
                    row.value = row.options[0]
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< TextRow(){ row in
                row.tag = "model";
                row.title = "Model"
                if (!isEditingCar) {
                    
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< InlineColorPickerRow(){ row in
                row.tag = "color"
                row.title = "Color"
                row.isCircular = true
                row.showsPaletteNames = false
                if (!isEditingCar) {
                    row.value = UIColor.white
                } else {
                    row.value = UIColor(hex: self.Car[row.tag!].stringValue);
                }
            }
            .cellSetup { (cell, row) in
                let palette = ColorPalette(name: "Basic Colors",
                    palette: [
                        ColorSpec(hex: "#FFFFFF", name: "White"),
                        ColorSpec(hex: "#000000", name: "Black"),
                        ColorSpec(hex: "#7F7F7F", name: "Gray"),
                        ColorSpec(hex: "#FB0707", name: "Red"),
                        ColorSpec(hex: "#0970BC", name: "Blue"),
                        ColorSpec(hex: "#08AE56", name: "Green"),
                        ColorSpec(hex: "#FA9807", name: "Orange"),
                        ColorSpec(hex: "#863F11", name: "Brown"),
                        ColorSpec(hex: "#9807FA", name: "Purple"),
                        ColorSpec(hex: "#BC8E07", name: "Golden Sand"),
                        ColorSpec(hex: "#DCDCDC", name: "Silver")
                    ]
                );
                row.palettes = [palette];
            }
            <<< InlineColorPickerRow(){ row in
                row.tag = "color_interior"
                row.title = "Interior Color"
                row.isCircular = true
                row.showsPaletteNames = false
                if (!isEditingCar) {
                    row.value = UIColor.white
                } else {
                    row.value = UIColor(hex: self.Car[row.tag!].stringValue);
                }
            }
            .cellSetup { (cell, row) in
                let palette = ColorPalette(name: "Basic Colors",
                                           palette: [
                                            ColorSpec(hex: "#FFFFFF", name: "White"),
                                            ColorSpec(hex: "#000000", name: "Black"),
                                            ColorSpec(hex: "#7F7F7F", name: "Gray"),
                                            ColorSpec(hex: "#FB0707", name: "Red"),
                                            ColorSpec(hex: "#0970BC", name: "Blue"),
                                            ColorSpec(hex: "#08AE56", name: "Green"),
                                            ColorSpec(hex: "#FA9807", name: "Orange"),
                                            ColorSpec(hex: "#863F11", name: "Brown"),
                                            ColorSpec(hex: "#9807FA", name: "Purple"),
                                            ColorSpec(hex: "#BC8E07", name: "Golden Sand"),
                                            ColorSpec(hex: "#DCDCDC", name: "Silver")
                    ]
                );
                row.palettes = [palette];
            }
            <<< TextRow(){ row in
                row.tag = "vin";
                row.title = "Vin"
                if (!isEditingCar) {
                    
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< DecimalRow(){ row in
                row.tag = "kilometers"
                row.title = "Kilometers"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                row.formatter = formatter
                if (!isEditingCar) {
                    
                } else {
                    row.value = self.Car[row.tag!].doubleValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "transmission";
                row.title = "Transmision";
                row.options = ["automatic","manual"];
                if (!isEditingCar) {
                    row.value = row.options[0]
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "drive_train";
                row.title = "Drive Train";
                row.options = ["FWD","RWD","AWD"];
                if (!isEditingCar) {
                    row.value = row.options[0]
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "opidi";
                row.title = "OPI / DI";
                row.options = ["OPI","DI"];
                if (!isEditingCar) {
                    row.value = row.options[0];
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "opidi_done";
                row.title = "OPI / DI Done?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].boolValue;
                }
            }
            <<< DecimalRow(){ row in
                row.tag = "price_total"
                row.title = "Price ($)"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                row.formatter = formatter
                if (!isEditingCar) {
                    
                } else {
                    row.value = self.Car["price"]["total"].doubleValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "price_payment";
                row.title = "Payment";
                row.options = ["weekly","bi-weekly","monthly"];
                row.value = row.options[0]
                if (!isEditingCar) {
                    
                } else {
                    row.value = self.Car["price"]["payment"]["period"].stringValue;
                }
            }
            <<< DecimalRow(){ row in
                row.tag = "price_payment_total"
                row.title = "Payment Price ($)"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                row.formatter = formatter
                if (!isEditingCar) {
                    
                } else {
                    row.value = self.Car["price"]["payment"]["total"].doubleValue;
                }
            }
            <<< DateRow(){ row in
                row.tag = "arrival";
                row.title = "Date of Arrival"
                if (!isEditingCar) {
                    row.value = Date()
                } else {
                    if (self.Car[row.tag!] != JSON.null) {
                        row.value = Formatter().ParseMomentDate(self.Car[row.tag!].stringValue)
                    }
                }
            }
            <<< DateRow(){ row in
                row.tag = "delivery";
                row.title = "Date of Delivery"
                if (!isEditingCar) {
                    
                } else {
                    if (self.Car[row.tag!] != JSON.null) {
                        row.value = Formatter().ParseMomentDate(self.Car[row.tag!].stringValue)
                    }
                }
            }
            <<< MultipleSelectorRow<String>{ row in
                row.tag="advertising";
                row.title = "Advertising";
                row.options = ["kijiji", "autotrader", "aws"];
                if (!isEditingCar) {
                    row.value = []
                } else {
                    var values: Set<String> = [];
                    for (_,obj):(String,JSON) in self.Car[row.tag!] {
                        values.insert(obj.stringValue);
                    }
                    row.value = values;
                }
            }
            .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(Add_InventoryVC.multipleSelectorDone(_:)))
            }
            <<< SwitchRow(){ row in
                row.tag = "pictures_taken";
                row.title = "Pictures Taken?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "detailing_done";
                row.title = "Detailing Done?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            
            +++ Section("Status")
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "front_brakes";
                row.title = "Front Brakes (%)";
                var opts:[String] = [];
                for percent in 1...10 {
                    opts.append("\(percent * 10)");
                }
                row.options = opts;
                if (!isEditingCar) {
                    row.value = row.options[0];
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "rear_brakes";
                row.title = "Rear Brakes (%)";
                var opts:[String] = [];
                for percent in 1...10 {
                    opts.append("\(percent * 10)");
                }
                row.options = opts;
                if (!isEditingCar) {
                    row.value = row.options[0];
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "front_rotors";
                row.title = "Front Rotors";
                row.options = ["good", "marginal", "bad"];
                row.value = row.options[0]
                if (!isEditingCar) {
                    row.value = row.options[0];
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "rear_rotors";
                row.title = "Rear Rotors";
                row.options = ["good", "marginal", "bad"];
                row.value = row.options[0]
                if (!isEditingCar) {
                    row.value = row.options[0];
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "leaks";
                row.title = "Without Leaks?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "engine_oil";
                row.title = "Have Engine Oil?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "coolant";
                row.title = "Have Coolant?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "air_con";
                row.title = "AC is working?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "air_heat";
                row.title = "Heat is working?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "dash_lights";
                row.title = "Dashboard Lights are ok?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            
            
            
            +++ Section("Body")
            <<< SwitchRow(){ row in
                row.tag = "scratches";
                row.title = "Without Scratches?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "dent";
                row.title = "Without Dents?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "lights";
                row.title = "Lights are ok?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< SwitchRow(){ row in
                row.tag = "wheels";
                row.title = "Wheels are ok?"
                if (!isEditingCar) {
                    row.value = false;
                } else {
                    row.value = self.Car[row.tag!].bool;
                }
            }
            <<< ViewRow<Size_TiresV>("tire_size") { (row) in
                row.title = "Tire Size";
            }
            .cellSetup { (cell, row) in
                let bundle = Bundle.main;
                let nib = UINib(nibName: "Size_TiresV", bundle: bundle)
                cell.view = nib.instantiate(withOwner: self, options: nil)[0] as? Size_TiresV
                cell.view!.backgroundColor = cell.backgroundColor
                cell.view?.frame.size.height = 46;
                if (!self.isEditingCar) {
                    cell.view?.firstTextfield.text = "";
                    cell.view?.secondTextfield.text = "";
                    cell.view?.thirdTextfield.text = "";
                } else {
                    cell.view?.firstTextfield.text = self.Car["tire_size"]["first"].stringValue;
                    cell.view?.secondTextfield.text = self.Car["tire_size"]["second"].stringValue;
                    cell.view?.thirdTextfield.text = self.Car["tire_size"]["third"].stringValue;
                }
            }
            
            +++ Section("Notes")
            <<< TextAreaRow() { row in
                row.tag = "notes";
                if (!isEditingCar) {
                    
                } else {
                    row.value = self.Car[row.tag!].stringValue;
                }
            }
        
        animateScroll = true
        rowKeyboardSpacing = 20
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func save(_ sender: Any) {
        if (self.validate()) {
            self.save();
        } else {
            self.alerta("Error", Mensaje: "Some empty values.");
        }
    }
    
    func validate() -> Bool{
//        let data = self.form.values();
//        if (data["price"] as! Double > 0.0 &&
//            data["price_number"] as! Double > 0.0 ) {
//            return true;
//        }
        return true;
    }
    func save() {
        let data = self.form.values();
        print(data);
        
        var Url = VARS().getApiUrl() + "/car";
        var Method = HTTPMethod.post;
        
        if (isEditingCar) {
            Method = HTTPMethod.put;
            Url = VARS().getApiUrl() + "/car/" + self.Car["_id"].stringValue;
        }
        
        let status = Reach().connectionStatus();
        
        switch status {
        case .online(.wwan), .online(.wiFi):
            
            var DatatoSend: Parameters = [
                "enterprise_id": VARS().getEnterprise(),
                "user_id": session._id,
                "year": data["year"] as! String,
                "make": data["make"] as! String,
                "color": (data["color"] as! UIColor).hexString(),
                "color_interior": (data["color_interior"] as! UIColor).hexString(),
                "transmission": data["transmission"] as! String,
                "drive_train": data["drive_train"] as! String,
                "opidi": data["opidi"] as! String,
                "opidi_done": data["opidi_done"] as! Bool,
                "pictures_taken": data["pictures_taken"] as! Bool,
                "detailing_done": data["detailing_done"] as! Bool,
                "front_brakes": data["front_brakes"] as! String,
                "rear_brakes": data["rear_brakes"] as! String,
                "front_rotors": data["front_rotors"] as! String,
                "rear_rotors": data["rear_rotors"] as! String,
                "leaks": data["leaks"] as! Bool,
                "engine_oil": data["engine_oil"] as! Bool,
                "coolant": data["coolant"] as! Bool,
                "air_con": data["air_con"] as! Bool,
                "air_heat": data["air_heat"] as! Bool,
                "dash_lights": data["dash_lights"] as! Bool,
                "scratches": data["scratches"] as! Bool,
                "dent": data["dent"] as! Bool,
                "lights": data["lights"] as! Bool,
                "wheels": data["wheels"] as! Bool
            ];
            
            // optional fields:
            if let field = data["model"] as? String {
                DatatoSend["model"] = field;
            }
            if let field = data["vin"] as? String {
                DatatoSend["vin"] = field;
            }
            if let field = data["kilometers"] as? Double {
                DatatoSend["kilometers"] = field;
            }
            var price: [String : Any] = [
                "total": 0
            ]
            var payment: [String : Any]  = [
                "period": data["price_payment"] as! String,
                "total": 0
            ]
            if let field = data["price_total"] as? Double {
                price["total"] = field;
            }
            if let field = data["price_payment_total"] as? Double {
                payment["total"] = field;
                price["payment"] = payment;
            }
            DatatoSend["price"] = price;
            if let field = data["arrival"] as? Date {
                DatatoSend["arrival"] = Formatter().DateOnly.date(from: Formatter().DateOnly.string(from: field))?.forServer;
            }
            if let field = data["delivery"] as? Date {
                DatatoSend["delivery"] = Formatter().DateOnly.date(from: Formatter().DateOnly.string(from: field))?.forServer;
            }
            if let advArray = data["advertising"] as? Set<String> {
                DatatoSend["advertising"] = [String](advArray);
            }
            if let field = data["notes"] as? String {
                DatatoSend["notes"] = field;
            }

            if let resultRow = self.form.rowBy(tag: "tire_size") as? ViewRow<Size_TiresV>,
                let resultView = resultRow.view {
                DatatoSend["tire_size"] = [
                    "first": resultView.firstTextfield.text!,
                    "second": resultView.secondTextfield.text!,
                    "third": resultView.thirdTextfield.text!
                ];
            }
            
            
            
            let headers = [
                "Authorization": self.session.token
            ];
            
            Alamofire.request(Url, method: Method, parameters: DatatoSend, encoding: JSONEncoding.default,  headers: headers).responseJSON { response in
                if response.result.isSuccess {
                    let data = JSON(data: response.data!);
                    if(data["success"] == true) {
                        self.Car = data["car"];
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
    }

    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
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
                self.delegate.updateObject(obj: self.Car);
            }
        }
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    

}
