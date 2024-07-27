!(import! &self list)

(=(isEmpty $exp)
    (if (== Nil $exp) True False)
)

(=(max $first-val $second-val)
    (if (> $first-val $second-val) $first-val $second-val)
)

(=(check_tree_depth $data)
    (case $data (
            (($op $exp1 $exp2)
                 (+ 1 (max (check_tree_depth $exp1) (check_tree_depth $exp2)))
            )
            (($op $exp1) 1)
            ($_ 0)
        )
    )
)
;; !(check_tree_depth (AND (OR x1 x2) (AND x3 x4)))

(:get-children (-> Expression List List))
(= (get-children $exp $guard-set)
    (if (==(get-metatype $exp) Symbol)
        Nil
        (if (==(get-metatype $exp) Expression)
            (case $exp 
                (
                    ($op $exp1 $exp2)
                    (let* 
                        (
                            ($type1 (get-metatype $exp1))
                            ($type2 (get-metatype $exp2))
                        )
                        (if (and (== $type1 Symbol) (== $type2 Symbol))
                            (append (Cons $exp1 (Cons $exp2 Nil)) $guard-set)

                            (if (and (== $type1 Symbol) (== $type2 Expression))
                                (append (Cons $exp1 Nil) (get-children $exp2 $guard-set))

                                (if (and (== $type1 Expression) (== $type2 Symbol))
                                    (append (Cons $exp2 Nil) (get-children $exp1 $guard-set))
                                    (append (get-children $exp1 $guard-set) (get-children $exp2 $guard-set))
                                    
                                )
                            )

                        )
                    )
                )
            )
            (ERROR the format is invalid)
        )
    )
)
;; !(get-children (AND (OR x1 x2) (AND x3 x4)) Nil)

(:get-guard-set (-> Expression List List))
(= (get-guard-set $exp)
    (case $exp 
        (
            (
                ($OP $exp1 $exp2)
                (let* (
                        ($type1 (get-metatype $exp1))
                        ($type2 (get-metatype $exp2)) 
                    )
                    (if (and (== $type1 Expression) (== $type2 Expression)) 
                        Nil
                        (if (== $OP AND)
                            (if (and (== $type1 Symbol) (== $type2 Symbol))
                                (Cons $exp1 (Cons $exp2 Nil))
                                (if (and (== $type1 Symbol) (== $type2 Expression))
                                    (Cons $exp1 Nil)
                                    (Cons $exp2 Nil)
                                )
                            )
                            Nil
                        )
                    )
                )
            )
            (
                ( $OP $exp )
                ( (if (== NOT $exp) ($OP $exp) ERROR) )
            )
            ($exp (Cons $exp Nil))
        )
    )
)
;; !(get-guard-set (AND (OR x1 x2) (AND x3 x4)))
