//
//  TiresListVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/23/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON

class TiresVC: MainController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var addButton: FABButton!
    @IBOutlet weak var ObjectTableView: UITableView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    let ApiUrl = VARS().getApiUrl();
    var UsuarioEnSesion:Session = Session();
    let Variables = VARS();
    var Objects:Array<JSON> = [];
    var FilteredObjects:Array<JSON> = [];
    var selectedTire:JSON = JSON();

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
        
        
        let nib = UINib(nibName: "TireTableVC", bundle: nil);
        self.ObjectTableView.register(nib, forCellReuseIdentifier: "CustomCell");
        
        // setup searchController
        self.searchController.searchBar.delegate = self;
        self.searchController.obscuresBackgroundDuringPresentation = false;
        self.searchController.searchBar.placeholder = "Search on tires";
        self.searchController.searchBar.backgroundColor = UIColor.white;
        self.searchController.searchBar.tintColor = VARS().PrimaryRed;
        self.searchController.searchBar.barTintColor = VARS().PrimaryBlue;
        
        self.searchBarContainer.addSubview(self.searchController.searchBar);
        
        definesPresentationContext = true;
        
        self.searchController.resignFirstResponder();
    }
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Tires";
        self.UsuarioEnSesion = Session();
        if(self.UsuarioEnSesion.token == "" && self.UsuarioEnSesion.name == ""){
            self.performSegue(withIdentifier: "LoginSegue", sender: self);
        } else {
            self.ReloadData();
        }
    }
    
    func ReloadData(){
        
        let AuthUrl = Variables.getApiUrl() + "/tires";
        
        let status = Reach().connectionStatus();
        let headers = [
            "Authorization": self.UsuarioEnSesion.token
        ]
        
        var parameters:Parameters = [
            "enterprise_id": VARS().getEnterprise(),
            "sort_order": self.sort_order,
            "sort_field": self.sort_field
        ]
        
        if (self.search_text != "") {
            parameters["search_text"] = self.search_text;
        }
        
        switch status {
        case .online(.wwan), .online(.wiFi):
            
            Alamofire.request(AuthUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                if response.result.isSuccess {
                    let data = JSON(data: response.data!);
                    if(data["success"] == true){
                        if (self.isFiltering()) {
                            self.FilteredObjects = [];
                        } else {
                            self.Objects = [];
                        }
                        for (_,obj):(String,JSON) in data["tires"]["docs"] {
                            if (self.isFiltering()) {
                                self.FilteredObjects.append(obj);
                            } else {
                                self.Objects.append(obj);
                            }
                        }
                        print(self.Objects);
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if (!isFiltering()) {
            let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
                self.ObjectTableView.dataSource?.tableView!(self.ObjectTableView, commit: .delete, forRowAt: indexPath);
                return
            })
            deleteButton.backgroundColor = VARS().PrimaryRed;
            return [deleteButton]
        }
        return nil;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = self.Objects[(indexPath as NSIndexPath).row]["_id"].stringValue
            let Url = Variables.getApiUrl() + "/tire/" + id;
            let status = Reach().connectionStatus();
            let headers = [
                "Authorization": self.UsuarioEnSesion.token
            ]
            
            switch status {
            case .online(.wwan), .online(.wiFi):
                Alamofire.request(Url, method: .delete, encoding: JSONEncoding.default,  headers: headers).responseJSON { response in
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TireTableVC = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TireTableVC;
        
        if isFiltering() {
            let first = self.FilteredObjects[(indexPath as NSIndexPath).row]["size"]["first"].stringValue;
            let second = self.FilteredObjects[(indexPath as NSIndexPath).row]["size"]["second"].stringValue;
            let third = self.FilteredObjects[(indexPath as NSIndexPath).row]["size"]["third"].stringValue;
            cell.sizeLabel.text = "\(first) / \(second) R \(third)";
            cell.stockLabel.text = "\(self.FilteredObjects[(indexPath as NSIndexPath).row]["stock"].numberValue)";
        } else {
            let first = self.Objects[(indexPath as NSIndexPath).row]["size"]["first"].stringValue;
            let second = self.Objects[(indexPath as NSIndexPath).row]["size"]["second"].stringValue;
            let third = self.Objects[(indexPath as NSIndexPath).row]["size"]["third"].stringValue;
            cell.sizeLabel.text = "\(first) / \(second) R \(third)";
            cell.stockLabel.text = "\(self.Objects[(indexPath as NSIndexPath).row]["stock"].numberValue)";
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.isFiltering()){
            self.selectedTire = self.FilteredObjects[(indexPath as NSIndexPath).row];
        } else {
            self.selectedTire = self.Objects[(indexPath as NSIndexPath).row];
        }
        self.performSegue(withIdentifier: "detail_tire_segue", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? Detail_TireVC {
            segue.Tire = self.selectedTire;
        }
    }
    
    @IBAction func displaySearch(_ sender: Any) {
        self.searchController.searchBar.becomeFirstResponder();
    }
    
    @IBAction func displaySort(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "Sort by:", preferredStyle: .actionSheet);
        let sizeAction = UIAlertAction(title: "Size", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (self.sort_field == "size.third") {
                if self.sort_order == 1 {
                    self.sort_order = -1;
                } else {
                    self.sort_order = 1;
                }
            } else {
                self.sort_order = -1;
            }
            self.sort_field = "size.third";
            self.ReloadData();
        });
        let stockAction = UIAlertAction(title: "Stock", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (self.sort_field == "stock") {
                if self.sort_order == 1 {
                    self.sort_order = -1;
                } else {
                    self.sort_order = 1;
                }
            } else {
                self.sort_order = -1;
            }
            self.sort_field = "stock";
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
        optionMenu.addAction(sizeAction);
        optionMenu.addAction(stockAction);
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
