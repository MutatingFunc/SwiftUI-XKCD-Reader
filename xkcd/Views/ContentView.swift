//
//  ContentView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import SwiftUI

struct ContentView: View {
	let content: Content
	@Binding var currentImage: Result<UIImage, Error>?
	
	var body: some View {
		VStack {
			Button(action: ContentPagerView.showMenuPublisher.send) {
				VStack(alignment: .trailing) {
					Text("\(self.content.index.rawValue)")
						.font(.footnote)
						.foregroundColor(Color(.secondaryLabel))
						.anchorPreference(key: IndexPickerFramePreferenceKey.self, value: .bounds, transform: {$0})
					Text(self.content.title)
						.font(.largeTitle)
						.foregroundColor(Color(.label))
						.fontWeight(.semibold)
						.frame(maxWidth: .greatestFiniteMagnitude)
				}
			}
			Spacer()
			FetchView(fetch: content.image, currentResult: $currentImage, loadingText: content.imageSrc) {image in
				ImageView(image: image)
			}
			Spacer()
			Text(content.altText)
				.font(.headline)
				.fontWeight(.medium)
				.layoutPriority(5)
		}
		.padding()
		.asAny
	}
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static let content = Content(
		index: Content.Index(rawValue: 2172)!,
		title: "Lunar Cycles",
		imageSrc: "https://imgs.xkcd.com/comics/lunar_cycles_2x.png",
		image: fetchConstantError(
			DebugError.notYetMocked,
			delay: 1
		).asResultForUI,
		altText: "The Antikythera mechanism had a whole set of gears specifically to track the cyclic popularity of skinny jeans and low-rise waists."
	)
	
	static var previews: some View {
		Group {
			ContentView(
				content: Self.content,
				currentImage: .constant(nil)
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
