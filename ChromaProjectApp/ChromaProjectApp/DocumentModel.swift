//
//  DocumentModel.swift
//  ChromaProjectApp
//
//  Created by José Servet Font on 28/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import Foundation

struct DocumentModel
{
	var documents = [ChromaDocument]()
	
	var count: Int { return self.documents.count }
	
	init(saveSettings: SaveSettings)
	{
		switch saveSettings
		{
		case .SaveLocally:
			break
			
		case .SaveInCloud:
			break
			
		default:
			break
		}
		
		
	}
}