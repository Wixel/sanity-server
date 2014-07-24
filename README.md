Sanity Check Ping Server
=============

Highly available ping servers that are reachable via a simple URL requests.

#### Current installations:

1. [http://sanity-1.herokuapp.com](http://sanity-1.herokuapp.com)
2. [http://sanity-2.herokuapp.com](http://sanity-2.herokuapp.com)
3. [http://sanity-3.herokuapp.com](http://sanity-3.herokuapp.com)
4. [http://sanity-4.herokuapp.com](http://sanity-4.herokuapp.com)
5. [http://sanity-5.herokuapp.com](http://sanity-5.herokuapp.com)

#### Example:

*curl http://sanity-1.herokuapp.com/check/wixelhq.com*

Produces:

```json
{"status":200,"response":0.549021817,"host":"http://wixelhq.com"}
```

#### Multiple concurrent checks

*curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d 
'["google.com", "facebook.com"]' http://sanity-1.herokuapp.com/check*

Produces:

```json
[{"status":200,"response":0.716687,"host":"http://google.com"},{"status":200,"response":0.872883,"host":"http://facebook.com"}]
```
