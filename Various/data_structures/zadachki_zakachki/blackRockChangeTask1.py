# -*- coding: utf-8 -*-
import sys

for line in sys.stdin:
    #print line,
    continue

d = {
    'PENNY': 0.01,
    'NICKEL': 0.05,
    'DIME': 0.10,
    'QUARTER': 0.25,
    'HALF DOLLAR': 0.50,
    'ONE': 1.00,
    'TWO': 2.00,
    'FIVE': 5.00,
    'TEN': 10.00,
    'TWENTY': 20.00,
    'FIFTY': 50.00,
    'ONE HUNDRED': 100.00
}

register = [100.0, 50.0, 20.0, 10.0, 5.0, 2.0, 1.0, 0.5, 0.25, 0.1, 0.05, 0.01]
    
l = line.rstrip()    
temp = l.split(';')

tempNum = list(map(float, temp))
change = tempNum[1] - tempNum[0]

if change < 0:
    print 'ERROR'
    
elif change == 0:
    print 'ZERO'

elif change > 0:    
    returned = []
    for i in register:
        while change >= i:
            returned.append(i)
            change -= i
            
    res = []        
    for i in returned:
        for key in d.keys():
            if i == d[key]:
                res.append(key)
                
                
    ans = ''
    for j in res:
        ans += j + ','
    
    finalChange = ans.rstrip(',')
    print finalChange
                


