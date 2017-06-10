//
//  FamilyMemberCell.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit

protocol FamilyMemberCellDelegate {
    func changeReportStatus(cellIndex: Int)
}


class FamilyMemberCell: UITableViewCell {

    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var statusButton: UIButton!
    
    var cellIndex: Int?
    
    // MARK:- Delegate
    var delegate:FamilyMemberCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData (member: FamilyMember) {
        self.memberImageView.image = member.image
        self.nameLabel.text = member.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapReportButton(_ sender: Any) {
        
        if let _: Int = self.cellIndex {
            self.delegate?.changeReportStatus(cellIndex: self.cellIndex!)

        }
    }

}
