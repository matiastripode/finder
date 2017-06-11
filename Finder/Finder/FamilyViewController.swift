//
//  FamilyViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit
import Alamofire

class FamilyViewController: UITableViewController, FamilyMemberCellDelegate {
    
    var array: [FamilyMember] = []

    let kFamilyMemberIdentifier = "cell"
    var isEmpty = true
    
    override func viewDidLoad() {
        
        NotificationManager.shared.listen((UserManager.shared.currentUser?.phone)!, success: { (result) in
            
            // Turn remote led on
            NotificationManager.shared.notifyLed()

            // Remove notification once receive it
            NotificationManager.shared.remove((UserManager.shared.currentUser?.phone)!)
            
            let notification = UILocalNotification()
            notification.alertBody = "Someone found your family member. You can reach that person at \(result.phone)"
            notification.alertAction = "open"
            notification.fireDate = Date() + 5
            UIApplication.shared.scheduleLocalNotification(notification)
            
            
            
            let alertController = UIAlertController(title: "Good news", message: "Someone found your family member. You can reach that person at \(result.phone)", preferredStyle: .alert)
            
            let cameraAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                
                self.performSegue(withIdentifier: "seePerson", sender: result)
            }
            alertController.addAction(cameraAction)
            
            self.present(alertController, animated: true) {
                
            }

            //}
            
        }) { (error) in
            print("error")
        }

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        UserManager.shared.getFamily()
        
        if let family = UserManager.shared.currentUser?.family{
            self.array = family
            isEmpty = self.array.count == 0
        } else {
            isEmpty = true
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEmpty {
            return 170
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (isEmpty) {
            return 1
        }
        
        return self.array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:FamilyMemberCell? = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as? FamilyMemberCell
        
        if (isEmpty) {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as? FamilyMemberCell
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "EmptyCell") as? FamilyMemberCell
            }

        } else {
            
           let member = self.array[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? FamilyMemberCell
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell") as? FamilyMemberCell
            }
            
            cell?.delegate = self
            //placeholder
            cell?.memberImageView.image = UIImage(named: "placeholder")
            cell?.nameLabel.text = member.name
            
            // Let's keep track of the index in our data source
            cell?.cellIndex = indexPath.row

            if let url = NSURL(string:member.image_url) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        cell?.memberImageView?.image = UIImage(data: data!)
                    }
                }
            }
            
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if (isEmpty) {
            self.performSegue(withIdentifier: "addPerson", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "seePerson" && sender != nil){
            if let send = sender as? RecieveNotificationResult {
                if let viewController = segue.destination as? FindResultViewController {

                    viewController.phone = send.phone
                    
                }
            }
        }
    }
    
    func changeReportStatus(cellIndex: Int) {
        print("Cell index: \(cellIndex)")
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
