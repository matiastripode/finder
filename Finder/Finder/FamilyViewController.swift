//
//  FamilyViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit
import Alamofire

class FamilyViewController: UITableViewController {
    
    var array: [FamilyMember] = []

    let kFamilyMemberIdentifier = "cell"
    var isEmpty = true
    
    override func viewDidLoad() {
        
//        self.tableView.register(FamilyMemberCell.self, forCellReuseIdentifier: kFamilyMemberIdentifier)

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
        
        var cell: UITableViewCell? = nil
        
        if (isEmpty) {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell")
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "EmptyCell")
            }

        } else {
            
            let member = self.array[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            }
            
            //placeholder
            cell?.imageView?.image = UIImage(named: "placeholder")
            cell?.textLabel?.text = member.name
            
            if let url = NSURL(string:member.image_url) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        cell?.imageView?.image = UIImage(data: data!)
                    }
                }
            }
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if (isEmpty) {
            self.performSegue(withIdentifier: "addPerson", sender: nil)
        } else {
            self.performSegue(withIdentifier: "seePerson", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "findResults") {
            if let viewController = segue.destination as? FindResultViewController {
                // Call kairos
            }
        }
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
