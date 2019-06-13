n,m=map(int,input().split())
arr=list(map(int,input().split()))
ans = -1
for i in range(0, n):
    if arr[i] == m:
        ans = i + 1
        
print(ans)