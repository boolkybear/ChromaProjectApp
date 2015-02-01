//
//  VisibilityBackgroundCell.swift
//  ChromaProjectApp
//
//  Created by Dylvian on 28/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit

class VisibilityBackgroundCell: VisibilityCell {
	
	@IBOutlet var backgroundImage: UIImageView!
	
	override func resetCell() {
		super.resetCell()
		
		self.backgroundImage?.image = nil
	}
	
	override func setVisibleLayer(documentVisibleLayer: DocumentVisibleLayer?) {
		super.setVisibleLayer(documentVisibleLayer)
		
		if let type = documentVisibleLayer?.type
		{
			switch type
			{
			case .Background(let bgImage):
				self.backgroundImage?.image = bgImage
				
			default:
				break
			}
		}
	}
	
}
