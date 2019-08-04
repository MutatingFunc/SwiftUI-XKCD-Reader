//
//  FetchModelPublisher.swift
//  xkcd
//
//  Created by James Froggatt on 04.08.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

typealias FetchModelPublisher<ContentType> = AnyPublisher<FetchModel<ContentType>, Never>

extension Publisher {
	var fetchModel: FetchModelPublisher<Output> {
		Just(.loading)
			.merge(
				with: self
				.resultPublisher()
				.map(FetchModel.complete)
			)
			.receive(on: DispatchQueue.main)
			.asAny
	}
}
