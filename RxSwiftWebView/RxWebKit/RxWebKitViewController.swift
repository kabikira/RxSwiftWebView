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
// RxWebKitを利用することでWKWebViewの操作がRx的に行えるようになる。

class RxWebKitViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!

    // このDisposeBagはRxの購読解除を自動化するためのもの。ViewControllerの寿命とともに購読も終了する。
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        // WKWebViewのloadingプロパティの変更を監視するObservableを作成。
        // share()は、このObservableの複数の購読者間で同じイベントを共有するためのもの。
        let loadingObserble = webView.rx.loading
            .share()

        // プログレスバーの表示/非表示を決定する。
        // ページのロード中は非表示、ロード完了で表示とする。
        loadingObserble
            .map { return !$0 }  // ロード中はtrue、完了時はfalseなので、その逆のBoolを返す。.mapは流れてくる値を変換するイメージ
            .observe(on: MainScheduler.instance)  // 以下の処理をメインスレッドで実行するようにする。
            .bind(to: progressView.rx.isHidden)   // 上記の結果に基づいてプログレスバーの表示/非表示を切り替える。
            .disposed(by: disposeBag)  // 購読解除のための処理を自動化。

        // ページのロード中に上部のアクティビティインジゲータを表示する。
        loadingObserble
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        // ページのタイトルをナビゲーションバーのタイトルとして設定。
        webView.rx.title
            .filterNil()  // nilの場合は無視する。
            .observe(on: MainScheduler.instance)  // 以下の処理をメインスレッドで実行。
            .bind(to: navigationItem.rx.title)    // タイトルを変更
            .disposed(by: disposeBag)

        // ページのロード進捗をプログレスバーに反映。
        webView.rx.estimatedProgress
            .map { return Float($0) }
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)

        // Googleのホームページをロード。
        let url = URL(string: "https://www.google.com/")!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
