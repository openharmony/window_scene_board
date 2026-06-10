/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import observer from '@ohos.telephony.observer';
import sim from '@ohos.telephony.sim';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus, SimPinVerifyEvent, sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { AbstractObserverManager, ObserverAble } from '../base/AbstractObserverManager';
import { SimCardUtils } from '../utils/SimCardUtils';
import { SystemParamUtils } from '../utils/SystemParamUtils';
import { CapsuleQueue } from '../base/CapsuleQueue';
import { getSimLabelSync, SimLabel, SimType } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubSimGetLabel';

const TAG = 'SimCardStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DEFAULT_PIN_REMAIN_TIMES = 3;
const DEFAULT_PUK_REMAIN_TIMES = 10;
const BROADCAST_DELAY_MILLIS = 500;

/**
 * 定义锁定类型
 */
export enum LockType {
  UNLOCK = '',
  PIN_LOCK = 'pin',
  PUK_LOCK = 'puk',
}

/**
 * Sim卡信息，属性只支持读取
 */
export class SimCard {
  /**
   * [原始指标]slotID
   */
  private readonly _slotId: number = 0;

  /**
   * [原始指标]SIM卡状态
   */
  private _simState: sim.SimState = sim.SimState.SIM_STATE_UNKNOWN;

  /**
   * 锁定类型
   */
  private _lockType: LockType = LockType.UNLOCK;

  /**
   * pin验证剩余次数
   */
  private _pinRemainTimes: number = DEFAULT_PIN_REMAIN_TIMES;

  /**
   * puk验证剩余次数
   */
  private _pukRemainTimes: number = DEFAULT_PUK_REMAIN_TIMES;

  /**
   * 是否为ESIM卡（一种内置SIM卡，无法卸载）
   */
  private _isEsim: boolean = false;

  /**
   * Sim卡名称索引（1/2/N）
   */
  private _labelIndex: number = 0;

  /**
   * 能否跳过验证（当存在一张卡已验证时，另一张卡状态为可跳过）
   */
  private _isCanSkipVerify: boolean = false;

  /**
   * 是否已跳过验证
   */
  private _hasSkipVerify: boolean = false;

  constructor(slotId: number) {
    this._slotId = slotId;
  }

  public get slotId(): number {
    return this._slotId;
  }

  public get simState(): sim.SimState {
    return this._simState;
  }

  protected set simState(simState: sim.SimState) {
    this._simState = simState;
    if (!this.isPresent) {
      // SIM不在位时，属性恢复
      this._lockType = LockType.UNLOCK;
      this._pinRemainTimes = DEFAULT_PIN_REMAIN_TIMES;
      this._pukRemainTimes = DEFAULT_PUK_REMAIN_TIMES;
      this._isEsim = false;
      this._isCanSkipVerify = false;
      this._hasSkipVerify = false;
      this._labelIndex = 0;
    }
  }

  public get lockType(): LockType {
    return this._lockType;
  }

  protected set lockType(lockType: LockType) {
    this._lockType = lockType;
  }

  public get isEsim(): boolean {
    return this._isEsim;
  }

  protected set isEsim(isEsim: boolean) {
    this._isEsim = isEsim;
  }

  public get labelIndex(): number {
    return this._labelIndex;
  }

  protected set labelIndex(labelIndex: number) {
    this._labelIndex = labelIndex;
  }

  public get pinRemainTimes(): number {
    return this._pinRemainTimes;
  }

  protected set pinRemainTimes(pinRemainTimes: number) {
    this._pinRemainTimes = pinRemainTimes;
  }

  public get pukRemainTimes(): number {
    return this._pukRemainTimes;
  }

  protected set pukRemainTimes(pukRemainTimes: number) {
    this._pukRemainTimes = pukRemainTimes;
  }

  /**
   * 能否跳过验证
   *
   * @returns true能/false否
   */
  public get isCanSkipVerify(): boolean {
    log.showInfo(`soltId ${this._slotId}, isEsim: ${this._isEsim}, pukRemainTimes: ${this._pukRemainTimes}`);
    return (this.isEsim && this._pukRemainTimes <= 0) || this._isCanSkipVerify;
  }

  protected set isCanSkipVerify(isCanSkipVerify: boolean) {
    this._isCanSkipVerify = isCanSkipVerify;
  }

  public get hasSkipVerify(): boolean {
    return this._hasSkipVerify;
  }

  protected set hasSkipVerify(hasSkipVerify: boolean) {
    this._hasSkipVerify = hasSkipVerify;
  }

  /**
   * [派生属性]SIM卡是否在位
   */
  public get isPresent(): boolean {
    return this._simState !== sim.SimState.SIM_STATE_UNKNOWN && this._simState !== sim.SimState.SIM_STATE_NOT_PRESENT;
  }

  /**
   * [派生属性]判断是否锁定
   *
   * @returns 是否锁定
   */
  public get isLocked(): boolean {
    return this.isPresent && this._lockType !== LockType.UNLOCK;
  }
}

/**
 * 内部Sim卡信息，支持修改数据
 */
export class InnerSimCard extends SimCard {
  /**
   * SIM卡定时器id
   */
  private _timerId: number = 0;

  /**
   * SIM卡插拔变更
   */
  private _postionChange: boolean = false;

  public get simState(): sim.SimState {
    return super.simState;
  }

  public set simState(simState: sim.SimState) {
    super.simState = simState;
  }

  public get lockType(): LockType {
    return super.lockType;
  }

  public set lockType(lockType: LockType) {
    super.lockType = lockType;
  }

  public get isEsim(): boolean {
    return super.isEsim;
  }

  public set isEsim(isEsim: boolean) {
    super.isEsim = isEsim;
  }

  public get labelIndex(): number {
    return super.labelIndex;
  }

  public set labelIndex(labelIndex: number) {
    super.labelIndex = labelIndex;
  }

  public get pinRemainTimes(): number {
    return super.pinRemainTimes;
  }

  public set pinRemainTimes(pinRemainTimes: number) {
    super.pinRemainTimes = pinRemainTimes;
  }

  public get pukRemainTimes(): number {
    return super.pukRemainTimes;
  }

  public set pukRemainTimes(pukRemainTimes: number) {
    super.pukRemainTimes = pukRemainTimes;
  }

  public set isCanSkipVerify(isCanSkipVerify: boolean) {
    super.isCanSkipVerify = isCanSkipVerify;
  }

  public get hasSkipVerify(): boolean {
    return super.hasSkipVerify;
  }

  public set hasSkipVerify(hasSkipVerify: boolean) {
    super.hasSkipVerify = hasSkipVerify;
  }

  public get timerId(): number {
    return this._timerId;
  }

  public set timerId(id: number) {
    this._timerId = id;
  }

  public get isPositionChange(): boolean {
    return this._postionChange;
  }

  public set isPositionChange(isChange: boolean) {
    this._postionChange = isChange;
  }
}

/**
 * 锁定SIM卡数据
 */
export class SimCardData {
  protected readonly _simCards: Array<SimCard>;

  constructor(simCards: Array<SimCard>) {
    this._simCards = simCards;
  }

  public simCards(): Array<SimCard> {
    return this._simCards;
  }

  public get count(): number {
    return this._simCards.length;
  }

  /**
   * 是否存在需要验证的SIM卡
   *
   * @returns 是否
   */
  public get hasVerifySimCard(): boolean {
    return this._simCards.filter(simCard => simCard.isLocked && !simCard.hasSkipVerify).length > 0;
  }
}

/**
 * SIM卡状态变更通知
 */
export interface SimCardStateChangeListener extends ObserverAble {
  /**
   * Sim卡变更通知（插卡，拔卡）
   *
   * @param simCardData sim卡数据
   * @param isAddCard 插卡还是拔卡
   */
  onSimCardCountChange?: (simCardData: SimCardData, isAddCard: boolean) => void;

  /**
   * SIM卡状态变更通知（解锁、锁定类型、可尝试解锁次数变更）
   *
   * @param slotId slotID
   * @param simCard SIM卡信息
   */
  onSimCardStateChange?: (slotId: number, simCard: SimCard) => void;

  /**
   * SIM卡自动校验失败，进入锁屏态
   *
   * @param slotId slotId
   */
  onSimCardAutoVerifyFail?: (slotId: number) => void;

  /**
   * SIM卡锁定状态变化回调
   *
   * @param isSimLocked Sim卡是否锁定
   */
  onSimCardLockChanged?: (isSimLocked: boolean) => void;
}

/**
 * Sim卡状态管理器
 */
export class SimCardStateManager extends AbstractObserverManager<SimCardStateChangeListener> {
  private static sInstance: SimCardStateManager;

  public static getInstance(): SimCardStateManager {
    if (SimCardStateManager.sInstance == null) {
      SimCardStateManager.sInstance = new SimCardStateManager();
      log.showInfo('create SimCardStateManager instance');
    }
    return SimCardStateManager.sInstance;
  }

  private readonly _simCards: InnerSimCard[] = [];
  private readonly _registeredSimCardCallback: Callback<observer.SimStateData>[] = [];
  private readonly _registeredIccChangeCallback = (): void => this.handleIccChange();
  private _lockedQueue: CapsuleQueue<number> = new CapsuleQueue();
  private _isSimLocked: boolean = false;
  private _pinVerifyEvent = async (data: SimPinVerifyEvent): Promise<void> => {
    let isVerifySuccess: boolean | undefined = data?.parameters?.result;
    let num: number = data?.parameters?.slotId ?? 0;
    if (num < 0 || num >= this._simCards.length) {
      log.showError(`SimPinVerifyEvent slot id ${num} is invalid`);
      return;
    }
    log.showInfo(`sim card auto verified, slotId: ${num}, result: ${isVerifySuccess}`);
    let simCard: InnerSimCard = this._simCards[num];
    if (!isVerifySuccess) {
      // 记住Pin码自动校验不成功，需要拉起Pin码验证界面
      await this.syncSimCardLockInfo(simCard);
      this.updateQueue(num, simCard.lockType, false);
      this.broadcastDataChange(callback => callback?.onSimCardAutoVerifyFail?.(simCard.slotId));
    }
  };

  private constructor() {
    super();
  }

  /**
   * 生成SIM卡数据
   *
   * @returns SIM卡数据
   */
  public get simCardData(): SimCardData {
    let simCards: SimCard[] = [];
    let hasUnlocked: boolean = this._simCards.some(simCard => simCard.isPresent && !simCard.isLocked);
    this._simCards.forEach(simCard => {
      if (simCard.isPresent) {
        simCard.isCanSkipVerify = hasUnlocked;
        simCards.push(simCard);
      }
    });
    return new SimCardData(simCards);
  }

  public getLockQueue(): CapsuleQueue<number> {
    return this._lockedQueue;
  }

  protected isSupport(): boolean {
    return SimCardUtils.isSimCardSupport();
  }

  protected doInit(): void {
    log.showInfo('doInit');
    this.initSimCards();
    SimCardUtils.registerIccChangeListener(this._registeredIccChangeCallback);
    EvtBus.on(SimPinVerifyEvent, this._pinVerifyEvent);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    this._registeredSimCardCallback.forEach(callback => SimCardUtils.unRegisterSimStateChangeListener(callback));
    this._registeredSimCardCallback.length = 0;
    SimCardUtils.unRegisterIccChangeListener(this._registeredIccChangeCallback);
    EvtBus.off(SimPinVerifyEvent, this._pinVerifyEvent);
  }

  private handleIccChange(): void {
    SimCardUtils.getActiveSimAccountInfoList((err, data: Array<sim.IccAccountInfo>) => {
      if (err) {
        log.showError(`getActiveSimAccountInfoList error. code ${err.code}`);
        return;
      }

      log.showInfo(`getActiveSimAccountInfoList success, total count=${data?.length}`);
      for (let simIccInfo of data) {
        log.showInfo(`sim slotId: ${simIccInfo.slotIndex}, isEsim: ${simIccInfo.isEsim}`);
        let simCard: InnerSimCard = this._simCards[simIccInfo.slotIndex];
        if (simCard) {
          simCard.isEsim = simIccInfo.isEsim;
          simCard.labelIndex = getSimLabelSync(simCard.slotId).index;
        }
      }
    });
  }

  private async initSimCards(): Promise<void> {
    log.showInfo('initSimCards');
    let maxCount: number = SimCardUtils.getMaxSimCount();
    for (let slotId = 0; slotId < maxCount; slotId++) {
      let simCard: InnerSimCard = new InnerSimCard(slotId);
      this._simCards.push(simCard);
      await this.updateSimCardState(simCard, await SimCardUtils.getSimState(slotId), true);
      this.registerSimStateChangeListener(slotId);
    }
  }

  private registerSimStateChangeListener(slotId: number): void {
    let callback: Callback<observer.SimStateData> = (data: observer.SimStateData) => {
      log.showInfo(`on simStateChange solt ${slotId}, state: ${data?.state}`);
      let innerSimCard: InnerSimCard = this._simCards[slotId];
      if (innerSimCard && data) {
        this.updateSimCardState(innerSimCard, data.state, true);
      }
    };

    if (SimCardUtils.registerSimStateChangeListener(slotId, callback)) {
      log.showInfo(`registerSimStateChangeListener for slotId ${slotId} success.`);
      this._registeredSimCardCallback.push(callback);
    }
  }

  private async updateSimCardState(simCard: InnerSimCard, simState: sim.SimState, isNotify: boolean): Promise<void> {
    // 分布式通信导致的虚拟卡状态变化，不更新SIM卡状态
    if (sSettingsUtil.getValue(SettingsKeyConstants.DISTRIBUTED_MODEM_STATE, '') === '1_sink') {
      log.showInfo(`distributed virtrual simCard change, do not updateSimCardState`);
      return;
    }
    if (simCard.timerId !== 0) {
      clearTimeout(simCard.timerId);
      simCard.timerId = 0;
    }

    if (simState === sim.SimState.SIM_STATE_UNKNOWN) {
      log.showWarn(`slot ${simCard.slotId} encounter unknown state, ignore.`);
      return;
    }

    log.showInfo(`slot ${simCard.slotId} update simState ${simState}.`);
    let lastIsPresent: boolean = simCard.isPresent;
    simCard.simState = simState;
    let newIsPresent: boolean = simCard.isPresent;
    if (newIsPresent !== lastIsPresent) {
      simCard.isPositionChange = true;
    }

    let isPinSavingEnabled: boolean = await this.isCurPinSavingSupported(simCard.slotId);
    if (newIsPresent) {
      log.showInfo(`slot ${simCard.slotId} begin sync info.`);
      this.syncSimAccountInfo(simCard);
      await this.syncSimCardLockInfo(simCard);
      this.updateQueue(simCard.slotId, simCard.lockType, isPinSavingEnabled);
    } else {
      this._simCards.forEach((simCard) => {
        this.updateQueue(simCard.slotId, simCard.lockType, isPinSavingEnabled);
        simCard.hasSkipVerify = false;
      });
    }

    if (!isNotify) {
      return;
    }
    this.sendBroadCast(simCard, isPinSavingEnabled, isPinSavingEnabled ? 0 : BROADCAST_DELAY_MILLIS);
  }

  private sendBroadCast(simCard: InnerSimCard, isPinSavingEnabled: boolean, delay: number): void {
    simCard.timerId = setTimeout(() => {
      simCard.timerId = 0;
      if (simCard.isPositionChange) {
        simCard.isPositionChange = false;
        let simCardData = this.simCardData;
        log.showInfo(`slot ${simCard.slotId} onSimCardCountChange. ${JSON.stringify(simCardData)}`);
        this.broadcastDataChange(callback => callback?.onSimCardCountChange?.(simCardData, simCard.isPresent));
      } else {
        log.showInfo(`slot ${simCard.slotId} onSimCardStateChange. ${JSON.stringify(simCard)}`);
        this.broadcastDataChange(callback => callback?.onSimCardStateChange?.(simCard.slotId, simCard));
      }
    }, delay);
  }

  private syncSimAccountInfo(simCard: InnerSimCard): void {
    // 更新数据
    SimCardUtils.getSimAccountInfo(simCard.slotId, (err, data) => {
      if (err) {
        log.showError(`getSimAccountInfo slot ${simCard.slotId} error. code ${err.code}`);
        return;
      }
      if (!data) {
        log.showError(`getSimAccountInfo slot ${simCard.slotId} encounter invalid data.`);
        return;
      }
      simCard.isEsim = data.isEsim;
      simCard.labelIndex = getSimLabelSync(simCard.slotId).index;
    });
  }

  private async syncSimCardLockInfo(simCard: InnerSimCard): Promise<void> {
    if (simCard.simState !== sim.SimState.SIM_STATE_LOCKED) {
      log.showInfo(`slotId ${simCard.slotId} is unlocked.`);
      simCard.lockType = LockType.UNLOCK;
      return;
    }
    let simLockType: sim.LockType = await SimCardUtils.getSimLockType(simCard.slotId);
    log.showInfo(`sim lock type: ${simLockType}.`);
    simCard.pinRemainTimes = this.getRemainTimes(simCard.slotId, LockType.PIN_LOCK, simLockType);
    simCard.pukRemainTimes = this.getRemainTimes(simCard.slotId, LockType.PUK_LOCK, simLockType);
    if (simCard.pinRemainTimes <= 0 || simCard.pukRemainTimes <= 0) {
      simCard.lockType = LockType.PUK_LOCK;
    } else {
      simCard.lockType = LockType.PIN_LOCK;
    }
  }

  private getRemainTimes(slotId: number, lockType: LockType, simLockType: sim.LockType): number {
    const simSlotId: number = slotId + 1;
    const propKey: string = `ril.gsm.slot${simSlotId}.num.${lockType}${simLockType}`;
    const defaultVal: string = LockType.PIN_LOCK === lockType ? '3' : '10';

    const availableStr: string = SystemParamUtils.getSystemParam(propKey, defaultVal);
    log.showInfo(`soltId=${slotId},propKey=${propKey},available=${availableStr}`);
    return Number.parseInt(availableStr);
  }

  private updateQueue(slotId: number, lockType: LockType, isPinSaved: boolean): void {
    log.showInfo(`updateQueue slotId: ${slotId}, lockType: ${lockType}, isPinSaved: ${isPinSaved}`);
    if ((lockType === LockType.PIN_LOCK && !isPinSaved) || lockType === LockType.PUK_LOCK) {
      if (!this._lockedQueue.hasItem(slotId)) {
        log.showInfo('updateQueue add queue');
        this._lockedQueue.enqueue(slotId);
      }
    } else {
      if (this._lockedQueue.hasItem(slotId)) {
        log.showInfo('updateQueue remove queue');
        this._lockedQueue.remove(slotId);
      }
    }
    this.onLockedQueueChanged();
  }

  private onLockedQueueChanged(): void {
    let isSimLocked = this.isSimLocked();
    if (this._isSimLocked !== isSimLocked) {
      this._isSimLocked = isSimLocked;
      this.broadcastDataChange(callback => callback?.onSimCardLockChanged?.(isSimLocked));
    }
  }

  private async isCurPinSavingSupported(slotId: number): Promise<boolean> {
    let isCurrentPinSavingEnabled: boolean = false;
    if (SimCardUtils.getPinSavingSupported()) {
      isCurrentPinSavingEnabled = await SimCardUtils.isPinSavingEnabled(slotId);
    }
    return isCurrentPinSavingEnabled;
  }

  public isPukLocked(): boolean {
    return this._lockedQueue.length() > 0 &&
      this._simCards[(this._lockedQueue.getFirst() ?? 0) as number].lockType === LockType.PUK_LOCK;
  }

  public isCurrentEsim(): boolean {
    return this._lockedQueue.length() > 0 &&
      this._simCards[(this._lockedQueue.getFirst() ?? 0) as number].isEsim;
  }

  public isPinLocked(): boolean {
    return this._lockedQueue.length() > 0 &&
      this._simCards[(this._lockedQueue.getFirst() ?? 0) as number].lockType === LockType.PIN_LOCK;
  }

  public isSimLocked(): boolean {
    return this._lockedQueue.length() > 0 &&
      !this._simCards[(this._lockedQueue.getFirst() ?? 0) as number].isCanSkipVerify;
  }

  public isNeedAddToQueue(slotId: number): boolean {
    if (this._simCards[slotId].hasSkipVerify) {
      log.showInfo(`slot ${slotId} has cancel auth by customer, no need add to locked queue`);
      return false;
    }

    if (this._lockedQueue.length() === 0) {
      return true;
    }

    if (this._lockedQueue.hasItem(slotId)) {
      log.showInfo(`slot ${slotId} has added to locked queue`);
      return false;
    }
    return true;
  }

  public getActiveSimNumber(): number {
    let count: number = 0;
    this._simCards.forEach((simCard) => {
      if (simCard.simState !== sim.SimState.SIM_STATE_UNKNOWN &&
        simCard.simState !== sim.SimState.SIM_STATE_NOT_PRESENT) {
        count++;
      }
    });
    return count;
  }

  public setSkipAuth(isSkip: boolean): void {
    if (this._lockedQueue.length() !== 0) {
      this._simCards[(this._lockedQueue.getFirst() ?? 0) as number].hasSkipVerify = isSkip;
    }
  }

  public getCurSimCard(): SimCard | undefined {
    if (this._lockedQueue.length() > 0) {
      return this._simCards[(this._lockedQueue.getFirst() ?? 0) as number];
    }
    return undefined;
  }

  /**
   * 判断是否跳过了至少一张卡
   *
   * @returns true: 已经跳过了至少一张卡
   */
  public isAlreadySkipAuth(): boolean {
    for (let i = 0; i < this._simCards.length; i++) {
      if (this._simCards[i].hasSkipVerify) {
        return true;
      }
    }
    return false;
  }

  public async updateCardState(slotId: number, simState: sim.SimState): Promise<void> {
    if (slotId < 0 || slotId >= this._simCards.length) {
      log.showWarn(`updateCardState error, slotid ${slotId} invalid`);
      return;
    }
    await this.updateSimCardState(this._simCards[slotId], simState, false);
  }

  public getAvailableTimes(): string {
    if (this.isSimLocked()) {
      let simCard: SimCard | undefined = this.getCurSimCard();
      if (simCard?.lockType === LockType.PIN_LOCK) {
        return simCard?.pinRemainTimes + '';
      } else {
        return simCard?.pukRemainTimes + '';
      }
    }
    return '';
  }
}