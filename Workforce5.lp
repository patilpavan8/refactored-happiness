\ Model Workforce5
\ LP format - for model browsing. Use MPS format to capture full model detail.
Minimize multi-objectives
  TotalSlack: Priority=2 Weight=1 AbsTol=2 RelTol=0.1
   totSlack
  Fairness: Priority=1 Weight=1 AbsTol=0 RelTol=0
   - minShift + maxShift
Subject To
 Mon1: Amy.Mon1 + Bob.Mon1 + Cathy.Mon1 + Dan.Mon1 + Ed.Mon1 + Fred.Mon1
   + Gu.Mon1 + Tobi.Mon1 + Mon1Slack = 3
 Tue2: Amy.Tue2 + Bob.Tue2 + Cathy.Tue2 + Dan.Tue2 + Ed.Tue2 + Fred.Tue2
   + Gu.Tue2 + Tobi.Tue2 + Tue2Slack = 2
 Wed3: Amy.Wed3 + Bob.Wed3 + Cathy.Wed3 + Dan.Wed3 + Ed.Wed3 + Fred.Wed3
   + Gu.Wed3 + Tobi.Wed3 + Wed3Slack = 4
 Thu4: Amy.Thu4 + Bob.Thu4 + Cathy.Thu4 + Dan.Thu4 + Ed.Thu4 + Fred.Thu4
   + Gu.Thu4 + Tobi.Thu4 + Thu4Slack = 4
 Fri5: Amy.Fri5 + Bob.Fri5 + Cathy.Fri5 + Dan.Fri5 + Ed.Fri5 + Fred.Fri5
   + Gu.Fri5 + Tobi.Fri5 + Fri5Slack = 5
 Sat6: Amy.Sat6 + Bob.Sat6 + Cathy.Sat6 + Dan.Sat6 + Ed.Sat6 + Fred.Sat6
   + Gu.Sat6 + Tobi.Sat6 + Sat6Slack = 6
 Sun7: Amy.Sun7 + Bob.Sun7 + Cathy.Sun7 + Dan.Sun7 + Ed.Sun7 + Fred.Sun7
   + Gu.Sun7 + Tobi.Sun7 + Sun7Slack = 5
 Mon8: Amy.Mon8 + Bob.Mon8 + Cathy.Mon8 + Dan.Mon8 + Ed.Mon8 + Fred.Mon8
   + Gu.Mon8 + Tobi.Mon8 + Mon8Slack = 2
 Tue9: Amy.Tue9 + Bob.Tue9 + Cathy.Tue9 + Dan.Tue9 + Ed.Tue9 + Fred.Tue9
   + Gu.Tue9 + Tobi.Tue9 + Tue9Slack = 2
 Wed10: Amy.Wed10 + Bob.Wed10 + Cathy.Wed10 + Dan.Wed10 + Ed.Wed10
   + Fred.Wed10 + Gu.Wed10 + Tobi.Wed10 + Wed10Slack = 3
 Thu11: Amy.Thu11 + Bob.Thu11 + Cathy.Thu11 + Dan.Thu11 + Ed.Thu11
   + Fred.Thu11 + Gu.Thu11 + Tobi.Thu11 + Thu11Slack = 4
 Fri12: Amy.Fri12 + Bob.Fri12 + Cathy.Fri12 + Dan.Fri12 + Ed.Fri12
   + Fred.Fri12 + Gu.Fri12 + Tobi.Fri12 + Fri12Slack = 6
 Sat13: Amy.Sat13 + Bob.Sat13 + Cathy.Sat13 + Dan.Sat13 + Ed.Sat13
   + Fred.Sat13 + Gu.Sat13 + Tobi.Sat13 + Sat13Slack = 7
 Sun14: Amy.Sun14 + Bob.Sun14 + Cathy.Sun14 + Dan.Sun14 + Ed.Sun14
   + Fred.Sun14 + Gu.Sun14 + Tobi.Sun14 + Sun14Slack = 5
 totSlack: Mon1Slack + Tue2Slack + Wed3Slack + Thu4Slack + Fri5Slack
   + Sat6Slack + Sun7Slack + Mon8Slack + Tue9Slack + Wed10Slack
   + Thu11Slack + Fri12Slack + Sat13Slack + Sun14Slack - totSlack = 0
 totShiftsAmy: Amy.Mon1 + Amy.Tue2 + Amy.Wed3 + Amy.Thu4 + Amy.Fri5
   + Amy.Sat6 + Amy.Sun7 + Amy.Mon8 + Amy.Tue9 + Amy.Wed10 + Amy.Thu11
   + Amy.Fri12 + Amy.Sat13 + Amy.Sun14 - AmyTotShifts = 0
 totShiftsBob: Bob.Mon1 + Bob.Tue2 + Bob.Wed3 + Bob.Thu4 + Bob.Fri5
   + Bob.Sat6 + Bob.Sun7 + Bob.Mon8 + Bob.Tue9 + Bob.Wed10 + Bob.Thu11
   + Bob.Fri12 + Bob.Sat13 + Bob.Sun14 - BobTotShifts = 0
 totShiftsCathy: Cathy.Mon1 + Cathy.Tue2 + Cathy.Wed3 + Cathy.Thu4
   + Cathy.Fri5 + Cathy.Sat6 + Cathy.Sun7 + Cathy.Mon8 + Cathy.Tue9
   + Cathy.Wed10 + Cathy.Thu11 + Cathy.Fri12 + Cathy.Sat13 + Cathy.Sun14
   - CathyTotShifts = 0
 totShiftsDan: Dan.Mon1 + Dan.Tue2 + Dan.Wed3 + Dan.Thu4 + Dan.Fri5
   + Dan.Sat6 + Dan.Sun7 + Dan.Mon8 + Dan.Tue9 + Dan.Wed10 + Dan.Thu11
   + Dan.Fri12 + Dan.Sat13 + Dan.Sun14 - DanTotShifts = 0
 totShiftsEd: Ed.Mon1 + Ed.Tue2 + Ed.Wed3 + Ed.Thu4 + Ed.Fri5 + Ed.Sat6
   + Ed.Sun7 + Ed.Mon8 + Ed.Tue9 + Ed.Wed10 + Ed.Thu11 + Ed.Fri12
   + Ed.Sat13 + Ed.Sun14 - EdTotShifts = 0
 totShiftsFred: Fred.Mon1 + Fred.Tue2 + Fred.Wed3 + Fred.Thu4 + Fred.Fri5
   + Fred.Sat6 + Fred.Sun7 + Fred.Mon8 + Fred.Tue9 + Fred.Wed10
   + Fred.Thu11 + Fred.Fri12 + Fred.Sat13 + Fred.Sun14 - FredTotShifts = 0
 totShiftsGu: Gu.Mon1 + Gu.Tue2 + Gu.Wed3 + Gu.Thu4 + Gu.Fri5 + Gu.Sat6
   + Gu.Sun7 + Gu.Mon8 + Gu.Tue9 + Gu.Wed10 + Gu.Thu11 + Gu.Fri12
   + Gu.Sat13 + Gu.Sun14 - GuTotShifts = 0
 totShiftsTobi: Tobi.Mon1 + Tobi.Tue2 + Tobi.Wed3 + Tobi.Thu4 + Tobi.Fri5
   + Tobi.Sat6 + Tobi.Sun7 + Tobi.Mon8 + Tobi.Tue9 + Tobi.Wed10
   + Tobi.Thu11 + Tobi.Fri12 + Tobi.Sat13 + Tobi.Sun14 - TobiTotShifts = 0
Bounds
 Amy.Mon1 = 0
 Amy.Thu4 = 0
 Amy.Sat6 = 0
 Amy.Mon8 = 0
 Bob.Wed3 = 0
 Bob.Thu4 = 0
 Bob.Sun7 = 0
 Bob.Tue9 = 0
 Bob.Wed10 = 0
 Bob.Fri12 = 0
 Bob.Sun14 = 0
 Cathy.Mon1 = 0
 Cathy.Tue2 = 0
 Cathy.Sat6 = 0
 Dan.Mon1 = 0
 Dan.Thu4 = 0
 Dan.Sun7 = 0
 Ed.Sat6 = 0
 Ed.Wed10 = 0
 Ed.Fri12 = 0
 Fred.Thu4 = 0
 Fred.Fri5 = 0
 Fred.Sun7 = 0
 Fred.Wed10 = 0
 Fred.Thu11 = 0
 Gu.Mon1 = 0
 Gu.Fri5 = 0
 Gu.Mon8 = 0
 Gu.Fri12 = 0
 Tobi.Thu4 = 0
Binaries
 Amy.Mon1 Amy.Tue2 Amy.Wed3 Amy.Thu4 Amy.Fri5 Amy.Sat6 Amy.Sun7 Amy.Mon8
 Amy.Tue9 Amy.Wed10 Amy.Thu11 Amy.Fri12 Amy.Sat13 Amy.Sun14 Bob.Mon1
 Bob.Tue2 Bob.Wed3 Bob.Thu4 Bob.Fri5 Bob.Sat6 Bob.Sun7 Bob.Mon8 Bob.Tue9
 Bob.Wed10 Bob.Thu11 Bob.Fri12 Bob.Sat13 Bob.Sun14 Cathy.Mon1 Cathy.Tue2
 Cathy.Wed3 Cathy.Thu4 Cathy.Fri5 Cathy.Sat6 Cathy.Sun7 Cathy.Mon8
 Cathy.Tue9 Cathy.Wed10 Cathy.Thu11 Cathy.Fri12 Cathy.Sat13 Cathy.Sun14
 Dan.Mon1 Dan.Tue2 Dan.Wed3 Dan.Thu4 Dan.Fri5 Dan.Sat6 Dan.Sun7 Dan.Mon8
 Dan.Tue9 Dan.Wed10 Dan.Thu11 Dan.Fri12 Dan.Sat13 Dan.Sun14 Ed.Mon1 Ed.Tue2
 Ed.Wed3 Ed.Thu4 Ed.Fri5 Ed.Sat6 Ed.Sun7 Ed.Mon8 Ed.Tue9 Ed.Wed10 Ed.Thu11
 Ed.Fri12 Ed.Sat13 Ed.Sun14 Fred.Mon1 Fred.Tue2 Fred.Wed3 Fred.Thu4
 Fred.Fri5 Fred.Sat6 Fred.Sun7 Fred.Mon8 Fred.Tue9 Fred.Wed10 Fred.Thu11
 Fred.Fri12 Fred.Sat13 Fred.Sun14 Gu.Mon1 Gu.Tue2 Gu.Wed3 Gu.Thu4 Gu.Fri5
 Gu.Sat6 Gu.Sun7 Gu.Mon8 Gu.Tue9 Gu.Wed10 Gu.Thu11 Gu.Fri12 Gu.Sat13
 Gu.Sun14 Tobi.Mon1 Tobi.Tue2 Tobi.Wed3 Tobi.Thu4 Tobi.Fri5 Tobi.Sat6
 Tobi.Sun7 Tobi.Mon8 Tobi.Tue9 Tobi.Wed10 Tobi.Thu11 Tobi.Fri12 Tobi.Sat13
 Tobi.Sun14
General Constraints
 minShift: minShift = MIN ( AmyTotShifts , BobTotShifts , CathyTotShifts ,
   DanTotShifts , EdTotShifts , FredTotShifts , GuTotShifts , TobiTotShifts )
 maxShift: maxShift = MAX ( AmyTotShifts , BobTotShifts , CathyTotShifts ,
   DanTotShifts , EdTotShifts , FredTotShifts , GuTotShifts , TobiTotShifts )
End
