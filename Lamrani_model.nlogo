
__includes ["fuzzy-logic.nls"]
;extensions [ rnd ]

breed [Donors Donor ]         ;;
breed [Entrepreneurs Entrepreneur ]
breed [Financial_operators Financial_operator]  ;; the crowdfunding plateform
breed [suppliers supplier ]

globals [


  Management_fees
  min_donation                              ;; the minimum amount of donation
  fld                                       ;; the number of projects excluded from the crowdfunding plateform
  loans-fund                                ;; the loan fund
  nbr-launched-projects                     ;;
  indemnities                               ;; the amount spent on health and death insurance
  nbr-business-failure-after-borrowing      ;; The number of businesses that default after borrowing
  nbr-loans-geting-financing-from-platform  ;; the number of micro entrepreneurs financed through platform.
  disability-date                           ;; disability date of a borrower
  nbr-no-loan                               ;; How many times the loan fund was not enough
  nbr-death                                 ;; the number of deaths
]

patches-own [
]


Financial_operators-own [

]
Entrepreneurs-own [

  wealth
  location
  monitoring_fees

  social_return                              ;; the social value of the project
  required_fund                              ;; the amount required for financing the project
  productivity                               ;; each individual has productivity level
  repayment-for-quard

  duration                                   ;; the compaing duration in the CF plateforme
  info-quality-project                       ;; quality of information about the project
  number-good-pay
  borrowingdate
  pay                                        ;; to know if the entrepreneur has paid the management fees or not
  rest                                       ;; the remaining period for an entrepreneur to pay the totality of his debt
  defaulter?                                 ;;
  borrower?                                  ;;

  nbr-god_pay
  project-creation-date
  loan-from-plateform?                      ;;
  individual-debt
  likelihood-geting-donaton
  activity                                   ;; the type of  the entrepreneur's activity(Trad" "Craft" "Service" "Agri" "other )
  disability?

]



Donors-own [
  given_amount
  min-donation

  my-concept-of-bad
  my-concept-of-medium
  my-concept-of-good
;;;;;;;;;;;;;;;;;;;;;;
  my-concept-of-high-qual
  my-concept-of-med-qual
  my-concept-of-low-qual
;;;;;;;;;;;;;;;;
  my-concept-of-close
  my-concept-of-neutral
  ;;;;;;
  my-concept-of-likely
  my-concept-of-unlikely
  my-prob-of-giving-donation

]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; The fuzzy inference system ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to  compute-probability  ;; to compute the likelihood of giving donation

  ;; COMPUTATION OF RESHAPED CONSEQUENTS FOR EACH RULE

  let distance1 sqrt ( (xcor - [xcor] of myself) ^ 2 + (ycor - [ycor] of myself) ^ 2)

  let R1 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-good ] of myself ) (list clip [0 10] info-quality-project [my-concept-of-high-qual] of myself)(list clip [0 21] distance1 [my-concept-of-close] of myself )) [my-concept-of-likely] of myself
  let R2 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-good ]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-med-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-close]of myself ))    [my-concept-of-likely] of myself
  let R3 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-good ]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-low-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-close] of myself))    [my-concept-of-likely] of myself

  let R4 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-good ]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-low-qual]of myself ) (list clip [0 21] distance1[my-concept-of-neutral]of myself ))    [my-concept-of-unlikely] of myself
  let R5 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-good ]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-med-qual]of myself ) (list clip [0 21] distance1[my-concept-of-neutral] of myself))    [my-concept-of-likely] of myself
  let R6 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-good ]of myself  ) (list clip [0 10] info-quality-project  [my-concept-of-high-qual]of myself ) (list clip [0 21]distance1 [my-concept-of-neutral]of myself ))   [ my-concept-of-likely] of myself


  let R7 fuzzy-and-rule (list (list clip [10 10] social_return [my-concept-of-medium]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-low-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-neutral]of myself ))  [ my-concept-of-unlikely] of myself
  let R8 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-medium]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-med-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-neutral]of myself ))   [my-concept-of-unlikely] of myself
  let R9 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-medium]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-high-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-neutral]of myself ))   [ my-concept-of-unlikely] of myself

  let R10 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-medium]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-low-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-close] of myself))   [my-concept-of-unlikely] of myself
  let R11 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-medium]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-med-qual]of myself ) (list clip [0 21] distance1[my-concept-of-close] of myself))   [my-concept-of-unlikely] of myself
  let R12 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-medium]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-high-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-close] of myself))   [ my-concept-of-likely] of myself


  let R13 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-bad]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-low-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-neutral]of myself ))   [my-concept-of-unlikely] of myself
  let R14 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-bad]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-med-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-neutral] of myself))    [my-concept-of-unlikely] of myself
  let R15 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-bad]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-high-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-neutral] of myself))    [my-concept-of-unlikely] of myself


  let R16 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-bad]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-low-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-close] of myself))   [my-concept-of-unlikely] of myself
  let R17 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-bad]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-med-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-close]of myself))    [my-concept-of-unlikely] of myself
  let R18 fuzzy-and-rule (list (list clip [0 10] social_return [my-concept-of-bad]of myself  ) (list clip [0 10] info-quality-project [my-concept-of-high-qual]of myself ) (list clip [0 21] distance1 [my-concept-of-close]of myself ))  [my-concept-of-unlikely] of myself


  let list-of-rules (list R1 R2 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R13 R14 R15 R16 R17 R18)

  ;; AGGREGATION OF ALL THE RESHAPED CONSEQUENTS
  let my-prob-of-giving-donation-fuzzy-set fuzzy-max list-of-rules

  ;; DEFUZZIFICATION OF THE AGGREGATED FUZZY SET
   set likelihood-geting-donaton [fuzzy-COG] of my-prob-of-giving-donation-fuzzy-set ;; my-prob-of-giving-donation
   let fuzzy-sets-created-here (turtle-set list-of-rules my-prob-of-giving-donation-fuzzy-set)
   ask fuzzy-sets-created-here [fuzzy-die]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to setup
  ca

  fuzzy-start
  set $fuzzy-resolution 8

 ; plot-templates
  random-seed 138
  random-seed behaviorspace-run-number ;; to obtain  different simulations when we use the BehaviorSpace
  set  Management_fees 0
  ask patches [
    set pcolor black
  ]

  setup-entrepreneurs
  setup-donors
  setup-Fop

  set  fld 0
  set loans-fund 0
  set indemnities  0
  set nbr-business-failure-after-borrowing 0

  set nbr-loans-geting-financing-from-platform 0
  set disability-date []
  set nbr-death 0

  reset-ticks

end

to setup-donors
create-Donors nbr_of_donors
 [
    set shape "person"
    set size 0.75
    set color green
    setxy random-xcor random-ycor
    set given_amount random-normal donation-mean donation-sd
    set min-donation 50

    create-my-fuzzy-sets
]
end





to launch-new-donors

create-Donors nbr_of_donors
 [
    set shape "person"
    set size 0.75
    set color green
    setxy random-xcor random-ycor

    set given_amount random-normal donation-mean donation-sd
    set min-donation 50
    create-my-fuzzy-sets
]

end


;sd  =2= s-close = s-medium = s-good = s-likely = s-unlikely = s-bad = s-neutral

to create-my-fuzzy-sets

                                                               ;;; social return  ;;;;;;;;;;;;

  set sd clip>0 sd
  set mu1 clip [0 10] mu1;
  set my-concept-of-bad fuzzy-gaussian-set (list
    clip [0 10] (mu1 + noise variability)
    clip>0 ( sd + noise variability ) ;
    [0 10])

  set mu2 clip [0 10] mu2 ;
  set my-concept-of-good fuzzy-gaussian-set (list
    clip [0 10] (mu3 + noise variability)
    clip>0 ( sd + noise variability )
    [0 10])

  set mu1 clip [0 10] mu1 ;
  set my-concept-of-medium  fuzzy-gaussian-set (list
    clip [0 10] (mu2 + noise variability)
    clip>0 ( sd + noise variability )
    [0 10])


                                                              ;;;   Quality-of-informationn ;;;;;;


  set sd clip>0 sd ;  sd = s-low-qual
  set my-concept-of-low-qual fuzzy-gaussian-set (list
    clip [0 10] ( mu1 + noise variability);
    clip>0 (sd + noise variability)
    [0 10])


  set mu3  clip [0 10] mu3;
  set my-concept-of-med-qual  fuzzy-gaussian-set (list
    clip [0 10] ( mu3  + noise variability)
    clip>0 ( sd + noise variability)
    [0 10])


  set my-concept-of-high-qual  fuzzy-gaussian-set (list
    clip [0 10] ( mu2  + noise variability)
    clip>0 ( sd + noise variability)
    [0 10])



                                                                      ;;; proximity ;;;;;

  set my-concept-of-close   fuzzy-gaussian-set (list
    clip [0 21] ( mu1 )
    clip>0 ( sd4 )
    [0 21])



  set my-concept-of-neutral   fuzzy-gaussian-set (list
    clip [0 21] (mu4 ); mu2 = mu-neutral
    clip>0 ( sd4 )
    [0 21])


                                                            ;;;Probability of giving a donation ;;;;;



 set my-concept-of-unlikely fuzzy-gaussian-set (list
    clip [0 10] (mu1 ) ; mu = mu-unlikely
    clip>0 ( sd )
    [0 10])


  set my-concept-of-likely   fuzzy-gaussian-set (list
    clip [0 10] (mu2  ); mu2 = mu-likely
    clip>0 ( sd  )
    [0 10])



end




to plot-concepts

  ;plot-templates

  set-current-plot "MFs: Social_return"
  clear-plot
  set-plot-x-range 0 10
  set-plot-pen-color blue
  ask donors [fuzzy-plot my-concept-of-bad]
  set-plot-pen-color green
  ask donors [fuzzy-plot my-concept-of-medium]
  set-plot-pen-color red
  ask donors [fuzzy-plot my-concept-of-good]


  set-current-plot "MFs: Quality_of_information"
  clear-plot
  set-plot-x-range 0 10
  set-plot-pen-color blue
  ask donors [fuzzy-plot my-concept-of-low-qual]
  set-plot-pen-color brown
  ask donors [fuzzy-plot my-concept-of-med-qual]
  set-plot-pen-color red
  ask donors [fuzzy-plot my-concept-of-high-qual]


 set-current-plot "MFs: Proximity"
  clear-plot
  set-plot-x-range 0 21
  set-plot-pen-color blue
  ask donors [fuzzy-plot my-concept-of-close]
  set-plot-pen-color red
  ask donors [fuzzy-plot my-concept-of-neutral]

  set-current-plot "MFs: Giving_donation"
  clear-plot
  set-plot-x-range 0 10
  set-plot-pen-color red
  ask donors [fuzzy-plot my-concept-of-unlikely]
  set-plot-pen-color green
  ask donors [fuzzy-plot my-concept-of-likely]


end


to setup-entrepreneurs

  create-Entrepreneurs nbr_of_entrepreneurs
  [
    set shape "person"
    set size 0.75
    set color red
    setxy random-xcor random-ycor
    set pay false
    set  wealth 0 ;
    set number-good-pay 0
    set  monitoring_fees 0



    set required_fund random-normal 15000 2000 ;; the amount required for financing the project
    set activity pick
    ifelse ( activity = "Agri" ) [ set rest  4 ] [ set rest  12 ]


    set repayment-for-quard 0

    set duration   funding-period * 30
    set borrowingdate 0
    set defaulter? false
    set borrower? false
    set  nbr-god_pay 0
    set project-creation-date 0
    set loan-from-plateform? false
    set individual-debt 0
    set likelihood-geting-donaton 0
    set info-quality-project  random-normal 6 2
    set location random-normal 6 2
    set social_return random-normal 7 3   ;; the social value of the project
    set disability?  false
   ]
    set  nbr-launched-projects nbr_of_entrepreneurs
end

to launch-new-projects
  set nbr-launched-projects ( nbr-launched-projects + nbr_of_entrepreneurs)
  create-Entrepreneurs nbr_of_entrepreneurs
  [
    set shape "person"
    set size 0.75
    set color red
    setxy random-xcor random-ycor
    set pay false
    set  wealth 0
    set number-good-pay 0
    set  monitoring_fees 0

    set social_return random-normal 7 3 ;; the social value of the project
    set required_fund random-normal 15000 2000 ;; the  required fund for a  project
    set activity pick
    ifelse ( activity = "Agri" ) [ set rest  4 ] [ set rest  12 ]




    set repayment-for-quard 0
    set duration   funding-period * 30
    set info-quality-project random-normal 6 2
    set location random-normal 6 2
    set borrowingdate 0
    set defaulter? false
    set borrower? false
    set  nbr-god_pay 0
    set project-creation-date ticks
    set loan-from-plateform? false
    set individual-debt 0
    set likelihood-geting-donaton 0
    set disability?  false



  ]

end


to setup-Fop
  create-Financial_operators 1

  ask Financial_operators [
    set size 3
    set shape "computer workstation"
    set color yellow
    setxy 0 3

  ]
end


to go
if ticks >= periods-per-year * 365 [ stop ]

if ( ( (funding-period * 30 ) - ticks) != (funding-period * 30 ) and  (ticks mod (funding-period * 30 ) = 0)) ;; to display  new projects on the plateform
[launch-new-projects ]



select-project-give-donation
giving-loan-from-platform
pay-transaction-fees
borowwing
default
repaying-loans
update

  tick

end



to select-project-give-donation ;; selecting pojects and giving donantions

  ask donors [

     if (given_amount >= min-donation) [

    let ye Entrepreneurs with [color = red ]

    if (ye != nobody)[
    ask ye [ compute-probability ]
     let b count ye ;;

     ifelse (b > 1) [
       ask  max-one-of ye[ likelihood-geting-donaton ][  if(( wealth <= (required_fund *(1 + transaction_fees / 100))) AND (    (ticks - project-creation-date) <= duration  )  )

      [set wealth  wealth + [given_amount ]  of myself]]]


      [ ask ye[  if(( wealth <= (required_fund *(1 + transaction_fees / 100))) AND (    (ticks - project-creation-date) <= duration  )  )

      [set wealth  wealth + [given_amount ]  of myself]]



        ]   ]  ]   ]

  end


to giving-loan-from-platform

  if (platform-gives-loans? = true  )[

  let yp  entrepreneurs with [ ( (ticks -   project-creation-date) >= duration ) AND ( wealth / ((required_fund)*(1 + transaction_fees / 100)) >= Threshold ) AND (borrower? = false) AND (color = red)   ] ;; on a ajouté color=red
if( yp != nobody  )[

  ask yp [ ifelse ((loans-fund >= ((required_fund) * ( 1 - Threshold) * (1 + transaction_fees / 100))))
    [
    set loan-from-plateform? true
    set nbr-loans-geting-financing-from-platform ( nbr-loans-geting-financing-from-platform + 1)
    set loans-fund (loans-fund - (required_fund * ( 1 - Threshold) * (1 + transaction_fees / 100)   ))
    set wealth  ( wealth + (required_fund * ( 1 - Threshold) * (1 + transaction_fees / 100)   ))


    ]

    [    set nbr-no-loan (nbr-no-loan  + 1) ]

    ]]]

end


to pay-transaction-fees

  ask entrepreneurs [

    if ( (wealth >= required_fund) AND (pay = false ) )

 [   set Management_fees (Management_fees + (  wealth -   required_fund))
     set wealth  required_fund
     set pay true
     set color blue
  ]

   ]
end


to borowwing

  ask entrepreneurs [

    if  (color = blue)  [ ;;the blue color refers to those who have achieved their funding goal and they have paid the transaction fees as well

      set borrowingdate  ticks
      set color orange  ;; if the color becomes orange, the entrepreneur is not allowed to have another loan

      set borrower? true
      set individual-debt required_fund

    ]

  ]

end



to repaying-loans ; The entrepreneur starts to reimburse his debt after the grace period

  if( platform-gives-loans? = true )[
  ask entrepreneurs [

    let grace-period grace-period1
    let p periodocity
    let dev credit-echeance

   if( (color = orange) AND (( ticks - borrowingdate) > ( grace-period * 30 )) AND
      (((  ticks - borrowingdate - ( grace-period * 30 )) mod p ) = 0)
      AND (individual-debt != 0 ) and (defaulter? = false) );; il rembouse si n'est pas
                                                                                          ;; en défaut
    [set wealth (wealth - required_fund / dev )
     set rest ( rest - 1)
     set nbr-god_pay ( nbr-god_pay + 1) ;; the number of loans that are fully repaid
     set loans-fund (loans-fund + 100 / 100 * ( required_fund) / dev )

     set individual-debt ( individual-debt - ( required_fund) / dev )
    ]

    if ( rest = 0) [
      set color violet ;;
      set borrower? false
       set individual-debt 0
      ]
    ]
  ]
end

to update

  ask entrepreneurs [
    if( (color = red) and ((ticks - project-creation-date) > duration) )
    [ set fld (fld + 1)

      if (platform-gives-loans? = TRUE)[
      set loans-fund ( loans-fund + wealth)]
      die ]

    ]
  ask donors [die ]
  launch-new-donors

end

to default ;; the business failure
  let df entrepreneurs with [  color = orange]
  if (df != nobody )[
     ask df [

    if random 1000  <  ( prop-failure * 10 ) [

    set  defaulter?  true
    set nbr-business-failure-after-borrowing (nbr-business-failure-after-borrowing + 1 )
    set color white
    set individual-debt 0 ;;  if an entrepreneur defaults, he is not required to pay anything
    set wealth  0

]]]

end




to-report noise [v]  ;; reports a random number in the interval [-v v]
  report (v - random-float (2 * v))
end

to-report clip [i v] ;; clips the value v within the interval i
  let f first i
  let l last i
  if v < f [set v f]
  if v > l [set v l]
  report v
end

to-report clip>0 [ v ]
  if v <= 0 [set v 0.01]
  report v
end

to plot-templates

  ;; Social return
  set-current-plot "MFs- Social return"
  clear-plot
  set-plot-x-range 0 10

  let bad-template fuzzy-gaussian-set (list mu1 sd [0 10])
  let good-template fuzzy-gaussian-set (list mu2 sd [0 10])
  let medium-template fuzzy-gaussian-set (list (mu1) sd [0 10])
  set-plot-pen-color blue
  fuzzy-plot bad-template
   set-plot-pen-color green
  fuzzy-plot medium-template
  set-plot-pen-color red
  fuzzy-plot good-template


    ;;   ;; Quality-of-information
  set-current-plot "MFs-Quality of information"
  clear-plot
  set-plot-x-range 0 10

  let low-qual-template fuzzy-gaussian-set (list mu1 sd [0 10])
  let high-qual-template fuzzy-gaussian-set (list mu2 sd [0 10])
    let med-qual-template fuzzy-gaussian-set (list mu3 sd [0 10])

  set-plot-pen-color blue
  fuzzy-plot low-qual-template

  set-plot-pen-color red
  fuzzy-plot high-qual-template

  set-plot-pen-color brown
  fuzzy-plot med-qual-template
  ;;
  ;;Probability
  set-current-plot "MFs- likelohood of donation"
  clear-plot
  set-plot-x-range 0 10

  let unlikely-template fuzzy-gaussian-set (list mu1 sd [0 10])
  let likely-template fuzzy-gaussian-set (list mu2 sd [0 10])

  set-plot-pen-color red
  fuzzy-plot unlikely-template
  set-plot-pen-color green
  fuzzy-plot likely-template

      ;; proximity
  set-current-plot "MFs-Proximity"
  clear-plot
  set-plot-x-range 0 10

  let close-template fuzzy-gaussian-set (list mu4  sd4 [0 21])
  let neutral-template fuzzy-gaussian-set (list mu4 sd4 [0 21])


  set-plot-pen-color blue
  fuzzy-plot close-template

  set-plot-pen-color red
  fuzzy-plot neutral-template


  ask (turtle-set bad-template good-template low-qual-template high-qual-template med-qual-template unlikely-template likely-template close-template neutral-template) [fuzzy-die]
end
to-report pick

  let rnd random 100
  if ( rnd <= 7 )
  [report "Craft"]
  if ( rnd > 7  and rnd <= 18  )
  [report "other" ]
  if ( rnd > 18  and rnd <= 35  )
  [report "Trad" ]
  if ( rnd > 35  and rnd <= 57 )
    [report "Agri" ]
    if ( rnd > 57  and rnd <= 100 )
    [report "Service" ]
end

to-report grace-period1
  if activity = "other" [ report 4 ]
  if activity = "Trad" [ report 2 ]
  if activity = "Service" OR activity = "Craft" [report 3 ]
  if activity = "Agri" [report 7]

end



to-report performance

  if activity = "other" [ report random-normal 40 10 ]
  if activity = "Trad" [ report  random-normal 40 5 ]
  if activity = "Service" OR activity = "Craft" [report random-normal 30 5  ]
  if activity = "Agri" [report random-normal 30 5 ]
end

to-report periodocity

  if activity = "other" [ report 30 ]
  if activity = "Trad" [ report  30 ]
  if activity = "Service" OR activity = "Craft" [report 30  ]
  if activity = "Agri" [report 210 ] ; 7 month
end
to-report credit-echeance
  ifelse  activity = "Agri" [report 4 ]
  [report 12 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
6
134
353
341
10
5
16.05
1
10
1
1
1
0
1
1
1
-10
10
-5
5
0
0
1
Day
30.0

BUTTON
183
342
268
375
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
274
342
362
375
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
383
187
416
nbr_of_entrepreneurs
nbr_of_entrepreneurs
0
100
10
1
1
NIL
HORIZONTAL

SLIDER
373
378
545
411
nbr_of_donors
nbr_of_donors
0
100
5
1
1
NIL
HORIZONTAL

SLIDER
7
418
187
451
periods-per-year
periods-per-year
0
20
6
1
1
NIL
HORIZONTAL

PLOT
598
175
990
372
Success rate (%)
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Entre" 1.0 0 -15582384 true "" "plot (count entrepreneurs with [color != red])/(nbr-launched-projects) * 100"

MONITOR
1168
215
1314
260
Nbr-entr-that-get-fun
count entrepreneurs with [color != red]
17
1
11

MONITOR
1169
266
1315
311
Nbr-failed-project
fld
2
1
11

SWITCH
6
342
182
375
platform-gives-loans?
platform-gives-loans?
0
1
-1000

MONITOR
999
362
1315
407
Nbr-entr-funded-thanks-to-loans repayments
nbr-loans-geting-financing-from-platform
2
1
11

SLIDER
191
457
365
490
Threshold
Threshold
0.3
0.9
0.3
0.1
1
NIL
HORIZONTAL

SLIDER
10
459
183
492
prop-failure
prop-failure
0.1
5
0.2
0.1
1
%
HORIZONTAL

SLIDER
190
382
366
415
donation-mean
donation-mean
150
500
250
50
1
NIL
HORIZONTAL

SLIDER
371
416
543
449
donation-sd
donation-sd
0
100
40
10
1
NIL
HORIZONTAL

MONITOR
1167
166
1312
211
Nbr-launched-projects
nbr-launched-projects
17
1
11

SLIDER
371
455
543
488
transaction_fees
transaction_fees
0.1
0.5
0.3
0.1
1
NIL
HORIZONTAL

MONITOR
999
313
1167
358
Nbr-of-defaulters
nbr-business-failure-after-borrowing
2
1
11

INPUTBOX
455
45
581
105
variability
0.5
1
0
Number

INPUTBOX
496
231
546
291
mu3
5
1
0
Number

PLOT
603
10
775
162
MFs: Social_return
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

BUTTON
455
10
582
43
NIL
plot-concepts
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
774
10
978
162
MFs: Quality_of_information
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

PLOT
980
10
1140
165
MFs: Proximity
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

PLOT
1140
10
1315
166
MFs: Giving_donation
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

INPUTBOX
358
217
408
277
mu1
0
1
0
Number

INPUTBOX
444
231
494
291
mu2
10
1
0
Number

MONITOR
998
263
1164
308
Loans-fund
loans-fund
2
1
11

MONITOR
1172
313
1315
358
Nbr of totaly Repaid loans
count entrepreneurs with [color = violet ]
2
1
11

INPUTBOX
516
219
568
279
mu4
21
1
0
Number

SLIDER
190
417
366
450
funding-period
funding-period
1
5
2
1
1
months
HORIZONTAL

INPUTBOX
438
279
488
339
sd
2
1
0
Number

INPUTBOX
492
280
542
340
sd4
5
1
0
Number

MONITOR
996
214
1164
259
Success rate
(count entrepreneurs with [color != red])/(nbr-launched-projects) * 100
2
1
11

TEXTBOX
357
199
587
342
Color Guide\n*****************\nGreen : Donors\nRed : Entrepreneur who does not get loan yet\nOrange:Entrepreneur who got loan\nwhite : Defaulter\nViolet: Entrepreneur who has totally repaid his loan\n
10
0.0
0

MONITOR
996
167
1165
212
Simulation orizon(years)
ticks / 360
2
1
11

@#$#@#$#@

## HOW TO USE IT

- The model is executed under NetLogo 5.3.1

- To be executed, the NetLogo model needs to be in the same folder with the "fuzzy-logic.nls" file.

- To execute the model  click on the“setup” button, the “plot-concepts” button and then the “go” button.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

cfo
true
4
Circle -1184463 false true 108 63 85
Rectangle -1184463 false true 120 135 180 180
Line -1184463 true 195 90 210 75
Line -1184463 true 150 60 150 30
Line -1184463 true 180 75 195 45
Line -1184463 true 120 75 90 60
Line -1184463 true 105 105 90 105
Line -1184463 true 135 60 120 30
Line -1184463 true 195 105 210 105

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

computer workstation
false
0
Rectangle -7500403 true true 60 45 240 180
Polygon -7500403 true true 90 180 105 195 135 195 135 210 165 210 165 195 195 195 210 180
Rectangle -16777216 true false 75 60 225 165
Rectangle -7500403 true true 45 210 255 255
Rectangle -10899396 true false 249 223 237 217
Line -16777216 false 60 225 120 225

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1825"/>
    <metric>(count entrepreneurs with [color != red])/(nbr-launched-projects) * 100</metric>
    <metric>nbr-insurance-benefeciaries</metric>
    <metric>nbr-launched-projects</metric>
    <metric>nbr-loans-geting-financing-from-platform</metric>
    <enumeratedValueSet variable="mu3">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-illness-or-death">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mu2">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mu1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="periods-per-year">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-period">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mu4">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nbr_of_entrepreneurs">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sd4">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Monitoring-eff">
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prop-failure">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="transaction_fees">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Threshold">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nbr_of_donors">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="platform-gives-loans?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="donation-mean">
      <value value="250"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Moral-hazard">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="donation-sd">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning-factor">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="variability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sd">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
