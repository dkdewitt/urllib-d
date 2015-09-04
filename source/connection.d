module connection;


import std.socket;
import util.connection;
import http.client;
import std.stdio;   
//alias _HTTPConnection = HTTPConnection;

class HTTPConnection: BaseHTTPConnection{

private:
    //default_socket_options = [(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)]

    
    string socketOptions;

    /**
    *   Establish new connection
    **/
    void newConnection(){
        string[string] extraKeywords;

        if(super.sourceAddress)
            extraKeywords["sourceAddress"] = super.sourceAddress;

        if(this.socketOptions)
            extraKeywords["socketOptions"] = this.socketOptions;

        try{
            auto connection = createConnection(super.host, super.timeout, super.sourceAddress);

        } catch(Exception exc){
            writeln("Exception");
        }
    }

    void prepareConnection(Socket conn){
        super.sock = conn;
        //Add tunnel crap
    }

    void connect(){
        newConnection();
        //prepareConnection(conn)
    }

public:
    this(string host, ushort port, int timeout=0, string sourceAddress=null){
        super(host, port, timeout, sourceAddress);
        //this.sourceAddress = sourceAddress;
    }
}

