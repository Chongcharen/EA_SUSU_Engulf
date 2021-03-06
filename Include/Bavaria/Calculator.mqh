//+------------------------------------------------------------------+
//|                                                   Calculator.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Bavaria/CandleBar.mqh>   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Calculator
  {
private:

public:
   double maYellow,maBlue,maRed,maPurple,maWhite,MACD,MAValue;
   int leastBars;
   bool isBull;
   bool isBear;
   bool isEnglufing;
   int strength;
   int pip;
   int trend,lotPoint;
   
   
   //
   double signalPrice;
    
   bool isHigh;
   double barHigh;
   //stoploss takeprofit
   double minstoplevel;
   double stoploss;
   double takeprofit;
   double openPrice;
   double newHigh;
   double newLow;
   // cantrade
   bool canTrade;
   bool buySloveTrade;
   bool sellSloveTrade;
   int trade_command;
   color color_trade,color_close;
   float _macdTrade;
   int maYellowHigh,averageMA,whiteFarRed;
   int diffMAYellowBlue,diffMABluePurple,diffMAPurpleRed,diffMARedWhite;
   //
   CandleBar* candleBar[];
                     Calculator();
                    ~Calculator();
   void UpdateMA();
   void SetCandle();
   double GetTakeProfit();
   void CalculateStrength();
   bool CalculateMALine(string _trade_command);
   bool CanTrade();
   void Init(float _setMACD,int yHigh,int aMA,int maWFmaR,
            int _diffMAYellowBlue,int _diffMABluePurple,int _diffMAPurpleRed,int _diffMARedWhite);
   void SwapTrade(int trade_command);
  };
void Calculator::Init(float _setMACD,int yHigh,int aMA,int maWFmaR,
                     int _diffMAYellowBlue,int _diffMABluePurple,int _diffMAPurpleRed,int _diffMARedWhite){
  leastBars = 4;
     pip = 1;
     newHigh =-100;
     newLow =100;
     _macdTrade = _setMACD;
     maYellowHigh = yHigh;
     averageMA = aMA;
     whiteFarRed = maWFmaR;
     diffMAYellowBlue = _diffMAYellowBlue;
     diffMABluePurple = _diffMABluePurple;
     diffMAPurpleRed = _diffMAPurpleRed;
     diffMARedWhite = _diffMARedWhite;
     switch(Digits)
        {
         case 3:
           lotPoint = 1;
           break;
         case 4:
           lotPoint = 10;
           break;
           case 5:
           lotPoint = 100;
           break;
        }
  }

void Calculator::SwapTrade(int trade_command){

   if(trade_command == OP_BUY){
         trade_command = OP_SELL;
         color_trade = clrRed;
         openPrice = Bid;
   
   }else
   {
         trade_command = OP_BUY;
         color_trade = clrGreen;
         openPrice = Ask;
   }

}
bool Calculator::CanTrade(void){

   double checklinePrice;

   if(trend > 1){
      checklinePrice = NormalizeDouble(maYellow - (maYellowHigh*Point),Digits);
      canTrade = (checklinePrice > maBlue) ? true:false;
      trade_command = OP_SELL;
      color_trade = clrRed;
      openPrice = Bid;
            if((maWhite+maRed+maBlue)/3 > NormalizeDouble(openPrice+(averageMA*Point),Digits)){
               canTrade = false;
            }
            if(NormalizeDouble(maWhite-(whiteFarRed*Point),Digits) > maRed){
               canTrade = false;
            }
             if(MathAbs(maRed - maWhite) >= NormalizeDouble(diffMARedWhite*Point,Digits))
                          {
                           canTrade = true;
                        
                          }
           /* if((maYellow - maWhite) > NormalizeDouble(diffMARedWhite*Point,Digits))
              {
               Print("SELL def "+(maYellow - maWhite));
               canTrade = true;
               color_trade = clrPurple;
               //canTrade = (checklinePrice > maBlue) ? true:false;
              }*/
   }
   else if(trend < -1){
      checklinePrice = NormalizeDouble(maYellow + (maYellowHigh*Point),Digits);
      canTrade = (checklinePrice < maBlue) ? true:false;
      trade_command = OP_BUY;
      color_trade = clrGreen;
      openPrice = Ask;
            if((maWhite+maRed+maBlue)/3 < NormalizeDouble(openPrice+(averageMA*Point),Digits)){
               canTrade = false;
            }
             if(NormalizeDouble(maWhite+(whiteFarRed*Point),Digits) < maRed){
               canTrade = false;
            }
            if(-MathAbs(maRed - maWhite) <= NormalizeDouble(-diffMARedWhite*Point,Digits))
                          {
                           canTrade = true;
                           
                          }
           
          
           /* if((maWhite - maYellow) > NormalizeDouble(diffMARedWhite*Point,Digits))
              {
               canTrade = true;
               color_trade = clrAzure;
               Print("SELL def "+(maWhite - maYellow));
              // canTrade = (checklinePrice < maBlue) ? true:false;
              }*/

   }else
   {
      canTrade =false;
   }
   
   if(MACD >_macdTrade || MACD <-_macdTrade)
           {
             canTrade = false;
           }     
   
     //Print("average  ",((maWhite+maRed+maBlue)/3));
    //  Print("Ask ",( NormalizeDouble(openPrice+(100*Point),Digits)));
   //   Print("Bid ",( NormalizeDouble(openPrice-(100*Point),Digits)));
    //  Print("Trend  ",trend);
     // Print("canTrade  ",canTrade);
   color_close = clrYellow;
   return canTrade;
}

bool Calculator::CalculateMALine(string _trade_command){

   bool _canTrade = false;
   
   if(_trade_command == OP_BUY)
     {
       if((maYellow - maBlue) >= NormalizeDouble(diffMAYellowBlue*Point,Digits))
           {
            if((maBlue - maPurple) >= NormalizeDouble(diffMABluePurple*Point,Digits))
              {
                if((maPurple - maRed) >= NormalizeDouble(diffMAPurpleRed*Point,Digits))
                 {
                   if((maRed - maWhite) >= NormalizeDouble(diffMARedWhite*Point,Digits))
                    {
                     _canTrade = true;
                     
                    Print("_canTrade SELL");
                    }
                 }
              }
           }
     }
     
      if(_trade_command == OP_SELL)
           {
             if((maYellow - maBlue) <= NormalizeDouble(-diffMAYellowBlue*Point,Digits))
                 {
                  if((maBlue - maPurple) <= NormalizeDouble(-diffMABluePurple*Point,Digits))
                    {
                      if((maPurple - maRed) <= NormalizeDouble(-diffMAPurpleRed*Point,Digits))
                       {
                         if((maRed - maWhite) <= NormalizeDouble(-diffMARedWhite*Point,Digits))
                          {
                           _canTrade = true;
                           Print("_canTrade BUY");
                          }
                       }
                    }
                 }
           }
              
       // _canTrade = false;
       // Print("cantrade ",_canTrade);
   return _canTrade;
}


void Calculator::UpdateMA(void){
   maYellow = iMA(NULL,0,1,0,MODE_EMA,PRICE_CLOSE,0);
   maBlue = iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,0);
   maRed = iMA(NULL,0,25,0,MODE_EMA,PRICE_CLOSE,0);
   maPurple = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0);
   maWhite = iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0);
   MACD = iMACD(NULL,1,5,50,9,PRICE_CLOSE,MODE_EMA,0);
  // MAValue = iMACD(NULL,0,1,50,9,PRICE_MEDIAN,MODE_EMA,0);
   MACD = NormalizeDouble(MACD*lotPoint,Digits);
   
   //Print("MACD ",MACD);
   //Print("Pint ",Point);
   //Print("Digit ",Digits);
   if(maYellow > maBlue && maYellow > maRed){
      if(maYellow > maWhite){
            trend = 2;
          }else
             {
               trend = 1;
             }
              //int diffMAYellowBlue,diffMABluePurple,diffMAPurpleRed,diffMARedWhite;
            /* if(MathAbs(maBlue - maPurple) > NormalizeDouble(diffMABluePurple*Point,Digits))
               {
                 trend = 3;
               }
               if(MathAbs(maPurple - maRed) > NormalizeDouble(diffMAPurpleRed*Point,Digits))
               {
                trend = 2;
               }
               if(MathAbs(maRed - maWhite) > NormalizeDouble(diffMARedWhite*Point,Digits))
               {
                trend = 1;
               }*/
               
        
   }else if(maYellow < maBlue && maYellow < maRed){
         if(maYellow < maWhite){
            trend = -2;
         }else
            {
             trend = -1;
            }
            
            /* if(-MathAbs(maBlue - maPurple) < -NormalizeDouble(diffMABluePurple*Point,Digits))
               {
                trend = -3;
               }
               if(-MathAbs(maPurple - maRed) < -NormalizeDouble(diffMAPurpleRed*Point,Digits))
               {
                trend = -2;
               }
               if(-MathAbs(maRed - maWhite) < -NormalizeDouble(diffMARedWhite*Point,Digits))
               {
                trend = -1;
               }*/
          
   }else{
      trend = 0;
   }

   
}
void Calculator::SetCandle(){
   buySloveTrade = false;
   sellSloveTrade = false;
   ArrayResize(candleBar,leastBars);
   double total;
   strength = 0;
   for(int i=0;i<leastBars;i++)
     {
      candleBar[i] = new CandleBar();
      candleBar[i].SetCandle(i);
     }
   for(int i=leastBars-1;i > 1;i--)
     {
      if(i-1 != 0){
         total = candleBar[i].close -candleBar[i-1].close;
         if(newHigh < candleBar[i].close){
           newHigh = candleBar[i].close;
         }else if(newLow > candleBar[i].close){
            newLow = candleBar[i].close;
         }
         
         if(candleBar[i].close < candleBar[i-1].close){
           if(isBull){
            strength ++;
           }else
           {
            strength = 0;
           }
           if(candleBar[i].close > candleBar[i-1].close){
               isEnglufing = true;
           }else
           {
               isEnglufing = false;
           }
            isBull = true;
            isBear = false;
         }else
         {
          if(isBear){
            strength ++;
           }else
           {
            strength = 0;
           }
           if(candleBar[i].close < candleBar[i-1].open){
               isEnglufing = true;
           }else
           {
               isEnglufing = false;
           }
            isBull = false;
            isBear = true;
         }
         
       }
     }
     signalPrice = candleBar[0].signalPrice;
     barHigh = candleBar[0].highBar;

     CalculateStrength();
}
double Calculator::GetTakeProfit(void){

   return barHigh;
}
Calculator::CalculateStrength(void){
int maStrength;
   if(isBull){
      if(maYellow > maBlue){
      maStrength = 0;
         if(maYellow > maRed){
         maStrength = 1;
            if(maYellow > maWhite){
            maStrength = 1;
               if((maWhite < maRed) && (maRed < maBlue)){
                  maStrength = 1;
               }
            }
         }
      }
   
   }else{
    if(maYellow < maBlue){
    maStrength = 0;
         if(maYellow < maRed){
         maStrength = 1;
            if(maYellow < maWhite){
            maStrength = 1;
               if((maWhite > maRed) && (maRed > maBlue)){
                  maStrength = 1;
                  }
            }
         }
      }
   }
   if(isEnglufing){
      maStrength ++;
   }
   
   strength += maStrength;
   
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Calculator::Calculator()
  {
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Calculator::~Calculator()
  {
  
  }
//+------------------------------------------------------------------+
