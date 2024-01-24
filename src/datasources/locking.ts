import { LockCreate, Relock, Delegate, Withdraw } from "../../generated/schema";

import {
  LockCreate as LockCreateEvent,
  Relock as RelockEvent,
  Delegate as DelegateEvent,
  Withdraw as WithdrawEvent,
} from "../../generated/locking/Locking";

import { events, transactions } from "@amxx/graphprotocol-utils";

import { fetchAccount } from "../fetch/account";

import { fetchLocking, fetchLock } from "../fetch/locking";

export function handleLockCreate(event: LockCreateEvent): void {
  let locking = fetchLocking(event.address);

  let lock = fetchLock(locking, event.params.id);
  lock.owner = fetchAccount(event.params.account).id;
  lock.delegate = fetchAccount(event.params.delegate).id;
  lock.time = event.params.time;
  lock.amount = event.params.amount;
  lock.slope = event.params.slopePeriod.toI32();
  lock.cliff = event.params.cliff.toI32();
  lock.relocked = false;
  lock.save();

  let ev = new LockCreate(events.id(event));
  ev.emitter = locking.id;
  ev.transaction = transactions.log(event).id;
  ev.timestamp = event.block.timestamp;
  ev.locking = lock.locking;
  ev.lock = lock.id;
  ev.owner = event.params.account;
  ev.save();
}

export function handleRelock(event: RelockEvent): void {
  let locking = fetchLocking(event.address);

  let oldLock = fetchLock(locking, event.params.id);
  let newLock = fetchLock(locking, event.params.counter);
  oldLock.relocked = true;
  oldLock.replacedBy = newLock.id;
  oldLock.save();

  newLock.owner = fetchAccount(event.params.account).id;
  newLock.delegate = fetchAccount(event.params.delegate).id;
  newLock.time = event.params.time;
  newLock.amount = event.params.amount;
  newLock.slope = event.params.slopePeriod.toI32();
  newLock.cliff = event.params.cliff.toI32();
  newLock.replaces = oldLock.id;
  newLock.relocked = false;
  newLock.save();

  let ev = new Relock(events.id(event));
  ev.emitter = locking.id;
  ev.transaction = transactions.log(event).id;
  ev.timestamp = event.block.timestamp;
  ev.locking = newLock.locking;
  ev.newLock = newLock.id;
  ev.oldLock = oldLock.id;
  ev.owner = newLock.owner;
  ev.save();
}

export function handleDelegate(event: DelegateEvent): void {
  let locking = fetchLocking(event.address);

  let lock = fetchLock(locking, event.params.id);
  lock.delegate = fetchAccount(event.params.delegate).id;
  lock.save();

  let ev = new Delegate(events.id(event));
  ev.emitter = locking.id;
  ev.locking = locking.id;
  ev.lock = lock.id;
  ev.transaction = transactions.log(event).id;
  ev.timestamp = event.block.timestamp;
  ev.owner = event.params.account;
  ev.delegate = event.params.delegate;
  ev.save();
}

export function handleWithdraw(event: WithdrawEvent): void {
  let locking = fetchLocking(event.address);

  let ev = new Withdraw(events.id(event));
  ev.emitter = locking.id;
  ev.locking = locking.id;
  ev.transaction = transactions.log(event).id;
  ev.timestamp = event.block.timestamp;
  ev.owner = event.params.account;
  ev.amount = event.params.amount;
  ev.save();
}
