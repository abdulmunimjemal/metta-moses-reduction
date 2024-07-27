! (register-module! ../../metta-moses-reduction)
! (import! &self metta-moses-reduction:utilities:tree-ds)

(= (zip $x $y) ($x $y))

(= (treeFoldl $func $acc NilNode) $acc)
(= (treeFoldl $func $acc (TreeNode $nodeVal $leftTree $rightTree $guardSet $children))
  (case $nodeVal
    (
      ( (Value $val $truthVal LITERAL) 
        ($func $acc $val)
      )
      ( (Value $val $truthVal ROOT)
        (treeFoldl $func $acc $rightTree)
      )
      ( (Value $val $truthVal NOT)
        (treeFoldl $func $acc $rightTree)
      )
      ( (Value $val $truthVal AND)
        (treeFoldl $func (treeFoldl $func $acc $leftTree) $rightTree)
      )
      ( (Value $val $truthVal OR)
        (treeFoldl $func (treeFoldl $func $acc $leftTree) $rightTree)
      )
    )
  )
)
;; !(treeFoldl zip Nil (buildTree (AND A (AND B (AND C (AND (OR A (OR B (OR C A))) (AND B (AND (AND A A) (NOT A)))))))))

(= (treeFoldr $func $acc NilNode) $acc)
(= (treeFoldr $func $acc (TreeNode $nodeVal $leftTree $rightTree $guardSet $children))
  (case $nodeVal
    (
      ( (Value $val $truthVal LITERAL) ($func $acc $val) )
      ( (Value $val $truthVal ROOT) (treeFoldl $func $acc $rightTree) )
      ( (Value $val $truthVal NOT) (treeFoldl $func $acc $rightTree) )
      ( (Value $val $truthVal AND)
        (treeFoldl $func (treeFoldl $func $acc $leftTree) $rightTree)
      )
      ( (Value $val $truthVal OR)
        (treeFoldl $func (treeFoldl $func $acc $leftTree) $rightTree)
      )
    )
  )
)
;; !(treeFoldr zip Nil (buildTree (AND A (AND B (AND C (AND (OR A (OR B (OR C A))) (AND B (AND (AND A A) (NOT A)))))))))


;; a function that compares the longest depth of two trees, 
;;   if they are equal it returns 0
;;   if the first has smaller depth it returns -1
;;   if the first has larger depth it returns 1
(: compareTrees (-> Tree Tree Number))
(= (compareTrees NilNode NilNode) 0)
(= (compareTrees $firstTree $secondTree)
  (case $firstTree
    (
      ( 
        (NilNode)
        (case $secondTree
          (
            ( (NilNode) 0 )
            ( (TreeNode $nodeVal $leftTree $rightTree $guardSet $children) -1 )
          )
        )  
      )
      (
        (TreeNode $firstNodeVal $firstLeftTree $firstRightTree $firstGuardSet $firstChildren)
        (case $secondTree
          (
            ( (NilNode) 1 )
            ( 
              (TreeNode $secondNodeVal $secondLeftTree $secondRightTree $secondGuardSet $secondChildren) 
              ( let*
                (
                  ( $leftTreeRes (compareTrees $firstLeftTree $secondLeftTree) )
                  ( $rightTreeRes (compareTrees $firstRightTree $secondRightTree) )
                )
                (if (or (== $leftTreeRes $rightTreeRes) (== $rightTreeRes 0))
                  $leftTreeRes
                  (if (== $leftTreeRes 0)
                    $rightTreeRes
                    (if ((== $leftTreeRes -1) (== $rightTreeRes 1))
                      (compareTrees $firstRightTree $secondLeftTree)
                      (compareTrees $firstLeftTree $secondRightTree)
                    )
                  )
                )
              ) 
            )
          )
        )
      )
    )
  )
)

(: has-terminal-node (-> Tree Bool))
(= (has-terminal-node NilNode) False)
(= (has-terminal-node $node) 
    (case $node 
        (
            ( 
                (TreeNode (Value $value $truthValue AND) NilNode NilNode $guardSet NilList) 
                ( unify $guardSet (ConsTree $singleNode NilList) True False)
            )
            (
                (TreeNode $nodeValue $left $right $guardSet $children) 
                ( or (has-terminal-node $left) (has-terminal-node $right)) 
            )
        )    
    )
)
;; !(has-terminal-node (TreeNode (Value Nil False OR) (TreeNode (Value Nil True AND) NilNode NilNode NilList NilList) (TreeNode (Value Nil False AND) NilNode (TreeNode (Value Nil False AND) NilNode NilNode (ConsTree (TreeNode (Value x True LITERAL) NilNode NilNode NilList NilList ) (ConsTree (TreeNode (Value x True LITERAL) NilNode NilNode NilList NilList ) NilList)) NilList) NilList NilList) NilList NilList) )

(: contains-terminal-node (-> TreeList Bool ))
(= (contains-terminal-node NilList) False)
(= (contains-terminal-node $treeList) 
    (case $treeList 
        (
            ( 
                (ConsTree $t $ts) 
                (or 
                    (has-terminal-node $t) 
                    (trace! (evaluating $ts ) (contains-terminal-node $ts))
                )
            )
            ; ($else (Invalid Expression--- $else))
        )
    )
)

; !(has-terminal-node (TreeNode (Value Nil False AND) (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) (TreeNode (Value Nil False AND) (TreeNode (Value NilNode False OR) NilNode NilNode (ConsTree (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) NilList ) NilList) (TreeNode (Value NilNode False AND) NilNode NilNode NilList NilList) NilList NilList) NilList NilList) ) 

; !(has-terminal-node (TreeNode (Value Nil False AND)
;     (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList)
;     (TreeNode (Value Nil False AND)
;         (TreeNode (Value NilNode False OR) NilNode NilNode (ConsTree (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) NilList ) NilList)
;         (TreeNode (Value NilNode False AND) 
;             (TreeNode (Value Nil False AND)
;             (TreeNode (Value NilNode False AND) NilNode NilNode (ConsTree (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) NilList ) NilList)
;             (TreeNode (Value NilNode False AND) NilNode NilNode NilList NilList)
;                 NilList
;                 NilList
;             ) 
;             NilNode NilList NilList)
;         NilList
;         NilList
;     )
;     NilList
;     NilList
; )
; )


; (ConsTree 
; (TreeNode (Value Nil False AND) (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) (TreeNode (Value Nil False AND) (TreeNode (Value NilNode False OR) NilNode NilNode (ConsTree (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) NilList ) NilList) (TreeNode (Value NilNode False AND) NilNode NilNode NilList NilList) NilList NilList) NilList NilList) NilList)


; !(contains-terminal-node
; (ConsTree 
;     (TreeNode (Value Nil False AND) (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) (TreeNode (Value Nil False AND) (TreeNode (Value NilNode False AND) NilNode NilNode (ConsTree (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) NilList ) NilList) (TreeNode (Value NilNode False AND) NilNode NilNode NilList NilList) NilList NilList) NilList NilList) 
;     (ConsTree (TreeNode (Value Nil False AND)
;     (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList)
;     (TreeNode (Value Nil False AND)
;         (TreeNode (Value NilNode False OR) NilNode NilNode (ConsTree (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) NilList ) NilList)
;         (TreeNode (Value NilNode False AND) 
;             (TreeNode (Value Nil False AND)
;             (TreeNode (Value NilNode False AND) NilNode NilNode (ConsTree (TreeNode (Value x False LITERAL) NilNode NilNode NilList NilList) NilList ) NilList) ;this node fulfills the condition
;             (TreeNode (Value NilNode False AND) NilNode NilNode NilList NilList)
;                 NilList
;                 NilList
;             ) 
;             NilNode NilList NilList)
;         NilList
;         NilList
;     )
;     NilList
;     NilList
; ) NilList)
;     )
;  )

; !(has-terminal-node (TreeNode
;   (Value Nil False AND)
;   (TreeNode
;     (Value x False LITERAL)
;     NilNode
;     NilNode
;     NilList
;     NilList
;   )
;   (TreeNode
;     (Value Nil False AND)
;     NilNode
;     NilNode
;     (ConsTree
;       (TreeNode
;         (Value b False LITERAL)
;         NilNode
;         NilNode
;         NilList
;         NilList
;       )
;       NilList
;     )
;     NilList
;   )
;   NilList
; )
; )