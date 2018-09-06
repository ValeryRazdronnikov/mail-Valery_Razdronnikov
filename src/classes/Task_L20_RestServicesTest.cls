/**
 * Created by User on 06.09.2018.
 */
@isTest
public class Task_L20_RestServicesTest {
    @isTest
    static void testGetAccountsAndContacts() {
        Account acc = new Account(Name = '1');
        insert acc;

        Contact c = new Contact(LastName = 'Vvv', AccountId = acc.Id);
        insert c;

        RestRequest request = new RestRequest();
        request.requestUri = 'https://volerey-dev-ed.lightning.force.com/services/apexrest/AccountContactHandler';
        request.httpMethod = 'GET';
        String s = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        request.params.put('date',s);
        RestContext.request = request;
        // Call the method to test
        Test.startTest();
        Map<String, List<Id>> result = Task_L20_RestServices.getAccountsAndContacts();
        Test.stopTest();

        //Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response);

        System.assert(result.containsKey('accountIds'));
        System.assert(result.containsKey('contactIds'));

        System.assertEquals(1, ((List<Object>)result.get('accountIds')).size());
        System.assertEquals(1, ((List<Object>)result.get('contactIds')).size());
    }

    @isTest static void testCreateAccountsAndContacts() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://volerey-dev-ed.lightning.force.com/services/apexrest/AccountContactHandler';
        request.httpMethod = 'POST';
        String s = '[{"name":"VRP","email":"cus@vrp.com","contacts":[{"LastName":"Sus","FirstName":"Art","Email":"hz@hz.com"}]}]';
        request.requestBody = Blob.valueOf(s);
        RestContext.request = request;
        Test.startTest();
        Map<String, List<Id>> response = Task_L20_RestServices.createAccountsAndContacts();
        Test.stopTest();
        //System.debug(response);
        List<Contact> contacts = [
                SELECT Id, LastName
                FROM Contact
        ];
        List<Account> accounts = [
                SELECT Id, Name
                FROM Account
        ];
        System.assertEquals(1, contacts.size());
        System.assertEquals(1, accounts.size());
        System.assertEquals('VRP', accounts[0].Name);
        System.assertEquals('Sus', contacts[0].LastName);
    }

}