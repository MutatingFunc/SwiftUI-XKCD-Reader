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
		case let .parsing(type, from: data, urlResponse):
			return """
				Parsing failure
				----Type: \(type)
				----Response:\n\(urlResponse)
				----Data:\n\(data)
				"""
		case .mockError:
			return "Mock error"
		}
	}
}

func fetchString(
	from url: URL,
	using urlSession: URLSession
) -> AnyPublisher<String, Error> {
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

func fetchImage(
	from url: URL,
	using urlSession: URLSession
) -> AnyPublisher<UIImage, Error> {
	urlSession
		.dataTaskPublisher(for: url)
		.tryMap {data, response -> UIImage in
			if let image = UIImage(data: data) {
				return image
			} else {
				throw FetchingError.parsing(
					UIImage.self,
					from: data,
					response
				)
			}
		}
		.eraseToAnyPublisher()
}

func fetchConstant<FetchedType>(
	_ constant: FetchedType,
	delay: DispatchQueue.SchedulerTimeType.Stride
) -> AnyPublisher<FetchedType, Error> {
	Just(constant)
		.setFailureType(to: Error.self)
		.delay(for: delay, scheduler: DispatchQueue.main)
		.eraseToAnyPublisher()
}

func fetchConstantError<FetchedType>(
	_ error: Error,
	delay: DispatchQueue.SchedulerTimeType.Stride
) -> AnyPublisher<FetchedType, Error> {
	Fail(error: error)
		.delay(for: delay, scheduler: DispatchQueue.main)
		.eraseToAnyPublisher()
}
