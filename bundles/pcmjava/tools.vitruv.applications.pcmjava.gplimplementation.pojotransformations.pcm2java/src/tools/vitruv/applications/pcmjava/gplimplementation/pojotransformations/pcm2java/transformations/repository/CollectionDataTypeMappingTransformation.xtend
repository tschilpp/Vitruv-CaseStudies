package tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.pcm2java.transformations.repository

import tools.vitruv.framework.userinteraction.UserInteractionType
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.util.transformationexecutor.EmptyEObjectMappingTransformation
import java.lang.reflect.Modifier
import java.util.ArrayList
import java.util.HashSet
import java.util.LinkedList
import java.util.List
import java.util.Set
import java.util.Stack
import java.util.Vector
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.emftext.language.java.classifiers.ConcreteClassifier
import org.emftext.language.java.containers.CompilationUnit
import org.emftext.language.java.generics.GenericsFactory
import org.emftext.language.java.generics.QualifiedTypeArgument
import org.emftext.language.java.types.NamespaceClassifierReference
import org.emftext.language.java.types.PrimitiveType
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.DataType

import static extension tools.vitruv.framework.correspondence.CorrespondenceModelUtil.*
import tools.vitruv.applications.pcmjava.util.pcm2java.DataTypeCorrespondenceHelper
import tools.vitruv.framework.util.command.ChangePropagationResult
import tools.vitruv.applications.pcmjava.util.pcm2java.Pcm2JavaUtils
import tools.vitruv.applications.pcmjava.util.java2pcm.Java2PcmUtils
import static extension edu.kit.ipd.sdq.commons.util.java.lang.IterableUtil.*

class CollectionDataTypeMappingTransformation extends EmptyEObjectMappingTransformation {

	override getClassOfMappedEObject() {
		return CollectionDataType
	}

	override setCorrespondenceForFeatures() {
		Pcm2JavaUtils.addEntityName2NameCorrespondence(featureCorrespondenceMap)
	}

	/** 
	 * Called when a new CollectionDataType is created
	 * Possible options for user:
	 * 	i) create Collection class in data types package
	 *  ii) just remember that it is a collection data type and map it internally to selected class
	 * In both cases: ask user whether it should be mapped to a which Collection class
	 * Currently implemented:
	 * 	CollectionDataType will always be mapped to its own class and the user is asked which kind of collection should be used
	 */
	override createEObject(EObject eObject) {
		val CollectionDataType cdt = eObject as CollectionDataType
		var String jaMoPPInnerDataTypeName = "?"
		if (null != cdt.innerType_CollectionDataType) {
			var jaMoPPInnerDataType = DataTypeCorrespondenceHelper.
				claimUniqueCorrespondingJaMoPPDataTypeReference(cdt.innerType_CollectionDataType, correspondenceModel)
			if(jaMoPPInnerDataType instanceof PrimitiveType){
				//get class object for inner type, e.g, for int get the class Integer
				jaMoPPInnerDataType = Pcm2JavaUtils.getWrapperTypeReferenceForPrimitiveType(jaMoPPInnerDataType)
			}
			if (null != jaMoPPInnerDataType && null != Java2PcmUtils.getTargetClassifierFromTypeReference(jaMoPPInnerDataType)) {
				jaMoPPInnerDataTypeName = Java2PcmUtils.getTargetClassifierFromTypeReference(jaMoPPInnerDataType).name
			}
		}

		//i) ask whether to create a new class
		//		val String selectClasOrNoClass = "Would you like to create a own class for the CollectionDataType named '" +
		//			cdt.entityName + "' in the data type package?"
		//		val int createOwnClassInt = userInteracting.selectFromMessage(UserInteractionType.MODAL,
		//			"Collection Data Type created. " + selectClasOrNoClass, #{"Yes", "No"})
		//		var boolean createOwnClass = false;
		//		if (0 == createOwnClassInt) {
		//			createOwnClass = true
		//		}


		//ii) ask data type
		//reflections does not work for java.util?
		//val reflection = new Reflections()
		//var Set<Class<? extends Collection>> collectionDataTypes = reflection.getSubTypesOf(Collection)
		var Set<Class<?>> collectionDataTypes = new HashSet
		collectionDataTypes.add(ArrayList)
		collectionDataTypes.add(LinkedList)
		collectionDataTypes.add(Vector)
		collectionDataTypes.add(Stack)
		collectionDataTypes.add(HashSet)
//		val createOwnClass = true;
//		if (createOwnClass) {
			collectionDataTypes = removeAbstractClasses(collectionDataTypes)
//		}
		val List<String> collectionDataTypeNames = new ArrayList<String>(collectionDataTypes.size)
		for (collectionDataType : collectionDataTypes) {
			collectionDataTypeNames.add(collectionDataType.name)
		}
		val String selectTypeMsg = "Please select type (or interface) that should be used for the type"
		val int selectedType = userInteracting.selectFromMessage(UserInteractionType.MODAL, selectTypeMsg,
			collectionDataTypeNames)
		val Class<?> selectedClass = collectionDataTypes.get(selectedType)
//		if (createOwnClass) {
			var datatypePackage = Pcm2JavaUtils.getDatatypePackage(correspondenceModel,
				cdt.repository__DataType, cdt.entityName, userInteracting)
			val String content = '''package «datatypePackage.namespacesAsString + datatypePackage.name»;

import «selectedClass.package.name».«selectedClass.simpleName»;

public class «cdt.entityName» extends «selectedClass.simpleName»<«jaMoPPInnerDataTypeName»>{

}
'''
			val cu = Pcm2JavaUtils.createCompilationUnit(cdt.entityName, content)
			val classifier = cu.classifiers.get(0)
			val superTypeRef = classifier.superTypeReferences.get(0)
			return #[cu, classifier, superTypeRef]
//		} else {
//
//			//TODO ML:
//			throw new UnsupportedOperationException(
//				"Not creating a class for collection data type is currently not supported")
//		}
	}

	def <T> Set<Class<?>> removeAbstractClasses(Set<Class<?>> collectionDataTypes) {
		val Set<Class<?>> nonAbstractCollections = new HashSet
		for (currentClass : collectionDataTypes) {
			if (!Modifier.isAbstract(currentClass.getModifiers())) {
				nonAbstractCollections.add(currentClass)
			}
		}
		return nonAbstractCollections
	}

	override updateSingleValuedEAttribute(EObject affectedEObject, EAttribute affectedAttribute, Object oldValue,
		Object newValue) {
		val transformationResult = new ChangePropagationResult
		val affectedEObjects = Pcm2JavaUtils.checkKeyAndCorrespondingObjects(affectedEObject, affectedAttribute,
			featureCorrespondenceMap, correspondenceModel)
		if (affectedEObjects.nullOrEmpty) {
			return transformationResult
		}
		val cus = affectedEObjects.filter(typeof(CompilationUnit))
		if (!cus.nullOrEmpty) {
			val CompilationUnit cu = cus.get(0)
			Pcm2JavaUtils.handleJavaRootNameChange(cu, affectedAttribute, newValue, correspondenceModel,
				false, transformationResult, affectedEObject)
		}
		transformationResult
	}

	override updateSingleValuedNonContainmentEReference(EObject affectedEObject, EReference affectedReference,
		EObject oldValue, EObject newValue) {
		val transformationResult = new ChangePropagationResult
		val innerType = DataTypeCorrespondenceHelper.
			claimUniqueCorrespondingJaMoPPDataType(newValue as DataType, correspondenceModel)
		if (null == innerType || !(innerType instanceof ConcreteClassifier)) {
			return transformationResult
		}
		val innerClassifier = innerType as ConcreteClassifier
		val concreteClass = correspondenceModel.
			getCorrespondingEObjectsByType(affectedEObject, org.emftext.language.java.classifiers.Class).claimOne
		if (!(concreteClass.extends instanceof NamespaceClassifierReference)) {
			return transformationResult
		}
		val extendsReference = concreteClass.extends as NamespaceClassifierReference
		val QualifiedTypeArgument qtr = GenericsFactory.eINSTANCE.createQualifiedTypeArgument
		qtr.typeReference = Pcm2JavaUtils.createNamespaceClassifierReference(innerClassifier)
		Pcm2JavaUtils.addImportToCompilationUnitOfClassifier(concreteClass, innerClassifier)
		extendsReference.classifierReferences.get(0).typeArguments.clear
		extendsReference.classifierReferences.get(0).typeArguments.add(qtr)
		transformationResult
	}

}
