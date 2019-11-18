repeatString str n = 
    if n == 0
        then ""
        else if n == 1
            then str ++ (repeatString str (n-1))
            else str ++ " " ++ (repeatString str (n-1))
