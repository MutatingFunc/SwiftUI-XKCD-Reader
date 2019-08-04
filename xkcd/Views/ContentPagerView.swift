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
	
	var body: some View {
		HStack {
			if metadata.index(before: currentIndex) != nil {
				Button(action: {self.changeIndex(by: -1)}) {
					Text("←")
						.font(.largeTitle)
				}
			}
			CardView {
				FetchView(
					fetch: self.metadata.fetchContent(self.currentIndex),
					currentResult: self.$fetchResults[self.currentIndex],
					loadingText: nil
				) {content in
					ContentView(content: content)
				}
			}
			if metadata.index(after: currentIndex) != nil {
				Button(action: {self.changeIndex(by: +1)}) {
					Text("→")
						.font(.largeTitle)
				}
			}
		}
	}
	
	func changeIndex(by offset: Int) {
		if let index = metadata.index(currentIndex, offsetBy: offset) {
			currentIndex = index
		}
	}
	func goForward() {
		
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
