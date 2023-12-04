# Introduction_to_OSS
오픈소스SW개론 과제 제출용 깃허브입니다!

## 목차
### [:one: 1차 과제](#one-1차-과제)
Bash 쉘을 이용한 영화 및 유저관리 프로그램 구현
### [:two: 2차 과제](#목차)
판다스와 사이킷런을 이용한 야구데이터 관리 프로그램 구현

<br>
<br>
<br>
<br>

---

## :one: 1차 과제
### 개요
인자로 받은 u.item, u.data, u.user 3개의 파일을 기반으로 영화 및 유저에 대한 정보를 가공하여 출력하는 프로그램의 구현
<br>
<br>

### 기능 설명
#### 1번째 기능
사용자가 선택한 영화의 정보를 출력한다. 영화 정보는 u.item을 기반으로 한다.
#### 2번째 기능
액션 장르의 영화에 대해 movie id와 movie title을 출력한다. 단, movie id를 오름차순으로 정렬하였을 때 상위 10개만 출력한다.
#### 3번째 기능
사용자가 선택한 영화의 평균 평점을 출력한다. 평균 평점 계산은 u.data의 정보를 기반으로 한다.
#### 4번째 기능
IMDb URL 필드를 제외한 영화 정보를 출력한다. 영화 정보는 u.item을 기반으로 하되, movie id 오름차순 정렬 기준 상위 10개만 출력한다.
#### 5번째 기능
user id가 1~10인 총 10명의 유저에 대해 유저의 정보를 출력한다. 유저 정보는 u.user를 기반으로 하되, gender 필드의 형식을 M/F에서 male/female로 바꾼다.
#### 6번째 기능
movie id가 1673~1682인 총 10개의 영화에 대해 영화 정보를 출력한다. 영화 정보는 u.item을 기반으로 하되, release date 필드의 형식을 'YYYYMMDD'로 바꾼다.
#### 7번째 기능
사용자가 선택한 유저가 평점을 매긴 영화의 movie id를 모두 출력한 뒤, 그 중 상위 10개(오름차순 기준)의 영화에 대해 movie id와 movie title을 출력한다. 출력 순서는 movie id를 오름차순으로 정렬한 순서를 따른다.
#### 8번째 기능
20대(age: 20~29) 프로그래머 유저가 평가한 모든 영화에 대해 movie id와 평균 평점을 출력한다. 평균 평점은 u.data를 기반으로 계산하되, 20대 프로그래머가 평가한 평점만 고려하여 산출한다.
#### 9번째 기능
"Bye!"를 출력하고 프로그램을 종료한다.
<br>
<br>

### 작동 예시
https://github.com/apple-seed/Introduction_to_OSS/assets/81312141/ce611bb4-302d-407e-95bb-a71e692c5fce

<br>
<br>
<br>
<br>

---

## :two: 2차 과제
### 개요
2019_kbo_for_kaggle_v2.csv에 저장된 야구 정보를 가공하여 특정한 결과를 도출하는 프로그램의 구현
<br>
<br>

### 2019_kbo_for_kaggle_v2.csv
* 1991~2018년 까지의 KBO 타자 기록을 저장하고 있는 데이터 파일로, 1913개 row, 37 col을 가지고 있다.
* row 하나하나는 특정 선수의 특정 연도에서의 기록을 의미한다.
* col 하나하나는 선수 이름, 연도, 포지션 등 특징(feature)를 의미한다.
<br>
<br>

### 기능 설명
#### OSS_project_2_1_code.py
판다스를 활용하여 야구 데이터를 요구 사항에 맞게 가공한 결과를 출력한다.
* top 10 player를 뽑기: 2015~2018년까지 각 연도에 대해 안타(H), 타율(avg), 홈런(HR), 출루율(OBP) 4가지 지표 각각에 대해 top 10 player를 뽑아 출력한다.
* 포지션 별로 승리 기여도가 가장 높았던 선수 뽑기: 2018년 기준으로, 각 야구 포지션(cp) 별로 승리 기여도(war)가 가장 높았던 선수를 1명씩 출력한다.
* 해당 시즌의 연봉과 가장 상관 관계가 높은 지표 찾기: 득점(R), 안타(H), 홈런(HR), 타점(RBI), 도루(SB), 승리 기여도(war), 타율(avg)), 출루율(OBP), 장타율(SLG) 9가지 지표 각각에 대해 연봉과의 상관 관계를 구한 뒤, 가장 상관 관계가 높은 지표를 출력한다.

<br>

#### OSS_project2_2_code_template.py
사이킷런을 활용하여 야구 데이터를 기반으로, 이전 연도(~2017)까지의 데이터를 학습하여 이번 년도(2018)의 연봉을 예측하는 모델을 구현하고 성능을 평가한다. 연봉은 연속적인 값이므로 regressor 모델을 사용해야 하며, 학습에 사용되는 feature는 numerical feature만 이용한다.
* <b>sort_datasetyear:</b> 입력으로 들어온 데이터프레임을 year 컬럼에 대해 오름차순 정렬하여 반환하는 함수.
* <b>split_dataset:</b> 입력으로 들어온 데이터프레임을 train/test 데이터셋으로 분할하여 반환하는 함수. 입력으로 들어온 데이터프레임은 레이블(salary)와 데이터셋이 분리되어 있지 않으므로, 먼저 salary 컬럼을 레이블로 분리한다. 또한 salary의 본래 값이 너무 크므로 0.001을 곱하여 salary를 스케일링한 뒤 train/test 데이터셋을 1718행을 기반으로 분할한다.
* <b>extract_numerical_cols:</b> 입력으로 들어온 데이터 프레임에서 numerical columns만 추출하여 반환하는 함수. numerical columns는 'age', 'G', 'PA', 'AB', 'R', 'H', '2B', '3B', 'HR', 'RBI', 'SB', 'CS', 'BB', 'HBP', 'SO', 'GDP', 'fly', 'war’ 총 18개 열이다.
* <b>train_predict_decision_tree:</b> decision_tree 모델로 학습 후 predict를 도출하여 반환하는 함수. 
* <b>train_predict_random_forest:</b> random_forest 모델로 학습 후 predict를 도출하여 반환하는 함수.
* <b>train_predict_svm:</b> svm 모델로 학습 후 predict를 도출하여 반환하는 함수. svm은 스케일에 민감하기 때문에 스케일러와 모델을 파이프라인으로 엮은 뒤 학습시키도록 한다.
모델 3개에 대해 train and predict하는 함수 구현할 것(즉 이함수에선 예상치 결과 내야할 것)
* <b>calculate_RMSE:</b> 입력으로 예측과 레이블이 입력되면, 이에 대해 rmse를 계산하여 반환하는 함수.
