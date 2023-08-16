//
//  TextFieldViewController.swift
//  RxSwiftWebView
//
//  Created by koala panda on 2023/08/16.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional

class TextFieldViewController: UIViewController {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let text = textField.rx.text
            .map { text -> String in
                print("call")
                return "☆☆\(text!)☆☆"
            }
            .share()
        text
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)

        text
            .bind(to: label2.rx.text)
            .disposed(by: disposeBag)
        text
            .bind(to: label3.rx.text)
            .disposed(by: disposeBag)


    }


}
