


import std.socket;



class HTTPConnection{

private:
    default_socket_options = [(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)]


    string sourceAddress;

public:
    this(string sourceAddress){
        this.sourceAddress = sourceAddress;
    }
}


void main() {
    string[string] x;
    x["test"] = "1";

    //x.pop("test");
}