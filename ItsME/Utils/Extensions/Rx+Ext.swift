//
//  Rx+Ext.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/13.
//

import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return self.asDriver(onErrorDriveWith: .empty())
    }
    
    func asSignalOnErrorJustComplete() -> Signal<Element> {
        return self.asSignal(onErrorSignalWith: .empty())
    }
}

extension ObservableType {
    
    func mapToVoid() -> Observable<Void> {
        return self.map { _ in }
    }
}