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
import { LimitMap, SlStateBaseMgr, SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex'
import { PointCheckParam } from '../../../common/constants/ImmComConst';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveMeshVm } from '../../../common/interface/IImmersiveMeshVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveVmInjector } from '../../../common/interface/IImmersiveVmInjector';
import { ImmCapLiveVmInjector } from '../injector/ImmCapLiveVmInjector';
import { ImmCardLiveVmInjector } from '../injector/ImmCardLiveVmInjector';
import { ImmersiveLiveVmInjector } from '../injector/ImmersiveLiveVmInjector';
import { ImmersiveNtfVmInjector } from '../injector/ImmersiveNtfVmInjector';
import { ImmCardOuterLiveVmInjector } from '../injector/outer/ImmCardOuterLiveVmInjector';
import { ImmOuterNtfVmInjector } from '../injector/outer/ImmOuterNtfVmInjector';

const TAG = 'ImmersiveV2Helper';

// 个数限制
const LIMIT_MAX = 10;

/**
 * 注入器类型
 */
enum Injector {
  NTF_INJECTOR = 'immersive_ntf_injector', // 通知通用注入器
  LIVE_INJECTOR = 'immersive_live_injector', // 实况通知注入器
  CAP_LIVE_INJECTOR = 'immersive_cap_live_injector', // 实况通知胶囊上使用时注入器
  CARD_LIVE_INJECTOR = 'immersive_card_live_injector', // 实况通知大卡上使用时注入器
}

// V2辅助工具抽象层
interface IImmV2Helper {
  getNtfInjector(mgrName?: SlStateMgr): IImmersiveNtfVmInjector | undefined;

  getLiveInjector(mgrName?: SlStateMgr): IImmersiveLiveVmInjector | undefined;
}

// 沉浸锁屏模块对外接口
export interface IImmV2Hook {
  /**
   * 返回手势回调
   *
   * @param stateMgr 类型区分(小外屏)
   */
  onBackGestureEvent(stateMgr: SlStateMgr): void;

  /**
   * 检测热区匹配
   *
   * @param param 坐标参数
   * @returns true热区匹配
   */
  checkMatchHotZones(param: PointCheckParam): boolean;

  /**
   * 检测精确位置匹配
   *
   * @param param 坐标参数
   * @returns true位置匹配
   */
  checkMatchExactArea(param: PointCheckParam): boolean;

  /**
   * 触发锁屏时钟收起展开
   *
   * @param isNeedCollapse 时钟是否需要收起
   */
  screenLockClockShift(isNeedToCollapse: boolean): void;

  /**
   * 请求刷新栅格范围
   */
  requestUpdateMeshRange(): void;

  /**
   * 取值列表底部间距
   *
   * @returns 列表底部间距
   */
  getListBottomPadding(): number;

  /**
   * 刷新列表是否最大高度状态，非动效中调用，自带动效变形
   *
   * @param isReachMax true列表最大高度
   */
  updateListReachMax(isReachMax: boolean): void;

  /**
   * 请求隐藏设置弹框
   */
  requestHideSettingDialog(): void;
}

// 沉浸锁屏模块对外转接
export class ImmV2Hook implements IImmV2Hook {
  private readonly _v2Helper: IImmV2Helper;

  constructor(helper: IImmV2Helper) {
    this._v2Helper = helper;
  }

  public onBackGestureEvent(stateMgr: SlStateMgr): void {
    // 按需分发返回事件
    let gestureArr = this._v2Helper?.getNtfInjector(stateMgr)?.getImmGestureVmList();
    gestureArr?.find((gestureVm) => Boolean(gestureVm?.onBackGestureEvent?.()));
  }

  public checkMatchHotZones(param: PointCheckParam): boolean {
    // 按需匹配热区
    let gestureArr = this._v2Helper?.getNtfInjector(param.slStMgr)?.getImmGestureVmList();
    let length = gestureArr?.length ?? 0;
    for (let i = 0; i < length; i++) {
      // 有一个匹配，则按匹配处理
      let result = gestureArr?.[i]?.checkMatchHotZones?.(param.globalX, param.globalY);
      if (result) {
        return true;
      }
    }
    return false;
  }

  public checkMatchExactArea(param: PointCheckParam): boolean {
    // 按需匹配位置
    let gestureArr = this._v2Helper?.getNtfInjector(param.slStMgr)?.getImmGestureVmList();
    let length = gestureArr?.length ?? 0;
    for (let i = 0; i < length; i++) {
      // 有一个匹配，则按匹配处理
      let result = gestureArr?.[i]?.checkMatchExactArea?.(param.globalX, param.globalY);
      if (result) {
        return true;
      }
    }
    return false;
  }

  public screenLockClockShift(isNeedToCollapse: boolean): void {
    this.getMeshVm()?.screenLockClockShift(isNeedToCollapse);
  }

  public requestUpdateMeshRange(): void {
    this.getMeshVm()?.requestUpdateMeshRange();
  }

  public getListBottomPadding(): number {
    return this.getMeshVm()?.getListBottomPadding() ?? 0;
  }

  public updateListReachMax(isReachMax: boolean): void {
    this.getMeshVm()?.updateListReachMax(isReachMax);
  }

  public requestHideSettingDialog(): void {
    // 关闭弹框
    this._v2Helper?.getNtfInjector()?.getSettingDiagVm()?.onBackGestureEvent?.();
  }

  private getMeshVm(): IImmersiveMeshVm | undefined {
    return this._v2Helper?.getNtfInjector()?.getImmersiveMeshVm();
  }
}

/**
 * 沉浸V2样式辅助工具
 */
class ImmersiveV2Helper implements IImmV2Helper {
  // 业务注入器集
  private readonly vmInjector: LimitMap<string, IImmersiveVmInjector> = new LimitMap(TAG, LIMIT_MAX);
  // 对外接口
  private readonly v2Hook: IImmV2Hook;
  // 默认通知通用业务注入器
  public readonly defaultNtfInjector: ImmersiveNtfVmInjector = new ImmersiveNtfVmInjector(SlStateMgr.MGR_COMMON);
  // 默认实况通知业务注入器
  public readonly defaultLiveInjector: ImmersiveLiveVmInjector = new ImmersiveLiveVmInjector(SlStateMgr.MGR_COMMON);

  constructor() {
    this.v2Hook = new ImmV2Hook(this);
  }

  /**
   * 对外接口
   *
   * @returns 对外接口
   */
  public getV2Hook(): IImmV2Hook {
    return this.v2Hook;
  }

  /**
   * 通知通用业务注入器
   *
   * @param mgrName 状态管理器名
   * @returns 业务注入器
   */
  public getNtfInjector(mgrName: SlStateMgr = SlStateMgr.MGR_COMMON): ImmersiveNtfVmInjector | undefined {
    // 开关控制
    if (!SlStateBaseMgr.isV2Enable()) {
      return undefined;
    }
    let key = this.getKey(mgrName, Injector.NTF_INJECTOR);
    let injector = this.vmInjector.get(key);
    if (!injector) {
      let isOuter = mgrName === SlStateMgr.MGR_OUTER_SCREEN;
      let ntfInjector = isOuter ? new ImmOuterNtfVmInjector(mgrName) : new ImmersiveNtfVmInjector(mgrName);
      // 加入实况注入器
      this.pushLiveInject(ntfInjector);
      injector = ntfInjector;
      this.vmInjector.set(key, injector);
    }
    return injector as ImmersiveNtfVmInjector;
  }

  /**
   * 实况通知业务注入器
   *
   * @param mgrName 状态管理器名
   * @returns 业务注入器
   */
  public getLiveInjector(mgrName: SlStateMgr = SlStateMgr.MGR_COMMON): ImmersiveLiveVmInjector | undefined {
    // 开关控制
    if (!SlStateBaseMgr.isV2Enable()) {
      return undefined;
    }
    let key = this.getKey(mgrName, Injector.LIVE_INJECTOR);
    let injector = this.vmInjector.get(key);
    if (!injector) {
      injector = new ImmersiveLiveVmInjector(mgrName);
      this.vmInjector.set(key, injector);
    }
    return injector as ImmersiveLiveVmInjector;
  }

  /**
   * 实况通知在胶囊使用时业务注入器
   *
   * @param mgrName 状态管理器名
   * @returns 业务注入器
   */
  public getCapLiveInjector(mgrName: SlStateMgr = SlStateMgr.MGR_COMMON): ImmCapLiveVmInjector | undefined {
    // 开关控制
    if (!SlStateBaseMgr.isV2Enable()) {
      return undefined;
    }
    let key = this.getKey(mgrName, Injector.CAP_LIVE_INJECTOR);
    let injector = this.vmInjector.get(key);
    if (!injector) {
      injector = new ImmCapLiveVmInjector(mgrName);
      this.vmInjector.set(key, injector);
    }
    return injector as ImmCapLiveVmInjector;
  }

  /**
   * 实况通知在大卡使用时业务注入器
   *
   * @param mgrName 状态管理器名
   * @returns 业务注入器
   */
  public getCardLiveInjector(mgrName: SlStateMgr = SlStateMgr.MGR_COMMON): ImmCardLiveVmInjector | undefined {
    // 开关控制
    if (!SlStateBaseMgr.isV2Enable()) {
      return undefined;
    }
    let key = this.getKey(mgrName, Injector.CARD_LIVE_INJECTOR);
    let injector = this.vmInjector.get(key);
    if (!injector) {
      let isOuter = mgrName === SlStateMgr.MGR_OUTER_SCREEN;
      injector = isOuter ? new ImmCardOuterLiveVmInjector(mgrName) : new ImmCardLiveVmInjector(mgrName);
      this.vmInjector.set(key, injector);
    }
    return injector as ImmCardLiveVmInjector;
  }

  private getKey(mgrName: SlStateMgr, injector: Injector): string {
    return `${mgrName}_${injector}`;
  }

  // 通用注入器构建时，加入实况注入器
  private pushLiveInject(comInject: ImmersiveNtfVmInjector): void {
    if (!comInject) {
      return;
    }
    let config = comInject.getImmStyleConfigHelper()?.getImmConfig();
    let vmArr = comInject.getImmLiveVmInjectorList();
    let stateMgrName = comInject.getStateMgr();
    if (config?.isListEnable()) {
      // 同步加入通用注入器
      let liveInjector = this.getLiveInjector(stateMgrName);
      liveInjector?.setNtfVmInjector(comInject);
      this.pushArr(vmArr, liveInjector);
    }
    if (config?.isCapEnable()) {
      let capInjector = this.getCapLiveInjector(stateMgrName);
      capInjector?.setNtfVmInjector(comInject);
      this.pushArr(vmArr, capInjector);
    }
    if (config?.isCardEnable()) {
      let cardInjector = this.getCardLiveInjector(stateMgrName);
      cardInjector?.setNtfVmInjector(comInject);
      this.pushArr(vmArr, cardInjector);
    }
  }

  /**
   * 列表添加数据
   *
   * @param arr 列表 item 数据
   */
  private pushArr<T>(arr: Array<T>, item?: T) : void {
    if (item) {
      arr?.push(item);
    }
  }
}

// 单例
export const v2Helper: ImmersiveV2Helper = new ImmersiveV2Helper();