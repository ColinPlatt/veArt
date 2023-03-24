// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "libSVG/SVG.sol";

contract veArt {
    using svg for string;

    function renderSVG() public pure returns (string memory) {
        return veBackground.card(
            uint256(1)
        );
    }

}

library veBackground {
    using svg for string;
    using utils for uint256; 

    string public constant VELO_GREEN = '#00e8c9';
    string public constant BG_BLACK = '#222323';

    string constant SVG_WRAP_TOP = 'xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 500 500" width="500" height="500" xmlns:xlink="http://www.w3.org/1999/xlink"';
    //style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd" 
   

    function card(uint256 id)
        internal 
        pure
        returns (string memory)
    {
        return string('svg').el(
            string.concat(SVG_WRAP_TOP), 
            string.concat(
                defs(),
                bgCard(),
                idText(id),
                headerText(),
                transparentBox(),
                veloLogo(),
                flowLogo()
            )
        );
    }

    function defs() private pure returns (string memory) {
        return string('defs').el(
            '',
            string.concat(
                svg.radialGradient(
                    string('id').prop('greenGradiant'),
                    string.concat(
                        svg.gradientStop(10, VELO_GREEN, ''),
                        svg.gradientStop(100, BG_BLACK, '')
                    )
                )
            )
        );
    }

    function bgCard() private pure returns (string memory) {
        return string.concat(
            string('x').prop('0'),
            string('y').prop('0'),
            string('width').prop('100%'),
            string('height').prop('100%'),
            string('fill').prop(BG_BLACK)
        ).rect();
    }

    function idText(uint256 _id) private pure returns (string memory) {
        return string.concat(
            svg.text(
                string.concat(
                    string('x').prop('125'),
                    string('y').prop('135'),
                    string('font-family').prop('Lucida Console'),
                    string('fill').prop(VELO_GREEN),
                    string('font-size').prop('20px'),
                    string('font-weight').prop('600')
                ),
                string.concat('Voted ID #', _id.toString())
            )
        );
    }
    

    function transparentBox()
        private 
        pure
        returns (string memory)
    {
        return string.concat(
                    string.concat(
                        boxBase(),
                        boxStroke()
                    ).rect(),
                    boxLineProps().line(),
                    boxTextStatic()
                );
    }

    function boxBase() private pure returns (string memory) {
        return string.concat(
            string('x').prop('45'),
            string('y').prop('155'),
            string('width').prop('410'),
            string('height').prop('320'),
            string('rx').prop('20'),
            string('fill').prop(VELO_GREEN),
            string('fill-opacity').prop('10%')
        );
    }

    function boxStroke() private pure returns (string memory) {
        return string.concat(
            string('stroke').prop('gray'),
            string('stroke-width').prop('5'),
            string('stroke-opacity').prop('10%')
        );
    }

    function boxLineProps() private pure returns (string memory) {
        return string.concat(
            string('x1').prop('45'),
            string('y1').prop('245'),
            string('x2').prop('455'),
            string('y2').prop('245'),
            string('stroke').prop('gray'),
            string('stroke-width').prop('3'),
            string('stroke-opacity').prop('10%')
        );
    }

    function boxTextStatic() private pure returns (string memory) {
        return svg.g(
            string.concat(
                string('font-family').prop('Courier'),
                string('fill').prop('white'),
                string('font-size').prop('18px')
            ),
            string.concat(
                svg.text(
                    string.concat(
                        string('x').prop('100'),
                        string('y').prop('280')
                    ),
                    'Balance:'
                ),
                svg.text(
                    string.concat(
                        string('x').prop('100'),
                        string('y').prop('315')
                    ),
                    '$NOTE Value:'
                ),
                svg.text(
                    string.concat(
                        string('x').prop('100'),
                        string('y').prop('350')
                    ),
                    'Votes:'
                ),
                svg.text(
                    string.concat(
                        string('x').prop('100'),
                        string('y').prop('385')
                    ),
                    'Influence:'
                ),
                svg.text(
                    string.concat(
                        string('x').prop('100'),
                        string('y').prop('420')
                    ),
                    'Matures on:'
                )
            )
        );
    }

    //Votes, Influence, Matures on

    function veloLogo() private pure returns (string memory) {
        return svg.g(
            '',
            string.concat(
                svg.polygon(
                    string.concat(
                        string('fill').prop(VELO_GREEN),
                        string('points').prop('42,31 53,31 73,50 93,31 104,31 73,85 Z')
                    )
                ),
                svg.polygon(
                    string.concat(
                        string('fill').prop(BG_BLACK),
                        string('points').prop('58,43 73,52 88,43 73,69 Z')
                    )
                )
            )
        );
    }

    string public constant arcLg = 'm2.2 1.6c2.3-0.074 4.1 0.76 5.5 2.5 0.87 1.2 1.3 2.5 1.3 3.9 3e-3 0.26-8e-3 0.51-0.033 0.77h-0.13c0.15-2-0.49-3.7-1.9-5.1-1.5-1.4-3.3-1.9-5.4-1.5-0.041-0.14-0.096-0.28-0.17-0.41 0.25-0.081 0.53-0.11 0.78-0.13z';

    function flowLogo() private pure returns (string memory) {
        return string.concat(
            svg.g(
                string('transform').prop('translate(75 175) scale(2.5)'),
                string.concat(
                    flowLogoOuter(),
                    flowLogoMid(),
                    flowLogoInner()
                )
            ),
            flowText()
        );
    }

    function flowLogoOuter() private pure returns (string memory) {
        return string.concat(
            svg.path(
                arcLg,
                string.concat(
                    string('id').prop('arcLg'),
                    string('fill').prop(VELO_GREEN)
                )
            ),
            svg.use(
                '#arcLg',
                string.concat(
                    string('transform').prop('rotate(120 2.5 8.5)')
                )
            ),
            svg.use(
                '#arcLg',
                string.concat(
                    string('transform').prop('rotate(240 2.5 8.5)')
                )
            )
        );
    }

    function flowLogoMid() private pure returns (string memory) {
        return string.concat(
            svg.use(
                '#arcLg',
                string.concat(
                    string('transform').prop('rotate(345 6 10)')
                )
            ),
            svg.use(
                '#arcLg',
                string.concat(
                    string('transform').prop('rotate(105 2.5 7.5) translate(0.5 0)')
                )
            ),
            svg.use(
                '#arcLg',
                string.concat(
                    string('transform').prop('translate(0 1.25) rotate(220 2.5 7.5)')
                )
            )
        );
    }

    function flowLogoInner() private pure returns (string memory) {
        return string.concat(
            svg.g(
                string('transform').prop('rotate(340 6 7) scale(0.85)'),
                flowLogoMid()
            )
        );
    }

    function flowText() private pure returns (string memory) {
        return string.concat(
            svg.text(
                string.concat(
                    string('x').prop('110'),
                    string('y').prop('195'),
                    string('font-family').prop('Lucida Console'),
                    string('fill').prop(VELO_GREEN),
                    string('font-size').prop('30px'),
                    string('font-weight').prop('800')
                ),
                'FLOW'
            ),
            flowSubText()
        );
    }

    function flowSubText() private pure returns (string memory) {
        return string.concat(
            svg.text(
                string.concat(
                    string('x').prop('110'),
                    string('y').prop('220'),
                    string('font-family').prop('Courier'),
                    string('fill').prop('gray'),
                    string('font-size').prop('18px'),
                    string('font-weight').prop('800')
                ),
                'Liquidity Lab Details'
            )
        );
    }

    function headerText() private pure returns (string memory) {
        return svg.g(
            '',
            string.concat(
                velocimeterText(),
                veFLOWText(), 
                gradiantLine()
            )
        );
    }

    function velocimeterText() private pure returns (string memory) {
        return string.concat(
            svg.text(
                string.concat(
                    string('x').prop('125'),
                    string('y').prop('45'),
                    string('font-family').prop('Lucida Console'),
                    string('fill').prop(VELO_GREEN),
                    string('font-size').prop('24px'),
                    string('font-weight').prop('600')
                ),
                'VELOCIMETER'
            )
        );
    }

    function veFLOWText() private pure returns (string memory) {
        return string.concat(
            svg.text(
                string.concat(
                    string('x').prop('125'),
                    string('y').prop('80'),
                    string('font-family').prop('Lucida Console'),
                    string('fill').prop('white'),
                    string('font-size').prop('40px'),
                    string('font-weight').prop('600')
                ),
                'veFLOW NFT'
            )
        );
    }

    function gradiantLine() private pure returns (string memory) {
        return svg.ellipse(
            string.concat(
                string('cx').prop('250'),
                string('cy').prop('100'),
                string('rx').prop('200'),
                string('ry').prop('5'),
                string('fill').prop("url('#greenGradiant')")
            )
        );
    }


}
