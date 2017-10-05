module SelectedFruit exposing (..)


type SelectedFruit
    = SelectedFruit (List String)


empty : SelectedFruit
empty =
    SelectedFruit []


member : String -> SelectedFruit -> Bool
member fruit (SelectedFruit list) =
    List.member fruit list


insert : String -> SelectedFruit -> SelectedFruit
insert fruit (SelectedFruit list) =
    SelectedFruit <|
        List.take 2 <|
            fruit
                :: list


remove : String -> SelectedFruit -> SelectedFruit
remove fruit (SelectedFruit list) =
    SelectedFruit <|
        List.filter (\x -> fruit /= x) list
