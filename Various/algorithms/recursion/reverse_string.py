def rev(s):
    # base case
    if len(s) <= 1:
        return s

    # recursive case
    return rev(s[1:]) + s[0]


# 'abc' --> 'c' + rev('ab') --> 'cb' 'a'

'''
RUN THIS CELL TO TEST YOUR FUNCTION AGAINST SOME TEST CASES
'''

from nose.tools import assert_equal

class TestReverse(object):
    
    def test_rev(self,solution):
        assert_equal(solution('hello'),'olleh')
        assert_equal(solution('hello world'),'dlrow olleh')
        assert_equal(solution('123456789'),'987654321')
        
        print('PASSED ALL TEST CASES!')
        
# Run Tests
test = TestReverse()
test.test_rev(reverse)
