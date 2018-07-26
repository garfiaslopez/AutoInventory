//
//  Status_Detail_InventoryVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/25/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import SwiftyJSON
import Eureka

class Status_Detail_InventoryVC: FormViewController {

    var Car:JSON = JSON();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section("Status")
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "front_brakes";
                row.title = "Front Brakes (%)";
                var opts:[String] = [];
                for percent in 1...10 {
                    opts.append("\(percent * 10)");
                }
                row.options = opts;
                row.value = self.Car["front_brakes"].stringValue;
                row.disabled = true;
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "rear_brakes";
                row.title = "Rear Brakes (%)";
                var opts:[String] = [];
                for percent in 1...10 {
                    opts.append("\(percent * 10)");
                }
                row.options = opts;
                row.value = self.Car["rear_brakes"].stringValue;
                row.disabled = true;
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "front_rotors";
                row.title = "Front Rotors";
                row.options = ["good", "marginal", "bad"];
                row.value = self.Car["front_rotors"].stringValue;
                row.disabled = true;
                
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "rear_rotors";
                row.title = "Rear Rotors";
                row.options = ["good", "marginal", "bad"];
                row.value = row.options[0]
                row.value = self.Car["rear_rotors"].stringValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "leaks";
                row.title = "Without Leaks?"
                row.value = self.Car["leaks"].boolValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "engine_oil";
                row.title = "Have Engine Oil?"
                row.value = self.Car["engine_oil"].boolValue;
                row.disabled = true;
                
            }
            <<< SwitchRow(){ row in
                row.tag = "coolant";
                row.title = "Have Coolant?"
                row.value = self.Car["coolant"].boolValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "air_con";
                row.title = "AC is working?"
                row.value = self.Car["air_con"].boolValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "air_heat";
                row.title = "Heat is working?"
                row.value = self.Car["air_heat"].boolValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "dash_lights";
                row.title = "Dashboard Lights are ok?"
                row.value = self.Car["dash_lights"].boolValue;
                row.disabled = true;
        }
        
        animateScroll = true
        rowKeyboardSpacing = 20
    }
    
    func reloadView() {
        Section("Status").reload();
    }

}
