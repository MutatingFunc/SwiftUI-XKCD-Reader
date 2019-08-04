//
//  FetchCache.swift
//  xkcd
//
//  Created by James Froggatt on 04.08.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation
import Combine
/*
class FetchCache: ObservableObject {
	@Published private var fetches: [Content.Index: (viewModel: FetchViewModel<Content>, cancellable: AnyCancellable)] = [:]
	
	let objectWillChange = PassthroughSubject<(), Never>()
	
	func fetch(_ index: Content.Index, from source: @escaping () -> AnyPublisher<Content, Error>) -> FetchViewModel<Content> {
		if let fetch = fetches[index]?.viewModel {
			return fetch
		} else {
			let fetch = FetchViewModel(source)
			let cancellable = fetch.objectWillChange.sink(receiveValue: objectWillChange.send)
			fetches[index] = (fetch, cancellable)
			return fetch
		}
	}
}
*/
