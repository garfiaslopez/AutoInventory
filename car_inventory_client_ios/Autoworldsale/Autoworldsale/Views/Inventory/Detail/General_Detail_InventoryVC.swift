//
//  General_Detail_InventoryVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/25/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import SwiftyJSON
import Eureka
import ColorPickerRow

class General_Detail_InventoryVC: FormViewController {
    
    var Car:JSON = JSON();

    override func viewDidLoad() {
        super.viewDidLoad();
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
                row.value = self.Car["year"].stringValue;
                row.disabled = true;
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "make";
                row.title = "Make";
                row.options = VARS().getCars();
                row.value = self.Car["make"].stringValue;
                row.disabled = true;

            }
            <<< TextRow(){ row in
                row.tag = "model";
                row.title = "Model"
                row.value = self.Car["model"].stringValue;
                row.disabled = true;
            }
            <<< InlineColorPickerRow(){ row in
                row.tag = "color"
                row.title = "Color"
                row.isCircular = true
                row.showsPaletteNames = false
                row.value = UIColor(hex:self.Car["color"].stringValue);
                row.disabled = true;
            }
            .cellUpdate { cell, row in
                row.value = UIColor(hex:self.Car["color"].stringValue);
            }
            <<< InlineColorPickerRow(){ row in
                row.tag = "color_interior"
                row.title = "Interior Color"
                row.isCircular = true
                row.showsPaletteNames = false
                row.value = UIColor(hex:self.Car["color_interior"].stringValue);
                row.disabled = true;
            }
            <<< TextRow(){ row in
                row.tag = "vin";
                row.title = "Vin"
                row.value = self.Car["vin"].stringValue;
                row.disabled = true;
            }
            <<< DecimalRow(){ row in
                row.tag = "kilometers"
                row.title = "Kilometers"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                row.formatter = formatter
                row.value = self.Car["kilometers"].doubleValue;
                row.disabled = true;
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "transmission";
                row.title = "Transmision";
                row.options = ["automatic","manual"];
                row.value = self.Car["transmission"].stringValue;
                row.disabled = true;
              
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "drive_train";
                row.title = "Drive Train";
                row.options = ["FWD","RWD","AWD"];
                row.value = self.Car["drive_train"].stringValue;
                row.disabled = true;
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "opidi";
                row.title = "OPI / DI";
                row.options = ["OPI","DI"];
                row.value = self.Car["opidi"].stringValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "opidi_done";
                row.title = "OPI / DI Done?"
                row.value = self.Car["opidi_done"].boolValue;
                row.disabled = true;
            }
            <<< DecimalRow(){ row in
                row.tag = "price_total"
                row.title = "Price ($)"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                row.formatter = formatter
                row.value = self.Car["price"]["total"].doubleValue;
                row.disabled = true;
            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "price_payment";
                row.title = "Payment";
                row.options = ["weekly","bi-weekly","monthly"];
                row.value = row.options[0]
                row.value = self.Car["price"]["payment"]["period"].stringValue;
                row.disabled = true;
            }
            <<< DecimalRow(){ row in
                row.tag = "price_payment_total"
                row.title = "Payment Price ($)"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                row.formatter = formatter
                row.value = self.Car["price"]["payment"]["total"].doubleValue;
                row.disabled = true;
            }
            <<< DateRow(){ row in
                row.tag = "arrival";
                row.title = "Date of Arrival"
                if (self.Car["arrival"] != JSON.null) {
                    row.value = Formatter().ParseMomentDate(self.Car["arrival"].stringValue);
                }
                row.disabled = true;
            }
            <<< DateRow(){ row in
                row.tag = "delivery";
                row.title = "Date of Delivery"
                if (self.Car["delivery"] != JSON.null) {
                    row.value = Formatter().ParseMomentDate(self.Car["delivery"].stringValue);
                }
                row.disabled = true;
            }
            <<< MultipleSelectorRow<String>{ row in
                row.tag="advertising";
                row.title = "Advertising";
                row.options = ["kijiji", "autotrader", "aws"];
                var values: Set<String> = [];
                for (_,obj):(String,JSON) in self.Car["advertising"] {
                    values.insert(obj.stringValue);
                }
                row.value = values;
                row.disabled = true;
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(Add_InventoryVC.multipleSelectorDone(_:)))
                }
            <<< SwitchRow(){ row in
                row.tag = "pictures_taken";
                row.title = "Pictures Taken?"
                row.value = self.Car[row.tag!].bool;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "detailing_done";
                row.title = "Detailing Done?"
                row.value = self.Car[row.tag!].bool;
                row.disabled = true;
            }
        animateScroll = true
        rowKeyboardSpacing = 20
    }
}
