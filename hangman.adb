with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Numerics.Discrete_Random;
package body hangman is
  package random_num is new Ada.Numerics.Discrete_Random
   (Result_Subtype => rng);

  procedure StackInit (Stk : in out SType) is
  begin
    Stk.Top := 0;
  end StackInit;

  function StkTop (Stk : in SType) return Character is
  begin
    return Stk.Store (Stk.Top);
  end StkTop;

  procedure Push (Stk : in out SType; new_e : in Character) is
  begin
    if Stk.Top /= Stk.Size then
      Stk.Top             := Stk.Top + 1;
      Stk.Store (Stk.Top) := new_e;
    end if;
  end Push;

  procedure Pop (Stk : in out SType) is
  begin
    loop
      if Stk.Top /= 0 then

        Stk.Top := Stk.Top - 1;
      end if;
      exit when Stk.Top = 0;
    end loop;
  end Pop;

  procedure Print (Stk : in SType) is
  begin
    for i in 1 .. Stk.Top loop
      Put (Item => Stk.Store (i));
      Put (Item => "  ");
    end loop;
  end Print;

  ------------ List Functions ---------------------------------

  procedure Search_Linked_List
   (List     : in List_Type; Key : in Unbounded_String; Found : out Boolean;
    Pred_Loc :    out Node_Ptr; Location : out Node_Ptr)
  is

  begin
    Location := List.Head;  -- Start at the beginning of the linked list
    Pred_Loc := null;  -- No predecessor for 1st element in the list
    -- Search the linked list
    -- Each iteration, check one node
    loop
      exit when Location =
       null or else -- Reached the end

        Key < (Location.all.Info)
       or else -- Passed by

        Key = (Location.all.Info);  -- Found it
      Pred_Loc := Location;
      Location := Location.all.Next;
    end loop; -- Found := Location /= null and then Key = Location.all.Info;
    if Location /= null then
      Found := Key = (Location.all.Info);
    else
      Found := False;
    end if;
  end Search_Linked_List;

  ----------------------------------------------------------------------------

  procedure Insert (List : in out List_Type; Word : in Unbounded_String) is
    Have_Duplicate : Boolean;
    Pred_Loc       : Node_Ptr;
    Location       : Node_Ptr;
  begin
    Search_Linked_List
     (List => List, Key => Word, Found => Have_Duplicate, Pred_Loc => Pred_Loc,
      Location => Location);
    if Have_Duplicate then
      raise DUPLICATE_KEY;
    elsif Pred_Loc = null then
      -- Add Item to the head of the linked list
      List.Head := new Node_Type'(Info => Word, Next => List.Head);
    else -- Add at the middle or end of the linked list
      Pred_Loc.all.Next := new Node_Type'(Info => Word, Next => Location);
    end if;
  exception
    when Storage_Error => -- Overflow when no storage available
      raise OVERFLOW;
  end Insert;

  ----------------------------------------------------------------------------
  procedure Traverse
   (List    : in out List_Type; RandomNum : in Integer;
    Element :    out Unbounded_String)
  is
    Location : Node_Ptr;  -- Designates current node
  begin
    Location := List.Head;  -- Start with the first node in the linked
    for i in 1 .. RandomNum loop
      exit when Location = null;
      Element  := Location.all.Info;
      Location := Location.all.Next; -- Move to next node
    end loop;
  end Traverse;

  --------------------------------------------------------------------------
  procedure InitList (x : out List_Type) is

    subtype File_Type is Ada.Text_IO.File_Type; -- creates a subtype File_Type
    File_1     : File_Type;
    c          : Character;
    line_data2 : Unbounded_String;
  begin
    Ada.Text_IO.Open
     (File => File_1, Mode => Ada.Text_IO.In_File, Name => "wordbank.txt");
    while not Ada.Text_IO.End_Of_File (File_1) loop
      loop
        Get (File => File_1, Item => c);
        exit when c = ' ';
        line_data2 := line_data2 & To_Lower (c);
      end loop;
      Insert (x, line_data2);
      line_data2 := To_Unbounded_String ("");
    end loop;
    Ada.Text_IO.Close (File => File_1);
  end InitList;

  function RandomNumber return Integer is
    R : random_num.Generator;

  begin
    random_num.Reset (Gen => R);
    return random_num.Random (Gen => R);
  end RandomNumber;

  function GetWord (x : in List_Type) return Unbounded_String is
    randnum  : Integer;
    retword  : Unbounded_String;
    retrieve : List_Type := x;
  begin
    randnum := RandomNumber;
    Traverse (retrieve, randnum, retword);
    return retword;
  end GetWord;

  ------------ Game Functions ---------------------------------
  function CreateMan (WrongCount : Integer) return ManArray is
    HangMan : ManArray;
    One     : Line;
    Two     : Line;
    Three   : Line;
    Four    : Line;
    Five    : Line;
    Six     : Line;
    Seven   : Line;
    Eight   : Line;
    Nine    : Line;
    Ten     : Line;
    Eleven  : Line;
  begin

    if (WrongCount = 0) then

      One    := "******************";
      Two    := "     _ _ _ _     *";
      Three  := "    |      |     *";
      Four   := "    |            *";
      Five   := "    |            *";
      Six    := "    |            *";
      Seven  := "    |            *";
      Eight  := "    |            *";
      Nine   := "    |            *";
      Ten    := " --------        *";
      Eleven := "******************";

    elsif (WrongCount = 1) then
      One    := "******************";
      Two    := "     _ _ _ _     *";
      Three  := "    |      |     *";
      Four   := "    |      O     *";
      Five   := "    |            *";
      Six    := "    |            *";
      Seven  := "    |            *";
      Eight  := "    |            *";
      Nine   := "    |            *";
      Ten    := " --------        *";
      Eleven := "******************";

    elsif (WrongCount = 2) then
      One    := "******************";
      Two    := "     _ _ _ _     *";
      Three  := "    |      |     *";
      Four   := "    |      O     *";
      Five   := "    |      |     *";
      Six    := "    |      |     *";
      Seven  := "    |            *";
      Eight  := "    |            *";
      Nine   := "    |            *";
      Ten    := " --------        *";
      Eleven := "******************";

    elsif (WrongCount = 3) then
      One    := "******************";
      Two    := "     _ _ _ _     *";
      Three  := "    |      |     *";
      Four   := "    |    \ O     *";
      Five   := "    |     \|     *";
      Six    := "    |      |     *";
      Seven  := "    |            *";
      Eight  := "    |            *";
      Nine   := "    |            *";
      Ten    := " --------        *";
      Eleven := "******************";

    elsif (WrongCount = 4) then
      One    := "******************";
      Two    := "     _ _ _ _     *";
      Three  := "    |      |     *";
      Four   := "    |    \ O /   *";
      Five   := "    |     \|/    *";
      Six    := "    |      |     *";
      Seven  := "    |            *";
      Eight  := "    |            *";
      Nine   := "    |            *";
      Ten    := " --------        *";
      Eleven := "******************";

    elsif (WrongCount = 5) then
      One    := "******************";
      Two    := "     _ _ _ _     *";
      Three  := "    |      |     *";
      Four   := "    |    \ O /   *";
      Five   := "    |     \|/    *";
      Six    := "    |      |     *";
      Seven  := "    |     /      *";
      Eight  := "    |    /       *";
      Nine   := "    |            *";
      Ten    := " --------        *";
      Eleven := "******************";

    elsif (WrongCount = 6) then
      One    := "******************";
      Two    := "     _ _ _ _     *";
      Three  := "    |      |     *";
      Four   := "    |    \ O /   *";
      Five   := "    |     \|/    *";
      Six    := "    |      |     *";
      Seven  := "    |     / \    *";
      Eight  := "    |    /   \   *";
      Nine   := "    |            *";
      Ten    := " --------        *";
      Eleven := "******************";

    end if;

    HangMan (1)  := One;
    HangMan (2)  := Two;
    HangMan (3)  := Three;
    HangMan (4)  := Four;
    HangMan (5)  := Five;
    HangMan (6)  := Six;
    HangMan (7)  := Seven;
    HangMan (8)  := Eight;
    HangMan (9)  := Nine;
    HangMan (10) := Ten;
    HangMan (11) := Eleven;

    return HangMan;

  end CreateMan;
  -----------------------------------------------------------------------------------------

  procedure DrawMan (Man : in ManArray) is
  begin
    for i in 1 .. 11 loop
      Ada.Text_IO.Put (Item => Man (i));
      New_Line;
    end loop;
  end DrawMan;

  -------------------------------------------------------------------------------------------

  procedure ShowMessage (WrongCount : Integer; WrongPrev : Integer) is

  begin
    if (WrongCount = WrongPrev) then
      Put ("Good Guess!");
    else
      if (WrongCount = 1) then
        Put ("Head added to Hang Man!");

      elsif (WrongCount = 2) then
        Put ("Body added to Hang Man!");

      elsif (WrongCount = 3) then
        Put ("First arm added to Hang Man!");

      elsif (WrongCount = 4) then
        Put ("Second arm added to Hang Man!");

      elsif (WrongCount = 5) then
        Put ("First leg added to Hang Man! Be Careful!!");

      else  -- (WrongCount = 6) Then
        Put ("Second leg added to Hang Man!");
        New_Line;
        Put ("You hung the man! YOU LOSE!");

      end if;

    end if;
  end ShowMessage;

  -------------------------------------------------------------
end hangman;
