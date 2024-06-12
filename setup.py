from setuptools import Extension, setup
from Cython.Build import cythonize
import pyarrow as pa
import numpy as np
import pathlib
import os

pa.create_library_symlinks()

ext_modules = [
    Extension(
        "cython_pyarrow_mwe.demo",
        [str(pathlib.Path() / "cython_pyarrow_mwe" / "demo.pyx")],
        define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
        language="c++",
    ),
]

for ext in ext_modules:
    # The Numpy C headers are currently required
    ext.include_dirs.append(np.get_include())
    ext.include_dirs.append(pa.get_include())
    ext.libraries.extend(pa.get_libraries())
    ext.library_dirs.extend(pa.get_library_dirs())

    if os.name == 'posix':
        ext.extra_compile_args.append('-std=c++17')

setup(
    name="cython_pyarrow_mwe",
    ext_modules=cythonize(
        ext_modules,
        compiler_directives={"language_level": "3str"},
    ),
)
