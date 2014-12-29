//
//  AppInitializer.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 25/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import Foundation
import UIKit

class AppInitializer
{
	func initializeFromController(controller: UIViewController)
	{
		let saveSettings = NSUserDefaults.saveSettings()
		let iCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken
		
		switch(saveSettings, iCloudToken)
		{
		case (.NotConfigured, let iCloudToken):
			// App not configured
			// iCloud connected
//			let alertController = UIAlertController(title: "Documents location", message: "You can choose to save documents locally or in iCloud", preferredStyle: .Alert)
//			let localAction = UIAlertAction(title: "Locally", style: .Default) {
//				NSUserDefaults.setSaveSettings(.SaveLocally)
//			}
//			let cloudAction = UIAlertAction(title: "iCloud", style: .Default) {
//				NSUserDefaults.setUbiquityToken(iCloudToken)
//				NSUserDefaults.setSaveSettings(.SaveInCloud)
//				self.registerForiCloudStatusUpdates()
//			}
//			alertController.addAction(localAction)
//			alertController.addAction(cloudAction)
			break
		
		case (.NotConfigured, nil):
			// App not configured
			// iCloud not connected
//			let alertController = UIAlertController(title: "Documents location", message: "iCloud is not configured. If you want to save documents in iCloud, configure your account and restart application. Otherwise you'll can only save documents locally", preferredStyle: .Alert)
//			let localAction = UIAlertAction(title: "Locally", style: .Default) {
//				NSUserDefaults.setSaveSettings(.SaveLocally)
//			}
//			alertController.addAction(localAction)
			break
			
		case (.SaveInCloud, let iCloudToken):
			// App configured in iCloud
			// iCloud connected
			break

		case (.SaveInCloud, nil):
			// App configured in iCloud
			// iCloud not connected
//			let alertController = UIAlertController(title: "Documents location", message: "iCloud is not configured. If you want to save documents in iCloud, configure your account and restart application. Otherwise you'll can only save documents locally", preferredStyle: .Alert)
//			let localAction = UIAlertAction(title: "Save Locally", style: .Default) {
//				NSUserDefaults.setSaveSettings(.SaveLocally)
//			}
//			alertController.addAction(localAction)
			break
			
		case (.SaveLocally, _):
			break
		}
	}
}