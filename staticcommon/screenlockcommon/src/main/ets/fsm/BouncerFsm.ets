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
import { AbstractEvent, AbstractFsm, AbstractState, AbstractStateFactory } from './ScreenLockFsm';
import type { MatchRule } from './ScreenLockFsm';
import { CoreEvent, CoreStateType, CoreStateTypeUtils } from './ScreenLockCoreFsm';

const TAG = 'BouncerFsm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_OFF_PAGE = 0x1000; // 熄屏页
const MAIN_PAGE = 0x2000; // 主页
const BOUNCER_PAGE = 0x4000; // 密码页
const UNLOCK_PAGE = 0x8000; // 非锁屏页

const PWD_LOCKED = 0x100; // 密码锁定
const SIM_LOCKED = 0x200; // SIM卡锁定

/**
 * 定义：密码页状态机-状态类型
 */
export enum BouncerStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 熄屏态
   */
  SCREEN_OFF_STATE = SCREEN_OFF_PAGE,

  /**
   * 主页态
   */
  MAIN_PAGE_STATE = MAIN_PAGE,

  /**
   * 密码校验态
   */
  PWD_CHECK_STATE = BOUNCER_PAGE | PWD_LOCKED,

  /**
   * 高指纹校验态
   */
  HIGH_FINGERPRINT_CHECK_STATE = BOUNCER_PAGE | PWD_LOCKED | 0x1,

  /**
   * SIM卡校验态
   */
  SIM_CHECK_STATE = BOUNCER_PAGE | SIM_LOCKED,

  /**
   * 非锁屏态
   */
  UNLOCK_STATE = UNLOCK_PAGE,
}

/**
 * 密码页状态类型工具类
 */
export class BouncerStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于首页状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInMainPageState(stateType: BouncerStateType): boolean {
    return stateType === MAIN_PAGE;
  }

  /**
   * 是否处于密码页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInBouncerState(stateType: BouncerStateType): boolean {
    return (stateType & BOUNCER_PAGE) === BOUNCER_PAGE;
  }

  /**
   * 是否处于密码验证状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInPwdLockState(stateType: BouncerStateType): boolean {
    return (stateType & PWD_LOCKED) === PWD_LOCKED;
  }

  /**
   * 是否处于SIM锁定状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInSimLockState(stateType: BouncerStateType): boolean {
    return (stateType & SIM_LOCKED) === SIM_LOCKED;
  }

  /**
   * 是否处于SIM锁定状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInUnLockState(stateType: BouncerStateType): boolean {
    return stateType === UNLOCK_PAGE;
  }
}

/**
 * 定义：密码页状态机-事件类型
 */
export enum BouncerEventType {
  /**
   * 进入熄屏态（由主状态机映射）
   */
  ENTER_SCREEN_OFF,

  /**
   * 进入主页态（由主状态机映射）
   */
  ENTER_MAIN_PAGE,

  /**
   * 进入未锁屏态（由主状态机映射）
   */
  ENTER_UNLOCK,

  /**
   * 进入SIM卡校验（由主状态机映射）
   */
  ENTER_SIM_CHECK,

  /**
   * 进入密码校验（由主状态机映射）
   */
  ENTER_PWD_CHECK,

  /**
   * 进入高指纹校验，包含（1、从密码页进入高指纹校验页）
   */
  ENTER_HIGH_FINGERPRINT_CHECK,

  /**
   * 取消高指纹校验，包含（1、高指纹校验页返回）
   */
  CANCEL_HIGH_FINGERPRINT_CHECK,
}

/**
 * 密码页状态机事件
 */
export class BouncerEvent extends AbstractEvent<BouncerEventType> {
  public toString(): string {
    return BouncerEventType[this.eventType] ?? 'Unknown_BouncerEvent';
  }
}

/**
 * 抽象密码页状态
 */
abstract class AbstractBouncerState extends AbstractState<BouncerStateType, BouncerEvent> {
  public toString(): string {
    return BouncerStateType[this.stateType] ?? 'Unknown_BouncerState';
  }
}

/**
 * 主状态映射态
 */
abstract class CoreMappingState extends AbstractBouncerState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    switch (event.eventType) {
      case BouncerEventType.ENTER_SCREEN_OFF:
        return BouncerStateType.SCREEN_OFF_STATE;
      case BouncerEventType.ENTER_MAIN_PAGE:
        return BouncerStateType.MAIN_PAGE_STATE;
      case BouncerEventType.ENTER_PWD_CHECK:
        return BouncerStateType.PWD_CHECK_STATE;
      case BouncerEventType.ENTER_SIM_CHECK:
        return BouncerStateType.SIM_CHECK_STATE;
      case BouncerEventType.ENTER_UNLOCK:
        return BouncerStateType.UNLOCK_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 初始态
 */
class InitState extends CoreMappingState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 熄屏态
 */
class ScreenOffState extends CoreMappingState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 主页态
 */
class MainPageState extends CoreMappingState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 密码校验态
 */
class PwdCheckState extends CoreMappingState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    switch (event.eventType) {
      case BouncerEventType.ENTER_HIGH_FINGERPRINT_CHECK:
        return BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 高指纹校验态
 */
class HighFingerPrintCheckState extends CoreMappingState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    switch (event.eventType) {
      case BouncerEventType.ENTER_PWD_CHECK:
        return this.stateType; // 密码校验态子状态，不处理跳转
      case BouncerEventType.CANCEL_HIGH_FINGERPRINT_CHECK:
        return BouncerStateType.PWD_CHECK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * SIM卡校验态
 */
class SimCheckState extends CoreMappingState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 非锁屏态
 */
class UnlockState extends CoreMappingState {
  public handleEvent(event: BouncerEvent): BouncerStateType | AbstractState<BouncerStateType, BouncerEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 密码页状态工厂
 */
class BouncerStateFactory extends AbstractStateFactory<BouncerStateType, BouncerEvent> {
  constructor() {
    super();
    this.addSateConstructor(BouncerStateType.INIT_STATE, (stateType: BouncerStateType) => new InitState(stateType));
    this.addSateConstructor(BouncerStateType.SCREEN_OFF_STATE,
      (stateType: BouncerStateType) => new ScreenOffState(stateType));
    this.addSateConstructor(BouncerStateType.MAIN_PAGE_STATE,
      (stateType: BouncerStateType) => new MainPageState(stateType));
    this.addSateConstructor(BouncerStateType.PWD_CHECK_STATE,
      (stateType: BouncerStateType) => new PwdCheckState(stateType));
    this.addSateConstructor(BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE,
      (stateType: BouncerStateType) => new HighFingerPrintCheckState(stateType));
    this.addSateConstructor(BouncerStateType.SIM_CHECK_STATE,
      (stateType: BouncerStateType) => new SimCheckState(stateType));
    this.addSateConstructor(BouncerStateType.UNLOCK_STATE, (stateType: BouncerStateType) => new UnlockState(stateType));
  }
}

/**
 * 定义匹配规则接口
 */
interface BouncerMatchRule extends MatchRule<CoreStateType, CoreEvent, BouncerEventType | undefined> {
  matched: (oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent) => BouncerEventType | undefined;
}

/**
 * 密码页状态机匹配规则
 */
const BOUNCER_FSM_MATCH_RULES: BouncerMatchRule[] =
  [
    // 进入熄屏态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): BouncerEventType | undefined => {
        if (!CoreStateTypeUtils.isInScreenOff(oldState) && CoreStateTypeUtils.isInScreenOff(newState)) {
          return BouncerEventType.ENTER_SCREEN_OFF;
        }
        return undefined;
      }
    },
    // 进入主页态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): BouncerEventType | undefined => {
        if (!CoreStateTypeUtils.isInMainPage(oldState) && CoreStateTypeUtils.isInMainPage(newState)) {
          return BouncerEventType.ENTER_MAIN_PAGE;
        }
        return undefined;
      }
    },
    // 进入密码页密码校验态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): BouncerEventType | undefined => {
        if (!(CoreStateTypeUtils.isInBouncePage(oldState) && CoreStateTypeUtils.isPwdLockState(oldState)) &&
          (CoreStateTypeUtils.isInBouncePage(newState) && CoreStateTypeUtils.isPwdLockState(newState))) {
          return BouncerEventType.ENTER_PWD_CHECK;
        }
        return undefined;
      }
    },
    // 进入密码页SIM卡校验态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): BouncerEventType | undefined => {
        if (oldState !== CoreStateType.BOUNCER_SIM_CHECK_STATE && newState === CoreStateType.BOUNCER_SIM_CHECK_STATE) {
          return BouncerEventType.ENTER_SIM_CHECK;
        }
        return undefined;
      }
    },
    // 进入非锁屏态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): BouncerEventType | undefined => {
        if (oldState !== CoreStateType.UNLOCK_STATE && newState === CoreStateType.UNLOCK_STATE) {
          return BouncerEventType.ENTER_UNLOCK;
        }
        return undefined;
      }
    },
  ];

/**
 * 定义锁屏的密码页状态机
 */
export class BouncerFsm extends AbstractFsm<BouncerStateType, BouncerEvent> {
  constructor(persistentId: number) {
    super(TAG + persistentId, BouncerStateType.INIT_STATE, new BouncerStateFactory());
  }

  /**
   * 提交核心状态机事件
   *
   * @param event 状态机事件
   */
  public submitEvent(eventIn: BouncerEvent | BouncerEventType): void {
    let event: BouncerEvent;
    if (eventIn instanceof BouncerEvent) {
      event = eventIn as BouncerEvent;
    } else {
      event = new BouncerEvent(eventIn as BouncerEventType);
    }
    log.showInfo('submitEvent:' + event.toString());
    this.processEvent(event);
  }

  /**
   * 映射主状态机状态变更
   *
   * @param oldState 主状态机原状态
   * @param newState 主状态机新状态
   * @param event 主状态机事件
   */
  public matchCoreFsmChange(oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent): void {
    for (let matchRule of BOUNCER_FSM_MATCH_RULES) {
      let eventType: BouncerEventType | undefined = matchRule.matched(oldState, newState, event);
      if (eventType !== undefined) {
        this.submitEvent(eventType);
        break;
      }
    }
  }
}