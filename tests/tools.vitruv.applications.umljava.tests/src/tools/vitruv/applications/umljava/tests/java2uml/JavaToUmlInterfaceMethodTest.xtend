package tools.vitruv.applications.umljava.tests.java2uml

import static tools.vitruv.applications.umljava.tests.util.UmlTestUtil.*
import org.junit.jupiter.api.Test
import org.eclipse.uml2.uml.VisibilityKind
import org.eclipse.emf.ecore.util.EcoreUtil

import static tools.vitruv.domains.java.util.JavaModificationUtil.*
import static extension tools.vitruv.applications.umljava.tests.util.UmlQueryUtil.*
import static extension tools.vitruv.applications.umljava.tests.util.JavaQueryUtil.*
import org.emftext.language.java.members.MembersFactory
import org.emftext.language.java.types.TypesFactory
import org.emftext.language.java.parameters.ParametersFactory
import static org.hamcrest.MatcherAssert.assertThat
import static org.hamcrest.CoreMatchers.*

/**
 * This class contains test cases for the creation, renaming and deleting of interface methods.
 * Plus, it checks the change of parameters and return types of interface methods.
 */
class JavaToUmlInterfaceMethodTest extends AbstractJavaToUmlTest {
	static val INTERFACE_NAME = "InterfaceName"
	static val TYPE_NAME = "TypeName"
	static val IOPERATION_NAME = "interfaceMethod"
	static val IOPERATION_RENAME = "interfaceMethodRenamed"
	static val PARAMETER_NAME = "parameterName"

	private def void createDefaultInterfaceWithMethod(String methodName) {
		createJavaInterfaceInRootPackage(INTERFACE_NAME)
		changeView(createJavaClassesView) [
			claimJavaInterface(INTERFACE_NAME) => [
				members += MembersFactory.eINSTANCE.createInterfaceMethod => [
					name = methodName
					typeReference = TypesFactory.eINSTANCE.createVoid
				]
			]
		]
	}
	
	private def assertInterfaceWithNameInRootPackage(String name) {
		assertClassifierWithNameInRootPackage(org.emftext.language.java.classifiers.Interface,
			org.eclipse.uml2.uml.Interface, name)
	}

	private def assertSingleInterfaceWithNameInRootPackage(String name) {
		assertSingleClassifierWithNameInRootPackage(org.emftext.language.java.classifiers.Interface,
			org.eclipse.uml2.uml.Interface, name)
	}

	@Test
	def void testCreateInterfaceMethod() {
		createDefaultInterfaceWithMethod(IOPERATION_NAME)
		assertSingleInterfaceWithNameInRootPackage(INTERFACE_NAME)
		createUmlView => [
			val umlInterface = defaultUmlModel.claimInterface(INTERFACE_NAME)
			val umlOperation = umlInterface.claimOperation(IOPERATION_NAME)
			assertUmlOperationTraits(umlOperation, IOPERATION_NAME, VisibilityKind.PUBLIC_LITERAL, null, false, true,
				umlInterface, null)
		]
	}

	@Test
	def void testRenameInterfaceMethod() {
		createDefaultInterfaceWithMethod(IOPERATION_NAME)
		changeView(createJavaClassesView) [
			claimJavaInterface(INTERFACE_NAME) => [
				claimInterfaceMethod(IOPERATION_NAME) => [
					name = IOPERATION_RENAME
				]
			]
		]
		assertSingleInterfaceWithNameInRootPackage(INTERFACE_NAME)
		createUmlView => [
			val umlInterface = defaultUmlModel.claimInterface(INTERFACE_NAME)
			val umlOperation = umlInterface.claimOperation(IOPERATION_RENAME)
			assertThat(umlOperation.name, is(IOPERATION_RENAME))
			assertUmlInterfaceDontHaveOperation(umlInterface, IOPERATION_NAME)
			assertUmlOperationTraits(umlOperation, IOPERATION_RENAME, VisibilityKind.PUBLIC_LITERAL, null, false, true,
				umlInterface, null)
		]

	}

	@Test
	def void testDeleteInterfaceMethod() {
		createDefaultInterfaceWithMethod(IOPERATION_NAME)
		changeView(createJavaClassesView) [
			claimJavaInterface(INTERFACE_NAME) => [
				EcoreUtil.delete(claimInterfaceMethod(IOPERATION_NAME))
			]
		]
		assertNoClassifierWithNameInRootPackage(INTERFACE_NAME)
		assertNoClassifierExistsInRootPackage()
		createUmlView => [
			val umlInterface = defaultUmlModel.claimInterface(INTERFACE_NAME)
			assertUmlInterfaceDontHaveOperation(umlInterface, IOPERATION_NAME)
		]
	}

	@Test
	def void testChangeInterfaceMethodReturnType() {
		createDefaultInterfaceWithMethod(IOPERATION_NAME)
		createJavaClassInRootPackage(TYPE_NAME)
		changeView(createJavaClassesView) [
			val typeClass = claimJavaClass(TYPE_NAME)
			claimJavaInterface(INTERFACE_NAME) => [
				claimInterfaceMethod(IOPERATION_NAME) => [
					typeReference = createNamespaceClassifierReference(typeClass)
				]
			]
		]
		assertInterfaceWithNameInRootPackage(INTERFACE_NAME)
		createUmlView => [
			val umlOperation = defaultUmlModel.claimInterface(INTERFACE_NAME).claimOperation(IOPERATION_NAME)
			val umlTypeClass = defaultUmlModel.claimClass(TYPE_NAME)
			assertUmlOperationHasReturntype(umlOperation, umlTypeClass)
		]
	}

	@Test
	def void testCreateInterfaceParameter() {
		createDefaultInterfaceWithMethod(IOPERATION_NAME)
		createJavaClassInRootPackage(TYPE_NAME)
		changeView(createJavaClassesView) [
			val typeClass = claimJavaClass(TYPE_NAME)
			claimJavaInterface(INTERFACE_NAME) => [
				claimInterfaceMethod(IOPERATION_NAME) => [
					parameters += ParametersFactory.eINSTANCE.createOrdinaryParameter => [
						name = PARAMETER_NAME
						typeReference = createNamespaceClassifierReference(typeClass)
					]
				]
			]
		]
		assertInterfaceWithNameInRootPackage(INTERFACE_NAME)
		createUmlView => [
			val umlOperation = defaultUmlModel.claimInterface(INTERFACE_NAME).claimOperation(IOPERATION_NAME)
			assertUmlOperationHasUniqueParameter(umlOperation, PARAMETER_NAME)
		]
	}
}
