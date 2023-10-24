#! /bin/bash
echo "--------------------------"
echo "User Name: jeonghui Han"
echo "Student Number: 12211717"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific"
echo "'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id'from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

userChoice = 0
movieID = ""
while [$userChoice -ne 9]
do
    read -p "Enter your choice [1-9] " userChoice
    case $userChoice in
        1)  read -p "Please enter the 'movie id'(1~1682) : " movieID
            cat $1 | awk '$1=="movieID"'
        2)
        