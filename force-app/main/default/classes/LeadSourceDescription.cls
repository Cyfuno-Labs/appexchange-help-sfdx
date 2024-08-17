@SuppressWarnings('PMD.FieldNamingConventions') // suppressed as SF named these things
public class LeadSourceDescription {
    public LSD_Description lead_description;

    public class LSD_Description {
        public Boolean allow_contact_other_products;
        public String listing_url;
        public LSD_UTM_Parameters utm_parameters;
        public String referral_code;
        public String other_source;
    }

    public class LSD_UTM_Parameters {
        public String utm_source;
        public String utm_medium;
        public String utm_campaign;
        public String utm_term;
        public String utm_content;
    }
}