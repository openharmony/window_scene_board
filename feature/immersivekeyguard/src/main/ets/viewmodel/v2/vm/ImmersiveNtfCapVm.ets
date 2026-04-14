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
import { KeyguardStatusService, ScreenLockApi } from '@ohos/screenlockcommon';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  ComponentPosition,
  WidgetAnimStateV2,
  WidgetCacheState,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { ImmersiveType, ImmersiveTypeScene } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  CapCacheSuffix,
  CapShowType,
  CAP_ALL_ANIM_SF,
  CAP_ALL_CACHE_SF,
  CAP_ALL_STYLE_SF,
  CAP_ALL_TYPE
} from '../../../common/constants/ImmCapConst';
import { ImmComAnimScene } from '../../../common/constants/ImmComConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ICapAnimChainVm } from '../../../common/interface/ICapAnimChainVm';
import { ImmDataShareWrap } from '../../../common/interface/IImmDataShare';
import { IImmersiveCapAnimVm } from '../../../common/interface/IImmersiveCapAnimVm';
import { IImmersiveCapsuleHandle } from '../../../common/interface/IImmersiveCapsuleHandle';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { IImmersiveLiveTimerVm } from '../../../common/interface/IImmersiveLiveTimerVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveWholeAnimVm } from '../../../common/interface/IImmersiveWholeAnimVm';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ISlClockAnimVm } from '../../../common/interface/ISlClockAnimVm';
import { ImmCapCheckData } from '../../../model/data/v2/ImmCapCheckData';
import { ImmCapData } from '../../../model/data/v2/ImmCapData';
import { ImmCapDataArray } from '../../../model/data/v2/ImmCapDataArray';
import { SlCapBindStateV2 } from '../../../model/data/v2/SlCapBindStateV2';
import { SlCapStaticStateV2 } from '../../../model/data/v2/SlCapStaticStateV2';
import { CapVmStyleMgr } from '../mgr/CapVmStyleMgr';
import { ImmersiveNtfBaseVm } from './ImmersiveNtfBaseVm';
import { KeyguardSlGreetModel } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';

const TAG = 'ImmersiveNtfCapVm';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const MAX_CACHE_DATA_SIZE = 5;

/**
 * 沉浸胶囊列表数据管理业务
 */
@ObservedV2
export class ImmersiveNtfCapVm extends ImmersiveNtfBaseVm implements IImmersiveCapVm {
  /**
   * 胶囊样式统一管理
   */
  private readonly capStyleMgr: CapVmStyleMgr;

  /**
   * 胶囊全量数据管理，groupKey => data
   */
  private readonly allCapData: LimitMap<string, ImmCapData> = new LimitMap();

  /**
   * 胶囊数据排序标识
   */
  private readonly orderGroupKey: string[] = [];

  /**
   * 用于动效检测的数据列表
   */
  private readonly checkCapData: ImmCapCheckData = new ImmCapCheckData();

  /**
   * 锁屏胶囊列表数据
   */
  @Trace private slCapList?: ImmCapDataArray;

  /**
   * 沉浸胶囊静态状态管理器
   */
  @Trace private slStaticState?: SlCapStaticStateV2;

  /**
   * 沉浸胶囊UI绑定状态管理器
   */
  @Trace private slBindState?: SlCapBindStateV2;

  /**
   * 沉浸胶囊动效状态管理器
   */
  @Trace private slAnimState?: WidgetAnimStateV2;

  /**
   * 沉浸胶囊UI属性样式状态管理器
   */
  @Trace private slStyleState?: WidgetStyleStateV2;

  /**
   * 沉浸胶囊缓存状态管理器
   */
  @Trace private slCacheState?: WidgetCacheState;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    // 初始创建全部条目的状态管理器
    this.createAllItemSt();
    this.capStyleMgr = new CapVmStyleMgr(vmInjector);
  }

  /**
   * 初始化
   */
  public init(): void {
    this.capStyleMgr.init();
    this.getCapHandle()?.init();
  }

  /**
   * 资源回收
   */
  public destroy(): void {
    this.capStyleMgr.destroy();
    this.getCapHandle()?.destroy();
    // 缓存数据清空
    this.allCapData.clear();
    this.orderGroupKey.splice(0);
    this.checkCapData.clear();
    this.getSlCapData()?.clear();
  }

  /**
   * 移除错误数据
   *
   * @param groupKey 错误数据分组标识
   */
  public onDelWrongData(groupKey: string): void {
    // 及时清除异常数据
    this.allCapData.delete(groupKey);
  }

  /**
   * 通知数据列表刷新回调
   *
   * @param dataShare 分享数据
   */
  public onDataChange(dataShare: ImmDataShareWrap): void {
    // 提前记录胶囊已有数据个数
    this.getSlCapData()?.recordValidSize();
    // 刷新全量数据缓存
    this.updateAllCapData(dataShare);
    // 提前清空数据集
    this.getSlCapData()?.clear();
    // 刷新胶囊显示数据
    this.updateCapsuleData();
    // 检测胶囊生命周期动效
    this.checkCapLifeCycleAnim();
  }

  /**
   * 胶囊数据列表
   *
   * @returns 胶囊数据
   */
  getSlCapData(): ImmCapDataArray {
    if (!this.slCapList) {
      this.slCapList = this.getSlStaticState()?.getCapData();
    }
    return this.slCapList;
  }

  /**
   * 胶囊动效检测数据列表
   *
   * @returns 动效检测数据
   */
  getCheckCapData(): ImmCapCheckData {
    return this.checkCapData;
  }

  /**
   * 沉浸态数据判断
   *
   * @param groupKey 目标数据标识
   * @returns true沉浸态正显示数据
   */
  isCurImmCard(groupKey?: string): boolean {
    return this.capStyleMgr.isCurImmCard(groupKey);
  }

  /**
   * 沉浸胶囊静态状态管理器
   *
   * @returns 静态状态管理器
   */
  getSlStaticState(): SlCapStaticStateV2 {
    if (!this.slStaticState) {
      this.slStaticState = this.stateHelper.getCapStaticState();
    }
    return this.slStaticState;
  }

  /**
   * 沉浸胶囊UI绑定状态管理器
   *
   * @returns UI绑定状态管理器
   */
  getSlBindState(): SlCapBindStateV2 {
    if (!this.slBindState) {
      this.slBindState = this.stateHelper.getCapBindState();
    }
    return this.slBindState;
  }

  /**
   * 沉浸胶囊动效状态管理器
   *
   * @returns 动效状态管理器
   */
  getSlAnimState(): WidgetAnimStateV2 {
    if (!this.slAnimState) {
      this.slAnimState = this.stateHelper.getCapAnimState();
    }
    return this.slAnimState;
  }

  /**
   * 沉浸胶囊样式状态管理器
   *
   * @returns 样式状态管理器
   */
  getSlStyleState(): WidgetStyleStateV2 {
    if (!this.slStyleState) {
      this.slStyleState = this.stateHelper.getCapStyleState();
    }
    return this.slStyleState;
  }

  /**
   * 沉浸胶囊缓存状态管理器
   *
   * @returns 缓存状态管理器
   */
  getSlCacheState(): WidgetCacheState {
    if (!this.slCacheState) {
      this.slCacheState = this.stateHelper.getCapCacheState();
    }
    return this.slCacheState;
  }

  /**
   * 取出胶囊数据
   *
   * @param groupKey 分组标识
   * @returns 胶囊数据
   */
  getCapData(groupKey?: string): ImmCapData | undefined {
    return this.allCapData.get(groupKey);
  }

  /**
   * 胶囊根组件位置切换
   *
   * @param oldValue 旧区域
   * @param newValue 新区域
   */
  onRootAreaChange(oldValue: Area, newValue: Area): void {
    // 缓存根组件位置
    this.getSlCacheState()?.setWidgetPosition(newValue);
    // 根据根组件位置，计算不同类型胶囊位置
    this.capStyleMgr.updateItemPos();
  }

  /**
   * 胶囊条目组件位置
   *
   * @param capType 胶囊类型
   * @returns 组件位置
   */
  getItemPosition(capType: CapShowType): ComponentPosition | undefined {
    let cacheSt = this.getItemHelperVm()?.getCapCacheH(CapCacheSuffix.ITEM_COMMON_CACHE).getItemSt(capType);
    return cacheSt?.getWidgetPosition();
  }

  /**
   * 热区检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true热区匹配
   */
  checkMatchHotZones(globalX: number, globalY: number): boolean {
    return this.getCapHandle()?.checkMatchHotZones?.(globalX, globalY) ?? false;
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
   * 条目点击回调
   *
   * @param itemData 条目数据
   */
  onItemClick(itemData: ImmCapData): void {
    // 支持沉浸态，则直接进入沉浸态
    log.showWarn(TAG, `onItemClick ${itemData?.getGroupKey()}, ${itemData?.isSupportImmCard()}`);
    KeyguardStatusService.setSlGreetMode(KeyguardSlGreetModel.SL_GREET_OFF);
    if (itemData.isSupportImmCard()) {
      // UIExtension数据，解锁安全校验，请求解锁
      if (!this.capStyleMgr.isOsAccountUnlocked()) {
        log.showWarn(TAG, `onItemClick ui extension locked: ${itemData?.getGroupKey()}`);
        ScreenLockApi.requestUnlock();
        return;
      }
      // 沉浸态数据切换前，记录数据
      this.getCardVm()?.requestCheckCapCard();
      this.onCapToCardClick(itemData);
    } else {
      // 切换列表态
      this.onCapToList(0, ImmersiveTypeScene.SCENE_CAP_CLICK);
    }
  }

  /**
   * 胶囊过渡列表态
   *
   * @param vel 过渡动效速度
   * @param scene 切换场景
   * @returns void
   */
  onCapToList(vel: number = 0, scene?: ImmersiveTypeScene): void {
    // 时钟元素动效需要速度共享
    this.getClockAnimVm()?.updateClockVel(vel);
    // 检测卡片过渡列表
    let isCardToList = this.getCardVm()?.checkCardToListAnim();
    // 标识大卡数据
    let skipGroupKey = this.capStyleMgr.getCurImmCard();
    // 检测胶囊过渡列表
    let isCapToList = this.capStyleMgr.getImmState().isCapsule();
    // 检测完毕，切换状态
    this.capStyleMgr.switchImmState(ImmersiveType.TYPE_LIST, scene);
    // 开启动效
    if (isCardToList) {
      this.getWholeAnimVm()?.startHybridAnim({
        animScene: ImmComAnimScene.ANIM_CARD_LIST,
        vel: vel,
        skipGroupKey: skipGroupKey
      });
    } else if (isCapToList) {
      this.getWholeAnimVm()?.startHybridAnim({
        animScene: ImmComAnimScene.ANIM_CAP_LIST_FIX,
        vel: vel
      });
    }
  }

  /**
   * 刷新胶囊内容
   * 影响参数：沉浸状态，通知数据
   */
  public updateCapsuleData(): void {
    // 按序取出内容胶囊、阴影胶囊
    let contentData: ImmCapData | undefined = undefined;
    let shadowData: ImmCapData | undefined = undefined;
    for (let groupKey of this.orderGroupKey) {
      // 排除沉浸态数据
      if (this.isCurImmCard(groupKey)) {
        continue;
      }
      let itemData = this.allCapData.get(groupKey);
      if (!itemData) {
        log.showWarn(TAG, `updateCapsuleData no data: ${groupKey}`);
        continue;
      }
      // 内容胶囊
      if (!contentData) {
        contentData = itemData;
        continue;
      }
      // 阴影胶囊
      if (!shadowData) {
        shadowData = itemData;
      }
      break;
    }
    // 刷新UI显示数据列表
    this.getSlCapData().setCapData(CapShowType.CAP_CONTENT, contentData);
    this.getSlCapData().setCapData(CapShowType.CAP_SHADOW, shadowData);
    // 数据刷新后及时任务
    this.getSlStaticState()?.exeUpdateDataRunnable();
    log.showInfo(TAG, `updateCapsuleData content: ${contentData?.getGroupKey()}, shadow: ${shadowData?.getGroupKey()}}`);
  }

  private updateAllCapData(dataShare: ImmDataShareWrap): void {
    // 刷新数据前，清空检测数据
    this.checkCapData.clear();
    // 标记此次数据刷新是否自动亮屏
    this.checkCapData.setAutoScreenOn(dataShare.isAutoScreenOn());
    // 无数据刷新
    if (!dataShare?.isDataChange()) {
      log.showWarn(TAG, `updateAllCapData no data refresh: ${dataShare?.getRefreshType()}`);
      return;
    }
    // 删除数据场景
    if (dataShare.isDel()) {
      dataShare.getDataChangeArr()?.forEach((ntf) => {
        let delData = this.allCapData.get(ntf?.groupKey);
        if (delData) {
          this.onDataDel(delData);
        }
      });
      // 更新数据场景
      this.refreshUpdateData(dataShare);
      // 刷新排序数据
      this.updateOrderGroupKey(dataShare);
      return;
    }
    // 新增数据场景
    dataShare.getDataChangeArr()?.forEach((ntf) => {
      if (!ntf) {
        return;
      }
      let oldData = this.allCapData.get(ntf.groupKey);
      if (oldData) {
        oldData.updateData(ntf);
        // 记录更新数据
        this.checkCapData.set(CapShowType.CAP_UPDATE, oldData);
      } else {
        let newData: ImmCapData = new ImmCapData(ntf);
        this.allCapData.set(ntf.groupKey, newData);
        // 记录新增数据
        this.checkCapData.set(CapShowType.CAP_ADD, newData);
      }
    });
    // 更新数据场景
    this.refreshUpdateData(dataShare);
    // 刷新排序数据
    this.updateOrderGroupKey(dataShare);
  }

  private refreshUpdateData(dataShare: ImmDataShareWrap): void {
    // 更新数据刷新
    dataShare.getDataUpdateArr()?.forEach((ntf) => {
      if (!ntf) {
        return;
      }
      let oldData = this.allCapData.get(ntf.groupKey);
      if (oldData) {
        oldData.updateData(ntf);
        // 统一按更新数据处理
        this.checkCapData.set(CapShowType.CAP_UPDATE, oldData);
      } else {
        let newData: ImmCapData = new ImmCapData(ntf);
        this.allCapData.set(ntf.groupKey, newData);
        // 统一按更新数据处理
        this.checkCapData.set(CapShowType.CAP_UPDATE, newData);
      }
    });
  }

  private updateOrderGroupKey(dataShare: ImmDataShareWrap): void {
    // 刷新最新排序，条数限制
    this.orderGroupKey.splice(0);
    dataShare.getDataAllArr()?.find((ntf) => {
      if (!ntf) {
        return false;
      }
      this.orderGroupKey.push(ntf.groupKey);
      return this.orderGroupKey.length >= MAX_CACHE_DATA_SIZE;
    });
  }

  private onDataDel(delData: ImmCapData): void {
    // 删除数据回调处理
    this.allCapData.delete(delData.getGroupKey());
    // 记录删除数据
    this.checkCapData.set(CapShowType.CAP_REMOVE, delData);
    // 实况数据，清除计时器
    let oriData = delData.getOriData();
    if (oriData?.isLiveView()) {
      this.getLiveTimerVm()?.deleteLiveTimer(oriData);
    }
  }

  private checkCapLifeCycleAnim(): void {
    let animScene = this.getCapAnimChainVm()?.checkLifeCycleAnim();
    log.showInfo(TAG, `checkCapLifeCycleAnim anim scene: ${animScene}`);
    // 开启生命周期动效
    this.getCapAnimVm()?.startLifeCycleAnim(animScene);
    // 动效检测完毕，及时清除自动亮屏标记
    this.checkCapData.setAutoScreenOn(false);
  }

  private onCapToCardClick(itemData: ImmCapData): void {
    // 切换沉浸态数据
    this.capStyleMgr.setCurImmData(itemData.getGroupKey());
    // 切换前，已在沉浸态，则胶囊大卡互切动效
    if (this.capStyleMgr.getImmState()?.isImmersive()) {
      this.saveMediaCapCardData(itemData);
      this.getWholeAnimVm()?.startHybridAnim({
        animScene: ImmComAnimScene.ANIM_CAP_CARD_SWITCH
      });
      return;
    }
    // 及时开启播控元素共享动效，规避时序影响
    if (itemData.isMediaCenter()) {
      ImmersiveComHelper.startMediaAnim(ImmComAnimScene.ANIM_CAP_CARD);
    }
    // 数据刷新后及时切换数据类型，保持不下树
    this.getSlStaticState()?.setUpdateDataRunnable(() => this.saveMediaCapCardData(itemData));
    this.capStyleMgr.switchImmState(ImmersiveType.TYPE_IMMERSIVE, ImmersiveTypeScene.SCENE_CAP_CLICK);
    // 清空及时任务
    this.getSlStaticState()?.setUpdateDataRunnable();
    // 开启胶囊过渡大卡动效
    this.getWholeAnimVm()?.startHybridAnim({
      animScene: ImmComAnimScene.ANIM_CAP_CARD
    });
  }

  private saveMediaCapCardData(itemData: ImmCapData): void {
    // 播控数据，及时切换数据类型，防止条目下树
    if (itemData.isMediaCenter()) {
      this.getSlCapData()?.setCapData(CapShowType.CAP_CARD, itemData);
    }
  }

  /**
   * 初始化时，创建所有胶囊条目状态
   */
  private createAllItemSt(): void {
    let helperVm = this.getItemHelperVm();
    CAP_ALL_TYPE.forEach((capType) => {
      // 条目动效状态新增
      CAP_ALL_ANIM_SF.forEach((sf) => {
        let animHelper = helperVm?.getCapAnimH(sf);
        animHelper?.addItemSt(capType);
      });
      // 条目样式状态新增
      CAP_ALL_STYLE_SF.forEach((sf) => {
        let styleHelper = helperVm?.getCapStyleH(sf);
        styleHelper?.addItemSt(capType);
      });
      // 条目缓存状态新增
      CAP_ALL_CACHE_SF.forEach((sf) => {
        let cacheHelper = helperVm?.getCapCacheH(sf);
        cacheHelper?.addItemSt(capType);
      });
    });
  }

  private getCapAnimChainVm(): ICapAnimChainVm {
    return this.vmInjector?.getImmCapAnimChainVm();
  }

  private getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }

  private getCapAnimVm(): IImmersiveCapAnimVm {
    return this.vmInjector?.getImmersiveCapAnimVm();
  }

  private getCapHandle(): IImmersiveCapsuleHandle {
    return this.vmInjector?.getImmersiveCapsuleHandle();
  }

  private getClockAnimVm(): ISlClockAnimVm {
    return this.vmInjector?.getSlClockAnimVm();
  }

  private getWholeAnimVm(): IImmersiveWholeAnimVm {
    return this.vmInjector?.getImmersiveWholeAnimVm();
  }

  private getCardVm(): IImmersiveCardVm {
    return this.vmInjector?.getImmersiveCardVm();
  }

  private getLiveTimerVm(): IImmersiveLiveTimerVm | undefined {
    return this.vmInjector?.getLiveTimerVm();
  }
}