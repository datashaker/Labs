__author__ = 'chaouki'

from sklearn.lda import LDA
import numpy as np
from sklearn import cross_validation

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
X=np.array(X)
y=np.array(y)
n_samples=len(X)

rate="{0:.2f}".format(np.mean(cross_validation.cross_val_score(LDA(),X,y,cv=10,scoring='f1_weighted')*100))
print "Recognition Rate with Linear Discriminant Analysis (LDA) classifier :",rate,"%"
