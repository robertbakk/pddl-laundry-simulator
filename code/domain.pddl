(define (domain washing-machine-domain)
    (:requirements
        :action-costs
        :typing
        :conditional-effects
        :existential-preconditions)
    (:types
        washing-machine - object
        client - object)

    (:predicates
        (washing-machine-functional ?x - washing-machine)
        (washing-machine-plugged-in ?x - washing-machine)
        (washing-machine-on ?x - washing-machine)
        (washing-machine-full ?x - washing-machine)
        (washing-machine-half-full ?x - washing-machine)
        (clean-clothes ?x - client)
        (mobile-phone-charged)
        (laptop-charged)
        (mobile-phone-on)
        (internet)
        (electricity)
        (washing-finished ?x - washing-machine)
        (client-called ?x - client)
        (phone-number ?x - client)
        (clothes-out-and-clean ?x - client)
        (clothes-in ?x - washing-machine ?y - client)
        (in-office)
        (in-washing-room))


    (:functions
        (total-cost))

    (:action plug-washing-machine-in
        :parameters (?w - washing-machine)
        :precondition (and (in-washing-room)
                           (not (washing-machine-plugged-in ?w))
                           (washing-machine-functional ?w))
        :effect (and (washing-machine-plugged-in ?w)
                     (increase (total-cost) 2)))
		   
    (:action pay-electricity-online
        :parameters ()
        :precondition (and (not (electricity))
                            (internet)
                            (or (mobile-phone-on)
                            	 (laptop-charged))
                            (in-office))
        :effect (and (electricity)
                     (increase (total-cost) 3)))
           
    (:action pay-electricity-in-person
        :parameters ()
        :precondition (not (electricity))
        :effect (and (not (in-office))
                     (not (in-washing-room))
                     (electricity)
                     (increase (total-cost) 6)))           
           
    (:action pay-internet-in-person
        :parameters ()
        :precondition (not (internet))
        :effect (and (not (in-office))
                     (not (in-washing-room))
                     (internet)
                     (increase (total-cost) 6)))
           
    (:action turn-washing-machine-on-full
        :parameters (?w - washing-machine)
        :precondition (and (in-washing-room)
                           (not (washing-machine-on ?w))
                           (washing-machine-plugged-in ?w)
                           (electricity)
                           (washing-machine-full ?w))
        :effect (and (washing-machine-on ?w)
        	      (not (washing-finished ?w))
                     (increase (total-cost) 3)))
        
        
    (:action turn-washing-machine-on-half-full
        :parameters (?w - washing-machine)
        :precondition (and (in-washing-room)
                           (not (washing-machine-on ?w))
                           (washing-machine-plugged-in ?w)
                           (electricity)
                           (washing-machine-half-full ?w))
        :effect (and (washing-machine-on ?w)
        	      (not (washing-finished ?w))
                     (increase (total-cost) 5)))
           
    (:action turn-phone-on
        :parameters ()
        :precondition (and (not (mobile-phone-on))
                           (mobile-phone-charged))
        :effect (and (mobile-phone-on)
        	      (increase (total-cost) 1)))
           
    (:action put-clothes-in-second-set
        :parameters (?w - washing-machine ?c - client)
        :precondition (and (washing-machine-half-full ?w)
                           (in-washing-room)
                           (not (exists (?w2 - washing-machine) (clothes-in ?w2 ?c)))
                           (not (exists (?e - client) (and (clothes-in ?w ?e) (clean-clothes ?e))))
                           (not (clean-clothes ?c)))
        :effect (and (washing-machine-full ?w)
                     (not (washing-machine-half-full ?w))
                     (clothes-in ?w ?c)
                     (increase (total-cost) 1)))
                     
    (:action put-clothes-in-first-set
        :parameters (?w - washing-machine ?c - client)
        :precondition (and (not (washing-machine-half-full ?w))
                           (not (washing-machine-full ?w))
                           (not (exists (?w2 - washing-machine) (clothes-in ?w2 ?c)))
                           (not (clothes-in ?w ?c))
                           (in-washing-room)
                           (not (clean-clothes ?c)))
        :effect (and (washing-machine-half-full ?w)
                     (clothes-in ?w ?c)
                     (increase (total-cost) 1)))
           
    (:action charge-phone
        :parameters ()
        :precondition (and (not (mobile-phone-charged))
                           (electricity))
        :effect (and (mobile-phone-charged)
                     (increase (total-cost) 1))) 
           
    (:action charge-laptop
        :parameters ()
        :precondition (and (not (laptop-charged))
                           (electricity))
        :effect (and (laptop-charged)
                     (increase (total-cost) 3)))  
           
    (:action finish-washing
        :parameters (?w - washing-machine)
        :precondition (and (not (washing-finished ?w))
                           (washing-machine-on ?w))
        :effect (and (washing-finished ?w) 
        	      (not (washing-machine-on ?w))
        	      (when (exists (?c - client) (clothes-in ?w ?c)) (clean-clothes ?c))))
           

                     
    (:action take-clothes-out
        :parameters (?w - washing-machine ?c - client)
        :precondition (and (in-washing-room)
                           (washing-finished ?w)
                           (clothes-in ?w ?c)
                           (clean-clothes ?c)
                           (or (washing-machine-half-full ?w)
                              (washing-machine-full ?w)))
        :effect (and (when (washing-machine-half-full ?w)
        		    (and (not (washing-machine-half-full ?w))
        		    	 (not (washing-machine-on ?w))))
                     (when (washing-machine-full ?w)
                     	    (and (not (washing-machine-full ?w)) 
                     	    	  (washing-machine-half-full ?w)))
                     (not (clothes-in ?w ?c))
                     (clothes-out-and-clean ?c)
                     (increase (total-cost) 1)))
           
    (:action call-client
        :parameters (?c - client)
        :precondition (and (clothes-out-and-clean ?c)
        		    (mobile-phone-on)
                           (mobile-phone-charged)
                           (phone-number ?c))
        :effect (client-called ?c))
           
    (:action go-to-office
        :parameters ()
        :precondition (not (in-office))
        :effect (and (not (in-washing-room))
                     (in-office)
                     (increase (total-cost) 5)))
                     
    (:action go-to-office-while-washing
        :parameters ()
        :precondition (and (not (in-office))
        		    (exists (?w - washing-machine) (washing-machine-on ?w)))
        :effect (and (not (in-washing-room))
                     (in-office)
                     (increase (total-cost) 3)))
           
    (:action go-to-washing-room
        :parameters ()
        :precondition (not (in-washing-room))
        :effect (and (not (in-office))
                     (in-washing-room)
                     (increase (total-cost) 5)))
           
    (:action get-phone-number
        :parameters (?c - client)
        :precondition (and (in-office)
        		    (mobile-phone-charged)
                           (laptop-charged)
                           (internet))
        :effect (phone-number ?c))
        
)
