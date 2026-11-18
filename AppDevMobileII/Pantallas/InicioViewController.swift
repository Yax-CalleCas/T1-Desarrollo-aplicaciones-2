import UIKit

class InicioViewController: UIViewController {

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.text = "DevMobile II"
        label.font = .boldSystemFont(ofSize: 34)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let comenzarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comenzar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = Constantes.celeste
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurarUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func configurarUI() {
        view.addSubview(tituloLabel)
        view.addSubview(comenzarButton)

        comenzarButton.round()
        comenzarButton.addTarget(self, action: #selector(comenzarTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            tituloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: Constantes.vertical),
            tituloLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: Constantes.horizontal),
            tituloLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -Constantes.horizontal),

            comenzarButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            comenzarButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            comenzarButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: Constantes.horizontal),
            comenzarButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -Constantes.horizontal),
            comenzarButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    @objc private func comenzarTapped() {
        comenzarButton.bounce()
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
