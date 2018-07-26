//
//  MenuViewController.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/20/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var UsuarioEnSesion:Session = Session();

    @IBOutlet var tblMenuOptions : UITableView!
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    @IBOutlet var nameLabel : UILabel!

    var arrayMenuOptions = [Dictionary<String,String>]()
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.UsuarioEnSesion = Session();
        self.nameLabel.text = self.UsuarioEnSesion.name;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"Inventory", "icon":"car"])
        arrayMenuOptions.append(["title":"Calendar", "icon":"calendar"])
        arrayMenuOptions.append(["title":"Reminders", "icon":"notification"])
        arrayMenuOptions.append(["title":"Tires Inventory", "icon":"wheel"])
        arrayMenuOptions.append(["title":"Logout", "icon":"logout"])

        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        if let lblTitle = cell.contentView.viewWithTag(101) as? UILabel {
            lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        }
        
        if let imgIcon = cell.contentView.viewWithTag(100) as? UIImageView {
            imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

}
