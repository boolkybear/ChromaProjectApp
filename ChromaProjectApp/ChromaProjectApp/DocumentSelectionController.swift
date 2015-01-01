//
//  DocumentSelectionController.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import UIKit

class DocumentSelectionController: UICollectionViewController {
	
	func reloadDocuments(saveSettings: SaveSettings)
	{
		switch(saveSettings)
		{
		case .SaveLocally:
			break
			
		case .SaveInCloud:
			break
			
		default:
			break
		}
	}
	
	func addNewDocument()
	{
		// TODO: add to model
	}
}
