/**
 * @description This class is used to parse the description field of a Lead record
 * based on a JSON payload provided by https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/appexchange_lead_source_codes.htm
 */
public with sharing class LeadSourceDescriptionParsingAction {
    public class ActionInput {
        @InvocableVariable(required=true)
        public String description;
    }

    public class ActionResponse {
        @InvocableVariable
        public Boolean contactPreferenceSpecified = false;
        @InvocableVariable
        public Boolean utmParamsSpecified = false;


        @InvocableVariable
        public Boolean preventContactOtherProducts;
        @InvocableVariable
        public String listingUrl;
        @InvocableVariable
        public String referralCode;
        @InvocableVariable
        public String otherSource;

        @InvocableVariable
        public String utmCampaign;
        @InvocableVariable
        public String utmContent;
        @InvocableVariable
        public String utmMedium;
        @InvocableVariable
        public String utmSource;
        @InvocableVariable
        public String utmTerm;
    }

    @InvocableMethod(label='AppX Description Parsing')
    public static List<ActionResponse> execute(List<ActionInput> inputs) {
        List<ActionResponse> responses = new List<ActionResponse>();
        for (ActionInput input : inputs) {
            responses.add(parseDescription(input.description));
        }
        return responses;
    }

    private static ActionResponse parseDescription(String description) {
        ActionResponse response = new ActionResponse();
        if (description != null && description.contains('"lead_description"')) {
            LeadSourceDescription descJson = (LeadSourceDescription) JSON.deserialize(description, LeadSourceDescription.class);

            LeadSourceDescription.LSD_Description leadDescription = descJson.lead_description;
            if (leadDescription != null) {
                if(leadDescription.allow_contact_other_products != null) {
                    response.contactPreferenceSpecified = true;
                    response.preventContactOtherProducts = !leadDescription.allow_contact_other_products;
                }
                response.listingUrl = leadDescription.listing_url;
                response.referralCode = leadDescription.referral_code;
                response.otherSource = leadDescription.other_source;

                if (leadDescription.utm_parameters != null) {
                    response.utmParamsSpecified = true;
                    response.utmCampaign = leadDescription.utm_parameters.utm_campaign;
                    response.utmContent = leadDescription.utm_parameters.utm_content;
                    response.utmMedium = leadDescription.utm_parameters.utm_medium;
                    response.utmSource = leadDescription.utm_parameters.utm_source;
                    response.utmTerm = leadDescription.utm_parameters.utm_term;
                }
            }
        }
        return response;
    }
}