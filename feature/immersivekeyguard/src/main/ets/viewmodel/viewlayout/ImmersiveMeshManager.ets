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

import { HashMap } from '@kit.ArkTS';
import { CommonUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  ClockBindStateType,
  ListStaticStateType,
  MeshConfig,
  MeshRange,
  NotificationStateManager
} from '@ohos/screenlockcommon';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import {
  immersiveKgMgr, ImmersiveState,
  IState,
  OnStateChangeListener,
  StateType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { KeyguardConstants } from '../../common/ImmersiveConstants';
import { ImmersivePanelState } from '../viewdata/ImmersivePanelState';
import { NtfListBindState, NtfListStaticState } from '../viewdata/NtfListState';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { SlMainStateType,
  SlStaticStateType,
  SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ImmersiveListAnimManager } from '../viewanim/ImmersiveListAnimManager';
import { IImmersiveMeshVm } from '../../common/interface/IImmersiveMeshVm';
import { IImmersiveNtfVmInjector } from '../../common/interface/IImmersiveNtfVmInjector';
import { SlListStaticStateV2 } from '../../model/data/v2/SlListStaticStateV2';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { IImmersiveListAnimVm } from '../../common/interface/IImmersiveListAnimVm';

// 通知列表对齐高度临界值：最高条目高度与最低条目高度差值
const HEIGHT_DIFF = 38;

// 艺术签名布局值基础值
const ART_SING_CLOCK_LAYOUT_BASE: number = 200;

/**
 * 沉浸网格状态管理
 */
export class ImmersiveMeshManager implements IImmersiveMeshVm {
  /**
   * 单例
   */
  private static instance: ImmersiveMeshManager;
  /**
   * 通知高度, key为通知的key, value为对应的高度值
   */
  private itemHeight: HashMap<string, number> = new HashMap();

  /**
   * 通知条目总个数
   */
  private itemSizeSum: number = 0;

  /**
   * 卡片高度
   */
  private cardHeight: number = 0;

  /**
   * 沉浸状态
   */
  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  /**
   * 列表网格范围
   */
  private listMeshRange: MeshRange = new MeshRange(this.getMeshEnd(), this.getMeshEnd());

  /**
   * 卡片网格范围
   */
  private cardMeshRange: MeshRange = new MeshRange(this.getMeshEnd(), this.getMeshEnd());

  /**
   * 请求网格范围
   */
  private reqMeshRange: MeshRange = new MeshRange(this.getMeshEnd(), this.getMeshEnd());

  /**
   * 面板状态
   */
  private panelState: ImmersivePanelState = new ImmersivePanelState();

  /**
   * 锁屏通知列表UI绑定状态
   */
  private listBindState: NtfListBindState = new NtfListBindState();

  /**
   * 锁屏通知列表非UI绑定状态
   */
  private listStaticState: NtfListStaticState = new NtfListStaticState();

  /**
   * 列表业务注入器
   */
  private vmInjector?: IImmersiveNtfVmInjector;

  /**
   * 列表动效管理
   */
  private listAnimMgr?: ImmersiveListAnimManager;

  /**
   * 是否达到最大高度
   */
  private isReachMax: boolean = false;

  /**
   * 条目总高度
   */
  private itemHeightSum: number = 0;

  /**
   * 是否条目高度变化
   */
  private isItemHeightChanging: boolean = false;

  /**
   * 是否注册锁屏网格配置变化
   */
  private readonly isRegisterMeshConfig: boolean = DeviceHelper.isFoldButNotSmallFoldProduct() || DeviceHelper.isPad();

  /**
   * 时钟展开态网格y值
   */
  private clockExpandMeshY: number = KeyguardConstants.DEFAULT_CLOCK_LAYOUT_AMOUNT_Y;

  /**
   * 沉浸状态切换监听
   */
  private onStateChange: OnStateChangeListener = {
    /**
     * 沉浸状态回调
     */
    onStateChange: (state: IState): void => {
      switch (state.getStateType()) {
        case StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE:
          this.onImmersiveStateChange();
          break;
        default:
          break;
      }
    }
  };

  /**
   * 网格配置变化回调
   */
  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.MESH_CONFIG && this.isRegisterMeshConfig) {
        this.onMeshConfigChange();
      } else if (subType === SlStaticStateType.CLOCK_EXPAND_MESH_Y) {
        this.onClockExpandMeshYChange();
      }
    }
  };

  /**
   * 构造函数
   */
  private constructor() {
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
  }

  /**
   * 获取单例
   */
  public static getInstance(): ImmersiveMeshManager {
    if(!ImmersiveMeshManager.instance) {
      ImmersiveMeshManager.instance = new ImmersiveMeshManager();
    }
    return ImmersiveMeshManager.instance;
  }

  /**
   * 初始化
   */
  init(): void {
    let meshY = this.getClockExpandMeshY() as number;
    if (!CommonUtils.isInvalid(meshY)) {
      this.clockExpandMeshY = meshY;
    }
    if (this.isRegisterMeshConfig) {
      this.onMeshConfigChange();
    }
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
  }

  /**
   * 释放vm资源
   */
  destroy(): void {
    slUiStateMgr.unregisterSlStateChangeListener(this.slStaticStateListener);
    // 组件下树时，恢复通知列表高度为0
    immersiveStateHelper.getSlListStaticState()?.setSlState(ListStaticStateType.NTF_LIST_ITEM_HEIGHT_SUM, 0);
  }

  /**
   * 面板状态
   *
   * @param state 面板状态
   */
  setPanelState(state: ImmersivePanelState): void {
    this.panelState = state;
  }

  /**
   * 初始化列表状态
   *
   * @param listBindState UI状态
   * @param listStaticState 非UI状态
   */
  setListState(listBindState: NtfListBindState, listStaticState:NtfListStaticState) {
    this.listBindState = listBindState;
    this.listStaticState = listStaticState;
  }

  /**
   * 设置业务注入器
   *
   * @param injector 注入器
   */
  setVmInjector(injector: IImmersiveNtfVmInjector): void {
    if (!this.vmInjector) { // 初始化一次即可
      this.vmInjector = injector;
    }
  }

  /**
   * 设置列表动效管理器
   *
   * @param listAnimMgr 列表动效管理器
   */
  setListAnimMgr(listAnimMgr?: ImmersiveListAnimManager): void {
    this.listAnimMgr = listAnimMgr;
  }

  /**
   * 列表通知key值变化时, 通知新增、删除等
   *
   * @param itemKeys 列表通知key值
   */
  onListItemKeysChange(itemKeys: Map<string, number>): void {
    if (CommonUtils.isInvalid(itemKeys)) {
      return;
    }
    let heightSum: number = 0;
    let isErrorHeight: boolean = false;
    if (itemKeys.size === 0) {
      this.itemHeight.clear();
    } else {
      let newItemHeight = new HashMap<string, number>();
      itemKeys.forEach((value: number, key: string) => {
        let height: number = this.itemHeight.get(key) ?? 0;
        if (height === 0) { // 异常高度
          isErrorHeight = true;
        }
        heightSum += height;
        newItemHeight.set(key, height);
      });
      let itemSpace: number = 0;
      // V2样式
      if (this.vmInjector) {
        itemSpace = this.getListStatic()?.getItemSpace();
      } else {
        itemSpace = this.listStaticState.itemSpace;
      }
      heightSum += (itemKeys.size - 1) * itemSpace;
      this.itemHeight = newItemHeight;
    }
    if (!isErrorHeight) { // 存在异常高度时，仅刷新缓存值，待高度变化时刷新
      this.updateItemHeightSum(heightSum, false, itemKeys.size);
    } else {
      this.updateCacheValue(heightSum, itemKeys.size);
    }
  }

  /**
   * 通知单条目大小变化
   *
   * @param key 通知key值
   * @param oldSize 旧大小
   * @param newSize 新大小
   */
  onListItemSizeChange(key: string, oldSize: SizeOptions, newSize: SizeOptions): void {
    if (oldSize?.height === newSize?.height) {
      return;
    }
    let oldHeight = this.itemHeight.get(key) ?? 0;
    let newHeight = newSize.height as number;
    if (oldHeight != newHeight) {
      this.itemHeight.set(key, newHeight);
      let sumHeight = this.itemHeightSum + newHeight - oldHeight;
      this.isItemHeightChanging = true;
      this.updateItemHeightSum(sumHeight, false, this.itemSizeSum);
    }
  }

  /**
   * 卡片大小变化
   *
   * @param oldSize 旧大小
   * @param newSize 新大小
   */
  onCardSizeChange(oldSize: SizeOptions, newSize: SizeOptions) {
    if (oldSize?.height === newSize?.height) {
      return;
    }
    let newHeight = newSize.height as number;
    if (CommonUtils.isInvalid(newHeight) || newHeight === this.cardHeight) {
      return;
    }
    this.cardHeight = newHeight;
    this.updateCardMeshRange();
  }

  /**
   * 请求刷新栅格范围
   */
  requestUpdateMeshRange(): void {
    this.onMeshConfigChange();
    this.onImmersiveStateChange();
  }

  /**
   * 取值列表底部间距
   *
   * @returns 列表底部间距
   */
  getListBottomPadding(): number {
    return this.getImmersiveKeyguardMargin(this.itemHeightSum);
  }

  /**
   * 沉浸状态变化
   */
  private onImmersiveStateChange() {
    if (this.immersiveState.isShowList()) {
      this.requestNotificationMeshRange(this.listMeshRange, true);
    } else if (this.immersiveState.isCapsule()) {
      let meshEnd = this.getMeshEnd();
      this.requestNotificationMeshRange(new MeshRange(meshEnd, meshEnd + 1));
    } else if (this.immersiveState.isShowCard()) {
      this.requestNotificationMeshRange(this.cardMeshRange);
    }
  }

  /**
   * 触发锁屏时钟收起展开
   *
   * @param isNeedCollapse 时钟是否需要收起
   */
  screenLockClockShift(isNeedToCollapse: boolean) {
    if (isNeedToCollapse) {
      // 时钟向上收起
      this.requestNotificationMeshRange(new MeshRange(0, this.getMeshEnd()));
    } else {
      // 时钟恢复展开状态
      this.onImmersiveStateChange();
    }
  }

  /**
   * 设置列表的最大高度
   *
   * @param heightMax 最大高度
   */
  setNotificationHeightMax(heightMax: number): void {
    if (this.listStaticState.notificationListHeightMax !== heightMax) {
      this.listStaticState.notificationListHeightMax = heightMax;
    }
    // 无时钟主题时刷新列表是否触顶状态
    if (!NotificationStateManager.notificationState.isClockVisible) {
      this.updateReachMax(this.checkNtfListHeightMax());
    }
  }

  /**
   * 通知列表条目总高度更新
   *
   * @param heightSum 新总高度
   * @param force 是否强制刷新
   */
  private updateItemHeightSum(heightSum: number, force?: boolean, itemSizeSum?: number) {
    if ((heightSum === this.itemHeightSum) && !force) {
      if (!this.immersiveState.isCapsule() && !this.isReachMax) {
        this.updateReachMax(this.checkNtfListHeightMax());
      }
      this.isItemHeightChanging = false;
      return;
    }
    // 开启拦截
    let interrupt = this.listStaticState?.getMeshInterrupt();
    this.listStaticState?.updateMeshInterrupt();
    interrupt?.requestInterrupt();

    let itemHeightAbs: number = Math.abs(heightSum - this.itemHeightSum);
    let nowHeight: number = heightSum;
    if (itemHeightAbs <= HEIGHT_DIFF && this.itemSizeSum === itemSizeSum &&
      heightSum < this.itemHeightSum) {
      nowHeight = this.itemHeightSum;
    }

    this.updateCacheValue(heightSum, itemSizeSum);

    let meshHeight = this.getMeshHeight();
    let meshNum = Math.ceil((nowHeight + this.getImmersiveKeyguardMargin(nowHeight)) / meshHeight);
    let meshRange = this.getMeshRange(this.getMeshEnd(), meshNum);
    this.listMeshRange = meshRange;
    this.updateListState();
    if (interrupt) {
      setTimeout(() => interrupt?.releaseInterrupt()); // 释放拦截
    }
    this.isItemHeightChanging = false;
  }

  private updateCacheValue(heightSum: number, itemSizeSum?: number): void { // 更新缓存值
    this.itemHeightSum = heightSum;
    this.itemSizeSum = itemSizeSum ?? this.itemSizeSum;
    immersiveStateHelper.getSlListStaticState()?.setSlState(ListStaticStateType.NTF_LIST_ITEM_HEIGHT_SUM, heightSum);
  }

  /**
   * 获取锁屏通知列表底部间距
   *
   * @returns 锁屏通知列表底部间距
   */
  private getImmersiveKeyguardMargin(listHeight: number): number {
    if (listHeight == 0) {
      //没有通知时不需要计算间距
      return 0;
    }
    let paddingB: number = 0;
    let itemSpace: number = 0;
    if (this.vmInjector) { // V2样式时
      paddingB = this.getListStatic()?.getMeshPaddingB() ?? 0;
      itemSpace = this.getListStatic()?.getItemSpace();
    } else {
      paddingB = this.panelState.paddingBottom;
      itemSpace = this.listStaticState.itemSpace;
    }
    return paddingB + itemSpace;
  }

  /**
   * 请求网格范围, 刷新列表状态
   */
  private updateListState(): void {
    if (this.immersiveState.isShowList()) {
      this.requestNotificationMeshRange(this.listMeshRange, true);
    } else if (!this.isArtClockLayout() && this.isReachMax && this.isListToBottom()) {
      this.updateReachMax(false);
    } else if (!this.isArtClockLayout() && !this.isReachMax && this.isListToTop()) {
      this.updateReachMax(true);
    } else if (!this.isReachMax && this.checkNtfListHeightMax()) {
      this.updateReachMax(true);
    }
  }

  /**
   * 更新卡片网格
   */
  private updateCardMeshRange() {
    let meshHeight = this.getMeshHeight();
    let meshNum = Math.ceil(this.cardHeight / meshHeight);
    let meshRange = this.getMeshRange(this.getMeshEnd(), meshNum);
    this.cardMeshRange = meshRange;
    if (this.immersiveState.isShowCard()) {
      this.requestNotificationMeshRange(this.cardMeshRange);
    }
  }

  /**
   * 检查列表总高度是否到达最大高度
   */
  checkNtfListHeightMax(): boolean {
    let notificationListHeightMax: number = 0;
    if (this.vmInjector) { // V2样式
      notificationListHeightMax = this.getListStatic()?.getListMaxHeight() ?? 0;
    } else {
      notificationListHeightMax = this.listStaticState.notificationListHeightMax;
    }
    return notificationListHeightMax !== 0 && this.itemHeightSum >= notificationListHeightMax;
  }

  private isArtClockLayout(): boolean {
    let clockLayout = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_BIND_STATE)?.getSlState(
      ClockBindStateType.CLOCK_LAYOUT) as number;
    if (clockLayout >= ART_SING_CLOCK_LAYOUT_BASE) {
      return true;
    }
    return false;
  }

  /**
   * 通知给锁屏所需的网格范围
   *
   * @param meshRange 网格范围
   * @param isListState 是否时列表态
   */
  private requestNotificationMeshRange(meshRange: MeshRange, isListState: boolean = false) {
    // 艺术签名样式，由高度管理器管理，普通时钟样式，向网格管理器申请，后续统一为高度管理器
    if (this.isArtClockLayout()) {
      return;
    }
    this.setRequestMesh(meshRange);
    NotificationStateManager.requestNotificationMeshRange(this.reqMeshRange, (notificationState) => {
      if (CommonUtils.isInvalid(notificationState)) {
        return;
      }
      if (!isListState) {
        return;
      }
      let isReachMax = notificationState.isBottomAlign ? false : this.isListToTop();
      // 更新无时钟主题下列表堆叠状态
      if (!notificationState.isClockVisible) {
        isReachMax = this.checkNtfListHeightMax();
      }
      this.updateReachMax(isReachMax);
    });
  }

  /**
   * 获取锁屏网格单位高度
   *
   * @returns 网格单位高度
   */
  private getMeshHeight(): number {
    return MeshConfig.meshHeight;
  }

  /**
   * 获取锁屏网格终止点
   *
   * @returns 网格终止点
   */
  private getMeshEnd(): number {
    let meshEnd = MeshConfig.maxScreenLockMesh;
    if (meshEnd == 0) {
      meshEnd = KeyguardConstants.MESH_END;
    }
    return meshEnd;
  }

  /**
   * 获取网格范围
   *
   * @param meshEnd 网格终止点
   * @param meshNum 网格数量
   * @returns 网格范围
   */
  private getMeshRange(meshEnd: number, meshNum: number): MeshRange {
    let meshStart = Math.max(Math.min(meshEnd - meshNum, meshEnd), KeyguardConstants.MESH_START);
    return new MeshRange(meshStart, meshEnd);
  }


  /**
   * 刷新列表是否达到最大高度状态
   *
   * @param isReachMax true达到最大高度
   * @param isNeedUpdateListAnim 是否需要刷新列表堆叠效果
   */
  public updateListReachMax(isReachMax: boolean, isNeedUpdateListAnim?: boolean): void {
    this.updateReachMax(isReachMax, isNeedUpdateListAnim);
  }

  /**
   * 更新达到最大网格状态
   *
   * @param isReachMax 是否达到最大网格状态
   * @param isNeedUpdateListAnim 是否需要刷新列表堆叠效果
   */
  private updateReachMax(isReachMax: boolean, isNeedUpdateListAnim?: boolean) {
    if (this.isReachMax === isReachMax) {
      // 条目高度变化，底部对齐，则List高度一定变化
      if (this.isItemHeightChanging && !isReachMax) {
        this.listStaticState?.setListHeightChange(true); // 记录列表高度变化
      }
      return;
    }

    this.isReachMax = isReachMax;

    // 息屏状态、非列表态不做动效
    if (!this.immersiveState.isShowList()) {
      this.setListPanelAlign();
      return;
    }

    // 面板可见，动效切换对齐方式
    if (this.vmInjector) {
      this.getListAnimMgr()?.startListAlignAnim(isReachMax, () => this.setListPanelAlign());
    } else if (isNeedUpdateListAnim) {
      this.listAnimMgr?.startListAlignAnim(isReachMax, () => {
        this.setListPanelAlign();
        this.listAnimMgr?.updateListAnimParas();
      });
    } else {
      this.listAnimMgr?.startListAlignAnim(isReachMax, () => this.setListPanelAlign());
    }
  }

  /**
   * 设置list面板对齐方式和高度
   */
  private setListPanelAlign(): void {
    let align = this.isReachMax ? Alignment.Top : Alignment.Bottom;
    let height = this.isReachMax ? '100%' : undefined;
    if (this.vmInjector) { // V2样式
      this.getListStyle()?.setAlignContent(align);
      this.getListStyle()?.setHeight(height);
    } else {
      this.panelState.listAlign = align;
      this.listBindState.listHeight = height;
    }
  }


  /**
   * 设置请求网格参数
   *
   * @param meshRange 网格参数
   */
  private setRequestMesh(meshRange: MeshRange) {
    this.reqMeshRange.rangeStart = meshRange.rangeStart;
    this.reqMeshRange.rangeEnd = meshRange.rangeEnd;
  }

  /**
   * 网格参数配置变化
   */
  private onMeshConfigChange(): void {
    this.updateItemHeightSum(this.itemHeightSum, true, this.itemSizeSum);
    this.updateCardMeshRange();
    if (this.immersiveState.isCapsule()) {
      let meshEnd = this.getMeshEnd();
      this.requestNotificationMeshRange(new MeshRange(meshEnd, meshEnd + 1));
    }
  }

  /**
   * 时钟展开态y轴网格值变化
   */
  private onClockExpandMeshYChange(): void {
    let meshY = this.getClockExpandMeshY() as number;
    if (!CommonUtils.isInvalid(meshY) && this.clockExpandMeshY !== meshY) {
      this.clockExpandMeshY = meshY;
      this.updateListState();
    }
  }

  /**
   * 获取时钟展开态y轴网格值
   *
   * @returns 时钟展开态y轴网格值
   */
  private getClockExpandMeshY(): number | undefined {
    return slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
      ?.getSlState(SlStaticStateType.CLOCK_EXPAND_MESH_Y) as number;
  }

  /**
   * 判断列表是否到顶部
   *
   * @returns 列表是否到顶部
   */
  private isListToTop(): boolean {
    return this.listMeshRange.rangeStart < this.clockExpandMeshY;
  }

  /**
   * 判断列表是否到底部
   *
   * @returns 列表是否到底部
   */
  private isListToBottom(): boolean {
    return this.listMeshRange.rangeStart >= this.clockExpandMeshY;
  }

  /**
   * 列表样式状态
   *
   * @returns 列表样式
   */
  private getListStyle(): WidgetStyleStateV2 | undefined {
    return this.vmInjector?.getImmersiveListVm()?.getSlStyleState();
  }

  /**
   * 列表静态状态
   *
   * @returns 列表静态
   */
  private getListStatic(): SlListStaticStateV2 {
    return this.vmInjector?.getImmersiveListVm()?.getSlStaticState() as SlListStaticStateV2;
  }

  private getListAnimMgr(): IImmersiveListAnimVm | undefined {
    return this.vmInjector?.getImmersiveListAnimVm();
  }
}