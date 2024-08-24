# AppExchange Helpful Things

This might grow into a collection of helpful things for Salesforce Partners who have an AppExchange Listing. These were assembled as we experienced frustrations with CMA and LMA while working with our [Microsoft Teams integration listing](https://appexchange.salesforce.com/appxListingDetail?listingId=ecc20b20-ed42-4a54-acde-eec4804518c5&utm_source=github&utm_medium=website&utm_content=appexchange-help).

Here's a list of what we have so far!

1. Auto-Opt Out Lead based on them not checking the box for allowing us to send them marketing messages.
1. Associate CampaignMembers bsaed on UTM params.
1. Convert Leads for Sandbox installs if matching Contact found.
1. Link Checkout Customer to Account

If you have suggestions we would love to incorporate them. Reach out at https://www.cyfunolabs.com

## Auto Opt Out Leads of Marketing Emails
When someone is providing their AppExchange profile information, there's an optional checkbox for "Allow the provider to contact me by email, phone, or SMS about other products or services". The value of this checkbox is passed onto the Lead within the JSON payload stamped into the Description field.

This feature is delivered with:
- A Lead before-save record triggered flow (`Lead_Opt_Out_from_AppExchange`)

To deploy:
- clone/download the repository and deploy from `manifest/optout-package.xml`

If you are looking to do more with the Description's JSON, consider using the `LeadSourceDescription` classes.

## Associate CampaignMembers based on UTM params
When the AppExchange creates a new Lead record, the description will contain some UTM parameters. Using these parameters, we can find the Campaign and add the Lead as a Member.

This feature is delivered with:
- A Lead after-save record triggered flow (`Lead_UTM_Param_Campaign_Selection`)
- A Flow Action (Apex Classes) for Parsing the Lead Source Description (`LeadSourceDescription*`)
- A Flow Action (Apex Classes) for matching the Campaign based on Parameters (`FindCampaignByUtm*`)

To deploy
- clone/download the repository and deploy from `manifest/utm-package.xml`

You might want to adjust the search order on how Campaigns are found based on UTM parameters matching.

If you already have UTM parameters as Custom Fields on the Campaign, you can adjust this solution to use those fields instead, though it will take a bit of adjusting this project.

### How matching works
Matching is done by first giving the 5 parameters an order of importance. So, from A-E.

A Lead will match a Campaign when ALL of the Campaign's defined values are matched with the most precise winning.  An example:

1. Campaign 1 has A,B,C defined
1. Campaign 2 has A,B,C,D defined
1. Campaign 3 has A,B,C,D,E defined

A Lead that has A,B,C,D values matching the above will:
- Initially match Campaign 1, as all Campaign 1 values have matched the Lead values
- Ultimately match Campaign 2, as all values match
- Does not match Campaign 3, as the Lead has not specified the E value.

## Auto Convert Leads
The License Management and Checkout Management Applications both end up creating duplicate Leads. With this, we auto convert and reduce the number of unnecessary records to manage.

This feature is delivered with:
- A Lead after-save record triggered flow (`Lead_Convert_if_possible`)
- A Flow Action (Apex CLasses) for converting the Lead.

To deploy
- clone/download the repository and deploy from `manifest/convert-package.xml`

You might want to adjust how the Contacts are matched (currently just by email address) and if you want an Opportunity to be created during the conversion or not. These are all options within the Flow Action.