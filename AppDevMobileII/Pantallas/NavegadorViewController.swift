import UIKit
import WebKit
import CoreData

class NavegadorViewController: UIViewController {

    private var webView: WKWebView!
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()

    private var botonAtras: UIBarButtonItem!
    private var botonAdelante: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Navegador"

        let configuracion = WKWebViewConfiguration()
        configuracion.defaultWebpagePreferences.allowsContentJavaScript = true

        webView = WKWebView(frame: .zero, configuration: configuracion)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        refreshControl.addTarget(self, action: #selector(recargar), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl

        botonAtras = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(irAtras))
        botonAdelante = UIBarButtonItem(image: UIImage(systemName: "chevron.right"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(irAdelante))
        botonAtras.isEnabled = false
        botonAdelante.isEnabled = false
        navigationItem.leftBarButtonItems = [botonAtras, botonAdelante]

        searchBar.placeholder = "Escribe una dirección https"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchBar

        webView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let usuario = UserDefaults.standard.string(forKey: Constantes.kUsuario) ?? "Sin usuario"
        let solicitud = NSFetchRequest<NSManagedObject>(entityName: "Tarea")
        let total = (try? Constantes.contexto.count(for: solicitud)) ?? 0

        let alerta = UIAlertController(title: "Resumen",
                                       message: "Usuario: \(usuario)\nTareas registradas: \(total)",
                                       preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

    @objc private func irAtras() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc private func irAdelante() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    @objc private func recargar() {
        webView.reload()
    }
}

extension NavegadorViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let texto = searchBar.text?
            .trimmingCharacters(in: .whitespacesAndNewlines),
            !texto.isEmpty else { return }

        guard let url = URL(string: "https://\(texto)"),
              url.scheme == "https" else {
            let alerta = UIAlertController(title: "Dirección no válida",
                                           message: "Solo se permiten direcciones https.",
                                           preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alerta, animated: true)
            return
        }

        webView.load(URLRequest(url: url))
    }
}

extension NavegadorViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshControl.endRefreshing()
        botonAtras.isEnabled = webView.canGoBack
        botonAdelante.isEnabled = webView.canGoForward
    }
}
