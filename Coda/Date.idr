module Date

import Coda.Range

%access public export
%default total

{-
  ISO 8601 Date Package

  Date Representation inclues:

    Year - Month - Day

  Show interface includes zero-padding of up to 3 zeroes for Year, and 1 zero
  for month and day.

-}

{-
  Type Definitions
-}

data Year : Type where
  MkYear : (year : Integer) -> Year

%name Year y,y1,y2,y3

isLeap : Year -> Bool
isLeap (MkYear year) = (modNatNZ (toNat year) 4 SIsNotZ) == 0

data Month : Type where
  January   : Month
  February  : Month
  March     : Month
  April     : Month
  May       : Month
  June      : Month
  July      : Month
  August    : Month
  September : Month
  October   : Month
  November  : Month
  December  : Month

%name Month m,m1,m2,m3

monthOrder : Month -> Nat
monthOrder January   = 1
monthOrder February  = 2
monthOrder March     = 3
monthOrder April     = 4
monthOrder May       = 5
monthOrder June      = 6
monthOrder July      = 7
monthOrder August    = 8
monthOrder September = 9
monthOrder October   = 10
monthOrder November  = 11
monthOrder December  = 12

monthDays : Year -> Month -> Nat
monthDays _    January   = 30
monthDays year February  = if isLeap year then 29 else 28
monthDays _    March     = 30
monthDays _    April     = 31
monthDays _    May       = 30
monthDays _    June      = 31
monthDays _    July      = 30
monthDays _    August    = 31
monthDays _    September = 30
monthDays _    October   = 31
monthDays _    November  = 30
monthDays _    December  = 31

previousMonth : Month -> Month
previousMonth January   = December
previousMonth February  = January
previousMonth March     = February
previousMonth April     = March
previousMonth May       = April
previousMonth June      = May
previousMonth July      = June
previousMonth August    = July
previousMonth September = August
previousMonth October   = September
previousMonth November  = October
previousMonth December  = November

data Day : Type where
  MkDay : (day : Nat) -> Day

%name Day d,d1,d2,d3

inDayRange : Nat -> Day -> Type
inDayRange n (MkDay day) = inRange (MkRange Z (S n)) day

validDate : Year -> Month -> Day -> Type
validDate year month = inDayRange (monthDays year month)

data Date : Type where
  MkDate : (year : Year) ->
           (month : Month) ->
           (day : Day) ->
           { auto p : (validDate year month day) } -> Date

%name Date d,d1,d2,d3


{-
  Standard Interface Implementations
-}

Eq Year where
  (==) (MkYear y) (MkYear y') = y == y'

Eq Month where
  (==) x y  = monthOrder x == monthOrder y

Eq Day where
  (==) (MkDay y) (MkDay y') = y == y'

Eq Date where
  (==) (MkDate y m d) (MkDate y' m' d') = d == d' && m == m' && y == y'

Ord Year where
  compare (MkYear y) (MkYear y') = compare y y'

Ord Month where
  compare x y = compare (monthOrder x) (monthOrder y)

Ord Day where
  compare (MkDay d) (MkDay d') = compare d d'

Ord Date where
  compare (MkDate y m d) (MkDate y' m' d') =
    case compare y y' of
         EQ => case compare m m' of
                    EQ => compare d d'
                    result => result
         result => result

Show Year where
  show (MkYear year) =
    let s = show year
    in case length s of
            Z => "0000"
            (S Z) => "000" ++ s
            (S (S Z)) => "00" ++ s
            (S (S (S Z))) => "0" ++ s
            _ => s

Show Month where
  show x =
    let s = show $ monthOrder x
    in case length s of
            (S Z) => "0" ++ s
            _ => s

Show Day where
  show (MkDay day) =
    let s = show day
    in case length s of
            (S Z) => "0" ++ s
            _ => s

Show Date where
  show (MkDate y m d) = show y ++ "-" ++ show m ++ "-" ++ show d

