import numpy as np
import pandas as pd
from pandas import Series, DataFrame


#csv 파일 불러오기
kbo_data = pd.read_csv("./2019_kbo_for_kaggle_v2.csv")

#Print the top 10 players in hits (안타, H), batting average (타율, avg), homerun (홈런, HR), and onbase percentage (출루율, OBP) for each year from 2015 to 2018.
print("\n\nRequirements 1. ")

#4가지 지표 선택을 위한 튜블 선언
prob1_label = 'H', 'avg', 'HR', 'OBP'
rank_label = '1등', '2등', '3등', '4등', '5등', '6등', '7등', '8등', '9등', '10등'

for i in range(2015,2019):
    #dataframe 선언 -> 특정 연도에 대한 각 지표별 top 10 player 정보를 저장할 객체
    top_10_player = pd.DataFrame(columns=prob1_label, index=rank_label)

    #특정 연도에 대한 데이터만 추출
    temp_data = kbo_data[kbo_data['year']==i] 

    #4가지 지표 각각에 대해 top 10 player 계산
    for j in range(4):
        #4가지 지표(H, ave, HR, OBP)중 하나 추출
        spec_top_10_player = temp_data.loc[: ,['batter_name', prob1_label[j]]]

        #선택된 지표에 대해 상위 10명의 선수를 뽑아 리스트로 변환
        spec_top_10_player = spec_top_10_player.sort_values(ascending=False, by=[prob1_label[j]])
        spec_top_10_player = spec_top_10_player.loc[:, 'batter_name'].iloc[:10]

        #top_10_player에 추가
        top_10_player[prob1_label[j]] = pd.Series(spec_top_10_player.values, index=rank_label)
        
    print("\ntop 10 players for", i)
    print(top_10_player.T)



#Print the player with the highest war (승리 기여도) by position (cp) in 2018
print("\n\nRequirements 2. ")

#tuple 선언 -> 모든 포지션 정보를 저장할 객체
cp_label = kbo_data.loc[: , ['cp']]
cp_label = cp_label.drop_duplicates().sort_values(by='cp')
cp_label = tuple(cp_label.values.T[0].tolist())

#2018에 대한 데이터만 추출하기
temp_data = kbo_data[kbo_data['year']==2018] 

#dataframe 선언 -> 각 포지션 별로 승리기여도가 가장 높은 선수 정보를 저장할 객체
highest_cp = pd.DataFrame(columns=cp_label, index=['batter_name', 'war'])

#각 포지션 별로 승리기여도가 가장 높은 선수 추출
for i in range(len(cp_label)):
    #특정 포지션에 대한 데이터만 추출
    spec_highest_cp = temp_data.loc[: , ['batter_name', 'war', 'cp']]
    spec_highest_cp = spec_highest_cp[spec_highest_cp['cp']==cp_label[i]]
    
    #승리기여도가 가장 높은 선수를 찾아 highest_cp에 추가
    spec_highest_cp_idx = spec_highest_cp['war'].idxmax()
    highest_cp[cp_label[i]] = pd.Series(spec_highest_cp.loc[spec_highest_cp_idx, ])
    
print(highest_cp)


#Among R (득점), H (안타), HR (홈런), RBI (타점), SB (도루), war (승리 기여도), avg (타율), OBP(출루율), and SLG (장타율), which has the highest correlation with salary (연봉)?
print("\n\nRequirements 3. ")

#4가지 지표 선택을 위한 튜블 선언
prob3_label = 'salary', 'R', 'H', 'HR', 'RBI', 'SB', 'war', 'avg', 'OBP', 'SLG'

#상관관계를 구할 대상만 추출
temp_data = kbo_data.loc[: , prob3_label]

#salary에 대한 상관관계 산출
corr_with_salary = temp_data.corr()['salary'].sort_values(ascending=False)
corr_with_salary = corr_with_salary.iloc[1:] #0번째 값은 자기 자신이므로 제외

#가장 높은 상관계수를 갖는 지표 출력
highest_corr_index = corr_with_salary.index[0]
highest_corr_value = corr_with_salary.iloc[0]
print("the highest correlation with salary is", highest_corr_index, "(", highest_corr_value, ")")
