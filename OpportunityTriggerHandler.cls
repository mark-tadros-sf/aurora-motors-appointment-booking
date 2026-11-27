public class OpportunityTriggerHandler {
    
    public static void handleTrigger(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppsMap, Boolean isBefore, Boolean isInsert) {
        if (isBefore) {
            for (Opportunity opp : newOpps) {
                // 1. حساب السعر النهائي أوتوماتيك (سعر السيارة - الخصم)
                if (opp.Vehicle_Price__c != null) {
                    Decimal discountPercent = (opp.Discount__c != null) ? opp.Discount__c : 0;
                    // حساب قيمة الخصم بناءً على النسبة المئوية
                    Decimal discountAmount = opp.Vehicle_Price__c * discountPercent;
                    opp.Final_Price__c = opp.Vehicle_Price__c - discountAmount;
                    
                    // 2. لو الخصم زاد عن 10%، الـ Stage تتغير أوتوماتيك لـ Pending Approval
                    if (discountPercent > 0.10) {
                        opp.StageName = 'Pending Approval';
                    }
                }
            }
        }
    }
}
