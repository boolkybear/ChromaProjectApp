//
//  NSFileManager.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 25/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import Foundation

extension NSFileManager
{
	class func localDocumentsPath() -> String
	{
		return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
	}
}