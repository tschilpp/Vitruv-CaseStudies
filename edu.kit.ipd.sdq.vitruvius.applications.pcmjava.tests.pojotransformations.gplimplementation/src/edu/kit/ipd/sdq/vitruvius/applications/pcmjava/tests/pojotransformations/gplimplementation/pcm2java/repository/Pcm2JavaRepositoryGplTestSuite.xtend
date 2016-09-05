package edu.kit.ipd.sdq.vitruvius.applications.pcmjava.tests.pojotransformations.gplimplementation.pcm2java.repository

import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

@RunWith(Suite)
@SuiteClasses(#[BasicComponentMappingGplTransformationTests, CollectionDataTypeMappingGplTransformationTest,
	CompositeComponentMappingGplTransformationTest, CompositeDataTypeMappingGplTransformationTest,
	InnerDeclarationMappingGplTransformationTest, OperationInterfaceMappingGplTransformationTest,
	OperationProvidedRoleMappingGplTransformationTest, OperationRequiredRoleMappingGplTransformationTest,
	OperationSignatureMappingGplTransformationTest, PcmParameterMappingGplTransformationTest,
	RepositoryMappingGplTransformationTest, ResourceDemandingInternalBehaviorMappingGplTransformationTest,
	SeffMappingGplTransformationTest ])
class Pcm2JavaRepositoryGplTestSuite {
}
