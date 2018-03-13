from sklearn import tree
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
X=np.array(X) # data vector
y=np.array(y) # label vector
n_samples=len(X) # number of characters in our dataset = 5600

print "Recognition Rate with Decision Tree classifier = ","{0:.2f}".format(np.mean(cross_validation.cross_val_score(tree.DecisionTreeClassifier(),X,y,cv=10,scoring='f1_weighted'))*100),"%"


