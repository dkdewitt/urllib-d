module url.parser;

import std.stdio;
import std.exception;
import std.string;
import std.conv;
import std.algorithm;
import std.array;

struct URL{

private:

    string scheme;
    string domain;
    string path;
    ushort port;
    string  query;
    string fragment;


    void parseScheme(ref string url){
        if(url.indexOf("://")!= -1){
            this.scheme = url[0..url.indexOf("://")];
            url = url[url.indexOf("//")+2 .. $];
        }
        else{
            this.scheme = "";
        }

        //writeln(this.scheme);
    }

    void parseHost(ref string url){
        auto tmp = url;
        auto loc = tmp.indexOf("/");

        if(loc > 0){
            tmp = url[0..loc];
            url = url[loc..$];
        }
        
        if(loc < 0){
            this.path = url;
            auto seperator = url.indexOf(":");
            if(seperator > 0){
                this.port = to!ushort(url[seperator+1..$]);
                this.path = url[0..seperator];
            }

        }    

    }

public:

    this(string url){
        enforce(url.length > 0);
        string urlTmp = url;
        parseScheme(urlTmp);
        parseHost(urlTmp);
        //writeln(this.path);
        writeln(urlTmp);
    }




}

    void main() {
        
        auto URL = URL("http://www.google.com/index");
    }