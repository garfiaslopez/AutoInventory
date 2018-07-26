//
//  Detail_TireVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 2/2/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Eureka
import ViewRow
import SwiftyJSON

class Detail_TireVC: FormViewController, UpdateNewObject{
    
    var Tire:JSON!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.Tire["brand"].stringValue;
        
        
        form
            +++ Section("General")
            <<< TextRow(){ row in
                row.tag = "brand";
                row.title = "Brand"
                row.disabled = true;
                row.value = self.Tire[row.tag!].stringValue;
            }
            <<< ViewRow<Size_TiresV>("size") { (row) in
                row.title = "Size";
                row.disabled = true;
                }
                .cellSetup { (cell, row) in
                    let bundle = Bundle.main;
                    let nib = UINib(nibName: "Size_TiresV", bundle: bundle)
                    cell.view = nib.instantiate(withOwner: self, options: nil)[0] as? Size_TiresV
                    cell.view!.backgroundColor = cell.backgroundColor
                    cell.view?.firstTextfield.text = self.Tire["size"]["first"].stringValue;
                    cell.view?.secondTextfield.text = self.Tire["size"]["second"].stringValue;
                    cell.view?.thirdTextfield.text = self.Tire["size"]["third"].stringValue;
                    
                    cell.view?.firstTextfield.isUserInteractionEnabled = false;
                    cell.view?.secondTextfield.isUserInteractionEnabled = false;
                    cell.view?.thirdTextfield.isUserInteractionEnabled = false;

            }
            <<< PickerInputRow<String>() { (row : PickerInputRow<String>) -> Void in
                row.tag = "season";
                row.title = "Season";
                row.options = ["all-season","winter"];
                row.disabled = true;
                row.value = self.Tire[row.tag!].stringValue;
            }
            <<< DecimalRow(){ row in
                row.tag = "stock"
                row.title = "How many?"
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .none
                row.formatter = formatter
                row.disabled = true;
                row.value = self.Tire[row.tag!].doubleValue;
        }
        
        animateScroll = true
        rowKeyboardSpacing = 20
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController {
            if let vc = nc.topViewController as? Add_TiresVC {
                print("Add_TiresVC");
                vc.isEditingTire = true;
                vc.Tire = self.Tire;
                vc.delegate = self;
            }
        }
    }
    
    func updateObject(obj: JSON) {
        self.navigationController?.popViewController(animated: true);
    }

}
