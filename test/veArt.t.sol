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

    Pure public pureCt;
    View public viewCt;

    function testInterface() public {

        pureCt = new Pure();
        viewCt = new View();

        emit log_string(IView(address(pureCt)).check());
        emit log_string(IPure(address(viewCt)).check());

    }

}


interface IView {
    function check() external view returns (string memory);
}


interface IPure {
    function check() external pure returns (string memory);
}

contract Pure is IPure {
    string public constant checkStr = "checkPure";

     function check() external pure returns (string memory) {
        return checkStr;
     }
}

contract View is IView {
    string public checkStr = "checkView";

     function check() external view returns (string memory) {
        return checkStr;
     }
}
