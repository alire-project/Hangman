with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package hangman is
  subtype Line is String (1 .. 18);
  type ManArray is array (1 .. 11) of Line;
  type alpha is array (Positive range <>) of Character;
  type SArray is array (Positive range <>) of Character;
  type SType (Size : Positive) is record
    Top   : Natural := 0;
    Store : SArray (1 .. Size);
  end record;
  DUPLICATE_KEY : exception;
  KEY_ERROR     : exception;
  OVERFLOW      : exception;
  subtype rng is Positive range 1 .. 100;
  type List_Type is private;

  ------------STACK FUNCTIONS----------------
  procedure StackInit (Stk : in out SType);
  function StkTop (Stk : in SType) return Character;
  procedure Push (Stk : in out SType; new_e : in Character);
  procedure Pop (Stk : in out SType);
  procedure Print (Stk : in SType);

  -------------LIST FUNCTIONS----------------
  procedure InitList (x : out List_Type);
  function RandomNumber return Integer;
  function GetWord (x : in List_Type) return Unbounded_String;

  --------------GAME FUNCTIONS----------------
  function CreateMan (WrongCount : Integer) return ManArray;
  procedure DrawMan (Man : in ManArray);
  procedure ShowMessage (WrongCount : Integer; WrongPrev : Integer);

  ----------------------------------------------------------------------------
  procedure Insert (List : in out List_Type; Word : in Unbounded_String);
  -- Purpose : Adds Item to List.
  -- Preconditions : None
  -- Postconditions : List = original list + Item
  -- Exceptions : OVERFLOW If there is no room for Item.
  -- List is unchanged.
  -- DUPLICATE_KEY If an element already exists in the list
  -- with the same key as Item.
  -- List is unchanged.

  -------------------------------------------------------------------------------
  -- Iterator

  ----------------------------------------------------------------------------
  procedure Traverse
   (List    : in out List_Type; RandomNum : in Integer;
    Element :    out Unbounded_String);
  -- Purpose : To process all the elements in List in ascending order
  -- Preconditions : Procedure Process does not change the key of an element
  -- Postconditions : Every element in List is passed to a call of
  -- procedure Process
  -- Elements processed in ascending order

---------------------------------------------------------------------------
private

  type Node_Type;
  type Node_Ptr is access Node_Type;
  type Node_Type is record
    Info : Unbounded_String;
    Next : Node_Ptr;
  end record;

  type List_Type is record
    Head : Node_Ptr;  -- Designates first node in the linked list
  end record;

end hangman;
