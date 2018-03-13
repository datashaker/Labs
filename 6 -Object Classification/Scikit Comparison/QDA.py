__author__ = 'chaouki'

from sklearn.qda import QDA
import numpy as np
from sklearn import cross_validation

X = []
y = []
with open(".\\File_Features.txt", "r") as g:
    line = g.readline() # Read a new line
    while line: # while line is not empty
        tmp = line.split(",")
        X.append(map(float, tmp[:-1]))
        y.append(tmp[-1].replace("\n", ""))
        line = g.readline()

# Features matrix
X=np.array(X) # Data vector
y=np.array(y) # Label vector
n_samples=len(X)

rate="{0:.2f}".format(np.mean(cross_validation.cross_val_score(QDA(),X,y,cv=10,scoring='f1_weighted')*100))
print "Recognition Rate with Quadratic Discriminant Analysis (QDA) classifier :",rate,"%"