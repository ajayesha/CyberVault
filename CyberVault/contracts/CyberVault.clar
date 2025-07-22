;; title: CyberVault-DataOptions
;; version: 2.0
;; summary: Cyberpunk-themed neural data derivatives
;; description: Trade encrypted data packets in the digital underground

;; Constants
(define-constant NETRUNNER tx-sender)
(define-constant ERR-CONNECTION-TIMEOUT (err u1))
(define-constant ERR-INVALID-BANDWIDTH (err u2))
(define-constant ERR-ACCESS-DENIED (err u3))
(define-constant ERR-FILE-NOT-FOUND (err u4))
(define-constant ERR-INSUFFICIENT-CREDITS (err u5))
(define-constant ERR-ALREADY-DECRYPTED (err u6))
(define-constant ERR-CORRUPTED-DATA (err u7))
(define-constant ERR-NEURAL-LINK-DOWN (err u8))

;; Protocol Types
(define-constant UPLOAD-STREAM u1)
(define-constant DOWNLOAD-STREAM u2)

;; Data Maps
(define-map CyberWallets 
    { hacker: principal }
    { credits: uint }
)

(define-map DataContracts
    { packet-id: uint }
    {
        coder: principal,
        client: (optional principal),
        protocol-type: uint,
        execution-price: uint,
        access-fee: uint,
        deadline: uint,
        data-size: uint,
        is-encrypted: bool,
        is-executed: bool,
        upload-timestamp: uint
    }
)

(define-map NetrunnerProfiles
    { user: principal }
    { coded: (list 20 uint), downloaded: (list 20 uint) }
)

;; Data Variables
(define-data-var next-packet-id uint u0)
(define-data-var market-feed uint u0)

;; Authorization
(define-private (is-netrunner)
    (is-eq tx-sender NETRUNNER)
)

;; Credit Management
(define-public (jack-in-credits (amount uint))
    (let
        ((user tx-sender)
         (current-wallet (default-to { credits: u0 } (map-get? CyberWallets { hacker: user }))))
        (map-set CyberWallets
            { hacker: user }
            { credits: (+ amount (get credits current-wallet)) })
        (ok true)
    )
)

(define-public (jack-out-credits (amount uint))
    (let
        ((user tx-sender)
         (current-wallet (default-to { credits: u0 } (map-get? CyberWallets { hacker: user }))))
        (asserts! (>= (get credits current-wallet) amount) ERR-INSUFFICIENT-CREDITS)
        (map-set CyberWallets
            { hacker: user }
            { credits: (- (get credits current-wallet) amount) })
        (ok true)
    )
)

(define-private (wire-transfer (sender principal) (receiver principal) (amount uint))
    (let
        ((sender-wallet (default-to { credits: u0 } (map-get? CyberWallets { hacker: sender })))
         (receiver-wallet (default-to { credits: u0 } (map-get? CyberWallets { hacker: receiver }))))
        (asserts! (>= (get credits sender-wallet) amount) ERR-INSUFFICIENT-CREDITS)
        (map-set CyberWallets
            { hacker: sender }
            { credits: (- (get credits sender-wallet) amount) })
        (map-set CyberWallets
            { hacker: receiver }
            { credits: (+ amount (get credits receiver-wallet)) })
        (ok true)
    )
)

(define-private (update-netrunner-profiles (user principal) (packet-id uint) (is-coder bool))
    (let
        ((user-profile (default-to 
            { coded: (list ), downloaded: (list ) }
            (map-get? NetrunnerProfiles { user: user }))))
        (if is-coder
            (ok (map-set NetrunnerProfiles
                { user: user }
                { coded: (unwrap! (as-max-len? (append (get coded user-profile) packet-id) u20) ERR-ACCESS-DENIED),
                  downloaded: (get downloaded user-profile) }))
            (ok (map-set NetrunnerProfiles
                { user: user }
                { coded: (get coded user-profile),
                  downloaded: (unwrap! (as-max-len? (append (get downloaded user-profile) packet-id) u20) ERR-ACCESS-DENIED) })))
    )
)