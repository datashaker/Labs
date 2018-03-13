import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.grid_search import GridSearchCV
from sklearn import cross_validation

X = []
y = []
with open(".\\File_Features.txt", "r") as g:
    line = g.readline()  # read a new line
    while line:  # while a line is not empty
        tmp = line.split(",")
        X.append(map(float, tmp[:-1]))
        y.append(tmp[-1].replace("\n", ""))
        line = g.readline()

# Fetures matrix
X=np.array(X)
y=np.array(y)
n_samples=len(X)

clfRF=RandomForestClassifier()

Erange=[]
for i in range (1,21,1):
    Erange.append(i)

# Parameter estimation using grid search with k-fold cross-validation
print "\n Random Forest (RF) parameter tuning using grid search with 10-fold cross-validation ...\n"

grid_RF=GridSearchCV(clfRF,param_grid={'n_estimators':Erange},scoring='f1_weighted',cv=10) # cv : k-fold
best=(grid_RF.fit(X,y).best_params_.items())[0][1] # best number of estimators
print "Best parameter choice : n_estimators =", best,"\n"

rate= "{0:.2f}".format(np.mean(cross_validation.cross_val_score(RandomForestClassifier(n_estimators=best),X,y,cv=10))*100)
print "Recognition rate with Random Forest classifier over best parameter choice : ", rate,"%"







