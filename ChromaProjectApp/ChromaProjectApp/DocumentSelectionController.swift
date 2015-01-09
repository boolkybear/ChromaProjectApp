//
//  DocumentSelectionController.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import UIKit

class DocumentSelectionController: UICollectionViewController {
	
	var documents: [ChromaDocument]? = nil
	
	func reloadDocuments(saveSettings: SaveSettings)
	{
		switch(saveSettings)
		{
		case .SaveLocally:
			self.documents = self.localDocuments()
			break
			
		case .SaveInCloud:
			// TODO: load from iCloud
			self.documents = nil
			break
			
		default:	// Not configured
			self.documents = nil
			break
		}
	}
	
	func addNewDocument()
	{
		// TODO: add to model
	}
}

private extension DocumentSelectionController
{
	func localDocumentsPath() -> String
	{
		return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
	}
	
	func localDocuments() -> [ChromaDocument]
	{
		var documents = [ChromaDocument]()
		
		var error: NSError? = nil
		let localDocumentsPath = self.localDocumentsPath()
		let localDocuments = NSFileManager.defaultManager().contentsOfDirectoryAtPath(localDocumentsPath, error: &error);
		
		let validExtensions = self.validExtensions()
		
		for document in localDocuments!
		{
			let fileName = document as String
			if(contains(validExtensions, fileName.pathExtension))
			{
				let fullPath = "\(localDocumentsPath)/\(fileName)"
				if let documentUrl = NSURL(fileURLWithPath: fullPath)
				{
					let chromaDocument = ChromaDocument(fileURL: documentUrl)
					chromaDocument.openWithCompletionHandler() {
						success in
						
						if success == false
						{
							// TODO: error
						}
					}
					documents.append(chromaDocument)
				}
			}
		}
		
		return documents
	}
	
	func validExtensions() -> [String]
	{
		var extensions = [String]()
		if let infoDict = NSBundle.mainBundle().infoDictionary
		{
			if let types = infoDict["CFBundleDocumentTypes"] as? [AnyObject]
			{
				for typeDict in types
				{
					if let contentTypes = typeDict["LSItemContentTypes"] as? [AnyObject]
					{
						for contentType in contentTypes
						{
							let pathExtension = contentType.pathExtension
							if contains(extensions, pathExtension) == false
							{
								extensions.append(pathExtension)
							}
						}
					}
				}
			}
		}
		
		return extensions
	}
}
