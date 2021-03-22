(define (problem washing-machine-prob1)
  (:domain washing-machine-domain)
  (:objects Client1 Client2 Client3 - client WM1 WM2 - washing-machine)
  (:init (washing-machine-functional WM1) (washing-machine-functional WM2) (laptop-charged) (= (total-cost) 0))
  (:goal (and (client-called Client1) (client-called Client2) (client-called Client3)))
  (:metric minimize (total-cost)))
