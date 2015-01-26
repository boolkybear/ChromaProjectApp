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
			
			// TODO: load data from document
		}
	}
	
	var name: String? {
		get { return self.document?.name }
		set {
			// TODO: save newValue as document name
		}
	}
}