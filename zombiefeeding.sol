// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./zombiefactory.sol";
contract ZombieFeeding is ZombieFactory {


  modifier onlyOwnerOf(uint _zombieId){
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

 function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(block.timestamp + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= block.timestamp) ;
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna) internal onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

}
