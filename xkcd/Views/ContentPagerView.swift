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
	@Binding var currentIndex: Content.Index
	@State private var fetchedContent: [Content.Index: Result<Content, Error>] = [:]
	@State private var fetchedImages: [Content.Index: Result<UIImage, Error>] = [:]
	@State private var dragXOffset: CGFloat = 0
	@State private var showIndexPicker: Bool = false
	
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
					self.currentIndex = newIndex
					
					withAnimation {
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
			}.sheet(isPresented: self.$showIndexPicker) {
				List {
					ForEach((Content.Index(rawValue: 1)!...self.metadata.latestContent.index).reversed()) {index in
						Button(action: {
							self.currentIndex = index
							self.showIndexPicker = false
						}) {
							Text("\(index.rawValue)")
						}
					}
				}
			}.asAny
		}
	}
	
	func contentCard(_ index: Content.Index) -> some View {
		let offsetFromCurrentIndex = CGFloat(self.currentIndex.distance(to: index))
		
		return GeometryReader {proxy in
			CardView {
				FetchView(
					fetch: self.metadata.fetchContent(index),
					currentResult: self.$fetchedContent[index],
					loadingText: nil,
					successView: {content in
						ContentView(
							content: content,
							showMenu: {self.showIndexPicker = true},
							currentImage: self.$fetchedImages[index]
						)
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
			).asResultForUI
		}
	)
	
	static var previews: some View {
		Group {
			ContentPagerView(
				metadata: metadata,
				currentIndex: .constant(metadata.latestContent.index)
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
