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

import { LogDomain, Logger } from '@ohos/basicutils';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  ComponentPosition,
  WidgetAnimStateV2,
  WidgetStyleStateV2,
  WidgetCacheState,
  AnimEvent
} from '@ohos/screenlockcommon/Index';
import { ImmersiveType, ImmersiveTypeScene } from '@ohos/systemuicommon';
import { NotificationArray, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { SlListBindStateV2 } from '../../../model/data/v2/SlListBindStateV2';
import { SlListStaticStateV2 } from '../../../model/data/v2/SlListStaticStateV2';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { ListVmStyleMgr } from '../mgr/ListVmStyleMgr';
import { ImmersiveNtfBaseVm } from './ImmersiveNtfBaseVm';
import { ImmDataShareWrap } from '../../../common/interface/IImmDataShare';
import { IImmersiveDataVm } from '../../../common/interface/IImmersiveDataVm';
import { ListCacheSuffix,
  LIST_ALL_ANIM_SF,
  LIST_ALL_CACHE_SF,
  LIST_ALL_STYLE_SF } from '../../../common/constants/ImmListConst';
import { ImmListItemFoldAnim } from '../anim/ImmListItemFoldAnim';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { IImmersiveWholeAnimVm } from '../../../common/interface/IImmersiveWholeAnimVm';
import { ImmComAnimScene } from '../../../common/constants/ImmComConst';
import { ImmListData } from '../../../model/data/v2/ImmListData';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { IImmersiveMeshVm } from '../../../common/interface/IImmersiveMeshVm';
import { IImmersiveListAnimVm } from '../../../common/interface/IImmersiveListAnimVm';
import { IImmersiveListHandle } from '../../../common/interface/IImmersiveListHandle';

const TAG = 'ImmersiveNtfListVm';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 集合限制
const LIMIT = 1000;

// 列表条目状态延时清除
const DELAY_TIME = 1000;

// 超出起始、结束索引个数
const OUT_INDEX: number = 2;

/**
 * 沉浸列表数据、排序等业务管理
 */
@ObservedV2
export class ImmersiveNtfListVm extends ImmersiveNtfBaseVm implements IImmersiveListVm {
  /**
   * 列表样式统一管理
   */
  private listStyleMgr: ListVmStyleMgr;

  /**
   * 状态移除延时任务管理
   */
  private readonly removeDelayId: LimitMap<string, number> = new LimitMap(TAG, LIMIT);

  /**
   * 条目堆叠动效管理
   */
  private readonly itemFoldAnimMap: LimitMap<string, ImmListItemFoldAnim> = new LimitMap(TAG, LIMIT);

  /**
   * 列表全量数据管理，groupKey => data
   */
  private readonly allListData: LimitMap<string, ImmListData> = new LimitMap();

  /**
   * 锁屏通知临时列表数据
   */
  private tempNtfList: NotificationArray = new NotificationArray();

  /**
   * 沉浸面板网格管理
   */
  private meshVm: IImmersiveMeshVm;

  /**
   * 锁屏通知列表数据
   */
  @Trace private slNtfList?: NotificationArray;

  /**
   * 沉浸列表静态状态管理器
   */
  @Trace private slStaticState?: SlListStaticStateV2;

  /**
   * 沉浸列表UI绑定状态管理器
   */
  @Trace private slBindState?: SlListBindStateV2;

  /**
   * 沉浸列表动效状态管理器
   */
  @Trace private slAnimState?: WidgetAnimStateV2;

  /**
   * 沉浸列表UI属性样式状态管理器
   */
  @Trace private slStyleState?: WidgetStyleStateV2;

  /**
   * 沉浸列表缓存状态管理器
   */
  @Trace private slCacheState?: WidgetCacheState;

  /**
   * 构造
   *
   * @param vmInjector 注入器
   */
  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.listStyleMgr = new ListVmStyleMgr(vmInjector);
    this.meshVm = vmInjector.getImmersiveMeshVm() as IImmersiveMeshVm;
  }

  /**
   * 初始化
   */
  init(): void {
    this.listStyleMgr.init();
    this.getListHandle()?.init();
  }

  /**
   * 销毁
   */
  destroy(): void {
    // 数据销毁
    this.allListData.clear();
    this.resetAllData();
    this.listStyleMgr.destroy();
    this.getListHandle()?.destroy();
  }

  /**
   * 数据刷新，嫁接通知中心
   */
  graftUpdateNtf(): void {
  }

  /**
   * 异常数据删除
   *
   * @param groupKey 异常数据分组标识
   */
  onDelWrongData(groupKey: string): void {
    // 及时清除异常数据
    this.allListData.delete(groupKey);
    // 清除条目状态
    this.removeItemStDelay(groupKey);
  }

  /**
   * 数据刷新
   *
   * @param dataShare 分享数据
   */
  onDataChange(dataShare: ImmDataShareWrap): void {
    // 无数据变化
    if (!dataShare.isDataChange()) {
      return;
    }
    // 优先处理条目状态
    this.refreshDataState(dataShare);
    let allData = dataShare?.getDataAllArr();
    if (allData) {
      this.tempNtfList.clear();
      this.tempNtfList.push(...allData);
      this.tryAnimRefreshUiData();
    }
    // V1兼容性处理，设置锁屏通知数量，用于AOD显示判断
    this.listStyleMgr.getImmState().updateNtfNumber(allData?.length);
  }

  /**
   * 缓存条目位置
   *
   * @param groupKey 分组标识
   * @param position 条目位置
   */
  cacheItemPosition(groupKey: string, position: Area | SizeOptions | ComponentPosition): void {
    let cacheSt = this.getItemHelperVm()?.getListCacheH(ListCacheSuffix.ITEM_COMMON_CACHE)
      .getItemSt(groupKey);
    cacheSt?.setWidgetPosition(position);
  }

  /**
   * 取值条目位置
   *
   * @param groupKey 分组标识
   * @returns 条目位置
   */
  getItemPosition(groupKey: string): ComponentPosition | undefined {
    let cacheSt = this.getItemHelperVm()?.getListCacheH(ListCacheSuffix.ITEM_COMMON_CACHE)
      .getItemSt(groupKey);
    return cacheSt?.getWidgetPosition();
  }

  /**
   * 列表整体区域变化回调
   *
   * @param oldValue 旧区域
   * @param newValue 新区域
   */
  onListAreaChange(oldValue: Area, newValue: Area): void {
    // 小外屏时不做处理
    if (this.listStyleMgr.isOuterScreen()) {
      return;
    }
    // 缓存列表位置
    this.getSlCacheState()?.setWidgetPosition(newValue);
    // 刷新堆叠动效
    this.forEachFoldAnim((foldAnim) => foldAnim?.onListRootSizeChange());
  }

  /**
   * 列表即将滑动回调
   *
   * @param willOffset 即将滑动位移
   */
  onListWillScroll(willOffset: number = 0): void {
    if (willOffset === 0) {
      return;
    }
    let isCheckOffset = this.getSlStaticState()?.isCheckWillOffset();
    this.getSlStaticState()?.resetCheckWillOffset();
    // 如果开始滑动时，列表已触顶，则下滑偏移量直接拦截
    if (isCheckOffset && willOffset < 0) {
      log.showWarn(TAG, `onListWillScroll err offset: ${willOffset}`);
      return;
    }
    // 先累加偏移值，在取累加值
    this.getSlStaticState()?.addWillOffset(willOffset);
    let realOffset = this.getSlStaticState()?.getWillOffset();
    // 刷新堆叠动效
    this.forEachFoldAnim((foldAnim, groupKey, index) => {
      foldAnim?.onItemAreaChange(groupKey, index, realOffset);
    });
  }

  /**
   * 列表滑动起始位置
   */
  onReachStart(): void {
    // 触顶时，第一个条目刷新堆叠效果
    this.refreshFoldAnim(0);
  }

  /**
   * 列表滑动末尾位置
   */
  onReachEnd(): void {
    // 触底时，最后一个条目刷新堆叠效果
    let lastIndex = (this.getSlNtfList()?.length ?? 0) - 1;
    this.refreshFoldAnim(lastIndex);
  }

  /**
   * 条目上树回调
   *
   * @param itemData 条目数据
   * @param index 条目索引
   */
  onItemAppear(itemData: NotificationBase, index: number): void {
    // 条目上树时，若该条目不在可见区域，存在无area变化回调问题，则提前刷新堆叠效果
    let startIndex = this.getSlStaticState()?.getStartIndex() ?? 0;
    let endIndex = this.getSlStaticState()?.getEndIndex() ?? 0;
    if (index >= startIndex && index <= endIndex) {
      return;
    }
    // 刷新条目堆叠效果
    this.refreshFoldAnim(index);
  }

  /**
   * 条目区域变化回调
   *
   * @param itemData 条目数据
   * @param newValue 新区域
   * @param index 条目索引
   */
  onItemAreaChange(itemData: NotificationBase, newValue: Area, index: number): void {
    // 小外屏时不做处理
    if (this.listStyleMgr.isOuterScreen()) {
      return;
    }
    let groupKey = itemData?.groupKey;
    // 缓存条目位置，剔除条目宽高
    let pos: ComponentPosition = {
      globalX: newValue?.globalPosition?.x as number,
      globalY: newValue?.globalPosition?.y as number,
    };
    this.cacheItemPosition(groupKey, pos);
    // 刷新条目堆叠效果
    this.refreshFoldAnim(index);
  }

  /**
   * 条目大小变化回调
   *
   * @param itemData 条目数据
   * @param oldValue 旧大小
   * @param newValue 新大小
   */
  onItemSizeChange(itemData: NotificationBase, oldValue: SizeOptions, newValue: SizeOptions): void {
    // 小外屏时不做处理
    if (this.listStyleMgr.isOuterScreen()) {
      return;
    }
    let groupKey = itemData?.groupKey;
    // 旧大小
    let oldPos = this.getItemPosition(groupKey);
    // 缓存卡片位置
    this.cacheItemPosition(groupKey, newValue);
    // 刷新堆叠效果
    if (oldValue?.height !== newValue?.height) {
      let index = this.getDataVm()?.getDataIndex(groupKey) ?? -1;
      this.refreshFoldAnim(index)
    }
    // 栅格计算，和缓存的旧大小做比对
    this.meshVm?.onListItemSizeChange(groupKey, { width: oldPos?.width, height: oldPos?.height }, newValue);
  }

  /**
   * 列表可见条目索引切换回调
   */
  onScrollIndexChange(): void {
    // 小外屏时不做处理
    if (this.listStyleMgr.isOuterScreen()) {
      return;
    }
    // 可见条目索引变化时，刷新不可见条目的堆叠效果
    let startIndex = this.getSlStaticState()?.getStartIndex() ?? 0;
    let endIndex = this.getSlStaticState()?.getEndIndex() ?? 0;
    // 顶部不可见条目
    this.refreshFoldAnim(startIndex - 1);
    // 底部不可见条目
    this.refreshFoldAnim(endIndex + 1);
  }

  /**
   * 列表条目图标点击
   *
   * @param groupKey 分组标识
   */
  onItemIconClick(groupKey: string): void {
    this.listStyleMgr.onItemIconClick(groupKey);
  }

  /**
   * 获取锁屏通知列表数据
   *
   * @returns 列表数据
   */
  getSlNtfList(): NotificationArray {
    if (!this.slNtfList) {
      this.slNtfList = this.getSlStaticState()?.getListData();
    }
    return this.slNtfList;
  }

  /**
   * 沉浸列表静态状态管理器
   *
   * @returns 静态状态管理器
   */
  getSlStaticState(): SlListStaticStateV2 {
    if (!this.slStaticState) {
      this.slStaticState = this.stateHelper.getListStaticState();
    }
    return this.slStaticState;
  }

  /**
   * 沉浸列表UI绑定状态管理器
   *
   * @returns UI绑定状态管理器
   */
  getSlBindState(): SlListBindStateV2 {
    if (!this.slBindState) {
      this.slBindState = this.stateHelper.getListBindState();
    }
    return this.slBindState;
  }

  /**
   * 沉浸列表动效状态管理器
   *
   * @returns 动效状态管理器
   */
  getSlAnimState(): WidgetAnimStateV2 {
    if (!this.slAnimState) {
      this.slAnimState = this.stateHelper.getListAnimState();
    }
    return this.slAnimState;
  }

  /**
   * 沉浸列表UI属性样式状态管理器
   *
   * @returns 样式状态管理器
   */
  getSlStyleState(): WidgetStyleStateV2 {
    if (!this.slStyleState) {
      this.slStyleState = this.stateHelper.getListStyleState();
    }
    return this.slStyleState;
  }

  /**
   * 沉浸列表缓存状态管理器
   *
   * @returns 缓存状态管理器
   */
  getSlCacheState(): WidgetCacheState {
    if (!this.slCacheState) {
      this.slCacheState = this.stateHelper.getListCacheState();
    }
    return this.slCacheState;
  }

  /**
   * 取出列表数据
   *
   * @param groupKey 分组标识
   * @returns 列表数据
   */
  getListData(groupKey?: string): ImmListData | undefined {
    return this.allListData.get(groupKey);
  }

  /**
   * 检测横滑拦截点击事件
   *
   * @param ntf 条目数据
   * @returns true 拦截点击事件
   */
  checkSwipeInterruptClick(ntf?: NotificationBase): boolean {
    if (!ntf) {
      return false;
    }
    let swipeVm = this.vmInjector?.getSwipeVm(ntf);
    if ((swipeVm?.offsetX ?? 0) === 0) {
      return false;
    }
    // 拦截点击事件，横滑复位
    swipeVm?.resetOffsetX(true);
    log.showInfo(TAG, `checkSwipeInterruptClick interrupt click: ${ntf?.groupKey}`);
    return true;
  }

  /**
   * 返回事件处理
   *
   * @returns true消费事件
   */
  onBackGestureEvent(): boolean {
    // AOD状态不消费事件
    if (this.listStyleMgr.isAOD()) {
      return false;
    }
    // 列表状态，切换胶囊态
    let isList = this.listStyleMgr.getImmState().isList();
    log.showInfo(TAG, `onBackGestureEvent isList: ${isList}`);
    if (isList) {
      this.onListToCap(0, ImmersiveTypeScene.SCENE_GESTURE_BACK);
      return true;
    }
    return false;
  }

  /**
   * 热区检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true热区匹配
   */
  checkMatchHotZones(globalX: number, globalY: number): boolean {
    return this.getListHandle()?.checkMatchHotZones?.(globalX, globalY) ?? false;
  }

  /**
   * 精确位置检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true位置匹配
   */
  checkMatchExactArea(globalX: number, globalY: number): boolean {
    // 与热区检测保持一致
    return this.checkMatchHotZones(globalX, globalY);
  }

  /**
   * 列表过渡胶囊
   *
   * @param vel 速度
   * @param scene 场景
   * @param onFinish 动效结束回调
   */
  onListToCap(vel: number = 0, scene?: ImmersiveTypeScene, onFinish?: AnimEvent): void {
    // 切换沉浸状态
    this.listStyleMgr.switchImmState(ImmersiveType.TYPE_CAPSULE, scene);
    this.listStyleMgr.resetItem();
    // 如果存在低指纹切换胶囊失败，则不触发动效
    if (!this.listStyleMgr.getImmState().isCapsule()) {
      return;
    }
    // 动效过渡胶囊
    this.getWholeAnimVm()?.startHybridAnim({
      animScene: ImmComAnimScene.ANIM_LIST_CAP_FIX,
      vel: vel,
      onFinish: onFinish
    });
  }

  /**
   * 重置所有数据缓存
   */
  private resetAllData(): void {
    // 清空条目状态
    this.getSlNtfList()?.forEach((ntf) => this.removeItemStDelay(ntf.groupKey));
    this.getSlNtfList()?.clear();
    this.tempNtfList.clear();
  }

  /**
   * UI绑定数据刷新，检测是否动效过渡
   */
  private tryAnimRefreshUiData(): void {
    // 列表态亮屏显示时，数据刷新采用动效过渡
    if (!this.listStyleMgr.isAOD() && this.listStyleMgr.getImmState()?.isShowList()) {
      this.getListAnimVm()?.startListDataAnim(() => this.refreshUiData());
    } else {
      this.refreshUiData();
    }
  }

  /**
   * UI绑定数据刷新
   */
  private refreshUiData(): void {
    this.getSlNtfList()?.clear();
    this.getSlNtfList()?.push(...this.tempNtfList);
  }

  /**
   * 刷新数据条目对应的状态管理器
   *
   * @param dataShare 共享数据
   */
  private refreshDataState(dataShare: ImmDataShareWrap): void {
    if (!dataShare?.isDataChange()) {
      log.showWarn(TAG, 'refreshDataState has not refresh');
      return;
    }
    // 栅格刷新
    this.meshVm?.onListItemKeysChange(this.getDataVm()?.getDataIndexMap());
    // 删除数据场景
    if (dataShare.isDel()) {
      dataShare.getDataChangeArr()?.forEach((ntf) => {
        this.allListData.delete(ntf?.groupKey);
        // 移除对应状态
        this.removeItemStDelay(ntf?.groupKey)
      });
      // 更新数据场景
      this.refreshUpdateData(dataShare);
      return;
    }
    // 新增数据场景
    dataShare.getDataChangeArr()?.forEach((ntf) => {
      if (!ntf) {
        return;
      }
      let oldData = this.allListData.get(ntf.groupKey);
      if (oldData) {
        oldData.updateData(ntf);
      } else {
        let newData: ImmListData = new ImmListData(ntf);
        this.allListData.set(ntf.groupKey, newData);
        // 创建对应状态
        this.createItemSt(ntf.groupKey);
      }
      this.handlePhoneNtfToList(this.allListData.get(ntf.groupKey));
    });
    // 更新数据场景
    this.refreshUpdateData(dataShare);
  }

  private refreshUpdateData(dataShare: ImmDataShareWrap): void {
    // 更新数据刷新
    dataShare.getDataUpdateArr()?.forEach((ntf) => {
      if (!ntf) {
        return;
      }
      let oldData = this.allListData.get(ntf.groupKey);
      if (oldData) {
        oldData.updateData(ntf);
      } else {
        let newData: ImmListData = new ImmListData(ntf);
        this.allListData.set(ntf.groupKey, newData);
        // 创建对应状态
        this.createItemSt(ntf.groupKey);
      }
    });
  }

  /**
   * 条目状态管理器创建
   *
   * @param groupKey 分组标识
   */
  private createItemSt(groupKey: string): void {
    // 创建状态时，及时取消清除任务
    this.cancelRemoveDelay(groupKey);
    let itemHelper = this.vmInjector?.getImmItemHelperVm();
    // 动效状态
    LIST_ALL_ANIM_SF.forEach((suffix) => {
      let animHelper = itemHelper?.getListAnimH(suffix);
      animHelper?.addItemSt(groupKey);
    });
    // 样式状态
    LIST_ALL_STYLE_SF.forEach((suffix) => {
      let styleHelper = itemHelper?.getListStyleH(suffix);
      styleHelper?.addItemSt(groupKey);
    });
    // 缓存状态
    LIST_ALL_CACHE_SF.forEach((suffix) => {
      let cacheHelper = itemHelper?.getListCacheH(suffix);
      cacheHelper?.addItemSt(groupKey);
    });
    // 条目状态创建后，刷新默认样式
    this.listStyleMgr.updateAllItemStyle(groupKey);
    // 同步创建堆叠动效
    if (!this.itemFoldAnimMap.has(groupKey)) {
      this.itemFoldAnimMap.set(groupKey, new ImmListItemFoldAnim(this.vmInjector));
    }
  }

  /**
   * 延时清除条目状态管理器
   *
   * @param groupKey 分组标识
   */
  private removeItemStDelay(groupKey: string): void {
    this.cancelRemoveDelay(groupKey);
    let delayId = setTimeout(() => {
      this.removeItemSt(groupKey);
      this.itemFoldAnimMap.delete(groupKey);
    }, DELAY_TIME);
    this.removeDelayId.set(groupKey, delayId);
  }

  /**
   * 条目状态管理器清除
   *
   * @param groupKey 分组标识
   */
  private removeItemSt(groupKey: string): void {
    // 清除延时任务
    this.cancelRemoveDelay(groupKey);
    let itemHelper = this.vmInjector?.getImmItemHelperVm();
    // 动效状态
    LIST_ALL_ANIM_SF.forEach((suffix) => {
      let animHelper = itemHelper?.getListAnimH(suffix);
      animHelper?.removeItemSt(groupKey);
    });
    // 样式状态
    LIST_ALL_STYLE_SF.forEach((suffix) => {
      let styleHelper = itemHelper?.getListStyleH(suffix);
      styleHelper?.removeItemSt(groupKey);
    });
    // 缓存状态
    LIST_ALL_CACHE_SF.forEach((suffix) => {
      let cacheHelper = itemHelper?.getListCacheH(suffix);
      cacheHelper?.removeItemSt(groupKey);
    });
  }

  /**
   * 取消延时任务
   *
   * @param groupKey 分组标识
   */
  private cancelRemoveDelay(groupKey: string): void {
    if (this.removeDelayId.has(groupKey)) {
      let delayId = this.removeDelayId.get(groupKey);
      this.removeDelayId.delete(groupKey);
      clearTimeout(delayId);
    }
  }

  private refreshFoldAnim(index: number): void {
    // 根据条目索引刷新堆叠效果
    let groupKey = this.getSlNtfList()?.[index]?.groupKey;
    if (groupKey) {
      this.itemFoldAnimMap.get(groupKey)?.onItemAreaChange(groupKey, index);
    }
  }

  /**
   * 锁屏通话类实况以列表态展示
   *
   * @param entry 通知基础数据
   */
  private handlePhoneNtfToList(ntfData?: ImmListData) {
    if (!ntfData?.isSysPhone()) {
      return;
    }
    let isCapsule = this.listStyleMgr.getImmState().isCapsule();
    let isImmersive = this.listStyleMgr.getImmState().isImmersive();
    if ((isImmersive || isCapsule) && this.isSwitchState()) {
      this.listStyleMgr.switchImmState(ImmersiveType.TYPE_LIST);
      // 如果胶囊存在AOD一镜到底动效打断器，则打断动效
      this.tryInterruptCapAodMirror();
      return;
    }
    if (isImmersive) {
      this.getImmCardVm()?.onExitImmState(false, ImmersiveTypeScene.SCENE_PHONE_SWITCH_LIST);
    }
    if (isCapsule) {
      this.getImmCapVm()?.onCapToList(0, ImmersiveTypeScene.SCENE_PHONE_SWITCH_LIST);
    }
  }

  /**
   * 打断胶囊AOD一镜到底动效
   */
  private tryInterruptCapAodMirror(): void {
    let capSt = this.getImmCapVm()?.getSlStaticState();
    let aodInterrupt = capSt?.getAodMirrorInterrupt();
    aodInterrupt?.();
  }

  /**
   * 是否直接切换锁屏通知状态
   *
   * @returns boolean 直接切换锁屏通知状态
   */
  private isSwitchState(): boolean {
    let isAod = this.listStyleMgr?.isAOD();
    let length: number = this.allListData.size() ?? 0;
    if (isAod || length === 0) {
      return true;
    }
    return false;
  }

  /**
   * 遍历堆叠动效集
   *
   * @param callback 遍历回调
   */
  private forEachFoldAnim(callback: (foldAnim: ImmListItemFoldAnim, groupKey: string, index: number) => void): void {
    // 按列表可见范围遍历
    let startIndex = this.getSlStaticState()?.getStartIndex() ?? 0;
    let endIndex = this.getSlStaticState()?.getEndIndex() ?? 0;
    let dataArr = this.getSlNtfList();
    for (let i = startIndex - OUT_INDEX; i <= endIndex + OUT_INDEX; i++) {
      let groupKey = dataArr?.[i]?.groupKey;
      let foldAnim = this.itemFoldAnimMap?.get(groupKey);
      if (foldAnim) {
        callback?.(foldAnim, groupKey, i);
      }
    }
  }

  private getDataVm(): IImmersiveDataVm {
    return this.vmInjector?.getImmDataVm();
  }

  private getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }

  private getWholeAnimVm(): IImmersiveWholeAnimVm {
    return this.vmInjector?.getImmersiveWholeAnimVm();
  }

  private getListAnimVm(): IImmersiveListAnimVm {
    return this.vmInjector?.getImmersiveListAnimVm();
  }

  private getListHandle(): IImmersiveListHandle {
    return this.vmInjector?.getImmersiveListHandle();
  }

  private getImmCardVm(): IImmersiveCardVm {
    return this.vmInjector?.getImmersiveCardVm();
  }

  private getImmCapVm(): IImmersiveCapVm {
    return this.vmInjector?.getImmersiveCapVm();
  }
}