//
//  SectionCourseTableViewCell.swift
//  NewE-learning
//
//  Created by admsup on 2015/9/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit

class SectionCourseTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var SelectImageView : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
