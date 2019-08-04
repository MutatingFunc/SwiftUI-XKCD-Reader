//
//  FetchView.swift
//  xkcd
//
//  Created by James Froggatt on 04.08.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation
import SwiftUI

struct FetchView<ContentType, ViewType: View>: View {
	let fetch: ResultPublisher<ContentType>
	@Binding var currentResult: Result<ContentType, Error>?
	let loadingText: String?
	let successView: (ContentType) -> ViewType
	
	var body: some View {
		switch currentResult {
		case nil:
			return HStack {
				ActivityIndicator(
					isAnimating: .constant(true),
					style: loadingText == nil ? .large : .medium
				)
				if loadingText != nil {
					Text(loadingText!)
				}
			}
			.onReceive(fetch) {
				self.currentResult = $0
			}
			.asAny
		case .failure(let error):
			return ErrorView(error: error, retry: {
				self.currentResult = nil
			})
			.asAny
		case .success(let content):
			return successView(content)
				.asAny
		}
	}
}

#if DEBUG
struct FetchView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			FetchView(
				fetch: fetchConstant(
					ContentView_Previews.content,
					delay: 1
				).asResult,
				currentResult: .constant(nil),
				loadingText: nil,
				successView: {content in
					ContentView(content: content)
				}
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
