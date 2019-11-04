pragma solidity ^0.5.0;

import "./FundingToken.sol";


contract StandardProject {
  // 클라이언트에 보낼 이벤트(트랜잭션 로그)) 정의
  event LogContractConstructed(address addr);
  event LogFundRaised(address indexed contributor, uint indexed amount);
  event LogFundingGoalReached(uint indexed time, uint funding);
  event LogRefund(address indexed contributor, address indexed project, uint indexed amount);
  event LogPayout(address indexed beneficiary, uint indexed payout);
  event LogDistributed(address indexed contributor);  // 수정 필요

  enum ProjectStatus {
    Active,   // FundingStage는 Open, FundingRaised, GoalReached 가능
    Expired,  // FundingStage는 GoalReached, Distribution, failed 가능
    Closed    // FuncdingStage가 Fail일 때만 가능
  }

  enum FundingStage {
    Open,             // 펀딩이 시작되고 아직 목표 금액이 모이지 않은 상태
    GoalReached,      // 목표 금액이 달성된 상태
    Distribution,     // 배당 진행, 이 상태에서 프로젝트는 Closed 상태가 될 수 없다.
    Failed            // 데드라인까지 목표금액 달성에 실패, 프로젝트는 Closed 상태가 된다.
  }
	// address public owner;

  // uint createdAtBlock;
  uint creationTime;
  uint public deadline;
  uint public fundingGoal;
  address public beneficiary;

  ProjectStatus status;
  FundingStage stage;
  FundingToken public fundingToken;

  constructor (address _creator,// 펀딩된 금액을 받을 사람 - 게임회사 사장?
    uint _fundingGoal,          // 목표 금액 (토큰 단위로)
    uint _deadline,             // 기한 (초 단위로)
    uint256 initialSupply,      // 토큰 발행량
    uint256 tokenPrice,         // 토큰 가격
    string memory name,         // 토큰 이름  ex) bitcoin
    string memory symbol        // 토큰 심볼  ex) BTC
  )
    public
  {
    beneficiary = _creator;
    fundingGoal = _fundingGoal;
    creationTime = now;
    deadline = _deadline;
    fundingToken = new FundingToken(initialSupply, tokenPrice, name, symbol);
    emit LogContractConstructed(address(fundingToken));
    stage = FundingStage.Open;
    status = ProjectStatus.Active;
  }

  modifier evalExpiry {
    if (now > creationTime + deadline &&
        status != ProjectStatus.Closed) {
        status = ProjectStatus.Expired;
    }
    _;
  }

  modifier evalFundingStage {
    // 프로젝트가 안 닫혀 있고
    if (status != ProjectStatus.Closed) {
      // 목표 금액을 달성했으면
      if (fundingToken.balanceOf(beneficiary) >= fundingGoal) {
        // 목표 달성...
        stage = FundingStage.GoalReached;
        // 펀딩 기간이 만료되면 배당 스테이지로 넘어간다.
        if (status == ProjectStatus.Expired) {
          stage = FundingStage.Distribution;
        }
      } else {
        // 목표 금액 달성 안된 상태에서 기간 만료되면
        if (status == ProjectStatus.Expired) {
          // 펀딩 실패
          stage == FundingStage.Failed;
        }
      }
    }
    _;
  }

  function amountRaised()
    public
    view
    returns (uint amount)
  {
    amount = fundingToken.balanceOf(address(this));
  }

  function projectStatus()
    public
    evalExpiry
    evalFundingStage
    returns (ProjectStatus)
  {
    return status;
  }

  function fundingStage()
    public
    evalExpiry
    evalFundingStage
    returns (FundingStage)
  {
    return stage;
  }


  function fund(uint _funding, address investor) public payable returns (bool) {
    require(fundingStage() == FundingStage.Open && msg.value > 0,
            "모금 기간이 종료되었거나 부적절한 입력값입니다.");

    // Reduce contribution amount if it exceeds funding Goal, or overflows
    if (amountRaised() + _funding > fundingGoal ||
      amountRaised() + _funding < amountRaised()) {
      _funding = fundingGoal - amountRaised();
    }
    
    // require(fundingToken.contribute(_funding, investor) &&
    //         fundingToken.transferFrom(investor, this, _funding));
    require(fundingToken.transfer(investor, _funding));
    emit LogFundRaised(investor, _funding);

    if (amountRaised() == fundingGoal) {
      stage = FundingStage.GoalReached;
      emit LogFundingGoalReached(now, _funding);
    }
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



   


  // function payout() public {
  //   require(stage == FundingStage.Success ||
  //           stage == FundingStage.EarlySuccess);

  //   uint payOut = fundingToken.balanceOf(this);
  //   require(fundingToken.transfer(beneficiary, payOut));
  //   stage = FundingStage.PaidOut;
  //   status = ProjectStatus.Closed;
  //   LogPayout(beneficiary, payOut);
  // }

}