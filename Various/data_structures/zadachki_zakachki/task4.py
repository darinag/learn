def missing(x):
z=[a for a in range(x[0],x[-1])]
return (list(c for c in z if c not in x))

print(missing([1,2,3,4,6,7,10]))
print(missing([10,11,12,14,17]))