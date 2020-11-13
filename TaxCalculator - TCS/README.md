# TaxCalculator_TCS
 
Please complete the below app and share it as a git hub link. So we can evaluate your level to share to client.

Mandatory Items:
1.       It should be in git hub repo.
2.       Unit test cases through TDD  is expected

  
Exercise
Elephant Carpaccio
Instructions
1.        Development - A fixed time-box of 1 hour.
2.        Need to have unit testing and design patterns wherever possible.
3.        Ux is not important
Product

We manufacture a point of sale capable of issuing cash register tickets.

Accept 4 inputs from the user for one or many items : * Label of item * Quantity of item * Price of item * letter state code

With a given 2 letters state code, we can compute the tax rate

With total price (without tax) we can compute a discount see tabular at end of subject.

Output the recipe like :
label of item     Quantity   Unit price   Total price
label of item     Quantity   Unit price   Total price
  
-----------------------------------------------------
Total without taxes                             XXXXX
Discout X%                                       -YYY
Tax Y%                                           +ZZZ
-----------------------------------------------------
Total price                                    XXXXXX

Order value
Discount rate
> 1000
3%
> 5000
5%
> 7000
7%
> 10000
10%
> 50000
15%

| State | Tax rate | | UT | 6.85% | | NV | 8.00% | | TX | 6.25% | | AL | 4.00% | | CA | 8.25% |

For other state tax rate see : https://en.wikipedia.org/wiki/Sales_taxes_in_the_United_States
