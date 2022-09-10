//
//  EncodableExtension.swift
//  GrubChaser
//
//  Created by Douglas Immig on 23/08/22.
//

import Foundation

public extension Encodable {
    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}
