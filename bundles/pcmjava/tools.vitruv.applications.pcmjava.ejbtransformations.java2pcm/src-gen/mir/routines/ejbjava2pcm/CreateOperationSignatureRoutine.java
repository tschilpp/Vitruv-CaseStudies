package mir.routines.ejbjava2pcm;

import java.io.IOException;
import java.util.function.Consumer;
import mir.routines.ejbjava2pcm.RoutinesFacade;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.Extension;
import org.emftext.language.java.members.InterfaceMethod;
import org.emftext.language.java.parameters.Parameter;
import org.palladiosimulator.pcm.repository.OperationInterface;
import org.palladiosimulator.pcm.repository.OperationSignature;
import org.palladiosimulator.pcm.repository.impl.RepositoryFactoryImpl;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class CreateOperationSignatureRoutine extends AbstractRepairRoutineRealization {
  private RoutinesFacade actionsFacade;
  
  private CreateOperationSignatureRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public EObject getElement1(final InterfaceMethod interfaceMethod, final OperationInterface opInterface, final OperationSignature opSignature) {
      return opSignature;
    }
    
    public EObject getElement2(final InterfaceMethod interfaceMethod, final OperationInterface opInterface, final OperationSignature opSignature) {
      return interfaceMethod;
    }
    
    public void callRoutine1(final InterfaceMethod interfaceMethod, final OperationInterface opInterface, final OperationSignature opSignature, @Extension final RoutinesFacade _routinesFacade) {
      opSignature.setEntityName(interfaceMethod.getName());
      opInterface.getSignatures__OperationInterface().add(opSignature);
      final Consumer<Parameter> _function = (Parameter it) -> {
        _routinesFacade.createPCMParameter(it, opSignature);
      };
      interfaceMethod.getParameters().forEach(_function);
      _routinesFacade.createPCMReturnType(interfaceMethod.getTypeReference(), opSignature, interfaceMethod);
    }
  }
  
  public CreateOperationSignatureRoutine(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy, final InterfaceMethod interfaceMethod, final OperationInterface opInterface) {
    super(reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.ejbjava2pcm.CreateOperationSignatureRoutine.ActionUserExecution(getExecutionState(), this);
    this.actionsFacade = new mir.routines.ejbjava2pcm.RoutinesFacade(getExecutionState(), this);
    this.interfaceMethod = interfaceMethod;this.opInterface = opInterface;
  }
  
  private InterfaceMethod interfaceMethod;
  
  private OperationInterface opInterface;
  
  protected void executeRoutine() throws IOException {
    getLogger().debug("Called routine CreateOperationSignatureRoutine with input:");
    getLogger().debug("   InterfaceMethod: " + this.interfaceMethod);
    getLogger().debug("   OperationInterface: " + this.opInterface);
    
    OperationSignature opSignature = RepositoryFactoryImpl.eINSTANCE.createOperationSignature();
    
    addCorrespondenceBetween(userExecution.getElement1(interfaceMethod, opInterface, opSignature), userExecution.getElement2(interfaceMethod, opInterface, opSignature), "");
    
    userExecution.callRoutine1(interfaceMethod, opInterface, opSignature, actionsFacade);
    
    postprocessElements();
  }
}
