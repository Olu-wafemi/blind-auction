//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract BlindAuction is HelperConfig {
    address payable public beneficiary;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address => Bid[]) private bids;

    address private highestBidder;
    uint private highestBid;

    mapping(address => uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    error TooEarly(uint time);
    error TooLate(uint time);
    error AuctionEndAlreadyCalled();

    modifier onlyBefore(uint time) {
        if (block.timestamp >= time) revert TooLate(time);
        _;
    }

    modifier onlyAfter(uint time) {
        if (block.timestamp <= time) revert TooEarly(time);
        _;
    }

    constructor(
        uint TimeofBid,
        uint TimeofReveal,
        address payable AddressofBeneficiary
    ) {
        beneficiary = AddressofBeneficiary;
        biddingEnd = block.timestamp + TimeofBid;
        revealEnd = biddingEnd + TimeofReveal;
    }

    function bid(bytes32 blindedbid) external payable onlyBefore(biddingEnd) {
        //blindedBid = keccak256((abi.encodePacked(msg.value,fake, secret)));
        bids[msg.sender].push(
            Bid({blindedBid: blindedbid, deposit: msg.value})
        );
    }

    function reveal(
        uint[1] calldata values,
        bool[1] calldata fakes,
        bytes32[1] calldata secrets
    ) external onlyAfter(biddingEnd) onlyBefore(revealEnd) {
        uint length = bids[msg.sender].length;
        require(values.length == length);
        require(fakes.length == length);
        require(secrets.length == length);

        for (uint i = 0; i < length; i++) {
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) = (
                values[i],
                fakes[i],
                secrets[i]
            );
            if (
                bidToCheck.blindedBid !=
                keccak256(abi.encodePacked(value, fake, secret))
            ) {
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
    }

    function withdraw() external {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }

    function auctionEnd() external onlyAfter(revealEnd) {
        if (ended) revert AuctionEndAlreadyCalled();
        emit AuctionEnded(highestBidder, highestBid);
        ended = true;
        beneficiary.transfer(highestBid);
    }

    function placeBid(
        address bidder,
        uint value
    ) internal returns (bool success) {
        if (value <= highestBid) {
            return false;
        }
        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBid = value;
        highestBidder = bidder;
        return true;
    }

    //View fundtions

    function getBids(
        address biddingaddress
    ) external view returns (Bid[] memory) {
        return bids[biddingaddress];
    }

    function gethighestbidder() external view returns (address) {
        return highestBidder;
    }
}
