//
//  FamilyViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit

class FamilyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (true){ //Do we have contacts already?
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.emptyView.isHidden = true
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        return cell
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
