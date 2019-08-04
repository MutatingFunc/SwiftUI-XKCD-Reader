//
//  CardView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import SwiftUI

struct CardView<ViewType: View>: View {
	let content: ViewType
	init(@ViewBuilder _ content: @escaping () -> ViewType) {
		self.content = content()
	}
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.fill(Color(.secondarySystemBackground))
				.shadow(color: Color(.systemGray3), radius: 32, x: 0, y: 0)
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.stroke(lineWidth: 5)
				.foregroundColor(Color(.systemFill))
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
