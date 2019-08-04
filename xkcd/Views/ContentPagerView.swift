//
//  ContentPagerView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import SwiftUI

struct ContentPagerView: View {
	let loadFetch: (Content.Index) -> FetchModelPublisher<Content>
	@State private var index: Content.Index = Content.Index(rawValue: 2172)!
	
	var body: some View {
		HStack {
			Button("←", action: {self.index = Content.Index(rawValue: self.index.rawValue - 1)!})
				.font(.largeTitle)
			CardView {
				FetchView(fetch: self.loadFetch(self.index), loadingText: nil) {content in
					ContentView(content: content)
				}
			}
			Button("→", action: {self.index = Content.Index(rawValue: self.index.rawValue + 1)!})
				.font(.largeTitle)
		}
	}
}

#if DEBUG
struct ContentPagerView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ContentPagerView(
				loadFetch: {index in
					scrapeContent(
						for: index,
						from: fetchString(
							from: URL(string: "https://www.xkcd.com/2172/")!,
							using: .shared
						),
						using: .shared
					).fetchModel
				}
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
