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

import { DomainName, LogDomain, LogHelper, SingletonHelper, TraceUtil } from '@ohos/basicutils';
import { StateFsm, FsmListener } from './StateFsm';
import { SceneBoardCoreStateFsm } from './SceneBoardCoreStateFsm';
import { DesktopStateFsm } from './DesktopStateFsm';
import { CoreEventType, FsmName, StateType } from './SceneBoardStateConfig';

const TAG = 'SceneBoardStateManager';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const INVALID_INDEX = -1;

/**
 * SceneBoard状态管理类
 */
export class SceneBoardStateManager {
  /**
   * 已完成初始化的标志位
   */
  private hasInit: boolean = false;

  /**
   * 注册的状态机数组
   */
  private allFsm: StateFsm[] = [];

  public static getInstance(): SceneBoardStateManager {
    return SingletonHelper.getInstance(SceneBoardStateManager, TAG);
  }

  /**
   * 初始化
   */
  public init(): void {
    if (this.hasInit) {
      log.showInfo(`${TAG} has init`);
      return;
    }
    let coreFsm: StateFsm = new SceneBoardCoreStateFsm();
    coreFsm.init();
    this.allFsm.push(coreFsm);
    let desktopFsm: StateFsm = new DesktopStateFsm();
    desktopFsm.init();
    this.allFsm.push(desktopFsm);
    this.hasInit = true;
    log.showInfo(`${TAG} init finish`);
  }

  /**
   * 分发事件
   *
   * @param event 事件类型
   * @param args 额外参数
   */
  public consumeEvent(event: CoreEventType, ...args: Object[]): void {
    let logStr: string = `consumeEvent ${event}`;
    log.showInfo(logStr + ' start');
    TraceUtil.startTrace(DomainName.SCB, logStr);
    this.allFsm.forEach((item) => {
      item.transfer(event, ...args);
    });
    log.showInfo(logStr + ' end');
    TraceUtil.endTrace(DomainName.SCB, logStr);
  }

  /**
   * 注册状态机
   *
   * @param fsm 状态机
   */
  public registerFsm(fsm: StateFsm): void {
    if (this.getFsm(fsm.name)) {
      log.showWarn(`registerFsm faiiled, ${fsm.name} is already existed`);
      return;
    }
    fsm.init();
    this.allFsm.push(fsm);
    log.showInfo(`${fsm.name} registerFsm success`);
  }

  /**
   * 取消注册状态机，同时也会清空该状态机的所有监听者
   *
   * @param fsm 状态机
   */
  public unRegisterFsm(fsm: StateFsm): void {
    let index: number = this.getFsmIndex(fsm.name);
    if (index === INVALID_INDEX) {
      log.showWarn(`unRegisterFsm faiiled, ${fsm.name} is invalid`);
      return;
    }
    fsm.clearListener();
    this.allFsm.splice(index, 1);
    log.showInfo(`${fsm.name} unRegisterFsm success`);
  }

  private getFsm(name: FsmName): StateFsm | undefined {
    let found: StateFsm | undefined = this.allFsm.find((item) => {
      return item.name === name;
    });
    return found;
  }

  private getFsmIndex(name: FsmName): number {
    let index: number = this.allFsm.findIndex((item) => {
      return item.name === name;
    });
    return index;
  }

  /**
   * 注册状态变更监听器
   *
   * @param name 目标的状态机name
   * @param listener 监听器
   */
  public registerStateChange(name: FsmName, listener: FsmListener): void {
    let fsm: StateFsm | undefined = this.getFsm(name);
    if (!fsm) {
      log.showWarn(`registerStateChange faild, ${name} is invalid`);
      return;
    }
    fsm.registerListener(listener);
  }

  /**
   * 取消注册状态变更监听器
   *
   * @param name 目标的状态机name
   * @param listener 监听器
   */
  public unRegisterStateChange(name: FsmName, listener: FsmListener): void {
    let fsm: StateFsm | undefined = this.getFsm(name);
    if (!fsm) {
      log.showWarn(`unRegisterStateChange faild, ${name} is invalid`);
      return;
    }
    fsm.unRegisterListener(listener);
  }

  /**
   * 获取当前状态
   *
   * @param name 目标的状态机name
   * @returns 目标状态机当前的stateType
   */
  public getCurrentState(name: FsmName): StateType {
    let fsm: StateFsm | undefined = this.getFsm(name);
    if (!fsm) {
      log.showWarn(`getCurrentState faild, ${name} is invalid`);
      return StateType.ERROR;
    }
    let stateType: StateType = fsm.currentState.stateType;
    log.showInfo(`getCurrentState is ${stateType} from ${name}`);
    return stateType;
  }
}