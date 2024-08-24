public with sharing class LeadConvertAction {
    public class ActionInput {
        @InvocableVariable(required=true)
        public String leadId;
        @InvocableVariable
        public String accountId;
        @InvocableVariable
        public String contactId;
        @InvocableVariable
        public Boolean doNotCreateOpportunity;
    }
    
    @InvocableMethod(label='Convert a Lead' description='Converts a Lead to an Account, Contact, and optionally an Opportunity.')
    public static void convertLeads(List<ActionInput> inputs) {
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

        for(ActionInput input : inputs) {
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            if(input.accountId != null) {
                leadConvert.setAccountId(input.accountId);
            }
            if(input.contactId != null) {
                leadConvert.setContactId(input.contactId);
            }
            if(input.doNotCreateOpportunity != null) {
                leadConvert.setDoNotCreateOpportunity(input.doNotCreateOpportunity);
            }

            leadConvert.setLeadId(input.leadId);
            leadConvert.setConvertedStatus(convertStatus.MasterLabel);
            leadConverts.add(leadConvert);
        }
        Database.LeadConvertResult[] results = Database.convertLead(leadConverts);
    }
}