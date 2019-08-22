//
//  RootView.swift
//  xkcd
//
//  Created by James Froggatt on 15.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Combine
import SwiftUI

struct RootView: View {
	let haptics = UISelectionFeedbackGenerator()
	@State private var metadata: Result<Metadata, Error>? = nil
	@State private var currentIndex: Content.Index? = nil {
		didSet {
			let edgeCaseEqual = (oldValue == nil && currentIndex == (try? metadata?.get().latestContent.index))
			if oldValue != currentIndex && !edgeCaseEqual {
				haptics.selectionChanged()
			}
		}
	}
	
	@State private var fetchedContent: [Content.Index: Result<Content, Error>] = [:]
	@State private var fetchedImages: [Content.Index: Result<UIImage, Error>] = [:]
	
	@State private var showIndexPicker: Bool = false
	
	var body: some View {
		FetchView(
			fetch: scrapeMetadata(
				from: fetchString(
					from: mainPage,
					using: .shared
				),
				using: .shared
			).asResultForUI,
			currentResult: $metadata,
			loadingText: nil,
			successView: {metadata in
				ContentPagerView(
					currentIndex: self.loadedCurrentIndex(metadata: metadata),
					index: metadata.index(_:offsetBy:),
	    	    	contentView: {index in
    	    	    	self.contentView(at: index, using: metadata).asAny
	    	    	},
	    	    	modifyContentView: {view, offset in
						self.modifyView(view, atOffset: offset, using: metadata).asAny
	    	    	}
				).onReceive(showMenuPublisher) {
	    	    	self.showIndexPicker = true
    	    	}
			}
		).onAppear(perform: haptics.prepare)
	}
	
	private func loadedCurrentIndex(metadata: Metadata) -> Binding<Content.Index> {
    	Binding(
	    	get: {self.currentIndex ?? metadata.latestContent.index},
	    	set: {self.currentIndex = $0}
    	)
	}
	
	private func contentView(at index: Content.Index, using metadata: Metadata) -> some View {
    	CardView {
	    	FetchView(
    	    	fetch: metadata.fetchContent(index),
    	    	currentResult: self.$fetchedContent[index],
    	    	loadingText: nil,
    	    	successView: {content in
	    	    	ContentView(
    	    	    	content: content,
    	    	    	currentImage: self.$fetchedImages[index]
	    	    	)
    	    	}
	    	)
    	}
	}
	
	private func modifyView(_ view: AnyView, atOffset offset: Int, using metadata: Metadata) -> AnyView {
		if offset != 0 {
			return view.asAny
		}
		return view
	    	.backgroundPreferenceValue(IndexPickerFramePreferenceKey.self) {anchor in
    	    	GeometryReader {(geometry: GeometryProxy) -> AnyView in
	    	    	let frame = anchor.map{geometry[$0]} ?? .zero
	    	    	return Rectangle()
						.fill(Color.clear)
    	    	    	.frame(width: frame.width, height: frame.height)
    	    	    	.offset(x: frame.minX, y: frame.minY)
    	    	    	.popover(isPresented: self.$showIndexPicker, attachmentAnchor: .rect(.rect(frame)), arrowEdge: .top) {
	    	    	    	IndexPicker(
    	    	    	    	validRange: Content.Index(rawValue: 1)!...metadata.latestContent.index,
    	    	    	    	index: self.loadedCurrentIndex(metadata: metadata),
    	    	    	    	onIndexSelected: {
									self.showIndexPicker = false
								}
	    	    	    	)
    	    	    	}.asAny
    	    	}
	    	}
			.asAny
	}
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			RootView()
		}
		.previewDevice("iPhone SE")
	}
}
#endif
