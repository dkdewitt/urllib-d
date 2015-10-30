import std.stdio;
import std.uni;
import http.client;
import connection;
import url.parser;


void main()
{
	//URLTest();
    //testConnection();
    //TestConn();
    //foreach(i; 0..100)
    ConnectionTest();
}


void ConnectionTest(){
    HTTPConnection conn = new HTTPConnection("http://www.google.com");
    conn.connect();
    conn.request("GET", "/");
    //writeln(conn.y);
    auto resp = conn.getResponse();
    writeln(resp.headers);
    
    //writeln(resp);
}

void URLTest(){
    auto u = URL("https://www.google.com/index.html?x=5&y=6#test.html");
    writeln(u);
}

void TestConn(){
    HTTPConnection c = new HTTPConnection("http://www.pylync.com");
    /*c.connect();
    string requestBody = "username=David";
    string[string] hdrs = ["Content-Type": "application/x-www-form-urlencoded"];
    c.request("POST", "/contact/", requestBody, hdrs);
    //c.request("GET", "/");
    auto t = c.getResponse();
    writeln(t.data);

    //writeln(t.status);
    */
}
