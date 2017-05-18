#include<iostream>
#include<vector>
#include<algorithm>
#include<set>
#include<limits.h>
using namespace std;
/*416. Partition Equal Subset Sum
  Given a non-empty array containing only positive integers, find if the array can be partitioned
  into two subsets such that the sum of elements in both subsets is equal.
  Note:
  Each of the array element will not exceed 100.
  The array size will not exceed 200.
  Example 1:

  Input: [1, 5, 11, 5]

  Output: true

  Explanation: The array can be partitioned as [1, 5, 5] and [11].
  Example 2:

  Input: [1, 2, 3, 5]

  Output: false

  Explanation: The array cannot be partitioned into equal sum subsets.
*/
bool canPartition(vector<int>& nums) {
  if(nums.size()<=1)
    {
      return false;
    }
  int sum=0;
  int n=nums.size();
  for(int i=0;i<n;++i)
    {
      sum+=nums[i];
    }
  if(sum%2!=0)
    {
      return false;
    }
  sum/=2;
  vector<bool>dp(sum,false);
  dp[0]=true;
  for(int i=1;i<=n;++i)
    {
      for(int j=sum;j>=nums[i-1];--j)
        {
          dp[j]=dp[j] || dp[j-nums[i-1]];
        }
    }
  return dp[sum];
        
}
/*413. Arithmetic Slices
  A sequence of number is called arithmetic if it consists of at least three elements and if the
  difference between any two consecutive elements is the same.
  For example, these are arithmetic sequence:

  1, 3, 5, 7, 9
  7, 7, 7, 7
  3, -1, -5, -9
  The following sequence is not arithmetic.

  1, 1, 2, 5, 7

  A zero-indexed array A consisting of N numbers is given. A slice of that array is any pair of integers (P, Q) such that 0 <= P < Q < N.

  A slice (P, Q) of array A is called arithmetic if the sequence:
  A[P], A[p + 1], ..., A[Q - 1], A[Q] is arithmetic. In particular, this means that P + 1 < Q.

  The function should return the number of arithmetic slices in the array A.


  Example:

  A = [1, 2, 3, 4]

  return: 3, for 3 arithmetic slices in A: [1, 2, 3], [2, 3, 4] and [1, 2, 3, 4] itself.
*/
int numberOfArithmeticSlices(vector<int>& A) {
  int ret=0,n=A.size();
  vector<int> dp(n,0);
  for(int i=2;i<n;++i)
    {
      if(A[i-1]-A[i-2] == A[i]-A[i-1])
        {
          dp[i]=dp[i-1]+1;
          ret+=dp[i];
        }
    }
  return ret;
}
/*410. Split Array Largest Sum
  Given an array which consists of non-negative integers and an integer m, you can split the array
  into m non-empty continuous subarrays. Write an algorithm to minimize the largest sum among these m subarrays.
  Note:
  Given m satisfies the following constraint: 1 ≤ m ≤ length(nums) ≤ 14,000.

  Examples:

  Input:
  nums = [7,2,5,10,8]
  m = 2

  Output:
  18

  Explanation:
  There are four ways to split nums into two subarrays.
  The best way is to split it into [7,2,5] and [10,8],
  where the largest sum among the two subarrays is only 18.

*/
int splitArray(vector<int>& nums, int m) {
  int L=nums.size();
  long *S=new long[L+1];
  S[0]=0;
  for(int i=0;i<L;++i)
    S[i+1]=S[i]+nums[i];
  long  *dp=new long [L];
  for(int i=0;i<L;++i)
    dp[i]=S[L]-S[i];
  for(int s=1;s<m;++s)
    for(int i=0;i<L;++i)
      {
        dp[i]=S[L];
        for(int j=i+1;j<L;++j)
          {
            long long int tmp=S[j]-S[i];
            long long int max=tmp>dp[j]?tmp:dp[j];
            if(max<=dp[i])
              dp[i]=max;
            else
              break;
          }
      }
  return (int)dp[0];
}
/*403. Frog Jump
  A frog is crossing a river. The river is divided into x units and at each unit there may or may not exist a stone. The frog can jump on a stone, but it must not jump into the water.

  Given a list of stones' positions (in units) in sorted ascending order, determine if the frog is able to cross the river by landing on the last stone. Initially, the frog is on the first stone and assume the first jump must be 1 unit.

  If the frog's last jump was k units, then its next jump must be either k - 1, k, or k + 1 units. Note that the frog can only jump in the forward direction.

  Note:

  The number of stones is ≥ 2 and is < 1,100.
  Each stone's position will be a non-negative integer < 2^31.
  The first stone's position is always 0.
  Example 1:

  [0,1,3,5,6,8,12,17]

  There are a total of 8 stones.
  The first stone at the 0th unit, second stone at the 1st unit,
  third stone at the 3rd unit, and so on...
  The last stone at the 17th unit.

  Return true. The frog can jump to the last stone by jumping 
  1 unit to the 2nd stone, then 2 units to the 3rd stone, then 
  2 units to the 4th stone, then 3 units to the 6th stone, 
  4 units to the 7th stone, and 5 units to the 8th stone.
  Example 2:

  [0,1,2,3,4,8,9,11]

  Return false. There is no way to jump to the last stone as 
  the gap between the 5th and 6th stone is too large.

*/
int find(vector<int> s,int d)
{
  int l=0,r=s.size()-1;
  while(l<=r){
    int mid=(l+r)/2;
    if(s[mid]==d){
      return mid;
    }else if(s[mid]>d){
      r=mid-1;
    }else{
      l=mid+1;
    }
  }
  return -1;
}
bool canCross(vector<int>&stones)
{
  int n=stones.size();
  vector<set<int> > dp;
  dp.resize(n);
  dp[0].insert(1);
  for(int i=0;i<n;++i){
    for(set<int>::iterator it=dp[i].begin();it!=dp[i].end();++it){
      int k= *it;
      int cur=stones[i];
      int fi=find(stones,k+cur);
      if(fi!=-1){
        dp[fi].insert(k);
      }
      k--;
      if(k>0 && i!=0){
        fi=find(stones,k+cur);
        if(fi!=-1){
          dp[fi].insert(k);
        }
      }
      k+=2;
      fi=find(stones,k+cur);
      if(fi!=-1 && i!=0){
        dp[fi].insert(k);
      }
    }
  }
  return dp[n-1].size()>0?true:false;
}
/*392. Is Subsequence
  Given a string s and a string t, check if s is subsequence of t.

  You may assume that there is only lower case English letters in both s and t. t is potentially a very long (length ~= 500,000) string, and s is a short string (<=100).

  A subsequence of a string is a new string which is formed from the original string by deleting some (can be none) of the characters without disturbing the relative positions of the remaining characters. (ie, "ace" is a subsequence of "abcde" while "aec" is not).
  Example 1:
  s = "abc", t = "ahbgdc"

  Return true.

  Example 2:
  s = "axc", t = "ahbgdc"

  Return false.
*/
bool isSubsequence(string s, string t) {
  if(s=="")
    {
      return true;
    }
  int ns=s.size();
  int nt=t.size();
  int i=0,j=0;
  while(i<ns && j<nt)
    {
      if(s[i]==t[j])
        {
          i++;
          j++;
        }
      else
        {
          j++;
        }
      if(i==ns)
        {
          return true;
        }
    }
  return false;
}
/*377. Combination Sum IV
  Given an integer array with all positive numbers and no duplicates, find the number of possible combinations that add up to a positive integer target.
  Example:

  nums = [1, 2, 3]
  target = 4

  The possible combination ways are:
  (1, 1, 1, 1)
  (1, 1, 2)
  (1, 2, 1)
  (1, 3)
  (2, 1, 1)
  (2, 2)
  (3, 1)

  Note that different sequences are counted as different combinations.

  Therefore the output is 7.
*/
int combinationSum4(vector<int>& nums, int target) {
  vector<int> result(target + 1);
  result[0] = 1;
  for (int i = 1; i <= target; ++i) {
    for (int j=0;j<nums.size();++j) {
      if (i >= nums[j]) {
        result[i] += result[i - nums[j]];
      }
    }
  }
        
  return result[target];
}
/*376. Wiggle Subsequence
  A sequence of numbers is called a wiggle sequence if the differences between successive numbers strictly alternate between positive and negative. The first difference (if one exists) may be either positive or negative. A sequence with fewer than two elements is trivially a wiggle sequence.

  For example, [1,7,4,9,2,5] is a wiggle sequence because the differences (6,-3,5,-7,3) are alternately positive and negative. In contrast, [1,4,7,2,5] and [1,7,4,5,5] are not wiggle sequences, the first because its first two differences are positive and the second because its last difference is zero.

  Given a sequence of integers, return the length of the longest subsequence that is a wiggle sequence. A subsequence is obtained by deleting some number of elements (eventually, also zero) from the original sequence, leaving the remaining elements in their original order.
  Examples:
  Input: [1,7,4,9,2,5]
  Output: 6
  The entire sequence is a wiggle sequence.

  Input: [1,17,5,10,13,15,10,5,16,8]
  Output: 7
  There are several subsequences that achieve this length. One is [1,17,10,13,10,16,8].

  Input: [1,2,3,4,5,6,7,8,9]
  Output: 2
*/
int wiggleMaxLength(vector<int>& nums) {
  if (nums.size() < 2)
    return nums.size();
  int down = 1, up = 1;
  for (int i = 1; i < nums.size(); i++) {
    if (nums[i] > nums[i - 1])
      up = down + 1;
    else if (nums[i] < nums[i - 1])
      down = up + 1;
  }
  return max(down, up);
}
/*375. Guess Number Higher or Lower II
  We are playing the Guess Game. The game is as follows:

  I pick a number from 1 to n. You have to guess which number I picked.

  Every time you guess wrong, I'll tell you whether the number I picked is higher or lower.

  However, when you guess a particular number x, and you guess wrong, you pay $x. You win the game when you guess the number I picked.
  Example:

  n = 10, I pick 8.

  First round:  You guess 5, I tell you that it's higher. You pay $5.
  Second round: You guess 7, I tell you that it's higher. You pay $7.
  Third round:  You guess 9, I tell you that it's lower. You pay $9.

  Game over. 8 is the number I picked.

  You end up paying $5 + $7 + $9 = $21
*/
int getMoneyAmount(int n) {
  int ** table=new int*[n+1];
  for(int i=0;i<n+1;++i)
    table[i]=new int[n+1];
  for(int j=2; j<=n; j++){
    for(int i=j-1; i>0; i--){
      int globalMin = INT_MAX;
      for(int k=i+1; k<j; k++){
        int localMax = k + max(table[i][k-1], table[k+1][j]);
        globalMin = min(globalMin, localMax);
      }
      table[i][j] = i+1==j?i:globalMin;
    }
  }
  return table[1][n];
}
/*368. Largest Divisible Subset
  Given a set of distinct positive integers, find the largest subset such that every pair (Si, Sj) of elements in this subset satisfies: Si % Sj = 0 or Sj % Si = 0.

  If there are multiple solutions, return any subset is fine.
  Example 1:

  nums: [1,2,3]

  Result: [1,2] (of course, [1,3] will also be ok)
  Example 2:

  nums: [1,2,4,8]

  Result: [1,2,4,8]
*/
vector<int> largestDivisibleSubset(vector<int>& nums) {
  if(nums.size()<1)
    return nums;
  sort(nums.begin(),nums.end());
  int n=nums.size();
  vector<int> dp(n,0),parent(n,-1);
  int max=1,index=0;
  dp[0]=1;
  for(int i=1;i<n;++i)
    for(int j=0;j<i;++j)
      {
        if(nums[i]%nums[j]==0 && dp[j]+1>=dp[i])
          {
            dp[i]=dp[j]+1;
            parent[i]=j;
          }
        if(dp[i]>=max)
          {
            max=dp[i];
            index=i;
          }
      }
  vector<int> ret;
  ret.push_back(nums[index]);
  while(index!=-1)
    {
      if(parent[index]!=-1)
        {
          ret.insert(ret.begin(),nums[parent[index]]);
        }
      index=parent[index];
    }
  return ret;
}
/*363. Max Sum of Rectangle No Larger Than K
  Given a non-empty 2D matrix matrix and an integer k, find the max sum of a rectangle in the matrix such that its sum is no larger than k.
  Example:
  Given matrix = [
  [1,  0, 1],
  [0, -2, 3]
  ]
  k = 2
*/
int maxSumSubmatrix(vector<vector<int> >& matrix, int k) {
  if (matrix.empty()) return 0;
  int row = matrix.size(), col = matrix[0].size(), res = INT_MIN;
  for (int l = 0; l < col; ++l) {
    vector<int> sums(row, 0);
    for (int r = l; r < col; ++r) {
      for (int i = 0; i < row; ++i) {
        sums[i] += matrix[i][r];
      }
      // Find the max subarray no more than K 
      set<int> accuSet;
      accuSet.insert(0);
      int curSum = 0, curMax = INT_MIN;
      for (int sum : sums) {
        curSum += sum;
        set<int>::iterator it = accuSet.lower_bound(curSum - k);
        if (it != accuSet.end()) curMax = std::max(curMax, curSum - *it);
        accuSet.insert(curSum);
      }
      res = std::max(res, curMax);
    }
  }
  return res;
}
/*357. Count Numbers with Unique Digits
  Given a non-negative integer n, count all numbers with unique digits, x, where 0 ≤ x < 10^n.
  Example:
  Given n = 2, return 91. (The answer should be the total numbers in the range of 0 ≤ x < 100, excluding [11,22,33,44,55,66,77,88,99])
*/
int countNumbersWithUniqueDigits(int n) {
  if(n==0)
    return 1;
  if(n==1)
    return 10;
  if(n<11)
    return (countNumbersWithUniqueDigits(n-1)-countNumbersWithUniqueDigits(n-2))*(11-n)
      +countNumbersWithUniqueDigits(n-1);
  return countNumbersWithUniqueDigits(10);
}
/*354. Russian Doll Envelopes
  You have a number of envelopes with widths and heights given as a pair of integers (w, h). One envelope can fit into another if and only if both the width and height of one envelope is greater than the width and height of the other envelope.

  What is the maximum number of envelopes can you Russian doll? (put one inside other)

  Example:
  Given envelopes = [[5,4],[6,4],[6,7],[2,3]], the maximum number of envelopes you can Russian doll is 3 ([2,3] => [5,4] => [6,7]).

  Subscribe to see which companies asked this question*/
//这里有一个trick，如果使用二分的方法，首先对first排序，对于first相等的把对应second大的放在前面，但是我写的nlogn竟然没有ac
static bool lessThen(pair<int,int>&a,pair<int,int>&b)
{
  if(a.first==b.first)
    return a.second>b.second;
  return a.first<b.first;
}
int find(vector<pair<int,int> > v,int end,pair<int,int> key)
{
  if(key.second>v[end].second){
    if(key.first>v[end].first)
      return end+1;
    else
      return -1;
  }
  int begin=0;
  while(begin<=end){
    int mid=(begin+end)/2;
    if(v[mid].second>key.second){
      end=mid-1;
    }else if(v[mid].second<key.second){
      begin=mid+1;
    }else
      return -1;
  }
  return begin;
}
int LIS(vector<pair<int,int> > v)
{
  int n=v.size();
  vector<pair<int,int> > dp(n,make_pair(-1,-1));
  int len=0;
  dp[0]=v[0];
  for(int i=1;i<n;++i){
    int ins=find(dp,len,v[i]);
    if(ins!=-1){
      dp[ins]=v[i];
      if(len<ins)
        len=ins;
    }
  }
  return len+1;
}
/*int LIS(vector<pair<int,int> > v)
  {
  int n=v.size();
  vector<int> dp(n,1);
  int max=1;
  for(int i=0;i<n;++i)
  {
  for(int j=0;j<i;++j)
  {
  if(v[j].second<v[i].second && v[j].first<v[i].first && dp[j]+1>dp[i])
  {
  dp[i]=dp[j]+1;
  if(max<dp[i])
  max=dp[i];
  }
  }
  }
  return max;
  }*/
int maxEnvelopes(vector<pair<int, int> >& en) {
  if(en.size()==0)
    return 0;
  sort(en.begin(),en.end(),lessThen);
  return LIS(en);
}
/*343. Integer Break
  Given a positive integer n, break it into the sum of at least two positive integers and maximize the product of those integers. Return the maximum product you can get.

  For example, given n = 2, return 1 (2 = 1 + 1); given n = 10, return 36 (10 = 3 + 3 + 4).

  Note: You may assume that n is not less than 2 and not larger than 58.*/
int integerBreak(int n) {
  if(n==2)
    return 1;
  if(n==3)
    return 2;
  vector<int>dp(59,0);
  dp[2]=2;
  dp[3]=3;
  for(int i=4;i<=n;++i)
    for(int j=2;j<i;++j){
      int t=dp[j]*dp[i-j];
      if(t>dp[i])
        dp[i]=t;
    }
  return dp[n];
}
/*338. Counting Bits
  Given a non negative integer number num. For every numbers i in the range 0 ≤ i ≤ num calculate the number of 1's in their binary representation and return them as an array.
  Example:
  For num = 5 you should return [0,1,1,2,1,2].
*/
vector<int> countBits(int num) {
  vector<int> v;
  v.push_back(0);
  if(num==0)
    return v;
  v.push_back(1);
  if(num==1)
    return v;
  int thre=2,j=0;
  for(int i=2;i<num+1;++i)
    {
      v.push_back(v[j++]+1);
      if(j%thre==0){
        j=0;
        thre*=2;
      }
    }
  return v;
}
/*322. Coin Change
  You are given coins of different denominations and a total amount of money amount. Write a function to compute the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return -1.
  Example 1:
  coins = [1, 2, 5], amount = 11
  return 3 (11 = 5 + 5 + 1)

  Example 2:
  coins = [2], amount = 3
  return -1.*/
int coinChange(vector<int>& coins, int amount) {
  if(amount==0)
    return 0;
  sort(coins.begin(),coins.end());
  if(amount<coins[0])
    return -1;
  vector<int> dp(amount+1,amount+1);
  for(int it:coins)
    if(it<=amount)
      dp[it]=1;
  for(int i=1;i<=amount;++i)
    for(int j=0;j<coins.size();++j)
      if(i>coins[j])
        dp[i]=min(dp[i],dp[i-coins[j]]+1);
      else
        break;
  return dp[amount]<=amount?dp[amount]:-1;
}

//AMAZING -2147483648 取反还是它自己

/*321. Create Maximum Number
  Given two arrays of length m and n with digits 0-9 representing two numbers. Create the maximum number of length k <= m + n from digits of the two. The relative order of the digits from the same array must be preserved. Return an array of the k digits. You should try to optimize your time and space complexity.
  Example 1:
  nums1 = [3, 4, 6, 5]
  nums2 = [9, 1, 2, 5, 8, 3]
  k = 5
  return [9, 8, 6, 5, 3]

  Example 2:
  nums1 = [6, 7]
  nums2 = [6, 0, 4]
  k = 5
  return [6, 7, 6, 0, 4]

  Example 3:
  nums1 = [3, 9]
  nums2 = [8, 9]
  k = 3
  return [9, 8, 9]*/
vector<int> maxArray(vector<int>& nums, int k){
  int n = nums.size();
  vector<int> result(k);
  for (int i = 0, j = 0; i < n; i++){
    while (n - i + j>k && j > 0 && result[j-1] < nums[i]) j--;
    if (j < k) result[j++] = nums[i];
  }
  return result;
}
bool greatervv(vector<int>& nums1, int i, vector<int>& nums2, int j){
  while (i < nums1.size() && j < nums2.size() && nums1[i] == nums2[j]){
    i++;
    j++;
  }
  return j == nums2.size() || (i<nums1.size() && nums1[i] > nums2[j]);
}

vector<int> merge(vector<int>& nums1, vector<int>& nums2, int k) {
  std::vector<int> ans(k);
  int i = 0, j = 0;
  for (int r = 0; r<k; r++){
    if( greatervv(nums1, i, nums2, j) ) ans[r] = nums1[i++] ;
    else ans[r] = nums2[j++];
  }
  return ans;
}
vector<int> maxNumber(vector<int>& nums1, vector<int>& nums2, int k) {
  int m = nums1.size();
  int n = nums2.size();
  vector<int> result(k);
  for (int i = std::max(0 , k - n); i <= k && i <= m; i++){
    auto v1 = maxArray(nums1, i);
    auto v2 = maxArray(nums2, k - i);
    vector<int> candidate = merge(v1, v2, k);
    if (greatervv(candidate, 0, result, 0)) result = candidate;
  }
  return result;
}
/*279. Perfect Squares
Given a positive integer n, find the least number of perfect square numbers (for example, 1, 4, 9, 16, ...) which sum to n.

For example, given n = 12, return 3 because 12 = 4 + 4 + 4; given n = 13, return 2 because 13 = 4 + 9.
*/
int numSquares(int c)
{
	vector<int> dp(c+1, INT_MAX);
	for(int i = 0; i*i <= c; ++i) {
		dp[i*i] = 1;
	}
	for (int i = 1; i < dp.size(); ++i) {
		for (int j = 1; i + j*j <= c; ++j) {
			dp[i + j*j] = min(dp[i] + 1, dp[i + j*j]);
		}
	}
	return dp[c];
}
int main()
{
  vector<int> v;
  cout<<"hello world"<<endl;
}





























