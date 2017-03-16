//
//  DetailViewController.swift
//  master detail test
//
//  Created by DPlatov on 3/16/17.
//  Copyright © 2017 dplatov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView:UIImageView!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if (self.detailDescriptionLabel != nil) {
                 ///detail.userID?.description
                var name:String
                
                if (detail.firstName != nil) {
                    name = detail.firstName!
                }else{
                    name = ""
                }
                
                if (detail.secondName != nil) {
                    name = name.appending(" ").appending(detail.secondName!)
                }
                
                self.detailDescriptionLabel!.text = name
            }
            
            if (self.emailLabel) != nil {
                emailLabel!.text = detail.email
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeName(_ sender: Any) {
        
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        
    }
    
    @IBAction func mailTo(){
        if let email = self.detailItem?.email {
            if let mailUrl = URL(string: "mailto:".appending(email)) {
                UIApplication.shared.openURL(mailUrl)
            }
        }
    }
    
    var detailItem: MDUser? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

