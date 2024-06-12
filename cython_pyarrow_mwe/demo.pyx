import pyarrow as pa

cimport numpy as np
cimport pyarrow as pa
cimport pyarrow.lib as libpa

from libcpp.memory cimport shared_ptr
from libcpp.vector cimport vector


SCHEMA = pa.schema([pa.field("col", pa.int32(), nullable=False)])

cdef shared_ptr[libpa.CTable] make_table(int n):
    cdef:
        libpa.CMemoryPool *pool = libpa.c_get_memory_pool()
        libpa.CInt32Builder *col = new libpa.CInt32Builder(pool)
        vector[shared_ptr[libpa.CArray]] columns
        int i

    for i in range(n, 0, -1):
        col.Append(i)

    columns.resize(1)
    col.Finish(&columns[0])

    cdef:
        shared_ptr[libpa.CSchema] schema = libpa.pyarrow_unwrap_schema(SCHEMA)
        shared_ptr[libpa.CTable] table = libpa.CTable.MakeFromArrays(schema, columns)

    del col
    return table

def example(n: int):
    return libpa.pyarrow_wrap_table(make_table(n))
