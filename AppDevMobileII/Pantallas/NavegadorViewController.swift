import UIKit
import WebKit
import CoreData

class NavegadorViewController: UIViewController {

    // MARK: - Propiedades

    /// Cantidad de tareas que envia la pantalla anterior.
    var cantidadTareas: Int = 0

    private var webView: WKWebView!
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()

    private var botonAtras: UIBarButtonItem!
    private var botonAdelante: UIBarButtonItem!

    private let urlInicial = URL(string: "https://www.apple.com")!

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Navegador"
        configurarWebView()
        configurarBarra()
        cargar(url: urlInicial)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mostrarResumen()
    }

    // MARK: - Configuracion

    private func configurarWebView() {
        let configuracion = WKWebViewConfiguration()
        configuracion.defaultWebpagePreferences.allowsContentJavaScript = true

        webView = WKWebView(frame: .zero, configuration: configuracion)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        // WKWebView anclado al area segura en los cuatro lados.
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Recarga al jalar la pagina.
        refreshControl.addTarget(self, action: #selector(recargar), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
    }

    private func configurarBarra() {
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
    }

    // MARK: - Navegacion web

    private func cargar(url: URL) {
        guard url.scheme == "https" else {
            mostrarAlertaSoloHTTPS()
            return
        }
        webView.load(URLRequest(url: url))
    }

    private func normalizarURL(_ texto: String) -> URL? {
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !limpio.isEmpty else { return nil }

        if limpio.lowercased().hasPrefix("https://") {
            return URL(string: limpio)
        }
        return URL(string: "https://\(limpio)")
    }

    @objc private func irAtras() {
        if webView.canGoBack { webView.goBack() }
    }

    @objc private func irAdelante() {
        if webView.canGoForward { webView.goForward() }
    }

    @objc private func recargar() {
        webView.reload()
    }

    private func mostrarAlertaSoloHTTPS() {
        let alerta = UIAlertController(title: "Dirección no válida",
                                       message: "Solo se permiten direcciones https.",
                                       preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

    // MARK: - Resumen final

    private func mostrarResumen() {
        let usuario = UserDefaults.standard.string(forKey: Constantes.kUsuario) ?? "Sin usuario"

        // Se cuenta directo en Core Data para que el resumen siempre este al dia.
        let solicitud = NSFetchRequest<NSManagedObject>(entityName: "Tarea")
        let total = (try? Constantes.contexto.count(for: solicitud)) ?? cantidadTareas

        let mensaje = "Usuario: \(usuario)\nTareas registradas: \(total)"

        let alerta = UIAlertController(title: "Resumen",
                                       message: mensaje,
                                       preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension NavegadorViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let texto = searchBar.text,
              let url = normalizarURL(texto) else { return }
        cargar(url: url)
    }
}

// MARK: - WKNavigationDelegate

extension NavegadorViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshControl.endRefreshing()
        botonAtras.isEnabled = webView.canGoBack
        botonAdelante.isEnabled = webView.canGoForward
    }

    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        refreshControl.endRefreshing()
    }

    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        refreshControl.endRefreshing()
    }
}
