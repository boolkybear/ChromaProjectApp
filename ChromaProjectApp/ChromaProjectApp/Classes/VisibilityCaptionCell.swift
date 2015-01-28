//
//  VisibilityCaptionCell.swift
//  ChromaProjectApp
//
//  Created by Dylvian on 28/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit

class VisibilityCaptionCell: VisibilityCell {

	@IBOutlet var captionLabel: UILabel!
	
	override func resetCell() {
		super.resetCell()
		
		self.captionLabel?.text = ""
	}
	
	override func setVisibleLayer(documentVisibleLayer: DocumentVisibleLayer?) {
		super.setVisibleLayer(documentVisibleLayer)
		
		if let type = documentVisibleLayer?.type
		{
			switch type
			{
			case .Caption(let captionString):
				self.captionLabel?.text = captionString ?? ""
				
			default:
				break
			}
		}
	}
}
