(: List type)
(: Nil List)
(: Cons (-> $a List List))

; Function to find the length of a list
(: length (-> List Number))
(= (length Nil) 0)
(= (length (Cons $x $xs))
    (+ 1 (length $xs))
)
;; ! (length (Cons A (Cons B (Cons C Nil))))

;Function to find a list element given an index
(: index (-> Number List $a))
(= (index $a Nil) Nil)
;(= (index 0 (Cons $x $xs)) $x)
(= (index $a (Cons $x $xs))
    (if (== $a 0) 
        $x
        (index (- $a 1) $xs)
    )
)
;; ! (index 2 (Cons A (Cons B (Cons C Nil))))

; Function to apply a partial function to every element in a list
(: map (-> Atom List List))
(= (map $func Nil) Nil)
(= (map $func (Cons $x $xs))
    (Cons ($func $x) (map $func $xs))
)
;; (= (add1 $num) (+ $num 1))
;; ! (map add1 (Cons 1 (Cons 2 (Cons 3 Nil))))

; Function to check whether an Atom exists in a list
(: member (-> $a List Bool))
(= (member $a Nil) False)
(= (member $a (Cons $x $xs))
    (if (== $a $x)
        True
        (member $a $xs)
    )
)
;; ! (member B (Cons A (Cons B (Cons C Nil))))
; !(member 1 Nil)

; Function to remove duplicates from a list
(: remove-duplicates (-> List List))
(= (remove-duplicates Nil) Nil)
(= (remove-duplicates (Cons $x $xs))
  (if (member $x $xs)
    (remove-duplicates $xs)
    (Cons $x (remove-duplicates $xs))
  )
)
;; ! (remove-duplicates (Cons A (Cons B (Cons B Nil))))

; Function to append two lists
(: append (-> List List List))
(= (append Nil $ys) $ys)
(= (append (Cons $x $xs) $ys) (Cons $x (append $xs $ys)))
;; !(append (Cons a (Cons b (Cons c Nil))) (Cons c Nil))

; Function to partition the list
(: partition (-> Atom List ( List List )))
(= (partition $_ Nil) ( Nil Nil ))
(= (partition $pivot (Cons $x $xs))
    (let ($left $right) (partition $pivot $xs)
        (let* ( ($cond  (<= $x $pivot))
        ;; (let* ( ($cond (lte $x $pivot))
                (() (println! ($x "<=" $pivot "=" $cond)))
                (() (println! ($left "---" $right)))
            )
        (if $cond
            ((Cons $x $left) $right)
            ($left (Cons $x $right))
        )
        )
    )
)

;A function that checks if at least one True exists from a Boolean list 
(: any (-> List Bool))
(= (any Nil) False) ;; return False if the list is empty
(= (any (Cons True $xs)) ;; return True if the item is True
    True
)
(= (any (Cons False $xs)) ;;go to the next list item if False
    (any $xs)
)
;;test cases
; ! (any (Cons False Nil)) ;; False
; ! (any (Cons True Nil)) ;; True
; ! (any (Cons True(Cons False (Cons True Nil)))) ;; True


;A function that check if all of the elements are true from a Bool List.
(: all (-> List Bool))
(= (all Nil) True) ;; return True if the list is empty
(= (all (Cons False $xs)) ;; return False if the item is False
    False
)
(= (all (Cons True $xs)) ;;go to the next list item if True
    (all $xs)
)
;; test cases
; ! (all (Cons False Nil)) ;; False
; ! (all (Cons True Nil)) ;; True
; ! (all (Cons False(Cons True (Cons False Nil)))) ;; False
; ! (all (Cons True(Cons True (Cons True Nil)))) ;; True

; A function to find and remove element from a list
(: findAndRemove (-> $t List List ))
;; if the list is empty, return Nil
(= (findAndRemove $elem Nil) Nil)
;; if $x equals $elem, skip it; otherwise, include $x in the new list.
(= (findAndRemove $elem (Cons $x $xs)) 
    (if (== $x $elem) (findAndRemove $elem $xs)
    (Cons $x (findAndRemove $elem $xs)))
    )

;; Test cases
; !(findAndRemove 1 (Cons 1 (Cons 2 (Cons 3 Nil))))  ;; Output: [(Cons 2 (Cons 3 Nil))]
; !(findAndRemove 3 (Cons 1 (Cons 2 (Cons 3 Nil))))  ;; Output: [(Cons 1 (Cons 2 Nil))]
; !(findAndRemove 4 (Cons 1 (Cons 2 (Cons 3 Nil))))  ;; Output: [(Cons 1 (Cons 2 (Cons 3 Nil)))]


;A function to compare 2 lists
(: compare (-> List List  Bool))
(= (compare Nil Nil) True) ;; if both the lists are empty, They are the same.
(= (compare (Cons $x $xs) (Cons $y $ys)) 
    (if (and (not(== $xs $ys)) (or (== $xs Nil) (== $ys Nil)))
        False
        (if (== $x $y) 
            (compare $xs $ys) 
            False
        )
    ) 
)
;; Test cases
; !(compare (Cons 1 Nil) (Cons 1 Nil)) ;; Output: True
; !(compare (Cons "A" Nil) (Cons "a" Nil)) ;; Output: False
; !(compare (Cons 1 (Cons 2 (Cons 3 Nil))) (Cons 1 (Cons 2 (Cons 3 Nil)))) ;; Output: True
; !(compare (Cons 1 (Cons 2 (Cons 3 Nil))) (Cons 1  (Cons 2 Nil)) ) ;; Output: False


; QuickSort implementation
(: quickSort (-> List List))
(= (quickSort Nil) Nil)
(= (quickSort (Cons $x $xs))
    (let ($left $right) (partition $x $xs)
        (append (quickSort $left) (Cons $x (quickSort $right)))
    )
)

;; Test cases
; !(quickSort (Cons 2 (Cons 1 (Cons 3 Nil))))
; !(quickSort (Cons 3 (Cons 6 (Cons 2 (Cons 7 (Cons 1 (Cons 5 (Cons 4 Nil))))))))

(: check-not-duplicated (-> List Bool))
(= (check-not-duplicated $list)
    (case $list
        (
            (Nil True)
            ((Cons $x $xs)
                (if (member $x $xs)
                    False
                    (check-not-duplicated $xs)
                )
            )
        )
    )
)

(: check-not-inverse-duplicated (-> List Bool))
(= (check-not-inverse-duplicated $list)
    (case $list
        (
            (Nil True)
            ((Cons $x $xs)
                (if (member-not $x $xs)
                    False
                    (check-not-inverse-duplicated $xs)
                )
            )
        )
    )
)

(:intersect (-> List List List List))
(=(intersect $list1 $list2 $accumulator)
    (if (or (== $list1 Nil) (== $list2 Nil))
        $accumulator
        (case ($list1 $list2)
            (
                (((Cons $x $xs) (Cons $y $ys))
                        (let* (
                            ($is-x-member (member $x $ys))
                            ($is-y-member (member $y $xs))
                            )(if (and (== $is-x-member True) (== $is-y-member True))
                                (if (== $x $y)
                                    (intersect $xs $ys (append $accumulator (Cons $x Nil)))
                                    (intersect $xs $ys (append $accumulator (Cons $x (Cons $y Nil))))
                                )
                                (if (and (== $is-x-member True) (== $is-y-member False))
                                    (intersect $xs $ys (append $accumulator (Cons $x Nil)))
                                    (if (and (== $is-x-member False) (== $is-y-member True))
                                        (intersect $xs $ys (append $accumulator (Cons $y Nil)))
                                        (intersect $xs $ys $accumulator)
                                    )
                                )

                            )
                        )

      
                )
            )
        )

    )
)
;; Test cases
; !(intersect (Cons a (Cons b (Cons c Nil))) (Cons c (Cons d (Cons e (Cons f Nil)))) Nil)
; !(intersect (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))) (Cons 1 (Cons 4 (Cons 5 (Cons 6 Nil)))) Nil)
; !(intersect (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))) (Cons 5 (Cons 6 (Cons 7 (Cons 1 Nil)))) Nil)

(:union-set (->List List List List))
(= (union-set $list1 $list2)
    (remove-duplicates (append $list1 $list2))
)
;; Test cases
; !(union-set (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))) (Cons 5 (Cons 6 (Cons 7 (Cons 1 Nil)))) )

(=(is-subset $list1 $list2)
    (let* (
            ($min-list (if (> (length $list1) (length $list2)) $list2 $list1
                        ))

            ($max-list (if (> (length $list1) (length $list2)) $list1 $list2
                        ) )

        )(is-subset-ordered $min-list $max-list)
    )
   
)
;; Test cases
; !(is-subset (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))) (Cons 1 (Cons 2 (Cons 3  Nil))))

(=(is-subset-ordered $min-list $max-list)
    (if (== $min-list Nil)
        True
        (case $min-list (
            ((Cons $x $xs)
                (if (member $x $max-list)
                    (is-subset-ordered $xs $max-list)
                    False
                )
            )


            )
        )
    )

)

(=(n-ary-and $exp)
    (case $exp 
        (
            (Nil True)
            ((Cons $x $xs)
                (if (== $x True)
                    (n-ary-and $xs)
                    False
                )
            )
        )
    )
)
;; Test cases
; !(n-ary-or (Cons False (Cons True (Cons False (Cons True Nil)))))

(=(n-ary-or $exp)
    (case $exp 
        (
            (Nil False)
            ((Cons $x $xs)
                (if (== $x True)
                    True
                    (n-ary-or $xs)
                )
            )
        )
    )
)
;; Test cases
; !(n-ary-and (Cons True (Cons True (Cons False (Cons True Nil)))))
