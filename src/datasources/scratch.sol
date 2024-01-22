  event LockCreate(
    uint256 indexed id,
    address indexed account,
    address indexed delegate,
    uint256 time,
    uint256 amount,
    uint256 slopePeriod,
    uint256 cliff
  );
  /**
   * @dev Emitted when change Lock parameters (newDelegate, newAmount, newSlopePeriod, newCliff) for Lock with given id
   */
  event Relock(
    uint256 indexed id,
    address indexed account,
    address indexed delegate,
    uint256 counter,
    uint256 time,
    uint256 amount,
    uint256 slopePeriod,
    uint256 cliff
  );
  /**
   * @dev Emitted when to set newDelegate address for Lock with given id
   */
  event Delegate(uint256 indexed id, address indexed account, address indexed delegate, uint256 time);
  /**
   * @dev Emitted when withdraw amount of Rari, account - msg.sender, amount - amount Rari
   */
  event Withdraw(address indexed account, uint256 amount);
  /**
   * @dev Emitted when migrate Locks with given id, account - msg.sender
   */
  event Migrate(address indexed account, uint256[] id);
  /**
   * @dev Stop run contract functions, accept withdraw, account - msg.sender
   */
  event StopLocking(address indexed account);
  /**
   * @dev Start run contract functions, accept withdraw, account - msg.sender
   */
  event StartLocking(address indexed account);
  /**
   * @dev StartMigration initiate migration to another contract, account - msg.sender, to - address delegate to
   */
  event StartMigration(address indexed account, address indexed to);
  /**
   * @dev set newMinCliffPeriod
   */
  event SetMinCliffPeriod(uint256 indexed newMinCliffPeriod);
  /**
   * @dev set newMinSlopePeriod
   */
  event SetMinSlopePeriod(uint256 indexed newMinSlopePeriod);
  /**
   * @dev set startingPointWeek
   */
  event SetStartingPointWeek(uint256 indexed newStartingPointWeek);
