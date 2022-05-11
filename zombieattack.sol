// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./zombihelper.sol";
import"./Chainlink.sol";

interface IRandom {
    function get() external view returns (uint);
}

contract ZombieAttack is ZombieHelper{
  address oracleAddress;
  uint attackVictoryProbability = 70;

  function _setAddress(address _addr) private onlyOwner{
          oracleAddress = _addr;
    }

    function getRandom(uint _a) private view returns(uint){
      uint randNum = IRandom(oracleAddress).get();
      return randNum % _a;
    }


  function attack(uint _zombieId, uint _targetId) external  onlyOwnerOf(_zombieId){
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = getRandom(100);
    if (rand <= attackVictoryProbability) {
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      feedAndMultiply(_zombieId, enemyZombie.dna);
    } else {
      myZombie.lossCount++;
      enemyZombie.winCount++;
      _triggerCooldown(myZombie);
    }
  }
}
