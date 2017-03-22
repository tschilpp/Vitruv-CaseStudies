package mir.routines.javaToUml;

import java.io.IOException;
import mir.routines.javaToUml.RoutinesFacade;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.uml2.uml.Model;
import org.eclipse.uml2.uml.Operation;
import org.eclipse.uml2.uml.Type;
import org.emftext.language.java.classifiers.ConcreteClassifier;
import org.emftext.language.java.members.Method;
import org.emftext.language.java.types.TypeReference;
import tools.vitruv.applications.umljava.java2uml.JavaToUmlHelper;
import tools.vitruv.applications.umljava.util.JavaUtil;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class ChangeUmlReturnTypeRoutine extends AbstractRepairRoutineRealization {
  private RoutinesFacade actionsFacade;
  
  private ChangeUmlReturnTypeRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public EObject getCorrepondenceSourceCustomType(final Method jMeth, final TypeReference jType, final Operation uMeth) {
      ConcreteClassifier _classifierfromTypeRef = JavaUtil.getClassifierfromTypeRef(jType);
      return _classifierfromTypeRef;
    }
    
    public EObject getElement1(final Method jMeth, final TypeReference jType, final Operation uMeth, final org.eclipse.uml2.uml.Class customType) {
      return uMeth;
    }
    
    public void update0Element(final Method jMeth, final TypeReference jType, final Operation uMeth, final org.eclipse.uml2.uml.Class customType) {
      Model _umlModel = JavaToUmlHelper.getUmlModel(this.correspondenceModel);
      Type _umlType = JavaToUmlHelper.getUmlType(jType, customType, _umlModel);
      uMeth.setType(_umlType);
    }
    
    public EObject getCorrepondenceSourceUMeth(final Method jMeth, final TypeReference jType) {
      return jMeth;
    }
  }
  
  public ChangeUmlReturnTypeRoutine(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy, final Method jMeth, final TypeReference jType) {
    super(reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.javaToUml.ChangeUmlReturnTypeRoutine.ActionUserExecution(getExecutionState(), this);
    this.actionsFacade = new mir.routines.javaToUml.RoutinesFacade(getExecutionState(), this);
    this.jMeth = jMeth;this.jType = jType;
  }
  
  private Method jMeth;
  
  private TypeReference jType;
  
  protected void executeRoutine() throws IOException {
    getLogger().debug("Called routine ChangeUmlReturnTypeRoutine with input:");
    getLogger().debug("   Method: " + this.jMeth);
    getLogger().debug("   TypeReference: " + this.jType);
    
    Operation uMeth = getCorrespondingElement(
    	userExecution.getCorrepondenceSourceUMeth(jMeth, jType), // correspondence source supplier
    	Operation.class,
    	(Operation _element) -> true, // correspondence precondition checker
    	null);
    if (uMeth == null) {
    	return;
    }
    initializeRetrieveElementState(uMeth);
    org.eclipse.uml2.uml.Class customType = getCorrespondingElement(
    	userExecution.getCorrepondenceSourceCustomType(jMeth, jType, uMeth), // correspondence source supplier
    	org.eclipse.uml2.uml.Class.class,
    	(org.eclipse.uml2.uml.Class _element) -> true, // correspondence precondition checker
    	null);
    initializeRetrieveElementState(customType);
    // val updatedElement userExecution.getElement1(jMeth, jType, uMeth, customType);
    userExecution.update0Element(jMeth, jType, uMeth, customType);
    
    postprocessElementStates();
  }
}
