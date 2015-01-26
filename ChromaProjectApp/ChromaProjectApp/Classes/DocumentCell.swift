//
//  DocumentCell.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {
	
	@IBOutlet var preview: UIImageView?
	@IBOutlet var nameLabel: UILabel?
	@IBOutlet var infoLabel: UILabel?
	
	var document: ChromaDocument? {
		didSet {
			self.preview?.image = nil
			self.nameLabel?.text = ""
			self.infoLabel?.text = ""
			
			ifNotNil(self.document, self.preview, self.nameLabel, self.infoLabel) {
				document, preview, nameLabel, infoLabel in
				
				// TODO: update cell ui
			}
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

}
