//
//  CardView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import SwiftUI

struct CardView<ViewType: View>: View {
	@Environment(\.colorScheme) private var colorScheme: ColorScheme
	let content: ViewType
	init(@ViewBuilder _ content: @escaping () -> ViewType) {
		self.content = content()
	}
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.fill(Color(.systemGray6))
				.shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.2), radius: 8, x: 0, y: 4)
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.stroke(lineWidth: 1)
				.foregroundColor(Color(.systemGray4))
			content
				.padding()
		}.padding()
	}
}

#if DEBUG
struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			CardView {
				ContentView_Previews.previews
			}
		}
		.previewDevice("iPhone SE")
	}
}
#endif
