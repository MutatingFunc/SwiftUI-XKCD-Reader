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
	let fetch: FetchModelPublisher<ContentType>
	let loadingText: String?
	let successView: (ContentType) -> ViewType
	@State private var viewModel: FetchModel<ContentType> = .loading
	
	var body: some View {
		switch viewModel {
		case .loading:
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
				self.viewModel = $0
			}
			.asAny
		case .complete(.failure(let error)):
			return ErrorView(error: error, retry: {
				self.viewModel = .loading
			})
			.asAny
		case .complete(.success(let content)):
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
				).fetchModel,
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
