public class Task_L19_WeatherRest {
    public static List<String> getWeather(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://api.openweathermap.org/data/2.5/forecast'
                + '?id=620127&APPID=bc67534c54ad35c33b9f25374ab7466c');
        request.setMethod('GET');

        HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.

        List<String> resultStrings = new List<String>();
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> days = (List<Object>) results.get('list');
            for (Integer i = 0; i < 40; i++){
                Map<String, Object> day = (Map<String, Object>) days[i];
                String temp = '' + day.get('dt_txt');
                Map<String, Object> main = (Map<String, Object>) day.get('main');
                Decimal temperature = (Decimal) main.get('temp') - 273.15;
                temp += ' - ' + temperature;
                List<Object> weather = (List<Object>) day.get('weather');
                Map<String, Object> weather0 = (Map<String, Object>) weather[0];
                temp += ' (' + weather0.get('main') + ')';
                resultStrings.add(temp);
                System.debug(temp);
            }
        }
        return resultStrings;
    }
}