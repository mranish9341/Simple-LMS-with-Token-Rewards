;; Simple LMS with Token Rewards

;; Define the token for rewards
(define-fungible-token learn-token)

;; Data map to track course completions
(define-map completed-courses {
  student: principal,
  course-id: uint
} bool)

;; Token reward per course
(define-constant reward-per-course u100)

;; Complete course and reward tokens
(define-public (complete-course (course-id uint))
  (begin
    (asserts! (not (is-eq tx-sender 'SP000000000000000000002Q6VF78.pox)) (err u401))
    (asserts! (is-none (map-get? completed-courses {student: tx-sender, course-id: course-id})) (err u403))
    (map-set completed-courses {student: tx-sender, course-id: course-id} true)
    (try! (ft-mint? learn-token reward-per-course tx-sender))
    (ok true)
  ))

;; Check if course completed
(define-read-only (is-course-completed (student principal) (course-id uint))
  (ok (is-some (map-get? completed-courses {student: student, course-id: course-id}))))