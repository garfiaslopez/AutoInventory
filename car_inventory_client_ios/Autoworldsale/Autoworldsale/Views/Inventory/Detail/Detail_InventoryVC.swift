//
//  Detail_InventoryVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/23/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import SwiftyJSON
import Material

class Detail_InventoryVC: UIViewController, TabBarDelegate, UpdateNewObject {
    
    var Car:JSON = JSON();
    var buttons = [TabItem]()
    
    var generalVC : UIViewController?
    var statusVC : UIViewController?
    var bodyVC : UIViewController?

    private var activeViewController : UIViewController?{
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    @IBOutlet weak var contentVC: UIView!
    @IBOutlet weak var categoriesBar: TabBar!
    @IBOutlet weak var carPhoto: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var pdfButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "aws" +  self.Car["folio"].stringValue + " - " + self.Car["model"].stringValue;
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.generalVC = storyboard.instantiateViewController(withIdentifier: "General_Detail_InventoryVC");
        self.statusVC = storyboard.instantiateViewController(withIdentifier: "Status_Detail_InventoryVC");
        self.bodyVC = storyboard.instantiateViewController(withIdentifier: "Body_Detail_InventoryVC");

        if let vc = self.generalVC as? General_Detail_InventoryVC {
            vc.Car = self.Car;
        }
        if let vc = self.statusVC as? Status_Detail_InventoryVC {
            vc.Car = self.Car;
        }
        if let vc = self.bodyVC as? Body_Detail_InventoryVC {
            vc.Car = self.Car;
        }
        
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil; // get previous view
            previousVC?.title = "" // or previousVC?.title = "Back"
        }
        prepareButtons();
        prepareTabBar();
    }
    
    func updateObject(obj: JSON) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func printCar(_ sender: Any) {
        let bundle = Bundle.main;
        let nib = UINib(nibName: "Paper", bundle: bundle)
        let paperView = nib.instantiate(withOwner: self, options: nil)[0] as? PaperView;
        
        paperView?.paymentLabel.text = self.Car["price"]["payment"]["period"].stringValue;
        paperView?.paymentTotalLabel.text = Formatter().Currency.string(from: self.Car["price"]["payment"]["total"].numberValue)!;
        paperView?.totalLabel.text = "Price: " + Formatter().Currency.string(from: self.Car["price"]["total"].numberValue)!;
        paperView?.makeLabel.text = "Make: " + self.Car["make"].stringValue;
        paperView?.modelLabel.text = "Model: " + self.Car["model"].stringValue;
        paperView?.kmLabel.text = "KM: \(self.Car["kilometers"].doubleValue)";
        paperView?.stockLabel.text = "Stock #: aws\(self.Car["folio"].stringValue)";
        
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "AutoworldSales"
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = paperView!.toImage()
        printController.present(animated: true, completionHandler: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gdi = segue.destination as? General_Detail_InventoryVC {
            gdi.Car = self.Car;
        }
        if let nc = segue.destination as? UINavigationController {
            print("NavigationController");
            if let vc = nc.topViewController as? Add_InventoryVC {
                print("Add_InventoryVC");
                vc.isEditingCar = true;
                vc.Car = self.Car;
                vc.delegate = self;
            }
        }
    }
    
    func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        print("will select")
        switch tabItem.tag {
        case 0:
            self.activeViewController = self.generalVC;
        case 1:
            self.activeViewController = self.statusVC;
        case 2:
            self.activeViewController = self.bodyVC;
        default:
            self.activeViewController = self.generalVC;
        }
    }
    
}

extension Detail_InventoryVC {
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inactiveVC = inactiveViewController {
            inactiveVC.willMove(toParentViewController: nil)
            inactiveVC.view.removeFromSuperview()
            inactiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            activeVC.view.frame = contentVC.bounds;
            UIView.transition(with: activeVC.view, duration: 1, options: .transitionCrossDissolve, animations: {
                self.contentVC.addSubview(activeVC.view)
            } , completion: nil);
            
            activeVC.didMove(toParentViewController: self)
        }
    }
    
    fileprivate func prepareButtons() {
        let sizeImage = CGFloat(20);
        
        let btn1 = TabItem(title: "General", titleColor: Color.blueGrey.base)
        btn1.tag = 0;
        btn1.pulseAnimation = .none
        var img1 = UIImage(named:"general");
        img1 = img1?.resize(toWidth: sizeImage);
        img1 = img1?.resize(toHeight: sizeImage);
        btn1.image = img1;
        
        buttons.append(btn1)
        
        let btn2 = TabItem(title: "Status", titleColor: Color.blueGrey.base)
        btn2.tag = 1;
        btn2.pulseAnimation = .none
        var img2 = UIImage(named:"status");
        img2 = img2?.resize(toWidth: sizeImage);
        img2 = img2?.resize(toHeight: sizeImage);
        btn2.image = img2;

        buttons.append(btn2)
        
        let btn3 = TabItem(title: "Body", titleColor: Color.blueGrey.base)
        btn3.tag = 2;
        btn3.pulseAnimation = .none
        var img3 = UIImage(named:"car");
        img3 = img3?.resize(toWidth: sizeImage)
        img3 = img3?.resize(toHeight: sizeImage)
        btn3.image = img3;
        
        buttons.append(btn3)
    }
    
    fileprivate func prepareTabBar() {
        categoriesBar.delegate = self
        categoriesBar.dividerColor = Color.grey.lighten2
        categoriesBar.dividerAlignment = .top
        categoriesBar.lineColor = Color.blue.base
        categoriesBar.lineAlignment = .top
        categoriesBar.backgroundColor = Color.grey.lighten5
        categoriesBar.tabItems = buttons
    }
}

