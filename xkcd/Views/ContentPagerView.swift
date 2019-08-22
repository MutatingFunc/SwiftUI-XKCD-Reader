//
//  ContentPagerView.swift
//  xkcd
//
//  Created by James Froggatt on 20.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import SwiftUI

struct IndexPickerFramePreferenceKey: PreferenceKey {
	typealias Value = Anchor<CGRect>?
	
	static var defaultValue: Value = nil
	
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value = value ?? nextValue()
	}
}

let showMenuPublisher = PassthroughSubject<(), Never>()
struct ContentPagerView<IndexType>: View
where IndexType: Strideable, IndexType.Stride: BinaryInteger & Identifiable, IndexType.Stride.Stride: SignedInteger {
	let index: (IndexType, _ offsetBy: IndexType.Stride) -> IndexType?
	@Binding var currentIndex: IndexType
	let contentView: (IndexType) -> AnyView
	///Applied only to the view currently displayed, for customisation when in focus
	let modifyContentView: (AnyView, _ offset: IndexType.Stride) -> AnyView
	let contentViewBuffer: IndexType.Stride = 2
	@State private var dragXOffset: CGFloat = 0
	
	var body: some View {
		GeometryReader {geometry -> AnyView in
			let drag = DragGesture(minimumDistance: 1, coordinateSpace: .global)
				.onChanged {value in
					self.dragXOffset = value.translation.width
				}
				.onEnded {value in
					let contentDimensions = self.contentDimensions(in: geometry)
					var newIndex = self.currentIndex
					if value.predictedEndTranslation.width >= contentDimensions.width/2, let index = self.index(self.currentIndex, -1) {
						self.dragXOffset -= contentDimensions.width
						newIndex = index
					} else if value.predictedEndTranslation.width <= -contentDimensions.width/2, let index = self.index(self.currentIndex, +1) {
						self.dragXOffset += contentDimensions.width
						newIndex = index
					}
					let hasChanged = newIndex != self.currentIndex
					self.currentIndex = newIndex
					
					withAnimation(hasChanged ? .interactiveSpring() : .spring()) {
						self.dragXOffset = 0
					}
				}
			return ZStack {
				Group {
					ForEach(-self.contentViewBuffer ... self.contentViewBuffer) {offset in
						self.index(self.currentIndex, offset)
							.map{self.page(for: $0, in: geometry)}
					}
				}
			}
			.gesture(drag)
			.asAny
		}
	}
	
	func page(for index: IndexType, in geometry: GeometryProxy) -> some View {
    	let offsetFromCurrentIndex = self.currentIndex.distance(to: index)
		let contentDimensions = self.contentDimensions(in: geometry)
		let xOffset = self.dragXOffset + (contentDimensions.inset/2) + (CGFloat(offsetFromCurrentIndex) * contentDimensions.width)
		let opacity = Double(max(0, (contentDimensions.width * 1.5 - abs(xOffset)) / contentDimensions.width))
		return self.modifyContentView(
			self
				.contentView(index)
				.frame(width: contentDimensions.width)
				.offset(x: xOffset)
				.opacity(opacity)
				.asAny,
			offsetFromCurrentIndex
		)
			
	}
	private func contentDimensions(in geometry: GeometryProxy) -> (width: CGFloat, inset: CGFloat) {
		let inset = geometry.size.width > geometry.size.height ? geometry.size.width / 10 : 0
		return (width: geometry.size.width - inset, inset: inset)
	}
}

#if DEBUG
struct ContentPagerView_Previews: PreviewProvider {
	static let metadata = Metadata(
		latestContent: ContentView_Previews.content,
		fetchContent: {index in
			scrapeContent(
				for: index,
				from: fetchString(
					from: contentPage(index: index),
					using: .shared
				),
				using: .shared
			).asResultForUI
		}
	)
	@State static var index = 1
	
	static var previews: some View {
		Group {
			ContentPagerView(
    	    	index: {$0 + $1},
    	    	currentIndex: $index,
				contentView: {Text("\($0)").asAny},
    	    	modifyContentView: {view, offset in view}
			)
		}
		.previewDevice("iPhone SE")
	}
}
#endif
