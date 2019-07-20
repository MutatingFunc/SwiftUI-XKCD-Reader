//
//  Fetchers.swift
//  xkcd
//
//  Created by James Froggatt on 12.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum FetchingError: LocalizedError {
	case mockError
	case parsing(_ type: Any.Type, from: Data, URLResponse)
	
	var errorDescription: String? {
		switch self {
		case .parsing(let type, from: let data, let urlResponse):
			return "Parsing failure\n---Type: \(type)\n----Response:\n\(urlResponse)\n----Data:\n\(data)"
		case .mockError:
			return "Mock error"
		}
	}
}

protocol Fetcher {
	associatedtype FetchedType
	func fetch(_ url: URL) -> AnyPublisher<FetchedType, Error>
}
extension Fetcher {
	var asAny: AnyFetcher<FetchedType> {AnyFetcher(self)}
}

struct AnyFetcher<FetchedType>: Fetcher {
	private let source: Base<FetchedType>
	init<FetcherType: Fetcher>(_ source: FetcherType) where FetcherType.FetchedType == FetchedType {self.source = Impl(source)}
	func fetch(_ url: URL) -> AnyPublisher<FetchedType, Error> {source.fetch(url)}
	private class Base<FetchedType>: Fetcher {
		func fetch(_ url: URL) -> AnyPublisher<FetchedType, Error> {fatalError()}
	}
	private class Impl<FetcherType: Fetcher>: Base<FetcherType.FetchedType> {
		let source: FetcherType
		init(_ source: FetcherType) {self.source = source}
		override func fetch(_ url: URL) -> AnyPublisher<FetcherType.FetchedType, Error> {source.fetch(url)}
	}
}



struct StringFetcher: Fetcher {
	let urlSession: URLSession
	func fetch(_ url: URL) -> AnyPublisher<String, Error> {
		urlSession
			.dataTaskPublisher(for: url)
			.tryMap {data, response -> String in
				if let html = String(data: data, encoding: .utf8) {
					return html
				} else {
					throw FetchingError.parsing(String.self, from: data, response)
				}
			}
			.eraseToAnyPublisher()
	}
}

struct ImageFetcher: Fetcher {
	let urlSession: URLSession
	func fetch(_ url: URL) -> AnyPublisher<UIImage, Error> {
		urlSession
			.dataTaskPublisher(for: url)
			.tryMap {data, response -> UIImage in
				if let image = UIImage(data: data) {
					return image
				} else {
					throw FetchingError.parsing(UIImage.self, from: data, response)
				}
			}
			.eraseToAnyPublisher()
	}
}

struct ConstantFetcher<FetchedType>: Fetcher {
	let constant: FetchedType
	let delay: DispatchQueue.SchedulerTimeType.Stride
	func fetch(_ url: URL) -> AnyPublisher<FetchedType, Error> {
		Just(constant)
			.setFailureType(to: Error.self)
			.delay(for: delay, scheduler: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}

struct ErrorFetcher<FetchedType>: Fetcher {
	let error: Error
	let delay: DispatchQueue.SchedulerTimeType.Stride
	func fetch(_ url: URL) -> AnyPublisher<FetchedType, Error> {
		Fail(error: error)
			.delay(for: delay, scheduler: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}
