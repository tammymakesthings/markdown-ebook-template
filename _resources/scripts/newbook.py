#!/usr/bin/env python
##############################################################################
# Create a new book, copying from the book_template directory and replacing
# tags.
#
# The tag names and values are defined in the `tag_dict` dict inside of
# `script_main`. This can be extended; `replace_tags_in` will happily replace
# any tags that are present in the `tag_dict` dict.
#
# The next book number is determined automatically, but can be overridden on
# the command line.
##############################################################################

from sys import argv
from os import mkdir
from os.path import realpath, dirname, basename, join, exists, isfile
from shutil import copytree, rmtree
from glob import glob
from datetime import datetime
from typing import List, Dict, Any, Optional
import re
import json

SCRIPT_VER = "1.0.0"
SCRIPT_VER_PARTS = SCRIPT_VER.split(".", 3)
SCRIPT_DATE = "2020-May-20"


def get_next_book_num(top_dir: str) -> int:
    """Gets the next book number from the filesystem."""

    newest_book: List[str] = sorted(glob(f"{top_dir}/book_*_*"))[-1]
    toks: List[str] = basename(newest_book).split("_", 3)
    return int(toks[1]) + 1


def title_to_slug(book_title: str) -> str:
    """Converts a book title to an alphanumeric slug."""

    book_slug: str = book_title.lower()
    book_slug = book_slug.replace(" ", "qqq")
    book_slug = re.sub(r'\W+', '', book_slug)
    book_slug = book_slug.replace('qqq', '_')
    return book_slug


def replace_tags_in(file_path: str,
                    tag_dict: Dict[str, Any]) -> bool:
    """Replaces variable tags in a specified file."""

    file_data: str = None

    with open(file_path, "r") as file_handle:
        file_data = file_handle.read()

    if (file_data.find("@@")):
        for dict_key in sorted(tag_dict.keys()):
            file_data = file_data.replace(f"@@{dict_key.upper()}@@",
                                          tag_dict[dict_key])

        with open(file_path, "w") as file_handle:
            file_handle.write(file_data)

        return True
    return False


def prompt_string(prompt_msg: str,
                  error_msg: Optional[str] = "Input not valid.") -> str:
    """Prompts the user for input, repeating until input is provided."""

    input_data: str = input(prompt_msg)
    while len(input_data.strip()) == 0:
        print(error_msg)
        input_data: str = input(prompt_msg)
    return input_data


def confirm_yorn(prompt_msg: str) -> bool:
    """Prompts the user for a yes or no answer."""

    confirm_input: str = input(prompt_msg)
    return confirm_input.lower()[0] == "y"


def banner_msg() -> None:
    """Displays the app startup banner."""

    print("*" * 76)
    print("*       ",
          "newbook.py - Create a new book in the series from a template",
          "       *")
    print("*" * 76)
    print("")


def print_usage(which_arg: Optional[str] = None) -> None:
    """Prints a version or usage message."""
    if which_arg in ["--version", "-v"]:
        print(f"newbook.py version {SCRIPT_VER}, {SCRIPT_DATE}")
        return

    print("Usage: newbook.py [book-number]")
    print("       newbook.py [-v] (or --version)")
    print("       newbook.py [-h] (or --help or --usage) ")
    print("")
    print("The book title will be prompted for interactively. If the book")
    print("number is not specified on the command line, the directory tree")
    print("will be examined and the next number will be chosen automatically.")
    print("")
    print("Variable replacements will be made in all files. Consult the")
    print("definition of tag_dict in the code for the list of defined")
    print("variables.")


def skip_file_by_ext(file_path: str) -> bool:
    skip_exts: List[str] = [
        ".pdf", ".docx", ".mobi", ".epub",
        ".gif", ".png", ".jpg", ".psd", ".xcf",
        ".ttf", ".otf"
    ]
    check_ext: str = None

    for check_ext in skip_exts:
        if file_path.endswith(check_ext):
            return True
    return False


def add_project_to_vscode_workspace(top_dir: str,
                                    new_dir_name: str) -> None:

    workspace_file: str = join(top_dir, "az_mysteries.code-workspace")
    workspace_data = None

    if not isfile(workspace_file):
        return

    with open(workspace_file, "r") as file_handle:
        workspace_data = json.load(file_handle)

    for folder in workspace_data["folders"]:
        if folder["path"] == realpath(new_dir_name):
            return
    workspace_data["folders"].append({'path': new_dir_name})
    with open(workspace_file, "w") as file_handle:
        json.dump(workspace_data, file_handle, indent=4)


def script_main(force_book_num: Optional[int] = None) -> int:
    """The main entrypoint for the script."""

    top_dir: str = dirname(realpath(realpath(__file__) + "/../.."))
    template_folder: str = f"{top_dir}/_resources/book_template"
    book_num: int = force_book_num

    if force_book_num is None:
        book_num = get_next_book_num(top_dir)
    else:
        book_num = force_book_num

    print(f"We're creating book number {book_num} - yay!")

    book_title = prompt_string("New book title: ",
                               "We can't create a book without a title!")
    book_slug: str = title_to_slug(book_title)
    new_dir_name: str = join(top_dir,
                             f"book_{str(book_num).zfill(3)}_{book_slug}")

    tag_dict: Dict[str, Any] = {
        'TITLE': book_title.strip(),
        'TITLE_NOSPACE': book_title.replace(' ', ''),
        'TITLE_SLUG': book_title.lower().replace(' ', ''),
        'SLUG': book_slug,
        'FOLDER': new_dir_name,
        'BOOKNUM': str(book_num),
        'BOOKNUMZ': str(book_num).zfill(3),
        'TEMPLATE': template_folder,
        'TODAY': datetime.today().strftime("%Y-%m-%d"),
        'YEAR': datetime.today().strftime("%Y"),
        'MONTH': datetime.today().strftime("%m"),
        'DAY': datetime.today().strftime("%d"),
        'NOW': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    if (exists(new_dir_name)):
        if confirm_yorn(f"The directory {new_dir_name} exists - delete it?"):
            print("* Removing existing directory")
            rmtree(new_dir_name, ignore_errors=True)
        else:
            print("OK, bailing out!")
            exit(1)

    print("* Copying book template files")
    copytree(template_folder, new_dir_name)

    print("* Updating file tags in the new directory")
    updated_file_count: int = 0
    total_file_count: int = 0

    for new_file in glob(join(new_dir_name, "**"), recursive=True):
        if isfile(new_file) and not skip_file_by_ext(new_file):
            if replace_tags_in(realpath(new_file), tag_dict):
                print(f"    - Updated tags in {new_file}")
                updated_file_count = updated_file_count + 1
        else:
            print(f"    - Skipped {new_file}")

        total_file_count = total_file_count + 1

    add_project_to_vscode_workspace(top_dir, new_dir_name)
    print("* Added new project to vscode workspace file.")

    print("")
    print(f"All done. File tags were updated in",
          f"{updated_file_count} of {total_file_count} files.")
    print("Please make sure to add the new directory to git before too long.")
    exit(0)


if __name__ == "__main__":
    new_book_num: int = None

    if len(argv) == 2:
        if argv[1] in ["-h", "--help", "--version", "--usage"]:
            print_usage(argv[1])
            exit(0)

        try:
            new_book_num = int(argv[1])
        except ValueError:
            new_book_num = None

    banner_msg()

    if new_book_num is not None:
        script_main(new_book_num)
    else:
        script_main()
