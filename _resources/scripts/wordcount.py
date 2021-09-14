#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Writing Word Count Helper.

This helper can do the following:

- Display (and log) daily word count progress
- Display progress toward a word count goal.

It is not super robust but it does the trick.
"""


import re
import sys
import getopt
import datetime
from typing import List, Optional, Dict, Tuple, Any
from colorama import Fore, Style, Back


PROGRESS_BAR_LENGTH = 50    # Length of the ASCII progress bar


def count_words_in_markdown(markdown: str) -> int:
    """
    Count the words in a block of Markdown text.

    Strips off the markup before doing the word count.

    From https://github.com/gandreadis/markdown-word-count/blob/master/mwc.py
    and simplified just a bit.
    """
    text = markdown

    text = re.sub(r'<!--(.*?)-->', '', text, flags=re.MULTILINE)
    text = text.replace('\t', '    ')
    text = re.sub(r'[ ]{2,}', '    ', text)
    text = re.sub(r'^\[[^]]*\][^(].*', '', text, flags=re.MULTILINE)
    text = re.sub(r'^( {4,}[^-*]).*', '', text, flags=re.MULTILINE)
    text = re.sub(r'{#.*}', '', text)
    text = text.replace('\n', ' ')
    text = re.sub(r'!\[[^\]]*\]\([^)]*\)', '', text)
    text = re.sub(r'</?[^>]*>', '', text)
    text = re.sub(r'[#*`~\-–^=<>+|/:]', '', text)
    text = re.sub(r'\[[0-9]*\]', '', text)
    text = re.sub(r'[0-9#]*\.', '', text)
    return len(text.split())


def calculate_wordcount(file_list: List[str],
                        suppress_output: Optional[bool] = False) -> int:
    """
    Calculate the word count for a list of Markdown files.

    Accepts a list of file paths and displays the word count for each file,
    tallying up and returning the total at the end. If the `suppress_output`
    parameter is truthy, the individual file counts are not printed.
    """
    total_words = 0
    for file in file_list:
        with open(file, 'r', encoding='utf8') as file_handle:
            word_count = count_words_in_markdown(file_handle.read())
            if not suppress_output:
                print("%5.0d %s" % (word_count, file))
            total_words = total_words + word_count
    return total_words


def log_wordcount(file_name: str, total_words: int,
                  date_format: Optional[str] = "%Y-%m-%d") -> None:
    """
    Log the daily word count to the specified (CSV) file. If the `date_format`
    parameter is specified, it is passed directly to `strftime` to generate
    the time stamp.

    The log file is read into a `dict` and updated (so multiple calls to
    `log_wordcount` on the same day will update rather than creating
    duplicates.) As a result, the format string should match the format of the
    log file, or garbage data may result.
    """
    today: str = datetime.datetime.today().strftime(date_format)
    daily_totals: Dict[str, int] = {}

    with open(file_name, "r") as file_handle:
        for line in file_handle.readlines():
            the_date, the_count = line.strip().split(",", 2)
            daily_totals[the_date] = int(the_count)
    daily_totals[today] = total_words

    with open(file_name, "w") as file_handle:
        for key in sorted(daily_totals.keys()):
            file_handle.write(f"{key},{daily_totals[key]}\n")


def display_progress_bar(current_value: int,
                         goal_value: int,
                         bar_length: Optional[int] = 50,
                         bar_title: Optional[str] = "progress",
                         hash_symbol: Optional[str] = "#",
                         bar_title_color: Fore = Fore.MAGENTA,
                         bar_active_fore_color: Fore = Fore.WHITE,
                         bar_active_back_color: Back = Back.LIGHTMAGENTA_EX,
                         bar_inactive_fore_color: Fore = Fore.WHITE,
                         bar_inactive_back_color: Back = Back.MAGENTA,
                         bar_pctval_color: Fore = Fore.BLUE,
                         bar_background_color: Back = Back.BLACK) -> None:
    """Display a progress bar."""
    percent_to_goal: float = (current_value / goal_value) * 100
    num_hashes: int = int(percent_to_goal // (100 // bar_length))

    if (num_hashes > bar_length):
        num_hashes = bar_length

    result_str: str = ""
    result_str = result_str + bar_title_color + bar_title + Style.RESET_ALL + "  |"
    result_str = result_str + bar_active_fore_color + bar_active_back_color
    result_str = result_str + f"{hash_symbol * num_hashes}"
    result_str = result_str + bar_inactive_fore_color + bar_inactive_back_color
    result_str = result_str + f"{'-' * (bar_length - num_hashes)}"
    if percent_to_goal > 100:
        result_str = result_str + Style.RESET_ALL + "|+  "
    else:
        result_str = result_str + Style.RESET_ALL + "|   "
    result_str = result_str + bar_pctval_color + f"{percent_to_goal:5.2f}"
    result_str = result_str + Style.RESET_ALL + "%"

    print(result_str)


def last_logged_is_today(log_file: str) -> bool:
    last_date = None

    with open(log_file, "r") as log_data:
        lines = log_data.readlines()

    toks: List[any] = lines[-1].split(",")
    try:
        last_date = datetime.datetime.strptime(toks[0], "%Y-%m-%d")
    except ValueError:
        return False

    return last_date == datetime.datetime.today().date()


def show_progress(log_file: str, wordcount_goal: int,
                  calculated_words: Optional[int] = None,
                  raw_mode: Optional[bool] = False,
                  daily_goal: Optional[int] = None) -> None:
    """
    Display daily writing progress and progress to goal.

    If `calculated_words` is None, the previous two days' word counts will be
    read from the log file and used to generate the progress display. If it's
    a numeric value, the delta used will be the current count (provided in
    calculated_words) and the most recent value from the logfile.
    """

    current_count: int = 0
    previous_count: int = 0
    todays_progress: int = 0
    remaining_words: int = 0

    with open(log_file, "r") as file_handle:
        lines = file_handle.readlines()
        for line in lines:
            toks = line.strip().split(",", 2)
            previous_count = int(current_count)
            current_count = int(toks[1])

    # Calculation logic:
    #
    # If calculated_words is truthy, we counted words from the file(s), so:
    #     calculated_words = the counted words from today
    #     current_count = the last logged word count
    #     previous_count = the previous logged word count
    #     If calculated_words and current_count are equal, assume we've already
    #     logged today's progress, and:
    #         todays_progress is the delta between the last two logged values
    #     Otherwise:
    #         todays_progress is the delta between the file count and the most
    #         recent logged value
    # Otherwise:
    #     todays_progress is the delta between the last two logged values

    if calculated_words:
        todays_progress = calculated_words - current_count
        if todays_progress == 0 and last_logged_is_today(log_file):
            todays_progress = current_count - previous_count
            remaining_words = wordcount_goal - current_count
        else:
            remaining_words = wordcount_goal - calculated_words
            current_count = calculated_words
    else:
        if last_logged_is_today(log_file):
            todays_progress = current_count - previous_count
        else:
            todays_progress = 0
        remaining_words = wordcount_goal - current_count

    percent_to_goal: float = (current_count / wordcount_goal) * 100
    if remaining_words < 0:
        remaining_words = 0

    result_str: str = ""

    if raw_mode:
        result_str = f"total,{todays_progress},{current_count},{remaining_words}," + \
            f"{percent_to_goal:.2f}"
    else:
        result_str = Fore.MAGENTA + "total words:" + Style.RESET_ALL + \
            Fore.GREEN + f"{current_count:7,}" + Style.RESET_ALL + \
            Fore.MAGENTA + "  today:" + Style.RESET_ALL +  \
            Fore.GREEN + f"{todays_progress:7,}" + Style.RESET_ALL +  \
            Fore.MAGENTA + "  remaining:" + Style.RESET_ALL + \
            Fore.GREEN + f"{remaining_words:7,}" + Style.RESET_ALL
    print("")
    print(result_str)

    if daily_goal:
        percent_to_daily: float = (todays_progress / daily_goal) * 100
        remaining_today: int = daily_goal - todays_progress
        if remaining_today < 0:
            remaining_today = 0

        if raw_mode:
            result_str = f"daily,{todays_progress},{daily_goal}," + \
                f"{remaining_today}," + \
                f"{percent_to_daily:.2f}"
        else:
            result_str = Fore.MAGENTA + "daily goal :" + Style.RESET_ALL + \
                Fore.GREEN + f"{daily_goal:7,}" + Style.RESET_ALL + \
                Fore.MAGENTA + "  today:" + Style.RESET_ALL + \
                Fore.GREEN + f"{todays_progress:7,}" + Style.RESET_ALL + \
                Fore.MAGENTA + "  remaining:" + Style.RESET_ALL +  \
                Fore.GREEN + f"{remaining_today:7,}" + \
                Style.RESET_ALL
        print(result_str)

    if not raw_mode:
        print("")
        display_progress_bar(current_count, wordcount_goal,
                             50,
                             "total w/c progress",
                             hash_symbol="▚",
                             bar_title_color=Fore.CYAN,
                             bar_active_fore_color=Fore.LIGHTYELLOW_EX,
                             bar_active_back_color=Back.LIGHTCYAN_EX,
                             bar_inactive_back_color=Back.BLACK,
                             bar_inactive_fore_color=Fore.CYAN,
                             bar_pctval_color=Fore.CYAN)
        if daily_goal:
            display_progress_bar(todays_progress, daily_goal,
                                 50,
                                 "daily w/c progress",
                                 hash_symbol="▚",
                                 bar_title_color=Fore.YELLOW,
                                 bar_active_fore_color=Fore.WHITE,
                                 bar_active_back_color=Back.LIGHTYELLOW_EX,
                                 bar_inactive_back_color=Back.BLACK,
                                 bar_inactive_fore_color=Fore.YELLOW,
                                 bar_pctval_color=Fore.YELLOW)
        print("")


def usage_opt(flag_name: str, flag_desc: str,
              default_val: Optional[str] = None) -> None:
    """Print an option flag in the usage message."""
    result_str: str = ""
    result_str = "   " + Style.BRIGHT + \
        f"{flag_name:12}  " + \
        Style.NORMAL + \
        flag_desc

    if default_val:
        result_str = result_str + "(Default is " + \
            Fore.LIGHTMAGENTA_EX + \
            default_val + Fore.WHITE + ")"
    result_str = result_str + Style.RESET_ALL
    print(result_str)


def usage() -> None:
    """
    Display the app usage message.
    """
    print("Usage: wordcount.py",
          "[-l]",
          "[-f logfile]",
          "[-g goal]",
          "[-d goal]",
          "[-p]",
          "[-r]",
          "[-q]")
    print("       wordcount.py -h")
    print("")
    print("Options:")
    usage_opt("-l", "Log the daily word count total.")
    usage_opt("-f logfile", "Log file for the word count log.", "wordcount.csv")
    usage_opt("-g goal", "Specify the total word count goal.", "75,000")
    usage_opt("-g goal", "Specify the daily word count goal.", "1,500")
    usage_opt("-p", "Display the progress graph.")
    usage_opt("-r", "Display only raw progress numbers (implies -p)")
    usage_opt("-q", "Quiet mode - don't display word counts.")
    usage_opt("-h", "Print this help message and exit.")


def parse_args(opt_list: Dict[str, any],
               file_list: List[str]) -> Tuple[Dict[str, Any], List[str]]:
    """
    Parse the command line options and figure out our run options.

    Builds a dict with the default options, and then updates as necessary from
    the actual options list returned by `getopt.getopt`. Returns a list of the
    command-line options and the file list.
    """

    opt_dict: Dict[str, Any] = {
        'log_total': False,
        'log_file': 'wordcount.csv',
        'goal_words': 75000,
        'daily_words': 1500,
        'help': False,
        'progress_bar': False,
        'raw_mode': False,
        'quiet_mode': False
    }

    for opt_nm, opt_vl in opt_list:
        if opt_nm == "-l":
            opt_dict['log_total'] = True
        elif opt_nm == "-f":
            opt_dict['log_file'] = opt_vl
        elif opt_nm == "-g":
            opt_dict['goal_words'] = int(opt_vl)
        elif opt_nm == "-d":
            opt_dict['daily_words'] = int(opt_vl)
        elif opt_nm == "-h":
            opt_dict['help'] = True
        elif opt_nm == "-p":
            opt_dict['progress_bar'] = True
        elif opt_nm == "-r":
            opt_dict['raw_mode'] = True
            opt_dict['progress_bar'] = True
        elif opt_nm == "-q":
            opt_dict['quiet_mode'] = True
        else:
            assert False

    return opt_dict, file_list


def script_main() -> None:
    """
    The main entry point for the script.

    Parses the command line options and then does the business.
    """

    opts_dict: Dict[Any, Any] = {}
    file_list: List[str] = []
    opt_switches: Any = None
    file_args: Any = None

    try:
        opt_switches, file_args = getopt.getopt(sys.argv[1:], "lf:g:hpqr")
    except getopt.GetoptError as getopt_exc:
        print(getopt_exc)
        usage()
        sys.exit(2)

    opts_dict, file_list = parse_args(opt_switches, file_args)

    if opts_dict['help']:
        usage()
        sys.exit(0)

    total_words: int = calculate_wordcount(file_list, opts_dict['quiet_mode'])

    if len(file_list) > 0 and not opts_dict['quiet_mode']:
        print("%5.0d total" % (total_words))

    if opts_dict['progress_bar']:
        if total_words > 0:
            show_progress(opts_dict['log_file'],
                          opts_dict['goal_words'],
                          calculated_words=total_words,
                          raw_mode=opts_dict['raw_mode'],
                          daily_goal=opts_dict['daily_words'])
        else:
            show_progress(opts_dict['log_file'],
                          opts_dict['goal_words'],
                          raw_mode=opts_dict['raw_mode'],
                          daily_goal=opts_dict['daily_words'])

    if opts_dict['log_total']:
        log_wordcount(opts_dict['log_file'], total_words)


if __name__ == '__main__':
    script_main()
