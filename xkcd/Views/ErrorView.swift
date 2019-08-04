//
//  ErrorView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
	let error: Error
	let retry: () -> ()
	
	var body: some View {
		VStack {
			Text("Error: \(error.localizedDescription)")
			Button("Retry", action: retry)
		}
	}
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ErrorView(
				error: DebugError.exampleError,
				retry: {}
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
