package tool.vitruv.applications.pcmumlcomp.pcm2uml

import org.junit.Test
import static org.junit.Assert.*
import org.palladiosimulator.pcm.repository.RepositoryFactory
import org.palladiosimulator.pcm.repository.OperationInterface
import org.eclipse.uml2.uml.Interface
import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationSignature
import org.eclipse.uml2.uml.Operation
import tools.vitruv.aplications.pcmumlcomp.pcm2uml.PcmToUmlUtil
import org.eclipse.uml2.uml.Model
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.Parameter
import org.palladiosimulator.pcm.repository.ParameterModifier

class InterfacesTest extends AbstractPcmUmlTest {
	
	protected def OperationInterface createOperationInterface(String name) {
		val pcmInterface = RepositoryFactory.eINSTANCE.createOperationInterface()
		pcmInterface.entityName = name
		rootElement.interfaces__Repository += pcmInterface
		saveAndSynchronizeChanges(rootElement)
		return pcmInterface
	}
	
	protected def OperationSignature createOperationInterfaceOperation(OperationInterface pcmInterface, String operationName, DataType returnType) {
		val operationSignature = RepositoryFactory.eINSTANCE.createOperationSignature()
		operationSignature.entityName = operationName
		operationSignature.returnType__OperationSignature = returnType
		pcmInterface.signatures__OperationInterface += operationSignature
		saveAndSynchronizeChanges(pcmInterface)
		return operationSignature
	}
	
	protected def OperationSignature createOperationInterfaceOperation(OperationInterface pcmInterface, String operationName, PrimitiveTypeEnum returnType) {
		val primitiveType = RepositoryFactory.eINSTANCE.createPrimitiveDataType()
		primitiveType.type = returnType
		rootElement.dataTypes__Repository += primitiveType
		return createOperationInterfaceOperation(pcmInterface, operationName, primitiveType)
	}
	
	@Test
	public def void testInterfaceCreation() {
		val interfaceName = "i1"
		val pcmInterface = createOperationInterface(interfaceName)
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmInterface]).flatten
		assertEquals(1, correspondingElements.length)
		assertTrue(correspondingElements.get(0) instanceof Interface)
		val umlInterface = (correspondingElements.get(0) as Interface)
		assertEquals(interfaceName, umlInterface.name)
	}
	
	@Test
	public def void testInterfaceAddOperation() {
		val pcmInterface = createOperationInterface("i2")
		val returnType = RepositoryFactory.eINSTANCE.createPrimitiveDataType()
		returnType.type = PrimitiveTypeEnum.BOOL
		rootElement.dataTypes__Repository += returnType
		saveAndSynchronizeChanges(rootElement)
		val operationName = "o1"
		val pcmOperation = createOperationInterfaceOperation(pcmInterface, operationName, returnType)
		val correspondingInterface = correspondenceModel.getCorrespondingEObjects(#[pcmInterface]).flatten
		assertEquals(1, (correspondingInterface.get(0) as Interface).ownedOperations.length)
		val correspondingOperation = correspondenceModel.getCorrespondingEObjects(#[pcmOperation]).flatten
		assertEquals(1, correspondingOperation.length)
		val umlOperation = (correspondingOperation.get(0) as Operation)
		assertEquals(operationName, umlOperation.name)
		assertEquals(PcmToUmlUtil.getUmlPrimitiveType(returnType.type), umlOperation.type.name)
	}
	
	@Test
	public def void testInterfaceChangeOperation() {
		val pcmInterface = createOperationInterface("i3")
		val pcmOperation = createOperationInterfaceOperation(pcmInterface, "o1", PrimitiveTypeEnum.BOOL)
		val newReturnType = RepositoryFactory.eINSTANCE.createPrimitiveDataType()
		newReturnType.type = PrimitiveTypeEnum.CHAR
		rootElement.dataTypes__Repository += newReturnType
		pcmOperation.returnType__OperationSignature = newReturnType
		saveAndSynchronizeChanges(rootElement)
		var correspondingOperation = correspondenceModel.getCorrespondingEObjects(#[pcmOperation]).flatten
		var umlOperation = (correspondingOperation.get(0) as Operation)
		assertEquals(PcmToUmlUtil.getUmlPrimitiveType(newReturnType.type), umlOperation.type.name)
		
		val newOperationName = "o11"
		pcmOperation.entityName = newOperationName
		saveAndSynchronizeChanges(pcmOperation)
		assertEquals(newOperationName, umlOperation.name)
		
		pcmOperation.returnType__OperationSignature = null
		saveAndSynchronizeChanges(rootElement)
		correspondingOperation = correspondenceModel.getCorrespondingEObjects(#[pcmOperation]).flatten
		umlOperation = (correspondingOperation.get(0) as Operation)
		assertEquals(null, umlOperation.type)
	}
	
	@Test
	public def void testInterfaceRemoveOperation() {
		val pcmInterface = createOperationInterface("i4")
		val pcmOperation1 = createOperationInterfaceOperation(pcmInterface, "o1", PrimitiveTypeEnum.INT)
		val pcmOperation2 = createOperationInterfaceOperation(pcmInterface, "o2", PrimitiveTypeEnum.DOUBLE)
		val correspondingInterface = correspondenceModel.getCorrespondingEObjects(#[pcmInterface]).flatten
		val umlInterface = (correspondingInterface.get(0) as Interface)
		assertEquals(2, umlInterface.ownedOperations.length)
		pcmInterface.signatures__OperationInterface -= pcmOperation1
		saveAndSynchronizeChanges(pcmInterface)
		assertEquals(1, umlInterface.ownedOperations.length)
		assertEquals(pcmOperation2.entityName, umlInterface.ownedOperations.get(0).name)
	}
	
	@Test
	public def void testInterfaceRemove() {
		val pcmInterface = createOperationInterface("i5")
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmInterface]).flatten
		assertEquals(1, correspondingElements.length)
		val umlModel = (correspondenceModel.getCorrespondingEObjects(#[rootElement]).flatten.get(0) as Model)
		val elementCount = umlModel.packagedElements.length
		rootElement.interfaces__Repository -= pcmInterface
		saveAndSynchronizeChanges(rootElement)
		assertEquals(elementCount-1, umlModel.packagedElements.length)
	}
	
	protected def Parameter createOperationParameter(OperationSignature pcmSignature, String name, DataType type) {
		val pcmParameter = RepositoryFactory.eINSTANCE.createParameter()
		pcmParameter.entityName = name
		pcmParameter.dataType__Parameter = type
		pcmSignature.parameters__OperationSignature += pcmParameter
		saveAndSynchronizeChanges(pcmSignature)
		return pcmParameter
	}
	
	@Test
	public def void testParameterAdd() {
		val pcmInterface = createOperationInterface("i6")
		val pcmOperation = createOperationInterfaceOperation(pcmInterface, "o1", PrimitiveTypeEnum.BOOL)
		val parameterName = "p1"
		createOperationParameter(pcmOperation, parameterName, pcmOperation.returnType__OperationSignature)
		val parameterType = pcmOperation.returnType__OperationSignature
		
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmOperation]).flatten
		val umlOperation = (correspondingElements.get(0) as Operation)
		assertEquals(2, umlOperation.ownedParameters.length)
		// first parameter should be the return value
		val umlParameter = umlOperation.ownedParameters.get(1)
		
		println(umlParameter)
		assertEquals(parameterName, umlParameter.name)
		assertEquals(PcmToUmlUtil.getUmlPrimitiveType((parameterType as PrimitiveDataType).type),
			umlParameter.type.name)
	}
	
	@Test
	public def void testParameterChange() {
		val pcmInterface = createOperationInterface("i6")
		val pcmOperation = createOperationInterfaceOperation(pcmInterface, "o1", PrimitiveTypeEnum.BOOL)
		val pcmParameter = createOperationParameter(pcmOperation, "p1", pcmOperation.returnType__OperationSignature)
		
		var correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmParameter]).flatten
		var umlParameter = (correspondingElements.get(0) as org.eclipse.uml2.uml.Parameter)
		
		val newType = RepositoryFactory.eINSTANCE.createPrimitiveDataType()
		newType.type = PrimitiveTypeEnum.DOUBLE
		rootElement.dataTypes__Repository += newType
		pcmParameter.dataType__Parameter = newType
		saveAndSynchronizeChanges(pcmParameter)
		
		// TODO: why is the correspondence broken for umlParameter?
		// umlParameter access didn't result in an NPE
		correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmParameter]).flatten
		umlParameter = (correspondingElements.get(0) as org.eclipse.uml2.uml.Parameter)
				
		assertEquals(PcmToUmlUtil.getUmlPrimitiveType((newType as PrimitiveDataType).type),
			umlParameter.type.name)

		val newName = "p11"
		pcmParameter.entityName = newName
		saveAndSynchronizeChanges(pcmParameter)
		assertEquals(newName, umlParameter.name)
		
		pcmParameter.modifier__Parameter = ParameterModifier.OUT
		saveAndSynchronizeChanges(pcmParameter)
		
		correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmParameter]).flatten
		umlParameter = (correspondingElements.get(0) as org.eclipse.uml2.uml.Parameter)
		
		assertEquals(PcmToUmlUtil.getUmlParameterDirection(pcmParameter.modifier__Parameter), umlParameter.direction)
	}
	
	@Test
	public def void testParameterDelete() {
		val pcmInterface = createOperationInterface("i6")
		val pcmOperation = createOperationInterfaceOperation(pcmInterface, "o1", PrimitiveTypeEnum.BOOL)
		val pcmParameter1 = createOperationParameter(pcmOperation, "p1", pcmOperation.returnType__OperationSignature)
		val remainingParameterName = "p2"
		createOperationParameter(pcmOperation, remainingParameterName, pcmOperation.returnType__OperationSignature)
		
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmOperation]).flatten
		val umlOperation = (correspondingElements.get(0) as Operation)
		assertEquals(3, umlOperation.ownedParameters.length)
		
		val parameterCount = umlOperation.ownedParameters.length
		
		pcmOperation.parameters__OperationSignature -= pcmParameter1
		saveAndSynchronizeChanges(pcmOperation)
		
		assertEquals(parameterCount - 1, umlOperation.ownedParameters.length)
		
		assertEquals(remainingParameterName, umlOperation.ownedParameters.get(1).name)
	}
}