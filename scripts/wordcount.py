# -*- coding: utf-8 -*-
import os
import re
import sys
import getopt
from datetime import date


def count_words_in_markdown(markdown):
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


def usage():
    print("Usage: wordcount.py [-l] [-f logfile] [-g goal] [-p]")
    print("       wordcount.py -h")
    print("")
    print("Options:")
    print("   -l          Log the daily word count total to a log file")
    print("   -f logfile  Specify the log file. Default is wordcount.csv")
    print("   -g goal     Specify the total word count goal. Default is 75,000")
    print("   -p          Display the progress graph")
    print("   -q          Quiet mode - don't display word counts")
    print("   -h          Print this usage message and exit")


def log_wordcount(file_name, total_words):
    today = date.today().strftime("%Y-%m-%d")
    with open(file_name, "a") as f:
        f.write(f"{today},{total_words}\n")


def calculate_wordcount(filelist, suppress_output=False):
    total_words = 0
    for file in filelist:
        with open(file, 'r', encoding='utf8') as f:
            word_count = count_words_in_markdown(f.read())
            if not suppress_output:
                print("%5.0d %s" % (word_count, file))
            total_words = total_words + word_count
    return total_words


def show_progress(log_file, wordcount_goal, calculated_words=None):
    current_count = previous_count = 0

    with open(log_file, "r") as f:
        lines = f.readlines()
        for line in lines:
            toks = line.strip().split(",", 2)
            previous_count = int(current_count)
            current_count = int(toks[1])

    if calculated_words:
        todays_progress = calculated_words - current_count
        print(
            f"Computing progress based on calculated_words={calculated_words}, last count={current_count}")
    else:
        print(
            f"Computing progress based on logged total={current_count}, last count={previous_count}")
        todays_progress = current_count - previous_count
    remaining_words = wordcount_goal - current_count
    percent_to_goal = (current_count / wordcount_goal) * 100

    num_hashes = int(percent_to_goal / 2)
    hashbar_filled = "#" * num_hashes
    hashbar_empty = " " * (50 - num_hashes)

    print(
        f"today: {todays_progress}, total: {current_count}, remaining: {remaining_words}")
    print(
        f"progress: |{hashbar_filled}{hashbar_empty}| {percent_to_goal:.2f} %")


if __name__ == '__main__':

    total_words = 0
    goal_words = 75000
    log_total = False
    quiet_mode = False
    progress_bar = False
    log_file = "wordcount.csv"

    try:
        optlist, filelist = getopt.getopt(sys.argv[1:], "lf:g:hpq")
    except getopt.GetoptError as e:
        print(e)
        usage()
        sys.exit(2)

    for o, a in optlist:
        if (o == "-l"):
            log_total = True
        elif (o == "-f"):
            log_file = a
        elif (o == "-g"):
            goal_words = int(a)
        elif (o == "-h"):
            usage()
            sys.exit(0)
        elif (o == "-p"):
            progress_bar = True
        elif (o == "-q"):
            quiet_mode = True
        else:
            assert (False)
    total_words = calculate_wordcount(filelist, quiet_mode)

    if len(filelist) and not quiet_mode:
        print("%5.0d total" % (total_words))

    if progress_bar:
        if total_words > 0:
            show_progress(log_file, goal_words, total_words)
        else:
            show_progress(log_file, goal_words)

    if log_total:
        log_wordcount(log_file, total_words)
