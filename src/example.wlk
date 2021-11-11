//vikingo.subirseA(expedicion)
//expedicion.subirA(vikingo)

class Expedicion{
	const vikingosSubidos = []
	const aldeasInvolucradas=[]
	const capitalesInvolucradas=[]
	method objetivosInvolucrados() =capitalesInvolucradas+aldeasInvolucradas
	method valeLaPena() =	self.aldeasValenLaPena() && self.capitalesValenLaPena()
	method aldeasValenLaPena() = aldeasInvolucradas.all{aldea=>aldea.valeLaPena(vikingosSubidos.size())}
	method capitalesValenLaPena() = capitalesInvolucradas.all{capital=>capital.valeLaPena(vikingosSubidos.size())}
	method subirVikingo(vikingo){vikingosSubidos.add(vikingo)}
	method realizarse(){
		vikingosSubidos.forEach{vikingo=>vikingo.aumentarPatrimonio(self.botinParaCadaVikingo())}
	}
	method botinParaCadaVikingo()=self.botinConseguido()/vikingosSubidos.size()
	method botinConseguido() = self.objetivosInvolucrados().map{objetivo=>objetivo.botin(vikingosSubidos.size())}.sum()
}

class Vikingo{
	var property clase
	var cantidadDeArmas
	var patrimonio
	method subirseA(expedicion){
		self.validarProductividad()
		self.validarClase()
		expedicion.subirVikingo(self)
	}
	method validarProductividad(){
		if(not self.esProductivo()){
			self.error("No es lo suficientemente productivo")
		}
	}
	method tieneArmas() = cantidadDeArmas>0
	method esProductivo()
	method aumentarPatrimonio(cantidad){patrimonio+=cantidad}
	method escalarSocialmente(){
		clase.escalarSocialmente(self)
	}
	method validarClase() {
		clase.puedeSumarseAExpedicion(self)
	}
}

object jarl{
	method escalarSocialmente(vikingo){
		vikingo.clase(karl)
		vikingo.gananciasDeLosKarl()
	}
	method puedeSumarseAExpedicion(vikingo){ 
		if(not vikingo.tieneArmas()){
			self.error("Un esclavo con armas no puede subirse a una mision")
		}
	}
}
object karl{

	method escalarSocialmente(vikingo){
		vikingo.clase(thrall)
	}
	method puedeSumarseAExpedicion(vikingo)= not vikingo.tieneArmas()
}
object thrall{
	method escalarSocialmente(vikingo){vikingo.clase(self)}
}
	
class Soldado inherits Vikingo{
	var vidasQueSeCobro
	override method esProductivo() = vidasQueSeCobro>20 && self.tieneArmas() //falta que si es Jarl no tenga armas
	method sumarArmas(cantidad){cantidadDeArmas+=cantidad}
	method gananciaDeConvertirseEnKarl(){self.sumarArmas(10)}
}

class Granjero inherits Vikingo{
	var cantidadDeHijos
	var hectareas
	override method esProductivo()= self.hectareasPorHijo()>=2
	method hectareasPorHijo() = hectareas/cantidadDeHijos
	method tenerHijos(cantidad){cantidadDeHijos+=cantidad}
	method agrandarTerritorio(cantidad){hectareas+=cantidad}
	method gananciaDeConvertirseEnKarl(){
		self.tenerHijos(2)
		self.agrandarTerritorio(2)
	}
}
class Capital{
	const factorDeRiqueza
	method valeLaPena(qVikingos)= self.botin(qVikingos)/qVikingos >= 3
	method defensoresQueSeranDerrotados(qVikingos)=qVikingos*1
	method botin(qVikingos)=self.defensoresQueSeranDerrotados(qVikingos)*factorDeRiqueza
}
class Aldea{
	const cantidadDeCrucifijos
	method valeLaPena(qVikingos)=self.botin()>=15
	method botin()=cantidadDeCrucifijos
}
class AldeaAmurallada inherits Aldea{
	const vikingosMinimosNecesarios
	override method valeLaPena(qVikingos) = super(qVikingos) && qVikingos>vikingosMinimosNecesarios 
}
