 #!/usr/bin/python
 
import numpy as np  #sudo apt-get install python-Numpy
import matplotlib.pyplot as plt #sudo apt-get install python-matplotlib

f=open("./statistic.csv","r")
datas = f.read()
rows = datas.split('\n')
mems=[]
cpuBefore=[]
cpuAfter=[]

#print rows
print ( "len:", len(rows))
for row in rows:
	#print(row)
	data = row.split(' ')
	if len(data) < 12:
		continue
	mems.append(float(data[7]))
	cpuBefore.append(float(data[9]))
	cpuAfter.append(float(data[11]))
#print(type(mems[1]))
#print(mems)
print ( "mems len:", len(mems))
index=range(1,len(mems)+1)
print ("index", len(index))
#print(index)

#print(mems)
print("memery(M): min: ",min(mems),"max: ",max(mems), " mean: ", np.mean(mems))
print("cpuBefore(%): min: ",min(cpuBefore),"max: ",max(cpuBefore), " mean: ", np.mean(cpuBefore))
print("cpuAfter(%): min: ",min(cpuAfter),"max: ",max(cpuAfter), " mean: ", np.mean(cpuAfter))

plt.figure()
plt.plot(index, mems)
plt.show()