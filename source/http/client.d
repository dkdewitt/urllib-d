module http.client;
import std.socket;
import std.stdio;
import std.algorithm;
import std.uni;
import std.conv;
import std.array;
import std.concurrency;
import core.thread;

private immutable string[] METHODS_REQUIRING_BODY = ["PATCH", "PUT", "POST"];
enum HTTPVersion{
    HTTP_1_1 = "HTTP/1/1"
}


void parseHeaders(){


}

//class BaseHTTPConnection{

//}


class BaseHTTPConnection{
private:
    string host;
    ushort port;
    int timeout;
    string sourceAddress;
    char[] _buffer;
    Socket sock;
    void _sendRequest(string method, string url, string requestBody, string[string] headers ){
        string[] headerKeys = headers.keys;

        string test="";
        if( !find(headerKeys, "content-length")){
            //set content length]
            string contentLength = to!string(_setContentLength(requestBody, method));
            headers["content-length"] = contentLength;
        }

        foreach(hdr; headers.byPair){

        }


    }

    int _setContentLength(string requestBody, string method){
        ulong length = 0;
        if(find( METHODS_REQUIRING_BODY,method.toUpper()) ){
            if(requestBody is null)
                length = 0;
            length = requestBody.length;

        }

        return to!int(length);
    }

    void _putHeader(string name, string value){
        string header;

        header = name ~ " : " ~ value ~"\r\n";
        char[] headerByte = header.dup;
        //ubyte[] headerByte = cast(ubyte[]) header.dup;

        _buffer ~= headerByte;

    }   

    //void _

public:
    this(string host, ushort port, int timeout=0, string sourceAddress=null){
        host = host;
        port = port;
        timeout = timeout;
    }

    void sendRequest(string method, string url, string requestBody, string[string] headers ){

    }

    void connect(){
        sock = new TcpSocket(AddressFamily.INET);
    }

    void send(char[] buff){
        char[] c  =  "GET / HTTP/1.1\r\nHost: localhost:9200\r\nConnection: keep-alive\r\nPragma: no-cache\r\nCache-Control: no-cache\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\r\nAccept-Encoding: gzip, deflate, sdch\r\nAccept-Language: en-US,en;q=0.8\r\n\r\n".dup;
        sock.send(c);

    }

    void receive(){

            sock.listen(10);
            char[1024] buffer;
            // the listener is ready to read
            // a new client wants to connect we accept it here
            auto newSocket = sock.accept();
            //char[1024] buffer;
            writeln(newSocket);
            auto received = newSocket.receive(buffer);
            writeln(buffer[0.. received]);
            //Response response = test(r1);            

            newSocket.close();
           

    }

    unittest{
        BaseHTTPConnection h1 = new BaseHTTPConnection("www.google.com", 80);    
        h1.connect();
        assert(h1.sock !is null);

        h1.send("Test Data".dup);
    }
}

