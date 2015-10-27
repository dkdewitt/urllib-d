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
    HTTP_1_1 = "HTTP/1.1"
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


void parseHeaders(){

    string[string] headers;


}

void makeHeaders(){}

alias Headers = HashList!(string);

