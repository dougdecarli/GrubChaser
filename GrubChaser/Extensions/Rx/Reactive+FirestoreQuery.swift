//
//  Reactive+FirestoreQuery.swift
//  GrubChaser
//
//  Created by Douglas Immig on 18/08/22.
//

import CodableFirebase
import FirebaseFirestore
import RxSwift
import RxCocoa

public extension ObservableType where Element: QuerySnapshot {
    
    /// Decode data from QuerySnapshot
    ///
    /// - Parameter type: Decodable
    /// - Returns: Observable
    func decode<T: Decodable>(_ type: T.Type) -> Observable<[T]> {
        return self.flatMapLatest { document -> Observable<[T]> in
            var documents = [T]()
            document.documentChanges.forEach { documentChange in
                do {
                    let data = documentChange.document.data()
                    let response = try FirestoreDecoder().decode(type, from: data)
                    documents.append(response)
                } catch {
                    print("Could not decode to \(type)")
                    print("\(error)")
                }
            }
            if !documents.isEmpty {
                return Observable.just(documents)
            }
            return Observable.empty()
        }
    }
}

public extension ObservableType where Element: DocumentSnapshot {
    
    /// Decode data from DocumentSnapshot
    ///
    /// - Parameter type: Decodable
    /// - Returns: Observable
    func decodeDocument<T: Decodable>(_ type: T.Type) -> Observable<T> {
        return self.flatMapLatest { document -> Observable<T> in
            if let data = document.data() {
                do {
                    let response = try FirestoreDecoder().decode(type, from: data)
                    return Observable.just(response)
                } catch {
                    print("Could not decode to \(type)")
                    print("\(error)")
                }
            }
            return Observable.empty()
        }
    }
}
