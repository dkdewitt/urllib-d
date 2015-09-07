module http.client;
import std.socket;
import std.stdio;
import std.algorithm;
import std.uni;
import std.conv;
import std.array;
import std.concurrency;
import core.thread;
import std.string;
import std.range;
import http.common;




class BaseHTTPConnection{
protected:
    string sourceAddress;
    string _host;
    ushort port;
    int timeout;
    Socket sock;
private:
    ConnectionState defaultState = ConnectionState.CS_IDLE;
    ConnectionState state;
    ushort defaultPort = 80;
    string defaultHTTPVersion = HTTPVersion.HTTP_1_1;
    string[string] _headers;
    HTTPResponse _response;
    //char[] _response;

    int debugLevel;
    string method = "GET";
    
    
    string[] _buffer;
    
    void output(string s){
        _buffer ~= s;
    }

    /**
    *   Send _buffer and optional message
    **/
    void sendBuffer(string message=null){

    }



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
        string headerByte = header;
        //ubyte[] headerByte = cast(ubyte[]) header.dup;

        _buffer ~= headerByte;

    }   

    void _outputToBuffer(string s){
        _buffer ~= s;
    }

    void _sendOutput(){
        auto buffer = this._buffer;
        buffer ~= ["", ""];
        auto message = buffer.join("\r\n");
        this._buffer = null;
        send(message);

    }

    //void _

public:
    this(string host, ushort port, int timeout=0, string sourceAddress=null){
        _host = host;
        port = port;
        timeout = timeout;
    }

    void setHostPort(string host, string port=null){
        if(port is null){
            auto i = host.lastIndexOf(":");
            auto j = host.lastIndexOf("]");
            if(i > j){
                try{
                this.port  = to!ushort(host[i+1..$]);
                } catch(ConvException exc){
                    writefln("error message: %s", exc.msg);
                    writefln("source file  : %s", exc.file);
                    writefln("source line  : %s", exc.line);
                    writeln();
                }

                this._host = host[0..i];
            }
            else
                this.port = defaultPort;
        }
        else{
            this.port = to!ushort(port);
            this._host = host;
        }
    }


    //Get Host w/o port
    @property string host(){
        string _host = _headers.get("host","");
        auto colonSep = _host.lastIndexOf(":");
        if (colonSep)
            return _host[0..colonSep];
        else
            return _host;
    }

    void sendRequest(string method, string url, string requestBody, string[string] headers ){

    }

    void connect(){
        sock = new TcpSocket(AddressFamily.INET);
    }

    void close(){
        this.state = ConnectionState.CS_IDLE;
        try{
            Socket sock = this.sock;
            if(sock){
                
                this.sock = null;
                sock.close();
            }
        }
        finally{    
            HTTPResponse response = this._response;
            if(response){
                this._response = null;
                response.close();
            }

        }
    }

    void send(string data){
        if (this.sock is null){
            //raise not connected maybe auto open??
        }

        if(debugLevel>0)
            writeln("send: " ~ data);
        size_t blockSize = 8192;

        while(1){
            writeln(data);
            auto dataBlock = to!(char[])(drop(data, blockSize));
            char[] x = to!(char[])(dataBlock);
            //writeln();
            if(dataBlock == null)
                break;
            writeln(dataBlock);
            sock.send(cast(byte[]) dataBlock);
            data = data[blockSize..$];
            //break;

        }
        return;

    }


    /**
    *   Send request to server
    **/
    void putRequest(string method, string url, int skip_host=0, int skipAcceptEncoding=0){
        if (this.state == ConnectionState.CS_IDLE)
            this.state = ConnectionState.CS_REQ_STARTED;
        else
            throw new CannotSendRequestException("Test");
    
        this.method = method;
        if(url is null)
            url = "/";

        string request = format("%s %s %s", method, url , HTTPVersion.HTTP_1_1);
        
        //encode ascii??

        if(this.defaultHTTPVersion == HTTPVersion.HTTP_1_1){
            if(! skip_host){
                string netloc = "";
                if(url.startsWith("http")){
                    //get URL obj
                   // urlSplit(url, "http");
                }
            }
        }
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


class HTTPResponse{

private:
    Socket socket;
    int debugLevel;
    string method;
    string url;

public:

    this(Socket sock, string method, string url,int debugLevel=0){
        this.socket = sock;
        this.debugLevel = debugLevel;
        this.method = method;
        this.url = url;
    }


    void close(){}
}




























