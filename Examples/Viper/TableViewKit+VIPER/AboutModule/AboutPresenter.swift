import Foundation

class AboutPresenter: AboutPresenterProtocol {

    var router: AboutWireFrameProtocol?
    weak var view: AboutViewControllerProtocol?

    func showHelpCenter() {
        router?.presentHelpCenter()
    }

    func showFaq() {
        let message = "FAQ not implemented"
        view?.presentMessage(message, title: "Error")
    }

    func showContactUs() {
        let message = "Contact Us not implemented"
        view?.presentMessage(message, title: "Error")
    }

    func showTermsAndConditions() {
        let message = "Terms and Conditions not implemented"
        view?.presentMessage(message, title: "Error")
    }

    func showFeedback() {
        let message = "Feedback not implemented"
        view?.presentMessage(message, title: "Error")
    }

    func showShareApp() {
        let message = "Share the app not implemented"
        view?.presentMessage(message, title: "Error")
    }

    func showRateApp() {
        let message = "Rate the app not implemented"
        view?.presentMessage(message, title: "Error")
    }
}
