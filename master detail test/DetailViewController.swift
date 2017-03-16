//
//  DetailViewController.swift
//  master detail test
//
//  Created by DPlatov on 3/16/17.
//  Copyright © 2017 dplatov. All rights reserved.
//

import UIKit
import SDWebImage


class DetailViewController: UIViewController, UITextFieldDelegate {

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
                
                if let emailHash = detail.email?.md5String() {
                    let urlString = "https://gravatar.com/avatar/".appending(emailHash)
                    
                    avatarImageView.sd_setImage(with: NSURL(string: urlString) as URL?)
                }
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
        if let detail = self.detailItem {
            
            let alert = UIAlertController(title: "Edit name", message: "Enter new name", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.delegate = self
                textField.placeholder = "First name"
                textField.text = detail.firstName
            }
            
            alert.addTextField { (textField) in
                textField.placeholder = "Second name"
                textField.text = detail.secondName
            }
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                detail.firstName = alert.textFields?.first?.text
                detail.secondName = alert.textFields?.last?.text
                
                MDDataController.sharedDataController.saveContext()
                self.configureView()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        if let detail = self.detailItem {
            
            let alert = UIAlertController(title: "Edit email", message: "Enter new email", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.delegate = self
                textField.placeholder = "email"
                textField.text = detail.email
            }
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                detail.email = alert.textFields?.first?.text
                
                MDDataController.sharedDataController.saveContext()
                self.configureView()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func mailTo(){
        if let email = self.detailItem?.email {
            if let mailUrl = URL(string: "mailto:".appending(email)) {
                UIApplication.shared.openURL(mailUrl)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    var detailItem: MDUser? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

