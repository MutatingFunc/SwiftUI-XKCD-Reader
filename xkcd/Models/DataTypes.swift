//
//  DataTypes.swift
//  xkcd
//
//  Created by James Froggatt on 13.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import Foundation
import UIKit

struct Metadata {
	var latestContent: Content
	var fetchContent: (Content.Index) -> ResultPublisher<Content>
	
	var indices: ClosedRange<Content.Index> {Content.Index(rawValue: 1)!...latestContent.index}
	func index(before index: Content.Index) -> Content.Index? {
		self.index(index, offsetBy: -1)
	}
	func index(after index: Content.Index) -> Content.Index? {
		self.index(index, offsetBy: +1)
	}
	func index(_ index: Content.Index, offsetBy offset: Content.Index.Stride) -> Content.Index? {
		Content.Index(rawValue: index.rawValue+offset).map(indices.contains) == true
			? Content.Index(rawValue: index.rawValue+offset)
			: nil
	}
}

struct Content {
	struct Index: RawRepresentable, Hashable, Equatable, Comparable, Strideable, Identifiable {
		func distance(to other: Content.Index) -> Int {
			other.rawValue - rawValue
		}
		
		func advanced(by n: Int) -> Content.Index {
			Content.Index(rawValue: rawValue + n)!
		}
		
		var rawValue: Int
    	init?(rawValue: Int) {
			guard rawValue >= 1 else {return nil}
			self.rawValue = rawValue
		}
		var id: Int {rawValue}
		static func <(lhs: Content.Index, rhs: Content.Index) -> Bool {lhs.rawValue < rhs.rawValue}
	}
	var index: Index
	var title: String
	var imageSrc: String
	var image: ResultPublisher<UIImage>
	var altText: String
}
