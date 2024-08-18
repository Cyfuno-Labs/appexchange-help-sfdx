@IsTest
private class FindCampaignByUtmActionTest {

    private static Campaign buildCampaignWithValuesSet(Integer valueCount) {
        Campaign campaign = new Campaign(Name = 'Test Campaign');
        for(Integer i = 0; i < valueCount; i++) {
            campaign.put(FindCampaignByUtmAction.UTM_MATCH_OPTIONS[i], 'value' + i);
        }
        return campaign;
    }

    private static FindCampaignByUtmAction.ActionInput buildActionWithValuesSet(Integer valueCount) {
        FindCampaignByUtmAction.ActionInput input = new FindCampaignByUtmAction.ActionInput();
        input.utmMatchOrder = String.join(FindCampaignByUtmAction.UTM_MATCH_OPTIONS, ',');
        input.utmCampaign = 'value0';

        if(valueCount > 1) {
            input.utmContent = 'value1';
        }

        if(valueCount > 2) {
            input.utmMedium = 'value2';
        }

        if(valueCount > 3) {
            input.utmSource = 'value3';
        }

        if(valueCount > 4) {
            input.utmTerm = 'value4';
        }

        return input;
    }
    
    @IsTest
    static void shouldMatchCampaign2UtmsWith2Utms() {
        //arrange
        Campaign campaign = buildCampaignWithValuesSet(2);
        insert campaign;
        
        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(2);

        //act
        FindCampaignByUtmAction.ActionOutput result = FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input})[0];

        //assert
        Assert.areEqual(campaign.Id, result.campaignId, 'Campaign Id should match');
    }

    @IsTest
    static void shouldMatchCampaign3UtmsWith3Utms() {
        //arrange
        Campaign campaign = buildCampaignWithValuesSet(3);
        insert campaign;
        
        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(3);

        //act
        FindCampaignByUtmAction.ActionOutput result = FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input})[0];

        //assert
        Assert.areEqual(campaign.Id, result.campaignId, 'Campaign Id should match');
    }

    @IsTest
    static void shouldMatchCampaign4UtmsWith4Utms() {
        //arrange
        Campaign campaign = buildCampaignWithValuesSet(4);
        insert campaign;
        
        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(4);

        //act
        FindCampaignByUtmAction.ActionOutput result = FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input})[0];

        //assert
        Assert.areEqual(campaign.Id, result.campaignId, 'Campaign Id should match');
    }

    @IsTest
    static void shouldMatchCampaign5UtmsWith5Utms() {
        //arrange
        Campaign campaign = buildCampaignWithValuesSet(5);
        insert campaign;
        
        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(5);

        //act
        FindCampaignByUtmAction.ActionOutput result = FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input})[0];

        //assert
        Assert.areEqual(campaign.Id, result.campaignId, 'Campaign Id should match');
    }
    
    @IsTest
    static void shouldMatchCampaign2UtmsWith3Utms() {
        //arrange
        Campaign campaign = buildCampaignWithValuesSet(2);
        insert campaign;
        
        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(3);

        //act
        FindCampaignByUtmAction.ActionOutput result = FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input})[0];

        //assert
        Assert.areEqual(campaign.Id, result.campaignId, 'Campaign Id should match');
    }

    @IsTest
    static void shouldNotMatchCampaign3UtmsWith2Utms() {
        //arrange
        Campaign campaign = buildCampaignWithValuesSet(3);
        insert campaign;
        
        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(2);

        //act
        FindCampaignByUtmAction.ActionOutput result = FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input})[0];

        //assert
        Assert.isNull(result.campaignId, 'Campaign Id should not match');
    }

    @IsTest
    static void shouldFindBestMatch() {
        //arrange
        Campaign campaign2 = buildCampaignWithValuesSet(2);
        Campaign campaign3 = buildCampaignWithValuesSet(3);
        Campaign campaign4 = buildCampaignWithValuesSet(4);
        Campaign campaign5 = buildCampaignWithValuesSet(5);
        insert new List<Campaign>{campaign2, campaign3, campaign4, campaign5};

        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(4);

        //act
        FindCampaignByUtmAction.ActionOutput result = FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input})[0];

        //assert
        Assert.areEqual(campaign4.Id, result.campaignId, 'Campaign Id should match');
    }

    @IsTest
    static void shouldPreventMultipleInputs() {
        //arrange
        FindCampaignByUtmAction.ActionInput input1 = buildActionWithValuesSet(2);
        FindCampaignByUtmAction.ActionInput input2 = buildActionWithValuesSet(2);

        //act
        try {
            FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input1, input2});
            Assert.fail('Should have thrown an exception');
        } catch(Exception e) {
            //assert
            Assert.areEqual('Only one input record is allowed', e.getMessage(), 'Exception message should match');
        }
    }

    @IsTest
    static void shouldPreventInvalidMatchOrder() {
        //arrange
        FindCampaignByUtmAction.ActionInput input = buildActionWithValuesSet(2);
        input.utmMatchOrder = 'UTM_Campaign__c,UTM_Content__c';

        //act
        try {
            FindCampaignByUtmAction.findCampaignByUtms(new List<FindCampaignByUtmAction.ActionInput>{input});
            Assert.fail('Should have thrown an exception');
        } catch(Exception e) {
            //assert
            Assert.areEqual('All 5 UTM parameters are required to be ranked for matching', e.getMessage(), 'Exception message should match');
        }
    }
}