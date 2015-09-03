module http.requests;
import std.uni;

private immutable string[] ENCODED_URL_METHODS = ["GET", "HEAD","DELETE", "OPTIONS"];

class Request{
private:
    string[string] _headers;


    void _requestEncodeUrl(string method, string url, string[string] fields = null, string[string] headers=null){
        if(headers == null){
            headers = _headers;
        }
        if (fields){

        }
    }


public:
    this(string[string] headers=null){
        _headers = headers;
    }

    void request(string method, string url){
        method = method.toUpper(); 
    }
}



unittest{

}

