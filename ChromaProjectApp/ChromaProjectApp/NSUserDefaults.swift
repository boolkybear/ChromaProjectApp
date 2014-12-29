//
//  NSUserDefaults.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 25/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import Foundation

enum SaveSettings: Int
{
	case NotConfigured = 0
	case SaveLocally = 1
	case SaveInCloud = 2
}

let saveSettingsKey = "saveSettingsKey"
let ubiquityTokenKey = "ubiquityTokenKey"

extension NSUserDefaults
{
	class func saveSettings() -> SaveSettings
	{
		let userDefaults = NSUserDefaults.standardUserDefaults()
		let currentSettings = userDefaults.integerForKey(saveSettingsKey)
		
		return SaveSettings(rawValue: currentSettings)!
	}
	
	class func setSaveSettings(settings: SaveSettings)
	{
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		userDefaults.setInteger(settings.rawValue, forKey: saveSettingsKey)
	}
	
	class func ubiquityToken() -> AnyObject?
	{
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		let tokenData = userDefaults.objectForKey(ubiquityTokenKey) as? NSData
		
		let token: AnyObject? = tokenData != nil ? NSKeyedUnarchiver.unarchiveObjectWithData(tokenData!) : nil
		
		return token
	}
	
	class func setUbiquityToken(token: protocol<NSCoding, NSCopying, NSObjectProtocol>?)
	{
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if let token = token
		{
			let tokenData = NSKeyedArchiver.archivedDataWithRootObject(token)
			
			userDefaults.setObject(tokenData, forKey: ubiquityTokenKey)
		}
		else
		{
			userDefaults.removeObjectForKey(ubiquityTokenKey)
		}
	}
}