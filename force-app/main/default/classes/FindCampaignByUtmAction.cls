public with sharing class FindCampaignByUtmAction {
    public static final List<String> UTM_MATCH_OPTIONS = new List<String>{'UTM_Campaign__c', 'UTM_Content__c', 'UTM_Medium__c', 'UTM_Source__c', 'UTM_Term__c'};
    
    public class ActionInput {
        @InvocableVariable
        public String utmMatchOrder;

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

        public Map<String, String> getMatchMap() {
            return new Map<String, String>{
                UTM_MATCH_OPTIONS[0] => utmCampaign,
                UTM_MATCH_OPTIONS[1] => utmContent,
                UTM_MATCH_OPTIONS[2] => utmMedium,
                UTM_MATCH_OPTIONS[3] => utmSource,
                UTM_MATCH_OPTIONS[4] => utmTerm
            };
        }
    }

    public class ActionOutput {
        @InvocableVariable
        public String campaignId;
    }

    @InvocableMethod(label='Find Campaign by UTM (not batch safe)')
    public static List<ActionOutput> findCampaignByUtms(List<ActionInput> inputs) {
        if(inputs.size() > 1) {
            throw new FindCampaignByUtmActionException('Only one input record is allowed');
        }
        ActionInput input = inputs[0];
        List<String> utmMatchOrder = input.utmMatchOrder.split(',');
        if(utmMatchOrder.size() != 5) {
            throw new FindCampaignByUtmActionException('All 5 UTM parameters are required to be ranked for matching');
        }
        Map<String, String> matchMap = input.getMatchMap();

        // query Campaign records based on the first 2 UTM parameters in the Match Order matching
        String param1 = matchMap.get(utmMatchOrder[0]);
        String param2 = matchMap.get(utmMatchOrder[1]);
        String query = 
            'SELECT Id, '+String.join(UTM_MATCH_OPTIONS,', ')+ ' ' + 
            'FROM Campaign '+
            'WHERE ' + utmMatchOrder[0] + ' = \''+ param1 + '\' ' + 
            'AND ' + utmMatchOrder[1] + ' = \''+ param2 + '\' ';
        System.debug(query);
        List<Campaign> campaigns = Database.query(query);
        System.debug('Found ' + campaigns.size() + ' campaigns');
        
        // loop through Campaigns trying to find a precise match, or find the best match
        Integer bestMatchCount = 2;
        Campaign bestMatchCampaign = null;

        System.debug('looking for the best match');
        for(Campaign c : campaigns) {
            // figure out how many matches this campaign needs
            Integer matchesNeeded = 2;
            if(String.isNotEmpty((String)c.get(utmMatchOrder[4]))) {
                matchesNeeded = 5;
            }
            else if(String.isNotEmpty((String)c.get(utmMatchOrder[3]))) {
                matchesNeeded = 4;
            }
            else if(String.isNotEmpty((String)c.get(utmMatchOrder[2]))) {
                matchesNeeded = 3;
            }
            Integer matchesAvailable = 2;
            if(String.isNotEmpty(matchMap.get(utmMatchOrder[2]))) {
                matchesAvailable++;
            }
            if(String.isNotEmpty(matchMap.get(utmMatchOrder[3]))) {
                matchesAvailable++;
            }
            if(String.isNotEmpty(matchMap.get(utmMatchOrder[4]))) {
                matchesAvailable++;
            }

            Integer matchCount = 2;
            Integer preciseMatchCount = 2;
            System.debug(c);

            if(String.isNotEmpty((String)c.get(utmMatchOrder[2])) && c.get(utmMatchOrder[2]) == matchMap.get(utmMatchOrder[2])) { 
                matchCount++; 
                preciseMatchCount++;
                System.debug('Matched 3rd UTM exactly, checking 4th next');
            }
            else if(String.isEmpty((String)c.get(utmMatchOrder[2])) && String.isNotEmpty(matchMap.get(utmMatchOrder[2]))) { 
                matchCount++;
                System.debug('Campaign 3rd UTM empty, loose match');
            }

            if(String.isNotEmpty((String)c.get(utmMatchOrder[3])) && c.get(utmMatchOrder[3]) == matchMap.get(utmMatchOrder[3]) && preciseMatchCount==3) { 
                matchCount++; 
                preciseMatchCount++; 
                System.debug('Matched 4th UTM exactly, checking 5th next');
            }
            else if(String.isEmpty((String)c.get(utmMatchOrder[3])) && String.isNotEmpty(matchMap.get(utmMatchOrder[3])) && preciseMatchCount==3) { 
                matchCount++; 
                System.debug('Campaign 4th UTM empty, loose match');
            }

            if(String.isNotEmpty((String)c.get(utmMatchOrder[4])) && c.get(utmMatchOrder[4]) == matchMap.get(utmMatchOrder[4]) && preciseMatchCount==4) { 
                matchCount++; 
                preciseMatchCount++; 
                System.debug('Matched 5th UTM exactly');
            }
            else if(String.isEmpty((String)c.get(utmMatchOrder[4])) && String.isNotEmpty(matchMap.get(utmMatchOrder[4])) && preciseMatchCount==4) { 
                matchCount++;
                System.debug('Campaign 5th UTM empty, loose match');
            }

            System.debug('Match count: ' + matchCount + ' Best match count: ' + bestMatchCount + ' Matches needed: ' + matchesNeeded);
            if(preciseMatchCount == matchesNeeded && matchesAvailable == matchesNeeded) {
                System.debug('found a precise match');
                bestMatchCampaign = c;
                break;
            }
            if(matchCount > bestMatchCount && matchCount >= matchesNeeded) {
                bestMatchCount = matchCount;
                bestMatchCampaign = c;
            }
        }
        
        ActionOutput output = new ActionOutput();
        if(bestMatchCampaign != null) {
            output.campaignId = bestMatchCampaign.Id;
        }
        return new List<ActionOutput>{output};
        
    }
}