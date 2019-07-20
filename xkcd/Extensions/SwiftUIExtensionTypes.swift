//
//  SwiftUIExtensionTypes.swift
//  xkcd
//
//  Created by James Froggatt on 11.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
	
	@Binding var isAnimating: Bool
	let style: UIActivityIndicatorView.Style
	
	func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
		return UIActivityIndicatorView(style: style)
	}
	
	func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
		isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
	}
}
