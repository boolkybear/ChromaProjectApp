//
//  VisibilityCell.swift
//  ChromaProjectApp
//
//  Created by Dylvian on 28/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit

typealias VisibilityChangeHandler = (Bool) -> Void

class VisibilityCell: UITableViewCell {
	
	@IBOutlet var visibleSwitch: UISwitch?
	
	var changeHandler: VisibilityChangeHandler?
	var visibleLayer: DocumentVisibleLayer? {
		didSet {
			self.resetCell()
			self.setVisibleLayer(self.visibleLayer)
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func resetCell()
	{
	}

	func setVisibleLayer(documentVisibleLayer: DocumentVisibleLayer?)
	{
		self.visibleSwitch?.on = documentVisibleLayer?.isVisible ?? true
	}
}

// Actions
extension VisibilityCell
{
	@IBAction func visibleSwitchChanged(sender: UISwitch) {
		self.changeHandler?(sender.on)
	}
}