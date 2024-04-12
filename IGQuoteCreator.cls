public class IGQuoteCreator {

    //What do I need?

/*
First Page:
Term
Service Start Date
Quote Expiration Date = Today(+60)
Account Name

A table that shows: Property / Order No / One-Time Fees / Annual Fees
And then Totals

Payment Schedule??

Acceptance T's & C's

Second Page:
Signatures

Third Page:
Term
Payment Schedule
Service Start Date
Customer
Owner
Property Address
Order No

Table for Product List
Item
Quantity
Unit Price
One-Time Fees
Annual Fees

Then another paragraph of T's & C's regarding One-Time Setup Feeds, Payment Schedule, and Annual Recurring Fees
*/
    public Account acct {get;set;}
    public Property__c prop {get;set;}
    public OpportunityLineItem product {get;set;}
    public Order order {get;set;}
    public Id oppId {get;set;}
    private final Opportunity opp {get;set;}
    public List<Property__c> propsList {get;set;}
    public List<Order> ordersList {get;set;}
    public List<Id> propsIds {get;set;}
    public List<OpportunityLineItem> lineItems {get;set;}
    public Id acctId {get;set;}
    public List<Opportunity> oppPropList {get;set;}
    Map<Id, OpportunityLineItem> oliList {get;set;}
    public List<OrderItem> orderLineItems {get;set;}
    public List<Decimal> prices {get;set;}
    public List<Opportunity> oppList {get;set;}
    public Decimal totalContract {get;set;}

    //private ApexPages.StandardController stdCtrl {get; set;}
    
    public IGQuoteCreator() {
       opp = [SELECT Id, Name, LeadSource, AccountId, Opportunity_Owner_Name__c, Conga_Term__c, 
            Conga_Quote_Expiration_Date__c, ARR__c, MRR__c, Total_Setup_Value__c, Term__c FROM Opportunity 
            WHERE Id = :ApexPages.currentPage().getParameters().get('id')];

        //Id oppId = new Id;
        oppId = opp.Id;
        acctId = opp.AccountId;

        ordersList = [SELECT OrderNumber, Name, Property__c, AccountId FROM ORDER WHERE OpportunityId =: oppId];
        system.debug('OrdersList is: ' + ordersList);                 


        //propsList = [SELECT Name, Street_Address__c, City__c FROM Property__c WHERE Name =: ordersList];
    
        List <Id> propIds = new List<Id>();
        for ( Order o : ordersList) {
            propIds.add(o.Property__c);
        }
            
        system.debug('prodIds is: ' + propIds);
        propsList = [SELECT Name, Street_Address__c, City__c FROM Property__c WHERE Id =: propIds];
        system.debug('PropsList is: ' + propsList);

        List <Order> ordersProdList = new List<Order>();
        List <OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        ordersProdList = [SELECT OrderNumber, Name, Property__c, AccountId FROM ORDER WHERE OpportunityId =: oppId];
        system.debug('ordersProdList = ' + ordersProdList);

        //quantity, Product2Id, UnitPrice, Id from OrderItem
        // List <OrderItem> orderLineItems = new List<OrderItem>();
        // orderLineItems = [SELECT Id, Quantity, UnitPrice, Product2Id FROM OrderItem WHERE OrderId =: ordersProdList];
        // system.debug('orderLineItems = ' + orderLineItems);


        lineItems = [SELECT Name, UnitPrice, One_Time_Fee__c, ARR__c, Id, OpportunityId, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.Family  FROM OpportunityLineItem 
                    WHERE OpportunityId =: oppId];
        system.debug('lineItems = ' + lineItems);

        // List<Decimal> prices = new List<Decimal>();
        // for(OpportunityLineItem oli : lineItems){
        //     prices.add(oli.UnitPrice);

        // }

        // List <Opportunity> oppPropList = new List<Opportunity>();
        // oppPropList = [SELECT Id, Name, LeadSource, AccountId, (SELECT Name, UnitPrice, One_Time_Fee__c, ARR__c, Id, Product2Id, OpportunityId 
        //             FROM OpportunityLineItems WHERE OpportunityId =: oppId) 
        //             FROM Opportunity 
        //             WHERE Id =: oppId];


        // Map<Id, OpportunityLineItem> oliList = new Map<Id, OpportunityLineItem>([SELECT Name, UnitPrice, One_Time_Fee__c, ARR__c, Id, Product2Id, OpportunityId
        //                                                                         FROM OpportunityLineItem WHERE OpportunityId =: oppId]);

        // system.debug('oliList = ' + oliList);

        // oppPropList = [SELECT Name, UnitPrice, One_Time_Fee__c, ARR__c, Id, OpportunityId 
        // FROM OpportunityLineItem WHERE OpportunityId = '006Ek000005fFt3IAE'];    
        
        oppList=[SELECT ID, NAME, Account.Name,
             (SELECT Quantity, UnitPrice, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.Family, 
             OpportunityId, Order__r.OrderNumber, MRR__c, ARR__c, Order__r.Property__r.Name FROM OpportunityLineItems)
             FROM OPPORTUNITY WHERE ID=: oppId];
        system.debug('OpptyList is ' + oppList);



        // system.debug('oppPropList = ' + oppPropList);

        acct = [SELECT Name, Stage__c, Current_ARR__c, BillingAddress FROM Account WHERE Id =: acctId ];
        system.debug('acct = ' + acct);

        totalContract = ((opp.Term__c / 12) * opp.ARR__c );  
    }

    public Opportunity getOpportunity() {
        return opp;
    }

    // public List<Opportunity> getOppRelaProps(){
    //     return oppPropList;
    // }

    public List<Property__c> getProps(){
        return propsList;
    }

    public List<OpportunityLineItem> getProducts(){
        return lineItems;
    }

    public Account getAccount(){
        return acct;

    }

    public List<Opportunity> getOpptyList(){
        return oppList;
    }

    public Decimal getTotalContractValue(){
        return totalContract;
    }

    // public map<Id, OpportunityLineItem> getMapOli(){
    //     return oliList;
    // }

    // public List<OrderItem> getOrderLIs(){
    //     return orderLineItems;
    // }

    // public List<Decimal> getUnitPrices(){
    //     return prices;
    // }

    

    // public List<Property__c> getPropsList(){
    //     oppId  = ApexPages.currentPage().getParameters().get('id');
    //     List <Order> ordersList = new List<Order>();
    //     List <Property__c> propsList = new List<Property__c>();
    //     List <Id> propIds = new List<Id>();
    //     ordersList = [SELECT OrderNumber, Name, Property__c, AccountId FROM ORDER WHERE OpportunityId =: oppId];
    //     system.debug('OrdersList is: ' + ordersList);
    //     //propsList = [SELECT Name, Street_Address__c, City__c FROM Property__c WHERE Name =: ordersList];

    //     for ( Order o : ordersList) {
    //         propIds.add(o.Property__c);
    //     }
    //     system.debug('prodIds is: ' + propIds);
    //     propsList = [SELECT Name, Street_Address__c, City__c FROM Property__c WHERE Id =: propIds];
    //     system.debug('PropsList is: ' + propsList);

    //     //loop through ids to make a list of properties
    //     return propsList;

    // }

    // public List<OpportunityLineItem> getProducts(){
    //     oppId  = ApexPages.currentPage().getParameters().get('id');
    //     List <Order> ordersProdList = new List<Order>();
    //     List <OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    //     ordersProdList = [SELECT OrderNumber, Name, Property__c, AccountId FROM ORDER WHERE OpportunityId =: oppId];
    //     lineItems = [SELECT Name, Opportunity_Property_Name__c, UnitPrice, One_Time_Fee__c, ARR__c FROM OpportunityLineItem 
    //                 WHERE Order__r.Id =: ordersProdList];
    //     return lineItems;

    // }

   
    
}