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

#### Check the global status

This is an unreliable method as the number will be reset when the server is restarted. It's meant to give you a general idea of the server usage.

*curl http://sanity-1.herokuapp.com/status*

```json
{
  "hits": 1,
  "since": "2014-07-30 13:10:46 +0200"
}
```