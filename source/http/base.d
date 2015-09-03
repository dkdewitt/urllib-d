module http.base;
import std.socket;
import std.stdio;
import std.algorithm;
import std.uni;
import std.conv;
import std.array;
import std.concurrency;
import std.string;
import std.range;
import core.thread;
import util.connection;
import std.format;

import std.exception;

class CannotSendRequestException : Exception {
     this (string msg) {
         super(msg) ;
     }
 }

private immutable string[] METHODS_REQUIRING_BODY = ["PATCH", "PUT", "POST"];
enum HTTPVersion{
    HTTP_1_1 = "HTTP/1.1"
}


enum ConnectionState{
    CS_IDLE = "Idle",
    CS_REQ_STARTED = "Request-started",
    CS_REQ_SENT = "Request-sent"
}

void parseHeaders(){


}

class BaseHTTPConnection{
private:
    ConnectionState defaultState = ConnectionState.CS_IDLE;
    ConnectionState state;
    int defaultPort = 80;
    string defaultHTTPVersion = HTTPVersion.HTTP_1_1;
    string timeOut;
    string sourceAddress;
    Socket sock;
    char[] _buffer;
    char[] _response;
    string host;
    int port;
    int debugLevel;
    string method;

    void output(char s){
        _buffer ~= s;
    }

    /**
    *   Send _buffer and optional message
    **/
    void sendBuffer(string message=null){

    }


public:
    this(){}

    void setHostPort(string host, string port=null){
        if(port is null){
            auto i = host.lastIndexOf(":");
            auto j = host.lastIndexOf("]");
            if(i > j){
                try{
                this.port  = to!int(host[i+1..$]);
                } catch(ConvException exc){
                    writefln("error message: %s", exc.msg);
                    writefln("source file  : %s", exc.file);
                    writefln("source line  : %s", exc.line);
                    writeln();
                }

                this.host = host[0..i];
            }
            else
                this.port = defaultPort;
        }
        else{
            this.port = to!int(port);
            this.host = host;
        }
    }

    void connect(){
        this.sock = createConnection(this.host, "");
    }

    void send(string data){
        if (this.sock is null){
            //raise not connected maybe auto open??
        }

        if(debugLevel>0)
            writeln(data);
        size_t blockSize = 8192;

        while(1){
            auto dataBlock = to!(char[])(drop(data, blockSize));
            char[] x = to!(char[])(dataBlock);
            //writeln();
            if(dataBlock == null)
                break;
            writeln(dataBlock);
            sock.send(cast(byte[]) dataBlock);
            break;

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


    unittest{
        BaseHTTPConnection b1 = new BaseHTTPConnection();
        b1.setHostPort("www.google.com", "80");
        writeln(b1.host);
        assert(b1.host == "www.google.com");
    }
}



/*
void main() {
    BaseHTTPConnection x = new BaseHTTPConnection();
    //writeln("HELLO");
            urlString = "/";

        string request = format("%s %s %s", method, urlString , HTTPVersion.HTTP_1_1);
 */       
