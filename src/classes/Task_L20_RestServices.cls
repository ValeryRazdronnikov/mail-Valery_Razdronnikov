/**
 * Created by User on 06.09.2018.
 */
@RestResource(urlMapping='/AccountContactHandler/*')
global with sharing class Task_L20_RestServices {
    @HttpGet
    global static String getContacts(){
        RestRequest request = RestContext.request;
        String dateString = '2018-6-1';
        if (request.params.containsKey('date')){
            dateString = request.params.get('date');
        }
        List<String> dateList = dateString.split('-');
        Date d = Date.newInstance(Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));
        System.debug(d);
        List<Account> accounts = [
                SELECT Id
                FROM Account
                WHERE CreatedDate >= :d
                AND CreatedDate < :d.addDays(1)
                ];
        List<Contact> contacts = [
                SELECT Id
                FROM Contact
                WHERE CreatedDate >= :d
                AND CreatedDate < :d.addDays(1)
        ];
        Map<String,List<Id>> serializeMap = new Map<String, List<Id>>();
        List<Id> listOfIds = new List<Id>();

        for (Contact c : contacts){
            listOfIds.add(c.Id);
        }
        serializeMap.put('contactIds', listOfIds);
        listOfIds = new List<Id>();
        for (Account a : accounts){
            listOfIds.add(a.Id);
        }
        serializeMap.put('accountIds', listOfIds);
        String result = JSON.serialize(serializeMap);
            System.debug(result);
        return result;
    }
}