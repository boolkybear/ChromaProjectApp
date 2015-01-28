//
//  DocumentViewModel.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import Foundation
import UIKit

enum DocumentLayerType
{
	case Caption(String?)
	case Chroma(ChromaDocumentLayer)
	case Background(UIImage?)
}

class DocumentVisibleLayer
{
	let type: DocumentLayerType
	var isVisible: Bool = true
	
	init(type: DocumentLayerType)
	{
		self.type = type
	}
}

struct DocumentViewModel
{
	var visibleLayers: [DocumentVisibleLayer] = [DocumentVisibleLayer]()
	
	var document: ChromaDocument? {
		didSet {
			visibleLayers.removeAll()
			
			document?.openWithCompletionHandler {
				success in
				
				if success
				{
					if let document = self.document
					{
						self.visibleLayers.append(DocumentVisibleLayer(type: .Caption(document.name)))
						
						let count = document.count
						for i in 0..<count
						{
							var visibleLayer = DocumentVisibleLayer(type: .Chroma(document[count-i-1]))
							self.visibleLayers.append(visibleLayer)
						}
						
						self.visibleLayers.append(DocumentVisibleLayer(type: .Background(document.background)))
					}
				}
			}
		}
	}
	
	init()
	{
	}
	
	var name: String? {
		get { return self.document?.name }
		set { self.document?.setName(newValue) }
	}
	
	func count() -> Int
	{
		return countElements(self.visibleLayers)
	}
	
	subscript(index: Int) -> DocumentVisibleLayer
	{
		return self.visibleLayers[index]
	}
}