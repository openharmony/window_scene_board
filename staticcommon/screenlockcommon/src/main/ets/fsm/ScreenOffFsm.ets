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

const TAG = 'ScreenOffFsm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_ON = 0x1000;
const SCREEN_OFF = 0x2000;

const PRE_BRIGHT = 0x100;

/**
 * 定义：熄屏状态机-状态类型
 */
export enum SoStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 正常熄屏态
   */
  NORMAL_SCREEN_OFF_STATE = SCREEN_OFF,

  /**
   * 预亮屏态
   */
  PRE_BRIGHT_STATE = SCREEN_OFF | PRE_BRIGHT | 0x1,

  /**
   * 预亮屏人脸验证态
   */
  PRE_BRIGHT_FACE_AUTH_STATE = SCREEN_OFF | PRE_BRIGHT | 0x2,

  /**
   * 亮屏态
   */
  SCREEN_ON_STATE = SCREEN_ON,
}

/**
 * 熄屏状态机-状态类型工具类
 */
export class SoStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于预亮屏状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isPreBrightState(stateType: SoStateType): boolean {
    return (stateType & PRE_BRIGHT) === PRE_BRIGHT;
  }

  /**
   * 是否处于预亮屏触发人脸解锁状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isPreBrightTriggerFaceAuth(stateType: SoStateType): boolean {
    return stateType === SoStateType.PRE_BRIGHT_FACE_AUTH_STATE;
  }
}

/**
 * 定义：熄屏状态机-事件类型
 */
export enum SoEventType {
  /**
   * 进入熄屏态（主状态机映射）
   */
  ENTER_SCREEN_OFF_STATE,

  /**
   * 进入亮屏态（主状态机映射）
   */
  ENTER_SCREEN_ON_STATE,

  /**
   * 预亮屏
   */
  PRE_BRIGHT,

  /**
   * 预亮屏失败灭屏
   */
  PRE_BRIGHT_FAIL_SLEEP,

  /**
   * 触发人脸验证
   */
  TRIGGER_FACE_RECOGNITION,

  /**
   * 人脸验证成功
   */
  FACE_VERIFY_SUCCESS,

  /**
   * 人脸验证失败
   */
  FACE_VERIFY_FAIL,
}

/**
 * 熄屏状态机事件
 */
export class SoEvent extends AbstractEvent<SoEventType> {
  public toString(): string {
    return SoEventType[this.eventType] ?? 'Unknown_ScreenOffEvent';
  }
}

/**
 * 抽象熄屏状态
 */
abstract class AbstractSoState extends AbstractState<SoStateType, SoEvent> {
  public toString(): string {
    return SoStateType[this.stateType] ?? 'Unknown_ScreenOffState';
  }
}

/**
 * 抽象熄屏态
 */
class InitState extends AbstractSoState {
  public handleEvent(event: SoEvent): SoStateType | AbstractState<SoStateType, SoEvent> {
    switch (event.eventType) {
      case SoEventType.ENTER_SCREEN_ON_STATE:
        return SoStateType.SCREEN_ON_STATE;
      case SoEventType.ENTER_SCREEN_OFF_STATE:
        return SoStateType.NORMAL_SCREEN_OFF_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 抽象熄屏态
 */
abstract class AbstractNormalSoState extends AbstractSoState {
  public handleEvent(event: SoEvent): SoStateType | AbstractState<SoStateType, SoEvent> {
    switch (event.eventType) {
      case SoEventType.ENTER_SCREEN_ON_STATE:
        return SoStateType.SCREEN_ON_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 正常熄屏态
 */
class NormalScreenOffState extends AbstractNormalSoState {
  public handleEvent(event: SoEvent): SoStateType | AbstractState<SoStateType, SoEvent> {
    switch (event.eventType) {
      case SoEventType.PRE_BRIGHT:
        return SoStateType.PRE_BRIGHT_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 预亮屏态
 */
class PreBrightState extends AbstractNormalSoState {
  public handleEvent(event: SoEvent): SoStateType | AbstractState<SoStateType, SoEvent> {
    switch (event.eventType) {
      case SoEventType.TRIGGER_FACE_RECOGNITION:
        return SoStateType.PRE_BRIGHT_FACE_AUTH_STATE;
      case SoEventType.PRE_BRIGHT_FAIL_SLEEP:
        return SoStateType.NORMAL_SCREEN_OFF_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 预亮屏人脸验证态
 */
class PreBrightFaceAuthState extends AbstractNormalSoState {
  public handleEvent(event: SoEvent): SoStateType | AbstractState<SoStateType, SoEvent> {
    switch (event.eventType) {
      case SoEventType.FACE_VERIFY_FAIL:
        return SoStateType.PRE_BRIGHT_STATE;
      case SoEventType.PRE_BRIGHT_FAIL_SLEEP:
        return SoStateType.NORMAL_SCREEN_OFF_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 亮屏态
 */
class ScreenOnState extends AbstractSoState {
  public handleEvent(event: SoEvent): SoStateType | AbstractState<SoStateType, SoEvent> {
    switch (event.eventType) {
      case SoEventType.ENTER_SCREEN_OFF_STATE:
        return SoStateType.NORMAL_SCREEN_OFF_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 熄屏状态工厂
 */
class AodStateFactory extends AbstractStateFactory<SoStateType, SoEvent> {
  constructor() {
    super();
    this.addSateConstructor(SoStateType.INIT_STATE, (stateType: SoStateType) => {
      return new InitState(stateType);
    });
    this.addSateConstructor(SoStateType.NORMAL_SCREEN_OFF_STATE, (stateType: SoStateType) => {
      return new NormalScreenOffState(stateType);
    });
    this.addSateConstructor(SoStateType.PRE_BRIGHT_STATE, (stateType: SoStateType) => {
      return new PreBrightState(stateType);
    });
    this.addSateConstructor(SoStateType.PRE_BRIGHT_FACE_AUTH_STATE, (stateType: SoStateType) => {
      return new PreBrightFaceAuthState(stateType);
    });
    this.addSateConstructor(SoStateType.SCREEN_ON_STATE, (stateType: SoStateType) => {
      return new ScreenOnState(stateType);
    });
  }
}

/**
 * 定义匹配规则接口
 */
interface ScreenOffMatchRule extends MatchRule<CoreStateType, CoreEvent, SoEventType | undefined> {
  matched: (oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent) => SoEventType | undefined;
}

/**
 * 熄屏状态机匹配规则
 */
const SCREEN_OFF_FSM_MATCH_RULES: ScreenOffMatchRule[] =
  [
    // 进入熄屏态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): SoEventType | undefined => {
        if (!CoreStateTypeUtils.isInScreenOff(oldState) && CoreStateTypeUtils.isInScreenOff(newState)) {
          return SoEventType.ENTER_SCREEN_OFF_STATE;
        }
        return undefined;
      }
    },
    // 退出熄屏态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): SoEventType | undefined => {
        if (CoreStateTypeUtils.isInScreenOff(oldState) && !CoreStateTypeUtils.isInScreenOff(newState)) {
          return SoEventType.ENTER_SCREEN_ON_STATE;
        }
        return undefined;
      }
    },
  ];

/**
 * 定义锁屏的熄屏状态机
 */
export class ScreenOffFsm extends AbstractFsm<SoStateType, SoEvent> {
  constructor(persistentId: number) {
    super(TAG + persistentId, SoStateType.INIT_STATE, new AodStateFactory());
  }

  /**
   * 提交状态机事件
   *
   * @param event 状态机事件
   */
  public submitEvent(eventIn: SoEvent | SoEventType): void {
    let event: SoEvent;
    if (eventIn instanceof SoEvent) {
      event = eventIn as SoEvent;
    } else {
      event = new SoEvent(eventIn as SoEventType);
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
    for (let matchRule of SCREEN_OFF_FSM_MATCH_RULES) {
      let eventType: SoEventType | undefined = matchRule.matched(oldState, newState, event);
      if (eventType !== undefined) {
        this.submitEvent(eventType);
        break;
      }
    }
  }
}