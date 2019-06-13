def coinChange(self, coins, amount):
    """
    :type coins: List[int]
    :type amount: int
    :rtype: int
    """
    n = amount
    change = amount # int
    #coins  # arr of ints
    coins.insert(0, 0)
    infinity = 10000000000

    matrix  = []
    for i in range(len(coins) + 1):
        helper = []
        for j in range(change + 1):
            helper.append(0)
        matrix.append(helper)

    for i in range(n + 1):
        matrix[0][i] = infinity

    for i in range(1, len(coins)):
        for j in range(1, change):
            if j - coins[i] < 0:
                matrix[i][j] = matrix[i-1][j]
            else:
                matrix[i][j] = min(matrix[i][j - coins[i]]+1, matrix[i-1][j]) 

            # print(matrix[i][j])

    #print("res", matrix[1][1])
    
    if (matrix[-1][-1] == infinity):
        return -1
    else:
        return matrix[-1][-1]


def coinChange(self, coins, amount):
    inf = 100000000000
    dp = [0] + ([inf] * amount)
    
    for i in range(len(coins)):
        for j in range(1, len(dp)):
            if j - coins[i] >= 0:
                dp[j] = min(dp[j], dp[j-coins[i]] + 1)
    
    if (dp[-1] >= inf):
        return -1
    else:
        return dp[-1]
                