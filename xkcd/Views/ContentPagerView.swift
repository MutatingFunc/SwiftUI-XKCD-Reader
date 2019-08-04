//
//  ContentPagerView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import SwiftUI

struct ContentPagerView: View {
	let metadata: Metadata
	@State private var fetchResults: [Content.Index: Result<Content, Error>] = [:]
	@State private var currentIndex: Content.Index = Content.Index(rawValue: 2172)!
	@State private var dragXOffset: CGFloat = 0
	
	var body: some View {
		GeometryReader {proxy -> AnyView in
			let drag = DragGesture(minimumDistance: 1, coordinateSpace: .global)
				.onChanged {value in
					withAnimation {
						self.dragXOffset = value.translation.width
					}
				}
				.onEnded {value in
					var newIndex = self.currentIndex
					if value.translation.width > 100, let index = self.metadata.index(before: self.currentIndex) {
						self.dragXOffset -= proxy.size.width
						newIndex = index
					} else if value.translation.width < -100, let index = self.metadata.index(after: self.currentIndex) {
						self.dragXOffset += proxy.size.width
						newIndex = index
					}
					
					withAnimation {
						self.currentIndex = newIndex
						self.dragXOffset = 0
					}
				}
			return ZStack {
				self.metadata
					.index(before: self.currentIndex)
					.map(self.contentCard)
				self.contentCard(self.currentIndex)
					.gesture(drag)
				self.metadata
					.index(after: self.currentIndex)
					.map(self.contentCard)
			}.asAny
		}
	}
	
	func contentCard(_ index: Content.Index) -> some View {
		let offsetFromCurrentIndex = CGFloat(self.currentIndex.distance(to: index))
		
		return GeometryReader {proxy in
			CardView {
				FetchView(
					fetch: self.metadata.fetchContent(index),
					currentResult: self.$fetchResults[index],
					loadingText: nil,
					successView: {content in
						ContentView(content: content)
					}
				)
			}.offset(x: self.dragXOffset + (offsetFromCurrentIndex * proxy.size.width))
		}
	}
	
	func changeIndex(by offset: Int) {
		if let index = metadata.index(currentIndex, offsetBy: offset) {
			currentIndex = index
		}
	}
}

#if DEBUG
struct ContentPagerView_Previews: PreviewProvider {
	static let metadata = Metadata(
		latestContent: ContentView_Previews.content,
		fetchContent: {index in
			scrapeContent(
				for: index,
				from: fetchString(
					from: contentPage(index: index),
					using: .shared
				),
				using: .shared
			).asResult
		}
	)
	
	static var previews: some View {
		Group {
			ContentPagerView(
				metadata: Self.metadata
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
