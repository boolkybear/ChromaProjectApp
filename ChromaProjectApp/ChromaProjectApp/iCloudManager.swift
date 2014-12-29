//
//  iCloudManager.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import Foundation

typealias ChangeHandler = (AnyObject?) -> ()

class ICloudManager
{
	var iCloudObserver: AnyObject? = nil
	
	init(changeHandler: ChangeHandler?)
	{
		let iCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken
		NSUserDefaults.setUbiquityToken(iCloudToken)
		
		self.iCloudObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSUbiquityIdentityDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
			notification in
			
			if let changeHandler = changeHandler
			{
				changeHandler(NSFileManager.defaultManager().ubiquityIdentityToken)
			}
		}
	}
}