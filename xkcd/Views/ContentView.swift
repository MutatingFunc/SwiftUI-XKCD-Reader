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
	@ObjectBinding var viewModel: FetchViewModel<Content>
	
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
		case .complete(.success(let content)):
			return VStack {
				Text(content.title)
					.font(.largeTitle)
					.fontWeight(.semibold)
					.frame(alignment: .center)
				Spacer()
				/*
				FetchView(viewModel: FetchViewModel({ImageFetcher(urlSession: .shared).fetch(content.imageSrc)})) {
					Image($0)
				}*/
				Text("Image")
				Spacer()
				Text("\(content.altText)")
					.font(.headline)
					.fontWeight(.medium)
					.layoutPriority(5)
			}
			.lineLimit(nil)
			.padding()
			.asAny
		}
	}
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		return Group {
			ContentView(
				viewModel: FetchViewModel {
					ConstantFetcher(
						constant: Content(
							index: Content.Index(rawValue: 1)!,
							title: "Normal Title",
							imageSrc: URL(string: "://")!,
							altText: "Witty alt text goes here, explaining something tangental"
						),
						delay: 1
					).fetch(URL(string: "://")!)
				}
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
