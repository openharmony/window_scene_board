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
import { promptAction } from '@kit.ArkUI';
import { commonEventManager, emitter, systemDateTime, systemParameterEnhance } from '@kit.BasicServicesKit';
import osAccount from '@ohos.account.osAccount';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import image from '@ohos.multimedia.image';
import { ActionType, FourFingersSwipe } from '@ohos.multimodalInput.gestureEvent';
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import rpc from '@ohos.rpc';
import settings from '@ohos.settings';
import fs from '@ohos.file.fs';
import spaceAbility from '@ohos.space_ability_napi';
import { ArrayUtils, CommonUtils, FileUtils, LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { PowerStatus } from '@ohos/commonconstants';
import { EventManager, EvtBus, GlobalContext, HiSysEventUtil, OobeActivatedEvent } from '@ohos/frameworkwrapper';
import { IUserData } from '@ohos/screenlockcommon';
import ScreenLockService from '../SceneBoard/screenlock/refactor/ScreenLockService';
import accountModel from '../SceneBoard/screenlock/refactor/AccountsModel';
import { SCBSceneSessionManager, sSampleManager, sSCBOobeManager } from '@ohos/windowscene';
import Constants from '../SceneBoard/screenlock/common/Constants';
import {
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import {
  SwipeGestureDirection
} from '@ohos/pcmode';
import { DesktopSwitchController } from '../SceneBoard/virtualmachine/DesktopSwitchController';
import { FourFingerSwipeEvent } from '../SceneBoard/virtualmachine/FourFingerSwipeEvent';

const TAG: string = 'MultiSpaceSwitchController';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const SWITCH_ACCOUNT_SUCCESS: number = 0;
const SWITCH_ACCOUNT_FAILED: number = 1;
const UNABLE_SWITCH_TOAST_TIME: number = 3500;
const INVALID_LOADING_PERSIST_TIME = 10_000;
const WAIT_PRIVACY_PAGE_HIDDEN: number = 300;
const MEM_INFO_FILE_PATH = '/proc/meminfo';
const UNIT_BYTE = 'B';
const UNIT_KB = 'kB';
const UNIT_KB_UPPER = 'KB';
const UNIT_MB = 'MB';
const UNIT_GB = 'GB';
const KILO_BYTES = 1024;
const MEGA_BYTES = 1024 * KILO_BYTES;
const GIGA_BYTES = 1024 * MEGA_BYTES;
const PAIR_ARRAY_LENGTH: number = 2;
const LOW_MEMORY_RANGE: number = 600 * MEGA_BYTES;

export interface MultiSpaceSwitchAnimationCtrlInf {
  startWithScreenshot(): Promise<image.PixelMap | undefined>;

  move(percent: number): boolean;

  restore(): Promise<void>;

  toSwitch(): Promise<void>;

  doneInOneGo(img: image.PixelMap, direction: Direction, spaceType?: SpaceTypeKey): Promise<boolean>;

  toFinish(): void;
}

export interface ISpaceUnlockParamValue {
  id: number;
  validUptime: number;
}

/**
 * 水平滑动方向
 */
export enum Direction {
  ToLeft = -1,
  ToRight = 1,
  UpDown = 0,
}

export enum SwitchEnterpriseMultiSpaceType {
  SHORTCUT_KEY = 'ShortcutKey',
  LOGO_LSHIFT_E = 'LOGO_LSHIFT_E',
  FOUR_FINGER = 'FourFinger',
  STATUS_BAR = 'StatusBar',
  HOVER_SCREEN_LOCK = 'HoverScreenLock',
  HOS_KEY = 'HosKey',
  RECENT_PANEL = 'RECENT_PANEL'
}

/**
 * 双空间初始化状态参数
 */
export enum SpaceInitializeParamEnum {
  E_SPACE_NOT_INITIALIZED = '0',
  P_SPACE_NOT_INITIALIZED = '1',
  SPACE_INITIALIZED = '2',
}

class SpaceSwitchCoolDown {
  private readonly COOL_DOWN_TOAST_DURATION: number = 2_000;
  private readonly COOL_DOWN_TIME: number = 5_000;
  private readonly COOL_DOWN_TIME_DISPLAY_RATIO: number = this.COOL_DOWN_TIME / 3_000;
  private coolDownTime: number = 0;
  private readonly BOOT_TIME: number = 3_000;
  private curSpaceBootTime: number = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, false);

  constructor() {
    this.markEnterDone();
  }

  bootDone(): boolean {
    const bootDone = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE) > this.curSpaceBootTime + this.BOOT_TIME;
    log.showInfo(`current space bootdone? ${bootDone}`);
    return bootDone;
  }

  markEnterDone(): void {
    const curTime = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, false);
    log.showInfo(`markEnterDone, curTime: ${curTime}`);
    AppStorage.setOrCreate('switchAccountState', curTime);
  }

  isDone(): boolean {
    const switchDoneTime = AppStorage.get('switchAccountState') as number;
    const curTime = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, false)
    log.showWarn(`switchDoneTime: ${switchDoneTime}, curTime:${curTime}`);
    this.coolDownTime = this.COOL_DOWN_TIME - (curTime - switchDoneTime);
    const coolDown = this.coolDownTime <= 0;

    log.showInfo(`isSpaceSwitchCoolDown: ${coolDown}`);
    return coolDown;
  }

  getCoolDownTimeMs(): number {
    log.showInfo(`getCoolDownTimeMs: ${this.coolDownTime}`);
    return Math.ceil(this.coolDownTime);
  }

  toast(waitTimeInMS: number): void {
    const waitTimeSec = waitTimeInMS / 1_000 / this.COOL_DOWN_TIME_DISPLAY_RATIO;
    promptAction.showToast({
      message: $r('app.string.multispace_too_often_switch', Math.ceil(waitTimeSec)),
      duration: Math.min(waitTimeInMS, this.COOL_DOWN_TOAST_DURATION),
      showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST
    });
  }
}

export const switchCoolDown = new SpaceSwitchCoolDown();

class DevelopModeLimit {
  private inDevelopMode: boolean = false;
  private allowLogInNewOne: boolean = true;

  constructor(unlock: boolean = false) {
    this.update()
  }

  disallow(): boolean {
    log.showInfo(`developmode check: inDevelopMode: ${this.inDevelopMode}, allowLogNewOne: ${this.allowLogInNewOne}`);
    return this.inDevelopMode && !this.allowLogInNewOne;
  }

  update(unlock: boolean = false): void {
    try {
      const developerMode: string = systemParameterEnhance.getSync('const.security.developermode.state', '0');
      log.showInfo(`developerMode: ${developerMode}, unlock: ${unlock}`);
      if (developerMode !== 'true') {
        this.inDevelopMode = false;
        this.allowLogInNewOne = true;
        log.showInfo('not in developer mode');
        return;
      }
      this.inDevelopMode = true;
      const am = osAccount.getAccountManager();
      const maxAllowed = am?.queryMaxLoggedInOsAccountNumber();
      am?.queryAllCreatedOsAccounts().then(async accountInfos => {
        const maxAllowedCount = await maxAllowed;
        const alreadyLoggedIn = accountInfos?.filter(item => {
          // 账号登录信息需要落盘后再读取，登录状态查询存在延迟。
          // 当前用户解锁登录事件回调中，当前用户解锁事件，也可作为已登录状态
          const isCurUser = item.localId === accountModel.getCurrentUserId();
          return isCurUser ? (item.isLoggedIn || unlock) : item.isLoggedIn;
        }).length;
        this.allowLogInNewOne = alreadyLoggedIn < maxAllowedCount;
        log.showInfo(`maxAllowedCount: ${maxAllowedCount}, alreadyLoggedIn: ${alreadyLoggedIn}`);
        log.showInfo(`in developMode, allowLogInNewOne: ${this.allowLogInNewOne}`);
      });
    } catch (err) {
      log.showWarn(`updateLoginUserExceedLimitInDeveloperMode failed. err.code: ${err?.code}, set to default exceed`);
      this.allowLogInNewOne = false;
    }
  }

  toast(): void {
    promptAction.showToast({
      message: $r('app.string.multispace_indevelopermode_cannot_switch'),
      duration: UNABLE_SWITCH_TOAST_TIME,
      showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
    });
  }
}

const developMode: DevelopModeLimit = new DevelopModeLimit();

class FoldStateLimit {
  disallow(): boolean {
    return false;
  }

  toast(): void {
    promptAction.showToast({
      message: $r('app.string.multispace_unable_switch_when_fold'),
      duration: UNABLE_SWITCH_TOAST_TIME,
      showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
    });
  }
}

const foldMode: FoldStateLimit = new FoldStateLimit();

class MemoryLimit {

  disallow(): boolean {
    return this.isLowMemory();
  }

  toast(): void {
    promptAction.showToast({
      message: $r('app.string.multispace_in_low_memory'),
      duration: UNABLE_SWITCH_TOAST_TIME,
      showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
    });
  }

  isLowMemory(): boolean {
    try {
      let content = FileUtils.readStringFromFile(MEM_INFO_FILE_PATH);
      let configs: string[] = content.split('\n');
      for (let i = 0; i < configs.length; i++) {
        let item: string = configs[i];
        if (CommonUtils.isEmpty(item)) {
          continue;
        }
        let pair = item.split(':');
        if (ArrayUtils.isEmpty(pair) || pair.length < PAIR_ARRAY_LENGTH) {
          continue;
        }
        let name = pair[0].trim();
        let value = pair[1].trim();
        if (name === 'MemAvailable') {
          let totalMem = value;
          let arr = totalMem.split(' ');
          // 检查数组长度是否至少为2
          if (arr.length < 2) {
            log.error('Invalid MemAvailable line format: ' + value);
            return false;
          }
          return this.getBytes(parseInt(arr[0]), arr[1]) < LOW_MEMORY_RANGE;
        }
      }
    } catch (error) {
      log.error('readConfigFile error:', error);
      return false;
    }
    return false;
  }

  /**
   * 获取字节数
   *
   * @param size 数值
   * @param unit 单位
   * @return 字节数
   */
  private getBytes(size: number, unit: string): number {
    log.showInfo(`getBytes size:${size}, unit:${unit}`);
    let multiple: number = 1;
    if (unit === UNIT_BYTE) {
      multiple = 1;
    } else if (unit === UNIT_KB || unit === UNIT_KB_UPPER) {
      multiple = KILO_BYTES;
    } else if (unit === UNIT_MB) {
      multiple = MEGA_BYTES;
    } else if (unit === UNIT_GB) {
      multiple = GIGA_BYTES;
    }
    return size * multiple;
  }
}

const memoryLimit: MemoryLimit = new MemoryLimit();

interface SwitchCondition {
  allowStart: boolean;
  allowSwitch?: boolean;
  toast?: () => void;
}

class SpaceSwitchCondition {
  check(switchType: SwitchEnterpriseMultiSpaceType, direction: Direction,
    targetId: number | undefined): SwitchCondition {
    log.showInfo(`check, switchType:${switchType}, direction:${direction}, targetId:${targetId}`);
    const cond = this.checkAllowStart(switchType, direction, targetId);
    cond.allowSwitch = false;
    if (switchType === SwitchEnterpriseMultiSpaceType.FOUR_FINGER && cond.toast) {
      cond.allowStart = true;
      return cond;
    }
    if (cond.allowStart && foldMode.disallow()) {
      return { allowStart: false, allowSwitch: false, toast: foldMode.toast };
    }
    if (!cond.allowStart) {
      return cond;
    }
    if (!this.ignoreDirectionId(switchType) && !this.checkDirectionAndTargetId(direction, targetId!)) {
      return cond;
    }
    if (!switchCoolDown.isDone()) {
      const remainTime = switchCoolDown.getCoolDownTimeMs();
      cond.toast = () => {
        log.showWarn(`cool down time remain: ${remainTime}`);
        switchCoolDown.toast(remainTime);
      }
      return cond;
    }
    cond.allowSwitch = true;
    return cond;
  }

  private ignoreDirectionId(switchType: SwitchEnterpriseMultiSpaceType): boolean {
    return switchType === SwitchEnterpriseMultiSpaceType.LOGO_LSHIFT_E;
  }

  checkDirectionAndTargetId(direction: Direction, targetId: number): boolean {
    const toRightLoadLeftSmaller = direction === Direction.ToRight && targetId <= accountModel.getCurrentUserId();
    const toLeftLoadRightBigger = direction === Direction.ToLeft && targetId >= accountModel.getCurrentUserId();
    log.showInfo(`toRightLoadLeftSmaller:${toRightLoadLeftSmaller}, toLeftLoadRightBigger:${toLeftLoadRightBigger}`);
    return toRightLoadLeftSmaller || toLeftLoadRightBigger;
  }

  private checkAllowStart(switchType: SwitchEnterpriseMultiSpaceType, direction: Direction,
    targetId: number | undefined): SwitchCondition {
    const disallowStart: SwitchCondition = { allowStart: false };
    if (accountModel.getCurrentUserId() !== accountModel.getForegroundUserId()) {
      log.showInfo(`current space is background, id:${accountModel.getCurrentUserId()}`);
      return disallowStart;
    }
    if (!MultiSpace.get().checkSpaceEnable()) {
      log.showInfo(`current space not enable`);
      return disallowStart;
    }
    if (direction === Direction.UpDown) {
      return disallowStart;
    }
    if (!targetId) {
      log.showInfo('target space is not exist');
      return disallowStart;
    }
    if (memoryLimit.disallow()) {
      disallowStart.toast = memoryLimit.toast;
      log.showInfo('low memory');
      return disallowStart;
    }
    if (!this.checkSysStatus()) {
      return disallowStart;
    }
    if (!switchCoolDown.bootDone()) {
      log.showInfo(`current space boot not done, id:${accountModel.getCurrentUserId()}`);
      return disallowStart;
    }
    if (!this.ignoreVm(switchType) && this.isVmSwitch(direction)) {
      return disallowStart;
    }
    if (developMode.disallow()) {
      disallowStart.toast = developMode.toast;
      log.showInfo('in develop mode, not allow switch');
      return disallowStart;
    }
    return { allowStart: true };
  }

  private isVmSwitch(direction: Direction): boolean {
    const hasVm = DesktopSwitchController.getInstance().hasVmAbility();
    if (!hasVm) {
      log.showInfo(`no vm`);
      return false;
    }
    if (viewMgrPolicy.isViewShowing(ViewType.DESKTOP_SWITCHER)) {
      log.showInfo('isVm switching');
      return true;
    }
    const isVm = DesktopSwitchController.getInstance().isVmDesktop();
    const isHmToVm = !isVm && (direction === Direction.ToLeft);
    const isVmToHm = isVm && (direction === Direction.ToRight);
    log.showInfo(`isVm:${isVm}, direction:${direction}, isHmToVm:${isHmToVm}, isVmToHm:${isVmToHm}`);
    return isHmToVm || isVmToHm;
  }

  private ignoreVm(switchType: SwitchEnterpriseMultiSpaceType): boolean {
    if (ScreenLockService.getLock()) {
      return true;
    }
    return switchType !== SwitchEnterpriseMultiSpaceType.FOUR_FINGER &&
      switchType !== SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY;
  }

  private checkSysStatus(): boolean {
    if (AppStorage.get('powerStatus') !== PowerStatus.RUNNING) {
      log.info('abnormal power status');
      return false;
    }
    if (sSampleManager.isSampleManagerChecked()) {
      log.info('current isSampleManagerChecked');
      return false;
    }
    return true;
  }
}

const spaceSwitchCheck = new SpaceSwitchCondition();

class SwipeMoveState {
  private readonly FOUR_FINGERS_MOVE_RANGE: number = 1500;
  private readonly FOUR_FINGERS_MOVE_THRESHOLD: number = 300;
  private readonly ONE_GO_SWITCH_THRESHOLD: number = 300;
  private readonly SWIPE_STEADY_MOVE_PX: number = 5;
  private startEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private preEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private curEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private curDirection = SwipeGestureDirection.NONE;
  private initDirection = SwipeGestureDirection.NONE;

  public updateMoveState(gesture: FourFingersSwipe, isLimit?: boolean): void {
    const curX = gesture.x;
    const curY = gesture.y;
    if (this.startEvent.x === -1) {
      this.startEvent.set(curX, curY, Date.now());
      this.preEvent.set(curX, curY, Date.now());
      this.curEvent.set(curX, curY, Date.now());
      return;
    }

    if (Math.abs(curY - this.preEvent.y) >= Math.abs(curX - this.preEvent.x)) {
      this.curDirection = curY < this.preEvent.y ? SwipeGestureDirection.UP : SwipeGestureDirection.DOWN;
    } else {
      this.curDirection = curX < this.preEvent.x ? SwipeGestureDirection.LEFT : SwipeGestureDirection.RIGHT;
    }
    if (this.initDirection === SwipeGestureDirection.NONE) {
      this.initDirection = this.curDirection;
    }

    if (Math.abs(this.curEvent.x - curX) < this.SWIPE_STEADY_MOVE_PX) {
      return;
    }

    this.preEvent.clone(this.curEvent);
    this.curEvent.set(curX, curY, Date.now());
    if (isLimit) {
      if (this.startEvent.x < (this.curEvent.x - this.ONE_GO_SWITCH_THRESHOLD)) {
        this.startEvent.x = this.curEvent.x - this.ONE_GO_SWITCH_THRESHOLD - 1;
        return;
      }

      if (this.startEvent.x > (this.curEvent.x + this.ONE_GO_SWITCH_THRESHOLD)) {
        this.startEvent.x = this.curEvent.x + this.ONE_GO_SWITCH_THRESHOLD + 1;
        return;
      }
    }
  }

  public getDirection(): SwipeGestureDirection {
    return this.curDirection;
  }

  public getFinalDirection(): SwipeGestureDirection {
    log.showWarn(`getFinalDirection curX=${this.curEvent.x}, startX=${this.startEvent.x}`);
    return this.curEvent.x < this.startEvent.x ? SwipeGestureDirection.LEFT : SwipeGestureDirection.RIGHT;
  }

  public isOneGoSwitch(): boolean {
    return Math.abs(this.curEvent.x - this.startEvent.x) > this.ONE_GO_SWITCH_THRESHOLD;
  }

  public getInitDirection(): SwipeGestureDirection {
    return this.initDirection;
  }

  /**
   * 水平方向，移动的长度
   *
   * @returns 正数代表与目标方向相同，负数代表与目标方向相反
   */
  public exceedSwipeMoveThreshold(): boolean {
    return Math.abs(this.curEvent.x - this.startEvent.x) > this.FOUR_FINGERS_MOVE_THRESHOLD;
  }

  /**
   * 在水平方向，自然位移
   *
   * @returns 正数代表向右，负数代表向左
   */
  public getFinalHorizontalDistance(): number {
    return (this.curEvent.x - this.startEvent.x) / this.FOUR_FINGERS_MOVE_RANGE;
  }

  /**
   * 是否发生移动方向翻转
   *
   * @returns
   */
  public directionFlipped(): boolean {
    return (this.curEvent.x - this.startEvent.x) * (this.preEvent.x - this.startEvent.x) < 0;
  }

  /**
   * 在前一次移动方向上，距离起点最近的距离
   *
   * @returns
   */
  public getPreDirectionDistanceCloseToStart(): number {
    const close = (this.preEvent.x > this.startEvent.x) ? 1 : -1;
    return close / this.FOUR_FINGERS_MOVE_RANGE;
  }

  public isHorizontalMove(): boolean {
    return this.curDirection === SwipeGestureDirection.LEFT || this.curDirection === SwipeGestureDirection.RIGHT;
  }

  public reset() {
    this.startEvent.reset();
    this.preEvent.reset();
    this.curEvent.reset();
    this.curDirection = SwipeGestureDirection.NONE;
    this.initDirection = SwipeGestureDirection.NONE;
  }
}

export class MultiSpaceSwipeCtrl {
  private static instance: MultiSpaceSwipeCtrl;
  private moveState: SwipeMoveState;
  private spaceCtrl: MultiSpace;
  private animationCtrl: MultiSpaceSwitchAnimationCtrlInf | null = null;
  private isAnimating: boolean = false;
  private conditions?: SwitchCondition;

  public static get(): MultiSpaceSwipeCtrl {
    if (!MultiSpaceSwipeCtrl.instance) {
      MultiSpaceSwipeCtrl.instance = new MultiSpaceSwipeCtrl();
    }
    return MultiSpaceSwipeCtrl.instance;
  }

  private constructor() {
    log.showDebug('MultiSpaceSwipeCtrl init');
    this.spaceCtrl = MultiSpace.get();
    this.moveState = new SwipeMoveState();
    inputMonitor.on('fourFingersSwipe', (evt: FourFingersSwipe) => {
      this.onFourFingersSwipeEventInternal(evt);
    });
  }

  public setAnimationCtrl(callback: MultiSpaceSwitchAnimationCtrlInf | null): void {
    this.animationCtrl = callback;
  }

  private onFourFingersSwipeEventInternal(gesture: FourFingersSwipe): void {
    if (accountModel.getCurrentUserId() !== accountModel.getForegroundUserId()) {
      log.showInfo('fourfingers onFourFingersSwipe, current is background space, not handle any event');
      return;
    }
    log.showInfo(`fourfingers onFourFingersSwipe, gesture.type: ${gesture.type}`);

    if (gesture.type === ActionType.CANCEL || gesture.type === ActionType.END) {
      // 四指横滑是连续多个事件 begin.update...update.end事件，
      // 接收end事件进行finish，需要在各状态判断前进行，避免update过程中状态发生变化，导致无法收到end事件
      if (this.isAnimating) {
        this.finishAnimationV2();
      } else {
        this.oneGoSwitch();
      }
      return;
    }
    this.updateMoveState(gesture);
    if (!this.moveState.isHorizontalMove()) {
      return;
    }
    const targetId = MultiSpace.get().getTargetId();
    if (this.conditions?.allowStart) {
      const finalDirection =
        this.moveState.getFinalDirection() === SwipeGestureDirection.LEFT ? Direction.ToLeft : Direction.ToRight;
      const ret =
        spaceSwitchCheck.check(SwitchEnterpriseMultiSpaceType.FOUR_FINGER, finalDirection, targetId!);
      if (this.conditions) {
        this.conditions.allowSwitch = ret.allowSwitch;
      }
    } else {
      this.conditions =
        spaceSwitchCheck.check(SwitchEnterpriseMultiSpaceType.FOUR_FINGER, this.getDirection(), targetId!);
    }
    if (!this.conditions?.allowStart) {
      log.showInfo(`fourfingers onFourFingersSwipe, not allow start`);
      return;
    }
    Trace.start('SWITCHACCOUNTANIMATION_FOUR_FINGER_TRIGGER');
    if (gesture.type === ActionType.BEGIN || gesture.type === ActionType.UPDATE) {
      this.animationCtrl?.startWithScreenshot();
      this.updateAnimation();
    }
  }

  private updateMoveState(gesture: FourFingersSwipe): void {
    if (gesture.type === ActionType.BEGIN) {
      this.moveState.reset();
    }
    if (gesture.type === ActionType.UPDATE) {
      this.moveState.updateMoveState(gesture, !this.isAnimating || !this.conditions?.allowSwitch);
    }
  }

  private getDirection(): Direction {
    let dire = SwipeGestureDirection.NONE;
    if (DesktopSwitchController.getInstance().hasVmAbility()) {
      dire = this.moveState.getInitDirection();
    } else {
      dire = this.moveState.getDirection();
    }
    if (this.moveState.isHorizontalMove()) {
      return dire === SwipeGestureDirection.RIGHT ? Direction.ToRight : Direction.ToLeft;
    } else {
      return Direction.UpDown;
    }
  }

  /**
   * 更新动效效果
   */
  public updateAnimation(): void {
    if (!this.moveState.isHorizontalMove()) {
      return;
    }
    let animating: boolean | undefined = false;
    if (this.moveState.directionFlipped()) {
      log.showWarn('FourFingers swipe direction flipped');
      animating = this.animationCtrl?.move(this.moveState.getPreDirectionDistanceCloseToStart());
    }
    animating = this.animationCtrl?.move(this.moveState.getFinalHorizontalDistance());
    this.isAnimating = !!animating;
  }

  private async finishAnimationV2(): Promise<void> {
    log.showInfo('FourFingers finishAnimation');
    let switchSuccess = false;
    try {
      if (this.moveState.exceedSwipeMoveThreshold() && this.conditions?.allowSwitch) {
        await this.animationCtrl?.toSwitch();
        const targetId = MultiSpace.get().getTargetId();
        switchSuccess =
          await this.spaceCtrl.switchAccountToTarget(SwitchEnterpriseMultiSpaceType.FOUR_FINGER, targetId!);
      }
    } finally {
      if (!switchSuccess) {
        await this.animationCtrl?.restore();
        this.conditions?.toast?.();
        this.animationCtrl?.toFinish();
      }
      this.postAnimation();
    }
  }

  /**
   * 一次性过完
   */
  private async oneGoSwitch() {
    if (!this.moveState.isOneGoSwitch()) {
      await this.animationCtrl?.restore();
      this.postAnimation(true);
      log.showInfo('this.moveState.isOneGoSwitch is false')
      return;
    }
    if (this.conditions?.allowStart) {
      await MultiSpaceSwitchOneGoCtrl.get()
        .handle(this.moveState.getFinalDirection(), SwitchEnterpriseMultiSpaceType.FOUR_FINGER);
    }
    this.postAnimation();
    await this.animationCtrl?.restore();
  }

  private async postAnimation(shouldSwitch: boolean = false) {
    log.showInfo(`MultiSpaceSwipeCtrl postAnimation, switch done, switched=${shouldSwitch}`);
    this.moveState.reset();
    this.conditions?.toast?.();
    this.conditions = undefined;
    this.isAnimating = false;
  }
}

export class MultiSpaceSwitchOneGoCtrl {
  private spaceCtrl: MultiSpace = MultiSpace.get();
  private animationCtrl: MultiSpaceSwitchAnimationCtrlInf | null = null;
  private static instance: MultiSpaceSwitchOneGoCtrl;

  public static get(): MultiSpaceSwitchOneGoCtrl {
    if (!MultiSpaceSwitchOneGoCtrl.instance) {
      MultiSpaceSwitchOneGoCtrl.instance = new MultiSpaceSwitchOneGoCtrl();
    }
    return MultiSpaceSwitchOneGoCtrl.instance;
  }

  public setAnimationCtrl(callback: MultiSpaceSwitchAnimationCtrlInf | null): void {
    this.animationCtrl = callback;
  }

  /**
   * 判断是否可以向目标方向切换空间
   *
   * @param direction
   * @returns
   */
  canHandleSpaceSwitch(direction: SwipeGestureDirection, switchType: SwitchEnterpriseMultiSpaceType): boolean {
    const switchMethod = switchType || SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY;
    const targetId = MultiSpace.get().getTargetId();
    if (!targetId) {
      log.showInfo('no another space');
      return false;
    }
    const direc = this.fixDirection(switchType, targetId!, direction);
    const cond = spaceSwitchCheck.check(switchMethod, direc, targetId!);
    if (!cond.allowStart || !cond.allowSwitch) {
      cond.toast?.();
    }
    return cond.allowStart;
  }

  /**
   *
   * @param direction 切换方向。向左切换，加载右侧空间
   * @param targetId 目标空间Id
   *
   * @returns 被处理时返回true，未处理时返回false
   */
  public async handle(direction: SwipeGestureDirection, switchType: SwitchEnterpriseMultiSpaceType): Promise<void> {
    log.showInfo(`MultiSpaceSwitchOneGoCtrl.handle, direction=${direction}`);
    Trace.start('SWITCHACCOUNTANIMATION_SHORTCUT_KEY');
    const targetId = MultiSpace.get().getTargetId();
    if (!targetId) {
      log.showInfo('no another space');
      return;
    }
    const direc = this.fixDirection(switchType, targetId!, direction);
    const cond = spaceSwitchCheck.check(switchType, direc, targetId);
    if (!cond.allowStart || !cond.allowSwitch) {
      cond.toast?.();
      return;
    }
    const img = await this.animationCtrl?.startWithScreenshot();
    if (!img) {
      return;
    }
    const canSwitch = await this.animationCtrl?.doneInOneGo(img, direc, MultiSpace.get().getSpaceType());
    if (!canSwitch) {
      log.showWarn(`already in progress can not exec again, canSwitch: ${canSwitch}`);
      return;
    }
    let switchSuccess: boolean = false;
    try {
      switchSuccess = await this.spaceCtrl.switchAccountToTarget(switchType, targetId!);
    } finally {
      log.showInfo(`handleSwitch, result: ${switchSuccess}`);
      if (!switchSuccess) {
        this.animationCtrl?.restore();
        this.animationCtrl?.toFinish();
      }
    }
  }

  /**
   * 创建个人空间完成后，执行切换到个人空间动画。
   * @param targetId
   * @returns
   */
  public async switchAnimationAfterPersonalCreated(targetId: number): Promise<void> {
    const img = await this.animationCtrl?.startWithScreenshot();
    if (!img) {
      return;
    }
    const canSwitch = await this.animationCtrl?.doneInOneGo(img, Direction.ToLeft);
    if (!canSwitch) {
      log.showWarn(`switch personal space already in progress can not exec again, canSwitch: ${canSwitch}`);
      return;
    }
    let switchSuccess: boolean = false;
    try {
      switchSuccess = await this.spaceCtrl.switchAccountToTarget(SwitchEnterpriseMultiSpaceType.HOS_KEY, targetId!);
    } finally {
      log.showInfo(`switch personal space result: ${switchSuccess}`);
      if (!switchSuccess) {
        this.animationCtrl?.restore();
        this.animationCtrl?.toFinish();
      }
    }
  }

  public async startCreatePersonalSpaceAnimation(duration: number): Promise<void> {
    log.showInfo(`startCreatePersonalSpaceAnimation`);
    const img = await this.animationCtrl?.startWithScreenshot();
    if (!img) {
      return;
    }
    await this.animationCtrl?.doneInOneGo(img, Direction.ToLeft)
    setTimeout(() => {
      this.animationCtrl?.toFinish();
    }, duration)
  }

  private fixDirection(switchType: SwitchEnterpriseMultiSpaceType, targetId: number,
    direction: SwipeGestureDirection): Direction {
    if (switchType === SwitchEnterpriseMultiSpaceType.FOUR_FINGER ||
      switchType === SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY) {
      const isLeft: boolean = direction === SwipeGestureDirection.LEFT;
      return isLeft ? Direction.ToLeft : Direction.ToRight;
    } else {
      return targetId > accountModel.getCurrentUserId() ? Direction.ToLeft : Direction.ToRight;
    }
  }
}

export enum SpaceTypeKey {
  None,
  Enterprise,
  Personal
}

export class MultiSpace {
  private static instance: MultiSpace | null = null;
  private readonly ENTERPRISE_SPACE_USER_ID: number = 100;
  private readonly SUPPORT_SPACE_CNT: number = 2;
  private enterpriseSpaceEnable: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();

  static get(): MultiSpace {
    if (!MultiSpace.instance) {
      MultiSpace.instance = new MultiSpace();
      MultiSpace.instance.init();
    }
    return MultiSpace.instance;
  }

  private init() {
    this.registerLockListener();
    this.registerUserSwitchListener();
    this.initSpaceEnable();
  }

  /**
   * 获取和当前用户id偏移量的用户类型
   *
   * @returns 用户账户类型，None类型表示无用户信息
   */
  getSpace(offset: number): SpaceTypeKey {
    const direction = offset < 0 ? Direction.ToLeft : Direction.ToRight;
    const targetId = this.getTargetId();
    if (!targetId) {
      // 如果targetId不存在，默认为个人空间
      log.showWarn(`targetId is not exist`);
      return SpaceTypeKey.Personal;
    }

    if (!spaceSwitchCheck.checkDirectionAndTargetId(direction, targetId)) {
      log.showWarn(`direction not match targetId `);
      return SpaceTypeKey.None;
    }

    return this.getSpaceType();
  }

  getSpaceType(): SpaceTypeKey {
    return (accountModel.getCurrentUserId() === this.ENTERPRISE_SPACE_USER_ID) ? SpaceTypeKey.Personal :
    SpaceTypeKey.Enterprise;
  }

  getCurrentSpaceType(): SpaceTypeKey {
    return (accountModel.getCurrentUserId() === this.ENTERPRISE_SPACE_USER_ID) ? SpaceTypeKey.Enterprise :
    SpaceTypeKey.Personal;
  }

  private registerUserSwitchListener(): void {
    try {
      osAccount.getAccountManager().on('switched', (switchEvtData: osAccount.OsAccountSwitchEventData) => {
        if (switchEvtData.toAccountId === accountModel.getCurrentUserId()) {
          addPersonalSpaceCtrl.correctSpaceInitParm();
          switchCoolDown.markEnterDone();
          this.updateSpaceEnable();
        }
      });
    } catch (error) {
      log.showError(`monitorUserSwitch failed, err.code=${error.code}`);
    }
  }

  private initSpaceEnable() {
    this.updateSpaceEnable();
    this.eventMgr.on(OobeActivatedEvent, (event: OobeActivatedEvent) => {
      log.showInfo(`OobeActivatedEvent isActivated ${event.isActivated}`);
      this.updateSpaceEnable();
    })
  }

  private updateSpaceEnable() {
    const spaceSysParam = systemParameterEnhance.getSync('persist.space_mgr_service.enterprise_space_enable', 'empty');
    const paramEnable = spaceSysParam === 'true';
    if (!paramEnable) {
      log.showInfo(`updateSpaceEnable: ${this.enterpriseSpaceEnable}`);
      this.enterpriseSpaceEnable = false;
      return;
    }
    try {
      // 判断是否隔离双空间和单空间版本，根据是否有SA接口判断，开机时候调用判断一次
      log.showInfo(`spaceAbility  ${spaceAbility.isNeedLockScreen()}`);
      this.enterpriseSpaceEnable = true;
    } catch (err) {
      log.showWarn('spaceAbility is not exist.');
      this.enterpriseSpaceEnable = false;
    }
    log.showInfo(`updateSpaceEnable: ${this.enterpriseSpaceEnable}`);
  }

  checkSpaceEnable(): boolean {
    return this.enterpriseSpaceEnable;
  }

  private registerLockListener(): void {
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback({
      name: 'MultiSpaceSwitchCtrl',
      onLock: () => {
        log.showInfo('screen locked')
        emitter.off(Constants.SPACE_SWITCH);
        this.updateSpaceEnable();
      },
      onUnlock: () => {
        log.showInfo('screen unlocked')
        developMode.update(true);
        this.updateSpaceEnable();
        this.registerHosKeySpaceSwitch();
        this.openAddPersonalSpaceDialog();
      }
    })
  }

  /**
   * 检查空间参数，拉起个人空间创建引导
   */
  private openAddPersonalSpaceDialog() {
    addPersonalSpaceCtrl.correctSpaceInitParm().then((needShow) => {
      if (!needShow) {
        log.info(`addPersonalSpaceCtrl needShow ${needShow}`);
        return;
      }
      const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      addPersonalSpaceCtrl.openDialog(context);
    });
  }

  private registerHosKeySpaceSwitch(): void {
    log.showInfo('registerHosKeySpaceSwitch');
    emitter.on(Constants.SPACE_SWITCH, async (data: emitter.EventData) => {
      log.showInfo('HosKeySpaceSwitch');
      let isEnterpriseSpaceEnable: boolean = false;
      try {
        isEnterpriseSpaceEnable =
          systemParameterEnhance.getSync('persist.space_mgr_service.enterprise_space_enable', 'empty') === 'true';
      } catch (err) {
        log.showInfo(`get enterprise_space_enable failed, ${err?.code} ${err?.message}`);
      }

      if (!isEnterpriseSpaceEnable) {
        log.showInfo('not enterprise_space_enable version, no processing required.');
        return;
      }
      // Settings 发送的 space_switch 信号会传递 id
      const id: number | undefined = data.data?.['id'];
      if (id !== undefined) {
        // 等待隐私页关闭，避免隐私页动效截图无权限而出现黑屏
        await new Promise<void>(resolve => setTimeout(resolve, WAIT_PRIVACY_PAGE_HIDDEN));
        // 设置个人空间完成后, 会从 Settings 发送信号并传递 id, 此处开始切换至个人空间
        await MultiSpaceSwitchOneGoCtrl.get().switchAnimationAfterPersonalCreated(id);
        return;
      }
      if (MultiSpaceSwitchOneGoCtrl.get()
        .canHandleSpaceSwitch(SwipeGestureDirection.LEFT, SwitchEnterpriseMultiSpaceType.HOS_KEY)) {
        setTimeout(() => {
          MultiSpaceSwitchOneGoCtrl.get().handle(SwipeGestureDirection.LEFT, SwitchEnterpriseMultiSpaceType.HOS_KEY);
        }, 250)
        return;
      }
    });
  }

  /**
   * 按照位移方向切换用户，计算目标空间UserId
   *
   * @param direction 向左-1，向右+1
   * @param targetId 目标空间id
   * @returns
   */
  public async switchAccountToTarget(switchType: string, targetId: number): Promise<boolean> {
    this.markTargetSpaceAnimation(targetId);
    const curSpaceId = accountModel.getCurrentUserId();
    const accountMgr = osAccount.getAccountManager();
    log.showInfo(`switchSpace: curSpaceId:${curSpaceId}, targetId:${targetId}, switchType:${switchType}`);
    try {
      // 等待500ms播放粒子动效
      await new Promise<void>(resolve => setTimeout(resolve, 500));

      Trace.start('SWITCHACCOUNTANIMATION_PULL_UP_PAGE');
      AppStorage.setOrCreate('accountSwitch', true);
      await accountMgr.activateOsAccount(targetId);
      Trace.end('SWITCHACCOUNTANIMATION_PULL_UP_PAGE');
      HiSysEventUtil.reportSwitchEnterpriseMultiSpaceEvent(curSpaceId, targetId, switchType,
        SWITCH_ACCOUNT_SUCCESS);
      log.showInfo('switchSpace: success');
      return true;
    } catch (err) {
      log.showWarn(`switchSpace: failed. err?.code: ${err?.code}, msg: ${err?.message}`);
      AppStorage.setOrCreate('accountSwitch', false);
      HiSysEventUtil.reportSwitchEnterpriseMultiSpaceEvent(curSpaceId, targetId, switchType, SWITCH_ACCOUNT_FAILED);
      return false;
    }
  }

  getTargetId(): number | undefined {
    const accountList: IUserData[] | undefined = AppStorage.get('userList');
    // 当前仅支持2个空间
    if (!accountList || accountList.length < this.SUPPORT_SPACE_CNT) {
      return undefined;
    }
    const target = accountList.filter(userData => userData.userId != accountModel.getCurrentUserId())[0];
    log.showInfo(`getTargetId: ${target.userId}`);
    return target.userId;
  }

  private markTargetSpaceAnimation(targetId: number) {
    const animationTime = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, false).toString();
    const context: Context = getContext(this);
    settings.setValue(context, 'screenlockSwitchToId', targetId.toString(), settings.domainName.DEVICE_SHARED);
    settings.setValue(context, 'screenAnimationStatus', animationTime, settings.domainName.DEVICE_SHARED);
  }
}

/**
 * 添加个人空间控制器
 */
class AddPersonalSpaceCtrl {
  public static instance: AddPersonalSpaceCtrl | null = null;
  private readonly ANIMATION_PERSIST_TIME: number = 1500;
  // 控制是否需要解锁空间的参数名
  public readonly unlockParamKey = 'settings.space_mgr_service.space_unlock_screen_valid_uptime';
  // 个人空间创建状态
  public readonly spaceFirstCreateKey = 'settings.personal_space_has_created';
  // 控制是否需要解锁空间的参数名
  public readonly needShowSpaceLoadingView = 'needShowSpaceLoadingView';
  // 空间 init 参数: 0 - 企业空间未初始化; 1 - 个人空间未初始化; 2 - 双空间均已初始化
  public readonly spaceInitParamKey = 'persist.space_mgr_service.enterprise_space_init';
  // 可以解锁空间的有效时间, 以 millisecond 为单位
  public readonly validDuration = 10_000;
  // 解锁后隐藏 LoadingView 的延迟时间, 以 millisecond 为单位
  public readonly hideLoadingViewDelay = 2_000;
  private _ctx: common.ServiceExtensionContext | null = null;
  private subscriberMap: Map<string, commonEventManager.CommonEventSubscriber> = new Map();

  // 获取上下文 (主要用于 settings.setValueSync)
  private get ctx(): common.ServiceExtensionContext {
    if (this._ctx === null) {
      const context = GlobalContext.getInstance().getObject('desktopContext') as common.ServiceExtensionContext;
      this._ctx = context;
    }
    return this._ctx;
  }

  /**
   * 获取控制器单例
   * @returns
   */
  public static getInstance(): AddPersonalSpaceCtrl {
    if (!AddPersonalSpaceCtrl.instance) {
      return new AddPersonalSpaceCtrl();
    }
    return AddPersonalSpaceCtrl.instance;
  }

  private constructor() {
    this.registerSpaceRemoveListener();
  }

  private registerSpaceRemoveListener() {
    emitter.on(Constants.SPACE_REMOVE, async (data: emitter.EventData) => {
      try {
        const id: number | undefined = data.data?.['id'];
        log.info(`receive remove space id: ${id}`);
        const accountMgr = osAccount.getAccountManager();
        AppStorage.setOrCreate('accountSwitch', true);
        await accountMgr.removeOsAccount(id);
      } catch (err) {
        log.error(`remove space failed code is ${err?.code}.`);
        AppStorage.setOrCreate('accountSwitch', false);
      }
    })
  }

  /**
   * 订阅事件, 在事件发布时执行回调
   * @param event 需要订阅的事件名
   * @param once 是否只执行一次
   * @param callback 事件发布时执行的回调
   */
  public subscribeEvent(event: string, once: boolean,
    callback: (data: commonEventManager.CommonEventData) => void): void {
    log.info(`subscribeEvent event ${event}`);
    if (this.subscriberMap.has(event)) {
      // 对已存在的订阅, 重复订阅会用新的覆盖旧的, 此处日志记录一下
      log.info(`event ${event} is already subscribed`);
    }
    try {
      commonEventManager.createSubscriber({ events: [event] },
        (err: BusinessError, subscriber: commonEventManager.CommonEventSubscriber) => {
          if (err) {
            log.error(`createSubscriber event ${event} failed.`, err);
            return;
          }
          log.info(`createSubscriber event ${event} successfully`);
          this.subscriberMap.set(event, subscriber);
          commonEventManager.subscribe(subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
            if (err) {
              log.error(`subscribe event ${event} failed.`, err);
              return;
            }
            log.info(`subscribe event ${event} successfully`);
            if (once) {
              this.unsubscribeEvent(event);
            }
            callback(data);
          });
        });
    } catch (err) {
      log.error(`subscribeEvent failed.`, err);
    }
  }

  public unsubscribeEvent(event: string): void {
    log.info(`unsubscribeEvent event ${event}`);
    if (!this.subscriberMap.has(event)) {
      log.info(`event ${event} not subscribed`);
      return;
    }
    try {
      commonEventManager.unsubscribe(this.subscriberMap.get(event));
      this.subscriberMap.delete(event);
      log.info(`unsubscribe event ${event} successfully`);
    } catch (err) {
      log.error(`unsubscribeEvent event ${event} failed`, err);
    }
  }

  public onSpaceSwitch(id: number): void {
    log.info(`onSpaceSwitch id ${id}`);
    if (id !== accountModel.getCurrentUserId()) {
      log.info('start switching space');
      this.switchSpaceLoadingView(true);
      accountModel.onAccountSwitch(id, () => {
        setTimeout(() => {
          this.switchSpaceLoadingView(false);
        }, INVALID_LOADING_PERSIST_TIME);
      });
    }
  }

  /**
   * 设置空间加载界面是否可见; 空间加载界面是创建个人空间完成到进入 OOBE 的过渡界面
   * @param visible
   */
  public switchSpaceLoadingView(visible: boolean): void {
    AppStorage.setOrCreate<boolean>('needShowSpaceLoadingView', visible);
    log.info(`switchSpaceLoadingView visible ${visible}`);
  }

  /**
   * 根据空间参数和账户数, 决定是否要校正空间参数
   * @param ctx 与 systemDialog 建立连接依赖的上下文
   */
  public async correctSpaceInitParm(): Promise<boolean> {
    log.info('correctSpaceInitParm');
    if (systemParameterEnhance.getSync('persist.space_mgr_service.enterprise_space_enable', 'empty') !==
      'true') {
      return false;
    }
    try {
      let oobeActivated: boolean = sSCBOobeManager.isOobeActivated();
      if (oobeActivated) {
        log.info('oobe is Activated, no need to add personal space');
        return false;
      }
      const spaceInitPara = systemParameterEnhance.getSync(this.spaceInitParamKey, 'empty');
      const accounts: osAccount.OsAccountInfo[] = await osAccount.getAccountManager().queryAllCreatedOsAccounts();
      log.info(`correctSpaceInitParm spaceInitPara ${spaceInitPara} accounts number ${accounts.length}`);
      // 检查 init 值是否与账号数匹配, 不匹配则需要修正
      if (spaceInitPara === SpaceInitializeParamEnum.SPACE_INITIALIZED && accounts.length === 1) {
        log.info('correctSpaceInitParm spaceInitPara inconsistent. will reset to 1');
        systemParameterEnhance.setSync(this.spaceInitParamKey, SpaceInitializeParamEnum.P_SPACE_NOT_INITIALIZED);
      }
      const hasCreatedOnce: boolean = settings.getValueSync(this.ctx, this.spaceFirstCreateKey, 'false') === 'true';
      log.info(`hasCreatedOnce: ${hasCreatedOnce}`);
      return !hasCreatedOnce && accounts.length === 1;
    } catch (err) {
      log.error('correctSpaceInitParm failed.', err);
      return false;
    }
  }

  /**
   * 依赖 systemDialog 拉起空间管理的添加个人空间弹窗
   * @param ctx 与 systemDialog 建立连接依赖的上下文
   */
  public openDialog(ctx: common.UIAbilityContext): void {
    log.info('openAddPersonalSpaceDialog');
    const want: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'com.ohos.sceneboard.systemdialog', // 大桌面系统弹窗
    };
    const connectOption: common.ConnectOptions = {
      onConnect(elementName, remote) {
        log.info('onConnect');
        try {
          const option = new rpc.MessageOption();
          const data = rpc.MessageSequence.create();
          const reply = rpc.MessageSequence.create();
          const bundleName: string = 'com.openharmony.space_manager'; // systemDialog 拉起的业务方包名 - 空间管理
          const abilityName: string = 'AddPersonalSpaceAbility'; // systemDialog 拉起的业务方 ability 名 - 添加个人空间
          const parameter: Record<string, Object> = {
            'ability.want.params.uiExtensionType': 'sysDialog/common',
          };
          const reqParamNum: number = 3; // systemDialog 约定的参数个数
          const reqCodePower: number = 1; // systemDialog 约定的 code power
          log.info('onConnect start writing data');
          data.writeInt(reqParamNum);
          data.writeString('bundleName');
          data.writeString(bundleName);
          data.writeString('abilityName');
          data.writeString(abilityName);
          data.writeString('parameters');
          data.writeString(JSON.stringify(parameter));
          log.info('onConnect start sending request');
          remote.sendMessageRequest(reqCodePower, data, reply, option)
            .then((result: rpc.RequestResult) => {
              log.info(`request space_manager completed. ${result.errCode} ${result.reply.readInt()}`);
            })
            .catch((err: BusinessError) => {
              log.error('request space_manager failed.', err)
            })
            .finally(() => {
              // 释放MessageSequence创建的内存
              data.reclaim();
              reply.reclaim();
            });
        } catch (err) {
          log.error(`onConnect failed.`, err);
        }
      },
      onDisconnect(elementName) {
        log.info(`DisConnect from System Dialog,elementName: ${elementName.bundleName}`);
      },
      onFailed(code) {
        log.error(`connect to systemDialog failed,code: ${code}`);
      }
    }
    try {
      const connectionId = ctx.connectServiceExtensionAbility(want, connectOption);
      log.info(`start connecting. connectionId ${connectionId}`);
    } catch (err) {
      log.error('connect to systemDialog failed.', err);
    }
  }
}

// 添加个人空间控制器单例
export const addPersonalSpaceCtrl: AddPersonalSpaceCtrl = AddPersonalSpaceCtrl.getInstance();