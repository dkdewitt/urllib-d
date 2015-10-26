module connection;


import std.socket;
import util.connection;
import http.client;
import http.common;
import std.stdio;   
//alias _HTTPConnection = HTTPConnection;




class HTTPConnection: BaseHTTPConnection{

private:
    //default_socket_options = [(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)]
    int defaulPort = 80;
    
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

    //void connect(){
    //    auto conn = newConnection();
    //    prepareConnection(conn);
    //}

public:

    this(string host, ushort port=0, int timeout=0, string sourceAddress=null, string[string] headers = null){
        super(host, port, timeout, sourceAddress);
        //this.sourceAddress = sourceAddress;
            auto conn = newConnection();
        prepareConnection(conn);
    }
}



struct RequestMethods{

private: 
    string[string] headers;
    


public:
    this(string[string] headers = null){
        this.headers = headers;
    }

    void request(string method, string[string] fields=null, string[string] headers=null){
        import std.algorithm: find;
        import std.string : toUpper;

        if(find(ENCODE_URL_METHODS, method.toUpper())){

        }
    }

    void encodeRequestURL(string method, string url, string fields = null, string[string] headers = null){

        if(!headers){
            headers = this.headers;
        }
        //string[string[string]] extraKeywords = ["headers" : headers];

        if(fields){
            //url ~= "?" urlencode(fields);
        }

        //return urlOpen(method, url, extraKeywords);
    }

    //void encodeRequestURL()
}



