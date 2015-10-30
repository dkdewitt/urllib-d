module connection;


import std.socket;
import util.connection;
import http.client;
import http.common;
import std.stdio;   
import url.parser;

alias baseRequest = BaseHTTPConnection.request;
class HTTPConnection : BaseHTTPConnection{

private:
    //default_socket_options = [(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)]
    
    ushort defaulPort = 80;
    
    string socketOptions;

    /**
    *   Establish new connection
    **/
    Socket newConnection(){
        Socket connection;
        string[string] extraKeywords;

        if(super.sourceAddress)
            extraKeywords["sourceAddress"] = super.sourceAddress;

        if(this.socketOptions)
            extraKeywords["socketOptions"] = this.socketOptions;

        try{
            connection = createConnection(super._host, super.timeout, super.sourceAddress);

        } catch(Exception exc){
            writeln("Exception");
        }

        return connection;
    }

    void prepareConnection(Socket conn){
        super.sock = conn;
        //Add tunnel crap
    }



public:
    //Headers headers;
    
    this(string host, ushort port=0, int timeout=0, string sourceAddress=null, string[string] headers = null){
        if(!port){
            port = defaulPort;
        }
        auto url = URL(host);
        super(url.host, port, timeout, sourceAddress);
        //connect();
           
    }

    void send(string method, string url, string requestBody=null, string[string] headers=null, bool redirect=true){
        request( method,  url,  requestBody=null, headers = null);
        auto t = super.getResponse();
        writeln(t.status);
    }


}



mixin template RequestMethods(string headers)
{
    import std.stdio;
    import std.uni : toUpper;
    import std.algorithm: canFind;
    string headers;

    void encodeUrl(string method, string url, string[string] fields = null, string headers = null){
        if(!headers){
            headers = this.headers;
        }
    }

    HTTPResponse request(string method, string url, string[string] fields = null, string headers = null){
        method = method.toUpper();

        
        if( ENCODE_URL_METHODS.canFind(method)){
            //writeln(method);
        }
    }
    

}
