import std.stdio;
import std.uni;
import http.client;
import connection;
import url.parser;
import std.net.curl;

void main()
{
	//URLTest();
    //testConnection();
    //TestConn();
    ConnectionTest();
}


void ConnectionTest(){
    HTTPConnection conn = new HTTPConnection("www.pylync.com", 80, 0);
    //writeln(conn.y);
}

void URLTest(){
    auto u = URL("https://www.google.com/index.html?x=5&y=6#test.html");
    writeln(u);
}

void TestConn(){
    HTTPConnection c = new HTTPConnection("www.pylync.com", 80);
    c.connect();
    string requestBody = "username=David";
    string[string] hdrs = ["Content-Type": "application/x-www-form-urlencoded"];
    //c.request("POST", "/login", requestBody, hdrs);
    c.request("GET", "/");
    auto t = c.getResponse();
    writeln(t.data);

    //writeln(t.status);
    //t.read();
}

void testConnection(){
            BaseHTTPConnection h1 = new BaseHTTPConnection("www.pylync.com", 80);    
        h1.connect();

string x = "GET / HTTP/1.1\r\nHost: localhost:8085\r\nConnection: keep-alive\r\nPragma: no-cache\r\nCache-Control: no-cache\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36\r\nAccept-Encoding: gzip, deflate, sdch\r\nAccept-Language: en-US,en;q=0.8";

        string method = "GET";
        string url = "/";
        string[string] headers;
//headers["Accept"] = "/*/*";
headers["Connection"] = "keep-alive";
//headers["Content-Type"] = "application/xml";
//headers["User-Agent"] =  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36";
        //sendRequest(string method, string url, string requestBody, string[string] headers )
        h1.request(method, url, null, headers);
        auto resp = h1.getResponse();
}