module connection;


import std.socket;
import util.connection;
import http.client;

//alias _HTTPConnection = HTTPConnection;

class HTTPConnection: BaseHTTPConnection{

private:
    //default_socket_options = [(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)]

    string sourceAddress;
    string[string] socketOptions;

    /**
    *   Establish new connection
    **/
    void newConnection(){
        string[string] extraKeywords;

        if(this.sourceAddress)
            extraKeywords["sourceAddress"] = this.sourceAddress;

        if(this.socketOptions)
            extraKeywords["socketOptions"] = this.socketOptions;

        try{
            //auto connection = createConnection();

        } catch(Exception exc){
            writeln("Exception");
        }
    }

public:
    this(string sourceAddress){
        this.sourceAddress = sourceAddress;
    }
}

