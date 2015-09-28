import std.stdio;
import std.uni;
import http.client;
import connection;
void main()
{
	writeln("Edit source/app.d to start your project.");

        BaseHTTPConnection h1 = new BaseHTTPConnection("localhost", 2526);    
        h1.connect();
        //assert(h1.sock !is null);
string x = "GET / HTTP/1.1\r\nHost: localhost:8085\r\nConnection: keep-alive\r\nPragma: no-cache\r\nCache-Control: no-cache\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36\r\nAccept-Encoding: gzip, deflate, sdch\r\nAccept-Language: en-US,en;q=0.8";
        //h1.send("Test Data".dup);
        //h1.send(x);

        string method = "GET";
        string url = "localhost:8085";
        string headers = x;
        //sendRequest(string method, string url, string requestBody, string[string] headers )
        h1.request(method, url, "");
        auto resp = h1.getResponse();
}
