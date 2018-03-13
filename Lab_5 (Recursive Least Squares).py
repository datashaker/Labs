#coding=utf-8
import numpy as np
import matplotlib.pyplot as plt
import math

def read_array_from_file(filename):
   result_list = []
   with open(filename, "rb") as _file:
       for line in _file:
           result_list.append(float(line))
   return result_list

def generate(n, autoreg_order, average_order, factors_a, factors_b):
   """
   Generates list of numbers that is like 
   y(k) = a_0 + a_1*y(k-1) + ... + a_i*y(k-i) + v(k) + b_1*v(k-1) + ... + b_j*v(k-j),
       where i = autoreg_order (do not include a_0)
             j = average_order
             a_0,...,a_i = factors_a
             b_1,...,b_j = factors_b
             n = quantity of numbers
   """
   normal_numbers = [np.random.normal() for _ in range(n)]
   
   result = [factors_a[0]+normal_numbers[i] for i in range(n)]
   for i in range(1,n):
       for j in range(1,min(autoreg_order+1,i+1)):
           result[i]+=factors_a[j]*result[i-j]
       for j in range(1,min(average_order+1,i+1)):
           result[i]+=factors_a[j]*normal_numbers[i-j]

   return normal_numbers, result


def ROLS(n, autoreg_order, average_order, y, v):
   
   X = np.zeros(shape=(n - max(autoreg_order, average_order), 2 + autoreg_order + average_order,))
   X[..., 0] = 1

   _autoreg_columns = []

   for i in range(1, autoreg_order + 1):
       temp = []
       for k in range(max(autoreg_order, average_order), n):
           temp.append(y[k - i])
       _autoreg_columns.append(temp)

   for i in range(X.shape[0]):
       for j in range(1, autoreg_order + 1):
           X[i, j] = _autoreg_columns[j - 1][i]

   _average_columns = []

   for i in range(0, average_order + 1):
       temp = []
       for k in range(max(autoreg_order, average_order), n):
           temp.append(v[k - i])
       _average_columns.append(temp)

   
   for i in range(X.shape[0]):
       for j in range(autoreg_order + 1, 2 + autoreg_order + average_order):
           X[i, j] = _average_columns[j - 1 - autoreg_order][i]

   result = np.zeros((2 + autoreg_order + average_order,1))
   P = 10*np.identity(2 + autoreg_order + average_order)
   #e = []

   c=X.shape[1]

   for i in range(X.shape[0]):
       
       temp=np.dot(P, X[i].reshape(c,1))
       temp=np.dot(temp, X[i].reshape(1,c))
       temp=np.dot(temp, P)
       const = 1+ np.dot(np.dot(X[i].reshape(1,c), P), X[i].reshape(c,1))
       P = P - temp/const
       temp1 = (y[max(autoreg_order, average_order)+i]-np.dot(X[i].reshape(1,c),result))*np.dot(P,X[i].reshape(c,1))
       result = result + temp1

   return result


normal_numbers, values = generate(10, 2, 1, [0.1, 0.2, 0.3], [0.05])
res=ROLS(10, 2, 1, values, normal_numbers)
print (res)
coef = [0.1, 0.2, 0.3, 1, 0.05]
err=0
for i in range(5):
   err+=(coef[i]-res[i])**2
err=math.sqrt(err)
print (err)
sust=0
for i in res:
   sust+=abs(i)
print (sust)


