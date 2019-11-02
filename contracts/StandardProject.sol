pragma solidity ^0.5.0;

import "./Project.sol";


contract StandardProject is Project {
	address public owner;

  constructor () public {

  }

  function fund(uint _funding, address investor) public {
    require(fundingStage() == FundingStage.Open);

    //
  }

  function refund() public {
    // 기간 내에 목표 금액이 모이지 않았을 시에만 환불 가능
    require(stage == FundingStage.Failed);
    // beneficiary에게 보낼 토큰 양
    uint256 amount = fundingToken.balanceOf(msg.sender);
    // beneficiary 한테 토큰 송금
    require(fundingToken.transfer(beneficiary, amount));
    // KLAY 환불
    msg.sender.transfer(amount * fundingToken.price());
    emit LogRefund(msg.sender, address(this), amount);
  }

  function payout() public {
    require(stage == FundingStage.Success ||
            stage == FundingStage.EarlySuccess);

    uint payOut = fundingToken.balanceOf(this);
    require(fundingToken.transfer(beneficiary, payOut));
    stage = FundingStage.PaidOut;
    status = ProjectStatus.Closed;
    LogPayout(beneficiary, payOut);
  }

}