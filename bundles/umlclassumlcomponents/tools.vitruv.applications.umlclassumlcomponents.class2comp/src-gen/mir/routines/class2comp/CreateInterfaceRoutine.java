package mir.routines.class2comp;

import java.io.IOException;
import mir.routines.class2comp.RoutinesFacade;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.uml2.uml.Interface;
import org.eclipse.uml2.uml.PackageableElement;
import org.eclipse.uml2.uml.internal.impl.UMLFactoryImpl;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class CreateInterfaceRoutine extends AbstractRepairRoutineRealization {
  private RoutinesFacade actionsFacade;
  
  private CreateInterfaceRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public EObject getElement1(final Interface classInterface, final Interface compInterface) {
      org.eclipse.uml2.uml.Package _package = classInterface.getPackage();
      return _package;
    }
    
    public void update0Element(final Interface classInterface, final Interface compInterface) {
      EList<PackageableElement> _packagedElements = classInterface.getPackage().getPackagedElements();
      _packagedElements.add(compInterface);
    }
    
    public void updateCompInterfaceElement(final Interface classInterface, final Interface compInterface) {
      compInterface.setName(classInterface.getName());
    }
    
    public EObject getElement2(final Interface classInterface, final Interface compInterface) {
      return classInterface;
    }
    
    public EObject getElement3(final Interface classInterface, final Interface compInterface) {
      return compInterface;
    }
  }
  
  public CreateInterfaceRoutine(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy, final Interface classInterface) {
    super(reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.class2comp.CreateInterfaceRoutine.ActionUserExecution(getExecutionState(), this);
    this.actionsFacade = new mir.routines.class2comp.RoutinesFacade(getExecutionState(), this);
    this.classInterface = classInterface;
  }
  
  private Interface classInterface;
  
  protected void executeRoutine() throws IOException {
    getLogger().debug("Called routine CreateInterfaceRoutine with input:");
    getLogger().debug("   Interface: " + this.classInterface);
    
    Interface compInterface = UMLFactoryImpl.eINSTANCE.createInterface();
    userExecution.updateCompInterfaceElement(classInterface, compInterface);
    
    // val updatedElement userExecution.getElement1(classInterface, compInterface);
    userExecution.update0Element(classInterface, compInterface);
    
    addCorrespondenceBetween(userExecution.getElement2(classInterface, compInterface), userExecution.getElement3(classInterface, compInterface), "");
    
    postprocessElements();
  }
}
