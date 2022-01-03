package tools.vitruv.applications.umljava.tests.java2uml

import tools.vitruv.applications.umljava.tests.UmlJavaTransformationTest
import org.emftext.language.java.classifiers.ClassifiersFactory
import java.util.List
import tools.vitruv.framework.vsum.views.View
import static extension tools.vitruv.applications.umljava.tests.util.UmlQueryUtil.*
import static extension tools.vitruv.applications.umljava.tests.util.UmlQueryUtil.*
import static extension tools.vitruv.applications.umljava.tests.util.JavaQueryUtil.*
import static org.hamcrest.MatcherAssert.assertThat
import static org.hamcrest.CoreMatchers.*
import static tools.vitruv.applications.umljava.tests.util.TestUtil.assertElementsEqual
import org.junit.jupiter.api.BeforeEach

abstract class AbstractJavaToUmlTest extends UmlJavaTransformationTest {

	@BeforeEach
	def protected setup() {
		userInteraction.addNextTextInput(UML_MODEL_NAME)
		userInteraction.addNextTextInput(MODEL_FOLDER_NAME)
	}

	protected def containedDefaultUmlModel(View view) {
		view.containedUmlModel(UML_MODEL_NAME)
	}

	protected def void createJavaPackageInRootPackage(String name) {
		createJavaPackagesView => [
			createJavaPackage[
				it.name = name
			]
		]
	}

	protected def void createJavaEnumInRootPackage(String name) {
		createJavaEnumInPackage(#[], name)
	}

	protected def void createJavaEnumInPackage(List<String> namespace, String name) {
		createJavaClassesView => [
			createJavaCompilationUnit[
				it.name = name + ".java"
				it.namespaces += namespace
				classifiers += ClassifiersFactory.eINSTANCE.createEnumeration => [
					it.name = name
					makePublic
				]
			]
		]
	}

	protected def void createJavaClassInRootPackage(String name) {
		createJavaClassInPackage(#[], name)
	}

	protected def void createJavaClassInPackage(List<String> namespace, String name) {
		createJavaClassesView => [
			createJavaCompilationUnit[
				it.name = name + ".java"
				it.namespaces += namespace
				classifiers += ClassifiersFactory.eINSTANCE.createClass => [
					it.name = name
					makePublic
				]
			]
		]
	}

	protected def void createJavaInterfaceInRootPackage(String name) {
		createJavaInterfaceInPackage(#[], name)
	}

	protected def void createJavaInterfaceInPackage(List<String> namespace, String name) {
		createJavaClassesView => [
			createJavaCompilationUnit[
				it.name = name + ".java"
				it.namespaces += namespace
				classifiers += ClassifiersFactory.eINSTANCE.createInterface => [
					it.name = name
					makePublic
				]
			]
		]
	}

	protected def assertSingleClassifierWithNameInRootPackage(
		Class<? extends org.emftext.language.java.classifiers.Classifier> javaClassifierType,
		Class<? extends org.eclipse.uml2.uml.Classifier> umlClassifierType, String name,
		String javaCompilationUnitName) {
		createUmlAndJavaClassesView => [
			val javaClassifier = containedJavaClassifier(javaClassifierType, name)
			val javaCompilationUnit = containedJavaCompilationUnit(javaCompilationUnitName)
			val umlClassifier = containedDefaultUmlModel.containedPackageableElement(umlClassifierType, name)
			assertThat("only one element in UML model is expected to exist",
				containedDefaultUmlModel.packagedElements.toSet, is(#{umlClassifier}))
			assertThat("only one Java compilation unit is expected to exist", containedJavaCompilationUnits.toSet,
				is(#{javaCompilationUnit}))
			assertThat("only one Java classifier is expected to exist",
				containedJavaClassifiersOfType(javaClassifierType).toSet, is(#{javaClassifier}))
			assertElementsEqual(umlClassifier, javaClassifier)
		]
	}

	protected def assertSingleClassifierWithNameInPackage(
		Class<? extends org.emftext.language.java.classifiers.Classifier> javaClassifierType,
		Class<? extends org.eclipse.uml2.uml.Classifier> umlClassifierType, String packageName, String name) {
		createUmlAndJavaClassesView => [
			val javaClassifier = containedJavaClassifier(javaClassifierType, name)
			val javaCompilationUnit = containedJavaCompilationUnit(name)
			val umlPackage = containedDefaultUmlModel.containedPackage(packageName)
			val umlClassifier = umlPackage.containedPackageableElement(umlClassifierType, name)
			assertThat("only one element in UML model is expected to exist", umlPackage.packagedElements.toSet,
				is(#{umlClassifier}))
			assertThat("only one Java compilation unit is expected to exist", containedJavaCompilationUnits.toSet,
				is(#{javaCompilationUnit}))
			assertThat("only one Java classifier is expected to exist",
				containedJavaClassifiersOfType(javaClassifierType).toSet, is(#{javaClassifier}))
			assertElementsEqual(umlClassifier, javaClassifier)
		]
	}

	protected def assertNoClassifierExistsInRootPackage() {
		createUmlView => [
			assertThat("no element in UML model is expected to exist", containedDefaultUmlModel.packagedElements.toSet,
				is(emptySet))
			assertThat("no Java classifier is expected to exist", containedJavaClassifiers.toSet, is(emptySet))
			assertThat("no Java compilation unit is expected to exist", containedJavaCompilationUnits.toSet,
				is(emptySet))
		]
	}

}
