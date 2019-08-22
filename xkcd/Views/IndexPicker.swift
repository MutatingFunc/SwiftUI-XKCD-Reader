//
//  IndexPicker.swift
//  xkcd
//
//  Created by James Froggatt on 18/08/2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import SwiftUI

struct IndexPicker<IndexType>: View
where IndexType: RawRepresentable & Comparable & Identifiable & Strideable, IndexType.Stride: SignedInteger, IndexType.RawValue: _FormatSpecifiable {
	
	let validRange: ClosedRange<IndexType>
	@Binding var index: IndexType
	let onIndexSelected: () -> ()
	
	var body: some View {
    	List {
	    	ForEach(validRange.reversed()) {index in
    	    	Button(action: {
	    	    	self.index = index
	    	    	self.onIndexSelected()
    	    	}) {
	    	    	Text("\(index.rawValue)")
    	    	}
	    	}
    	}
	}
}

#if DEBUG
struct IndexPicker_Previews: PreviewProvider {

	static var previews: some View {
    	Group {
	    	IndexPicker(
    	    	validRange: 1...5,
    	    	index: .constant(1),
    	    	onIndexSelected: {}
	    	)
    	}
    	.previewDevice("iPhone SE")
	}
}

extension Int: RawRepresentable, Identifiable {
	public init?(rawValue: Int) {self = rawValue}
	public var rawValue: Int {self}
	public var id: Int {self}
}
#endif
