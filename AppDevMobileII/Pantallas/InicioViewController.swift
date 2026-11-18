import UIKit

class InicioViewController: UIViewController {

    // MARK: - Componentes

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.text = "DevMobile II"
        label.font = .boldSystemFont(ofSize: 34)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let comenzarButton: BounceButton = {
        let button = BounceButton(type: .system)
        button.setTitle("Comenzar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = Constantes.celeste
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Inicio"
        configurarUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // La pantalla de inicio no usa barra de navegacion.
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Layout

    private func configurarUI() {
        view.addSubview(tituloLabel)
        view.addSubview(comenzarButton)

        comenzarButton.round()
        comenzarButton.addTarget(self, action: #selector(comenzarTapped), for: .touchUpInside)

        // El boton queda centrado vertical y horizontalmente.
        let centradoVertical = comenzarButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        let centradoHorizontal = comenzarButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)

        // El titulo va centrado en la parte superior, separado 12 del area segura.
        NSLayoutConstraint.activate([
            tituloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: Constantes.vertical),
            tituloLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: Constantes.horizontal),
            tituloLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -Constantes.horizontal),

            centradoVertical,
            centradoHorizontal,
            comenzarButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: Constantes.horizontal),
            comenzarButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -Constantes.horizontal),
            comenzarButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    // MARK: - Acciones

    @objc private func comenzarTapped() {
        comenzarButton.bounce()

        // Navegacion por codigo, sin segue.
        let login = LoginViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(login, animated: true)
    }
}
