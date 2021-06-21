//
//  Observable.swift
//  FLO
//
//  Created by Dain Song on 2021/06/21.
//

import Foundation

class Observable<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}
