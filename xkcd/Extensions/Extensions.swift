//
//  Extensions.swift
//  xkcd
//
//  Created by James Froggatt on 11.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

extension Color {
	init(_ uiColor: UIColor) {
		var r, g, b, a: CGFloat
		(r, g, b, a) = (0, 0, 0, 0)
		uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
		self.init(.sRGB, red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
	}
}

extension String {
	func substringMatchingFirstCaptureGroup(of regex: String) throws -> String {
		let nsRegex = try NSRegularExpression(pattern: regex, options: [])
		let fullRange = NSRange(0..<(self as NSString).length)
		guard let range = nsRegex.firstMatch(in: self, options: [], range: fullRange)?.range(at: 1) else {
			throw MatchingError.findingRange(matchingCaptureGroupOfRegex: regex, in: self)
		}
		return (self as NSString).substring(with: range)
	}
}

enum MatchingError: LocalizedError {
	case findingRange(matchingCaptureGroupOfRegex: String, in: String)
	
	var errorDescription: String? {
		switch self {
		case .findingRange(matchingCaptureGroupOfRegex: let regex, in: let string):
			return "Failure matching capture group\n----RegEx:\n\(regex)\n----String:\n\(string)"
		}
	}
}

extension Publisher {
	var asAny: AnyPublisher<Output, Failure> {AnyPublisher(self)}
	
	func resultPublisher() -> Publishers.Catch<Publishers.Map<Self, Result<Self.Output, Error>>, Just<Result<Self.Output, Error>>> {
		self
			.map{Result<Output, Error>.success($0)}
			.catch{Just<Result<Output, Error>>(.failure($0))}
	}
}
extension View {
	var asAny: AnyView {AnyView(self)}
}

extension Cancellable {
	var asAny: AnyCancellable {AnyCancellable(self)}
	/// Stores this AnyCancellable in the specified collection.
	/// Parameters:
	///    - collection: The collection to store this AnyCancellable.
	@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	func store<C>(in collection: inout C) where C : RangeReplaceableCollection, C.Element == AnyCancellable {
		AnyCancellable(self).store(in: &collection)
	}
	
	/// Stores this AnyCancellable in the specified set.
	/// Parameters:
	///    - collection: The set to store this AnyCancellable.
	func store(in set: inout Set<AnyCancellable>) {
		AnyCancellable(self).store(in: &set)
	}
}
