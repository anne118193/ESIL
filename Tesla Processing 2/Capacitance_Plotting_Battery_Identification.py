import numpy
import statistics
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

#you will need to run Tesla_Processing_Battery_Identification.py 1st and then copy paste the capacity values in (annoying ik)
Cap13 = [187.20086151, 186.87922311, 187.28763808, 186.88395959, 187.13236877, 187.1115934 ]
Cap1 = [189.75840796, 189.00691331, 189.42443167, 188.9208769, 189.6166473, 189.33821521]



Cap7 = [182.21788795, 181.07284964, 181.9890806, 181.20438228, 181.55150681, 181.91390666]
Cap2 = [181.15539526, 180.92867144, 181.44721062, 181.38422831, 181.2265288, 181.5563293]
Cap6 = [181.14521694, 181.39616656, 181.49654839,181.26666285, 181.49751227, 181.35535195]

std_13 = statistics.stdev(Cap13)
std_1 = statistics.stdev(Cap1)
std_7 = statistics.stdev(Cap7)
std_2 = statistics.stdev(Cap2)
std_6 = statistics.stdev(Cap6)

mean_13 = sum(Cap13)/len(Cap13)
mean_1 = sum(Cap1)/len(Cap1)
mean_7 = sum(Cap7)/len(Cap7)
mean_2 = sum(Cap2)/len(Cap2)
mean_6 = sum(Cap6)/len(Cap6)

print("standard dev T1-1 ", std_1)
print("standard dev T1-13 ",std_13)
print("standard dev orig 1", std_7)
print("standard dev orig 2", std_2)
print("standard dev orig 3", std_6)
print("mean T1-1 ", mean_1)
print("mean T1-13 ", mean_13)
print("mean T1-7", mean_7)
print("mean T1-2", mean_2)
print("mean T1-6", mean_6)

plt.plot(Cap13, label="T1-13")
plt.plot(Cap1, label="T1-1")
plt.plot(Cap7, label="T1-7")
plt.plot(Cap2, label="T1-2")
plt.plot(Cap6, label="T1-6")
plt.legend(loc='best')
plt.title("capacity")
plt.xlabel("cells")

plt.show()
