//
//  ImageView.swift
//  xkcd
//
//  Created by James Froggatt on 04.08.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct ImageView: View {
	@Environment(\.colorScheme) private var colorScheme: ColorScheme
	let image: UIImage
	
	var body: some View {
		let view = Image(uiImage: image)
			.resizable()
			.aspectRatio(contentMode: .fit)
		switch colorScheme {
		case .light:
			return view.asAny
		case .dark:
			return view.colorInvert().asAny
		@unknown case _:
			return view.asAny
		}
	}
}
