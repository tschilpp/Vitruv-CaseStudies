package tool.vitruv.applications.pcmumlcomp.pcm2uml

import org.junit.Test
import static org.junit.Assert.*;
import org.eclipse.uml2.uml.Model
import org.palladiosimulator.pcm.repository.RepositoryFactory
import org.eclipse.uml2.uml.Component

class PcmToUmlTest extends AbstractPcmUmlTest {
	private static val COMPONENT_NAME = "TestComponent";

	@Test
	public def void testModelCreation() {
		assertModelExists("model/" + MODEL_NAME + ".uml");
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[rootElement]).flatten
		assertEquals(1, correspondingElements.size);
		val umlModel = correspondingElements.get(0);
		assertTrue(umlModel instanceof Model);
		assertEquals(MODEL_NAME, (umlModel as Model).name);
	}

	@Test
	public def void testCreateComponent() {
		val pcmComponent = RepositoryFactory.eINSTANCE.createBasicComponent();
		pcmComponent.entityName = COMPONENT_NAME;
		rootElement.components__Repository += pcmComponent;
		saveAndSynchronizeChanges(pcmComponent);
		val correspondingElements = correspondenceModel.getCorrespondingEObjects(#[pcmComponent]).flatten
		assertEquals(1, correspondingElements.size);
		val umlComponent = correspondingElements.get(0);
		assertTrue(umlComponent instanceof Component);
		assertEquals(COMPONENT_NAME, (umlComponent as Component).name);
	}
}