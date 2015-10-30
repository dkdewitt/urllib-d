module url.parser;

import std.stdio;
import std.exception;
import std.string;
import std.conv;
import std.algorithm;
import std.array;
struct URL{

    string scheme;
    string host;
    
    ushort port;
    string path;

    string  query;
    string fragment;


    this(string url , bool allowFragments=true){
        enforce(url.length > 0);

        string urlTmp = url;
        
        if ( urlTmp.indexOf("://") != -1){
            long loc = urlTmp.indexOf("://");
            string scheme = urlTmp[0..loc];
            //writeln(urlTmp[loc]);
            urlTmp = urlTmp[loc+1..$];
            this.scheme = scheme;
            //writeln(this.scheme);
            switch (scheme){
                case "http":
                case "ftp" : 
                case "https" :
                    enforce(urlTmp.startsWith("//"), "URL does not contain //");
                    urlTmp = urlTmp[2..$];
                    goto default;
                default:
                    long hostBeg = 0;
                    long hostEnd = urlTmp.indexOf("/");
                    string hostTmp;
                    if (hostEnd == -1){
                        hostEnd = urlTmp.length;
                        hostTmp = urlTmp;
                    }
                    else
                        hostTmp = urlTmp[0..hostEnd];
                    //Check if credentials are passed in
                    
                    auto userpassLoc = hostTmp.indexOf("@");
                    hostBeg = userpassLoc+1;
                    
                    if(userpassLoc > 0){
                        //Seperate Out for user and pass

                        auto credentials = hostTmp[0..userpassLoc];
                        auto seperator = credentials.indexOf(":");
                        auto username = credentials[0..seperator];
                        auto password = credentials[seperator+1..$];

                        enforce(username.length > 0, "Cannot have empty username");

                    }
                    this.host  = urlTmp[hostBeg..hostEnd];
                    auto portTmpLoc = this.host.indexOf(":");

                    if(portTmpLoc > 0){
                        enforce(portTmpLoc < this.host.length -1, "Invalid Port");
                    
                    this.port = to!ushort(this.host[portTmpLoc+1..$]);
                    this.host = this.host[0 .. portTmpLoc];
                }

                urlTmp = urlTmp[hostEnd..$]; 
                auto sep = urlTmp.indexOf("?");
                long tmpFrag;
                tmpFrag = urlTmp.indexOf("#");
                if (tmpFrag > 0){

                    this.fragment= urlTmp[tmpFrag..$];
                    urlTmp = urlTmp[0..tmpFrag];    
                    }
                if(sep > 0){
            
                    if(tmpFrag > 0)
                        this.query = urlTmp[sep+1..tmpFrag];
                    else
                        this.query = urlTmp[sep+1..$]; 
                    this.path = urlTmp[0..sep];

                }


                else{
                    tmpFrag = urlTmp.indexOf("#");
                    if (tmpFrag > 0){
                        auto path = urlTmp[0..tmpFrag];
                        this.path = path;
                        
                    }

                }


            }
        }


    }
}


/**
*   Parse URL into 5 components <scheme>://<host>/<path>?<query>#<fragment>
**/
URL urlSplit(string url, string scheme = "", bool allowFragments=true){
    URL u1 = URL(url);

    return u1;
}

