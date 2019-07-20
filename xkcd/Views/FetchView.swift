//
//  FetchView.swift
//  xkcd
//
//  Created by James Froggatt on 28.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import SwiftUI
/*
struct FetchView<ModelType, ViewType: View>: View {
	@ObjectBinding var viewModel: FetchViewModel<ModelType>
	let createView: (ModelType) -> ViewType
	
	var body: some View {
		let view: AnyView
		switch viewModel.model {
		case .loading:
			view = ActivityIndicator(isAnimating: .constant(true), style: .large)
				.onAppear(perform: viewModel.viewAppeared)
				.onDisappear(perform: viewModel.viewDisappeared)
				.asAny
		case .complete(.failure(let error)):
			view = ErrorView(error: error, retry: viewModel.retry)
				.asAny
		case .complete(.success(let model)):
			view = createView(model)
				.asAny
		}
		FetchView(viewModel: FetchViewModel({ImageFetcher(urlSession: .shared).fetch(URL(string: "://")!)})) {model in
			Image(model)
		}
		return view
	}
}
*/
