//
//  SettingsController.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import UIKit

typealias SettingsChangeHandler = (SaveSettings) -> Void

class SettingsController: UITableViewController {

	@IBOutlet var localCell: UITableViewCell!
	@IBOutlet var iCloudCell: UITableViewCell!
	@IBOutlet var localButton: UIButton!
	@IBOutlet var iCloudButton: UIButton!
	
	var settingsChange: SettingsChangeHandler? = nil
	var isiCloudEnabled: Bool = false
	
	func changeSettings(saveSettings: SaveSettings)
	{
		NSUserDefaults.setSaveSettings(saveSettings)
		
		if let change = self.settingsChange
		{
			change(saveSettings)
		}
	}
	
	func enableiCloud(enabled: Bool)
	{
		self.isiCloudEnabled = enabled
		if let button = self.iCloudButton
		{
			button.enabled = enabled
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.iCloudButton.enabled = self.isiCloudEnabled
	}
}

// MARK: Actions
extension SettingsController
{
	@IBAction func localButtonClicked(sender: AnyObject) {
		self.changeSettings(.SaveLocally)
	}
	
	@IBAction func iCloudButtonClicked(sender: AnyObject) {
		self.changeSettings(.SaveInCloud)
	}
}