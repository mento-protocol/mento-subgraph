import { Address, BigInt } from "@graphprotocol/graph-ts";
import { Locking, Lock } from "../../generated/schema";

import { fetchAccount } from "./account";

export function fetchLocking(address: Address): Locking {
  let contract = Locking.load(address);

  if (contract == null) {
    contract = new Locking(address);
    contract.asAccount = address;
    contract.save();

    let account = fetchAccount(address);
    account.asLocking = address;
    account.save();
  }

  return contract;
}

export function fetchLock(contract: Locking, lockId: BigInt): Lock {
  let id = contract.id.toHex().concat("/").concat(lockId.toHex());
  let lock = Lock.load(id);

  if (lock == null) {
    lock = new Lock(id);
    lock.locking = contract.id;
    lock.lockId = lockId;
    lock.owner = Address.zero();
    lock.delegate = Address.zero();
    lock.time = BigInt.zero();
    lock.amount = BigInt.zero();
    lock.slope = 0;
    lock.cliff = 0;
  }

  return lock;
}
