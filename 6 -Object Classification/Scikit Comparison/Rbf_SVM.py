__author__ = 'chaouki boufenar'

from sklearn.svm import SVC
import numpy as np
from sklearn.grid_search import GridSearchCV
from sklearn import cross_validation

X = []
y = []
with open(".\\File_Features.txt", "r") as g:
    line = g.readline()  # read a new line
    while line:  # while line is not empty
        tmp = line.split(",")
        X.append(map(float, tmp[:-1]))
        y.append(tmp[-1].replace("\n", ""))
        line = g.readline()

# Features matrix
X=np.array(X) # Data vector
y=np.array(y) # Labels vector
n_samples=len(X)

print "\n Rdf_SVM parameter tuning using grid search with 10-fold cross-validation ...\n"

clfrbfsvc=SVC(kernel='rbf')

Crange=np.logspace(-3,3,20)
Grange=np.logspace(-3,3,20)

grid_RBFsvc=GridSearchCV(clfrbfsvc,param_grid={'C':Crange,'gamma':Grange},scoring='average_precision',cv=10)


#scores_rbfsvc=[g[1] for g in grid_RBFsvc.grid_scores_]
best=grid_RBFsvc.fit(X,y).best_params_
best_C=(best.items())[0][1]
best_gamma=(best.items())[0][2]

print "Best parameter choice:", best_C

print "\nBest parameter choice: Gamma= ", best_gamma

rate="{0:.2f}".format(np.mean(cross_validation.cross_val_score(SVC(C=best_C, gamma=best_gamma,kernel='rbf'),X,y,cv=10))*100)
print "Recognition Rate with Rbf_SVM classifier over best parameter choice == ",rate,"%"


