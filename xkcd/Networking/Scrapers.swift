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

protocol Scraper {
	associatedtype InputType
	associatedtype ScrapedType
	func scrape(_ input: InputType) -> AnyPublisher<ScrapedType, Error>
}
extension Scraper {
	var asAny: AnyScraper<InputType, ScrapedType> {AnyScraper(self)}
}
struct AnyScraper<InputType, ScrapedType>: Scraper {
	private let source: Base<InputType, ScrapedType>
	init<ScraperType: Scraper>(_ source: ScraperType) where ScraperType.InputType == InputType, ScraperType.ScrapedType == ScrapedType {self.source = Impl(source)}
	func scrape(_ input: InputType) -> AnyPublisher<ScrapedType, Error> {source.scrape(input)}
	private class Base<InputType, ScrapedType>: Scraper {
		func scrape(_ input: InputType) -> AnyPublisher<ScrapedType, Error> {fatalError()}
	}
	private class Impl<ScraperType: Scraper>: Base<ScraperType.InputType, ScraperType.ScrapedType> {
		let source: ScraperType
		init(_ source: ScraperType) {self.source = source}
		override func scrape(_ input: ScraperType.InputType) -> AnyPublisher<ScraperType.ScrapedType, Error> {source.scrape(input)}
	}
}

private let mainPage = URL(string: "https://www.xkcd.com")!

struct MetadataScraper: Scraper {
	let fetcher: AnyFetcher<String>
	func scrape(_: ()) -> AnyPublisher<Metadata, Error> {
		fetcher.fetch(mainPage)
			.tryMap {html -> (html: String, index: Content.Index) in
				let previousIndexString = try html.substringMatchingFirstCaptureGroup(of: #"<a rel="prev" href="\/(\d+)\/""#)
				guard let previousIndex = Int(previousIndexString) else {
					throw ScrapingError.parsingType(Int.self, from: previousIndexString)
				}
				//This defines what the upper limit is, when indices are later retreived from Metadata
				let index = Content.Index(rawValue: previousIndex+1)!
				return (html, index)
			}
		.flatMap{ContentScraper(fetcher: ConstantFetcher(constant: $0.html, delay: 0).asAny).scrape($0.index)}
			.map(Metadata.init)
			.eraseToAnyPublisher()
	}
}

private func contentPage(index: Content.Index) -> URL {
	URL(string: "https://www.xkcd.com/\(index.rawValue)/")!
}

struct ContentScraper: Scraper {
	let fetcher: AnyFetcher<String>
	func scrape(_ index: Content.Index) -> AnyPublisher<Content, Error> {
		fetcher.fetch(contentPage(index: index))
					.tryMap {html -> Content in
						let title = try html.substringMatchingFirstCaptureGroup(of: #"<div id="ctitle">([^<]*)<\/div>"#)
						let imageSrcString = try html.substringMatchingFirstCaptureGroup(of: #"<img src="([^"]*)" title="[^"]*""#)
						guard let imageSrc = URL(string: "https:" + imageSrcString) else {
							throw ScrapingError.parsingType(URL.self, from: imageSrcString)
						}
						let altText = try html.substringMatchingFirstCaptureGroup(of: #"<img src="[^"]*" title="([^"]*)""#)
						return Content(index: index, title: Self.removingHTML(title), imageSrc: imageSrc, altText: Self.removingHTML(altText))
					}
					.eraseToAnyPublisher()
	}

	private static func removingHTML(_ string: String) -> String {
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
}
