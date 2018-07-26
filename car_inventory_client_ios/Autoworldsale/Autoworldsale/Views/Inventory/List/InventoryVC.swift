//
//  InventoryListVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/21/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Material
import SwiftyJSON
import Alamofire

class InventoryVC: MainController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var addButton: FABButton!
    @IBOutlet weak var ObjectTableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var searchBarContainerTopLayout: NSLayoutConstraint!
    
    
    let ApiUrl = VARS().getApiUrl();
    var UsuarioEnSesion:Session = Session();
    let Variables = VARS();
    var Objects:Array<JSON> = [];
    var FilteredObjects:Array<JSON> = [];
    var selectedCar:JSON = JSON();
    
    var sort_field = "created";
    var sort_order = -1;
    var search_text = "";

    let searchController = UISearchController(searchResultsController: nil);

    
    override func viewDidLoad() {
        super.viewDidLoad();
        addSlideMenuButton();
        
        addButton.pulseColor = .white;
        addButton.backgroundColor = VARS().PrimaryRed;
        addButton.tintColor = UIColor.white;
        addButton.image = UIImage(named: "add");
        
        let nib = UINib(nibName: "InventoryTableVC", bundle: nil);
        self.ObjectTableView.register(nib, forCellReuseIdentifier: "CustomCell");
        
        // setup searchController
        self.searchController.searchBar.delegate = self;
        self.searchController.obscuresBackgroundDuringPresentation = false;
        self.searchController.searchBar.placeholder = "Search on inventory";
        self.searchController.searchBar.backgroundColor = UIColor.white;
        self.searchController.searchBar.tintColor = VARS().PrimaryRed;
        self.searchController.searchBar.barTintColor = VARS().PrimaryBlue;
    
        self.searchBarContainer.addSubview(self.searchController.searchBar);
        
        definesPresentationContext = true;
        
        self.searchController.resignFirstResponder();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Inventory";
        self.UsuarioEnSesion = Session();
        if(self.UsuarioEnSesion.token == "" && self.UsuarioEnSesion.name == ""){
            self.performSegue(withIdentifier: "LoginSegue", sender: self);
        } else {
            self.ReloadData();
        }
    }
    
    func ReloadData(){
        
        let AuthUrl = Variables.getApiUrl() + "/cars";
        
        let status = Reach().connectionStatus();
        let headers = [
            "Authorization": self.UsuarioEnSesion.token
        ]
        
        var parameters:Parameters = [
            "enterprise_id": VARS().getEnterprise(),
            "is_delivery": false,
            "sort_order": self.sort_order,
            "sort_field": self.sort_field
        ]
        
        if (self.search_text != "") {
            parameters["search_text"] = self.search_text;
        }
        
        switch status {
        case .online(.wwan), .online(.wiFi):
            
            Alamofire.request(AuthUrl,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                if response.result.isSuccess {
                    let data = JSON(data: response.data!);
                    if(data["success"] == true) {
                        if (self.isFiltering()) {
                            self.FilteredObjects = [];
                        } else {
                            self.Objects = [];
                        }
                        for (_,obj):(String,JSON) in data["cars"]["docs"] {
                            if (self.isFiltering()) {
                                self.FilteredObjects.append(obj);
                            } else {
                                self.Objects.append(obj);
                            }
                        }
                        self.totalLabel.text = "Total: \(self.Objects.count)";
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
    
    
    // MARK: - Search view data source
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search_text = searchBar.text!;
        self.ReloadData();
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.FilteredObjects.removeAll();
        self.search_text = "";
        self.ReloadData();
    }
    
    
    

    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.FilteredObjects.count;
        }
        return self.Objects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:InventoryTableVC = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! InventoryTableVC;
        
        
        if isFiltering() {
            cell.idLabel.text = "\(self.FilteredObjects[(indexPath as NSIndexPath).row]["make"].stringValue)";
            cell.brandLabel.text = "\(self.FilteredObjects[(indexPath as NSIndexPath).row]["model"].stringValue)";
            cell.arrivalLabel.text = "\(self.FilteredObjects[(indexPath as NSIndexPath).row]["year"].stringValue)";
            cell.priceLabel.text = "\(self.FilteredObjects[(indexPath as NSIndexPath).row]["kilometers"].stringValue)";
            cell.colorView.backgroundColor = UIColor(hex: self.FilteredObjects[(indexPath as NSIndexPath).row]["color"].stringValue);
        } else {
            cell.idLabel.text = "\(self.Objects[(indexPath as NSIndexPath).row]["make"].stringValue)";
            cell.brandLabel.text = "\(self.Objects[(indexPath as NSIndexPath).row]["model"].stringValue)";
            cell.arrivalLabel.text = "\(self.Objects[(indexPath as NSIndexPath).row]["year"].stringValue)";
            cell.priceLabel.text = "\(self.Objects[(indexPath as NSIndexPath).row]["kilometers"].stringValue)";
            cell.colorView.backgroundColor = UIColor(hex: self.Objects[(indexPath as NSIndexPath).row]["color"].stringValue);
        }
        let colorVal = self.Objects[(indexPath as NSIndexPath).row]["color"].stringValue;
        if ( colorVal == "#FFFFFF" || colorVal == "#ffffff" || colorVal == "#FFFFFFFF") {
            cell.colorView.layer.borderColor = UIColor.black.cgColor;
            cell.colorView.layer.borderWidth = 1.5;
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if (!isFiltering()) {
            let deleteButton = UITableViewRowAction(style: .default, title: "Delivered", handler: { (action, indexPath) in
                self.ObjectTableView.dataSource?.tableView!(self.ObjectTableView, commit: .delete, forRowAt: indexPath);
                return
            })
            deleteButton.backgroundColor = UIColor(hex: "#8BC34A");
            return [deleteButton]
        }
        return nil;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = self.Objects[(indexPath as NSIndexPath).row]["_id"].stringValue
            let Url = Variables.getApiUrl() + "/car/" + id;
            let status = Reach().connectionStatus();
            let headers = [
                "Authorization": self.UsuarioEnSesion.token
            ]
            let DatatoSend: Parameters = [
                "delivery": Date().forServer,
                "is_delivery": true
            ];
            
            switch status {
            case .online(.wwan), .online(.wiFi):
                Alamofire.request(Url, method: .put, parameters: DatatoSend, encoding: JSONEncoding.default,  headers: headers).responseJSON { response in
                    if response.result.isSuccess {
                        let data = JSON(data: response.data!);
                        if(data["success"] == true) {
                            self.alerta(data["message"].stringValue, Mensaje: "");
                            self.ReloadData();
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.isFiltering()){
            self.selectedCar = self.FilteredObjects[(indexPath as NSIndexPath).row];
        } else {
            self.selectedCar = self.Objects[(indexPath as NSIndexPath).row];
        }
        self.performSegue(withIdentifier: "detail_inventory_segue", sender: self);
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? Detail_InventoryVC {
            segue.Car = self.selectedCar;
        }
    }
    
    
    
    @IBAction func displaySearch(_ sender: Any) {
        self.searchController.searchBar.becomeFirstResponder();
    }
    
    @IBAction func displaySort(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "Sort by:", preferredStyle: .actionSheet);
        let makeAction = UIAlertAction(title: "Make", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (self.sort_field == "make") {
                if self.sort_order == 1 {
                    self.sort_order = -1;
                } else {
                    self.sort_order = 1;
                }
            } else {
                self.sort_order = -1;
            }
            self.sort_field = "make";
            self.ReloadData();
        });
        let modelAction = UIAlertAction(title: "Model", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (self.sort_field == "model") {
                if self.sort_order == 1 {
                    self.sort_order = -1;
                } else {
                    self.sort_order = 1;
                }
            } else {
                self.sort_order = -1;
            }
            self.sort_field = "model";
            self.ReloadData();
        });
        let yearAction = UIAlertAction(title: "Year", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (self.sort_field == "year") {
                if self.sort_order == 1 {
                    self.sort_order = -1;
                } else {
                    self.sort_order = 1;
                }
            } else {
                self.sort_order = -1;
            }
            self.sort_field = "year";
            self.ReloadData();
        });
        let kmAction = UIAlertAction(title: "Kilometers", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (self.sort_field == "kilometers") {
                if self.sort_order == 1 {
                    self.sort_order = -1;
                } else {
                    self.sort_order = 1;
                }
            } else {
                self.sort_order = -1;
            }
            self.sort_field = "kilometers";
            self.ReloadData();
        });
        let createdAction = UIAlertAction(title: "Created", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (self.sort_field == "created") {
                if self.sort_order == 1 {
                    self.sort_order = -1;
                } else {
                    self.sort_order = 1;
                }
            } else {
                self.sort_order = -1;
            }
            self.sort_field = "created";
            self.ReloadData();
        });
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        });
        optionMenu.addAction(makeAction);
        optionMenu.addAction(modelAction);
        optionMenu.addAction(yearAction);
        optionMenu.addAction(kmAction);
        optionMenu.addAction(createdAction);
        optionMenu.addAction(cancelAction);
        
        self.present(optionMenu, animated: true, completion: nil);
    }
    
    func alerta(_ Titulo:String,Mensaje:String) {
        let alertController = UIAlertController(title: Titulo, message:
            Mensaje, preferredStyle: UIAlertControllerStyle.alert);
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil));
        self.present(alertController, animated: true, completion: nil);
    }
    
}

