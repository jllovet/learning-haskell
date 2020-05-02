import Data.List
import System.IO

myTuple = (1, "I'm a String!")

bobSmith = ("Bob Smith", 52)

bobsName = fst bobSmith

bobsAge = snd bobSmith


newTuple = (1,2,"apple")
-- function using patter matching to get third element
-- not recommended for larger tuples
thrd (x,y,z) = z
thirdElement = thrd newTuple

-- Combining lists elementwise into tuples
names = ["Bob", "Mary", "Tom"]
addresses = ["123 Main St", "1029 My Street", "938 Apple Lane"]

userInfo = zip names addresses
