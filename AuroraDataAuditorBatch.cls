global class AuroraDataAuditorBatch implements Database.Batchable<sObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // بنستعلم عن الفرص وتاريخ الإغلاق
        String query = 'SELECT Id, StageName, CloseDate FROM Opportunity';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        for(Opportunity opp : scope) {
            // لو وقت تجربة القيادة عدى وماتحدثتش، ترجع لـ Negotiating
            if(opp.StageName == 'Scheduled for Test Drive' && opp.CloseDate < System.today()) {
                opp.StageName = 'Negotiating';
                oppsToUpdate.add(opp);
            }
        }
        
        if(!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) {
        // تنفيذ المهام عند الانتهاء
    }

    global void execute(SchedulableContext SC) {
        AuroraDataAuditorBatch batch = new AuroraDataAuditorBatch();
        Database.executeBatch(batch, 200);
    }
}
