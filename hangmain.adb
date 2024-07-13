with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with hangman;                  use hangman;

procedure hangmain is

  --VARIABLES--
  WordList   : List_Type;
  response   : Character        := 'y';
  guess      : Character;
  MAXWRONG   : constant Integer := 6;
  MAXCOR     : Integer          := 0;
  CorCount   : Integer          := 0;
  CorPrev    : Integer          := 0;
  Wrongcount : Integer          := 0;
  Wrongprev  : Integer          := 0;
  CurrWord   : Unbounded_String;
  GuessStack : SType (26);
  type showWord is array (Positive range <>) of Character;
  DispWord    : showWord (1 .. 100);
  CorrectWord : showWord (1 .. 100);
  Man         : ManArray;
begin
  --- INITIALIZE GUESSES ---
  InitList (WordList);
  --WELCOME TO HANGMAN--
  Put ("***** W E L C O M E  T O  H A N G M A N  *****");
  New_Line;
  Put (" By: Jon Hollan, Mark Hoffman, & Brandon Ball");
  New_Line;
  New_Line;

  while (response = 'y') or (response = 'Y') loop
    StackInit (GuessStack);
    CurrWord := GetWord (WordList);
    MAXCOR   := Length (CurrWord);
    for i in 1 .. MAXCOR loop
      DispWord (i) := '-';
    end loop;

    for i in 1 .. MAXCOR loop
      CorrectWord (i) := Element (CurrWord, i);
    end loop;

    --- START THE ROUND ---
    --while(CorCount /= MAXCOR) OR (WrongCount /= MAXWRONG) loop
    loop
      Wrongprev := Wrongcount;
      CorPrev   := CorCount;
      Man       := CreateMan (Wrongcount);
      DrawMan (Man);
      New_Line;
      for i in 1 .. MAXCOR loop
        Put (DispWord (i));
      end loop;
      New_Line;

      Put ("Guesses: ");
      Print (GuessStack);
      New_Line;
      Put ("Enter Guess: ");
      Get (guess);
      Push (GuessStack, guess);

      for i in 1 .. MAXCOR loop
        if (guess = CorrectWord (i)) then
          DispWord (i) := CorrectWord (i);
          CorCount     := CorCount + 1;
        end if;
      end loop;

      if (CorCount = CorPrev) then
        Wrongcount := Wrongcount + 1;
      end if;

      ShowMessage (Wrongcount, Wrongprev);
      New_Line;
      New_Line;
      exit when (CorCount = MAXCOR);
      exit when (Wrongcount = MAXWRONG);
    end loop;
    if (Wrongcount = MAXWRONG) then
      Man := CreateMan (Wrongcount);
      DrawMan (Man);
      Put ("The correct word was ");
      Put (Item => CurrWord);
      New_Line;
      Put ("Would you like to play again? y/n: ");
      Get (response);
    end if;

    if (CorCount = MAXCOR) then
      Put ("Congratulations! YOU WON!");
      New_Line;
      Put ("The correct word was ");
      Put (Item => CurrWord);
      New_Line;
      Put ("Would you like to play again? y/n: ");
      Get (response);
    end if;
    Wrongcount := 0;
    CorCount   := 0;

  end loop;
end hangmain;
