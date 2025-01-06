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

    constructor(
        uint TimeofBid,
        uint TimeofReveal,
        address payable AddressofBeneficiary
    ){
        beneficiary = AddressofBeneficiary;
        biddingEnd = block.timestamp + TimeofBid;
        revealEnd = biddingEnd+ TimeofReveal;
    }


}