//
//  ChromaDocument.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 28/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import UIKit

private enum DocumentKey: String
{
	case OrderKey = "order"
	case ThumbnailKey = "thumbnail"
	case NameKey = "name"
	case CaptionKey = "caption"
	case BackgroundKey = "background"
}

private enum DocumentLayerKey: String
{
	case ImageKey = "image"
	case TransformKey = "transform"
	case ChromaKey = "chroma"
	case IdentifierKey = "identifier"
}

typealias DocumentFileWrapper = NSFileWrapper
typealias DocumentLayerFileWrapper = NSFileWrapper

extension NSFileWrapper
{
	func fileWrapperForKey(key: String) -> NSFileWrapper?
	{
		return self.fileWrappers[key] as? NSFileWrapper
	}
	
	func removeFileWrapperForKey(key: String) -> Bool
	{
		var childExists = false
		
		if let childWrapper = self.fileWrapperForKey(key)
		{
			self.removeFileWrapper(childWrapper)
			childExists = true
		}
		
		return childExists
	}
}

extension DocumentFileWrapper
{
	func order() -> [String]?
	{
		var order: [String]? = nil
		
		if let orderData = self.fileWrapperForKey(DocumentKey.OrderKey.rawValue)?.regularFileContents
		{
			order = NSKeyedUnarchiver.unarchiveObjectWithData(orderData) as? [String]
		}
		
		return order
	}
	
	private func imageForKey(documentKey: DocumentKey) -> UIImage?
	{
		var image: UIImage? = nil
		
		if let imageData = self.fileWrapperForKey(documentKey.rawValue)?.regularFileContents
		{
			image = UIImage(data: imageData)
		}
		
		return image
	}
	
	func thumbnail() -> UIImage?
	{
		return self.imageForKey(.ThumbnailKey)
	}
	
	func background() -> UIImage?
	{
		return self.imageForKey(.BackgroundKey)
	}
	
	private func stringForKey(documentKey: DocumentKey, encoding: UInt) -> String?
	{
		var string: String? = nil
		
		if let stringData = self.fileWrapperForKey(documentKey.rawValue)?.regularFileContents
		{
			if let str = NSString(data: stringData, encoding: encoding)
			{
				string = String(str)
			}
		}
		
		return string
	}
	
	func name() -> String?
	{
		return self.stringForKey(.NameKey, encoding: NSUTF8StringEncoding)
	}
	
	func caption() -> String?
	{
		return self.stringForKey(.CaptionKey, encoding: NSUTF8StringEncoding)
	}
	
	func layerWrapper(identifier: String) -> DocumentLayerFileWrapper?
	{
		return self.fileWrapperForKey(identifier)
	}
	
	private func setStringForKey(string: String?, documentKey: DocumentKey, encoding: UInt) -> String?
	{
		var dev: String? = nil
		self.removeFileWrapperForKey(documentKey.rawValue)
		
		if let string = string
		{
			let stringWrapper = NSFileWrapper(regularFileWithContents: string.dataUsingEncoding(encoding, allowLossyConversion: false) ?? NSData())
			dev = self.addFileWrapper(stringWrapper)
		}
		
		return dev
	}
	
	func setName(newName: String?) -> String?
	{
		return self.setStringForKey(newName, documentKey: .NameKey, encoding: NSUTF8StringEncoding)
	}
}

extension DocumentLayerFileWrapper
{
	func image() -> UIImage?
	{
		var image: UIImage? = nil
		
		if let imageData = self.fileWrapperForKey(DocumentLayerKey.ImageKey.rawValue)?.regularFileContents
		{
			image = UIImage(data: imageData)
		}
		
		return image
	}
	
	func transform() -> CGAffineTransform
	{
		var transform: CGAffineTransform = CGAffineTransformIdentity
		
		if let transformData = self.fileWrapperForKey(DocumentLayerKey.TransformKey.rawValue)?.regularFileContents
		{
			if let transformString = NSString(data: transformData, encoding: NSUTF8StringEncoding)
			{
				transform = CGAffineTransformFromString(transformString)
			}
		}
		
		return transform
	}
	
	func chroma() -> UIColor?
	{
		var chroma: UIColor? = nil
		
		if let chromaData = self.fileWrapperForKey(DocumentLayerKey.ChromaKey.rawValue)?.regularFileContents
		{
			if let chromaDict: [ String : CGFloat ] = NSKeyedUnarchiver.unarchiveObjectWithData(chromaData) as? [ String : CGFloat ]
			{
				chroma = UIColor(red: chromaDict["r"] ?? 0.0, green: chromaDict["g"] ?? 0.0, blue: chromaDict["b"] ?? 0.0, alpha: chromaDict["a"] ?? 1.0)
			}
		}
		
		return chroma
	}
}

class ChromaDocumentLayer
{
	var image: UIImage?
	var transform: CGAffineTransform
	var chroma: UIColor?
	
	var identifier: String
	
	init()
	{
		self.image = nil
		self.transform = CGAffineTransformIdentity
		self.chroma = nil
		
		self.identifier = NSUUID().UUIDString
	}
}

class ChromaDocument: UIDocument
{
//	private let orderKey = "order"
//	private let imageKey = "image"
//	private let captionKey = "caption"
	
	private var layers: [ChromaDocumentLayer] = [ChromaDocumentLayer]()
	var thumbnail: UIImage? = nil
	var name: String? = nil
	var background: UIImage? = nil
	var fileWrapper: NSFileWrapper? = nil
	
	var count: Int { return self.layers.count }
	
	subscript(index: Int) -> ChromaDocumentLayer {
		let layer = self.layers[index]
		
		return layer
	}
	
	override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		self.fileWrapper = contents as? DocumentFileWrapper
		
		self.thumbnail = self.fileWrapper?.thumbnail()
		self.name = self.fileWrapper?.name()
		self.background = self.fileWrapper?.background()
		
		self.layers.removeAll()
		if let orderArray = self.fileWrapper?.order()
		{
			for layerIdentifier in orderArray
			{
				let layer = ChromaDocumentLayer()
				
				layer.identifier = layerIdentifier
				
				if let layerWrapper = self.fileWrapper?.layerWrapper(layer.identifier)
				{
					if let image = layerWrapper.image()
					{
						layer.image = image
					}
					
					layer.transform = layerWrapper.transform()
					
					if let chroma = layerWrapper.chroma()
					{
						layer.chroma = chroma
					}
				}
				
				self.layers.append(layer)
			}
		}
		
		return true
	}
	
	override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
		if self.fileWrapper == nil
		{
			self.fileWrapper = NSFileWrapper(directoryWithFileWrappers: [NSObject : AnyObject]())
		}
		
		return self.fileWrapper
	}
	
	func removeLayerAtIndex(index: Int)
	{
		let layer = self.layers.removeAtIndex(index)
		
		let layerWrapper = self.fileWrapper?.fileWrapperForKey(layer.identifier)
		if let layerWrapper = layerWrapper
		{
			self.fileWrapper?.removeFileWrapper(layerWrapper)
		}
		
		self.recreateOrderWrapper()
	}
	
	func recreateOrderWrapper()
	{
		let orderWrapper = self.fileWrapper?.fileWrapperForKey(DocumentKey.OrderKey.rawValue)
		if let orderWrapper = orderWrapper
		{
			self.fileWrapper?.removeFileWrapper(orderWrapper)
		}
		
		if(self.layers.count > 0)
		{
			let identifierArray = self.layers.map() { layer in layer.identifier }
			var error: NSError? = nil
			let orderData = NSKeyedArchiver.archivedDataWithRootObject(identifierArray)
			
			let newOrderWrapper = NSFileWrapper(regularFileWithContents: orderData)
			newOrderWrapper.preferredFilename = DocumentKey.OrderKey.rawValue
			self.fileWrapper?.addFileWrapper(newOrderWrapper)
		}
	}
	
	class func validExtensions() -> [String]
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

// Setters
extension ChromaDocument
{
	typealias FileWrapperErrorHandler = (String?) -> Void
	
	func defaultErrorHandler(newKey: String?)
	{
		if let key = newKey
		{
			if let newWrapper = self.fileWrapper?.fileWrapperForKey(key)
			{
				self.fileWrapper?.removeFileWrapper(newWrapper)
			}
		}
	}
	
	func setRegularFileWithData(data: NSData?, preferredFilename: String, errorHandler: FileWrapperErrorHandler?)
	{
		if let dataWrapper = self.fileWrapper?.fileWrapperForKey(preferredFilename)
		{
			self.fileWrapper?.removeFileWrapper(dataWrapper)
		}
		
		if let data = data
		{
			let dataKey = self.fileWrapper?.addRegularFileWithContents(data, preferredFilename: DocumentKey.CaptionKey.rawValue)
			if dataKey == nil || dataKey! != preferredFilename
			{
				if let handler = errorHandler
				{
					handler(dataKey)
				}
			}
		}
	}
	
	func setCaption(caption: String?)
	{
		var data: NSData? = nil
		
		if let captionString = caption
		{
			data = captionString.dataUsingEncoding(NSUTF32LittleEndianStringEncoding, allowLossyConversion: false)
		}
		
		self.setRegularFileWithData(data, preferredFilename: DocumentKey.CaptionKey.rawValue) { [unowned self]
			string in
			self.defaultErrorHandler(string) }
	}
	
	func addNewLayer()
	{
	}
	
	func setBackground(background: UIImage?)
	{
		var data: NSData? = nil
		
		if let backgroundImage = background
		{
			data = UIImageJPEGRepresentation(backgroundImage, 1.0)
		}
		
		self.setRegularFileWithData(data, preferredFilename: DocumentKey.BackgroundKey.rawValue) { [unowned self]
			string in
			self.defaultErrorHandler(string) }
	}
	
	func setThumbnail(thumbnail: UIImage?)
	{
		var data: NSData? = nil
		
		if let thumbnailImage = thumbnail
		{
			data = UIImageJPEGRepresentation(thumbnailImage, 1.0)
		}
		
		self.setRegularFileWithData(data, preferredFilename: DocumentKey.ThumbnailKey.rawValue) { [unowned self]
			string in
			self.defaultErrorHandler(string) }
	}
	
	func setName(newName: String?)
	{
		self.fileWrapper?.setName(newName)
	}
}