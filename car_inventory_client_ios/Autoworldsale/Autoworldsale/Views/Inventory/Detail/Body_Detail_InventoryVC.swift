//
//  Body_Detail_InventoryVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/25/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import SwiftyJSON
import Eureka
import ViewRow

class Body_Detail_InventoryVC: FormViewController {

    var Car:JSON = JSON();

    override func viewDidLoad() {
        super.viewDidLoad()

        form
            +++ Section("Body")
            <<< SwitchRow(){ row in
                row.tag = "scratches";
                row.title = "Without Scratches?"
                row.value = self.Car["scratches"].boolValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "dent";
                row.title = "Without Dents?"
                row.value = self.Car["dent"].boolValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "lights";
                row.title = "Lights are ok?"
                row.value = self.Car["lights"].boolValue;
                row.disabled = true;
            }
            <<< SwitchRow(){ row in
                row.tag = "wheels";
                row.title = "Wheels are ok?"
                row.value = self.Car["wheels"].boolValue;
                row.disabled = true;
            }
            <<< ViewRow<Size_TiresV>("tire_size") { (row) in
                row.title = "Tire Size";
            }.cellSetup { (cell, row) in
                let bundle = Bundle.main;
                let nib = UINib(nibName: "Size_TiresV", bundle: bundle)
                cell.view = nib.instantiate(withOwner: self, options: nil)[0] as? Size_TiresV
                cell.view!.backgroundColor = cell.backgroundColor
                cell.view?.frame.size.height = 46;

                if (self.Car["tire_size"] != JSON.null) {
                    cell.view?.firstTextfield.text = self.Car["tire_size"]["first"].stringValue;
                    cell.view?.secondTextfield.text = self.Car["tire_size"]["second"].stringValue;
                    cell.view?.thirdTextfield.text = self.Car["tire_size"]["third"].stringValue;
                }
                cell.view?.firstTextfield.isUserInteractionEnabled = false;
                cell.view?.secondTextfield.isUserInteractionEnabled = false;
                cell.view?.thirdTextfield.isUserInteractionEnabled = false;
            }
            +++ Section("Notes")
            <<< TextAreaRow() { row in
                row.tag = "notes";
                row.value = self.Car["notes"].stringValue;
                row.disabled = true;
        }
        
        animateScroll = true
        rowKeyboardSpacing = 20
    }

    func reloadView() {
        Section("Body").reload();
    }
    
}
