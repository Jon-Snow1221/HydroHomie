//
//  HydroError.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/8/21.
//

import Foundation

enum HydroError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String? {
        switch self {
            
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Could not unwrap water entry."
        }
    }
}
