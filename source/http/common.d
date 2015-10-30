module http.common;
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
import util.hashlist;
import std.format;

import std.exception;

class CannotSendRequestException : Exception {
     this (string msg) {
         super(msg);
     }
 }


class CannotSendHeader : Exception {
    this(string msg){
        super(msg);
    }
}

class ResponseNotReady : Exception {
    this(string msg){
        super(msg);
    }
}

class NotConnected : Exception {
    this(string msg){
        super(msg);
    }
}


protected immutable string[] METHODS_REQUIRING_BODY = ["PATCH", "PUT", "POST"];
protected immutable string[] ENCODE_URL_METHODS = ["DELETE", "GET", "HEAD", "OPTION"];

enum HTTPVersion{
    HTTP_1_1 = "HTTP/1.1",
    HTTP_1_0 = "HTTP/1.0"
    
}


enum ConnectionState{
    CS_IDLE = "Idle",
    CS_REQ_STARTED = "Request-started",
    CS_REQ_SENT = "Request-sent"
}

enum DefaultPorts{
    HTTP = 80,
    HTTPS = 443
}

enum HTTPMethod {
    GET,
    HEAD,
    PUT,
    POST,
    PATCH,
    DELETE,
    OPTIONS,
    TRACE,
    CONNECT,
}

enum maxHeaderLength = 4096;

HTTPMethod httpMethodFromString(string str)
{
    switch(str){
        default: throw new Exception("Invalid HTTP method: "~str);
        // HTTP standard, RFC 2616
        case "GET": return HTTPMethod.GET;
        case "HEAD": return HTTPMethod.HEAD;
        case "PUT": return HTTPMethod.PUT;
        case "POST": return HTTPMethod.POST;
        case "PATCH": return HTTPMethod.PATCH;
        case "DELETE": return HTTPMethod.DELETE;
        case "OPTIONS": return HTTPMethod.OPTIONS;
        case "TRACE": return HTTPMethod.TRACE;
        case "CONNECT": return HTTPMethod.CONNECT;
}}

void parseHeaders(string input, ref Headers requestHeaders){
        auto y = splitter(input, "\r\n");
        
        string [] requestLine = y.takeOne()[0].split(" ");
        foreach (lineNum, line; y.dropOne().enumerate(1)){
            if(line.length<1){
                continue;
            }
           
            auto sepPosition = line.indexOf(":");

            requestHeaders.insert(line[0..sepPosition], line[sepPosition+2..$]);
        }
        

}

void makeHeaders(){}

alias Headers = HashList!(string);



struct Data{
    char[] data;
    long size;
    long i;
    string[string] headers;
    Headers h1;

    this(long i, char[] data){

        size = i;
        data = data;
    }
    @property bool empty()
    {
        return i == size;
    }

    @property char front()
    {
        return data[i];
    }

    void popFront()
    {
        ++i;
    }

}

