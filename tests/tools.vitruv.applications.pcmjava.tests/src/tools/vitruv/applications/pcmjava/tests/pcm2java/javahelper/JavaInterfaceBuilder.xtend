package tools.vitruv.applications.pcmjava.tests.pcm2java.javahelper

import java.util.ArrayList
import java.util.List
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.imports.Import
import org.emftext.language.java.imports.ImportsFactory
import org.emftext.language.java.modifiers.ModifiersFactory

import static tools.vitruv.applications.pcmjava.tests.pcm2java.javahelper.JavaCreatorsUtil.*

import static extension edu.kit.ipd.sdq.commons.util.java.lang.IterableUtil.*

class JavaInterfaceBuilder {
	
	// === data ===
	final String interfaceName
	final String namespace
	final List<Import> interfaceImports
	
	new(String interfaceName, String namespace) {
		this.interfaceName = interfaceName
		this.namespace = namespace
		this.interfaceImports = new ArrayList<Import>()
	}
	
	// === builder-API ===
	
	def JavaInterfaceBuilder addImport(CompilationUnit importedCompilationUnit){
		var import = ImportsFactory.eINSTANCE.createClassifierImport
		import.namespaces += importedCompilationUnit.namespaces
		import.classifier = importedCompilationUnit.classifiers.claimOne
		
		this.interfaceImports += import
		return this
	}
	
	def CompilationUnit build() {
		val interface = createInterface [
			annotationsAndModifiers += ModifiersFactory.eINSTANCE.createPublic
			name = interfaceName
		]
		
		return createCompilationUnit[
			name = namespace + "." + interfaceName + ".java"
			namespaces += namespace.split("\\.")
			classifiers += interface
			imports += interfaceImports
		]
	}
}
