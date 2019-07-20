//
//  DebugError.swift
//  xkcd
//
//  Created by James Froggatt on 19.07.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation

enum DebugError: String, LocalizedError {
	case notYetMocked = "Not yet mocked"
	case exampleError = "A non-specific error occured"
	
	var errorDescription: String? {self.rawValue}
}
