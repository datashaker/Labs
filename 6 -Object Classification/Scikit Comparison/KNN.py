from __future__ import division
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
from sklearn import cross_validation
from sklearn.grid_search import GridSearchCV

X = []
y = []
with open(".\\File_Features.txt", "r") as g:
    line = g.readline()  # REad a new line
    while line:  # while line is not empty
        tmp = line.split(",")
        X.append(map(float, tmp[:-1]))
        y.append(tmp[-1].replace("\n", ""))
        line = g.readline()

# Features matrix
X=np.array(X)
y=np.array(y)
n_samples=len(X)

print "\nKNN Parameter tuning using grid search with 10-fold cross-validation ...\n"
clfknn=KNeighborsClassifier()
Krange=np.linspace(1,20,20)

grid_Knn=GridSearchCV(clfknn,param_grid={'n_neighbors':Krange},scoring='accuracy',cv=10)
k_best=(grid_Knn.fit(X,y).best_params_.items())[0][1]
print "Best parameter choice: k=",k_best

print ("{0:.2f}".format(np.mean(cross_validation.cross_val_score(KNeighborsClassifier(n_neighbors=k_best),X,y,cv=10))*100)),"%"


