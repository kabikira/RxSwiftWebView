//
//  RxWebKitViewController.swift
//  RxSwiftWebView
//
//  Created by koala panda on 2023/08/17.
//

import UIKit
import WebKit
import RxWebKit
import RxCocoa
import RxSwift
//RxWebKitでkeyのベタ書き､値型の指定がなくなる

class RxWebKitViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!

    private let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()

    }
    private func setupWebView() {
        let loadingObserble = webView.rx.loading
            .share()

        loadingObserble
            .map { return !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)

        loadingObserble
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        webView.rx.title
            .filterNil()
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        webView.rx.estimatedProgress
            .map { return Float($0) }
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)

        let url = URL(string: "https://www.google.com/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    


}
