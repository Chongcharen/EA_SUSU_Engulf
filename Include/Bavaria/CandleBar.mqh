//+------------------------------------------------------------------+
//|                                                    CandleBar.mqh |
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
class CandleBar
  {
private:

public:
// information Bar
   double open;
   double close;
   double low;
   double high;
   double highBar;
   double signalPrice;
   int direction;
   int pointCal;
   double gap;
   bool isBull;
   bool barUp;
   bool barDown;
   
                     CandleBar();
                    ~CandleBar();
                     void SetCandle(int indexTime);
  };  
  
void CandleBar::SetCandle(int indexTime){
switch(Digits)
  {
   case 3:
     pointCal = 1000;
     break;
   case 4:
     pointCal = 10000;
     break;
     case 5:
     pointCal = 100000;
     break;
  }
   open = Open[indexTime];
   close = Close[indexTime];
   low = Low[indexTime];
   high = High[indexTime];
   highBar = MathAbs(high - low)*pointCal;
   isBull = ((open - close) > 0)? true : false;
   direction = (isBull) ? 1 : -1;
   signalPrice = (open+close)/2;
   gap = close-open;
   
   barUp = (high - open > 0)? true : false;
   barDown = (low - open < 0) ? true :false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleBar::CandleBar()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleBar::~CandleBar()
  {
  }
//+------------------------------------------------------------------+
