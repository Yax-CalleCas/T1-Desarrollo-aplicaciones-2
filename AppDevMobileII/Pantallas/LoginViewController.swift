import UIKit

class LoginViewController: UIViewController {

    private let usuarioTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Usuario"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let contrasenaTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contraseña"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let ingresarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ingresar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = Constantes.celeste
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cerrarSesionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cerrar sesión", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login"
        configurarUI()
        usuarioTextField.text = UserDefaults.standard.string(forKey: Constantes.kUsuario)
    }

    private func configurarUI() {
        view.addSubview(usuarioTextField)
        view.addSubview(contrasenaTextField)
        view.addSubview(ingresarButton)
        view.addSubview(cerrarSesionButton)

        ingresarButton.round()
        ingresarButton.addTarget(self, action: #selector(ingresarTapped), for: .touchUpInside)
        cerrarSesionButton.addTarget(self, action: #selector(cerrarSesionTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            usuarioTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: Constantes.horizontal),
            usuarioTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -Constantes.horizontal),
            usuarioTextField.heightAnchor.constraint(equalToConstant: 44),
            usuarioTextField.bottomAnchor.constraint(equalTo: contrasenaTextField.topAnchor,
                                                     constant: -Constantes.vertical),

            contrasenaTextField.leadingAnchor.constraint(equalTo: usuarioTextField.leadingAnchor),
            contrasenaTextField.trailingAnchor.constraint(equalTo: usuarioTextField.trailingAnchor),
            contrasenaTextField.heightAnchor.constraint(equalToConstant: 44),
            contrasenaTextField.bottomAnchor.constraint(equalTo: ingresarButton.topAnchor,
                                                        constant: -Constantes.vertical),

            ingresarButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            ingresarButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            ingresarButton.leadingAnchor.constraint(equalTo: usuarioTextField.leadingAnchor),
            ingresarButton.trailingAnchor.constraint(equalTo: usuarioTextField.trailingAnchor),
            ingresarButton.heightAnchor.constraint(equalToConstant: 52),

            cerrarSesionButton.topAnchor.constraint(equalTo: ingresarButton.bottomAnchor,
                                                    constant: Constantes.vertical),
            cerrarSesionButton.centerXAnchor.constraint(equalTo: ingresarButton.centerXAnchor)
        ])
    }

    private func validar() -> String? {
        let usuario = usuarioTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let contrasena = contrasenaTextField.text ?? ""

        if usuario.isEmpty || contrasena.isEmpty {
            return "Debe completar ambos campos."
        }
        if usuario.count <= 6 {
            return "El usuario debe tener más de 6 caracteres."
        }
        if contrasena.count <= 3 {
            return "La contraseña debe tener más de 3 caracteres."
        }
        return nil
    }

    @objc private func ingresarTapped() {
        ingresarButton.bounce()

        if let mensaje = validar() {
            let alerta = UIAlertController(title: "Error al iniciar sesión",
                                           message: mensaje,
                                           preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alerta, animated: true)
            return
        }

        let usuario = usuarioTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        UserDefaults.standard.set(usuario, forKey: Constantes.kUsuario)

        navigationController?.pushViewController(TareasViewController(), animated: true)
    }

    @objc private func cerrarSesionTapped() {
        cerrarSesionButton.bounce()

        UserDefaults.standard.removeObject(forKey: Constantes.kUsuario)
        usuarioTextField.text = nil
        contrasenaTextField.text = nil

        let alerta = UIAlertController(title: "Sesión cerrada",
                                       message: "Se eliminó el usuario guardado.",
                                       preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
