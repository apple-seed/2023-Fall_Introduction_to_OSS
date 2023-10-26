#! /bin/bash

#메뉴창 출력
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

userChoice=0 #유저의 메뉴 선택을 담는 변수, 0으로 초기화

#9번 입력 전까지 무한반복
while true
do
    #유저로부터 메뉴 선택받기
    read -p "Enter your choice [1-9] " userChoice

    case "$userChoice" in
        "1") #Get the data of the movie identified by a specific 'movie id' from 'u.item'
            read -p "Please enter the 'movie id'(1~1682): " movieID #특정 'movie id' 입력받기 

            #awk를 이용해 해당 movieID를 가지는 영화의 정보를 출력한다.
            cat $1 | awk -F\| -v id=$movieID '$1==id {print}' 
        ;;


        "2") #Get the data of ‘action’ genre movies from 'u.item’
            read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n): " userCommand #진행 여부 묻기
            
            if [ $userCommand = "y" ]
            then 
                #action 영화는 7번 field가 1로 설정되어 있다.
                #awk를 이용해 action 장르의 영화만 추출한 뒤 head로 상위 10개만 출력한다.
                cat $1 | awk -F\| '$7==1 {print $1, $2}' | head
            fi
        ;;


        "3") #Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
            read -p "Please enter the 'movie id'(1~1682): " movieID #특정 'movie id' 입력받기 

            #awk를 이용하여 입력된 movieID과 관련된 평점 정보만 추출한다.
            movieRatingAve=$( cat $2 | awk -F '\t' -v mvID=$movieID '$2==mvID {print $3}' | \
            #awk를 이용해 평점 평균을 계산한다.
            awk '{sum += $1} END {print sum/NR}') 
            
            #print format에 맞게 출력한다.
            echo "average rating of ${movieID}: ${movieRatingAve}"
        ;;


        "4") #Delete the ‘IMDb URL’ from ‘u.item’
            read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " userCommand #진행 여부 묻기

            if [ $userCommand = "y" ]
            then 
                #head로 u.item에서 상위 10개만 뽑아낸다.
                cat $1 | head | \
                #sed를 이용해 http:로 시작하면서 )로 끝나는 문자열을 제거하고 출력한다.(""으로 치환)
                sed -E 's/http:[^\)]*\)//g'
            fi
        ;;


        "5") #Get the data about users from 'u.user’
            read -p "Do you want to get the data about users from 'u.user'?(y/n): " userCommand #진행 여부 묻기
            
            if [ $userCommand = "y" ]
            then 
                #head로 u.user에서 상위 10개만 뽑아낸다.
                cat $3 | head | 
                #sed를 이용해 gender field를 출력 형식에 맞게 치환한다.(M->male, F->female)
                sed -e 's/M/male/' -e 's/F/female/' | \
                #awk를 이용해 print format에 맞게 출력한다.
                awk -F\| '{printf("user %s is %s years old %s %s\n", $1, $2, $3, $4)}'
            fi
        ;;


        "6") #Modify the format of 'release date' in 'u.item’
            read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n): " userCommand #진행 여부 묻기
            
            if [ $userCommand = "y" ]
            then 
                #tail로 u.item에서 하위 10개만 뽑아낸다.
                cat $1 | tail | 
                #sed를 이용해 문자열로 표시된 월을 숫자로 치환한다. (ex. Jan->01)
                sed -e 's/Jan/01/' -e 's/Feb/02/' -e 's/Mar/03/' -e 's/Apr/04/' -e 's/May/05/' -e 's/Jun/06/'  \
                    -e 's/Jul/07/' -e 's/Aug/08/' -e 's/Sep/09/' -e 's/Oct/10/' -e 's/Nov/11/' -e 's/Dec/12/' | \
                #sed를 이용해 print format에 맞게 '일-월-년' 패턴을 '년월일' 패턴으로 치환한다.
                sed 's/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/g'
            fi
        ;;


        "7") #Get the data of movies rated by a specific 'user id' from 'u.data'
            read -p "Please enter the 'user id'(1~943): " userID #특정 'user id' 입력받기

            #awk를 이용해 u.data에서 해당 userID인 사람이 평점을 준 영화 리스트를 추출한다.
            #sort를 이용해 movieID를 정렬하되, -u 옵션을 주어 중복된 movieID는 제거되도록 한다.
            movieList=$(cat $2 | awk -F '\t' -v uID=$userID '$1==uID {print $2}' | sort -un)
            
            #첫번째 print format에 맞게 줄바꿈 대신 | 로 구분하여 출력한다.
            echo "$movieList" | sed -e ':a;N;$!ba;s/\n/|/g'
            echo ""

            #조건에 맞는 상위 10개의 영화에 대해
            for movieID in $(echo "$movieList" | head)
            do
                #awk를 이용해 u.item에서 해당 movieID를 가지는 영화를 찾는다.
                movieName=$(cat $1 | awk -F '|' -v mvID="$movieID" '$1==mvID {print $2}')
                #두번째 print format에 맞게 movie id와 movie title을 출력한다.
                echo "$movieID|$movieName"
            done
        ;;


        "8") #Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
            read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " userCommand #진행 여부 묻기
            if [ $userCommand = "y" ]
            then 
                #awk를 이용해 u.user에서 20대 프로그래머들의 userID를 추출한다.
                userIDList=$(cat $3 | awk -F '|' '$2>19 && $2<30 && $4=="programmer" {print $1}')

                #awk를 이용해 u.item에서 20대 프로그래머들이 평가한 모든 영화들의 movieID를 추출한다.
                movieIDList=""
                for userID in $userIDList
                do
                    movieIDList+=$(cat $2 | awk -F '\t' -v uID=$userID '$1==uID {print $2}')
                    movieIDList+=$'\n'
                done

                #중복을 제거한 movieIDList의 모든 영화에 대해
                for movieID in $(echo "$movieIDList" | sort -un)
                do
                    #해당 movieID과 관련된 평점 정보만 추출한다. 
                    curMovieRatingListAll=$(cat $2 | awk -F '\t' -v mvID=$movieID '$2==mvID {print $1, $3}')

                    #grep을 이용해 curMovieRatingListAll 중 조건에 맞는 유저(20대 프로그래머)와 관련된 정보만 추출한다.
                    userIDList=$(echo "$userIDList" | sed -e ':a;N;$!ba;s/\n/|/g') #grep 탐색을 위해 userIDList의 구분자를 줄바꿈에서 |로 바꾼다.
                    curMovieRatingListProg=$(echo "$curMovieRatingListAll" | grep -Ew ^"$userIDList") #각 행의 시작 문자열(userID)이 userIDList 중 하나와 일치한다면 추출한다.

                    #awk를 이용해 해당 movieID의 평점 평균을 계산한다.
                    curMovieAve=$(echo "$curMovieRatingListProg" | awk '{sum += $2} END {print sum/NR}')
                    #print format에 맞게 출력한다.
                    echo "$movieID $curMovieAve"
                done
            fi
        ;;


        "9") #Exit
            echo "Bye!" 
            exit 0
        ;;


        *) #0~9 외의 문자열이 입력되었다면 
            echo "Please enter valid number between 0 and 9"
        ;;
    esac
done
