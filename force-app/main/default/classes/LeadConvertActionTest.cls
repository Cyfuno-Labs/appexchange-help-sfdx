@IsTest
private class LeadConvertActionTest {
    
    @IsTest
    static void shouldConvertLead() {
        // arrange
        Lead lead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Acme',
            Status = 'Open - Not Contacted'
        );
        insert lead;

        Account account = new Account(Name = 'Acme');
        insert account;
        Contact contact = new Contact(LastName = 'Doe', AccountId = account.Id);
        insert contact;

        LeadConvertAction.ActionInput input = new LeadConvertAction.ActionInput();
        input.leadId = lead.Id;
        input.accountId = account.Id;
        input.contactId = contact.Id;
        input.doNotCreateOpportunity = true;
        
        // act
        Test.startTest();
        LeadConvertAction.convertLeads(new List<LeadConvertAction.ActionInput>{input});
        Test.stopTest();
        
        // assert
        lead = [SELECT Id, ConvertedContactId, IsConverted  FROM Lead WHERE Id = :lead.Id];
        Assert.isTrue(lead.IsConverted, 'Lead should be converted');
        Assert.areEqual(contact.Id, lead.ConvertedContactId, 'Lead should be converted to contact');
    }
}