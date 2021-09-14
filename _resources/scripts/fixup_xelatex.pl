#!/Users/tammy/perl5/bin/perl

$filename      = $ARGV[0] || "book.tex";
$mode          = $ARGV[1] || "final";
$book_title    = $ARGV[2] || "Book Title";
$book_subtitle = $ARGV[3] || "Series Title";
$book_author   = $ARGV[4] || "Tammy Cravit";

open(INPUT, "${filename}") || die("Could not open input file: $!\n");
open(OUTPUT, ">${filename}.new") || die("Could not open output file: $!\n");

$linecount = 1;
$injected_mainmatter = 0;
$book_title = "";

print("*** processing ${filename}\n");

while (<INPUT>)
{
    $line = $_;
    if ($line =~ m/^\\frontmatter/) {
        print "Found \\frontmatter line at line ${linecount} - adjusting frontmatter\n";
        print OUTPUT "\\frontmatter\n";
        #        print OUTPUT "\\pagestyle{empty}\n";
    }
    elsif ($line =~ m/^\\mainmatter/) {
        print "Found mainmatter start at line ${linecount} - removing it\n";
    }
    elsif ($line =~ m/\\chapter{(.*?)}\\label{(.*?)}}$/) {
        if ($injected_mainmatter == 0) {
            print "Got chapter [", $1, "] with label [", $2, "] in frontmatter\n";
            if (($1 eq "Copyright") || ($1 eq "Dedication")) {
                print OUTPUT "\\chapter{}\\label{$2}}\n";
            }
            else {
                print OUTPUT "\\chapter*{$1}\\label{$2}}\n";
            }
        }
        else {
            print OUTPUT $line;
        }
    }
    elsif ($line =~ m/^\\hypertarget{prologue}/) {
        if ($injected_mainmatter == 0) {
            print "Found start of prologue at line ${linecount} - injecting mainmatter\n";
            print OUTPUT "\\mainmatter\n";
            print OUTPUT "\\pagestyle{headings}\n";
            print OUTPUT "\n";
            $injected_mainmatter = 1;
        }
        print OUTPUT $line;
    }
    elsif ($line =~ m/^\\hypertarget{chapter-1}/) {
        if ($injected_mainmatter == 0) {
            print "Found start of chapter 1 at line ${linecount} - injecting mainmatter\n";
            print OUTPUT "\\mainmatter\n";
            print OUTPUT "\\pagestyle{headings}\n";
            print OUTPUT "\n";
            $injected_mainmatter = 1;
        }
        print OUTPUT $line;
    }
    elsif ($line =~ m/\\title{(.*)}/) {
        print "Found book title: $1\n";
        $book_title = $1;
    }
    elsif ($line =~ m/\\maketitle/) {
        print "Found maketitle line - injecting new cover page info\n";
        if ($mode eq "final") {
            print OUTPUT "\\begin{titlepage}\n";
            print OUTPUT "\\begin{center}\n";
            print OUTPUT "\\vfill\n";
            print OUTPUT "\\par\\noindent\\rule{0.9\\textwidth}{0.4pt} \\\\ \n";
            print OUTPUT "\\Huge{\\textbf{$book_title}} \\\\ \n";
            print OUTPUT "\\vspace{2\\baselineskip}\n";
            print OUTPUT "\\Large{\\textit{a nikki saylor mystery}} \\\\ \n";
            print OUTPUT "\\par\\noindent\\rule{0.9\\textwidth}{0.4pt} \\\\ \n";
            print OUTPUT "\\vspace{5\\baselineskip}\n";
            print OUTPUT "\\LARGE{\\textbf{Tammy Cravit}} \\\\ \n";
            print OUTPUT "\\vfill\n";
            print OUTPUT "\\fbox{\\textbf{TMT}} \\\\ \n";
            print OUTPUT "tammy\\textbf{makes}things\n";
            print OUTPUT "\\end{center}\n";
            print OUTPUT "\\end{titlepage}\n";
            print OUTPUT "\\cleardoublepage\n";
        }
        else
        {
            print OUTPUT "\\begin{titlepage}\n";
            print OUTPUT "\\begin{center}\n";
            print OUTPUT "\\vfill\n";
            print OUTPUT "\\par\\noindent\\rule{0.9\\textwidth}{0.4pt} \\\\ \n";
            print OUTPUT "\\Huge{\\textbf{$book_title}} \\\\ \n";
            print OUTPUT "\\vspace{2\\baselineskip}\n";
            print OUTPUT "\\Large{\\textit{a nikki saylor mystery}} \\\\ \n";
            print OUTPUT "\\vspace{2\\baselineskip}\n";
            print OUTPUT "\\Large{\\textbf{BETA READER DRAFT}} \\\\ \n";
            print OUTPUT "\\par\\noindent\\rule{0.9\\textwidth}{0.4pt} \\\\ \n";
            print OUTPUT "\\vspace{6\\baselineskip}\n";
            print OUTPUT "\\LARGE{\\textbf{Tammy Cravit}} \\\\ \n";
            print OUTPUT "\\vfill\n";
            print OUTPUT "\\vspace{2\\baselineskip}\n";
            print OUTPUT "\\large{\\textit{This is an advance draft for beta readers, ";
            print OUTPUT "generated at}} \\\\";
            print OUTPUT "\\vspace{0.8\\baselineskip}";
            print OUTPUT "\\large{\\textit{", scalar(localtime), "}} \\\\";
            print OUTPUT "\\vspace{0.8\\baselineskip}";
            print OUTPUT "\\large{\\textit{It does not necessarily reflect the final form or ";
            print OUTPUT "content of the book.}} \\\\\n";
            print OUTPUT "\\vspace{\\baselineskip}\n";
            print OUTPUT "\\large{\\textbf{PLEASE DO NOT REDISTRIBUTE OR SHARE}}\n";
            print OUTPUT "\\end{center}\n";
            print OUTPUT "\\end{titlepage}\n";
            print OUTPUT "\\cleardoublepage\n";
        }
    }
    else {
        print OUTPUT $line;
    }
    $linecount++;
}
print "Done. Scanned ${linecount} lines.\n";
close(OUTPUT);
close(INPUT);

unlink($filename);
rename("${filename}.new", $filename);
exit(0);
