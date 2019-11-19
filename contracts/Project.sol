pragma solidity ^0.5.0;

import "./SSToken.sol";


contract Project {
  using SafeMath for *;

  // 클라이언트에 보낼 이벤트(트랜잭션 로그)) 정의
  event LogFundRaised(address indexed contributor, uint indexed amount);
  event LogFundingGoalReached(uint indexed time, uint funding);
  event LogRefund(address indexed contributor, address indexed project, uint indexed amount);
  event LogPayout(address indexed owner, uint indexed payout);
  event LogDistributed(address indexed contributor);  // 수정 필요

  enum FundingStage {
    Open,             // 펀딩이 시작되고 아직 목표 금액이 모이지 않은 상태
    GoalReached,      // 목표 금액이 달성된 상태
    Distribution,     // 배당 진행, 이 상태에서 프로젝트는 Closed 상태가 될 수 없다.
    Failed            // 데드라인까지 목표금액 달성에 실패, 프로젝트는 Closed 상태가 된다.
  }

  uint creationTime;
  uint public deadline;
  uint public fundingGoal;
  address public owner;
  address public backAccount;
  address payable[] private fundRaisers;
  FundingStage stage;
  SSToken public fundingToken;

  constructor (
    // address _owner,             // 펀딩된 금액을 받을 사람 - 게임회사 사장?
    // uint _fundingGoal,          // 목표 금액 (토큰 단위로)
    // uint _deadline,             // 기한 (초 단위로)
    // // uint256 _tokenPrice,         // 토큰 가격 -> 100peb(또는 wei)으로 고정
    // string memory _name,         // 토큰 이름  ex) bitcoin
    // string memory _symbol        // 토큰 심볼  ex) BTC
    // // uint8 decimals,             // 토큰을 몇 자리 이후부터 표시할 것인가 -> 2로 고정
  )
    public
  {
    // owner = _owner;
    owner = msg.sender;
    backAccount = msg.sender;
    // fundingGoal = _fundingGoal;
    fundingGoal = 2000000000000000000;
    creationTime = now;
    // deadline = _deadline;
    deadline = 10000;
    // fundingToken = new SSToken(100, _name, _symbol, 2);
    fundingToken = new SSToken(100, "ssToken", "SST", 2);
    stage = FundingStage.Open;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Not Authorized Owner");
    _;
  }

  modifier onlyGoalReached {
    require(stage == FundingStage.GoalReached, "Not Accepted");
    _;
  }

  function amountRaised() public view returns (uint amount) {
    amount = fundingToken.totalSupply();
  }

  function requiredAmount() public view returns (uint amount){
    amount = fundingGoal - fundingToken.totalSupply();
  }

  function fundingStage() public view returns (FundingStage) {
    return stage;
  }

  function getContractBalance() public view returns (uint){
    return address(this).balance;
  }

  function changeStage(uint num) public returns (string memory){
    if (num == 0) {
      stage = FundingStage.Open;
      return "Open";
    } else if (num == 1) {
      stage = FundingStage.GoalReached;
      return "GoalReached";
    } else if (num == 2) {
      stage = FundingStage.Distribution;
      return "Distribution";
    } else if (num == 3) {
      stage = FundingStage.Failed;
      return "Failed";
    }
  }



  /**
   * @dev deposit function
   */
  function deposit() public payable{}

  /**
   * @dev fund function
   */
  function fund() public payable returns (bool) {
    require(fundingStage() == FundingStage.Open, "모금 기간이 종료되었습니다..");
    require(msg.value > 0, "부적절한 입력값입니다. value를 확인하세요.");

    uint256 _funding = msg.value/fundingToken.price();

    fundRaisers.push(msg.sender);
    require(fundingToken.mint(msg.sender, _funding), "Not Authenticated Minter");
    emit LogFundRaised(msg.sender, _funding);

    if (amountRaised() == fundingGoal) {
      stage = FundingStage.GoalReached;
      emit LogFundingGoalReached(now, _funding);
    }
    return true;
  }

  function withdraw() public onlyOwner returns (bool) {
    msg.sender.transfer(address(this).balance);
  }

  function refund() public {
    // 기간 내에 목표 금액이 모이지 않았을 시에만 환불 가능
    require(stage == FundingStage.Failed, "funding was not failed");
    // owner에게 보낼 토큰 양
    uint256 amount = fundingToken.balanceOf(msg.sender) * fundingToken.price();

    // KLAY 환불
    msg.sender.transfer(amount);
    emit LogRefund(msg.sender, address(this), amount);
  }


  /**
   * @dev distribute margins to fund raisers
   */
  function distribute(uint256 margin) public returns (bool) {
    for (uint i = 0; i < fundRaisers.length; i++) {
      uint ratio = fundingToken.balanceOf(fundRaisers[i]).div(amountRaised());
      uint amount = margin.mul(ratio);
      fundRaisers[i++].transfer(amount);
    }
    return true;
  }
}