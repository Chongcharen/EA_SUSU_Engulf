//+------------------------------------------------------------------+
//|                                                         SUSU.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Bavaria/Calculator.mqh>   
#include <Bavaria/CandleBar.mqh>   
#include <Bavaria/MoneyManager.mqh>   

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

Calculator* cal;
MoneyManager* mm;
int lastBar=0;
int currentTrend;
double minstop,takeProfit,stopLoss;
bool cutRedMA = false;
int strength = 1;

int ticketBuy[];
int ticketSell[];
//int ticketSelect;

double lastTicketBuy = 0;
double lastTicketSell = 0;
int stepBuy = 0;
int stepSell = 0;

bool barTrade = false;

input double lotStart = 0.01;
input int pointForProfit = 100;
input int moneyToupMM = 3000;
input float macd = 5;
input int maxOrder = 15;
input bool useMM = true;
input bool useStrength = false;
input int barHighForTrade = 25;
input int yellowHiegh = 25;
input int averageMA = 100;
input int maWhiteFarmaRed = 50;
input int magicNumber = 1;
input int stepToTrade = 0;
input int diffMAYellowBlue = 250;
input int diffMABluePurple = 250;
input int diffMAPurpleRed = 250;
input int diffMARedWhite = 250;

int OnInit()
  {
//---

   ArrayResize(ticketBuy,0);
   ArrayResize(ticketSell,0);
   cal = new Calculator();
   mm = new MoneyManager();
   cal.Init(macd,yellowHiegh,averageMA,maWhiteFarmaRed,
            diffMAYellowBlue,diffMABluePurple,diffMAPurpleRed,diffMARedWhite);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  cal.UpdateMA();
  cal.SetCandle();
   
   
   if(lastBar != Bars){
      lastBar = Bars;
       barTrade = false;
       
   }
   CheckAllOrder();
   Trade();
  
   
  }
//+------------------------------------------------------------------+
void Trade(){

   if(cal.CanTrade()&&!barTrade){
      if(cal.trade_command == OP_BUY && ArraySize(ticketBuy) < maxOrder){
         if(lastTicketBuy > NormalizeDouble(Ask+(barHighForTrade*Point),Digits) || ArraySize(ticketBuy) <= 0){ 
         if(stepBuy >= stepToTrade){
            TradeBuy();
            stepBuy = 0;
            }else
               {
                stepBuy++;
               }
            
         }
      } 
      if(cal.trade_command == OP_SELL && ArraySize(ticketSell) < maxOrder)
      {
          if(lastTicketSell < NormalizeDouble(Bid-(barHighForTrade*Point),Digits) || ArraySize(ticketSell) <= 0){
             if(stepSell >= stepToTrade){
                TradeSell();
                stepSell = 0;
               }else
               {
                stepSell++;
               }
          }
          
      }
   barTrade = true;
   }
   
   
  
}

void TradeSell(){
 int ticketSelect = OrderSend(Symbol(),cal.trade_command,mm.GetMoneyPlay(lotStart,moneyToupMM,1,useMM,ArraySize(ticketSell)),cal.openPrice,3,0,0,NULL,magicNumber,0,cal.color_trade);
   if(ticketSelect != -1){
       ArrayResize(ticketSell,ArraySize(ticketSell)+1);
       ticketSell[ArraySize(ticketSell)-1] = ticketSelect;
     //  ArrayFill(ticketSell,ArraySize(ticketSell)-1,1,ticketSelect);
       lastTicketSell = cal.openPrice;
      ticketSelect = -1;
      //Print("Ticket Sell count ",ArraySize(ticketSell));
   }
    //ticketSelect = 0;
}

void TradeBuy(){
  int ticketSelect = OrderSend(Symbol(),cal.trade_command,mm.GetMoneyPlay(lotStart,moneyToupMM,1,useMM,ArraySize(ticketBuy)),cal.openPrice,3,0,0,NULL,magicNumber,0,cal.color_trade);
    if(ticketSelect != -1){
       ArrayResize(ticketBuy,ArraySize(ticketBuy)+1);
       ticketBuy[ArraySize(ticketBuy)-1] = ticketSelect;
       //ArrayFill(ticketBuy,ArraySize(ticketBuy)-1,1,ticketSelect);
       lastTicketBuy = cal.openPrice;
        ticketSelect = -1;
       // Print("Ticket Buy count ",ArraySize(ticketBuy));
   }
   // ticketSelect = 0;
}

void CheckAllOrder(){
 float price = 0;
       for(int i=0;i<ArraySize(ticketBuy);i++)
        {
           if(OrderSelect(ticketBuy[i],SELECT_BY_TICKET)){
               price += OrderProfit();
            }
        }
   if(price > (ArraySize(ticketBuy))*(mm.GetLot(lotStart,moneyToupMM)*pointForProfit))
     {
        Print("mm.GetLot()",mm.GetLot(lotStart,moneyToupMM));
        Print("Profit ()",(ArraySize(ticketBuy))*(mm.GetLot(lotStart,moneyToupMM)*pointForProfit));
       for(int i=ArraySize(ticketBuy)-1;i>=0;i--)
        {
           if(OrderSelect(ticketBuy[i],SELECT_BY_TICKET)){
               OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrYellow);
                //ArrayResize(_ticket,i,0);
            }
        }
       ArrayResize(ticketBuy,0); 
       lastTicketBuy = 0;
     }
     
      price = 0;
       for(int i=0;i<ArraySize(ticketSell);i++)
        {
           if(OrderSelect(ticketSell[i],SELECT_BY_TICKET)){
               price += OrderProfit();
            }
        }
   
   if(price > (ArraySize(ticketSell))*(mm.GetLot(lotStart,moneyToupMM)*pointForProfit))
     {
     Print("sell profit ",price);
       //CloseAllOrder(ticketSell,"CLOSESELL");
        for(int i=ArraySize(ticketSell)-1;i>=0;i--)
        {
           if(OrderSelect(ticketSell[i],SELECT_BY_TICKET)){
               OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrYellow);
                //ArrayResize(_ticket,i,0);
            }
        }
       ArrayResize(ticketSell,0); 
       lastTicketSell = 0;
     
     }
     
     

}
void CloseAllOrder(int& _ticket[],string comment){
   for(int i=ArraySize(_ticket)-1;i>=0;i--)
        {
           if(OrderSelect(ticketSell[i],SELECT_BY_TICKET)){
          // Print("comment ",comment);
               OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrYellow);
                //ArrayResize(_ticket,i,0);
            }
        }
       ArrayResize(_ticket,0); 
}
int GetBrunch(int& _ticket[]){
   return ArraySize(_ticket);
}

float GetProfit(int& _ticket[]){
   float price = 0;
       for(int i=0;i<ArraySize(_ticket);i++)
        {
           if(OrderSelect(_ticket[i],SELECT_BY_TICKET)){
               price += OrderProfit();
            }
        }
   return price;
}