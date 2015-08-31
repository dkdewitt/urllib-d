module urllib.urlparser;

import std.stdio;
import std.exception;
import std.string;
import std.conv;

struct URL{

    string scheme;
    string netloc;
    ushort port;
    string path;
    //string params;
    string  query;
    string fragment;


    this(string url ){
        enforce(url.length > 0);

        string urlTmp = url;
        

        if ( urlTmp.indexOf("://") != -1){
            long loc = urlTmp.indexOf("://");
            string scheme = urlTmp[0..loc];
            //writeln(urlTmp[loc]);
            urlTmp = urlTmp[loc+1..$];
            this.scheme = scheme;
            writeln(this.scheme);
            switch (scheme){
                case "http":
                case "ftp" : 
                case "https" :
                    enforce(urlTmp.startsWith("//"), "URL does not contain //");
                    urlTmp = urlTmp[2..$];
                    goto default;
                default:
                    writeln(urlTmp);
                    //Get next slash
                    long netlocBeg = 0;
                    long netlocEnd = urlTmp.indexOf("/");

                    if (netlocEnd == -1)
                        //Fix this
                        break;

                    string hostTmp = urlTmp[0..netlocEnd];
                    //Check if credentials are passed in

                    auto userpassLoc = hostTmp.indexOf("@");
                    netlocBeg = userpassLoc+1;
                    if(userpassLoc > 0){
                        //Seperate Out for user and pass
                        auto credentials = hostTmp[0..userpassLoc];
                        auto seperator = credentials.indexOf(":");
                        auto username = credentials[0..seperator];
                        auto password = credentials[seperator+1..$];

                        enforce(username.length > 0, "Cannot have empty username");

                    }
                    this.netloc  = urlTmp[netlocBeg..netlocEnd];
                    auto portTmpLoc = this.netloc.indexOf(":");

                    if(portTmpLoc > 0){
                        enforce(portTmpLoc < this.netloc.length -1, "Invalid Port");
                    
                    this.port = to!ushort(this.netloc[portTmpLoc+1..$]);
                    this.netloc = this.netloc[0 .. portTmpLoc];
                }
                urlTmp = urlTmp[netlocEnd..$]; 
                auto sep = urlTmp.indexOf("?");
                long tmpFrag;
                if(sep > 0){
                    tmpFrag = urlTmp.indexOf("#");
 
                    this.path = urlTmp[0..sep];


                    tmpFrag = urlTmp.indexOf("#");
                    if(tmpFrag > 0)
                        this.query = urlTmp[sep+1..tmpFrag];
                        //this.fragment = urlTmp[tmpFrag+1..$];
                    else
                        this.query = urlTmp[sep+1..$]; 


                    //this.path = path;

                }


                else{
                    tmpFrag = urlTmp.indexOf("#");
                    if (tmpFrag > 0){
                        auto path = urlTmp[0..tmpFrag];
                        this.path = path;
                        
                    }

                }
                    if(tmpFrag > 0)
                       this.fragment=urlTmp[tmpFrag+1..$];

            }
        }


    }
}