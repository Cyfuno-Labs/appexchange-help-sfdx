@IsTest
private class LeadSourceDescriptionParsingActionTest {

    @IsTest
    static void shouldHandleBlankDescription() {
        //arrange
        LeadSourceDescriptionParsingAction.ActionInput input = new LeadSourceDescriptionParsingAction.ActionInput();

        //act
        List<LeadSourceDescriptionParsingAction.ActionInput> inputs = new List<LeadSourceDescriptionParsingAction.ActionInput>{input};
        List<LeadSourceDescriptionParsingAction.ActionResponse> responses = LeadSourceDescriptionParsingAction.execute(inputs);

        //assert
        Assert.areEqual(1, responses.size(), 'Should have one response');
        LeadSourceDescriptionParsingAction.ActionResponse response = responses[0];
        Assert.isFalse(response.contactPreferenceSpecified, 'Contact preference flag should not be set');
    }

    @IsTest
    static void shouldHandleSimpleDontMessageMe() {
        //arrange
        LeadSourceDescriptionParsingAction.ActionInput input = new LeadSourceDescriptionParsingAction.ActionInput();
        input.description = '{"lead_description":{"allow_contact_other_products":false}}';

        //act
        List<LeadSourceDescriptionParsingAction.ActionInput> inputs = new List<LeadSourceDescriptionParsingAction.ActionInput>{input};
        List<LeadSourceDescriptionParsingAction.ActionResponse> responses = LeadSourceDescriptionParsingAction.execute(inputs);

        //assert
        Assert.areEqual(1, responses.size(), 'Should have one response');
        LeadSourceDescriptionParsingAction.ActionResponse response = responses[0];
        Assert.isTrue(response.contactPreferenceSpecified, 'Contact preference flag should be set');
        Assert.isTrue(response.preventContactOtherProducts, 'Allow contact other products should be false');
    }

    @IsTest
    static void shouldHandleSimpleMessageMe() {
        //arrange
        LeadSourceDescriptionParsingAction.ActionInput input = new LeadSourceDescriptionParsingAction.ActionInput();
        input.description = '{"lead_description":{"allow_contact_other_products":true}}';

        //act
        List<LeadSourceDescriptionParsingAction.ActionInput> inputs = new List<LeadSourceDescriptionParsingAction.ActionInput>{input};
        List<LeadSourceDescriptionParsingAction.ActionResponse> responses = LeadSourceDescriptionParsingAction.execute(inputs);

        //assert
        Assert.areEqual(1, responses.size(), 'Should have one response');
        LeadSourceDescriptionParsingAction.ActionResponse response = responses[0];
        Assert.isTrue(response.contactPreferenceSpecified, 'Contact preference flag should be set');
        Assert.isFalse(response.preventContactOtherProducts, 'Allow contact other products should be false');
    }

    @IsTest
    static void shouldProvideUtmParams() {
        //arrange
        LeadSourceDescriptionParsingAction.ActionInput input = new LeadSourceDescriptionParsingAction.ActionInput();
        input.description = '{"lead_description":{"utm_parameters":{"utm_campaign":"campaign","utm_content":"content","utm_medium":"medium","utm_source":"source","utm_term":"term"}}}';

        //act
        List<LeadSourceDescriptionParsingAction.ActionInput> inputs = new List<LeadSourceDescriptionParsingAction.ActionInput>{input};
        List<LeadSourceDescriptionParsingAction.ActionResponse> responses = LeadSourceDescriptionParsingAction.execute(inputs);

        //assert
        Assert.areEqual(1, responses.size(), 'Should have one response');
        LeadSourceDescriptionParsingAction.ActionResponse response = responses[0];
        Assert.areEqual('campaign', response.utmCampaign, 'Campaign should be set');
        Assert.areEqual('content', response.utmContent, 'Content should be set');
        Assert.areEqual('medium', response.utmMedium, 'Medium should be set');
        Assert.areEqual('source', response.utmSource, 'Source should be set');
        Assert.areEqual('term', response.utmTerm, 'Term should be set');
    }

    @IsTest
    static void shouldHandleOtherDescription() {
        //arrange
        LeadSourceDescriptionParsingAction.ActionInput input = new LeadSourceDescriptionParsingAction.ActionInput();
        input.description = 'some other description went here';

        //act
        List<LeadSourceDescriptionParsingAction.ActionInput> inputs = new List<LeadSourceDescriptionParsingAction.ActionInput>{input};
        List<LeadSourceDescriptionParsingAction.ActionResponse> responses = LeadSourceDescriptionParsingAction.execute(inputs);

        //assert
        Assert.areEqual(1, responses.size(), 'Should have one response');
        LeadSourceDescriptionParsingAction.ActionResponse response = responses[0];
        Assert.isFalse(response.contactPreferenceSpecified, 'Contact preference flag should not be set');
    }
}