//
//  VisibilityLayerCell.swift
//  ChromaProjectApp
//
//  Created by Dylvian on 28/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit

class VisibilityLayerCell: VisibilityCell {

	@IBOutlet var layerImage: UIImageView!
	@IBOutlet var chromaColorView: UIView!
	
	override func resetCell() {
		super.resetCell()
		
		self.layerImage?.image = nil
		self.chromaColorView?.backgroundColor = UIColor.clearColor()
	}
	
	override func setVisibleLayer(documentVisibleLayer: DocumentVisibleLayer?) {
		super.setVisibleLayer(documentVisibleLayer)
		
		if let type = documentVisibleLayer?.type
		{
			switch type
			{
			case .Chroma(let chromaLayer):
				self.layerImage?.image = chromaLayer.image
				self.chromaColorView?.backgroundColor = chromaLayer.chroma ?? UIColor.clearColor()
				
			default:
				break
			}
		}
	}

}
