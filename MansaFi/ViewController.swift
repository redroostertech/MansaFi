//
//  ViewController.swift
//  MansaFi
//
//  Created by Michael Westbrooks II on 12/16/17.
//  Copyright © 2017 RedRooster Technologies Inc. All rights reserved.
//

import UIKit
import LinkKit

class ViewController: UIViewController, PLKPlaidLinkViewDelegate {
    
    @IBOutlet var loginButton: UIButton!
    
    var linkConfigurationFromAppDelegate: PLKConfiguration! {
        didSet {
            print("Configurationfrom delegate was set")
            self.loginButton.isEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveNotification(_:)), name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func didReceiveNotification(_ notification: NSNotification) {
        if notification.name.rawValue == "PLDPlaidLinkSetupFinished" {
            NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.linkConfigurationFromAppDelegate = appDelegate.LinkConfiguration
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfigurationFromAppDelegate, delegate: linkViewDelegate)
        present(linkViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //  MARK:- PLKPlaid delegates.
    //  Metadata is important because it gives you information about what the heck is going on during the login flow. 
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        self.dismiss(animated: true) {
            UserDefaults.standard.set(publicToken, forKey: "uToken")
            self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
            //  print("Success:", publicToken, metadata)
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        self.dismiss(animated: true) {
            //  print("Error:", error, metadata)
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
        //  print("Event:",event, metadata)
    }
}

