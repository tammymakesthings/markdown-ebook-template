#!/home/tammy/perl/bin/perl

$book_title = "Cold Whispers";
$book_subtitle = "A Nikki Saylor Mystery";
$book_author = "Tammy Cravit";

$filename = $ARGV[0] || "book.tex";

open(INPUT, "${filename}") || die("Could not open input file: $!\n");
open(OUTPUT, ">${filename}.new") || die("Could not open output file: $!\n");

$linecount = 1;
$injected_mainmatter = 0;

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
            print OUTPUT "\\chapter*{$1}\\label{$2}}\n";
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
