"""
   Copyright (c) 2024, UChicago Argonne, LLC
   All Rights Reserved

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--------------------------------------------------------------------------------
* Copyright (c) 2024, by Volumez Technologies Ltd
 
* All rights reserved. Not a Contribution
*
* Redistribution and use in source and binary forms, with or without modification, are strictly prohibited.
*
* - Licensee shall not copy, distribute, modify, adapt, translate, reverse engineer, decompile, disassemble, or create derivative works based on the Licensed Code.
* - Licensee shall not incorporate the Licensed Code with proprietary code.
* - Licensee shall not distribute the Licensed Code or any new works based on the Licensed Code.
* - Licensee shall not use the Licensed Code in any way not expressly permitted by this Agreement.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS 
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
* GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""

import numpy as np
import os 
import ctypes
import struct

from dlio_benchmark.common.constants import MODULE_DATA_READER
from dlio_benchmark.reader.reader_handler import FormatReader
from dlio_benchmark.utils.utility import Profile

dlp = Profile(MODULE_DATA_READER)


class NPYReader(FormatReader):
    """
    Reader for NPY files
    """

    @dlp.log_init
    def __init__(self, dataset_type, thread_index, epoch):
        super().__init__(dataset_type, thread_index)

    @dlp.log
    def open(self, filename):        
        super().open(filename)
        return self.load_npy_odirect(filename)
  
    def load_npy_odirect(self, filepath):
        alignment = 4096

        try:
            # Open the file with O_DIRECT
            fd = os.open(filepath, os.O_RDONLY | os.O_DIRECT)

            # Get the file size
            file_size = os.path.getsize(filepath)

            # Calculate the buffer size, aligned to 512 bytes
            buffer_size = ((file_size + alignment - 1) // alignment) * alignment

            # Allocate the aligned buffer
            buf = self.allocate_aligned_buffer(buffer_size)
            mem_view = memoryview(buf)

            # Read the file into the buffer
            bytes_read = os.readv(fd, [mem_view[0:buffer_size]])
            if bytes_read != file_size:
                raise IOError(f"Could not read the entire file. Expected {file_size} bytes, got {bytes_read} bytes")

            # Verify the magic string
            if buf[:6] != b'\x93NUMPY':
                raise ValueError("This is not a valid .npy file.")

            # Read version information
            major, minor = struct.unpack('<BB', buf[6:8])
            if major == 1:
                header_len = struct.unpack('<H', buf[8:10])[0]
                header = buf[10:10 + header_len]
            elif major == 2:
                header_len = struct.unpack('<I', buf[8:12])[0]
                header = buf[12:12 + header_len]
            else:
                raise ValueError(f"Unsupported .npy file version: {major}.{minor}")

            # Parse the header
            header_dict = eval(header.decode('latin1'))
            dtype = np.dtype(header_dict['descr'])
            shape = header_dict['shape']
            fortran_order = header_dict['fortran_order']

            # Calculate the data offset
            data_offset = (10 + header_len) if major == 1 else (12 + header_len)
            data_size = np.prod(shape) * dtype.itemsize

            # Load the array data
            data = np.ndarray(shape, dtype=dtype, buffer=mem_view[data_offset:data_offset + data_size])

            # If the array is in Fortran order, convert it
            if fortran_order:
                data = np.asfortranarray(data)
        finally:
            os.close(fd)

        return data

    def allocate_aligned_buffer(self, size, alignment=4096):
        buf_size = size + (alignment - 1)
        raw_memory = bytearray(buf_size)
        ctypes_raw_type = (ctypes.c_char * buf_size)
        ctypes_raw_memory = ctypes_raw_type.from_buffer(raw_memory)
        raw_address = ctypes.addressof(ctypes_raw_memory)
        offset = raw_address % alignment
        offset_to_aligned = (alignment - offset) % alignment
        ctypes_aligned_type = (ctypes.c_char * (buf_size - offset_to_aligned))
        ctypes_aligned_memory = ctypes_aligned_type.from_buffer(raw_memory, offset_to_aligned)
        return ctypes_aligned_memory
        
    @dlp.log
    def close(self, filename):
        super().close(filename)

    @dlp.log
    def get_sample(self, filename, sample_index):
        super().get_sample(filename, sample_index)
        image = self.open_file_map[filename][..., sample_index]
        dlp.update(image_size=image.nbytes)

    def next(self):
        for batch in super().next():
            yield batch

    @dlp.log
    def read_index(self, image_idx, step):
        return super().read_index(image_idx, step)

    @dlp.log
    def finalize(self):
        return super().finalize()

    def is_index_based(self):
        return True

    def is_iterator_based(self):
        return True