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
	@ObjectBinding var viewModel: FetchViewModel<Metadata>
	let contentViewModel: (Content.Index) -> FetchViewModel<Content>
	var body: some View {
		switch viewModel.model {
		case .loading:
			return ActivityIndicator(isAnimating: .constant(true), style: .large)
				.onAppear(perform: viewModel.viewAppeared)
				.onDisappear(perform: viewModel.viewDisappeared)
				.asAny
		case .complete(.failure(let error)):
			return ErrorView(error: error, retry: viewModel.retry)
				.asAny
		case .complete(.success(let metadata)):
			return ContentPagerView(
				contentViewModel: contentViewModel,
				metadata: metadata,
				index: metadata.latestContent.index
			)
			.asAny
		}
	}
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
	static func content(_ index: Content.Index) -> Content {
		Content(
			index: index,
			title: "Normal Title \(index.rawValue)",
			imageSrc: URL(string: "://")!,
			altText: "Witty alt text goes here, explaining something tangental"
		)
	}
	static func contentViewModel(_ index: Content.Index) -> FetchViewModel<Content> {
		FetchViewModel {
			ConstantFetcher(
				constant: content(index),
				delay: 1
			).fetch(URL(string: "://")!)
		}
	}
	static var previews: some View {
		Group {
			RootView(
				viewModel: FetchViewModel {
					ConstantFetcher(
						constant: Metadata(
							latestContent: RootView_Previews.content(Content.Index(rawValue: 1)!)
						),
						delay: 1
					).fetch(URL(string: "://")!)
					//MetadataScraper(fetcher: StringFetcher(urlSession: .shared).asAny).scrape(())
				},
				contentViewModel: contentViewModel
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
