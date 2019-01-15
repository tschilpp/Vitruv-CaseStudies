package mir.routines.umlRepositoryAndSystemPackageReactions;

import java.io.IOException;
import java.util.Optional;
import mir.routines.umlRepositoryAndSystemPackageReactions.RoutinesFacade;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.StringExtensions;
import org.palladiosimulator.pcm.repository.Repository;
import tools.vitruv.applications.pcmumlclass.TagLiterals;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class RenameCorrespondingRepositoryOrSystemRoutine extends AbstractRepairRoutineRealization {
  private RenameCorrespondingRepositoryOrSystemRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public EObject getCorrepondenceSourcePcmRepository(final org.eclipse.uml2.uml.Package umlPkg, final String newName) {
      return umlPkg;
    }
    
    public EObject getCorrepondenceSourcePcmSystem(final org.eclipse.uml2.uml.Package umlPkg, final String newName, final Optional<Repository> pcmRepository) {
      return umlPkg;
    }
    
    public String getRetrieveTag1(final org.eclipse.uml2.uml.Package umlPkg, final String newName) {
      return TagLiterals.REPOSITORY_TO_REPOSITORY_PACKAGE;
    }
    
    public String getRetrieveTag2(final org.eclipse.uml2.uml.Package umlPkg, final String newName, final Optional<Repository> pcmRepository) {
      return TagLiterals.SYSTEM__SYSTEM_PACKAGE;
    }
    
    public void callRoutine1(final org.eclipse.uml2.uml.Package umlPkg, final String newName, final Optional<Repository> pcmRepository, final Optional<org.palladiosimulator.pcm.system.System> pcmSystem, @Extension final RoutinesFacade _routinesFacade) {
      boolean _isPresent = pcmRepository.isPresent();
      if (_isPresent) {
        Repository _get = pcmRepository.get();
        String _firstUpper = null;
        if (newName!=null) {
          _firstUpper=StringExtensions.toFirstUpper(newName);
        }
        _get.setEntityName(_firstUpper);
      } else {
        boolean _isPresent_1 = pcmSystem.isPresent();
        if (_isPresent_1) {
          org.palladiosimulator.pcm.system.System _get_1 = pcmSystem.get();
          String _firstUpper_1 = null;
          if (newName!=null) {
            _firstUpper_1=StringExtensions.toFirstUpper(newName);
          }
          _get_1.setEntityName(_firstUpper_1);
        }
      }
    }
  }
  
  public RenameCorrespondingRepositoryOrSystemRoutine(final RoutinesFacade routinesFacade, final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy, final org.eclipse.uml2.uml.Package umlPkg, final String newName) {
    super(routinesFacade, reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.umlRepositoryAndSystemPackageReactions.RenameCorrespondingRepositoryOrSystemRoutine.ActionUserExecution(getExecutionState(), this);
    this.umlPkg = umlPkg;this.newName = newName;
  }
  
  private org.eclipse.uml2.uml.Package umlPkg;
  
  private String newName;
  
  protected boolean executeRoutine() throws IOException {
    getLogger().debug("Called routine RenameCorrespondingRepositoryOrSystemRoutine with input:");
    getLogger().debug("   umlPkg: " + this.umlPkg);
    getLogger().debug("   newName: " + this.newName);
    
    	Optional<org.palladiosimulator.pcm.repository.Repository> pcmRepository = Optional.ofNullable(getCorrespondingElement(
    		userExecution.getCorrepondenceSourcePcmRepository(umlPkg, newName), // correspondence source supplier
    		org.palladiosimulator.pcm.repository.Repository.class,
    		(org.palladiosimulator.pcm.repository.Repository _element) -> true, // correspondence precondition checker
    		userExecution.getRetrieveTag1(umlPkg, newName), 
    		false // asserted
    		)
    );
    registerObjectUnderModification(pcmRepository.isPresent() ? pcmRepository.get() : null);
    	Optional<org.palladiosimulator.pcm.system.System> pcmSystem = Optional.ofNullable(getCorrespondingElement(
    		userExecution.getCorrepondenceSourcePcmSystem(umlPkg, newName, pcmRepository), // correspondence source supplier
    		org.palladiosimulator.pcm.system.System.class,
    		(org.palladiosimulator.pcm.system.System _element) -> true, // correspondence precondition checker
    		userExecution.getRetrieveTag2(umlPkg, newName, pcmRepository), 
    		false // asserted
    		)
    );
    registerObjectUnderModification(pcmSystem.isPresent() ? pcmSystem.get() : null);
    userExecution.callRoutine1(umlPkg, newName, pcmRepository, pcmSystem, this.getRoutinesFacade());
    
    postprocessElements();
    
    return true;
  }
}