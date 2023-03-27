// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "libSVG/SVG.sol";
//import {IVeArtProxy} from "contracts-latest/interfaces/IVeArtProxy.sol";
import "solady/utils/DateTimeLib.sol";

interface IPair {
    function current(address tokenIn, uint amountIn) external view returns(uint);
}

interface IVotingEscrow {
    function balanceOfNFT(uint) external view returns (uint);
    function totalSupply() external view returns (uint);
}

interface IVeArtProxy {
    function _tokenURI(uint _tokenId, uint _balanceOf, uint _locked_end, uint _value) external view returns (string memory output);
}

contract veArt is IVeArtProxy {
    using svg for string;

    IVotingEscrow public constant VOTING_ESCROW = IVotingEscrow(0x8E003242406FBa53619769F31606ef2Ed8A65C00);
    IPair public constant FLOW_NOTE_PAIR = IPair(0x7e79E7B91526414F49eA4D3654110250b7D9444f);
    address public constant FLOW_TOKEN = 0xB5b060055F0d1eF5174329913ef861bC3aDdF029;
    
    function _tokenURI(uint _tokenId, uint _balanceOf, uint _locked_end, uint _value) external view returns (string memory output) {
        veBackground.NFT_STATS memory stats = veBackground.NFT_STATS({
            id:             _tokenId,
            notionalFlow:   _value,
            notionalNote:   FLOW_NOTE_PAIR.current(FLOW_TOKEN, _value),
            votes:          _balanceOf,
            voteInfluence:  (_balanceOf*10000)/VOTING_ESCROW.totalSupply(),
            expiry:         _locked_end
        });



    }

    function renderSVG() public view returns (string memory) {
        veBackground.NFT_STATS memory stats = veBackground.NFT_STATS({
            id:             123,
            notionalFlow:   1000e18,
            notionalNote:   10e18,
            votes:          10e9,
            voteInfluence:  69,
            expiry:         block.timestamp + 730 days
        });
        
        return veBackground.card(stats);
    }

}

library veBackground {
    using svg for string;
    using utils for uint256; 

    struct NFT_STATS {
        uint id;
        uint notionalFlow; // notional amount
        uint notionalNote; // notion amount in NOTE
        uint votes; //votes
        uint voteInfluence; // influence in bps
        uint expiry;        
    }

    string public constant VELO_GREEN = '#00e8c9';
    string public constant BG_BLACK = '#222323';

    string constant SVG_WRAP_TOP = 'xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 500 500" width="500" height="500" xmlns:xlink="http://www.w3.org/1999/xlink"';
    //style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd" 
   

    function card(NFT_STATS memory _stats)
        internal 
        pure
        returns (string memory)
    {
        return string('svg').el(
            string.concat(SVG_WRAP_TOP), 
            string.concat(
                defs(),
                bgCard(),
                idText(_stats.id),
                headerText(),
                transparentBox(_stats),
                veloLogo(),
                flowLogo()
            )
        );
    }

    struct curveParams {
        uint256 offset0;
        uint256 offset1;
        uint256 r;
        string cx;
    }

    function curveDefs() private pure returns (string memory curvesDefs_) {

        curveParams[8] memory curves = [
            curveParams( 0,  80, 100,   "50" ),
            curveParams(10, 100,  80,  "-20" ),
            curveParams( 0, 100,  50,   "40" ),
            curveParams( 0, 100,  80,   "100"),
            curveParams(70, 100,  75,  "-40" ),
            curveParams(50, 100,  75,   "130"),
            curveParams(50, 100,  30,   "20" ),
            curveParams(50, 100,  30,   "70" )
        ];

      
        unchecked{
            for (uint256 i = 0; i<8; ++i) {
                
                curvesDefs_ = string.concat(
                    curvesDefs_,
                    svg.radialGradient(
                        string.concat(
                            string('id').prop(string.concat('curveGradiant_', i.toString())),
                            string('r').prop(string.concat(curves[i].r.toString(), '%')),
                            string('cx').prop(string.concat(curves[i].cx, '%'))
                        ),
                        string.concat(
                            svg.gradientStop(curves[i].offset0, VELO_GREEN, string('stop-opacity').prop('1')),
                            svg.gradientStop(curves[i].offset1, VELO_GREEN, string('stop-opacity').prop('0'))
                        )
                    )
                );
            }
        }
        

    }

    function defs() private pure returns (string memory) {
        return string('defs').el(
            '',
            string.concat(
                '<path id="curve" d="m0 450 c100-0 300-250 500-250" fill="none"  stroke-width="4"/>',
                curveDefs(),
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


    function bgCurves() private pure returns (string memory curveBG_)  {
        string[25] memory curves = [
            "0",
            "20",
            "40",
            "60",
            "-20",
            "-40",
            "-60",
            "-80",
            "-10",
            "-50",
            "-30",
            "10",
            "30",
            "50",
            "70",
            "55",
            "-5",
            "5",
            "-15",
            "15",
            "-25",
            "25",
            "-35",
            "35",
            "-55"
        ];
      
        unchecked{
            for (uint256 i = 0; i<25; ++i) {
                curveBG_ = string.concat(
                    curveBG_,
                    svg.use(
                        '#curve',
                        string.concat(
                            string('y').prop(curves[i]),
                            string('stroke').prop(string.concat('url(#curveGradiant_',(i%7).toString(),')'))
                        )
                    )
                );
            }
        }
    }

    function bgCard() private pure returns (string memory) {
        return string.concat(
            string.concat(
                string('x').prop('0'),
                string('y').prop('0'),
                string('width').prop('100%'),
                string('height').prop('100%'),
                string('fill').prop(BG_BLACK)
            ).rect(),
            bgCurves()
        );
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
    

    function transparentBox(NFT_STATS memory _stats)
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
                    boxTextStatic(),
                    boxTextDynamic(_stats)
                );
    }

    function boxBase() private pure returns (string memory) {
        return string.concat(
            string('x').prop('45'),
            string('y').prop('155'),
            string('width').prop('410'),
            string('height').prop('320'),
            string('rx').prop('20'),
            string('fill').prop('#343636'),
            string('fill-opacity').prop('85%')
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

    function formatExpirationDate(uint timestamp) private pure returns (string memory) {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(timestamp);

        string[12] memory months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
        ];

        return string.concat(
            day.toString(),
            '-',
            months[month-1],
            '-',
            year.toString()
        );
    }

    function boxTextDynamic(NFT_STATS memory _stats) private pure returns (string memory) {
        return svg.g(
            string.concat(
                string('font-family').prop('Courier'),
                string('fill').prop('white'),
                string('font-size').prop('18px')
            ),
            string.concat(
                svg.text(
                    string.concat(
                        string('x').prop('240'),
                        string('y').prop('280')
                    ),
                    string.concat(
                        (_stats.notionalFlow/1e18).toString(),
                        '.',
                        (_stats.notionalFlow % 1e14).toString()
                    )
                ),
                svg.text(
                    string.concat(
                        string('x').prop('240'),
                        string('y').prop('315')
                    ),
                    string.concat(
                        (_stats.notionalNote/1e18).toString(),
                        '.',
                        (_stats.notionalNote % 1e14).toString()
                    )
                ),
                svg.text(
                    string.concat(
                        string('x').prop('240'),
                        string('y').prop('350')
                    ),
                    _stats.votes.toString()
                ),
                svg.text(
                    string.concat(
                        string('x').prop('240'),
                        string('y').prop('385')
                    ),
                    string.concat('0.', _stats.voteInfluence.toString(), '%')
                ),
                svg.text(
                    string.concat(
                        string('x').prop('240'),
                        string('y').prop('420')
                    ),
                    formatExpirationDate(_stats.expiry)
                )
            )
        );
    }

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
