import glob
import os
import platform
import sys
import sysconfig
from setuptools import setup
from setuptools import find_namespace_packages
from setuptools import Extension
try:
    from Cython.Build import cythonize
    USE_CYTHON = True
except ImportError:
    USE_CYTHON = False

__author__ = 'Tiziano Bettio'
__license__ = 'MIT'
__version__ = '0.0.7'
__copyright__ = """
Copyright (c) 2021 Tiziano Bettio
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

with open('README.md', 'r') as fh:
    long_description = fh.read()

with open('VERSION', 'r') as fh:
    version = fh.read()

if platform.system() == 'Windows':
    EXTRA_COMPILE_ARGS = []
    EXTRA_LINK_ARGS = []
elif platform.system() == 'Darwin':
    EXTRA_COMPILE_ARGS = ['-std=c++11', '-stdlib=libc++']
    EXTRA_LINK_ARGS = ['-std=c++11', '-stdlib=libc++']
else:
    EXTRA_COMPILE_ARGS = ['-std=c++11']
    EXTRA_LINK_ARGS = ['-std=c++11']

# Add "c++_shared" to libraries if installed via python-for-android
LIBRARIES = []
if 'ARCH' in os.environ and os.environ['ARCH'].startswith('arm'):
    LIBRARIES.append('c++_shared')

# Build against the stable ABI so one wheel per platform covers CPython 3.11+.
# 3.11 is the first version whose limited API includes the buffer protocol
# needed by typed memoryviews. Free-threaded builds have no stable ABI.
LIMITED_API = (
    USE_CYTHON
    and sys.version_info >= (3, 11)
    and not sysconfig.get_config_var('Py_GIL_DISABLED')
)
DEFINE_MACROS = [('Py_LIMITED_API', '0x030B0000')] if LIMITED_API else []

EXT = '.pyx' if USE_CYTHON else '.cpp'
EXTENSIONS = [
    Extension(
        i[4:-4].replace('/', '.').replace('\\', '.'),
        [i],
        include_dirs=['ext/FastNoise', 'ext/CPPWrapper'],
        extra_compile_args=EXTRA_COMPILE_ARGS,
        extra_link_args=EXTRA_LINK_ARGS,
        language='c++',
        libraries=LIBRARIES,
        define_macros=DEFINE_MACROS,
        py_limited_api=LIMITED_API,
    )
    for i in glob.glob('src/pyfastnoiselite/**/*' + EXT, recursive=True)
]


def ext_modules():
    if USE_CYTHON:
        return cythonize(EXTENSIONS,
                         compiler_directives={'language_level': 3,
                                              'embedsignature': True},
                         annotate=False)
    return EXTENSIONS


# Check if the submodule is present, download if not.
if not os.path.exists('ext/FastNoise/Cpp/FastNoiseLite.h'):
    import io, shutil, urllib.request, zipfile
    uri = 'https://github.com/Auburn/FastNoise/archive/master.zip'
    req = urllib.request.urlopen(uri)
    buf = io.BytesIO(req.read())
    zipf = zipfile.ZipFile(buf)
    if not os.path.exists('tmp'):
        os.makedirs('tmp')
    zipf.extractall('tmp/')
    if not os.path.exists('ext/FastNoise'):
        os.makedirs('ext/FastNoise')
    for pth in glob.glob('tmp/FastNoise-master/*', recursive=True):
        shutil.move(pth, 'ext/FastNoise')
    shutil.rmtree('tmp')


setup(
    name='pyfastnoiselite',
    version=version,
    author='Tiziano Bettio',
    author_email='tc@tizilogic.com',
    description='Cython wrapper for Auburns\' FastNoise Lite.',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/tizilogic/pyfastnoiselite',
    packages=find_namespace_packages(where='src'),
    package_data={'pyfastnoiselite': [
        'LICENSE',
        'VERSION'
    ]},
    package_dir={'': 'src'},
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.9',
    install_requires=['numpy'],
    ext_modules=ext_modules(),
    options={'bdist_wheel': {'py_limited_api': 'cp311'}} if LIMITED_API else {},
)