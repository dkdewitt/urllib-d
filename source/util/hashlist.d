module util.hashlist;

struct HashList(Value){


    string[] keyOrder;

    Value[string] kv;


    this(string k, Value v){
        keyOrder ~= k;
        kv[k] = v;
    }


    void insert(string key, Value value){

        keyOrder ~= key;
        kv[key] = value;
    }

    inout(Value) opIndex(size_t index) inout {
        return kv[keyOrder[index]];
    }

    inout(Value) opIndex(string key) inout {
        return kv[key];
    }

    Value get(string key, lazy Value defVal){
        return  kv.get(key, defVal);
        
    }
}
