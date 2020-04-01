//
//  ViewController.swift
//  GymAtHome
//
//  Created by PUIT RULL Josep on 27/03/2020.
//  Copyright © 2020 PUIT RULL Josep. All rights reserved.
//

import UIKit
import CoreData
/*class AppleProducts{
    var productName: String?
    var productCategory: String?
    init(prName:String,prCategory:String){
        self.productName = prName
        self.productCategory = prCategory
    }
}*/
class Ejercicio{
    var nombre: String?
    var duracion: Int
    init(name:String, time:Int){
        self.nombre = name
        self.duracion = time
    }
}
class SetEjercicios{
    var name: String?
    var tEjercicio: [Ejercicio]
    var tDescanso: Int
    var tEntreSeries: Int
    var series: Int
    //var totalTime: Int
    
    init(name: String, ejer:[Ejercicio], desc:Int, entreSeries:Int, ser:Int){
        self.name = name
        self.tEjercicio = ejer
        self.tDescanso = desc
        self.tEntreSeries = entreSeries
        self.series = ser
    }
    func calcularTiempo() -> Int {
        
        var tiempoEjercicio = 0
        var total = 0
        
        for ejercicio in self.tEjercicio{
            tiempoEjercicio += ejercicio.duracion
            
        }
        
        total = ((tiempoEjercicio + self.tDescanso) * self.series) + (self.tEntreSeries * (self.series-1))

        return total
    }
}
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //@IBOutlet weak var tblAppleProducts: UITableview!
    var ejerciciosArray = [SetEjercicios]()
    
    @IBOutlet weak var tblFitProducts: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flexBrazos: Ejercicio = Ejercicio(name: "Flexiones de brazos", time: 30)
        let dippings: Ejercicio = Ejercicio(name: "Dippings", time: 30)
        let flexDiamante: Ejercicio = Ejercicio(name: "Flexiones diamante", time: 30)
        /*let flexBrazos: Ejercicio = Ejercicio(name: "Flexiones de brazos", time: 5)
        let dippings: Ejercicio = Ejercicio(name: "Dippings", time: 5)
        let flexDiamante: Ejercicio = Ejercicio(name: "Flexiones diamante", time: 5)*/
        
        let sentadilla: Ejercicio = Ejercicio(name: "Sentadilla", time: 60)
        let sentadillaIsometrica: Ejercicio = Ejercicio(name: "Sentadilla Isometrica", time: 60)
        let zancadas: Ejercicio = Ejercicio(name: "Zancadas", time: 60)
        
        
        let flexionClasica: Ejercicio = Ejercicio(name: "Flexión clasica", time: 45)
        let flexionEspartana: Ejercicio = Ejercicio(name: "Flexión espartana", time: 45)
        let flexionPalma: Ejercicio = Ejercicio(name: "Flexión con palma", time: 45)

        let benchDip: Ejercicio = Ejercicio(name: "BenchDip", time: 30)
        let tricepsBow: Ejercicio = Ejercicio(name: "Triceps Bow", time: 30)
        let powerTricepsExtension: Ejercicio = Ejercicio(name: "Power Triceps Extension", time: 30)
        
        var eBiceps: [Ejercicio] = [flexBrazos, dippings, flexDiamante]
        var eCuadriceps: [Ejercicio] = [sentadilla, sentadillaIsometrica, zancadas]
        var ePecho: [Ejercicio] = [flexionClasica, flexionEspartana, flexionPalma]
        var eTriceps: [Ejercicio] = [benchDip, tricepsBow, powerTricepsExtension]
        
        
        
        
        // Do any additional setup after loading the view.
        let biceps = SetEjercicios(name: "Biceps", ejer: eBiceps, desc: 10, entreSeries: 30, ser: 3)
        //let biceps = SetEjercicios(name: "Biceps", ejer: eBiceps, desc: 1, entreSeries: 1, ser: 1)

        let cuadricdeps = SetEjercicios(name: "Cuadriceps", ejer: eCuadriceps, desc: 15, entreSeries: 30, ser: 4)
        let pecho = SetEjercicios(name: "Pecho", ejer: ePecho, desc: 10, entreSeries: 30, ser: 4)
        let triceps = SetEjercicios(name: "Triceps", ejer: eTriceps, desc: 0, entreSeries: 20, ser: 3)
        
        
        ejerciciosArray.append(biceps)
        ejerciciosArray.append(triceps)
        ejerciciosArray.append(cuadricdeps)
        ejerciciosArray.append(pecho)
        
        tblFitProducts.dataSource = self
        tblFitProducts.delegate = self
    }
    
    //UITableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ejerciciosArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "productstable")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "productstable")
        }
        cell?.textLabel?.text = ejerciciosArray[indexPath.row].name
        cell?.detailTextLabel?.text = String(ejerciciosArray[indexPath.row].calcularTiempo()) + "s"
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt IndexPath: IndexPath){
        //tableView.deselectRow(at: IndexPath, animated: true)
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC {
            destination.ejercicios = ejerciciosArray[(tblFitProducts.indexPathForSelectedRow?.row)!]
        }
    }

}

