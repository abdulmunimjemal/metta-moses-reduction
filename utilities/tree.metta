! (register-module! ../../metta-moses-reduction)
! (import! &self metta-moses-reduction:utilities:tree-ds)

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

;; (= (zip $x $y) ($x $y))

;; !(treeFoldl zip Nil (buildTree (AND A (AND B (AND C (AND (OR A (OR B (OR C A))) (AND B (AND (AND A A) (NOT A)))))))))
;; !(treeFoldr zip Nil (buildTree (AND A (AND B (AND C (AND (OR A (OR B (OR C A))) (AND B (AND (AND A A) (NOT A)))))))))
