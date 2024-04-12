public class IGQuoteCreator {

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


        lineItems = [SELECT Name, UnitPrice, One_Time_Fee__c, ARR__c, Id, OpportunityId, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.Family  FROM OpportunityLineItem 
                    WHERE OpportunityId =: oppId];
        system.debug('lineItems = ' + lineItems);
   
        
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
   
    
}