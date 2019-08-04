//
//  RootView.swift
//  xkcd
//
//  Created by James Froggatt on 15.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import SwiftUI

struct RootView: View {
	@State private var metadata: Result<Metadata, Error>? = nil
	
	var body: some View {
		FetchView(
			fetch: scrapeMetadata(
				from: fetchString(
					from: mainPage,
					using: .shared
				),
				using: .shared
			).asResultForUI,
			currentResult: $metadata,
			loadingText: nil,
			successView: {metadata in
				ContentPagerView(metadata: metadata)
			}
		)
	}
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			RootView()
		}
		.previewDevice("iPhone SE")
	}
}
#endif
