pragma solidity ^0.6.0;

def storage:
  owner is addr at storage 0
  balanceOf is mapping of uint256 at storage 1
  allowance is mapping of uint256 at storage 2
  totalSupply is uint256 at storage 3
  name is array of uint256 at storage 4
  symbol is array of uint256 at storage 5
  mintingFinished is uint8 at storage 6 offset 8
  decimals is uint8 at storage 6

def mintingFinished() payable: 
  return bool(mintingFinished)

def name() payable: 
  return name[0 len name.length]

def totalSupply() payable: 
  return totalSupply

def decimals() payable: 
  return decimals

def balanceOf(address _owner) payable: 
  require calldata.size - 4 >= 32
  return balanceOf[addr(_owner)]

def owner() payable: 
  return owner

def symbol() payable: 
  return symbol[0 len symbol.length]

def allowance(address _owner, address _spender) payable: 
  require calldata.size - 4 >= 64
  return allowance[addr(_owner)][addr(_spender)]

#
#  Regular functions
#

def _fallback() payable: # default function
  revert

def renounceOwnership() payable: 
  if owner != caller:
      revert with 0, 'eOwnable: caller is not the owne'
  log OwnershipTransferred(
        address previousOwner=owner,
        address newOwner=0)
  owner = 0

def finishMinting() payable: 
  if mintingFinished:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  34,
                  0x7345524332304d696e7461626c653a206d696e74696e672069732066696e69736865,
                  mem[198 len 30]
  if owner != caller:
      revert with 0, 'eOwnable: caller is not the owne'
  mintingFinished = 1
  log MintFinished()

def transferOwnership(address _newOwner) payable: 
  require calldata.size - 4 >= 32
  if owner != caller:
      revert with 0, 'eOwnable: caller is not the owne'
  if not _newOwner:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  38,
                  0x734f776e61626c653a206e6577206f776e657220697320746865207a65726f20616464726573,
                  mem[202 len 26]
  log OwnershipTransferred(
        address previousOwner=owner,
        address newOwner=_newOwner)
  owner = _newOwner

def approve(address _spender, uint256 _value) payable: 
  require calldata.size - 4 >= 64
  if not caller:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  36,
                  0x7345524332303a20617070726f76652066726f6d20746865207a65726f20616464726573,
                  mem[200 len 28]
  if not _spender:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  34,
                  0x7345524332303a20617070726f766520746f20746865207a65726f20616464726573,
                  mem[198 len 30]
  allowance[caller][addr(_spender)] = _value
  log Approval(
        address owner=_value,
        address spender=caller,
        uint256 value=_spender)
  return 1

def mint(address _to, uint256 _amount) payable: 
  require calldata.size - 4 >= 64
  if mintingFinished:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  34,
                  0x7345524332304d696e7461626c653a206d696e74696e672069732066696e69736865,
                  mem[198 len 30]
  if owner != caller:
      revert with 0, 'eOwnable: caller is not the owne'
  if not _to:
      revert with 0, 'ERC20: mint to the zero address'
  if _amount + totalSupply < totalSupply:
      revert with 0, 'SafeMath: addition overflow'
  totalSupply += _amount
  if _amount + balanceOf[addr(_to)] < balanceOf[addr(_to)]:
      revert with 0, 'SafeMath: addition overflow'
  balanceOf[addr(_to)] += _amount
  log Transfer(
        address from=_amount,
        address to=0,
        uint256 value=_to)

def decreaseAllowance(address _spender, uint256 _subtractedValue) payable: 
  require calldata.size - 4 >= 64
  if _subtractedValue > allowance[caller][addr(_spender)]:
      revert with 0, 
                  32,
                  37,
                  0x6445524332303a2064656372656173656420616c6c6f77616e63652062656c6f77207a6572,
                  mem[165 len 27],
                  mem[219 len 5]
  if not caller:
      revert with 0, 32, 36, 0x7345524332303a20617070726f76652066726f6d20746865207a65726f20616464726573, mem[296 len 28]
  if not _spender:
      revert with 0, 32, 34, 0x7345524332303a20617070726f766520746f20746865207a65726f20616464726573, mem[294 len 30]
  allowance[caller][addr(_spender)] -= _subtractedValue
  log Approval(
        address owner=(allowance[caller][addr(_spender)] - _subtractedValue),
        address spender=caller,
        uint256 value=_spender)
  return 1

def increaseAllowance(address _spender, uint256 _addedValue) payable: 
  require calldata.size - 4 >= 64
  if _addedValue + allowance[caller][addr(_spender)] < allowance[caller][addr(_spender)]:
      revert with 0, 'SafeMath: addition overflow'
  if not caller:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  36,
                  0x7345524332303a20617070726f76652066726f6d20746865207a65726f20616464726573,
                  mem[200 len 28]
  if not _spender:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  34,
                  0x7345524332303a20617070726f766520746f20746865207a65726f20616464726573,
                  mem[198 len 30]
  allowance[caller][addr(_spender)] += _addedValue
  log Approval(
        address owner=(_addedValue + allowance[caller][addr(_spender)]),
        address spender=caller,
        uint256 value=_spender)
  return 1

def transfer(address _to, uint256 _value) payable: 
  require calldata.size - 4 >= 64
  if not caller:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  37,
                  0x7245524332303a207472616e736665722066726f6d20746865207a65726f20616464726573,
                  mem[201 len 27]
  if not _to:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  35,
                  0xfe45524332303a207472616e7366657220746f20746865207a65726f20616464726573,
                  mem[199 len 29]
  if _value > balanceOf[caller]:
      revert with 0, 
                  32,
                  38,
                  0x7345524332303a207472616e7366657220616d6f756e7420657863656564732062616c616e63,
                  mem[166 len 26],
                  mem[218 len 6]
  balanceOf[caller] -= _value
  if _value + balanceOf[_to] < balanceOf[_to]:
      revert with 0, 'SafeMath: addition overflow'
  balanceOf[addr(_to)] = _value + balanceOf[_to]
  log Transfer(
        address from=_value,
        address to=caller,
        uint256 value=_to)
  return 1

def transferFrom(address _from, address _to, uint256 _value) payable: 
  require calldata.size - 4 >= 96
  if not _from:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  37,
                  0x7245524332303a207472616e736665722066726f6d20746865207a65726f20616464726573,
                  mem[201 len 27]
  if not _to:
      revert with 0x8c379a000000000000000000000000000000000000000000000000000000000, 
                  32,
                  35,
                  0xfe45524332303a207472616e7366657220746f20746865207a65726f20616464726573,
                  mem[199 len 29]
  if _value > balanceOf[addr(_from)]:
      revert with 0, 
                  32,
                  38,
                  0x7345524332303a207472616e7366657220616d6f756e7420657863656564732062616c616e63,
                  mem[166 len 26],
                  mem[218 len 6]
  balanceOf[addr(_from)] -= _value
  if _value + balanceOf[_to] < balanceOf[_to]:
      revert with 0, 'SafeMath: addition overflow'
  balanceOf[addr(_to)] = _value + balanceOf[_to]
  log Transfer(
        address from=_value,
        address to=_from,
        uint256 value=_to)
  if _value > allowance[addr(_from)][caller]:
      revert with 0, 
                  32,
                  40,
                  0x6545524332303a207472616e7366657220616d6f756e74206578636565647320616c6c6f77616e63,
                  mem[264 len 24],
                  mem[312 len 8]
  if not _from:
      revert with 0, 32, 36, 0x7345524332303a20617070726f76652066726f6d20746865207a65726f20616464726573, mem[392 len 28]
  if not caller:
      revert with 0, 32, 34, 0x7345524332303a20617070726f766520746f20746865207a65726f20616464726573, mem[390 len 30]
  allowance[addr(_from)][caller] -= _value
  log Approval(
        address owner=(allowance[addr(_from)][caller] - _value),
        address spender=_from,
        uint256 value=caller)
  return 1

