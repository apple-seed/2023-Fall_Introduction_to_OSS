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

userChoice=0
while true
do
    read -p "Enter your choice [1-9] " userChoice
    case "$userChoice" in
        "1") 
            read -p "Please enter the 'movie id'(1~1682): " movieID
            cat $1 | awk -F\| -v id=$movieID '$1==id {print}'
            ;;
        "2") 
            read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n): " userCommand
            if [ $userCommand = "y" ]
            then 
                cat $1 | awk -F\| '$7==1 {print $1, $2}' | head
            fi
            ;;
        "3") 
            read -p "Please enter the 'movie id'(1~1682): " movieID
            movieRound=$(cat $2 | awk -F '\t' -v mvID=$movieID '$2==mvID {print $3}' | \
                awk '{sum += $1} END {print sum/NR}')
            echo "average rating of ${movieID}: ${movieRound}"
            ;;
        "4")
            read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " userCommand
            if [ $userCommand = "y" ]
            then 
                cat $1 | head | sed -E 's/http:[^\)]*\)//g'
            fi
            ;;
        "5")
            read -p "Do you want to get the data about users from 'u.user'?(y/n): " userCommand
            if [ $userCommand = "y" ]
            then 
                cat $3 | head | sed -e 's/M/male/' -e 's/F/female/' | \
                    awk -F\| '{printf("user %s is %s years old %s %s\n", $1, $2, $3, $4)}'
            fi
            ;;
        "6")
            read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n): " userCommand
            if [ $userCommand = "y" ]
            then 
                cat $1 | tail | sort | 
                sed -e 's/Jan/01/' -e 's/Feb/02/' -e 's/Mar/03/' -e 's/Apr/04/' -e 's/May/05/' -e 's/Jun/06/'  \
                    -e 's/Jul/07/' -e 's/Aug/08/' -e 's/Sep/09/' -e 's/Oct/10/' -e 's/Nov/11/' -e 's/Dec/12/' | \
                sed 's/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/g'
            fi
            ;;
        "7")
            read -p "Please enter the 'user id'(1~943): " userID
            movieList=$(cat $2 | awk -F '\t' -v uID=$userID '$1==uID {print $2}' | sort -un)
            echo "$movieList" | sed -e ':a;N;$!ba;s/\n/|/g'
            echo ""

            for movieID in $(echo "$movieList" | head)
            do
                movieName=$(cat $1 | awk -F '|' -v mvID="$movieID" '$1==mvID {print $2}')
                echo "$movieID|$movieName"
            done
            ;;
        "8")
            read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " userCommand
            if [ $userCommand = "y" ]
            then 
                #20대 프로그래머의 userID 리스트 구하기
                userIDList=$(cat $3 | awk -F '|' '$2>19 && $2<30 && $4=="programmer" {print $1}')
                #echo "$userIDList"

                #조건에 맞는 user(20대 프로그래머)들이 평가한 모든 영화의 movieID 리스트 구하기
                movieIDList=""
                for userID in $userIDList
                do
                    movieIDList+=$(cat $2 | awk -F '\t' -v uID=$userID '$1==uID {print $2}')
                    movieIDList+=$'\n'
                done

                #movieIDList에 포함된 특정 영화에 대해
                for movieID in $(echo "$movieIDList" | sort -un)
                do
                    #각 movieID에 대해 rating 리스트 구하기
                    curMovieRatingListAll=$(cat $2 | awk -F '\t' -v mvID=$movieID '$2==mvID {print $1, $3}' | sort -un -k1)

                    #조건에 맞는 유저(20대 프로그래머)들만 grep으로 골라내기
                    userIDList=$(echo "$userIDList" | sed -e ':a;N;$!ba;s/\n/|/g') #grep 탐색을 위해 줄바꿈을 |로 바꾸기
                    curMovieRatingListProg=$(echo "$curMovieRatingListAll" | grep -Ew ^"$userIDList")

                    #curMovieRatingListProg에 대해 평균낸 후 출력
                    curMovieAve=$(echo "$curMovieRatingListProg" | awk '{sum += $2} END {print sum/NR}')
                    echo "$movieID $curMovieAve"
                done
            fi
            ;;
        "9")
            echo "Bye!" 
            exit 0
            ;;
        *)
            echo "Please enter valid number between 0 and 9"
            ;;
    esac
done