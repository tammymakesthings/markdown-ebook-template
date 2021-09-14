#!python

import glob
import sys
import os
from num2words import num2words

try:
    MANUSCRIPT_DIR=sys.argv[1]
except IndexError:
    MANUSCRIPT_DIR=os.getcwd()

flist = sorted(glob.glob(f"{MANUSCRIPT_DIR}/ch_*.md"))
last_file = os.path.basename(flist[-1])
(fname, fext) = last_file.split(".", 2)
(_, file_num_str) = fname.split("_", 2)
file_num = int(file_num_str)

file_num = file_num + 1
chapter_num_str = num2words(file_num).replace('-', ' ').title()
filename = f"ch_{str(file_num).zfill(3)}.md"
with open(filename, "w") as f:
    f.write("\n")
    f.write(f"# Chapter {chapter_num_str}\n")
    f.write("\n")

print(f"Created Chapter {chapter_num_str} in {filename}.")
