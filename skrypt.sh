#!/bin/bash

if [[ $# -lt 2 ]]; then
echo "Sposob uruchomienia: $0 <archiwum> <katalog>";
exit 1;

elif [[ ! -d $HOME/$2 ]]; then
echo "Podany katalog $2 nie istnieje";
exit 2;

else

#tworzenie pliku do przechowywania zawartosci katalogu
touch $HOME/temp-pliki.txt
ls --format=single-column > $HOME/temp-pliki.txt;

#wyszukiwanie plikow z "a" w nazwie
grep -E ".*a.*\." $HOME/temp-pliki.txt > $HOME/temp-doarchiwum.txt;

#tworzenie katalogu tymczasowego
mkdir $1;

#kopiowanie plikow z uprawnieniami typu read do katalogu
while read line
do
if [ -r $HOME/$2/$line ]; then
cp $HOME/$2/$line $1;
fi
done < $HOME/temp-doarchiwum.txt

#tworzenie archiwum z wybranymi plikami
tar cf $1.tar $HOME/$2/$1  2>/dev/null
(( $? !=0 )) && { printf '%s\n' "Wystapil blad przy tworzeniu archiwum $1.tar";
exit 3;};

#usuwanie wszystkich tymczasowych plikow i katalogow
rm $HOME/temp-doarchiwum.txt;
rm $HOME/temp-pliki.txt;
rm -r $1;

gzip -9 $1.tar
gerror=$?
if [[ $gerror -ne 0 ]]; then
echo "Gzip zwrocil blad o kodzie:" $gerror;
exit $gerror;

fi
fi