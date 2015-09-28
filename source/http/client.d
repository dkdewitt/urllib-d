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
import url.parser;



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

        putRequest(method, url, 0,  0);
        if( !find(headerKeys, "content-length")){
            //set content length]
            string contentLength = to!string(_setContentLength(requestBody, method));
            headers["content-length"] = contentLength;
        }

        foreach(hdr; headers.byPair){
            _putHeader(hdr[0], hdr[1]);
        }

        endHeaders(requestBody);


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
        if(state != ConnectionState.CS_REQ_STARTED)
            throw new CannotSendHeader("Request has not started");

        string header;

        header = name ~ " : " ~ value ~"\r\n";
        string headerByte = header;
        //ubyte[] headerByte = cast(ubyte[]) header.dup;

        _buffer ~= headerByte;

    }   

    void _outputToBuffer(string s){
        _buffer ~= s;
    }


    void endHeaders(string messageBody=null){
 
        if(state == ConnectionState.CS_REQ_STARTED)
            state = ConnectionState.CS_REQ_SENT;
        else
            throw new CannotSendHeader("Request has not started");

        _sendOutput(messageBody);
    }
    void _sendOutput(string messageBody = null){
        auto buffer = this._buffer;
        buffer ~= ["", ""];
        auto message = buffer.join("\r\n");
        this._buffer = null;
        send(message);
        if(messageBody)
            send(messageBody);

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
        _sendRequest(method,  url,  requestBody,  headers );
    }

    void connect(){
        //sock = new TcpSocket(AddressFamily.INET);
        sock = new Socket(AddressFamily.INET, SocketType.STREAM);
        Address addresses = new InternetAddress("localhost", 2526);
        sock.connect(addresses);
        //sock.setOption(SocketOptionLevel.TCP, SocketOption.TCP_NODELAY,1);
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

    void request(string method, string url, string requestBody, string[string] headers = null){
        this._sendRequest(method, url, requestBody, headers);
    }

    void send(string data){
        if (this.sock is null){
            //raise not connected maybe auto open??
        }

        if(debugLevel>0)
            writeln("send: " ~ data);
        size_t blockSize = 8192;

        while(1){
            auto dataBlock = to!(char[])(drop(data, blockSize));
            char[] x = to!(char[])(dataBlock);
         
            if(dataBlock == null)
                break;

            sock.send(cast(byte[]) dataBlock);
            data = data[blockSize..$];

        }
        return;
    }


    /**
    *   Send request to server
    **/
    void putRequest(string method, string url, int skip_host=0, int skipAcceptEncoding=0){
        
        if(this._response && this._response.isClosed())
            this._response = null;

        if (this.state == ConnectionState.CS_IDLE)
            this.state = ConnectionState.CS_REQ_STARTED;
        else
            throw new CannotSendRequestException("Test");
        this.method = method;
        if(url is null)
            url = "/";

        string request = format("%s %s %s", method, url , HTTPVersion.HTTP_1_1);
        _sendOutput();
        //encode ascii??

        if(this.defaultHTTPVersion == HTTPVersion.HTTP_1_1){
            if(! skip_host){
                URL netUrl;
                if(url.startsWith("http")){
                    //get URL obj
                    netUrl = urlSplit(url, "http");
               }
               if(netUrl.netloc){
                    _putHeader("Host", netUrl.netloc);
                }
               else{
                /*if tunnel hsot

                */

                auto host = this._host;
                auto port = this.port;

                auto hostLoc = host.lastIndexOf(":");
                if(hostLoc >= 0){
                    //ipv6ify host
                }

                if(port == defaultPort){
                    _putHeader("Host", host);
                }
                else{
                    _putHeader("Host",  host ~ ":" ~ to!string(port)  );
                    //self.putheader('Host', "%s:%s" % (host_enc, port)
                }

               

               }
                
            }
        }
    }        


    void receive(){

            this.sock.listen(10);
            char[1024] buffer;
            // the listener is ready to read
            // a new client wants to connect we accept it here
            auto newSocket = sock.accept();
            auto received = newSocket.receive(buffer);
            writeln(buffer[0.. received]);        
            newSocket.close();
           

    }

    HTTPResponse getResponse(){
        HTTPResponse response;

        if(this._response && this._response.isClosed)
            this._response = null;

  
        if(this.state != ConnectionState.CS_REQ_SENT || this._response)
            throw new ResponseNotReady("Response not ready");

        if(this.debugLevel>0)
            response = null;
        else{
            response = new HTTPResponse(this.sock, this.method,  this.debugLevel);
        }

        try{
            try{
                response.begin();

            } catch (Exception exc){
                close();
            }

            this.state = ConnectionState.CS_IDLE;

            if(response.willClose)
                close();
            else
                this._response = response;
            this._response.read();
            return response;
        }catch (Exception exc){
            throw new Exception(" ");
        }

    }

    unittest{
        BaseHTTPConnection h1 = new BaseHTTPConnection("localhost", 8085);    
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

    this(Socket sock, string method,int debugLevel=0){
        this.socket = sock;
        this.debugLevel = debugLevel;
        this.method = method;
     
    }


    void begin(){

    }
    void close(){}

    bool willClose(){
        return false;
    }
    bool isClosed(){
        return false;
    }

    void read(){
        char[8192] buff;
        writeln("Received", buff[0..this.socket.receive(buff)]);       
    }
}




























