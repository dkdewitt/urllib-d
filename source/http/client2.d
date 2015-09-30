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
    //HTTPResponse _response;
    string[] _buffer;
    HTTPResponse _response;
    void output(string s){
        _buffer ~= s;
    }

    void sendRequest(string method, string url, string requestBody, string[string] headers ){

        string requestLine = format("%s %s %s", method, url, "HTTP/1.1");
        output(requestLine);
        string[string] skips;
        if("host" in headers){
            skips["host"] = "1";
        }

        if(!("content-length" in headers))
             headers["content-length"] = to!string(setContentLength(requestBody, method));


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

        string header = name ~ " : " ~ value ~"\r\n";
        output(header);

    }

    void endHeaders(string messageBody = null){
        if(state == ConnectionState.CS_REQ_STARTED)
            state = ConnectionState.CS_REQ_SENT;
        else
            throw new CannotSendHeader("Request has not started");

        sendOutput( messageBody);
    }

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
            //raise not connected
        }

        if(debugLevel > 0)
            writeln("Send: " ~ data);
        size_t chuckSize = 8192;

        foreach(chunk; chunks(data, chuckSize)){
            this.sock.send(to!(char[])(chunk));
        }
    }


public:

    this(string host, ushort port, int timeout=0, string sourceAddress=null){
        this._host = host;
        this._port = port;
        this.timeout = timeout;
    }

    void connect(){
        sock = new Socket(AddressFamily.INET, SocketType.STREAM);
        Address addresses = new InternetAddress("localhost", 5000);
        sock.connect(addresses);
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
}


class HTTPResponse{


    void close(){
        
    }
}


