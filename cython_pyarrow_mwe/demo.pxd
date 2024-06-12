cimport numpy as np
cimport pyarrow.lib as libpa
from libcpp.memory cimport shared_ptr

cdef shared_ptr[libpa.CTable] make_table(int n)
