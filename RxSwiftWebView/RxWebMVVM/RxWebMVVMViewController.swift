//
//  RxWebMVVMViewController.swift
//  RxSwiftWebView
//
//  Created by koala panda on 2023/08/17.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import RxOptional


class RxWebMVVMViewController: UIViewController {

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!

    private let disposeBag = DisposeBag()
    private var viewModel: RxWebKitViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RxWebKitViewModel(webView: webView)
        setupBindings()
        

    }

    private func setupBindings() {
        viewModel.isProgressHidden
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.networkActivityIndicatorVisible
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        viewModel.pageTitle
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.progressValue
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
    }
    



}
