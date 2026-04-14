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
import {
  ComponentPosition,
  ImmRunningLockMgr,
  KeyguardStatusService,
  WidgetAnimStateV2,
  WidgetCacheState,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { LimitMap, SlCardChildId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ImmersiveType, ImmersiveTypeScene } from '@ohos/systemuicommon';
import {
  CardCacheSuffix,
  CardShowType,
  CardStyleSuffix,
  CARD_ALL_ANIM_SF,
  CARD_ALL_CACHE_SF,
  CARD_ALL_STYLE_SF,
  CARD_ALL_TYPE
} from '../../../common/constants/ImmCardConst';
import { ImmComAnimScene } from '../../../common/constants/ImmComConst';
import { ImmDataShareWrap } from '../../../common/interface/IImmDataShare';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveWholeAnimVm } from '../../../common/interface/IImmersiveWholeAnimVm';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmCardData } from '../../../model/data/v2/ImmCardData';
import { ImmBaseData } from '../../../model/data/v2/ImmBaseData';
import { ImmCardCheckData } from '../../../model/data/v2/ImmCardCheckData';
import { ImmCardDataArray } from '../../../model/data/v2/ImmCardDataArray';
import { SlCardBindStateV2 } from '../../../model/data/v2/SlCardBindStateV2';
import { SlCardStaticStateV2 } from '../../../model/data/v2/SlCardStaticStateV2';
import { CardVmStyleMgr } from '../mgr/CardVmStyleMgr';
import { ImmersiveNtfBaseVm } from './ImmersiveNtfBaseVm';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ICardAnimChainVm } from '../../../common/interface/ICardAnimChainVm';
import { IImmersiveCardAnimVm } from '../../../common/interface/IImmersiveCardAnimVm';
import { IImmersiveMeshVm } from '../../../common/interface/IImmersiveMeshVm';
import { IImmersiveCardHandle } from '../../../common/interface/IImmersiveCardHandle';
import { IImmersiveDataVm } from '../../../common/interface/IImmersiveDataVm';
import { IImmComVm } from '../../../common/interface/IImmComVm';

const TAG = 'ImmersiveNtfCardVm';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 沉浸大卡业务管理
 */
@ObservedV2
export class ImmersiveNtfCardVm extends ImmersiveNtfBaseVm implements IImmersiveCardVm {

  /**
   * 大卡全量数据管理，groupKey => data
   */
  private readonly allCardData: LimitMap<string, ImmCardData> = new LimitMap();

  /**
   * 用于动效检测的大卡数据
   */
  private readonly checkCardData: ImmCardCheckData = new ImmCardCheckData();

  /**
   * 沉浸大卡样式统一管理
   */
  protected cardStyleMgr: CardVmStyleMgr;

  /**
   * 沉浸面板网格管理
   */
  private meshVm: IImmersiveMeshVm;

  /**
   * 大卡列表数据
   */
  @Trace private slCardList?: ImmCardDataArray;

  /**
   * 大卡静态状态
   */
  @Trace private slStaticState?: SlCardStaticStateV2;

  /**
   * 大卡UI绑定状态
   */
  @Trace private slBindState?: SlCardBindStateV2;

  /**
   * 大卡动效状态
   */
  @Trace private slAnimState?: WidgetAnimStateV2;

  /**
   * 大卡样式状态
   */
  @Trace private slStyleState?: WidgetStyleStateV2;

  /**
   * 大卡缓存状态
   */
  @Trace private slCacheState?: WidgetCacheState;

  /**
   * 构造
   *
   * @param vmInjector 注入器
   */
  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    // 初始创建全部条目的状态管理器
    this.createAllItemSt();
    this.cardStyleMgr = this.createStyleMgr();
    this.meshVm = vmInjector.getImmersiveMeshVm() as IImmersiveMeshVm;
  }

  /**
   * 初始化
   */
  init(): void {
    // 优先注册实况数据控制器
    this.getImmComVm()?.registerImmCurDataCtrl(this);
    this.cardStyleMgr.init();
    this.getCardHandle()?.init();
    // 沉浸态常亮管理初始化
    ImmRunningLockMgr.getInstance().init();
  }

  /**
   * 资源回收
   */
  destroy(): void {
    // 清空当前沉浸态数据
    this.cardStyleMgr.setCurImmData();
    this.cardStyleMgr.destroy();
    this.getCardHandle()?.destroy();
    this.getImmComVm()?.unregisterImmCurDataCtrl(this);
    // 缓存数据清空
    this.allCardData.clear();
    this.getSlCardData()?.clear();
    // 沉浸态常亮管理初始化
    ImmRunningLockMgr.getInstance().destroy();
  }

  /**
   * 数据列表变化回调
   *
   * @param dataShare 分享数据
   */
  onDataChange(dataShare: ImmDataShareWrap): void {
    let isInit = dataShare.isInit();
    // 刷新全量数据缓存
    this.updateAllCardData(dataShare);
    // 如果当前非沉浸态，则无需检测生命周期动效，直接清空检测数据
    if (!this.cardStyleMgr.getImmState()?.isImmersive()) {
      this.checkCardData.clear();
    }
    // 非初始化场景，无可显示的卡片数据时，需要清空内容卡片数据，退出沉浸态
    let showGroupKey = this.cardStyleMgr.getCurImmCard();
    if (!isInit && showGroupKey && !this.allCardData.has(showGroupKey)) {
      log.showWarn(TAG, `onDataChange showGroupKey: ${showGroupKey}`);
      this.getSlCardData()?.remove(CardShowType.CARD_CONTENT);
      this.cardStyleMgr.requestExitImmersive();
    }
    // 检测大卡生命周期动效
    this.checkCardLifeCycleAnim();
    // 初始化场景，检测默认进沉浸态
    if (isInit) {
      this.checkDefaultEnterImm();
      this.cardStyleMgr.checkDefaultImmComplete();
    }
  }

  /**
   * 沉浸大卡位置切换
   *
   * @param oldValue 旧区域
   * @param newValue 新区域
   */
  onCardAreaChange(oldValue: Area, newValue: Area): void {
    // 记录大卡位置
    this.getSlCacheState()?.setWidgetPosition(newValue);
    // 同步条目位置
    this.cardStyleMgr?.updateItemPos();
    this.meshVm?.onCardSizeChange({ width: oldValue.width, height: oldValue.height },
      { width: newValue.width, height: newValue.height });
  }

  /**
   * 取值大卡条目组件位置
   *
   * @param cardType 大卡类型
   * @returns 条目位置
   */
  getItemPosition(cardType: CardShowType): ComponentPosition | undefined {
    let itemCache = this.getItemHelperVm()?.getCardCacheH(CardCacheSuffix.ITEM_COMMON_CACHE).getItemSt(cardType);
    return itemCache?.getWidgetPosition();
  }

  /**
   * 取值有效大卡数据
   *
   * @param groupKey 分组标识
   * @returns 大卡有效数据
   */
  getImmValidData(groupKey?: string): ImmCardData | undefined {
    let cardData = this.allCardData.get(groupKey);
    if (cardData?.isSupportImmCard()) {
      return cardData;
    }
    return undefined;
  }

  /**
   * 条目点击回调
   *
   * @param itemData 条目数据
   */
  onItemClick(itemData: ImmCardData): void {
    // 点击启动应用
    this.vmInjector?.getStarterVm()?.startNtfWantAgent?.(itemData?.getOriData());
  }

  /**
   * 定位权限授权按钮点击回调
   *
   * @param itemData 条目数据
   */
  onAuthBtnClick(itemData: ImmCardData): void {
    ImmersiveComHelper.startLocationAuthWithUnlock(itemData?.getLocationSettingsWant());
  }

  /**
   * 沉浸大卡UI绑定数据
   *
   * @returns 数据集
   */
  getSlCardData(): ImmCardDataArray {
    if (!this.slCardList) {
      this.slCardList = this.getSlStaticState()?.getCardData();
    }
    return this.slCardList;
  }

  /**
   * 大卡动效检测数据列表
   *
   * @returns 动效检测数据
   */
  getCheckCardData(): ImmCardCheckData {
    return this.checkCardData;
  }

  /**
   * 沉浸大卡静态状态管理器
   *
   * @returns 静态状态
   */
  getSlStaticState(): SlCardStaticStateV2 {
    if (!this.slStaticState) {
      this.slStaticState = this.stateHelper.getCardStaticState();
    }
    return this.slStaticState;
  }

  /**
   * 沉浸大卡UI绑定状态管理器
   *
   * @returns UI绑定状态
   */
  getSlBindState(): SlCardBindStateV2 {
    if (!this.slBindState) {
      this.slBindState = this.stateHelper.getCardBindState();
    }
    return this.slBindState;
  }

  /**
   * 沉浸大卡动效状态管理器
   *
   * @returns 动效状态
   */
  getSlAnimState(): WidgetAnimStateV2 {
    if (!this.slAnimState) {
      this.slAnimState = this.stateHelper.getCardAnimState();
    }
    return this.slAnimState;
  }

  /**
   * 沉浸大卡样式状态管理器
   *
   * @returns 样式状态
   */
  getSlStyleState(): WidgetStyleStateV2 {
    if (!this.slStyleState) {
      this.slStyleState = this.stateHelper.getCardStyleState();
    }
    return this.slStyleState;
  }

  /**
   * 沉浸大卡缓存状态管理器
   *
   * @returns 缓存状态
   */
  getSlCacheState(): WidgetCacheState {
    if (!this.slCacheState) {
      this.slCacheState = this.stateHelper.getCardCacheState();
    }
    return this.slCacheState;
  }

  /**
   * 取用子动效状态
   *
   * @param childId 子ID
   * @returns 子动效
   */
  getChildAnimSt(childId: SlCardChildId): WidgetAnimStateV2 | undefined {
    return this.getSlAnimState()?.getChildState(childId);
  }

  /**
   * 取用子样式状态
   *
   * @param childId 子ID
   * @returns 子样式
   */
  getChildStyleSt(childId: SlCardChildId): WidgetStyleStateV2 | undefined {
    return this.getSlStyleState()?.getChildState(childId);
  }

  /**
   * 设置当前显示的沉浸大卡数据
   *
   * @param groupKey 通知数据唯一标识
   */
  setCurImmCardData(groupKey?: string): void {
    let oldGroupKey = this.cardStyleMgr.getCurImmCard();
    let oldData = this.allCardData.get(oldGroupKey);
    if (this.getSlStaticState().setGroupKeyOfShowing(groupKey)) {
      log.showWarn(TAG, `setImmersiveCardData groupKey=${groupKey}, ${this.vmInjector?.getStateMgr()}`);
      let cardData = this.allCardData.get(groupKey);
      // 提前清除UIExtension标记
      this.getSlCardData()?.delCacheUIExtension(cardData?.getGroupKey());
      // 更新大卡显示数据/清除内容大卡数据
      this.getSlCardData()?.setCardData(CardShowType.CARD_CONTENT, cardData);
      ImmRunningLockMgr.getInstance().setCurShowingImmersive(cardData?.getHashcode());
      // 最后缓存UIExtension的旧数据
      this.getSlCardData().addCacheUIExtension(oldData);
    }
  }

  /**
   * 检测大卡过渡列表
   *
   * @returns true 满足过渡条件
   */
  checkCardToListAnim(): boolean {
    // 当前是沉浸态，则由沉浸态过渡列表态
    if (!this.cardStyleMgr?.getImmState()?.isImmersive()) {
      return false;
    }
    // 数据异常，不满足条件
    let conData = this.getSlCardData()?.getCardData(CardShowType.CARD_CONTENT);
    if (!conData) {
      log.showWarn(TAG, 'checkCardToListAnim content data err.');
      return false;
    }
    // 记录列表大卡数据，过渡动效使用
    this.getCheckCardData()?.set(CardShowType.CARD_LIST, conData);
    return true;
  }

  /**
   * 手势返回事件
   *
   * @returns true消费事件
   */
  onBackGestureEvent(): boolean {
    // AOD状态不消费事件
    if (this.cardStyleMgr.isAOD()) {
      return false;
    }
    // 非沉浸态不消费事件
    if (!this.cardStyleMgr.getImmState().isImmersive()) {
      return false;
    }
    // 沉浸态退出，区分胶囊、列表态
    let isBeforeCap = this.cardStyleMgr.getBeforeImmState().isCapsule();
    return this.onExitImmState(isBeforeCap, ImmersiveTypeScene.SCENE_GESTURE_BACK);
  }

  /**
   * 热区检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true热区匹配
   */
  checkMatchHotZones(globalX: number, globalY: number): boolean {
    return this.getCardHandle()?.checkMatchHotZones?.(globalX, globalY) ?? false;
  }

  /**
   * 精确位置检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true位置匹配
   */
  checkMatchExactArea(globalX: number, globalY: number): boolean {
    return this.getCardHandle()?.checkMatchExactArea?.(globalX, globalY) ?? false;
  }

  /**
   * 请求记录胶囊大卡数据
   */
  requestCheckCapCard(): void {
    // 当前如果存在内容大卡数据，则标记为胶囊大卡
    let conData = this.getSlCardData()?.getCardData(CardShowType.CARD_CONTENT);
    if (conData) {
      this.getCheckCardData()?.set(CardShowType.CARD_CAP, conData);
    }
  }

  /**
   * 退出沉浸态
   *
   * @param isToCap 是否过渡到胶囊
   * @param scene 退出场景
   * @returns 是否正常退出
   */
  onExitImmState(isToCap: boolean = true, scene?: ImmersiveTypeScene): boolean {
    // 数据异常，直接退出沉浸态
    let conData = this.getSlCardData()?.getCardData(CardShowType.CARD_CONTENT);
    if (!conData) {
      this.cardStyleMgr.setDefaultImmState();
      log.showWarn(TAG, `onExitImmState content data err: ${scene}`);
      return false;
    }
    // 非低指纹时才允许过渡胶囊，否则统一按列表处理
    let canToCap = isToCap && !this.cardStyleMgr.isLowFinger();
    if (canToCap) {
      // 记录胶囊大卡数据
      this.getCheckCardData()?.set(CardShowType.CARD_CAP, conData);
      // 播控涉及元素共享动效，保持不下树
      if (conData.isMediaCenter()) {
        this.getSlCardData()?.setCardData(CardShowType.CARD_CAP, conData);
      }
      this.cardStyleMgr.switchImmState(ImmersiveType.TYPE_CAPSULE, scene);
      this.getWholeAnimVm()?.startHybridAnim({
        animScene: ImmComAnimScene.ANIM_CARD_CAP
      });
    } else {
      // 记录列表大卡数据
      this.getCheckCardData()?.set(CardShowType.CARD_LIST, conData);
      // 播控涉及元素共享动效，保持不下树
      if (conData.isMediaCenter()) {
        this.getSlCardData()?.setCardData(CardShowType.CARD_LIST, conData);
      }
      this.cardStyleMgr.switchImmState(ImmersiveType.TYPE_LIST, scene);
      this.getWholeAnimVm()?.startHybridAnim({
        animScene: ImmComAnimScene.ANIM_CARD_LIST,
        skipGroupKey: conData?.getGroupKey()
      });
    }
    log.showInfo(TAG, `onExitImmState exit immersive state: ${isToCap}, ${canToCap}, ${scene}`);
    return true;
  }

  /**
   * 样式管理器构造
   *
   * @returns 样式管理器
   */
  protected createStyleMgr(): CardVmStyleMgr {
    return new CardVmStyleMgr(this.vmInjector);
  }

  /**
   * 检测默认进入沉浸态
   */
  protected checkDefaultEnterImm(): void {
    if (this.isInterruptDefaultImm()) {
      // 当拦截进沉浸态，但此时已在沉浸态，则主动请求沉浸态数据
      if (this.cardStyleMgr.getImmState().isImmersive()) {
        this.getImmComVm()?.requestImmCurData(this);
      }
      return;
    }
    // 提前刷新锁定状态
    this.getImmComVm()?.refreshLockVerify();
    // 查找有效沉浸态数据
    let immList = this.getImmDataVm()?.getImmList();
    let immData = immList?.find((ntf) => {
      let innerData = this.allCardData.get(ntf.groupKey);
      return innerData?.isSupportImmCard() ?? false;
    });
    // 有沉浸态数据，则默认进沉浸态
    if (!immData) {
      return;
    }
    this.cardStyleMgr.setCurImmData(immData.groupKey);
    this.cardStyleMgr.switchImmState(ImmersiveType.TYPE_IMMERSIVE, ImmersiveTypeScene.SCENE_DEFAULT_IMM);
    log.showInfo(TAG, `checkDefaultEnterImm enter imm: ${immData.groupKey}`);
  }

  /**
   * 默认进沉浸态拦截场景
   *
   * @returns true拦截进沉浸态
   */
  protected isInterruptDefaultImm(): boolean {
    if (!this.cardStyleMgr.isCheckDefaultImm()) {
      log.showInfo(TAG, 'checkDefaultEnterImm is not desktop to aod');
      return true;
    }
    // 已在沉浸态，无需重复校验
    if (this.cardStyleMgr.getImmState().isImmersive()) {
      log.showInfo(TAG, 'checkDefaultEnterImm has enter imm');
      return true;
    }
    // 开机锁定场景，不允许默认进沉浸态
    if (!this.cardStyleMgr.isOsAccountUnlocked()) {
      log.showInfo(TAG, 'checkDefaultEnterImm is os locked');
      return true;
    }
    // 问候模式，不允许默认沉浸态
    if (KeyguardStatusService.isSlGreetMode()) {
      log.showInfo(TAG, 'checkDefaultEnterImm is greet mode');
      return true;
    }
    // 无数据，无进入沉浸态
    if (this.allCardData.isEmpty()) {
      log.showInfo(TAG, 'checkDefaultEnterImm has not data');
      return true;
    }
    return false;
  }

  /**
   * 沉浸数据移除回调
   *
   * @param delData 移除数据
   */
  protected onImmDataDel(delData: ImmCardData): void {
    // 记录删除数据
    this.checkCardData.set(CardShowType.CARD_DELETE, delData);
    // 同步删除UIExtension缓存数据
    this.getSlCardData()?.delCacheUIExtension(delData?.getGroupKey());
  }

  /**
   * 沉浸数据更新回调
   *
   * @param updateData 更新数据
   */
  protected onImmDataUpdate(updateData: ImmCardData): void {
  }

  /**
   * 沉浸数据新增回调
   *
   * @param addData 新增数据
   */
  protected onImmDataAdd(addData: ImmCardData): void {
  }

  private checkCardLifeCycleAnim(): void {
    // 实况大卡生命周期动效
    let animScene = this.getCardAnimChainVm()?.checkLifeCycleAnim();
    log.showInfo(TAG, `checkCardLifeCycleAnim anim scene: ${animScene}`);
    this.getCardAnimVm()?.startLifeCycleAnim(animScene);
  }

  private updateAllCardData(dataShare: ImmDataShareWrap): void {
    // 刷新数据前，清空检测数据
    this.checkCardData.clear();
    // 无数据刷新
    if (!dataShare?.isDataChange()) {
      log.showWarn(TAG, `updateAllCardData no data refresh: ${dataShare?.getRefreshType()}`);
      return;
    }
    // 删除数据场景
    if (dataShare.isDel()) {
      dataShare.getDataChangeArr()?.forEach((ntf) => {
        let delData = this.allCardData.get(ntf?.groupKey);
        if (delData) {
          this.allCardData.delete(ntf.groupKey);
          // 数据移除回调
          this.onImmDataDel(delData);
        }
      });
      return;
    }
    // 新增数据场景
    dataShare.getDataChangeArr()?.forEach((ntf) => {
      if (!ntf) {
        return;
      }
      let oldData = this.allCardData.get(ntf.groupKey);
      if (oldData) {
        // 记录旧的更新数据
        this.checkCardData.set(CardShowType.CARD_UPDATE_OLD, oldData.copy());
        oldData.updateData(ntf);
        // 更新数据回调
        this.onImmDataUpdate(oldData);
      } else {
        // 判断是否含有沉浸态数据
        if (ImmBaseData.hasImmCard(ntf)) {
          let newData: ImmCardData = new ImmCardData(ntf);
          this.allCardData.set(ntf.groupKey, newData);
          // 新增数据回调
          this.onImmDataAdd(newData);
        }
      }
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
      let oldData = this.allCardData.get(ntf.groupKey);
      if (oldData) {
        // 统一按更新数据处理
        this.checkCardData.set(CardShowType.CARD_UPDATE_OLD, oldData.copy());
        oldData.updateData(ntf);
        // 更新数据回调
        this.onImmDataUpdate(oldData);
      }
    });
  }

  /**
   * 初始化时，创建所有大卡条目状态
   */
  private createAllItemSt(): void {
    let helperVm = this.getItemHelperVm();
    CARD_ALL_TYPE.forEach((cardType) => {
      // 条目动效状态新增
      CARD_ALL_ANIM_SF.forEach((sf) => {
        let animHelper = helperVm?.getCardAnimH(sf);
        animHelper?.addItemSt(cardType);
      });
      // 条目样式状态新增
      CARD_ALL_STYLE_SF.forEach((sf) => {
        let styleHelper = helperVm?.getCardStyleH(sf);
        styleHelper?.addItemSt(cardType);
      });
      // 条目缓存状态新增
      CARD_ALL_CACHE_SF.forEach((sf) => {
        let cacheHelper = helperVm?.getCardCacheH(sf);
        cacheHelper?.addItemSt(cardType);
      });
    });
  }

  protected getLiveCardStyle(): WidgetStyleStateV2 | undefined {
    let liveHelper = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_LIVE_STYLE);
    return liveHelper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  protected getLiveCardCache(): WidgetCacheState | undefined {
    let liveHelper = this.getItemHelperVm()?.getCardCacheH(CardCacheSuffix.ITEM_LIVE_CACHE);
    return liveHelper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  protected getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }

  protected getCardAnimVm(): IImmersiveCardAnimVm {
    return this.vmInjector?.getImmersiveCardAnimVm();
  }

  protected getCardHandle(): IImmersiveCardHandle {
    return this.vmInjector?.getImmersiveCardHandle();
  }

  protected getCardAnimChainVm(): ICardAnimChainVm {
    return this.vmInjector?.getImmCardAnimChainVm();
  }

  protected getWholeAnimVm(): IImmersiveWholeAnimVm {
    return this.vmInjector?.getImmersiveWholeAnimVm();
  }

  protected getImmDataVm(): IImmersiveDataVm {
    return this.vmInjector?.getImmDataVm();
  }

  protected getImmComVm(): IImmComVm {
    return this.vmInjector?.getImmComVm();
  }
}