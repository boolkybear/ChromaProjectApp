//
//  DocumentManager.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import Foundation

struct DocumentManager
{
	var documents: [ChromaDocument] = [ChromaDocument]()
	
	var path: String? = nil {
		didSet {
			documents = documentsInPath(self.path)
		}
	}
	
	static func localDocumentsPath() -> String
	{
		return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
	}
	
	func count() -> Int
	{
		return countElements(self.documents)
	}
	
	subscript(index: Int) -> ChromaDocument
	{
		return self.documents[index]
	}
	
	func deleteDocumentAtIndex(index: Int)
	{
		let document = self.documents[index];
		
		var error: NSError? = nil
		if NSFileManager.defaultManager().removeItemAtURL(document.fileURL, error: &error)
		{
			//self.documents.removeAtIndex(index);
		}
	}
}

private extension DocumentManager
{
	func documentsInPath(pathToLoad: String?) -> [ChromaDocument]
	{
		var documents = [ChromaDocument]()
		
		if let pathToLoad = pathToLoad
		{
			var error: NSError? = nil
			if let filePaths = NSFileManager.defaultManager().contentsOfDirectoryAtPath(pathToLoad, error: &error)
			{
				let validExtensions = ChromaDocument.validExtensions()
				
				for file in filePaths
				{
					let fileName = file as String
					if(contains(validExtensions, fileName.pathExtension))
					{
						let fullPath = "\(pathToLoad)/\(fileName)"
						if let documentUrl = NSURL(fileURLWithPath: fullPath)
						{
							let document = ChromaDocument(fileURL: documentUrl)
							documents.append(document)
						}
					}
				}
			}
		}
		
		return documents.sorted {
			document1, document2 in
			
			switch (document1.fileModificationDate, document2.fileModificationDate)
			{
			case (.None, .None):
				return false
				
			case (.None, .Some):
				return true
				
			case (.Some, .None):
				return false
				
			case (.Some(let date1), .Some(let date2)):
				return date1.timeIntervalSinceDate(date2) > 0
			}
		}
	}
}