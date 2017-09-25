//+------------------------------------------------------------------+
//|                                                 MoneyManager.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MoneyManager
  {
private:

public:
   double priceForUse;
   double takeProfit;
   double stopLoss;
   int lotPoint;
                     MoneyManager();
                    ~MoneyManager();
                     double GetMoneyPlay(double lotStart,int moneyToupMM,int _strength,bool _useMM,int countBranch);
                     double GetLot(double lotStart,int moneyToupMM);
  };
double MoneyManager::GetLot(double lotStart , int moneyToupMM){
   double lot = NormalizeDouble(((AccountEquity()*lotStart)/moneyToupMM),2);
    if(lot < lotStart){
      lot = lotStart;
    }
   return lot;
}
double MoneyManager::GetMoneyPlay(double lotStart,int moneyToupMM,int _strength, bool _useMM,int countBranch){
switch(Digits)
  {
   case 3:
     lotPoint = 1000;
     break;
   case 4:
     lotPoint = 10000;
     break;
     case 5:
     lotPoint = 100000;
     break;
  }
  
  if(_useMM)
    {
   //  priceForUse = (AccountEquity()*0.00001)+(countBranch+(countBranch+1)*lotStart)*_strength;
   
      priceForUse = GetLot(lotStart,moneyToupMM)*((countBranch+(countBranch)+1))*_strength;
     // Print("Babalance ",((countBranch+(countBranch+1)*lotStart)));
    //  Print("price for use ",priceForUse);
    }else
       {
        priceForUse = (lotStart*((countBranch+(countBranch)+1)))*_strength;
       }
   
  
   if(priceForUse < lotStart){
     priceForUse = lotStart;
   }
  // Print("lot ",priceForUse);
   return priceForUse;
}


  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MoneyManager::MoneyManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MoneyManager::~MoneyManager()
  {
    priceForUse = (AccountBalance()/100)*Point;
  }
//+------------------------------------------------------------------+
