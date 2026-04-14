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

import { IBaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { LimitSet, WidgetAnimStateV2, WidgetCacheState, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ImmersiveState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { IImmComVm } from '../../../common/interface/IImmComVm';
import { IImmCurDataCtrlVm } from '../../../common/interface/IImmCurDataCtrlVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { ImmComVmStyleMgr } from '../mgr/ImmComVmStyleMgr';
import { ImmersiveNtfBaseVm } from './ImmersiveNtfBaseVm';

/**
 * 沉浸模块通用业务管理器
 */
export class ImmComVm extends ImmersiveNtfBaseVm implements IImmComVm {
  /**
   * 单实例
   */
  private static immComVm?: ImmComVm;

  /**
   * 当前沉浸态数据控制器
   */
  private readonly curDataCtrls: LimitSet<IImmCurDataCtrlVm> = new LimitSet();

  /**
   * 沉浸通用样式统一管理
   */
  private readonly immStyleMgr: ImmComVmStyleMgr;

  /**
   * 是否已初始化
   */
  private hasInit: boolean = false;

  /**
   * 当前沉浸态数据标识
   */
  private curImmGroupKey?: string;

  /**
   * 单实例获取
   *
   * @param vmInjector 注入器
   * @returns 单实例
   */
  public static getInstance(vmInjector: IImmersiveNtfVmInjector): ImmComVm {
    if (!ImmComVm.immComVm) {
      ImmComVm.immComVm = new ImmComVm(vmInjector);
    }
    return ImmComVm.immComVm;
  }

  private constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.immStyleMgr = new ImmComVmStyleMgr(this.vmInjector);
  }

  /**
   * 设置默认状态
   */
  public setDefaultImmState(): void {
    this.immStyleMgr.setDefaultImmState();
  }

  /**
   * 是否显示胶囊
   * @returns boolean
   */
  public isShowCapsule(): boolean {
    return this.getImmState().isShowCapsule();
  }

  /**
   * 是否显示列表
   * @returns boolean
   */
  public isShowList(): boolean {
    return this.getImmState().isShowList();
  }

  /**
   * 是否显示大卡
   * @returns boolean
   */
  public isShowCard(): boolean {
    return this.getImmState().isShowCard();
  }

  /**
   * 获取沉浸显示状态
   *
   * @returns 沉浸显示状态
   */
  public getImmState(): ImmersiveState {
    return this.immStyleMgr.getImmState();
  }

  /**
   * 获取沉浸前状态
   *
   * @returns 沉浸前显示状态
   */
  public getBeforeImmState(): ImmersiveState {
    return this.immStyleMgr.getBeforeImmState();
  }

  /**
   * AOD状态
   *
   * @returns true AOD
   */
  public isAod(): boolean {
    return this.immStyleMgr.isAOD();
  }

  /**
   * 刷新锁定状态
   */
  public refreshLockVerify(): void {
    this.immStyleMgr.refreshLockVerify();
  }

  /**
   * 当前沉浸态标识
   *
   * @param groupKey 分组标识
   */
  public setCurImmData(groupKey?: string): void {
    this.curImmGroupKey = groupKey;
    this.curDataCtrls.forEach((ctrl) => ctrl?.setCurImmCardData(groupKey));
  }

  /**
   * 注册控制器
   *
   * @param ctrl 控制器
   */
  public registerImmCurDataCtrl(ctrl: IImmCurDataCtrlVm): void {
    if (ctrl) {
      this.curDataCtrls.add(ctrl);
    }
  }

  /**
   * 注销控制器
   *
   * @param ctrl 控制器
   */
  public unregisterImmCurDataCtrl(ctrl: IImmCurDataCtrlVm): void {
    this.curDataCtrls.delete(ctrl);
  }

  /**
   * 主动请求当前沉浸态数据
   *
   * @param ctrl 控制器
   */
  public requestImmCurData(ctrl: IImmCurDataCtrlVm): void {
    // 当存在数据时，主动回调一次
    if (this.curImmGroupKey) {
      ctrl?.setCurImmCardData(this.curImmGroupKey);
    }
  }

  getSlStaticState(): IBaseState {
    return this.stateHelper?.getImmStaticState();
  }

  getSlBindState(): IBaseState {
    return this.stateHelper?.getImmBindState();
  }

  getSlAnimState(): WidgetAnimStateV2 {
    return this.stateHelper?.getImmAnimState();
  }

  getSlStyleState(): WidgetStyleStateV2 {
    return this.stateHelper?.getImmStyleState();
  }

  getSlCacheState(): WidgetCacheState {
    return this.stateHelper?.getImmCacheState();
  }

  init(): void {
    if (this.hasInit) {
      return;
    }
    this.hasInit = true;
    this.immStyleMgr.init();
  }

  destroy(): void {
    if (!this.hasInit) {
      return;
    }
    this.hasInit = false;
    this.immStyleMgr.destroy();
  }
}