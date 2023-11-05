# nslookup positrace.com returns 35.203.23.79
curl -X POST http://localhost:3000/geo_locations/ -d "lookup_value=35.203.23.79"
curl http://localhost:3000/geo_locations/35%2E203%2E23%2E79

