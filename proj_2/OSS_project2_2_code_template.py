import numpy as np
import pandas as pd
from pandas import Series, DataFrame

from sklearn.model_selection import train_test_split

from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR

from sklearn.metrics import accuracy_score

def sort_dataset(dataset_df):
	#TODO: Implement this function
	#year 컬럼에 대해 오름차순 정렬
	return dataset_df.sort_values(by='year')

def split_dataset(dataset_df):	
	#TODO: Implement this function
	#salary 컬럼값에 대해 0.001을 곱하기
	dataset_df['salary'] *= 0.001

	#레이블과 데이터셋 분리
	X = dataset_df.drop(columns="salary", axis=1)
	y = dataset_df["salary"]
      
	#1718을 기점으로 데이테셋을 훈련셋과 검증셋으로 분리
	X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=1718, shuffle=False)
	return X_train, X_test, y_train, y_test

def extract_numerical_cols(dataset_df):
    #TODO: Implement this function
	#숫자 컬럼 인덱스만 뽑아내기 위해 튜플 생성
    numerical_cols = 'age', 'G', 'PA', 'AB', 'R', 'H', '2B', '3B', 'HR', 'RBI', 'SB', 'CS', 'BB', 'HBP', 'SO', 'GDP', 'fly', 'war'
    
	#데이터셋에서 숫자 컬럼만 추출
    return dataset_df.loc[: , numerical_cols]

def train_predict_decision_tree(X_train, Y_train, X_test):
	#TODO: Implement this function
	#decision_tree 모델 학습
    dt_reg = DecisionTreeRegressor()
    dt_reg.fit(X_train, Y_train)
    
	#decision_tree 모델의 예측 결과 반환
    return dt_reg.predict(X_test)

def train_predict_random_forest(X_train, Y_train, X_test):
	#TODO: Implement this function
	#random_forest 모델 학습
    rf_reg = RandomForestRegressor()
    rf_reg.fit(X_train, Y_train)
    
	#random_forest 모델의 예측 결과 반환
    return rf_reg.predict(X_test)

def train_predict_svm(X_train, Y_train, X_test):
	#TODO: Implement this function
	#svm 모델 학습
    svm_pipe = make_pipeline(
        StandardScaler(),
        SVR()
    )
    svm_pipe.fit(X_train, Y_train)
    
	#svm 모델의 예측 결과 반환
    return svm_pipe.predict(X_test)

def calculate_RMSE(labels, predictions):
	#TODO: Implement this function
	#RMSE 계산 결과 반환
    return np.sqrt((np.mean((predictions-labels)**2)))

if __name__=='__main__':
	#DO NOT MODIFY THIS FUNCTION UNLESS PATH TO THE CSV MUST BE CHANGED.
	data_df = pd.read_csv('2019_kbo_for_kaggle_v2.csv')
	
	sorted_df = sort_dataset(data_df)	
	X_train, X_test, Y_train, Y_test = split_dataset(sorted_df)
	
	X_train = extract_numerical_cols(X_train)
	X_test = extract_numerical_cols(X_test)

	dt_predictions = train_predict_decision_tree(X_train, Y_train, X_test)
	rf_predictions = train_predict_random_forest(X_train, Y_train, X_test)
	svm_predictions = train_predict_svm(X_train, Y_train, X_test)
	
	print ("Decision Tree Test RMSE: ", calculate_RMSE(Y_test, dt_predictions))	
	print ("Random Forest Test RMSE: ", calculate_RMSE(Y_test, rf_predictions))	
	print ("SVM Test RMSE: ", calculate_RMSE(Y_test, svm_predictions))