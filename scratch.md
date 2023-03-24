

**to calculate**
FLOW/NOTE - exchange_rate
pair 0x7e79E7B91526414F49eA4D3654110250b7D9444f
flow 0xB5b060055F0d1eF5174329913ef861bC3aDdF029
function current(address tokenIn, uint amountIn) external view returns(uint);

token ID    <= _tokenId [no change]
NFT balance <=  _balanceOf [no change]
NOTE value <=  pair.current(address(flow), _balanceOf)
Votes
Influence
Matures on <=  _locked_end [no change]

//_tokenURI(uint _tokenId, uint _balanceOf, uint _locked_end, uint _value)