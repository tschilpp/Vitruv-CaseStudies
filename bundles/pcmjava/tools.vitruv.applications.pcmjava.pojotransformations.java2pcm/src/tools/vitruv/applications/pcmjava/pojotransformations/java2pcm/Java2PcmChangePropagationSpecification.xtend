package tools.vitruv.applications.pcmjava.pojotransformations.java2pcm

import tools.vitruv.applications.pcmjava.util.java2pcm.Java2PcmPackagePreprocessor
import mir.reactions.JavaToPcmChangePropagationSpecification

class Java2PcmChangePropagationSpecification extends JavaToPcmChangePropagationSpecification {
	protected override setup() {
		//TODO zeile raus
		//addChangeMainprocessor(new Java2PcmChangeProcessor());
		super.setup();
		addChangePreprocessor(new Java2PcmPackagePreprocessor());
	}
}
