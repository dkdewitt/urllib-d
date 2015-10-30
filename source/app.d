import std.stdio;
import std.uni;
import http.client;
import connection;
import url.parser;


void main()
{

    ConnectionTest();
}


void ConnectionTest(){
    HTTPConnection conn = new HTTPConnection("http://github.com", 80);
    conn.connect();
    conn.request("GET", "/");
    //writeln(conn.y);
    auto resp = conn.getResponse();
    writeln(resp.status);
    
    writeln(resp.headers);
}

void URLTest(){
    auto u = URL("https://www.google.com/index.html?x=5&y=6#test.html");
    writeln(u);
}

