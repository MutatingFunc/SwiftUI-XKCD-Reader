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
	@State private var metadata: Result<Metadata, Error>? = nil
	@State private var currentIndex: Content.Index? = nil
    
    @State private var fetchedContent: [Content.Index: Result<Content, Error>] = [:]
    @State private var fetchedImages: [Content.Index: Result<UIImage, Error>] = [:]
	
    @State private var showIndexPicker: Bool = false
    
    func loadedCurrentIndex(metadata: Metadata) -> Binding<Content.Index> {
        Binding(
            get: {self.currentIndex ?? metadata.latestContent.index},
            set: {self.currentIndex = $0}
        )
    }
    
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
					index: metadata.index(_:offsetBy:),
                    currentIndex: self.loadedCurrentIndex(metadata: metadata),
                    contentView: {index in
                        self.contentView(at: index, using: metadata).asAny
                    },
                    primaryContentModifier: {primaryView in
                        self.primaryContentModifier(primaryView, using: metadata).asAny
                    }
				).onReceive(showMenuPublisher) {
                    self.showIndexPicker = true
                }
			}
		)
	}
    
    func contentView(at index: Content.Index, using metadata: Metadata) -> some View {
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
    
    func primaryContentModifier(_ view: AnyView, using metadata: Metadata) -> some View {
        view
            .backgroundPreferenceValue(IndexPickerFramePreferenceKey.self) {anchor in
                GeometryReader {(proxy: GeometryProxy) -> AnyView in
                    let frame = anchor.map{proxy[$0]} ?? .zero
                    return Rectangle()
                        .frame(width: frame.width, height: frame.height)
                        .offset(x: frame.minX, y: frame.minY)
                        .popover(isPresented: self.$showIndexPicker, attachmentAnchor: .rect(.rect(frame)), arrowEdge: .top) {
                            IndexPicker(
                                validRange: Content.Index(rawValue: 1)!...metadata.latestContent.index,
                                index: self.loadedCurrentIndex(metadata: metadata),
                                onIndexSelected: {self.showIndexPicker = false}
                            )
                        }.asAny
                }
            }
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
