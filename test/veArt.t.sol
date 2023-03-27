// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/veArt.sol";
import {VotingEscrow} from "contracts-latest/VotingEscrow.sol";

contract veArtTest is Test {

    string RPC = vm.envString("RPC_URL");
    uint256 fork;

    veArt public art;
    VotingEscrow public nft;

    function setUp() public {
        fork = vm.createSelectFork(RPC);

        art = new veArt();
        nft = VotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);

        vm.startPrank(nft.team());
            nft.setArtProxy(address(art));
        vm.stopPrank();

    }

    function testSVG() public {
        vm.writeFile('test/output/testSVG.svg', art.renderSVG());
    }

    function testURI() public {
        vm.writeFile('test/output/testURI.txt', nft.tokenURI(688));
    }
}


