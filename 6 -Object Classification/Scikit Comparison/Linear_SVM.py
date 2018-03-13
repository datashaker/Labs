__author__ = 'chaouki boufenar'

from sklearn.svm import SVC
import numpy as np
from sklearn import cross_validation
from sklearn.grid_search import GridSearchCV

X = []
y = []
with open(".\\File_Features.txt", "r") as g:
    line = g.readline()
    while line:
        tmp = line.split(",")
        X.append(map(float, tmp[:-1]))
        y.append(tmp[-1].replace("\n", ""))
        line = g.readline()

# Features matrix
X=np.array(X) # Data vector
y=np.array(y) # Label vector
n_samples=len(X) # Number of characters in our dataset = 5600 characters
print "\nLinear SVM parameter tuning using grid search with 10-fold cross-validation ...\n"
clflsvc=SVC('linear')
Crange=np.logspace(-3,3,40) # step = 40 , Scale = logarithmic

grid_Lsvc=GridSearchCV(clflsvc,param_grid={'C':Crange},scoring='accuracy',cv=10)
best_C=(grid_Lsvc.fit(X,y).best_params_.items())[0][1]

print "Best parameter choice: C =", best_C
rate="{0:.2f}".format(np.mean(cross_validation.cross_val_score(SVC(C=best_C, kernel='linear'),X,y,cv=10))*100)
print "\nRecognition Rate with Linear_SVM classifier over best parameter choice =",rate,"%"

