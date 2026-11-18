import UIKit
import CoreData

// MARK: - Constantes del proyecto

enum Constantes {

    /// Clave usada en UserDefaults para recordar el usuario.
    static let kUsuario = "kUsuario"

    /// Separacion horizontal de todos los componentes visuales.
    static let horizontal: CGFloat = 24

    /// Distancia vertical entre componentes visuales.
    static let vertical: CGFloat = 12

    /// Color celeste usado en la pantalla de inicio.
    static let celeste = UIColor(red: 0.20, green: 0.62, blue: 0.94, alpha: 1.0)

    /// Usuario por defecto cuando aun no se ha guardado nada.
    static let usuarioVacio = ""

    // Nombres de controladores en el storyboard (opcional, usado si se
    // prefiere instanciarlos desde el storyboard).
    static let idInicio = "InicioViewController"
    static let idLogin = "LoginViewController"
    static let idTareas = "TareasViewController"
    static let idNavegador = "NavegadorViewController"
}

// MARK: - Acceso a Core Data

extension Constantes {

    static var contexto: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No se encontro el AppDelegate con el contenedor de Core Data")
        }
        return appDelegate.persistentContainer.viewContext
    }
}
