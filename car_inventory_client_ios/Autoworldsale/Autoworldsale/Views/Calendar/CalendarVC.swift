//
//  CalendarVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/21/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FSCalendar

class CalendarVC: MainController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate  {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var ObjectTableView: UITableView!
    
    let ApiUrl = VARS().getApiUrl();
    var UsuarioEnSesion:Session = Session();
    let Format = Formatter();
    let Variables = VARS();
    var Objects:Array<JSON> = [];
    var selectedObject:JSON!;
    var selectedDate:Date = Date();
    var DateHistogram:[String:Int] = [:];
    
    var sort_field = "created";
    var sort_order = -1;
    var search_text = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton();
        
        let nib = UINib(nibName: "ReminderTableVC", bundle: nil);
        self.ObjectTableView.register(nib, forCellReuseIdentifier: "CustomCell");
        
        self.selectedDate = self.Format.Today();
        self.ReloadDataDates();
        
        self.calendarView.locale = .current;
    }

    override func viewDidAppear(_ animated: Bool) {
        self.title = "Reminders";
        self.UsuarioEnSesion = Session();
        if(self.UsuarioEnSesion.token == "" && self.UsuarioEnSesion.name == ""){
            self.performSegue(withIdentifier: "LoginSegue", sender: self);
        } else {
            self.ReloadData();
        }
    }
    
    func ReloadDataDates(){
        
        let AuthUrl = Variables.getApiUrl() + "/pendings/agg";
        
        let status = Reach().connectionStatus();
        let headers = [
            "Authorization": self.UsuarioEnSesion.token
        ]
        
        let parameters:Parameters = [
            "enterprise_id": VARS().getEnterprise(),
            "is_done": false,
            "agg": "date",
            "timezone": TimeZone.current.identifier
        ];
        
        switch status {
        case .online(.wwan), .online(.wiFi):
            
            Alamofire.request(AuthUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                if response.result.isSuccess {
                    let data = JSON(data: response.data!);
                    if(data["success"] == true){
                        self.DateHistogram = [:];
                        for (_,obj):(String,JSON) in data["data"] {
                            self.DateHistogram[obj["_id"]["date"].stringValue] = obj["total"].intValue;
                        }
                        self.calendarView.reloadData();
                    }else{
                        self.alerta("Oops!", Mensaje: data["message"].stringValue );
                    }
                }else{
                    self.alerta("Oops!", Mensaje: (response.result.error?.localizedDescription)!);
                }
            }
        case .unknown, .offline:
            self.alerta("Oops!", Mensaje: "Favor de conectarse a internet");
        }
    }

    func ReloadData() {
        
        let AuthUrl = Variables.getApiUrl() + "/pendings";
        
        let status = Reach().connectionStatus();
        let headers = [
            "Authorization": self.UsuarioEnSesion.token
        ]
        
        let dateS = self.Format.DateOnly.string(from: self.selectedDate);
        let dateSF = self.Format.DateOnly.string(from: self.selectedDate.addDays(1));
        let parameters:Parameters = [
            "enterprise_id": VARS().getEnterprise(),
            "is_done": false,
            "initial_date": self.Format.DateOnly.date(from: dateS)?.forServer ?? "",
            "final_date": self.Format.DateOnly.date(from: dateSF)?.forServer ?? ""
        ];
        
        switch status {
        case .online(.wwan), .online(.wiFi):
            Alamofire.request(AuthUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if response.result.isSuccess {
                    let data = JSON(data: response.data!);
                    if(data["success"] == true){
                        self.Objects = [];
                        for (_,obj):(String,JSON) in data["pendings"]["docs"] {
                            self.Objects.append(obj);
                        }
                        self.ObjectTableView.reloadData();
                    }else{
                        self.alerta("Oops!", Mensaje: data["message"].stringValue );
                    }
                }else{
                    self.alerta("Oops!", Mensaje: (response.result.error?.localizedDescription)!);
                }
            }
        case .unknown, .offline:
            self.alerta("Oops!", Mensaje: "Favor de conectarse a internet");
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateOnly = Format.DateOnly.string(from: date);
        if let events = self.DateHistogram[dateOnly] {
            return events;
        }
        return 0;
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date;
        self.ReloadData();
    }
    
    
    
    /// TABLE VIEw METHODS
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.Format.DatePrettyCanadian.string(from: self.selectedDate))";
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Objects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReminderTableVC = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ReminderTableVC;
        
        if (self.Objects[(indexPath as NSIndexPath).row]["car_id"] == JSON.null) {
            cell.reminderLabel.text = "\(self.Objects[(indexPath as NSIndexPath).row]["denomination"].stringValue)";
        } else {
            let folio = self.Objects[(indexPath as NSIndexPath).row]["car_id"]["folio_text"].stringValue;
            let make = self.Objects[(indexPath as NSIndexPath).row]["car_id"]["make"].stringValue;
            let brand = self.Objects[(indexPath as NSIndexPath).row]["car_id"]["brand"].stringValue;
            let year = self.Objects[(indexPath as NSIndexPath).row]["car_id"]["year"].stringValue;
            let model = self.Objects[(indexPath as NSIndexPath).row]["car_id"]["model"].stringValue;
            let km = self.Objects[(indexPath as NSIndexPath).row]["car_id"]["kilometers"].stringValue;
            cell.reminderLabel.text = "Deliver car \(folio) - make: \(make), brand: \(brand), model: \(model), km: \(km) and year: \(year)";
        }
        let stringDate = self.Objects[(indexPath as NSIndexPath).row]["date"].stringValue;
        let dt = Formatter().ParseMomentDate(stringDate);
        let datePretty = Formatter().DatePretty.string(from: dt);
        cell.dateLabel.text = "\(datePretty)";

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedObject = self.Objects[(indexPath as NSIndexPath).row];
        self.performSegue(withIdentifier: "detail_reminder_segue", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? Detail_ReminderVC {
            segue.Object = self.selectedObject;
        }
    }
    
    
    func alerta(_ Titulo:String,Mensaje:String){
        let alertController = UIAlertController(title: Titulo, message:
            Mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
