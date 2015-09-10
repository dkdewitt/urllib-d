import std.stdio;
import std.uni;
import http.client;
void main()
{
	writeln("Edit source/app.d to start your project.");

        BaseHTTPConnection h1 = new BaseHTTPConnection("localhost", 2525);    
        h1.connect();
        //assert(h1.sock !is null);
string x = "GET / HTTP/1.1\r\nHost: localhost:8085\r\nConnection: keep-alive\r\nPragma: no-cache\r\nCache-Control: no-cache\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36\r\nAccept-Encoding: gzip, deflate, sdch\r\nAccept-Language: en-US,en;q=0.8";
        string y = "I rock";
        //h1.send("Test Data I know I ".dup);
        h1.send(cast(char[])x);
        h1.send("Test123".dup);
}
