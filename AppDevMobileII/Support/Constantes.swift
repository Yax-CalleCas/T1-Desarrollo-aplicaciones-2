import UIKit
import CoreData

enum Constantes {

    static let kUsuario = "kUsuario"

    static let horizontal: CGFloat = 24
    static let vertical: CGFloat = 12

    static let celeste = UIColor(red: 0.20, green: 0.62, blue: 0.94, alpha: 1.0)

    static var contexto: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No se encontro el AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
}
