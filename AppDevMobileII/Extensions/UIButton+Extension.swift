import UIKit

// MARK: - Extension de UIButton

extension UIButton {

    /// Redondea las esquinas del boton.
    /// - Parameter radius: radio de las esquinas (por defecto 12).
    func round(radius: CGFloat = 12) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    /// Anima el boton con un pequeno rebote al tocarlo.
    func bounce() {
        UIView.animate(withDuration: 0.10,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { _ in
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.6,
                           options: .allowUserInteraction,
                           animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }
}

/// Boton que ejecuta bounce() en el momento del toque (touchDown).
final class BounceButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bounce()
    }
}
