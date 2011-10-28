#ifndef __THERMAL_H
#define __THERMAL_H

#include <x10rt.h>


#define X10_LANG_OBJECT_H_NODEPS
#include <x10/lang/Object.h>
#undef X10_LANG_OBJECT_H_NODEPS
namespace x10 { namespace array { 
template<class TPMGL(T)> class Array;
} } 
namespace x10 { namespace lang { 
class String;
} } 
namespace x10 { namespace io { 
class Printer;
} } 
namespace x10 { namespace io { 
class Console;
} } 
class thermal : public x10::lang::Object   {
    public:
    RTT_H_DECLS_CLASS
    
    static void main(x10aux::ref<x10::array::Array<x10aux::ref<x10::lang::String> > > id__29064);
    virtual x10aux::ref<thermal> thermal____thermal__this();
    void _constructor();
    
    static x10aux::ref<thermal> _make();
    
    
    // Serialization
    public: static const x10aux::serialization_id_t _serialization_id;
    
    public: virtual x10aux::serialization_id_t _get_serialization_id() {
         return _serialization_id;
    }
    
    public: virtual void _serialize_body(x10aux::serialization_buffer& buf);
    
    public: static x10aux::ref<x10::lang::Reference> _deserializer(x10aux::deserialization_buffer& buf);
    
    public: void _deserialize_body(x10aux::deserialization_buffer& buf);
    
};
#endif // THERMAL_H

class thermal;

#ifndef THERMAL_H_NODEPS
#define THERMAL_H_NODEPS
#ifndef THERMAL_H_GENERICS
#define THERMAL_H_GENERICS
#endif // THERMAL_H_GENERICS
#endif // __THERMAL_H_NODEPS
