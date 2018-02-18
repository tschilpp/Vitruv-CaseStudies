package mir.reactions.javaToUmlClassifier;

import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionsChangePropagationSpecification;

@SuppressWarnings("all")
public class JavaToUmlClassifierChangePropagationSpecification extends AbstractReactionsChangePropagationSpecification {
  public JavaToUmlClassifierChangePropagationSpecification() {
    super(new tools.vitruv.domains.java.JavaDomainProvider().getDomain(), 
    	new tools.vitruv.domains.uml.UmlDomainProvider().getDomain());
  }
  
  protected void setup() {
    this.addChangeMainprocessor(new mir.reactions.javaToUmlClassifier.ReactionsExecutor());
  }
}
