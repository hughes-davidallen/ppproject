/*************************************************/
/* START of thermal */
#include <thermal.h>

#include <x10/lang/Object.h>
#include <x10/array/Array.h>
#include <x10/lang/String.h>
#include <x10/io/Printer.h>
#include <x10/io/Console.h>

//#line 9 "D:\x10dt\workspace\thermal\src\thermal.x10": x10.ast.X10MethodDecl_c
void thermal::main(x10aux::ref<x10::array::Array<x10aux::ref<x10::lang::String> > > id__29064) {
    
    //#line 10 "D:\x10dt\workspace\thermal\src\thermal.x10": Eval of x10.ast.X10Call_c
    _X10_STATEMENT_HOOK(); x10aux::nullCheck(x10::io::Console::FMGL(OUT))->x10::io::Printer::println(
                             x10aux::string_utils::lit("Hello, World!"));
}

//#line 4 "D:\x10dt\workspace\thermal\src\thermal.x10": x10.ast.X10MethodDecl_c
x10aux::ref<thermal> thermal::thermal____thermal__this() {
    
    //#line 4 "D:\x10dt\workspace\thermal\src\thermal.x10": x10.ast.X10Return_c
    _X10_STATEMENT_HOOK(); return ((x10aux::ref<thermal>)this);
    
}

//#line 4 "D:\x10dt\workspace\thermal\src\thermal.x10": x10.ast.X10ConstructorDecl_c
void thermal::_constructor() {
    
    //#line 4 "D:\x10dt\workspace\thermal\src\thermal.x10": x10.ast.X10ConstructorCall_c
    _X10_STATEMENT_HOOK(); (this)->::x10::lang::Object::_constructor();
    {
        
        //#line 4 "D:\x10dt\workspace\thermal\src\thermal.x10": x10.ast.AssignPropertyCall_c
        _X10_STATEMENT_HOOK(); 
        {
         
        }
    }
}
x10aux::ref<thermal> thermal::_make() {
    x10aux::ref<thermal> this_ = new (memset(x10aux::alloc<thermal>(), 0, sizeof(thermal))) thermal();
    this_->_constructor();
    return this_;
}


const x10aux::serialization_id_t thermal::_serialization_id = 
    x10aux::DeserializationDispatcher::addDeserializer(thermal::_deserializer, x10aux::CLOSURE_KIND_NOT_ASYNC);

void thermal::_serialize_body(x10aux::serialization_buffer& buf) {
    x10::lang::Object::_serialize_body(buf);
    
}

x10aux::ref<x10::lang::Reference> thermal::_deserializer(x10aux::deserialization_buffer& buf) {
    x10aux::ref<thermal> this_ = new (memset(x10aux::alloc<thermal>(), 0, sizeof(thermal))) thermal();
    buf.record_reference(this_);
    this_->_deserialize_body(buf);
    return this_;
}

void thermal::_deserialize_body(x10aux::deserialization_buffer& buf) {
    x10::lang::Object::_deserialize_body(buf);
    
}

x10aux::RuntimeType thermal::rtt;
void thermal::_initRTT() {
    if (rtt.initStageOne(&rtt)) return;
    const x10aux::RuntimeType* parents[1] = { x10aux::getRTT<x10::lang::Object>()};
    rtt.initStageTwo("thermal",x10aux::RuntimeType::class_kind, 1, parents, 0, NULL, NULL);
}
/* END of thermal */
/*************************************************/

static const char _X10strings[] __attribute__((used)) __attribute__((_X10_DEBUG_DATA_SECTION)) =
    "thermal\0" //0
    "thermal.cc\0" //8
    "D:\\x10dt\\workspace\\thermal\\src\\thermal.x10\0" //19
    "main\0" //62
    "void\0" //67
    "x10.array.Array[x10.lang.String]\0" //72
    "x10aux::ref<x10::array::Array<x10aux::ref<x10::lang::String> > >\0" //105
    "";

static const struct _X10sourceFile _X10sourceList[] __attribute__((used)) __attribute__((_X10_DEBUG_DATA_SECTION)) = {
    { 0, 19 },
};

static const struct _X10toCPPxref _X10toCPPlist[] __attribute__((used)) __attribute__((_X10_DEBUG_DATA_SECTION)) = {
    { 0, 8, 4, 36, 38 },
    { 0, 8, 9, 12, 17 },
    { 0, 8, 10, 15, 16 },
    { 0, 8, 11, 17, 17 },
};

static const struct _CPPtoX10xref _CPPtoX10xrefList[] __attribute__((used)) __attribute__((_X10_DEBUG_DATA_SECTION)) = {
    { 0, 8, 9, 12, 17 },
    { 0, 8, 10, 15, 16 },
    { 0, 8, 11, 17, 17 },
    { 0, 8, 4, 20, 25 },
    { 0, 8, 4, 23, 23 },
    { 0, 8, 4, 28, 40 },
    { 0, 8, 4, 31, 31 },
    { 0, 8, 4, 32, 39 },
    { 0, 8, 4, 35, 35 },
    { 0, 8, 4, 36, 38 },
    { 0, 8, 4, 39, 39 },
    { 0, 8, 4, 40, 40 },
};

static const struct _X10methodName _X10methodNameList[] __attribute__((used)) = {
#if defined(__xlC__)
    { 0, 62, 67, 0, (uint64_t) 0, 1, 0, 11 }, // thermal.main()
#else
    { 0, 62, 67, 0, (uint64_t) "\0\0\0\110" "", 1, 0, 11 }, // thermal.main()
#endif
};

static const struct _X10TypeMember _X10thermalMembers[] __attribute__((used)) __attribute__((_X10_DEBUG_DATA_SECTION)) = {
};

static const struct _X10ClassMap _X10ClassMapList[] __attribute__((used)) = {
    { 101, 0, sizeof(thermal), 0, _X10thermalMembers },
};

static const struct _MetaDebugInfo_t _MetaDebugInfo __attribute__((used)) __attribute__((_X10_DEBUG_SECTION)) = {
    sizeof(struct _MetaDebugInfo_t),
    X10_META_LANG,
    0x0B08170C, // 2011-08-23, 12:00
    sizeof(_X10strings),
    sizeof(_X10sourceList),
    sizeof(_X10toCPPlist),
    sizeof(_CPPtoX10xrefList),
    sizeof(_X10methodNameList),
    0,  // no local variable mappings
    sizeof(_X10ClassMapList),
    0,  // no closure mappings
    0, // no array mappings
    0, // no reference mappings
    _X10strings,
    _X10sourceList,
    _X10toCPPlist,
    _CPPtoX10xrefList,
    _X10methodNameList,
    NULL,
    _X10ClassMapList,
    NULL,
    NULL,
    NULL
};
