module http.client;
import http.common;
import std.stdio;
import std.socket;
import std.conv;
import std.array;
import std.format;
import std.algorithm;
import std.uni;
import std.conv;
import std.array;
import std.concurrency;
import std.range;
import std.string;
import url.parser;

class BaseHTTPConnection {

protected:
    string _host;
    ushort _port;
    int timeout;
    Socket sock;
    string[string] _headers;
    string sourceAddress;

private:
    int debugLevel;
    ConnectionState defaultState = ConnectionState.CS_IDLE;
    ConnectionState state;
    ushort defaultPort = 80;
    string defaultHTTPVersion = HTTPVersion.HTTP_1_1;
    string[] _buffer;
    HTTPResponse _response;
    string method;
    URL url;


    void output(string s){
        _buffer ~= s;
    }


    //Send output and clear buffer
    void sendOutput(string messageBody = null){
        auto buffer = this._buffer;
        buffer ~= [""];
        auto message = buffer.join("\r\n");
        send(message);
        this._buffer = null;

        if(messageBody){
            message = ["", messageBody].join("\r\n");
            send(message);
        }
    }

    void sendRequest(string method, string url, string requestBody, string[string] headers ){

        string requestLine = format("%s %s %s", method, url, "HTTP/1.1");
        output(requestLine);
        string[string] skips;
        if("host" in headers){
            skips["host"] = "1";
        }
        putRequest(method, url, 0,  0);
        if(!("content-length" in headers))
            if(requestBody){}
                //headers["content-length"] = to!string(setContentLength(requestBody, method));


        foreach(hdr; headers.byPair){
            putHeader(hdr[0], hdr[1]);
        }

        //Needs Changed
        output("\r\n");
        endHeaders(requestBody);
    }

    int setContentLength(string requestBody, string method){
        ulong length = 0;
        if(find(METHODS_REQUIRING_BODY, method.toUpper())){
            if(requestBody is null)
                length = 0;
            length = requestBody.length;
        }
        return to!int(length);
    }

    void putHeader(string name, string value){
        if(state != ConnectionState.CS_REQ_STARTED)
            throw new CannotSendHeader("Request has not started");

        string header = name ~ ": " ~ value;
        output(header);

    }

    void endHeaders(string messageBody = null){
        if(state == ConnectionState.CS_REQ_STARTED)
            state = ConnectionState.CS_REQ_SENT;
        else
            throw new CannotSendHeader("Request has not started");

        sendOutput( messageBody);
    }



    void setHostPort(string host, string port = null){
        if(port is null){
            auto i = host.lastIndexOf(":");
            auto j = host.lastIndexOf("]");
        

        if(i>j){
            try{
                this._port = to!ushort(host[i+1..$]);
            } catch(ConvException exc){
                writefln("error message: %s", exc.msg);
                writefln("source file  : %s", exc.file);
                writefln("source line  : %s", exc.line);
                writeln();
            }

            this._host = host[0..i];
        }
        else
            this._port = defaultPort;
    }
        else{
            this._port = to!ushort(port);
            this._host = host;
        }
    }

    void send(string data){
        if(this.sock is null){
            //if (autoOpen)
                //connect();
            throw new NotConnected("Client is currently not connected2");
        }

        if(debugLevel > 0)
            writeln("Send: " ~ data);
        size_t chuckSize = 8192;
        
        writeln(data);
        foreach(chunk; chunks(data, chuckSize)){
            writeln(chunk);
            this.sock.send(to!(char[])(chunk));
        }
        //this.sock.send("\r\n");

    }


    /**
    *   Send request to server
    **/
    void putRequest(string method, string url, int skiphost=0, int skipAcceptEncoding=0){
        
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
        //sendOutput();
        //encode ascii??

        if(this.defaultHTTPVersion == HTTPVersion.HTTP_1_1){
            if(! skiphost){
                URL netUrl;
                if(url.startsWith("http")){
                    //get URL obj
                    netUrl = urlSplit(url, "http");
               }
               if(netUrl.host){
                    putHeader("Host", netUrl.host);
                }
               else{
                /*if tunnel hsot

                */
                auto host = this._host;
                auto port = this._port;

                auto hostLoc = host.lastIndexOf(":");
                if(hostLoc >= 0){
                    //ipv6ify host
                }

                if(port == defaultPort){
                    putHeader("Host", host);
                }
                else{
                    putHeader("Host",  host ~ ":" ~ to!string(port)  );
                }
               }
                
            }
        }
    }        



public:

    this(string host, ushort port, int timeout=0, string sourceAddress=null){
        this._host = host;
        this._port = port;
        this.timeout = timeout;
        this.url = URL(host);

        //switch to setHostPort
    }

    void connect(){
        sock = new Socket(AddressFamily.INET, SocketType.STREAM);


        // TODO change thid
        this.sock.setOption(SocketOptionLevel.SOCKET,
        SocketOption.RCVTIMEO, dur!"msecs"(100));

        Address addresses = new InternetAddress(this._host, this._port);
        writeln(addresses);
        this.sock.connect(addresses);
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


    void request(string method, string url, string requestBody=null, string[string] headers = null){
        this.sendRequest(method, url, requestBody, headers);
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


}


class HTTPResponse{

private:
    Socket socket;
    int debugLevel;
    string method;
    string url;
    char[] data;
    string[string] headers;

    void readStatus(){

    }

public:

    this(Socket sock, string method,int debugLevel=0){
        this.socket = sock;
        this.debugLevel = debugLevel;
        this.method = method;
        //this.socket.blocking = 1;

     
    }


    void begin(){
        
        if(this.headers)
            return;

        //Read until 
        //while(true){

        //}

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



        while(true){
            
            auto sx = this.socket.receive(buff);
            //writeln(sx);
            if(sx == 0)
                this.socket.close();
                //return;
            if(sx > 0){
                data ~= buff[0..sx];
                writeln(data);

                //return;
            }
            else{
                
                return;
            }
        }
    }
}



struct Data{
    char[8192] buff;
    long size;
    long i;

    this(long i, char[] buff){
        write(buff);
        size = i;
        buff = buff;
    }
    @property bool empty()
    {
        return i == size;
    }

    @property char front()
    {
        return buff[i];
    }

    void popFront()
    {
        ++i;
    }
}


