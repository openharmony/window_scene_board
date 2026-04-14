/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSCBOobeManager, SCBTransitionManager } from '@ohos/windowscene';
import { LockState, PageState, ScreenLockStateManager } from '../manager/ScreenLockStateManager';
import { SimCardStateManager } from '../manager/SimCardStateManager';
import { VerifyDataManager } from '../manager/VerifyDataManager';
import { SlServerHelper } from '../utils/SlServerHelper';
import { WallpaperZIndexUtils } from '../utils/WallpaperZIndexUtil';
import { AbstractEvent, AbstractFsm, AbstractState, AbstractStateFactory } from './ScreenLockFsm';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'ScreenLockCoreFsm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_OFF = 0x1000; // 熄屏态
const SCREEN_ON = 0x2000; // 亮屏态

const MAIN_PAGE = 0x100; // 主页
const BOUNCER_PAGE = 0x200; // 密码页
const UNLOCK_PAGE = 0x400; // 解锁页

const SIM_LOCK_STATE = 0x10; // SIM卡锁定态
const PWD_LOCK_STATE = 0x20; // 密码锁定态
const UNLOCKED_STATE = 0x40; // 解锁态

const EDIT_STATE = 0x1; // 编辑态
const FAKE_AOD = 0x2; // 假AOD态

/**
 * 定义：核心状态机-状态类型
 */
export enum CoreStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 熄屏主页锁屏态
   */
  SCREEN_OFF_MP_LOCK_STATE = SCREEN_OFF | MAIN_PAGE | PWD_LOCK_STATE,

  /**
   * 熄屏主页解锁态
   */
  SCREEN_OFF_MP_UNLOCK_STATE = SCREEN_OFF | MAIN_PAGE | UNLOCKED_STATE,

  /**
   * 熄屏密码验证态
   */
  SCREEN_OFF_PWD_CHECK_STATE = SCREEN_OFF | BOUNCER_PAGE | PWD_LOCK_STATE,

  /**
   * 熄屏SIM校验态
   */
  SCREEN_OFF_SIM_CHECK_STATE = SCREEN_OFF | BOUNCER_PAGE | SIM_LOCK_STATE,

  /**
   * 熄屏非锁屏态
   */
  SCREEN_OFF_UNLOCK_STATE = SCREEN_OFF | UNLOCK_PAGE | UNLOCKED_STATE,

  /**
   * 主页锁屏态
   */
  MAIN_PAGE_LOCK_STATE = SCREEN_ON | MAIN_PAGE | PWD_LOCK_STATE,

  /**
   * 主页假AOD态
   */
  MAIN_PAGE_FAKE_AOD_STATE = SCREEN_ON | MAIN_PAGE | PWD_LOCK_STATE | FAKE_AOD,

  /**
   * 主页解锁态
   */
  MAIN_PAGE_UNLOCK_STATE = SCREEN_ON | MAIN_PAGE | UNLOCKED_STATE,

  /**
   * 主页编辑态
   */
  MAIN_PAGE_EDIT_STATE = SCREEN_ON | MAIN_PAGE | UNLOCKED_STATE | EDIT_STATE,

  /**
   * 密码页TO非锁屏态
   */
  BOUNCER_TO_UNLOCK_STATE = SCREEN_ON | BOUNCER_PAGE | PWD_LOCK_STATE,

  /**
   * 密码页解锁态
   */
  BOUNCER_UNLOCK_STATE = SCREEN_ON | BOUNCER_PAGE | UNLOCKED_STATE,

  /**
   * 密码页TO编辑态
   */
  BOUNCER_TO_EDIT_STATE = SCREEN_ON | BOUNCER_PAGE | PWD_LOCK_STATE | EDIT_STATE,

  /**
   * 密码页SIM卡校验态
   */
  BOUNCER_SIM_CHECK_STATE = SCREEN_ON | BOUNCER_PAGE | SIM_LOCK_STATE,

  /**
   * 非锁屏态
   */
  UNLOCK_STATE = SCREEN_ON | UNLOCK_PAGE | UNLOCKED_STATE,
}

/**
 * 核心状态机-状态类型工具类
 */
export class CoreStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于熄屏页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInScreenOff(stateType: CoreStateType): boolean {
    return (stateType & SCREEN_OFF) === SCREEN_OFF;
  }

  /**
   * 是否处于亮屏态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInScreenOn(stateType: CoreStateType): boolean {
    return (stateType & SCREEN_ON) === SCREEN_ON;
  }

  /**
   * 是否处于主页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInMainPage(stateType: CoreStateType): boolean {
    return (stateType & (SCREEN_ON | MAIN_PAGE)) === (SCREEN_ON | MAIN_PAGE);
  }

  /**
   * 是否处于主页常态显示态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInNormalMainPage(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.MAIN_PAGE_LOCK_STATE || stateType === CoreStateType.MAIN_PAGE_UNLOCK_STATE;
  }

  /**
   * 是否处于主页假AOD态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInFakeAodMainPage(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.MAIN_PAGE_FAKE_AOD_STATE;
  }

  /**
   * 是否处于主页编辑态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInEditMainPage(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.MAIN_PAGE_EDIT_STATE;
  }

  /**
   * 是否处于密码页态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInBouncePage(stateType: CoreStateType): boolean {
    return (stateType & (SCREEN_ON | BOUNCER_PAGE)) === (SCREEN_ON | BOUNCER_PAGE);
  }

  /**
   * 是否处于正常密码页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInNormalBounce(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.BOUNCER_TO_UNLOCK_STATE || stateType === CoreStateType.BOUNCER_TO_EDIT_STATE;
  }

  /**
   * 是否解锁进编辑页面
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isBounceToEditState(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.BOUNCER_TO_EDIT_STATE;
  }

  /**
   * 是否处于Sim卡校验密码页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInSimCheckBounce(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.BOUNCER_SIM_CHECK_STATE;
  }

  /**
   * 是否处于熄屏Sim卡校验态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInSimCheckScreenOff(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.SCREEN_OFF_SIM_CHECK_STATE;
  }

  /**
   * 是否处于非锁屏页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInUnlockPage(stateType: CoreStateType): boolean {
    return (stateType & UNLOCK_PAGE) === UNLOCK_PAGE;
  }

  /**
   * 是否处于熄屏非锁屏态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isScreenOffUnlockState(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.SCREEN_OFF_UNLOCK_STATE;
  }

  public static isScreenOffPwdCheckState(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.SCREEN_OFF_PWD_CHECK_STATE;
  }

  public static isBouncerToUnlockState(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.BOUNCER_TO_UNLOCK_STATE;
  }

  /**
   * 是否处于亮屏解锁态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isUnlockStateScreenOn(stateType: CoreStateType): boolean {
    return (stateType & (SCREEN_ON | UNLOCKED_STATE)) === (SCREEN_ON | UNLOCKED_STATE);
  }

  /**
   * 是否处于亮屏非锁屏页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isUnlockPageScreenOn(stateType: CoreStateType): boolean {
    return stateType === CoreStateType.UNLOCK_STATE;
  }

  /**
   * 是否处于解锁态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isUnlockState(stateType: CoreStateType): boolean {
    return (stateType & UNLOCKED_STATE) === UNLOCKED_STATE;
  }

  /**
   * 是否处于亮屏态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isScreenOnState(stateType: CoreStateType): boolean {
    return (stateType & SCREEN_ON) === SCREEN_ON;
  }

  /**
   * 是否处于AOD态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isAodState(stateType: CoreStateType): boolean {
    return (stateType & (SCREEN_ON | FAKE_AOD)) === (SCREEN_ON | FAKE_AOD);
  }

  /**
   * 是否处于熄屏态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isScreenOffState(stateType: CoreStateType): boolean {
    return (stateType & SCREEN_OFF) === SCREEN_OFF;
  }

  /**
   * 是否处于密码校验态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isPwdLockState(stateType: CoreStateType): boolean {
    return (stateType & (SCREEN_ON | PWD_LOCK_STATE)) === (SCREEN_ON | PWD_LOCK_STATE);
  }

  /**
   * 是否处于SIM校验态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isSimLockState(stateType: CoreStateType): boolean {
    return (stateType & (SCREEN_ON | SIM_LOCK_STATE)) === (SCREEN_ON | SIM_LOCK_STATE);
  }
}

/**
 * 定义：主状态机-事件类型
 */
export enum CoreEventType {
  /**
   * 亮屏事件（包括：1、熄屏态双击屏幕 2、熄屏态按电源键）
   */
  SCREEN_ON,

  /**
   * 熄屏通知事件（包括：1、关闭电源, 一段时间未操作引起熄屏）
   */
  PRE_SCREEN_OFF,

  /**
   * 熄屏事件（包括：1、屏幕关闭）
   */
  SCREEN_OFF,

  /**
   * 强制熄屏事件（包括：1、收到endSleep时处于掉电状态，多用户场景才会出现）
   */
  FORCE_SCREEN_OFF,

  /**
   * 请求锁屏（包括：1、收到服务侧锁屏请求）
   */
  REQUEST_LOCK,

  /**
   * 请求解锁（包括：1、收到服务侧解锁请求，2、假AOD双击 3、点击应用 4、收到锁屏服务的请求解锁）
   */
  REQUEST_UNLOCK,

  /**
   * 底部上滑（包括：1、熄屏态底部上滑 2、主页态底部上滑）
   */
  SLIDE_FROM_BOTTOM,

  /**
   * 直接解锁（包括：1、指纹校验成功 2、密码校验成功 3、人脸解锁配合直接解锁设置 4、密码页验证SIM卡通过且无锁屏密码 5、OOBE阶段且未设置密码
   *  6、账号激活且已验证 7、假AOD态上滑）
   */
  UNLOCK_DIRECT,

  /**
   * 静默解锁（包括：1、未设置密码 2、 人脸解锁配合滑动解锁设置）
   */
  UNLOCK_SILENCE,

  /**
   * 返回主页（包括：1、 密码页点击返回、紧急呼叫、被覆盖或锁屏应用启动 2、进程启动或系统Ready且设置了密码或非OOBE阶段无密码）
   */
  BACK_TO_MAIN_PAGE,

  /**
   * 进入编辑态（包括：1、双指捏合 2、长按时钟）
   */
  ENTER_EDIT,

  /**
   * 退出编辑态（包括：1、取消编辑 2、应用 3、底部上滑 4、编辑常态时侧滑）
   */
  EXIT_EDIT,

  /**
   * 插SIM卡
   */
  ADD_SIM_CARD,

  /**
   * 拨SIM卡
   */
  REMOVE_SIM_CARD,

  /**
   * SIM卡验证通过（设置了锁屏密码）
   */
  CHECK_SIM_SUCCESS,

  /**
   * 账号去激活（包括：1、多用户场景其他账号激活）
   */
  USER_DEACTIVATE,

  /**
   * 账号激活（包括：1、多用户场景本账号激活）
   */
  USER_ACTIVATE,

  /**
   * 验证失败（包括：1、熄屏态下指纹多次验证失败）
   */
  VERIFY_FAIL,
}

/**
 * 核心状态机事件
 */
export class CoreEvent extends AbstractEvent<CoreEventType> {
  public toString(): string {
    return CoreEventType[this.eventType] ?? 'Unknown_CoreEvent';
  }
}

/**
 * 抽象核心状态
 */
abstract class AbstractCoreState extends AbstractState<CoreStateType, CoreEvent> {
  public toString(): string {
    return CoreStateType[this.stateType] ?? 'Unknown_CoreState';
  }
}

/**
 * 初始态
 */
class InitState extends AbstractCoreState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.BACK_TO_MAIN_PAGE:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.ADD_SIM_CARD:
        return CoreStateType.BOUNCER_SIM_CHECK_STATE;
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.UNLOCK_SILENCE:
        return CoreStateType.MAIN_PAGE_UNLOCK_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 非SIM卡校验熄屏态
 */
abstract class NotSimCheckScreenOffState extends AbstractCoreState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.ADD_SIM_CARD:
        return CoreStateType.SCREEN_OFF_SIM_CHECK_STATE;
      case CoreEventType.REMOVE_SIM_CARD:
        return CoreStateType.SCREEN_OFF_MP_LOCK_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 熄屏主页锁屏态
 */
class ScreenOffMpLockState extends NotSimCheckScreenOffState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SCREEN_ON:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.VERIFY_FAIL:
      case CoreEventType.SLIDE_FROM_BOTTOM:
      case CoreEventType.REQUEST_UNLOCK:
        if (VerifyDataManager.getInstance().hasNoPwd) {
          return CoreStateType.UNLOCK_STATE;
        } else {
          return CoreStateType.SCREEN_OFF_PWD_CHECK_STATE;
        }
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.SCREEN_OFF_UNLOCK_STATE;
      case CoreEventType.UNLOCK_SILENCE:
        return CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 熄屏主页解锁态
 */
class ScreenOffMpUnlockState extends NotSimCheckScreenOffState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SCREEN_ON:
        return CoreStateType.MAIN_PAGE_UNLOCK_STATE;
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 熄屏密码验证态
 */
class ScreenOffPwdCheckState extends NotSimCheckScreenOffState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SCREEN_ON:
        return CoreStateType.BOUNCER_TO_UNLOCK_STATE;
      case CoreEventType.UNLOCK_DIRECT:
      case CoreEventType.UNLOCK_SILENCE:
        return CoreStateType.SCREEN_OFF_UNLOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 熄屏SIM校验态
 */
class ScreenOffSimCheckState extends AbstractCoreState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.REMOVE_SIM_CARD:
        return CoreStateType.SCREEN_OFF_MP_LOCK_STATE;
      case CoreEventType.SCREEN_ON:
        return CoreStateType.BOUNCER_SIM_CHECK_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 熄屏非锁屏态
 */
class ScreenOffUnlockState extends NotSimCheckScreenOffState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SCREEN_ON:
        return CoreStateType.UNLOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 密码页SIM卡校验态
 */
class BouncerSimCheckState extends AbstractCoreState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.PRE_SCREEN_OFF:
      case CoreEventType.FORCE_SCREEN_OFF:
        return CoreStateType.SCREEN_OFF_SIM_CHECK_STATE;
      case CoreEventType.BACK_TO_MAIN_PAGE:
      case CoreEventType.REMOVE_SIM_CARD:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.CHECK_SIM_SUCCESS:
        return CoreStateType.BOUNCER_TO_UNLOCK_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * SIM卡正常且非熄屏态
 */
abstract class SimNormalAndNotAodState extends AbstractCoreState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.PRE_SCREEN_OFF:
        return CoreStateType.MAIN_PAGE_FAKE_AOD_STATE;
      case CoreEventType.FORCE_SCREEN_OFF:
        return CoreStateType.SCREEN_OFF_MP_LOCK_STATE;
      case CoreEventType.REMOVE_SIM_CARD:
      case CoreEventType.USER_DEACTIVATE:
      case CoreEventType.USER_ACTIVATE:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.ADD_SIM_CARD:
        return CoreStateType.BOUNCER_SIM_CHECK_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 主页锁屏态
 */
class MainPageLockState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SLIDE_FROM_BOTTOM:
      case CoreEventType.REQUEST_UNLOCK:
        return CoreStateType.BOUNCER_TO_UNLOCK_STATE;
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.UNLOCK_SILENCE:
        return CoreStateType.MAIN_PAGE_UNLOCK_STATE;
      case CoreEventType.ENTER_EDIT:
        return CoreStateType.BOUNCER_TO_EDIT_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 主页假AOD态
 */
class MainPageFakeAodState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SCREEN_ON:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.SCREEN_OFF:
        if (SimCardStateManager.getInstance().isSimLocked()) {
          return CoreStateType.SCREEN_OFF_SIM_CHECK_STATE;
        } else {
          return CoreStateType.SCREEN_OFF_MP_LOCK_STATE;
        }
      case CoreEventType.REMOVE_SIM_CARD:
        return this.stateType; // 同父类处理不同，保持状态不变
      case CoreEventType.SLIDE_FROM_BOTTOM:
      case CoreEventType.REQUEST_UNLOCK:
        if (VerifyDataManager.getInstance().hasNoPwd) {
          return CoreStateType.UNLOCK_STATE;
        } else {
          return CoreStateType.BOUNCER_TO_UNLOCK_STATE;
        }
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.BACK_TO_MAIN_PAGE:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 主页解锁态
 */
class MainPageUnlockState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SLIDE_FROM_BOTTOM:
      case CoreEventType.REQUEST_UNLOCK:
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.ENTER_EDIT:
        return CoreStateType.MAIN_PAGE_EDIT_STATE;
      case CoreEventType.REQUEST_LOCK:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 主页编辑态
 */
class MainPageEditorState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.SLIDE_FROM_BOTTOM:
      case CoreEventType.BACK_TO_MAIN_PAGE:
      case CoreEventType.EXIT_EDIT:
        return CoreStateType.MAIN_PAGE_UNLOCK_STATE;
      case CoreEventType.REQUEST_UNLOCK:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.REQUEST_LOCK:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 密码页To非锁屏态
 */
class BouncerToUnlockState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.BACK_TO_MAIN_PAGE:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.UNLOCK_SILENCE:
        return CoreStateType.BOUNCER_UNLOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 密码页解锁态
 */
class BouncerUnlockState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.BACK_TO_MAIN_PAGE:
        return CoreStateType.MAIN_PAGE_UNLOCK_STATE;
      case CoreEventType.SLIDE_FROM_BOTTOM:
      case CoreEventType.REQUEST_UNLOCK:
      case CoreEventType.UNLOCK_DIRECT:
        return CoreStateType.UNLOCK_STATE;
      case CoreEventType.REQUEST_LOCK:
        return CoreStateType.BOUNCER_TO_UNLOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 密码页To编辑态
 */
class BouncerToEditorState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.BACK_TO_MAIN_PAGE:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.UNLOCK_DIRECT:
      case CoreEventType.UNLOCK_SILENCE:
        return CoreStateType.MAIN_PAGE_EDIT_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 非锁屏态
 */
class UnlockState extends SimNormalAndNotAodState {
  public handleEvent(event: CoreEvent): CoreStateType | AbstractState<CoreStateType, CoreEvent> {
    switch (event.eventType) {
      case CoreEventType.REQUEST_LOCK:
        return CoreStateType.MAIN_PAGE_LOCK_STATE;
      case CoreEventType.USER_ACTIVATE:
        // 解锁态激活，不做动作
        return this.stateType;
    }
    return super.handleEvent(event);
  }
}

/**
 * 核心状态工厂
 */
class CoreStateFactory extends AbstractStateFactory<CoreStateType, CoreEvent> {
  constructor() {
    super();
    this.addSateConstructor(CoreStateType.INIT_STATE, (stateType: CoreStateType) => new InitState(stateType));
    this.addSateConstructor(CoreStateType.SCREEN_OFF_MP_LOCK_STATE,
      (stateType: CoreStateType) => new ScreenOffMpLockState(stateType));
    this.addSateConstructor(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE,
      (stateType: CoreStateType) => new ScreenOffMpUnlockState(stateType));
    this.addSateConstructor(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE,
      (stateType: CoreStateType) => new ScreenOffPwdCheckState(stateType));
    this.addSateConstructor(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE,
      (stateType: CoreStateType) => new ScreenOffSimCheckState(stateType));
    this.addSateConstructor(CoreStateType.SCREEN_OFF_UNLOCK_STATE,
      (stateType: CoreStateType) => new ScreenOffUnlockState(stateType));
    this.addSateConstructor(CoreStateType.MAIN_PAGE_LOCK_STATE,
      (stateType: CoreStateType) => new MainPageLockState(stateType));
    this.addSateConstructor(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE,
      (stateType: CoreStateType) => new MainPageFakeAodState(stateType));
    this.addSateConstructor(CoreStateType.MAIN_PAGE_UNLOCK_STATE,
      (stateType: CoreStateType) => new MainPageUnlockState(stateType));
    this.addSateConstructor(CoreStateType.MAIN_PAGE_EDIT_STATE,
      (stateType: CoreStateType) => new MainPageEditorState(stateType));
    this.addSateConstructor(CoreStateType.BOUNCER_TO_UNLOCK_STATE,
      (stateType: CoreStateType) => new BouncerToUnlockState(stateType));
    this.addSateConstructor(CoreStateType.BOUNCER_UNLOCK_STATE,
      (stateType: CoreStateType) => new BouncerUnlockState(stateType));
    this.addSateConstructor(CoreStateType.BOUNCER_TO_EDIT_STATE,
      (stateType: CoreStateType) => new BouncerToEditorState(stateType));
    this.addSateConstructor(CoreStateType.BOUNCER_SIM_CHECK_STATE,
      (stateType: CoreStateType) => new BouncerSimCheckState(stateType));
    this.addSateConstructor(CoreStateType.UNLOCK_STATE, (stateType: CoreStateType) => new UnlockState(stateType));
  }
}

export const SCREEN_LOCK_Z_INDEX: number = 2000;
export const WALLPAPER_Z_INDEX: number = 1;
export const SCREEN_LOCK_WALL_PAPER_Z_INDEX: number = 1999;

/**
 * 定义锁屏的核心状态机
 */
export class ScreenLockCoreFsm extends AbstractFsm<CoreStateType, CoreEvent> {
  constructor(persistentId: number) {
    super(TAG + persistentId, CoreStateType.INIT_STATE, new CoreStateFactory());
    // 进入锁屏流程里，锁屏加锁流程优先执行
    this._preCallback = (oldState: CoreStateType, newState: CoreStateType): void => {
      if (oldState === newState || CoreStateTypeUtils.isInUnlockPage(newState)) {
        return;
      }
      log.showDebug('update screen lock state info to lock');
      if (CoreStateTypeUtils.isInUnlockPage(oldState) && !CoreStateTypeUtils.isInUnlockPage(newState)) {
        this.updateWindowZIndex(newState);
      }
      this.updateScreenLockStateInfo(newState);
    };

    // 退出锁屏流程里，锁屏退锁流程最后执行
    this._postCallback = (oldState: CoreStateType, newState: CoreStateType): void => {
      if (oldState === newState || !CoreStateTypeUtils.isInUnlockPage(newState)) {
        return;
      }
      log.showDebug('update screen lock state info to unlock');
      this.updateScreenLockStateInfo(newState);
      if (!CoreStateTypeUtils.isInUnlockPage(oldState) && CoreStateTypeUtils.isInUnlockPage(newState)) {
        this.updateWindowZIndex(newState);
      }
      if (!CoreStateTypeUtils.isUnlockPageScreenOn(oldState) && CoreStateTypeUtils.isUnlockPageScreenOn(newState)) {
        SCBTransitionManager.getInstance().notifyUnlockAnimation();
        SCBTransitionManager.getInstance().notifyUnlockTransition();
      }
    };
  }

  private updateScreenLockStateInfo(newState: CoreStateType): void {
    if (CoreStateTypeUtils.isInUnlockPage(newState)) {
      // OOBE阶段的解锁提前
      ScreenLockStateManager.getInstance().updateStateInfo({
        pageState: PageState.HIDE,
        lockState: LockState.UNLOCKED,
        isInBouncer: false,
        isInEdite: false,
      });
    } else if (CoreStateTypeUtils.isUnlockState(newState)) {
      ScreenLockStateManager.getInstance().updateStateInfo({
        pageState: PageState.SHOW,
        lockState: LockState.UNLOCKED,
        isInBouncer: false,
        isInEdite: CoreStateTypeUtils.isInEditMainPage(newState),
      });
    } else {
      ScreenLockStateManager.getInstance().updateStateInfo({
        pageState: PageState.SHOW,
        lockState: VerifyDataManager.getInstance().hasNoPwd ? LockState.UNLOCKED : LockState.LOCKED,
        isInBouncer: CoreStateTypeUtils.isInBouncePage(newState),
        isInEdite: false,
      });
    }
  }

  private updateWindowZIndex(newState: CoreStateType): void {
    if (CoreStateTypeUtils.isInUnlockPage(newState)) {
      log.showInfo('wallpaperZIndex to unlockPage');
      ViewManagerPolicy.setZIndex(ViewType.KEYGUARD, SCREEN_LOCK_Z_INDEX);
      WallpaperZIndexUtils.setWallpaperZIndex(WALLPAPER_Z_INDEX, 0);
    } else {
      log.showDebug('wallpaperZIndex to screenLock, enter normal screen lock page.');
      WallpaperZIndexUtils.setWallpaperZIndex(SCREEN_LOCK_WALL_PAPER_Z_INDEX, 0, 'lock');
    }
  }

  protected getNextState(handleEventResult: CoreStateType | AbstractState<CoreStateType, CoreEvent>):
    AbstractState<CoreStateType, CoreEvent> {
    if (SlServerHelper.getInstance().isScreenLockDisabled()) {
      // 演示样机场景，不执行熄屏
      return super.getNextState(CoreStateType.UNLOCK_STATE);
    }
    let rawNextState = super.getNextState(handleEventResult);
    if (this.currentStateType === CoreStateType.MAIN_PAGE_FAKE_AOD_STATE &&
      CoreStateTypeUtils.isScreenOnState(rawNextState.stateType) &&
      rawNextState.stateType !== CoreStateType.MAIN_PAGE_FAKE_AOD_STATE &&
      SimCardStateManager.getInstance().isSimLocked()) {
      // 假AOD打断场景，若有SIM卡需要校验，则跳转至SIM校验态
      return super.getNextState(CoreStateType.BOUNCER_SIM_CHECK_STATE);
    }
    if (rawNextState.stateType === CoreStateType.MAIN_PAGE_LOCK_STATE && VerifyDataManager.getInstance().hasNoPwd) {
      // 无密码时，自动迁移到解锁态，避免状态反复横跳
      return super.getNextState(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
    }
    return rawNextState;
  }

  /**
   * 提交核心状态机事件
   *
   * @param event 状态机事件
   */
  public submitEvent(eventIn: CoreEvent | CoreEventType): void {
    let event: CoreEvent;
    if (eventIn instanceof CoreEvent) {
      event = eventIn as CoreEvent;
    } else {
      event = new CoreEvent(eventIn as CoreEventType);
    }
    log.showInfo('submitEvent:' + event.toString());
    this.processEvent(event);
  }

  /**
   * 执行状态初始化
   */
  public init(): void {
    if (VerifyDataManager.getInstance().hasNoPwd) {
      // OOBE阶段未设置密码则运转至未锁屏态, 非OOBE阶段未设置密码则运转至主页解锁态
      this.submitEvent(sSCBOobeManager.isEnable() ? CoreEventType.UNLOCK_DIRECT : CoreEventType.UNLOCK_SILENCE);
    } else {
      // 其他场景，运转至主页锁屏态
      this.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);
    }
  }
}