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
	
	var body: some View {
		VStack {
			Text("\(content.index.rawValue)")
				.font(.footnote)
				.foregroundColor(Color(.secondaryLabel))
				.frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
			Text(content.title)
				.font(.largeTitle)
				.fontWeight(.semibold)
				.frame(alignment: .center)
			Spacer()
			FetchView(fetch: content.image, loadingText: content.imageSrc) {image in
				ImageView(image: image)
			}
			Spacer()
			Text("\(content.altText)")
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
		).fetchModel,
		altText: "The Antikythera mechanism had a whole set of gears specifically to track the cyclic popularity of skinny jeans and low-rise waists."
	)
	
	static var previews: some View {
		Group {
			ContentView(
				content: Self.content
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
