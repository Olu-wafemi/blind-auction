//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract BlindAuction{
    struct Bid{
        bytes32 blindedBid;
        uint deposit;
    }

    address payable public beneficiary;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address=> Bid[]) public bids;

    address public highestBidder;
    uint public highestBid;

    mapping(address=> uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    error TooEarly(uint time);
    error TooLate(uint time);
    error AuctionEndAlreadyCalled();


    modifier onlyBefore(uint time){
        if(block.timestamp >=time) revert Toolate(time);
        _;
    }

    modifier onlyAfter(uint time){
        if(block.timestamp<= time) revert TooEarly(time);
        _;
    }

    constructor(
        uint TimeofBid,
        uint TimeofReveal,
        address payable AddressofBeneficiary
    ){
        beneficiary = AddressofBeneficiary;
        biddingEnd = block.timestamp + TimeofBid;
        revealEnd = biddingEnd+ TimeofReveal;
    }


    function bid(bytes32 blindedBid) external payable onlyBefore(biddingEnd){

        blindedBid = keccak256((abi.encodePacked((value,fake, secrets));))
        bids[msg.sender].push(Bid({
            blindedBid: blindedBid,
            deposit: msg.value
        }))
    }

    function reveal(
        uint[] calldata values
        bool[] calldata fakes,
        bytes32[] calldat secrets
    ) external onlyAfter(biddongEnd) onlyBefoe(revealEnd){
        uint length = bids[msg.sender].length;
        require(values.length == length);
        require(fakes.length == length);
        require(secrets.length == length);

        uint refund;
        for (uint i =0; i< length; i++){
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) = 
            (values[i], fakes[i], secrets[i]);
            if(bidTocheck.blindedBid!= keccak256(abi.encodePacked(value,fake,secret))){
                continue;
            }
            refund += bidToCheck.deposit;
            if(!fake && bidToCheck.deposit >= value){
                if(placeBid(msg.sender, value))
                refund -= value;
            }
            bidToCheck.blindedBid = bytes32(0);
        }
        payable(msg.sender).transfer(refund);
    }
    






}