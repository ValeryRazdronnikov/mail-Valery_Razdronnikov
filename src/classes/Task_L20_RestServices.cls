/**
 * Created by User on 06.09.2018.
 */
@RestResource(urlMapping='/AccountContactHandler/*')
global with sharing class Task_L20_RestServices {
    @HttpGet
    global static Map<String,List<Id>> getAccountsAndContacts(){
        RestRequest request = RestContext.request;
        String dateString = '2018-6-1';
        if (request.params.containsKey('date')){
            dateString = request.params.get('date');
        }
        List<String> dateList = dateString.split('-');
        Date d = Date.newInstance(Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));
//        System.debug(d);
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

        //    System.debug(result);
        return serializeAccountsAndContacts(accounts, contacts);
    }

    @HttpPost
    global static Map<String, List<Id>> createAccountsAndContacts() {

        RestRequest request = RestContext.request;
//        String data = request.requestBody;
//        System.debug(data);

        List<Object> requestAccounts = (List<Object>) JSON.deserializeUntyped(request.requestBody.toString());
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<String> namesOfAccounts = new List<String>();
        List<String> namesOfContacts = new List<String>();
        for (Object o : requestAccounts){
            Map<String, Object> acc = (Map<String, Object>) o;
            Account account;
            if (acc.containsKey('name')){
                account = new Account(Name = (String) acc.get('name'));
            }
            else {
                continue;
            }/*
            if (acc.containsKey('email')){
                account. = acc.get('email');
            }*/
            if (acc.containsKey('contacts')){
                List<Object> requestContacts = (List<Object>) acc.get('contacts');
                for (Object c : requestContacts){
                    Map<String, Object> con = (Map<String, Object>) c;
                    Contact contact;
                    if (con.containsKey('LastName')){
                        contact = new Contact(LastName = (String) con.get('LastName'));
                    }
                    else {
                        continue;
                    }
                    if (con.containsKey('Email')){
                        contact.Email = (String) acc.get('email');
                    }
                    if (acc.containsKey('FirstName')){
                        contact.FirstName = (String) acc.get('FirstName');
                    }
                    //contact.AccountId = account.Id;
                    contacts.add(contact);
                    namesOfContacts.add(contact.LastName);
                }
            }
            accounts.add(account);
            namesOfAccounts.add(account.Name);
        }
        System.debug(accounts);
        System.debug(contacts);

        try {
            insert accounts;
            insert contacts;
        }
        catch (Exception e){
            System.debug('Error');
        }
        contacts = [
                SELECT Id
                FROM Contact
                WHERE LastName IN :namesOfContacts
        ];
        accounts = [
                SELECT Id
                FROM Account
                WHERE Name IN :namesOfAccounts
        ];
        return serializeAccountsAndContacts(accounts, contacts);
        //return null;

    }

    private static Map<String,List<Id>> serializeAccountsAndContacts(List<Account> accounts, List<Contact> contacts){
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
        return serializeMap;
    }
}