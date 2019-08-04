//
//  Scrapers.swift
//  xkcd
//
//  Created by James Froggatt on 11.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation
import Combine

enum ScrapingError: LocalizedError {
	case parsingType(_ type: Any.Type, from: String)
	
	var errorDescription: String? {
		switch self {
		case .parsingType(let type, from: let string):
			return "Failure parsing Int\n----Type: \(type)\n----String: \(string)"
		}
	}
}

let mainPage = URL(string: "https://www.xkcd.com")!

func scrapeMetadata(from fetch: AnyPublisher<String, Error>, using urlSession: URLSession) -> AnyPublisher<Metadata, Error> {
	fetch
		.tryMap {html -> (html: String, index: Content.Index) in
			let previousIndexString = try html.substringMatchingFirstCaptureGroup(of: #"<a rel="prev" href="\/(\d+)\/""#)
			guard let previousIndex = Int(previousIndexString) else {
				throw ScrapingError.parsingType(Int.self, from: previousIndexString)
			}
			//This defines what the upper limit is, when indices are later retreived from Metadata
			let index = Content.Index(rawValue: previousIndex+1)!
			return (html, index)
		}
	.flatMap{scrapeContent(for: $0.index, from: fetchConstant($0.html, delay: 0), using: urlSession)}
	.map {
		Metadata(
			latestContent: $0,
			fetchContent: {index in
				scrapeContent(
					for: index,
					from: fetchString(
						from: contentPage(index: index),
						using: urlSession
					),
					using: urlSession
				).asResult
			}
		)
	}
		.eraseToAnyPublisher()
}

func contentPage(index: Content.Index) -> URL {
	URL(string: "https://www.xkcd.com/\(index.rawValue)/")!
}

func scrapeContent(for index: Content.Index, from fetch: AnyPublisher<String, Error>, using urlSession: URLSession) -> AnyPublisher<Content, Error> {
	fetch
		.tryMap {html -> Content in
			let title = try html.substringMatchingFirstCaptureGroup(of: #"<div id="ctitle">([^<]*)<\/div>"#)
			let imageSrcString = try html.substringMatchingFirstCaptureGroup(of: #"<img src="([^"]*)" title="[^"]*""#)
			guard let imageSrc = URL(string: "https:" + imageSrcString) else {
				throw ScrapingError.parsingType(URL.self, from: imageSrcString)
			}
			let altText = try html.substringMatchingFirstCaptureGroup(of: #"<img src="[^"]*" title="([^"]*)""#)
			return Content(
				index: index,
				title: removingHTML(title),
				imageSrc: imageSrc.absoluteString,
				image: fetchImage(from: imageSrc, using: urlSession).asResult,
				altText: removingHTML(altText)
			)
		}
		.eraseToAnyPublisher()
}

private func removingHTML(_ string: String) -> String {
	func htmlDecode(_ data: Data) -> NSAttributedString? {
		let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]
		return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
	}
	
	return string
		.data(using: .utf8)
		.flatMap(htmlDecode)?
		.string
		?? string
}
