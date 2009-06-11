use inc::Module::Install;

name     'BibTeX-Parser';
all_from 'lib/BibTeX/Parser.pm';
author   'Gerhard Gossen <gerhard.gossen@googlemail.com>';
license 'perl';

requires 'Text::Balanced';

build_requires 'Test::More';
build_requires 'IO::String';
build_requires 'IO::File';
build_requires 'File::Spec';

#auto_install;

Meta->write();
WriteAll;

