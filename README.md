# Video Library
Projekt na studia 2009 r. System do obsługi Wideoteki. Baza danych z filmami zaimplementowana w języku Pascal

## Cel projektu

Napisać prostą bazę danych przechowującą informacje o filmach, wykorzystując struktury dynamiczne. Rekord przechowujący informacje o książce powinien zawierać pola: tytuł, wytwórnia, rok wydania, gatunek, informacje o wypożyczeniu. Program powinien umożliwiać:
* Odczytywanie bazy z pliku. 
* Zapisywanie bazy do pliku. 
* Dodawanie i usuwanie filmów. 
* Modyfikację istniejących rekordów. 
* Sortowanie bazy według tytułu i autora.
* Wypisywanie na ekran informacji o wszystkich filmach. 
* Wypisywanie na ekran informacji o filmach, w których tytułach zawiera się łańcuch znaków podany przez użytkownika. 
* Eksport bazy do pliku tekstowego.

## Specyfikacja zewnętrzna
* Program odpowiada za obsługę bazy danych filmów video za pomocą jego można przeglądać, wyszukiwać, aktualizować, dodawać a także usuwać filmy z bazy. W dodatku dodany jest menadżer gatunków filmowych dzięki czemu w łatwy sposób można zmieniać, usuwać, modyfikować istniejące gatunki  oraz dodawać nowe w miarę potrzeb. Jest także interesujący system statystyk oraz możliwość sortowania wyświetlonych programów względem 3ech kategorii a do tego dla każdej z nich możliwość sortowania malejąco i rosnąco. Jest także możliwość eksportowania bazy danych do pliku podanego przez użytkownika
* Obsługa programu jest trywialna wystarczy uważnie czytać co program wyświetla. 
* Klawisze jakimi głownie się obsługuje program klawisze numeryczne strzałki oraz litery ważne przy doborze sortowania oraz wyborze z listy gatunków.
* Pliki z danymi zapisywane są pod nazwami ‘dane.txt’ oraz ‘gatunki.txt’ pod żadnym pozorem nie wolno ich kasować, chyba że chcesz skasować wszystkie dotychczasowe wpisy
* Błędy programu są w jasny sposób wyświetlane podczas działania programu, one same nie powodują złego działania programu, a tylko starają się naprowadzić użytkownika aby wpisał poprawne dane.
* Dane:
   * Rok – powinien zostać podawany z zakresu 1899-2099
   * Tytuł,  producent, gatunek filmu, imię oraz nazwisko wypożyczającego – nie powinny mieć mniej niż 2 znaki ale nie więcej niż 20 powinny zawierać także tylko i wyłącznie znaki alfanumeryczne oraz podstawowe znaki w zdaniu jak ‘,?!()’ itd.
