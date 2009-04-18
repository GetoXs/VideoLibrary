program Filmy;
{$APPTYPE CONSOLE}
uses  crt,  SysUtils;
type
  data = record                                         // dane rekordu
    title : string[20];
    wytwornia : string[20];
    year : integer;
    gatunek : integer;
    case wyp : boolean of
      true : (imie : string[20];
              nazwisko : string[20];)
  end; 
  wsk_rekord = ^rekord;                                 // lista rekordów (glowna tablica)
  rekord = record
    dane : data;
    next : wsk_rekord;
  end;
  data_gatunek = record                                         // dane gatunkow
    nazwa : string[20];
    id : integer;
  end;
  wsk_gatunek = ^gatunek;                                 // lista gatunkowów
  gatunek = record
    dane : data_gatunek;
    next : wsk_gatunek;
  end;

var 
  glowa : wsk_rekord;                                   //glowa listy rekordow
  glowa_gat : wsk_gatunek;                               //glowa listy gatunkow
  key_main, key_wypisz:char;                            //klucze menu glownego i z wyswietlana baza
  od : integer;                                         //od ktorej pozycji ma byc wyswietlana baza
  sort : string;                                       //okresla rodzaj sortowania


procedure logo;                                         //logo firmy
begin
    writeln ('==========================================================================');
    writeln ('|                 Wypozyczalnia FILMOW GetoX Corp.                       |');
    writeln ('==========================================================================');
end;
procedure dodaj(var glowa : wsk_rekord; title, wytwornia, imie, nazwisko : string; year, gatunek : integer; wyp : boolean);    //dodaje na poczatek wpis do listy rekordow
var 
  nowy : wsk_rekord;
begin 
  new(nowy); 
  nowy^.dane.title := title;
  nowy^.dane.wytwornia := wytwornia;
  nowy^.dane.year := year;
  nowy^.dane.gatunek := gatunek;
  nowy^.dane.wyp := wyp;
  if wyp=true then                     //gdy film jest wypozyczony wpisuje dodatkowe dane
  begin
    nowy^.dane.imie:=imie;
    nowy^.dane.nazwisko:=nazwisko;
  end;
  nowy^.next := glowa;
  glowa := nowy;
end;
procedure dodaj_gat(var glowa : wsk_gatunek; nazwa: string; id : integer);                 //dodaje wpis na koniec do listy gatunkow
var 
  nowy : wsk_gatunek;
  pom : wsk_gatunek;
  max:integer;         //max id w liscie gatunkow
begin 
  new(nowy); 
  nowy^.dane.nazwa := nazwa;
  pom := glowa;
  if id=0 then                                            //gdy id = 0 wtedy szuka najwiekszy id z elementow listy i zastepuje id podanym przez uzytkownika
  begin
    max:=0;
    while pom<>nil do
    begin
      if pom^.dane.id>max then
        max:=pom^.dane.id;
      pom:=pom^.next;
    end;
    inc(max);
    id:=max;
  end;
  nowy^.dane.id := id;
  nowy^.next := nil;
  pom := glowa;
  if glowa = nil then
  begin
    glowa := nowy;
  end
  else
  begin
    while pom^.next <> nil do
      pom := pom^.next;
    pom^.next := nowy;
  end;
end;
function el_list(glowa : wsk_rekord):integer;                                  // zlicza liczbe elementow listy rekordów
begin
  el_list := 0;
  while glowa<>nil do
  begin
    glowa := glowa^.next;
    inc(el_list);
  end;
end;
{procedure wyp(glowa:wsk_rekord);                         //pomocnicze wypisywanie rekordow
begin
  while glowa <> nil do
  begin
    writeln(glowa^.dane.title);
    glowa:=glowa^.next
  end;
  writeln;
end;
procedure wyp_gat(glowa:wsk_gatunek);                         //pomocnicze wypisywanie gatunku
begin
  while glowa <> nil do
  begin
    writeln(glowa^.dane.nazwa);
    writeln(glowa^.dane.id);
    glowa:=glowa^.next
  end;
  writeln;
end; }
procedure sort_list(var glowa:wsk_rekord; met:string);         // sortuje liste wg. okreslonej metody
var
  i,j : integer;
  n : integer;          //dlugosc listy
  pom : wsk_rekord;     //wsk na nast
  temp : wsk_rekord;    //pierwszy el
begin
n := el_list(glowa);
temp:=glowa;
  if n>1 then                        //gdy jest wiecej niz 2 el
  begin
    for i := 1 to n-1 do
    begin                                         //w zaleznosci od metody sprawdza inne warunki aby przejsc dalej
      if (glowa^.dane.title>glowa^.next^.dane.title)AND(met='n0') OR (glowa^.dane.title<glowa^.next^.dane.title)AND(met='n1') OR (glowa^.dane.wytwornia>glowa^.next^.dane.wytwornia)AND(met='p0') OR (glowa^.dane.wytwornia<glowa^.next^.dane.wytwornia)AND(met='p1') OR (glowa^.dane.year>glowa^.next^.dane.year)AND(met='y0') OR (glowa^.dane.year<glowa^.next^.dane.year)AND(met='y1') then
      begin         //sprawdza 1szy i 2gi element listy
        pom :=  glowa^.next;
        glowa^.next := glowa^.next^.next;
        pom^.next := glowa;
        glowa := pom;
      end;
      j := 1;
      temp:=glowa;
      while (temp^.next^.next <> nil) AND (j <= n-i)  do
      begin                                          //w zaleznosci od metody zamienia 2 sasiadujace ze soba elementy
        if (temp^.next^.dane.title>temp^.next^.next^.dane.title)AND(met='n0') OR (temp^.next^.dane.title<temp^.next^.next^.dane.title)AND(met='n1') OR (temp^.next^.dane.wytwornia>temp^.next^.next^.dane.wytwornia)AND(met='p0') OR (temp^.next^.dane.wytwornia<temp^.next^.next^.dane.wytwornia)AND(met='p1') OR (temp^.next^.dane.year>temp^.next^.next^.dane.year)AND(met='y0') OR (temp^.next^.dane.year<temp^.next^.next^.dane.year)AND(met='y1')then
        begin            //zamiana
          pom :=  temp^.next^.next;
          temp^.next^.next := temp^.next^.next^.next;
          pom^.next := temp^.next;
          temp^.next := pom;
        end;
        temp:=temp^.next;
        inc(j);
      end;
    end;

  end;
end;
function menu_wypisz(var glowa : wsk_rekord; glowa_gat : wsk_gatunek; od : integer; sort:string):char;     //wypisuje tablice na monitor od miejsca wskazanego w 'od' do max 10 pol zwraca klawisz
var
  pom:wsk_rekord;
  pom_gat : wsk_gatunek;
  temp : integer;                      //przechowuje liczbe 'od'
begin
  temp := od;

  repeat
    clrscr;
    logo;
    writeln;
    pom := glowa;
    od:=temp;
    while od>1 do                                //przerzuca liste do konkretnego miejsca, gdzie zacznie sie wyswietlanie
    begin
      pom := pom^.next;
      dec(od);
    end;
    while (pom <> nil) AND (od<=10) do           //wyswietla liste do 10 max elementow
    begin
      write('Tytul: ', pom^.dane.title);
      gotoxy(28, 5+3*od-3);
      write(' Wytwornia: ', pom^.dane.wytwornia);
      gotoxy(58, 5+3*od-3);
      writeln('Rok wydania: ', pom^.dane.year);
      write('        ->  Gatunek: ');
      if pom^.dane.gatunek<>0 then
      begin
        pom_gat := glowa_gat;
        if pom_gat = nil then                               //Aby poszukac gatunek odpowiadajace danemu id przeszukuje liste gatunkow
          write('Bez gatunku')
        else
        begin
          while (pom_gat^.dane.id <> pom^.dane.gatunek) AND (pom_gat^.next <> nil) do
          begin
            pom_gat := pom_gat^.next;
          end;
          if pom_gat = nil then
            write('Bez gatunku')
          else
            write(pom_gat^.dane.nazwa);
        end;
      end
      else
        write('Bez gatunku');
      gotoxy(30, 6+3*od-3);
      if pom^.dane.wyp = true then                                    //w zaleznosci od wartosci 'wyp' podaje dane dot. osoby ktora wypozyczyla
        writeln('WYPOZYCZONE przez: ',pom^.dane.nazwisko,' ', pom^.dane.imie)
      else
        writeln;
      writeln;
      pom := pom^.next;
      inc(od);
    end;                                                      //zaczyna wyswietlanie menu
    writeln ('Menu:');
    gotoxy(30,6+3*od-3);
    if temp<>1 then
    begin
      gotoxy(21,6+3*od-3);
      write ('Poprzednie <-');
    end;
    if (pom<>nil) then
    begin
      gotoxy(35,6+3*od-3);
      write ('-> Nastepne');
    end;
    writeln;
    gotoxy(50, 7+3*od-3);
    writeln('Filmow na stronie: ', od-1);
    gotoxy(50, 8+3*od-3);
    write('Wyswietlanie od: ', temp);
    gotoxy(1, 8+3*od-3);
    writeln (' 1. Dodaj film');
    writeln (' 2. Aktualizuj film');
    write (' t. Sortuj po tytule ');
    if sort='n0' then writeln('(malejaco)')
    else writeln('(rosnaco)');
    write (' p. Sortuj po producencie ');
    if sort='p0' then writeln('(malejaco)')
    else writeln('(rosnaco)');
    write (' r. Sortuj po roku wydania ');
    if sort='y0' then writeln('(malejaco)')
    else writeln('(rosnaco)');
    writeln (' 0. Wstecz');
    menu_wypisz := ReadKey;
    if  menu_wypisz = chr(0)  then
    begin                                             //wyczytuje klawisz
      menu_wypisz := ReadKey;
    end;
    if ((temp=1) AND (menu_wypisz='K')) OR ((menu_wypisz='M') AND (pom=nil)) then      //jesli nie ma wiecej niz 10 elementow nie pozwala przejsc do nastepnych elementow (ew. poprzednich)
      menu_wypisz:='X';
  until (menu_wypisz='1') OR (menu_wypisz='2') OR (menu_wypisz='0') OR (menu_wypisz='K') OR (menu_wypisz='M') OR (menu_wypisz='t') OR (menu_wypisz='p') OR (menu_wypisz='r');
end; 
procedure zapisz(nazwa : string; glowa : wsk_rekord);                         //zapisuje liste rekordow do pliku
var
  plik : file of data;
begin 
  assign(plik, nazwa); 
  rewrite(plik); 
  while glowa <> nil do 
  begin 
    write(plik, glowa^.dane); 
    glowa := glowa^.next;
  end; 
  close(plik);
end; 
procedure zapisz_gat(glowa : wsk_gatunek);                         //zapisuje liste gatunkow do pliku
var
  plik : file of data_gatunek;
begin 
  assign(plik, 'gatunki.txt');
  rewrite(plik); 
  while glowa <> nil do 
  begin 
    write(plik, glowa^.dane); 
    glowa := glowa^.next;
  end; 
  close(plik);
end;
procedure wczytaj(nazwa : string; var glowa : wsk_rekord);                    //wyczytuje tablice z pliku do listy
var 
  plik : file of data;
  pom : data;
begin
{$I-}
  assign(plik, nazwa);
  reset(plik);
  if IOresult<>0 then
    rewrite(plik);                                  //tworzy pusty plik gdy on sam nie istnieje
  while not eof(plik) do 
  begin
    read(plik, pom);
    dodaj(glowa, pom.title, pom.wytwornia, pom.imie, pom.nazwisko, pom.year, pom.gatunek, pom.wyp);     //przekazuje dane z pliku do listy
  end;
  close(plik);
{$I+}
end; 
procedure wczytaj_gat(var glowa_gat : wsk_gatunek);                    //wyczytuje gatunki z pliku do listy
var 
  plik : file of data_gatunek;
  pom : data_gatunek;
begin
{$I-}
  assign(plik, 'gatunki.txt');
  reset(plik);
  if IOresult<>0 then
    rewrite(plik);                                  //tworzy pusty plik gdy on sam nie istnieje
  while not eof(plik) do 
  begin
    read(plik, pom); 
    dodaj_gat(glowa_gat, pom.nazwa, pom.id);     //przekazuje dane z pliku do listy
  end;
  close(plik);
{$I+}
end;
procedure usun(var glowa : wsk_rekord; var glowa_gat : wsk_gatunek);           //zwalnia listy z pamieci
var 
  pom : wsk_rekord; 
  pom_gat : wsk_gatunek;
begin 
  while glowa <> nil do 
  begin 
    pom := glowa; 
    glowa := glowa^.next;
    dispose(pom); 
  end;
  while glowa_gat <> nil do
  begin 
    pom_gat := glowa_gat;
    glowa_gat := pom_gat^.next;
    dispose(pom_gat);
  end;   
end; 

function menu_main:char;                                        //wyswietla menu glowne
begin
  repeat
    clrscr;
    logo;
    writeln ('Menu:');
    writeln ('1. Wyswietl baze filmow');
    writeln ('2. Dodaj film');
    writeln ('3. Usun film');
    writeln ('4. Szukaj filmu');
    writeln ('5. Statystyki');
    writeln ('6. Eksportuj baze do podanego pliku');
    writeln ('7. Zarzadzanie gatunkami');
    writeln ('0. Wyjscie i zapis zmian');
    menu_main := ReadKey;
  until (menu_main >= '0') AND (menu_main <= '7');
end;

function check_string (text : string):boolean;                //sprawdza czy w podanej przez argument frazie sa litery cyfty i podstawowe znaki
var
  i:integer;
begin
  i := 1;
  check_string := true;
  while ((check_string = true) AND (i <= 20)) AND (i <= length(text)) do       //przechodzi po kolejnym znaku
  begin
    if ((ord(text[i])>=46) AND (ord(text[i])<=57)) OR ((ord(text[i])>=97) AND (ord(text[i])<=122)) OR ((ord(text[i])>=63) AND (ord(text[i])<=90)) OR ((ord(text[i])>=32) AND (ord(text[i])<=41)) then
      check_string := true
    else
      check_string := false;
    inc(i);
  end;
end;

procedure seek(glowa:wsk_rekord; glowa_gat:wsk_gatunek);         //uruchamia modul wyszukiwania
var
  pom:wsk_rekord;
  pom_gat:wsk_gatunek;
  i,j:integer;
  check,ok:boolean;     //ok, odpowiedzialne za to czy slowa do siebie pasuja  check, za poprawne znaki
  title_part:string;
  tab:array[0..100] of data;
begin
  repeat
    writeln('Wpisz poczatkowa czesc nazwy filmu ktorego szukasz');
    readln(title_part);
    check := check_string(title_part);                                         //sprawdzanie wyrazenia
    if (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 2) then
    begin
      pom:=glowa;
      j:=0;
      while pom<>nil do
      begin
        for i:=1 to length(title_part) do
          if (title_part[i]<>pom^.dane.title[i]) AND (chr(ord(title_part[i])-32)<>pom^.dane.title[i])  then    //Wyszukiwanie tytulow zaczynajacych sie od podanej frazy po kolei po znaku
          begin
            ok:=false;
            break;
          end
          else ok:=true;
        if ok=true then
        begin
          tab[j]:=pom^.dane;
          inc(j);
        end;
      pom:=pom^.next;
      end;
    end
    else
    begin
      if check = false then writeln ('Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
      if (length(title_part) > 20) AND (length(title_part) < 2) then writeln('Fraza musi zawierac przynamniej 2 i conajwyzej 20 znakow');
    end;
    if (j >99) OR (j=0)  then writeln('Wynikow jest wiecej niz 100 lub nie ma zadnego, uscislij poszukiwania');
  until (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 2) AND (j <= 100) AND (j>0);
  if (j<>1) then            // gdy znalezionych tytulow jest wiecej niz 1
  begin
    clrscr;
    logo;
    writeln('Znaleziono ',j+1,' tytulow:');
    for i:=0 to j-1 do
    begin                                              //wyswietla znalezione filmy
      write('   Tytul: ', tab[i].title);
      write('         Producent: ', tab[i].wytwornia);
      writeln('    Rok wydania: ', tab[i].year);
      write('    Gatunek: ');
      if tab[i].gatunek<>0 then
      begin
        pom_gat := glowa_gat;
        if pom_gat = nil then                      // Wyswietlanie gatunku danego filmu
          write('Bez gatunku')
        else
        begin
          while (pom_gat^.dane.id <> tab[i].gatunek) AND (pom_gat^.next <> nil) do
          begin
            pom_gat := pom_gat^.next;
          end;
          if pom_gat = nil then
            write('Bez gatunku')
          else
            write(pom_gat^.dane.nazwa);
        end;
      end
      else
        write('Bez gatunku');
      write('     Stan w magazynie: ');
      if tab[i].wyp=true then                        //w zaleznosci od wartosci 'wyp' wypisuje informacje o osobie wypozyczajacej film
        writeln('Wypozyczone, przez: ',tab[i].nazwisko,' ',tab[i].imie)
      else writeln('Niewypozyczone');
      writeln;
    end;
  end
  else
  begin                            //gdy znaleziono jeden tytul
    clrscr;
    logo;
    writeln('Znaleziono jeden tytul:');
    write('Tytul: ', tab[0].title);
    write('       Producent: ', tab[0].wytwornia);
    writeln('     Rok wydania: ', tab[0].year);
    if tab[i].gatunek<>0 then
    begin
      pom_gat := glowa_gat;
      if pom_gat = nil then                                           // Wyswietlanie gatunku danego filmu
        write('Bez gatunku')
      else
      begin
        while (pom_gat^.dane.id <> tab[i].gatunek) AND (pom_gat^.next <> nil) do
        begin
          pom_gat := pom_gat^.next;
        end;
        if pom_gat = nil then
          write('Bez gatunku')
        else
          write(pom_gat^.dane.nazwa);
      end;
    end
    else
      write('Bez gatunku');
    write('     Stan w magazynie: ');
    if tab[0].wyp=true then                           //w zaleznosci od wartosci 'wyp' wypisuje informacje o osobie wypozyczajacej film
      writeln('Wypozyczone, przez: ',tab[0].nazwisko,' ',tab[0].imie)
    else writeln('Niewypozyczone');
  end;
    writeln('Aby przejsc dalej kliknij [enter]');
    readln;


end;

procedure pob_wyp(glowa:wsk_rekord; var imie,nazwisko:string);        // pobiera imie i nazwisko do danych nt. osoby ktora wypozycza film
var
  pom:wsk_rekord;
  i,j:integer;
  key:char;                      //key przechowuje klawisz klikniety przez usera
  check,ok:boolean;              //ok, odpowiedzialne za to czy slowa do siebie pasuja  check, za poprawne znaki
  title_part:string;             //przetrzymuje wpisywane przez usera dane
  tab:array[0..100] of data;     //tab przechowujaca znalezione rekordy
begin
  writeln('| Skad pobrac dane dot. osoby wypozyczajacej: ');
  writeln('| 1. Ta osoba juz istnieje, poszukaj w istniejacych');
  writeln('| 2. Dodaj nowa osobe');
  writeln('| 0. Ustaw na niewypozyczona');
  repeat
    key:=readkey;
  until (key>='0') AND (key<='2');
  if key='1'then
  begin
    repeat
      writeln('Wpisz poczatkowa czesc nazwiska ktorego szukasz');
      readln(title_part);                
      check := check_string(title_part);                                         //sprawdzanie wyrazenia
      if (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 2) then
      begin
        pom:=glowa;
        j:=0;
        while pom<>nil do
        begin
          if (pom^.dane.wyp = true) then                               //przechodzi przez liste sprawdzajac filmy ktore s¹ wypozyczone
          begin
            i:=0;
            while (i<=j) AND NOT ((tab[i].nazwisko=pom^.dane.nazwisko) AND (tab[i].imie=pom^.dane.imie)) do   //porownuje aktualny rekord o osobie w liscie do rekordow zapisanych w tablicy i przepuszcza tylko te niepowtarzajace sie
              inc(i);
            if NOT ((tab[i].nazwisko=pom^.dane.nazwisko) AND (tab[i].imie=pom^.dane.imie)) then
            begin
              for i:=1 to length(title_part) do
                if (title_part[i]<>pom^.dane.nazwisko[i]) AND (chr(ord(title_part[i])-32)<>pom^.dane.nazwisko[i])  then    //Wyszukiwanie tytulow zaczynajacych sie od podanej frazy
                begin
                  ok:=false;        //ok, odpowiedzialne za to czy slowa do siebie pasuja
                  break;
                end
                else ok:=true;
              if ok=true then
              begin
                tab[j]:=pom^.dane;
                inc(j);
              end;
            end;
          end;
        pom:=pom^.next;
        end;
      end
      else
      begin
        if check = false then writeln ('Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
        if (length(title_part) > 20) AND (length(title_part) < 2) then writeln('Fraza musi zawierac przynamniej 2 i conajwyzej 20 znakow');
      end;
      if (j >99) OR (j=0)  then writeln('Wynikow jest wiecej niz 100 lub nie ma zadnego, uscislij poszukiwania');
    until (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 2) AND (j <= 100) AND (j>0);

    if (j<>1) then                     // gdy rekordow jest wiecej niz 1
    begin
      repeat
        clrscr;
        logo;
        writeln('ID');
        for i:=0 to j-1 do                                 //wyswietla znalezione osoby
        begin
          write(' ->',i,'<- ');
          write('   Imie: ', tab[i].imie);
          writeln('         Nazwisko: ', tab[i].nazwisko);
        end;
        writeln('Znaleziono kilka tytulow, prosze wpisac odpowiedni');
        read(title_part);
        readln;
        val(title_part,i);
        if (i < 0) OR (i > j-1) then
        begin
          writeln('Wpisz liczbe z zakresu od 0 do ',j-1,' [enter]');
          readln;
        end;
      until (i >= 0) AND (i <= j-1);            //sprawdza czy wpisana liczba pasuje do wyswietlanego zakresu
      imie:=tab[i].imie;
      nazwisko:=tab[i].nazwisko;
    end
    else
    begin
      clrscr;                             //wyswietla gdy jest tylko jeden tytul
      logo;
      writeln('Znaleziono jeden tytul:');
      write('   Imie: ', tab[0].imie);
      writeln('         Nazwisko: ', tab[0].nazwisko);
      imie:=tab[0].imie;
      nazwisko:=tab[0].nazwisko;
    end;
  end
  else if key='2' then                           //dodaje osobe
  begin
    repeat                                                                       //dodawanie imienia
      write('|Podaj imie osoby wypozyczajacej: ');
      read (imie);
      readln;
      check := check_string(imie);                                         //sprawdzanie wyrazenia
      if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
      if (length(imie) > 20) OR (length(imie) < 3) then writeln ('| -> Imie musi zawierac co najmniej 2 znaki, maksymalnie 20');
    until (check = true) AND (length(imie) <= 20) AND (length(imie) >= 2);
    repeat                                                                       //dodawanie nazwiska
      write('|Podaj nazwisko osoby wypozyczajacej: ');
      read (nazwisko);
      readln;
      check := check_string(nazwisko);                                         //sprawdzanie wyrazenia
      if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
      if (length(nazwisko) > 20) OR (length(nazwisko) < 3) then writeln ('| -> Nazwisko musi zawierac co najmniej 2 znaki, maksymalnie 20');
    until (check = true) AND (length(nazwisko) <= 20) AND (length(nazwisko) >= 2);
  end;
  if key='0' then                                          //przekazuje puste lancuchy, co oznacza ze user zrezygnowal z wypozyczenia
  begin
    imie:='0';
    nazwisko:='0';
  end
  else
  begin
    imie[1]:=upcase(imie[1]);                              //ustawia 1 znak na duzy
    nazwisko[1]:=upcase(nazwisko[1]);
  end;
end;

procedure menu_dodaj(var glowa: wsk_rekord; glowa_gat : wsk_gatunek);                       //formularz dodawania rekordow
var
  title,imie,nazwisko : string; //Tymczasowe
  wytwornia : string;   //jw
  year : integer;       //jw
  i,j : integer;
  gatunek : integer;    //jw
  wyp:boolean;          //jw
  check : boolean;      //przechowuje wynik funkcji
  key:char;             //przechowuje klawisz
  pom : data;           //pomocnicza rekordu
  pom_gat : wsk_gatunek;//pomocnicza gatunku
begin
  writeln;
  writeln('-------------------------------------------------------------------------------');
  repeat
    write('|Podaj Tytul filmu: ');                                             //dodawanie tytulu
    read (title);
    readln;
    check := check_string(title);                                             //sprawdzanie wyrazenia
    if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
    if (length(title) > 20) OR (length(title) < 3) then writeln ('| -> Tytul musi zawierac co najmniej 2 znaki, maksymalnie 20');
  until (check = true) AND (length(title) <= 20) AND (length(title) >= 2);
  repeat                                                                       //dodawanie wytwornii
    write('|Podaj producenta, wytwornie filmu: ');
    read (wytwornia);
    readln;
    check := check_string(wytwornia);                                         //sprawdzanie wyrazenia
    if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
    if (length(wytwornia) > 20) OR (length(wytwornia) < 3) then writeln ('| -> Wytwornia musi zawierac co najmniej 2 znaki, maksymalnie 20');
  until (check = true) AND (length(wytwornia) <= 20) AND (length(wytwornia) >= 2);
  {$I-}
  repeat                                                                      //dodawanie roku
    write('|Podaj rok wydania filmu: ');
    read (year);
    readln;
    if IOresult<>0 then
      writeln ('| -> Bledne dane, wprowadz ponownie liczbe')
    else if (year < 1899) OR (year > 2099) then                              //sprawdzanie roku od 1899 do 2099
      writeln ('| -> Rok musi zawierac sie z przedzialu od 1899 do 2099');
  until (IOresult=0) AND (year >= 1899) AND (year <= 2099);
  {$I+}
  writeln('|---->Lista gatunkow do wyboru:');
  i := 1;
  pom_gat:=glowa_gat;                                          //Wyswietla dostepne gatunki
  while pom_gat <> nil do
  begin
    writeln('|== ', chr(i+96) ,' ', pom_gat^.dane.nazwa);
    inc(i);
    pom_gat:=pom_gat^.next;
  end;
  if i=1 then
  begin
    writeln('Nie ma zadnych gatunkow, ustalony zostanie gatunek: Bez Gatunku [enter]');
    gatunek := 0;
    readln;
  end
  else
  begin
    writeln('|Wybierz numer gatunku z listy powyzej dla tego filmu');
    repeat
      key := readkey;
    until (key > chr(96)) AND (key < chr(i+96));         //sprawdza czy klikniety klawisz pasuje do wyswietlanego zakresu znakow
    pom_gat:=glowa_gat;
    for j:=1 to ord(key)-97 do
      pom_gat:=pom_gat^.next;
    gatunek := pom_gat^.dane.id;
  end;
  writeln('Czy film zostal wypozyczony? [t/n]');        //dodaje informacje o wypozyczeniu
  repeat
    key := readkey;
  until (key = 't') OR (key = 'n');
  if key = 't' then
  begin
    clrscr;
    logo;
    pob_wyp(glowa,imie,nazwisko);                        //pobiera informacje nt. osoby
    if (imie='0') AND (nazwisko='0') then                //gdy zwrocone 0 znaczy ze user sie rozmyslil
      wyp:=false
    else
    begin
      wyp:=true;
    end;
  end
  else wyp := false;
  title[1] := upcase(title[1]);                            //ustawia 1 znak na duzy
  wytwornia[1] := upcase(wytwornia[1]);

  pom.title := title;                                       // wypisywanie tymczasowych danych do rekordu pomocniczego
  pom.wytwornia := wytwornia;
  pom.year := year;
  pom.gatunek := gatunek;
  pom.wyp := wyp;
  if wyp=true then
  begin
    pom.imie:=imie;
    pom.nazwisko:=nazwisko;
  end;

  writeln('-------------------------------------------------------------------------------');
  writeln('|PODSUMOWANIE:');
  with pom do
  begin
    writeln('|=Tytul:        ', title);
    writeln('|=Wytwornia:    ', wytwornia);
    writeln('|=Rok wydania:  ', year);
    write('|=Gatunek:      ');
    if i<>1 then writeln(pom_gat^.dane.nazwa)
    else writeln('Bez Gatunku');
    write('|=Wypozyczone:  ');
    if wyp=true then
      writeln('Tak, przez: ',nazwisko,' ',imie)
    else
      writeln('Nie');
  end;
  writeln('-------------------------------------------------------------------------------');
  writeln('|Czy chcesz dodac film do bazy? [t/n]');                              //potwierdzenie
  repeat
    key := readkey;
  until (key = 't') OR (key = 'n');
  if key = 't' then
  begin
    dodaj(glowa, pom.title, pom.wytwornia, pom.imie, pom.nazwisko, pom.year, pom.gatunek, pom.wyp);             // dodawanie do listy rekordow
    write('|Rekord zostal pomyslnie dodany! [enter]');
    readln;
  end;
end;
procedure menu_update(var glowa: wsk_rekord; glowa_gat:wsk_gatunek);       //Aktualizacja wyszukanego przez usera rekordu
var
  i,j:integer;                //j liczba wynikow
  title_part:string;          //przechowuje stringi wprowadzone przez usera
  pom:wsk_rekord;
  tab:array [0..100] of wsk_rekord;  //tablica do znalezionych rekordow
  ok,check:boolean;    //pomocnicze walidatory
  key:char;            //wprowadzany klawisz
  title,wytwornia,imie,nazwisko:string;     //tymczasowe dane wejsciowe
  year:integer;       //jw.
  wyp : boolean;              //jw.
  pom_gat : wsk_gatunek;
begin
  repeat
    writeln('Wpisz poczatkowa czesc tytulu filmu, ktorego chcesz zaktualizoweac');
    readln(title_part);
    check := check_string(title_part);                                         //sprawdzanie wyrazenia

    if (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 1) then
    begin
      pom:=glowa;
      j:=0;
      while pom<>nil do
      begin
        for i:=1 to length(title_part) do
          if (title_part[i]<>pom^.dane.title[i]) AND (chr(ord(title_part[i])-32)<>pom^.dane.title[i])  then    //Wyszukiwanie tytulow zaczynajacych sie od podanej frazy
          begin
            ok:=false;
            break;
          end
          else ok:=true;
        if ok=true then
        begin
          tab[j]:=pom;
          inc(j);
        end;
      pom:=pom^.next;
      end;
      if (j<=99) AND (j>=1) then                    //gdy tytulow jest mniej niz 100 i wiecej niz 0
      begin
        if (j<>1) then                              //gdy jest wiecej niz 1
        begin
          repeat
            clrscr;
            logo;
            writeln('ID');
            for i:=0 to j-1 do
            begin
              write(' ->',i,'<- ');
              write('   Tytul: ', tab[i]^.dane.title);
              write('         Producent: ', tab[i]^.dane.wytwornia);
              writeln('    Rok wydania: ', tab[i]^.dane.year);
              write('               Stan w magazynie: ');
              if tab[i]^.dane.wyp=true then
              writeln('Wypozyczone, przez: ',tab[i]^.dane.nazwisko,' ',tab[i]^.dane.imie)
              else writeln('Niewypozyczone');
              writeln;
            end;
            writeln('Znaleziono kilka tytulow, prosze wpisac odpowiedni');
            read(title_part);
            readln;
            val(title_part,i);
            if (i < 0) OR (i > j-1) then
            begin
              writeln('Wpisz liczbe z zakresu od 0 do ',j-1,' [enter]');
              readln;
            end;
          until (i >= 0) AND (i <= j-1);
          tab[0]:=tab[i];                      //zastepuje 0 element tablicy wybranym przez usera, w pozniejszym etapie ulatwia to prace
        end
        else                                   //gdy jest 1 element
        begin
          clrscr;
          logo;
          writeln('Znaleziono jeden tytul:');
          write('Tytul: ', tab[0]^.dane.title);
          write('       Producent: ', tab[0]^.dane.wytwornia);
          writeln('     Rok wydania: ', tab[0]^.dane.year);
          write('Stan w magazynie: ');
          if tab[0]^.dane.wyp=true then
          writeln('Wypozyczone, przez: ',tab[0]^.dane.nazwisko,' ',tab[0]^.dane.imie)
          else writeln('Niewypozyczone');
        end;

        writeln('Wybierz co chcesz zmienic:');    //lista zmian do wyboru
        writeln('1. Tytul');
        writeln('2. Wytwornia');
        writeln('3. Rok produkcji');
        writeln('4. Gatunek');
        writeln('5. Stan w magazynie');
        writeln('0. Nic');
        repeat
          key:=readkey;
        until (ord(key) >= 48) AND (ord(key) <= 53);
        if key = '1' then
        begin
          repeat
            write('Podaj Tytul filmu: ');                                             //aktualizowanie tytulu
            readln(title);
            check := check_string(title);                                             //sprawdzanie wyrazenia
            if check = false then writeln ('Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
            if (length(title) > 20) OR (length(title) < 3) then writeln ('Tytul musi zawierac co najmniej 2 znaki, maksymalnie 20');
          until (check = true) AND (length(title) <= 20) AND (length(title) >= 2);
          tab[0]^.dane.title := title;
          tab[0]^.dane.title[1] := upcase(title[1]);
        end;
        if key = '2' then
        begin
          repeat                                                                       //aktualizowanie producenta
            write('Podaj producenta (wytwornie) filmu: ');
            readln (wytwornia);
            check := check_string(wytwornia);                                         //sprawdzanie wyrazenia
            if check = false then writeln ('Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
            if (length(wytwornia) > 20) OR (length(wytwornia) < 3) then writeln ('Wytwornia musi zawierac co najmniej 2 znaki, maksymalnie 20');
          until (check = true) AND (length(wytwornia) <= 20) AND (length(wytwornia) >= 2);
          tab[0]^.dane.wytwornia:=wytwornia;
          tab[0]^.dane.wytwornia[1] := upcase(wytwornia[1]);
        end;
{$I-}
        if key = '3' then
        begin
          repeat                                                                      //aktualizowanie roku
            write('Podaj rok wydania filmu: ');
            readln(year);
            if IOresult<>0 then
              writeln ('| -> Bledne dane, wprowadz ponownie liczbe')
            else if (year < 1899) OR (year > 2099) then                              //sprawdzanie roku od 1899 do 2099
            writeln ('| -> Rok musi zawierac sie z przedzialu od 1899 do 2099');
          until (IOresult=0) AND (year >= 1899) AND (year <= 2099);
          tab[0]^.dane.year:=year;
        end;
{$I+}
        if key = '4' then                                                     //aktualizowanie gatunku
        begin
          i := 1;
          pom_gat:=glowa_gat;
          while pom_gat <> nil do                                     //wyswietlanie gatunkow
          begin
            writeln(' ', chr(i+96) ,' ', pom_gat^.dane.nazwa);
            inc(i);
            pom_gat:=pom_gat^.next;
          end;
          if i=1 then
          begin
            writeln('Nie ma zadnych gatunkow, ustalony zostanie gatunek: Bez Gatunku [enter]');
            tab[0]^.dane.gatunek := 0;
            readln;
          end
          else
          begin
            writeln('Wybierz numer gatunku z listy powyzej dla tego filmu');
            repeat
              key := readkey;
            until (key > chr(96)) AND (key < chr(i+96));       //sprawdza klikniety klawisz czy pasuje wyswietlonego zakresu
            pom_gat:=glowa_gat;
            for j:=1 to ord(key)-97 do
              pom_gat:=pom_gat^.next;
            tab[0]^.dane.gatunek := pom_gat^.dane.id;
          end;
        end;

        if key = '5' then                                     //aktualizuje informacje nt. wypozyczenia
        begin
          writeln('Czy film zostal wypozyczony? [t/n]');
          repeat
            key := readkey;
          until (key = 't') OR (key = 'n');
          if key = 't' then
          begin
            clrscr;
            logo;
            pob_wyp(glowa,imie,nazwisko);                    //pobiera info nt. osoby wypozyczajacej
            if (imie='0') AND (nazwisko='0') then            //gdy zwrocone 0 znaczy ze user sie rozmyslil
              wyp:=false
            else
            begin
              wyp:=true;
            end;
          end
          else wyp := false;
          tab[0]^.dane.wyp:=wyp;
          if wyp=true then
          begin
            tab[0]^.dane.imie:=imie;
            tab[0]^.dane.nazwisko:=nazwisko;
          end;
          key:='5';
        end;


        writeln('-------------------------------------------------------------------------------');
        writeln('|PODSUMOWANIE:');
        writeln('|=Tytul:        ', tab[0]^.dane.title);
        writeln('|=Wytwornia:    ', tab[0]^.dane.wytwornia);
        writeln('|=Rok wydania:  ', tab[0]^.dane.year);
        if key='4' then
        begin
          write('|=Gatunek:      ');
          if i<>1 then writeln(pom_gat^.dane.nazwa)
          else writeln('Bez Gatunku');
        end;
        write('|=Wypozyczone:  ');
        if tab[0]^.dane.wyp=true then
          writeln('Tak, przez: ',tab[0]^.dane.nazwisko,' ',tab[0]^.dane.imie)
        else
          writeln('Nie');
        writeln('-------------------------------------------------------------------------------');
        writeln('|Czy chcesz dokonac ponownej aktualizaji? [t/n]');                              //potwierdzenie
        repeat
          key := readkey;
        until (key = 't') OR (key = 'n');
        clrscr;
      end
      else
        writeln('Wynikow jest wiecej niz 100 lub nie ma zadnego, uscislij poszukiwania');
    end
    else
      if check = false then writeln ('Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
      if (length(title_part) > 20) AND (length(title_part) < 1) then writeln('Fraza musi zawierac przynamniej 1 i conajwyzej 20 znakow');
  until (key = 'n')  AND (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 1);
end;

procedure menu_usun(var glowa:wsk_rekord);
var
  title_part:string;             //wpisywane stringi
  pom,del:wsk_rekord;            //pomocniczy wsk, oraz wskaznik do skasowania
  i,j:integer;
  check,ok:boolean;              //ok, odpowiedzialne za to czy slowa do siebie pasuja  check, za poprawne znaki
  tab:array [0..100] of wsk_rekord;       //tab przechowujaca znalezione rekordy
  key:char;                       //przechowuje wcisniety klawisz
begin
  repeat
    writeln('Wpisz poczatkowa czesc tytulu filmu, ktory chcesz usunac');
    read(title_part);
    readln;
    check := check_string(title_part);                                         //sprawdzanie wyrazenia

    if (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 1) then
    begin
      pom:=glowa;
      j:=0;
      while pom<>nil do
      begin
        for i:=1 to length(title_part) do                                        //porownywanie znakow po kolei w wpisanej frazie
          if (title_part[i]<>pom^.dane.title[i]) AND (chr(ord(title_part[i])-32)<>pom^.dane.title[i])  then    //Wyszukiwanie tytulow zaczynajacych sie od podanej frazy
          begin
            ok:=false;
            break;
          end
          else ok:=true;
        if ok=true then
        begin
          tab[j]:=pom;
          inc(j);
        end;
      pom:=pom^.next;
      end;
      if (j<=99) AND (j>=1) then                     // gdy tytulow jest mniej niz 100 i wiecej niz 0
      begin
        if (j<>1) then
        begin
          repeat
            clrscr;
            logo;
            writeln('ID');
            for i:=0 to j-1 do
            begin
              write(' ->',i,'<- ');
              write('   Tytul: ', tab[i]^.dane.title);
              write('         Producent: ', tab[i]^.dane.wytwornia);
              writeln('        Rok wydania: ', tab[i]^.dane.year);
              write('               Stan w magazynie: ');
              if tab[i]^.dane.wyp=true then
              writeln('Wypozyczone, przez: ',tab[i]^.dane.nazwisko,' ',tab[i]^.dane.imie)
              else writeln('Niewypozyczone');
              writeln;
            end;
            writeln('Znaleziono kilka tytulow, prosze wpisac odpowiedni');
            read(title_part);
            readln;
            val(title_part,i);
            if (i < 0) OR (i > j-1) then
            begin
              writeln('Wpisz liczbe z zakresu od 0 do ',j-1,' [enter]');
              readln;
            end;
          until (i >= 0) AND (i <= j-1);
          tab[0]:=tab[i];                       //zastepuje zerowy element tab, wybranym przez usera
        end
        else                                              //gdy jest jeden tytul
        begin
          clrscr;
          logo;
          writeln('Znaleziono jeden tytul:');
          write('Tytul: ', tab[0]^.dane.title);
          write('       Producent: ', tab[0]^.dane.wytwornia);
          writeln('     Rok wydania: ', tab[0]^.dane.year);
          write('Stan w magazynie: ');
          if tab[0]^.dane.wyp=true then
          writeln('Wypozyczone, przez: ',tab[0]^.dane.nazwisko,' ',tab[0]^.dane.imie)
          else writeln('Niewypozyczone');
        end;
        writeln('-------------------------------------------------------------------------------');
        writeln('|PODSUMOWANIE:');
        writeln('|=Tytul:        ', tab[0]^.dane.title);
        writeln('|=Wytwornia:    ', tab[0]^.dane.wytwornia);
        writeln('|=Rok wydania:  ', tab[0]^.dane.year);
        writeln('|=Wypozyczone:  ', tab[0]^.dane.wyp);
        writeln('-------------------------------------------------------------------------------');
        writeln('|Czy chcesz skasowac ten wpis? [t/n]');                              //potwierdzenie
        repeat
          key := readkey;
        until (key = 't') OR (key = 'n');
        if key='t' then
        begin
          pom:=glowa;
          if tab[0]=glowa then                                                  //proces usuwania
          begin
            del:=glowa;
            glowa:=glowa^.next;
          end;
          while tab[0]<>pom^.next do
            pom:=pom^.next;
          del:=pom^.next;
          pom^.next:=pom^.next^.next;
          dispose(del);
          writeln('Wpis usuniety pomyslnie! [enter]');
          readln;
        end;
      end
      else
      begin
        writeln('Wynikow jest wiecej niz 100 lub nie ma zadnego, uscislij poszukiwania');
        check:=false;
      end;
    end
    else
      if check = false then writeln ('Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
      if (length(title_part) > 20) AND (length(title_part) < 1) then writeln('Fraza musi zawierac przynamniej 1 i conajwyzej 20 znakow');
  until (check = true) AND (length(title_part) <= 20) AND (length(title_part) >= 1);

end;
procedure menu_stat(glowa:wsk_rekord; glowa_gat:wsk_gatunek);
var
  w : integer;        //przechowuje iulosc wypozyczonych filmow
  tab:array [1..100] of integer;     //tablica przechowujaca ilosc filmow dla danego gatunku
  i:integer;
  all:integer;          //liczba wszystkich filmow
  pom : wsk_rekord;
begin
  clrscr;
  logo;
  w:=0;
  all:=el_list(glowa);     //pobiera liczbe wszyskich filmow
  for i:=1 to 100 do             //zerowanie tablicy
    tab[i]:=0;
  pom := glowa;
  while pom<>nil do
  begin
    if pom^.dane.wyp=true then inc(w);       //pobiera dane
    inc(tab[pom^.dane.gatunek]);
    pom:=pom^.next
  end;
  gotoxy(23,4+1);
  writeln('Wszystkich filmow:   ',all);
  gotoxy(23,4+3);
  writeln('Filmy wypozyczone:   ',w);
  gotoxy(20,4+5);
  writeln('Filmy niewypozyczone:   ',all-w);
  i:=1;
  while glowa_gat <> nil do
  begin                                          //wyswietla gatunki  oraz liczbe filmow dla danego gatunku
    pom:=glowa;
    gotoxy(24-length(glowa_gat^.dane.nazwa),9+2*i);
    write('Filmy kategorii ', glowa_gat^.dane.nazwa,':  ');
    inc(i);
    w:=0;
    while pom<>nil do
    begin
      if glowa_gat^.dane.id = pom^.dane.gatunek then
        inc(w);
      pom:=pom^.next;
    end;
    writeln(w);
    glowa_gat := glowa_gat^.next;
  end;
  gotoxy(20,11+2*i);
  writeln('Aby przejsc dalej kliknij [enter]');
  readln;
end;
procedure menu_ex(glowa : wsk_rekord; glowa_gat:wsk_gatunek);                         //zapisuje tablice do pliku
var
  plik : file of char;   //plik wyeksportowany
  nazwa : string;  //nazwa pliku
  check:boolean;  //walidator sprawdzajacy poprawnosc nazwy
  i:integer;
  temp:string;    //bufor wpisywanych danych
  pom_gat:wsk_gatunek;
begin 
  repeat
    writeln;
    writeln('Podaj nazwe pliku: ');
    readln(nazwa);
    check := check_string(nazwa);                                             //sprawdzanie wyrazenia
    if (check = false) OR (nazwa='dane.txt') OR (nazwa='gatunki.txt') then writeln ('Bledne dane, wprowadz ponownie tylko litery, liczby, nazwa musi byc rozna od plikow systemowych');
    if (length(nazwa) > 20) OR (length(nazwa) < 1) then writeln ('Tytul musi zawierac co najmniej 1 znak, maksymalnie 20');
  until (check = true) AND (length(nazwa) <= 20) AND (length(nazwa) >= 1) AND (nazwa<>'dane.txt') AND (nazwa<>'gatunki.txt');
  assign(plik, nazwa);
  rewrite(plik);
  temp:='Tytul, Producent, Rok wydania, Gatunek, Stan';
  for i:=1 to length(temp) do           //wpisuje nag³owki
    write(plik, temp[i]);
  write(plik, char(13));
  while glowa <> nil do 
  begin 
    with glowa^.dane do                       //wpisuje metoda po znaku dane z listy rekordow w zestawieniu z gatunkami
    begin
      for i:=1 to length(title) do
        write(plik, title[i]);
      write(plik, ',');
      for i:=1 to length(wytwornia) do
        write(plik, wytwornia[i]);
      write(plik, ',');
      STR(year,temp);
      for i:=1 to length(temp) do
        write(plik, temp[i]);
      write(plik, ',');
      pom_gat:=glowa_gat;
      if (pom_gat = nil) OR (gatunek = 0) then
        temp:='Bez gatunku'
      else
      begin
        while (pom_gat^.dane.id <> gatunek) AND (pom_gat^.next <> nil) do
        begin
          pom_gat := pom_gat^.next;
        end;
        if pom_gat = nil then
          temp:='Bez gatunku'
        else
          temp:=pom_gat^.dane.nazwa;
      end;
      for i:=1 to length(temp) do
        write(plik, temp[i]);
      write(plik, ',');
      if wyp = true then
      begin
        temp:='WYPOZYCZONE przez ';
        for i:=1 to length(temp) do
          write(plik, temp[i]);
        temp:=imie;
        for i:=1 to length(temp) do
          write(plik, temp[i]);
        write(plik, ' ');
        temp:=nazwisko;
        for i:=1 to length(temp) do
          write(plik, temp[i]);
      end
      else
      begin
        temp:='NIEWYPOZYCZONE';
        for i:=1 to length(temp) do
          write(plik, temp[i]);
      end;
      write(plik, char(13));
    end;
    glowa := glowa^.next;
  end; 
  close(plik);
  writeln('Baza danych zostala wyeksportowana [enter]');
  readln;
end;
procedure menu_gat(glowa:wsk_rekord; var glowa_gat:wsk_gatunek);
var
  key:char;           //wybrany klawisz
  pom:wsk_gatunek;    //pomocnicza gatunek
  pom_gat:wsk_gatunek;//pomocnicza2 gatunek
  pom2:wsk_rekord;    //pomocnicza rekord
  check:boolean;      //walidator sprawdzajacy string
  nazwa:string;       //przechowuje szukany lancuch
  i:integer;
  escape:boolean;      //gdy user chce wyjsc z menu
begin
  repeat
    clrscr;
    logo;                                         //menu
    escape:=false;
    writeln('Menadzer gatunkow:');
    writeln('1. Lista gatunkow');
    writeln('2. Dodaj gatunek');
    writeln('3. Usun gatunek');
    writeln('4. Zmien nazwe gatunku');
    writeln('0. Wroc do poprzedniego menu i zapisz zmiany');
    repeat
      key:=readkey;
    until (key>='0') AND (key<='4');

    if key='1' then                     //wyswietla liste gatunkow
    begin
      writeln('-------------------------------------------------------------------------------');
      pom:=glowa_gat;
      if pom=nil then
        writeln('| Lista jest pusta [enter]')
      else
      begin
        while pom<>nil do
        begin
          writeln('| ID -> ', pom^.dane.id,'   ', pom^.dane.nazwa);
          pom:=pom^.next;
          end;
        writeln('| Aby przesc do menu wcisnij [enter]');
      end;
      readln;
    end;

    if key='2' then
    begin
      writeln('-------------------------------------------------------------------------------');
      repeat
        write('| Podaj nazwe gatunku: ');                                             //dodawanie gatunku
        read (nazwa);
        readln;
        check := check_string(nazwa);                                            //sprawdzanie wyrazenia
        if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
        pom:=glowa_gat;
        while pom<>nil do
        begin
          if nazwa=pom^.dane.nazwa then               //gdy nazwa sie duplikuje z istniejaca juz
          begin
            writeln ('| -> Taka kategoria juz istnieje');
            readln;
            escape:=true;
          end;
          pom:=pom^.next;
        end;
        if (length(nazwa) > 20) OR (length(nazwa) < 3) then writeln ('| -> Gatunek musi zawierac co najmniej 3 znaki, maksymalnie 20');
      until (check = true) AND (length(nazwa) <= 20) AND (length(nazwa) >= 3) OR (escape=true);
      if escape=false then                 //gdy user nie chce wyjsc z menu
      begin
        dodaj_gat(glowa_gat,nazwa,0);      //dodaje nowy gatunek do listy
        writeln('Gatunek: ', #39, nazwa, #39, ' zostal pomyslnie dodany [enter]');
        readln;
      end;
    end;
    if key='3' then       //usuwa gatunek
    begin
      writeln('-------------------------------------------------------------------------------');
      repeat
        write('| Podaj dokladna nazwe gatunku do usuniecia: ');                                             //szukanie gatunku
        read (nazwa);
        readln;
        check := check_string(nazwa);                                            //sprawdzanie wyrazenia
        if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
        if (length(nazwa) > 20) OR (length(nazwa) < 3) then writeln ('| -> Gatunek musi zawierac co najmniej 3 znaki, maksymalnie 20');
      until (check = true) AND (length(nazwa) <= 20) AND (length(nazwa) >= 3);
      pom:=glowa_gat;
      check:=false;
      while pom<>nil do
      begin
        if nazwa=pom^.dane.nazwa then
        begin
          writeln ('| -> Znaleziono kategorie... [enter]');
          check:=true;                 //gdy znaleziono pasujaca kategorie
          break;
        end;
        pom:=pom^.next;
      end;
      if check=false then            //gdy znaleziono niepasujaca kategorie
      begin
        writeln ('| -> Taka kategoria nie istnieje [enter]');
        readln;
      end
      else
      begin
        clrscr;                       //menu
        writeln('| Co zrobic filmami ktore posiadana kategorie: ',pom^.dane.nazwa);
        writeln('| 1. Pozostaw bez kategorii');
        if (glowa_gat<>pom) OR (glowa_gat^.next<>nil) then
          writeln('| 2. Zmien kategorie na inna');
        writeln('| 0. Nie usuwaj');
        repeat
          key:=readkey;
        until (key>='0') AND (key<='2');

        if key='1' then         //ustawia id filmow na 0
        begin
          writeln(' Lista zmienionych filmow: ');
          pom2:=glowa;
          while pom2<>nil do
          begin
            if pom2^.dane.gatunek=pom^.dane.id then       //wyswietla filmy w ktorych id kategorii zostaje zmienione
            begin
              write('Tytul: ', pom2^.dane.title);
              write('       Producent: ', pom2^.dane.wytwornia);
              writeln('     Rok wydania: ', pom2^.dane.year);
              pom2^.dane.gatunek:=0;
            end;
            pom2:=pom2^.next;
          end;
        end
        else if key='2' then              //zamienia gatunek filmow na wybrany ponizej
        begin
          clrscr;
          pom_gat:=glowa_gat;
          i:=1;
          while pom_gat<>nil do
          begin
            if pom_gat<>pom then                     //wyswietla liste gatunkow pomijajac ten ktory ma zostac usuniety
            begin
              writeln(' ', chr(i+96) ,' ', pom_gat^.dane.nazwa);
              inc(i);
            end;
            pom_gat:=pom_gat^.next;
          end;
          writeln('Na ktora z powyzszych kategorii zamienic kategorie usuwana');
          repeat
            key:=readkey;
          until (key >= chr(96)) AND (key <= chr(i+96));      //sprawdza czy wybrany jest w zakresie listy
          i:=1;

          pom_gat:=glowa_gat;
          while i<=ord(key)-97 do                     //ustawia gatunek w liscie na ten na ktory maja zostac zamienione gatunki w filmach pomijajac ten ktory ma byc kasowany
          begin
            if pom_gat<>pom then
              inc(i);
            pom_gat:=pom_gat^.next;
          end;
          writeln('Lista zmienionych filmow: ');
          pom2:=glowa;
          while pom2<>nil do
          begin
            if pom2^.dane.gatunek=pom^.dane.id then   //wyswietla filmy w ktorych gatunek zostaje zamieniony
            begin
              write('Tytul: ', pom2^.dane.title);
              write('       Producent: ', pom2^.dane.wytwornia);
              writeln('     Rok wydania: ', pom2^.dane.year);
              write('Stan w magazynie: ');
              if pom2^.dane.wyp = true then writeln('Wypozyczone')
              else writeln('Niewypozyczone');
              pom2^.dane.gatunek:=pom_gat^.dane.id;
            end;
            pom2:=pom2^.next;
            key:='2';
          end;
        end;
        if (key='1') OR (key='2') then              //warunek ogolny dla kasowania
        begin
          if glowa_gat=pom then
            glowa_gat:=pom^.next
          else                                      //proces kasowania
          begin
            pom_gat:=glowa_gat;
            while pom_gat^.next<>pom do
              pom_gat:=pom_gat^.next;
            pom_gat^.next:=pom^.next;
          end;
          dispose(pom);
        end;
        readln;
        key:='3';
      end;
    end;
    if key='4' then                         //aktualizuje nazwe gatunku
    begin
      writeln('-------------------------------------------------------------------------------');
      repeat
        write('| Podaj dokladna nazwe gatunku do aktualizacji: ');                                             //szukanie gatunku
        read (nazwa);
        readln;
        check := check_string(nazwa);                                            //sprawdzanie wyrazenia
        if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
        if (length(nazwa) > 20) OR (length(nazwa) < 3) then writeln ('| -> Gatunek musi zawierac co najmniej 3 znaki, maksymalnie 20');
      until (check = true) AND (length(nazwa) <= 20) AND (length(nazwa) >= 3);
      pom:=glowa_gat;
      check:=false;
      while pom<>nil do
      begin
        if nazwa=pom^.dane.nazwa then
        begin
          writeln ('| -> Znaleziono kategorie... [enter]');
          check:=true;                    //gdy znaleziono pasujaca kategorie
          break;
        end;
        pom:=pom^.next;
      end;
      if check=false then
      begin                                 //gdy znaleziono niepasujaca kategorie
        writeln ('| -> Taka kategoria nie istnieje [enter]');
        readln;
      end
      else
      begin
        repeat
          write('| Podaj nowa nazwe tego gatunku: ');                                             //aktualizowanie gatunku
          read (nazwa);
          readln;
          check := check_string(nazwa);                                            //sprawdzanie wyrazenia
          if check = false then writeln ('| -> Bledne dane, wprowadz ponownie tylko litery, liczby i podstawowe znaki w zdaniu');
          if (length(nazwa) > 20) OR (length(nazwa) < 3) then writeln ('| -> Gatunek musi zawierac co najmniej 3 znaki, maksymalnie 20');
        until (check = true) AND (length(nazwa) <= 20) AND (length(nazwa) >= 3);
        writeln('| Czy chcesz zaktualizowac nazwe z: ',#39, pom^.dane.nazwa ,#39,' na: ',#39, nazwa, #39,'? [t/n]');
        repeat
          key:=readkey;
        until (key='t') OR (key='n');               //potwierdzenie
        if key='t' then
        begin
          pom^.dane.nazwa:=nazwa;             //proces akutalizacja
          writeln('Nazwa zostala pomyslnie zakutalizowana. [enter]');
        end;
      end;
    end;
  zapisz_gat(glowa_gat);                     //po wyjsciu z menu zapisuje liste gatunkow do pliku
  until (key='0');
end;


begin
  glowa := nil;
  glowa_gat:=nil;
 { dodaj_gat(glowa_gat, 'komedia', 1);                                           //Dodawanie danych
  dodaj_gat(glowa_gat, 'romans', 2);
  dodaj_gat(glowa_gat, 'dramat', 3);
  dodaj_gat(glowa_gat, 'fantastyka', 4);
  dodaj_gat(glowa_gat, 'komediodramat', 5);
  dodaj_gat(glowa_gat, 'bajka', 6);

  dodaj(glowa, 'Madagaskar 2', 'Disney', 'Matieo', 'Przyb', 2008, 0, true);
  dodaj(glowa, 'Bnna', 'Nowak', '', '', 1970, 5, false);
  dodaj(glowa, 'Botanika', 'Disney', 'Mati', 'Przyb', 2008, 5, true);
  dodaj(glowa, 'Shrek', 'Nowak', '', '', 1920, 5, false);
  dodaj(glowa, 'Madagaskar', 'Disney', 'Lol', 'banka',  2008, 4, true);
  dodaj(glowa, 'Shrek 3', 'Nowak', '', '', 1973, 1, false);
  dodaj(glowa, 'Bajeczki', 'DCG', '', '', 2008, 2, false);
  dodaj(glowa, 'Milosc', 'Nowak', '', '', 1950, 1, false);
  dodaj(glowa, 'Madagaaa', 'Disndfgdfgey', '', '', 2008, 1, false);
  dodaj(glowa, 'Desnej', 'Nowak', '', '', 1970, 1, false);
  dodaj(glowa, 'Madagaskar 2', 'Disnedfgdgy', 'Cwik', 'Nowak', 2008, 1, true);
  dodaj(glowa, 'Madagaskar', 'Disney', 'Endrju', 'Wyleciol', 1970, 2, true);
  dodaj(glowa, 'Madagaskgdfgar 2', 'Disney', '', '', 2008, 1, false);
  dodaj(glowa, 'Madagaskar', 'Disney', '', '', 1970, 1, false);
  dodaj(glowa, 'Madagadfgskar 2', 'Disdfgdfney', '', '', 2008, 2, false);
  dodaj(glowa, 'Bajeczki', 'DCG', 'Geto', 'Eto', 1970, 2, true);
  dodaj(glowa, 'Madagaskar 2', 'Disney', '', '', 2008, 2, false);
  dodaj(glowa, 'Madagaskar', 'Disney', '', '', 1970, 1, false);
  dodaj(glowa, 'Shrek 3', 'Nowak', '', '', 2008, 2, false);
  dodaj(glowa, 'Madagaskar', 'Disney', '', '', 1965, 1, false);
  dodaj(glowa, 'Madag', 'Disney', 'Mateo', 'Flapek', 2008, 2, true);
  dodaj(glowa, 'Botanika', 'Disney', '', '', 1977, 1, false);
  zapisz('dane.txt', glowa);                                          //zapisuje dane do pliku
  zapisz_gat(glowa_gat);
  usun(glowa,glowa_gat);}                                              //usuwa listy

  wczytaj('dane.txt', glowa);                                          //wczytuje dane do list z plikow
  wczytaj_gat(glowa_gat);

  od := 1;                                                       //ustala od ktorego elementu wyswietlac
  sort := '';                                                    //ustala rodzaj sortowania
  repeat
    key_main := menu_main;                                       //wywoluje menu poczatkowe
    key_wypisz := '0';                                           //zeruje wszystkie pozostale klucze

    case key_main of                                             // lista zadan kluczy dla menu glownego
      '1' : key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);  //1 wywoluje wyswietlanie
      '2' : menu_dodaj(glowa,glowa_gat);                         //2 dodaje wpis
      '3' : menu_usun(glowa);                                    //3 usuwa wpis
      '4' : seek(glowa,glowa_gat);                               //4 szuka wpisu
      '5' : menu_stat(glowa,glowa_gat);                          //5 wysyluje statystyki
      '6' : menu_ex(glowa,glowa_gat);                            //6 exportuje daze danych
      '7' : menu_gat(glowa,glowa_gat);                           //7 menager gatunkow

    end;

    while key_wypisz<>'0' do
    begin                                                        //lista zadan kluczy dla menu z lista wyswietlana
//    repeat
      case key_wypisz of
        '1' : begin
              menu_dodaj(glowa,glowa_gat);                         //dodaje wpis
              key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);  //i wraca do modulu wyswietlania listy
              end;
        '2' : begin
              menu_update(glowa,glowa_gat);                        //aktualizuje wpis
              key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);  //i wraca do modulu wyswietlania listy
              end;
        't' : begin
              if sort='n0' then sort:='n1'
              else sort:='n0';
              sort_list(glowa, sort);                               //sortuje wzg. nazwy (rosnaco/malejaco)
              key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);   //i wraca do modulu wyswietlania listy
              end;
        'p' : begin
              if sort='p0' then sort:='p1'
              else sort:='p0';
              sort_list(glowa, sort);                               //sortuje wzg. producenta (rosnaco/malejaco)
              key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);   //i wraca do modulu wyswietlania listy
              end;
        'r' : begin
              if sort='y0' then sort:='y1'
              else sort:='y0';
              sort_list(glowa, sort);                                //sortuje wzg. roku (rosnaco/malejaco)
              key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);    //i wraca do modulu wyswietlania listy
              end;
        'M' : begin                                                 //poruszanie w prawo klawiszem
              od := od+10;                                          //przesuwa wyswietlana liste o 10rekordow do przodu
              key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);   //i wraca do modulu wyswietlania listy
              end;
        'K' : begin                                                  //poruszanie w lewo klawiszem
              od := od-10;                                           //przesuwa wyswietlana liste o 10rekordow do wstecz
              key_wypisz := menu_wypisz(glowa,glowa_gat,od,sort);    //i wraca do modulu wyswietlania listy
              end;
      end;
    end;
  until key_main='0';
  zapisz('dane.txt', glowa);                     //po wysciu z programu zapisuje zmiany do pliku
  usun(glowa,glowa_gat);                         //usuwa liste z pamieci
end.
