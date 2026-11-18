import UIKit
import CoreData

class TareasViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celdaTarea")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var tareas: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tareas"
        configurarUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarTareas()
    }

    private func cargarTareas() {
        let contexto = Constantes.contexto
        let solicitud = NSFetchRequest<NSManagedObject>(entityName: "Tarea")
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]

        do {
            tareas = try contexto.fetch(solicitud)
            tableView.reloadData()
        } catch {
            print("Error al recuperar tareas: \(error)")
        }
    }

    private func configurarUI() {
        tableView.dataSource = self
        view.addSubview(tableView)

        let agregar = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(agregarTarea))
        let web = UIBarButtonItem(title: "Web",
                                  style: .plain,
                                  target: self,
                                  action: #selector(irAlNavegador))
        navigationItem.rightBarButtonItems = [agregar, web]

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func agregarTarea() {
        let alerta = UIAlertController(title: "Nueva tarea",
                                       message: "Escribe el nombre de la tarea",
                                       preferredStyle: .alert)
        alerta.addTextField { textField in
            textField.placeholder = "Nombre"
        }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            guard let self = self,
                  let nombre = alerta?.textFields?.first?.text?
                    .trimmingCharacters(in: .whitespacesAndNewlines),
                  !nombre.isEmpty else { return }

            let contexto = Constantes.contexto
            guard let entidad = NSEntityDescription.entity(forEntityName: "Tarea", in: contexto) else { return }
            let tarea = NSManagedObject(entity: entidad, insertInto: contexto)
            tarea.setValue(nombre, forKey: "nombre")

            do {
                try contexto.save()
                self.cargarTareas()
            } catch {
                print("Error al guardar la tarea: \(error)")
            }
        })

        present(alerta, animated: true)
    }

    @objc private func irAlNavegador() {
        navigationController?.pushViewController(NavegadorViewController(), animated: true)
    }
}

extension TareasViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tareas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaTarea", for: indexPath)
        celda.textLabel?.text = tareas[indexPath.row].value(forKey: "nombre") as? String
        return celda
    }
}
