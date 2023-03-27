// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/veArt.sol";

contract veArtTest is Test {

    veArt public art;

    function setUp() public {
        art = new veArt();
    }

    function testSVG() public {

        vm.writeFile('test/output/testSVG.svg', art.renderSVG());

    }
}


