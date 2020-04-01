//
//  DetailVC.swift
//  GymAtHome
//
//  Created by PUIT RULL Josep on 27/03/2020.
//  Copyright © 2020 PUIT RULL Josep. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UIViewController {
    
    //var name: String? //? es opcional
    //var exerciceName: String? //? es opcional
    //var time: Int //? es opcional
    
    var ejercicios: SetEjercicios
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    
    var secondsTarget: Int = 0
    var step: Int = 0
    
    var ejer: Int = 0
    var desc: Int = 0
    var serie: Int = 0
    
    var stopwatchString: String = ""
    
    var startStopWatch: Bool = true
    var stopWatch: Bool = false
    var iniciado: Bool = false
    var finalizado: Bool = false
    
    @IBOutlet weak var lblSet: UILabel!
    @IBOutlet weak var lblEjercicio: UILabel!
    @IBOutlet weak var lblTiempo: UILabel!
    
    @IBOutlet var vista: UIView!
    
    //Todo esto es solo para que el puto programa se calle
    required init?(coder aDecoder: NSCoder) {
        let e: Ejercicio = Ejercicio(name: "", time: 0)
        let le: [Ejercicio] = [e]
        
        self.ejercicios = SetEjercicios(name: "", ejer: le, desc: 0, entreSeries: 0, ser: 0)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblSet.text = "\((ejercicios.name)!)"
        lblEjercicio.text = "\((ejercicios.tEjercicio[0].nombre!))"
        //lblTiempo.text = "\(String (ejercicios.calcularTiempo()))"
        lblTiempo.text = "00:00:00"
        //serie = ejercicios.series
        inicio()
        
    }
    
    @IBAction func StopButton(_ sender: Any) {
        //MIRAR SI esta inicializado, sino restar tiempo if iniciado
        if iniciado{
            if !stopWatch{
                timer.invalidate()
                stopWatch = true
            }else{
                timer = Timer.scheduledTimer(timeInterval: 0.01,
                target: self, selector:
                   #selector(fire),
                userInfo: nil,
                repeats: true)
                stopWatch = false
            }
        }else{
            /*if !stopWatch{
                timer.invalidate()
                stopWatch = true
            }else{
                timer = Timer.scheduledTimer(timeInterval: 0.01,
                target: self, selector:
                   #selector(fireInicio),
                userInfo: nil,
                repeats: true)
            }*/
            self.navigationController?.popViewController(animated: true)
        }
        if finalizado{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func StartStopWatch(){
        if startStopWatch == true{
            timer = Timer.scheduledTimer(timeInterval: 0.01,
                                         target: self, selector:
                                            #selector(fire),
                                         userInfo: nil,
                                         repeats: true)
            startStopWatch = false
        }else{
            timer.invalidate()
            startStopWatch = true
        }
        
    }
    @objc func fire(){
        updateStopWatch()
    }
    @objc func fireInicio(){
        inicioWatch()
    }
    
    func updateStopWatch(){
        
        fractions += 1
        if fractions == 100 {
            seconds += 1
            fractions = 0
        }
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        // Si fractions es mayor que 9 pondra su valor tal cual, si no pondra un cero delante

        let fractionString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
                
        
        stopwatchString = "\(minutesString):\(secondsString)"
        lblTiempo.text = stopwatchString
        
        if seconds == secondsTarget{
            if serie != self.ejercicios.series{
                if ejer != self.ejercicios.tEjercicio.count{
                    if ejer == desc{
                        ejer += 1
                        if desc != (self.ejercicios.tEjercicio.count - 1) {
                            vista.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                            prepararVariablesParaSiguienteEstado(
                                nombre: "Descanso",
                                duracion: self.ejercicios.tDescanso)
                        }
                    }else{
                        if desc != (self.ejercicios.tEjercicio.count - 1) { //BORRAR?
                            desc += 1
                            vista.backgroundColor = UIColor.systemGreen
                            prepararVariablesParaSiguienteEstado(
                                nombre: self.ejercicios.tEjercicio[ejer].nombre ?? "",
                                duracion: self.ejercicios.tEjercicio[ejer].duracion)
                        }
                    }
                }else{
                    serie += 1
                    vista.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    prepararVariablesParaSiguienteEstado(
                        nombre: "Descanso Largo",
                        duracion: self.ejercicios.tEntreSeries)
                    ejer = 0
                    desc = -1
                }
                
            }else{
                //DONE
                timer.invalidate()
                vista.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                lblEjercicio.text = "¡HAS ACABADO!"
                lblTiempo.text = "Bien hecho"
                finalizado = true
                startStopWatch = true
                //SaveData()
            }
        }
    }
    func inicioWatch(){
        
        fractions -= 1
        if fractions == -100 {
            seconds -= 1
            fractions = 0
        }
        if seconds == -60 {
            minutes -= 1
            seconds = 0
        }
        // Si fractions es mayor que 9 pondra su valor tal cual, si no pondra un cero delante

        let fractionString = fractions > -9 ? "\(-fractions)" : "0\(-fractions)"
        let secondsString = seconds > -9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > -9 ? "\(-minutes)" : "0\(-minutes)"
                
        
        //stopwatchString = "\(minutesString):\(secondsString):\(fractionString)"
        stopwatchString = "\(secondsString)"
        lblTiempo.text = stopwatchString
        
        switch seconds {
        case 3:
            lblEjercicio.text = "PREPARADOS"
        case 2:
            lblEjercicio.text = "LISTOS"
        case 1:
            lblEjercicio.text = "¡YA!"
        case 0:
             vista.backgroundColor = UIColor.systemGreen
            prepararVariablesParaSiguienteEstado(
                nombre: self.ejercicios.tEjercicio[0].nombre ?? "",
                duracion: self.ejercicios.tEjercicio[0].duracion)
            iniciado = true
        default:
            lblEjercicio.text = "¡YA!"
            iniciado = true
        }
    }
    
    func prepararVariablesParaSiguienteEstado(nombre: String, duracion: Int){
        lblEjercicio.text = nombre
        seconds = 0
        minutes = 0
        fractions = 0
        secondsTarget = duracion
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.01,
        target: self, selector:
           #selector(fire),
        userInfo: nil,
        repeats: true)
    }
    
    func inicio(){
        seconds = 3
        vista.backgroundColor = #colorLiteral(red: 0.8858566284, green: 0.1878562868, blue: 0.2624383271, alpha: 1)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
        target: self, selector:
           #selector(fireInicio),
        userInfo: nil,
        repeats: true)
    }
    func SaveData(){
    //@IBAction func SaveData(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        let date = Date()
        let formatter = DateFormatter()
        //Give the format you want to the formatter:

        formatter.dateFormat = "dd.MM.yyyy"
        
        
        //newEntity.setValue(date, forKey: "lastDay")
        newEntity.setValue(2, forKey: "lastDay")
        
        do{
            try context.save()
            print("saved")
        } catch{
            print("Failed saving")
        }
    }

}
