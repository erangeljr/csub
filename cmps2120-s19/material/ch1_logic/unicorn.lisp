; load clisp:  clisp
; load with (load 'unicorn)
; run with (test 'unicorn)

; the following lisp program uses the aima logic "make-prop-kb" function to 
; create a knowledge base (KB) about unicorns, to load the KB with facts with
; "tell", and query the KB with "ask" 

;  Hypothesis:
;  If the unicorn is mythical, then it is immortal, but if it is not mythical,
;  then it is a mortal mammal. If the unicorn is either immortal or a mammal,
;  then it is horned. The unicorn is magical if it is horned.
;
;  Are the following conclusions true or false?
;  A unicorn is mythical.
;  A unicorn is magical.
;  A unicorn is horned.


(load 'aima.lisp)
(aima-load 'logic)
(deftest unicorn 
  ((setf kb (make-prop-kb)))
  ((tell kb "mythical => immortal"))
  ((tell kb "~mythical => ~immortal ^ mammal"))
  ((tell kb "immortal | mammal => horned"))
  ((tell kb "horned => magical"))
  ((ask kb "mythical"))
  ((ask kb "~mythical"))
  ((ask kb "magical"))
  ((ask kb "horned"))
)
; end of deftest


; ======================================================================
; proof for magical:
; mythical => immortal                  Premise 1
; ~mythical => ~immortal ^ mammal       Premise 2
; immortal | mammal => horned           Premise 3
; horned => magical                     Premise 4
; ---------------------
; : magical

; 1. mythical => immortal             Premise 1
; 2. ~mythical | immortal             By Implication Elimination on 1
; 3. ~mythical => ~immortal ^ mammal  Premise 2
; 4. mythical | (~immortal ^ mammal)  By Implication Elimination on 3 
; 5. immortal | (~immortal ^ mammal)  By Resolution on 2 and 4
; 6. immortal | mammal => horned      Premise 3
; 7. ~(immortal | mammal) | horned    Implication Elimination on 6
; 8. horned => magical                Premise 4
; 9. ~horned | magical                Implication elimination on 8 
; 10. ~(immortal | mammal) | magical  Resolution on 7 and 9
; 11. ~immortal ^ ~mammal  | magical  De Morgan on 10 
; 12. ~immortal | magical             Simplification on 11
; 13.  Ran out of time.... extra credit for finishing.... 
