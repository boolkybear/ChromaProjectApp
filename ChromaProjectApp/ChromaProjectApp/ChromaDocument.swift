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
	
	func thumbnail() -> UIImage?
	{
		var thumbnail: UIImage? = nil
		
		if let thumbnailData = self.fileWrapperForKey(DocumentKey.ThumbnailKey.rawValue)?.regularFileContents
		{
			thumbnail = UIImage(data: thumbnailData)
		}
		
		return thumbnail
	}
	
	func layerWrapper(identifier: String) -> DocumentLayerFileWrapper?
	{
		return self.fileWrapperForKey(identifier)
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
			// TODO: decode color
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
	private let orderKey = "order"
	private let imageKey = "image"
	private let captionKey = "caption"
	
	private var layers: [ChromaDocumentLayer]
	var thumbnail: UIImage?
	var fileWrapper: NSFileWrapper? = nil
	
	var count: Int { return self.layers.count }
	
	subscript(index: Int) -> ChromaDocumentLayer {
		let layer = self.layers[index]
		
		return layer
	}
	
	override init()
	{
		self.layers = [ChromaDocumentLayer]()
		self.thumbnail = nil
		
		super.init()
	}
	
	override init(fileURL url: NSURL)
	{
		self.layers = [ChromaDocumentLayer]()
		self.thumbnail = nil
		
		super.init(fileURL: url)
	}
	
	override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		self.fileWrapper = contents as? DocumentFileWrapper
		
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
		let orderWrapper = self.fileWrapper?.fileWrapperForKey(self.orderKey)
		if let orderWrapper = orderWrapper
		{
			self.fileWrapper?.removeFileWrapper(orderWrapper)
		}
		
		if(self.layers.count > 0)
		{
			let identifierArray = self.layers.map() { layer in layer.identifier }
			var error: NSError? = nil
			let orderData = NSJSONSerialization.dataWithJSONObject(identifierArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
			if let orderData = orderData
			{
				let newOrderWrapper = NSFileWrapper(regularFileWithContents: orderData)
				newOrderWrapper.preferredFilename = self.orderKey
				self.fileWrapper?.addFileWrapper(newOrderWrapper)
			}
		}
	}
}