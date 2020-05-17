# Markdown Book Template
Template for creating books (paperback and ebook) from Markdown files.

This project contains a template for creating a book (paperback and eBook)
from Markdown sources. It also supports the use of a "book journal",
something I use when I'm plotting out a book. I got this idea from an
article published in
[Writing Mysteries](https://www.amazon.com/Writing-Mysteries-Sue-Grafton/dp/1582971021/).
You can see a few examples of a book journal
[here](https://www.suegrafton.com/journal-notes.php)

## Installation

1. Make sure you have the prerequisites installed on your system. You need to
   install [Pandoc](https://pandoc.org), [TeX Live](https://www.tug.org/texlive/),
   and [Calibre](https://calibre-ebook.com).

2. Copy the files from this repository into your new project folder.

3. Edit the `Makefile`. At a minimum you need to change the `FILENAME` variable
   to a short version of your book's name.

4. Edit the ``metadata/pandoc_metadata.yaml`` and ``metadata/epub_metadata.yaml``
   files to reflect your book's metadata. You should also customize the metadata
   in ``tex/xelatex_hyperref.tex``.

## Usage example

The intended workflow for books created using this template is simple:

1. Add/edit content (chapter files, journal files, images, etc.)

2. Use the Makefile to compile the output files.

3. Wash, rinse, repeat. :smile:

More information is provided in the following sections.

### Using the Makefile

The Makefile defines the following targets for generating output files:

<dl>
<dt><strong>epub</strong></dt>
<dd>
Generates an EPUB version of the book. The <strong>.epub</strong>
file is also used as the base for generating the <strong>mobi</strong>
file.
</dd>
<dt><strong>mobi</strong></dt>
<dd>
Generates a Mobi (Kindle) version of the book.
</dd>
<dt><strong>pdf</strong></dt>
<dd>
Generates a PDF version of the book, in a format suitable for printing.
</dd>
<dt><strong>draftpdf</strong></dt>
<dd>
Generates a watermarked draft version of the manuscript on letter paper.
</dd>
<dt><strong>journal</strong></dt>
<dd>
Generates a PDF version of the book journal.
</dd>
</dl>

The following additional maintenance targets also are defined:

<dl>
<dt><strong>all</strong></dt>
<dd>Generates the mobi, epub, and pdf versions of the file.</dd>
<dt><strong>veryall</strong></dt>
<dd>Generates all of the output files.</dd>
<dt><strong>clean</strong></dt>
<dd>Cleans up all the output files.</dd>
<dt><strong>gitsnap</strong></dt>
<dd>Creates a git snapshot commit of the repository.</dd>
<dt><strong>help</strong></dt>
<dd>Displays a help message.</dd>
</dl>

A couple of additional Makefile targets exist for testing purposes. You're
welcome to use them, but they're undocumented on purpose.

### Adding Content

Any images you'd like to add to your book should go in the ``images/`` folder.

Your ebook cover (625 x 1000 pixels) should go in ``images/cover.jpg``.

Markdown files should be in the main directory. The Makefile picks up the
frontmatter (`fm_*.md`), mainmatter (`ch_*.md`), and endmatter (`em_*.md`)
files with wildcard expansion, so name your files accordingly.

The ebook CSS file is ``ebook.css``, which can be customized as desired.

### Customizing the PDF Generation

The following [XeLaTeX](https://en.wikipedia.org/wiki/XeTeX) files are used
during the PDF generation:

- ``tex/xelatex_bullets.tex`` - customizes list bullets
- ``tex/xelatex_chapterbreak.tex`` - forces chapters to start on a
right-hand page
- ``tex/xelatex_codeblocks.tex`` - Pygments formatting for code blocks
- ``tex/xelatex_hyperref.tex`` - Hyperref metadata
- ``tex/xelatex_papersize.tex`` - Sets the paper size for the print PDF.
ConTeXt
You can customize these, and add your own LaTeX files to perform additional
customization. Add a `--include-in-header` option for your new file(s) to the
appropriate Makefile variables (`PDF_OPTS`, `PDF_BASE_OPTS`, `PDF_DRAFT_OPTS`
or `PDF_JOURNAL_OPTS`).

## Release History

* 2020-05-17 - Converted from ConTeXt to XELaTeX engine
* 2020-05-15 - Initial Revision

## Meta

Tammy Cravit – [@Maker_Tammy](https://twitter.com/maker_tammy) – tammymakesthings@gmail.com

Distributed under the MIT license. See ``LICENSE.md`` for more information.

[https://github.com/tammymakesthings](https://github.com/tammymakesthings/)

## Contributing

1. Fork it (<https://github.com/tammymakesthings/markdown-ebook-template/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request
