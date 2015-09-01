module util.connection;

import std.socket;
import std.stdio;
import std.conv;

struct Address{
    string host;
    ushort port;
}


Socket createConnection(string address, string timeout, string sourceAddress=null){
    return createConnection(Address(address), timeout, sourceAddress);
}

Socket createConnection(Address address, string timeout, string sourceAddress=null ){
    string host = address.host;
    ushort port = address.port;
    auto result = getAddressInfo(host, to!string(port),SocketType.STREAM);
    foreach(res; result){
    writeln(res);
    Socket sock;


    try{
        sock = new Socket(res.family, res.type, res.protocol);


        if(sourceAddress)
            sock.bind(parseAddress(sourceAddress));

        //return sock;

    }
    catch{}
}
    return null;
}

/*\\
void main() {

    auto x = createConnection(Address("localhost",80),"");
    writeln(x);
}*/