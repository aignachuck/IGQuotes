@IsTest(SeeAllData=true)
public with sharing class IGQuotePageTest {
    // @IsTest(SeeAllData=true)
    // public IGQuotePageTest1() {

    //     Create opp, Account, Order, Property, Price Book Entry, Product, Contact?

    //     Account testAccount = new Account();
    //     testAccount.Name = 'Test Acct 1';
    //     testAccount.Stage__c = 'Opportunity';
    //     testAccount.BillingAddress = ' 2 Test Street';

        
    // }

    @IsTest(SeeAllData=true)
    static void QuoteTest1(){

        Opportunity testOpp = new Opportunity();

        testOpp = [SELECT Id, Name, LeadSource, AccountId, Opportunity_Owner_Name__c, Conga_Term__c, 
        Conga_Quote_Expiration_Date__c, ARR__c, MRR__c, Total_Setup_Value__c FROM Opportunity 
        WHERE Name = 'Test Opp 2'];

        
        

        Test.startTest();

        Pagereference myPage = Page.IGQuotePage;
        Test.setCurrentPage(myPage);
        ApexPages.currentPage().getParameters().put('id',testOpp.id);
        IGQuoteCreator controller = new IGQuoteCreator();

        controller.getOpportunity();
        controller.getProps();
        controller.getProducts();
        controller.getAccount();
        controller.getOpptyList();

        Test.stopTest();

    }
}