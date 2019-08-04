//
//  FetchViewModel.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
/*
class FetchViewModel<ModelType>: ObservableObject {
	private let source: () -> AnyPublisher<FetchModel<ModelType>, Never>
	fileprivate var cancel: AnyCancellable?
	
	@Published var model: FetchModel<ModelType>
	
	init(_ source: AnyPublisher<ModelType, Error>) {
		self.model = .loading
		self.source = {
			Just(.loading).merge(
				with: source
				.resultPublisher()
				.map(FetchModel.complete)
			)
			.receive(on: DispatchQueue.main)
			.asAny
		}
	}
	
	func viewAppeared() {
		cancel = cancel ?? source().assign(to: \.model, on: self)
	}
	func retry() {
		cancel?.cancel()
		cancel = source().assign(to: \.model, on: self)
	}
	func viewDisappeared() {
		//cancel?.cancel()
	}
}
*/
