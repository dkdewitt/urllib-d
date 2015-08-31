import std.socket;
import std.stdio;
import std.conv;
struct Address{
    string host;
    ushort port;
}


Socket createConnection(Address address, string timeout, ){
    string host = address.host;
    ushort port = address.port;
    auto res = getAddressInfo(host, to!string(port),SocketType.STREAM);
    writeln(res);
    return null;
}

void main() {
    //auto results = getAddressInfo("localhost", SocketType.STREAM);
    //writeln(results);


    auto x = createConnection(Address("localhost",5001),"");
}