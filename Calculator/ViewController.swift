import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var operationDescriptionLabel: UILabel!
    //Operation buttons
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var divisionButton: UIButton!
    @IBOutlet weak var multiplicationButton: UIButton!
    @IBOutlet weak var squareRootButton: UIButton!
    @IBOutlet weak var cosButton: UIButton!
    @IBOutlet weak var sinButton: UIButton!
    @IBOutlet weak var piButton: UIButton!
    //Action buttons
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    private var calculator = CalculatorViewModel()
    private let disposableBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enterButton.rx_tap.subscribeNext({ [weak self] _ in
            self?.calculator.enter()
            }).addDisposableTo(self.disposableBag)
        
        self.additionButton.rx_tap.subscribeNext({[weak self] _ in
            self?.calculator.calculate(.Addition)
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.subtractionButton.rx_tap.subscribeNext({[weak self] _ in
            self?.calculator.calculate(.Subtraction)
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.divisionButton.rx_tap.subscribeNext({[weak self] _ in
            self?.calculator.calculate(.Division)
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.multiplicationButton.rx_tap.subscribeNext({[weak self] _ in
            self?.calculator.calculate(.Multiplication)
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.squareRootButton.rx_tap.subscribeNext ({ [weak self] _ in
            self?.calculator.calculate(.SquareRoot)
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.sinButton.rx_tap.subscribeNext ({ [weak self] _ in
            self?.calculator.calculate(.Sin)
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.cosButton.rx_tap.subscribeNext ({ [weak self] _ in
            self?.calculator.calculate(.Cos)
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.piButton.rx_tap.subscribeNext ({ [weak self] _ in
            self?.calculator.calculate(.Pi)
            self?.updateDisplay(self?.calculator.displayText)
        }).addDisposableTo(self.disposableBag)
        
        self.dotButton.rx_tap.subscribeNext({ [weak self] _ in
            if let text = self?.displayLabel.text {
                self?.updateDisplay(self?.calculator.addDotToDisplayText(text))
            }
            }).addDisposableTo(self.disposableBag)
        
        self.clearButton.rx_tap.subscribeNext ({ [weak self] _ in
            self?.calculator.reset()
            self?.updateDisplay(self?.calculator.displayText)
            }).addDisposableTo(self.disposableBag)
        
        self.calculator.optStackSubject.asObservable().subscribeNext ({ (array) in
            self.operationDescriptionLabel.text = "\(array)"
        }).addDisposableTo(self.disposableBag)
        
    }
    
    @IBAction func appendNumber(sender: UIButton) {
        
        guard let number = sender.titleLabel?.text else {
            return
        }
        
        self.calculator.appendNumber(number)
        displayLabel.rx_text.onNext(self.calculator.displayText)
    }
    
    func updateDisplay(text: String?) {
        if let text = text {
            self.displayLabel.rx_text.onNext(text)
        }
    }
}
