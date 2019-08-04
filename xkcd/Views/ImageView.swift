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
	let image: UIImage
	
	var body: some View {
		Image(uiImage: image)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.layoutPriority(1)
	}
}
