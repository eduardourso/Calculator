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

        calculateAndUpdateDisplayWhenButtonClicked(self.additionButton, operation: .Addition)
        calculateAndUpdateDisplayWhenButtonClicked(self.subtractionButton, operation: .Subtraction)
        calculateAndUpdateDisplayWhenButtonClicked(self.divisionButton, operation: .Division)
        calculateAndUpdateDisplayWhenButtonClicked(self.multiplicationButton, operation: .Multiplication)
        calculateAndUpdateDisplayWhenButtonClicked(self.squareRootButton, operation: .SquareRoot)
        
        self.enterButton.rx_tap.subscribeNext({ [weak self] _ in
            self?.calculator.enter()
            }).addDisposableTo(self.disposableBag)

        self.dotButton.rx_tap.subscribeNext({ [weak self] _ in
            if let text = self?.displayLabel.text {
                if let text2 = self?.calculator.addDotToNumber(text) {
                    self?.displayLabel.rx_text.onNext(text2)
                }
            }
            }).addDisposableTo(self.disposableBag)
        
        self.clearButton.rx_tap.subscribeNext ({ [weak self] _ in
            self?.calculator.reset()
            self?.updateDisplayText()
        }).addDisposableTo(self.disposableBag)

        self.calculator.observableOptStack().subscribeNext ({ (array) in
            self.operationDescriptionLabel.text = "\(array)"
        }).addDisposableTo(self.disposableBag)
        
    }
    
    @IBAction func appendNumber(sender: UIButton) {
        
        guard let number = sender.titleLabel?.text else {
            return
        }
        
        self.calculator.appendNumber(number)
        updateDisplayText()
    }

    func updateDisplayText() {
        self.displayLabel.rx_text.onNext(self.calculator.displayTextString())
    }
    
    func calculateAndUpdateDisplayWhenButtonClicked(button: UIButton, operation: CalculatorViewModel.Operation) {
        button.rx_tap.subscribeNext ({ [weak self] _ in
            self?.calculator.calculate(operation)
            self?.updateDisplayText()
        }).addDisposableTo(self.disposableBag)
    }
}
