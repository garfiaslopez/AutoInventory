//
//  Detail_ReminderVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/23/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Eureka
import ViewRow
import SwiftyJSON

class Detail_ReminderVC: FormViewController, UpdateNewObject {

    var Object:JSON!;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Reminder";
        
        form
            +++ Section("What do you need to remember?")
            <<< TextAreaRow(){ row in
                row.tag = "denomination"
                row.disabled = true;
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
            +++ Section("I will remind you on...")
            <<< DateRow(){ row in
                row.tag = "date";
                row.title = "Date"
                row.disabled = true;
                row.value = Formatter().ParseMomentDate(self.Object["date"].stringValue);

        }
        animateScroll = true
        rowKeyboardSpacing = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController {
            if let vc = nc.topViewController as? Add_ReminderVC {
                print("Add_ReminderVC");
                vc.isEditingObject = true;
                vc.Object = self.Object;
                vc.delegate = self;
            }
        }
    }
    
    func updateObject(obj: JSON) {
        self.navigationController?.popViewController(animated: true);
    }
    

}
