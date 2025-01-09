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


     function bid( bool fake, bytes32 secret)
        external
        payable
        onlyBefore(biddingEnd)
    {
        blindedBid = keccak256((abi.encodePacked(msg.value,fake, secret)));
        bids[msg.sender].push(Bid({
            blindedBid: blindedBid,
            deposit: msg.value
        }));
    }


    function reveal(
        uint[] calldata values,
        bool[] calldata fakes,
        bytes32[] calldata secrets
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
            bidToCheck.blindedBid = bytes32(0);
if (!fake && bidToCheck.deposit >= value) {
    if (!placeBid(msg.sender, value)) {
        
        payable(msg.sender).transfer(bidToCheck.deposit);
    }
} else {
    payable(msg.sender).transfer(bidToCheck.deposit);
}
    }

    function withdraw() external {
        uint amount = pendingReturns(msg.sender);
        if (amount > 0){
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }

    function auctionEnd() external onlyAfter(revealEnd){
        if(ended) revert AuctionEndAlreadyCalled();
        emit AuctionEnded(highestBidder, highestBid);
        ended = true;
        beneficiary.transfer(highestBid);
    }
    function placeBid(address bidder, uint value) internal returns (bool success){
        if (value <= highestBid){
            return false;
        }
        if(highestBidder != address(0)){
            pendingReturns[highestBidde] += highestBid;
         }
         highestBid = value;
         highestBidder = bidder;
         return true;

    }








}