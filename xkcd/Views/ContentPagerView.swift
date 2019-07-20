//
//  ContentPagerView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import SwiftUI

struct ContentPagerView: View {
	let contentViewModel: (Content.Index) -> FetchViewModel<Content>
	let metadata: Metadata
	@State var index: Content.Index
	
	var body: some View {
		GeometryReader(content: {self.view($0)})
	}
	
	func view(_ proxy: GeometryProxy, lowerBound: Int = 1, upperBound: Int = 5) -> some View {
		let frame = proxy.frame(in: .local)
		return List {
			ForEach(lowerBound...upperBound) {index in
				ContentView(
					viewModel: self.contentViewModel(Content.Index(rawValue: index)!)
				).frame(width: frame.width, height: frame.height)
			}
		}
	}
}

#if DEBUG
struct ContentPagerView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ContentPagerView(
				contentViewModel: RootView_Previews.contentViewModel,
				metadata: Metadata(
					latestContent: RootView_Previews.content(Content.Index(rawValue: 100)!)
				),
				index: Content.Index(rawValue: 1)!
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
