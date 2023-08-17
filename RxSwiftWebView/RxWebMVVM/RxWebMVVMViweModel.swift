//
//  RxWebMVVMViweModel.swift
//  RxSwiftWebView
//
//  Created by koala panda on 2023/08/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxWebKit
import WebKit

protocol RxWebKitViewModelInput {
    // ここにViewModelへのインプットを定義します（例: ボタンタップ、テキスト入力など）
}

protocol RxWebKitViewModelOutput {
    // Viewを更新するアウトプット
    var isProgressHidden: Observable<Bool> { get }
    var networkActivityIndicatorVisible: Observable<Bool> { get }
    var pageTitle: Observable<String?> { get }
    var progressValue: Observable<Float> { get }
}

protocol RxWebKitViewModelType {
    var input: RxWebKitViewModelInput { get }
    var output: RxWebKitViewModelOutput { get }
}

class RxWebKitViewModel: RxWebKitViewModelType, RxWebKitViewModelInput, RxWebKitViewModelOutput {
    // RxWebKitViewModelType
    var input: RxWebKitViewModelInput { return self }
    var output: RxWebKitViewModelOutput { return self }

    private var webView: WKWebView

    private let defaultURLString = "https://www.google.com/"


    // RxWebKitViewModelOutput
    let isProgressHidden: Observable<Bool>
    let networkActivityIndicatorVisible: Observable<Bool>
    let pageTitle: Observable<String?>
    let progressValue: Observable<Float>

    init(webView: WKWebView) {
        self.webView = webView
        isProgressHidden = webView.rx.loading.map { !$0 }
        networkActivityIndicatorVisible = webView.rx.loading
        pageTitle = webView.rx.title
        progressValue = webView.rx.estimatedProgress.map { Float($0) }
        loadDefaultURL()

    }
    private func loadDefaultURL() {
            guard let url = URL(string: defaultURLString) else { return }
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }

}
