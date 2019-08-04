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

typealias ResultPublisher<ContentType> = AnyPublisher<Result<ContentType, Error>, Never>
extension Publisher {
	var asAny: AnyPublisher<Output, Failure> {AnyPublisher(self)}
	
	var asResult: ResultPublisher<Self.Output> {
		self
			.map{Result<Output, Error>.success($0)}
			.catch{Just<Result<Output, Error>>(.failure($0))}
		.asAny
	}
}
extension View {
	var asAny: AnyView {AnyView(self)}
}

extension Cancellable {
	var asAny: AnyCancellable {AnyCancellable(self)}
}
