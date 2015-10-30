module connectionpool;



class ConnectionPool{
public:

    string scheme;
    string host;
    ushort port;
    this(string host, ushort port=0){
        this.host = host;
        this.port = port;
    }

}


class HTTPConnectionPool:ConnectionPool{

public:
    string scheme = "http";

    this(string host, ushort port = 0){
        super(host, port);
    }

}

