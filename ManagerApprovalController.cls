public with sharing class ManagerApprovalController {
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getPendingOpportunities() {
        return [SELECT Id, Name, Amount, Discount__c, Final_Price__c, StageName 
                FROM Opportunity 
                WHERE StageName = 'Pending Approval'];
    }

    @AuraEnabled
    public static void approveOpportunity(String recordId) {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :recordId LIMIT 1];
        opp.StageName = 'Closed Won';
        update opp;
    }

    @AuraEnabled
    public static void rejectOpportunity(String recordId) {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :recordId LIMIT 1];
        opp.StageName = 'Negotiating';
        update opp;
    }
}
