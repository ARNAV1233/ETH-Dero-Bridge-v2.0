/* Private Token Smart Contract Example in DVM-BASIC.  
   DERO Smart Contracts Tokens privacy can be understood just like banks handle cash. Once cash is out from the bank, bank is not aware about it (who owns what value), until it is deposited back.
   Smart contract only maintains supply and other necessary items to keep it working.
   DERO Tokens can be tranfered to other wallets just like native DERO with Homomorphic Encryption and without involvement of issuing Smart Contracts.
   Token issuing Smart Contract cannot hold/freeze/control their tokens once they are issued and sent to any wallet. 
   This token is Private. Use Function InitializePrivate() Uint64 to make any Smart Contract private.
*/

    // Issue tokens after depositing DERO (Convert DERO to TOKENX)
    Function IssueTOKENX(amount Uint64, receipient String) Uint64 
	10 IF LOAD("owner") == SIGNER() THEN GOTO 30
	20 RETURN 1 
	30 IF IS_ADDRESS_VALID(ADDRESS_RAW(receipient)) == 0 THEN GOTO 20
	40 SEND_ASSET_TO_ADDRESS(ADDRESS_RAW(receipient), amount ,SCID())   // Increment balance of user, without knowing original balance, this is done homomorphically
	50  RETURN 0
	End Function
	
    // This function is used to initialize parameters during install time
    // InitializePrivate initializes a private SC
	Function InitializePrivate() Uint64
	10  STORE("owner", SIGNER())   // Store in DB  ["owner"] = address
	20  RETURN 0 
	End Function 

	
	// This function is used to change owner 
	// owner is an string form of address 
	Function TransferOwnership(newowner String) Uint64 
	10  IF LOAD("owner") == SIGNER() THEN GOTO 30 
	20  RETURN 1
	30  STORE("tmpowner",ADDRESS_RAW(newowner))
	40  RETURN 0
	End Function
	
	// Until the new owner claims ownership, existing owner remains owner
    Function ClaimOwnership() Uint64 
	10  IF LOAD("tmpowner") == SIGNER() THEN GOTO 30 
	20  RETURN 1
	30  STORE("owner",SIGNER()) // ownership claim successful
	40  RETURN 0
	End Function
	
	// if signer is owner, withdraw any requested funds
	// if everthing is okay, they will be showing in signers wallet
   Function Withdraw( amount Uint64) Uint64 
	10  IF LOAD("owner") == SIGNER() THEN GOTO 30 
	20  RETURN 1
	30  SEND_DERO_TO_ADDRESS(SIGNER(),amount)
	40  RETURN 0
	End Function
	
	// if signer is owner, provide him rights to update code anytime
        // make sure update is always available to SC
        Function UpdateCode( code String) Uint64 
	10  IF LOAD("owner") == SIGNER() THEN GOTO 30 
	20  RETURN 1
	30  UPDATE_SC_CODE(code)
	40  RETURN 0
	End Function
	
	

