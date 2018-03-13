from sklearn.naive_bayes import GaussianNB
import numpy as np
from sklearn import cross_validation
X = []
y = []
with open(".\\File_Features.txt", "r") as g:
    line = g.readline()  # read line
    while line:  # while line is not empty
        tmp = line.split(",")
        X.append(map(float, tmp[:-1]))
        y.append(tmp[-1].replace("\n", ""))
        line = g.readline()

# Feature matrix
X=np.array(X) # Data vector
y=np.array(y) # Label vector
n_samples=len(X) # Number of characters in our dataset = 5600

rate="{0:.2f}".format(np.mean(cross_validation.cross_val_score(GaussianNB(),X,y,cv=10,scoring='f1_weighted'))*100)
print "\nRecognition Rate with Naive Bayes classifier =",rate,"%"

