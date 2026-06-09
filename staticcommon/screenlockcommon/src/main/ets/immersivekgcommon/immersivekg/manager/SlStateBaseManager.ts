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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { StateType } from '../../base/constants/BaseType';
import { IBaseState } from '../../base/interface/IBaseState';
import { BaseStateManager } from '../../base/manager/BaseStateManager';
import { LimitMap } from '../../base/utils/LimitMap';
import { SlStateId, SlStateMgr } from '../constants/SlStateConst';

const TAG = 'SlStateBaseMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_SIZE = 100; // 集合限制

/**
 * 锁屏状态管理基类
 */
export class SlStateBaseMgr extends BaseStateManager {
  /**
   * 锁屏状态管理器集
   */
  private static slMgr: LimitMap<SlStateMgr, SlStateBaseMgr> = new LimitMap(TAG, MAX_SIZE);

  /**
   * V2状态管理是否开启，默认不开启
   */
  private static _isV2StateEnable: boolean = false;

  /**
   * 隐藏构造
   *
   * @param mgrName 管理器名称
   */
  protected constructor(mgrName: SlStateMgr) {
    super(mgrName);
  }

  /**
   * 获取共享状态，限制锁屏状态类型
   *
   * @param stateType 状态类型
   * @param stateId 状态唯一标示
   * @returns 状态
   */
  public getState(stateType: StateType, stateId: SlStateId): IBaseState | undefined {
    return super.getState(stateType, stateId);
  }

  /**
   * 删除共享状态，限制锁屏状态类型
   *
   * @param stateType 状态类型
   * @param stateId 状态唯一标示
   * @returns true删除成功
   */
  public deleteStateById(stateType: StateType, stateId: SlStateId): boolean {
    return super.deleteStateById(stateType, stateId);
  }

  /**
   * V2状态是否开启
   *
   * @returns true开启
   */
  public static isV2Enable(): boolean {
    return SlStateBaseMgr._isV2StateEnable;
  }

  /**
   * 设置V2状态是否开启
   *
   * @param isEnable true开启V2状态
   */
  public static setV2Enable(isEnable: boolean): void {
    SlStateBaseMgr._isV2StateEnable = isEnable;
  }

  /**
   * 获取映射状态管理器
   *
   * @param name 管理器名称
   * @returns 管理器
   */
  public static getMgr(name: SlStateMgr): SlStateBaseMgr | undefined {
    return SlStateBaseMgr.slMgr.get(name);
  }

  /**
   * 缓存状态管理器
   *
   * @param name 管理器名称
   * @param mgr 管理器
   */
  protected static setMgr(name: SlStateMgr, mgr: SlStateBaseMgr): void {
    if (mgr) {
      SlStateBaseMgr.slMgr.set(name, mgr);
    } else {
      log.showWarn(`setMgr invalid mgr: ${name}`);
    }
  }
}