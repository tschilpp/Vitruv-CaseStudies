package mir.routines.javaToUmlMethod;

import java.io.IOException;
import mir.routines.javaToUmlMethod.RoutinesFacade;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.uml2.uml.Operation;
import org.eclipse.uml2.uml.internal.impl.UMLFactoryImpl;
import org.emftext.language.java.members.ClassMethod;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class CreateUmlClassMethodRoutine extends AbstractRepairRoutineRealization {
  private RoutinesFacade actionsFacade;
  
  private CreateUmlClassMethodRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public EObject getElement1(final ClassMethod jMeth, final org.emftext.language.java.classifiers.Class jClass, final org.eclipse.uml2.uml.Class uClass, final Operation uOperation) {
      return uOperation;
    }
    
    public EObject getCorrepondenceSourceUClass(final ClassMethod jMeth, final org.emftext.language.java.classifiers.Class jClass) {
      return jClass;
    }
    
    public void update0Element(final ClassMethod jMeth, final org.emftext.language.java.classifiers.Class jClass, final org.eclipse.uml2.uml.Class uClass, final Operation uOperation) {
      EList<Operation> _ownedOperations = uClass.getOwnedOperations();
      _ownedOperations.add(uOperation);
    }
    
    public EObject getElement2(final ClassMethod jMeth, final org.emftext.language.java.classifiers.Class jClass, final org.eclipse.uml2.uml.Class uClass, final Operation uOperation) {
      return jMeth;
    }
    
    public EObject getElement3(final ClassMethod jMeth, final org.emftext.language.java.classifiers.Class jClass, final org.eclipse.uml2.uml.Class uClass, final Operation uOperation) {
      return uClass;
    }
    
    public void updateUOperationElement(final ClassMethod jMeth, final org.emftext.language.java.classifiers.Class jClass, final org.eclipse.uml2.uml.Class uClass, final Operation uOperation) {
      uOperation.setName(jMeth.getName());
    }
  }
  
  public CreateUmlClassMethodRoutine(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy, final ClassMethod jMeth, final org.emftext.language.java.classifiers.Class jClass) {
    super(reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.javaToUmlMethod.CreateUmlClassMethodRoutine.ActionUserExecution(getExecutionState(), this);
    this.actionsFacade = new mir.routines.javaToUmlMethod.RoutinesFacade(getExecutionState(), this);
    this.jMeth = jMeth;this.jClass = jClass;
  }
  
  private ClassMethod jMeth;
  
  private org.emftext.language.java.classifiers.Class jClass;
  
  protected void executeRoutine() throws IOException {
    getLogger().debug("Called routine CreateUmlClassMethodRoutine with input:");
    getLogger().debug("   ClassMethod: " + this.jMeth);
    getLogger().debug("   Class: " + this.jClass);
    
    org.eclipse.uml2.uml.Class uClass = getCorrespondingElement(
    	userExecution.getCorrepondenceSourceUClass(jMeth, jClass), // correspondence source supplier
    	org.eclipse.uml2.uml.Class.class,
    	(org.eclipse.uml2.uml.Class _element) -> true, // correspondence precondition checker
    	null);
    if (uClass == null) {
    	return;
    }
    registerObjectUnderModification(uClass);
    Operation uOperation = UMLFactoryImpl.eINSTANCE.createOperation();
    userExecution.updateUOperationElement(jMeth, jClass, uClass, uOperation);
    
    addCorrespondenceBetween(userExecution.getElement1(jMeth, jClass, uClass, uOperation), userExecution.getElement2(jMeth, jClass, uClass, uOperation), "");
    
    // val updatedElement userExecution.getElement3(jMeth, jClass, uClass, uOperation);
    userExecution.update0Element(jMeth, jClass, uClass, uOperation);
    
    postprocessElements();
  }
}
