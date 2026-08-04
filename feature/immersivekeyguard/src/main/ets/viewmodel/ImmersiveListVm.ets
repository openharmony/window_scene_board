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

import { LogDomain, LogHelper, ArrayUtils } from '@ohos/basicutils';
import {
  obtainLocalEvent,
  ScreenOnOffEvent,
  sEventManager,
  EventConstants,
  EvtBus
} from '@ohos/frameworkwrapper';
import {
  AccessibilityUtil,
  IState,
  StateType,
  OnStateChangeListener,
  immersiveKgMgr,
  ILiveIconClickListener,
  ImmersiveState,
  ImmersiveType,
  ImmersiveTypeScene,
  LiveUseScene,
  SceneFlag,
  bannerMgr,
  EnableBackGestureEvent
} from '@ohos/systemuicommon';
import { NotificationConstants } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConstants';
import { notificationStyle } from '@ohos/notificationcomponent/src/main/ets/vm/style/NotificationStyle';
import { NtfColorModeConfig, NtfColorModeVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfColorModeVM';
import {
  CcmOption,
  ClockStaticStateType,
  ScreenLockApi,
  SlAreaType,
  SlVisualControl,
  SolidColorListener,
  UserSwitchService,
  WAnimProperty
} from '@ohos/screenlockcommon';
import { IBaseStateChangeListener, SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { ImmersiveAnimScene } from '../common/anim/ImmersiveAnimConstants';
import { ImmersiveConstants } from '../common/ImmersiveConstants';
import { immersiveStateMgr } from '../common/manager/ImmersiveStateManager';
import { ImmersiveAnimManager } from './viewanim/ImmersiveAnimManager';
import { ImmersiveNtfData } from './viewdata/ImmersiveNtfData';
import { NotificationEntryArray } from './viewdata/NotificationEntryArray';
import { NtfListBindState, NtfListStaticState } from './viewdata/NtfListState';
import { NtfListInfoKeyGuard, NtfListKeyGuard } from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { ImmersiveListAnimManager } from './viewanim/ImmersiveListAnimManager';
import { ImmersiveMeshManager } from './viewlayout/ImmersiveMeshManager';
import { immersiveFgCtrl } from '../model/service/ImmersiveFingerControll';
import { ImmersiveSysEventUtil, StatusParams, ToggleWay } from '../common/ImmersiveSysEventUtil';
import { osAccount } from '@kit.BasicServicesKit';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { fontScaleManager, FontScaleState } from '@ohos/systemuicommon';
import {
  NotificationAnimationParas,
  OnItemPreSizeChange
} from '@ohos/notificationcomponent/src/main/ets/common/NotificationAnimationParas';

import { interruptHelper } from '../common/helper/ImmersiveInterruptHelper';
import { ImmersivePanelState } from './viewdata/ImmersivePanelState';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import {
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { immersiveStateHelper } from '../common/helper/ImmersiveStateHelper';
import { SlListWidgetBindState } from '../model/data/SlListWidgetBindState';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';

const TAG = 'ImmersiveListVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏默认阴影样式
 */
const ITEM_SHADOW_STYLE: ShadowOptions = {
  radius: 30, // 半径
  color: '#19000000',
  offsetX: 0,
  offsetY: 10
};

// 数据更新动效曲线
const UPDATE_ANIM: AnimateParam = { duration: 350, curve: Curve.Friction };

const TOP_OFFSET = 0.01; // 触顶偏移误差

/**
 * 沉浸实况卡片图标点击监听回调
 */
class ImmersiveLiveIconClickListener implements ILiveIconClickListener {
  /**
   * 条目数据
   */
  private itemData?: ImmersiveNtfData;

  /**
   * 点击监听
   */
  private clickListener?: ( type: LiveUseScene, itemData?: ImmersiveNtfData) => void;

  /**
   * 构造
   *
   * @param itemData 条目数据
   * @param clickListener 点击监听
   */
  constructor(itemData?: ImmersiveNtfData, clickListener?: (type: LiveUseScene, itemData?: ImmersiveNtfData) => void) {
    this.itemData = itemData;
    this.clickListener = clickListener;
  }

  /**
   * 复写ILiveIconClickListener
   *
   * @param groupKey 条目标识
   */
  onIconClick( type: LiveUseScene, groupKey: string,): void {
    this.clickListener?.(type, this.itemData);
  }
}

/**
 * 沉浸列表业务管控
 */
export class ImmersiveListVm {
  /**
   * 不需要进行数据刷新拦截的动效列表
   */
  private readonly noNeedInterruptAnimScenes: Array<string> = [
    ImmersiveConstants.IMMERSIVE_ONE_MIRROR_SCENE,
  ];

  /**
   * 锁屏通知列表数据
   */
  private ntfList: NotificationEntryArray = new NotificationEntryArray();

  /**
   * 锁屏通知列表非UI绑定状态
   */
  private staticState: NtfListStaticState = new NtfListStaticState();

  /**
   * 锁屏通知列表UI绑定状态
   */
  private bindState: NtfListBindState = new NtfListBindState();

  /**
   * 沉浸列表面板状态
   */
  private panelState: ImmersivePanelState = new ImmersivePanelState();

  /**
   * 沉浸状态
   */
  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  /**
   * 沉浸锁屏动效管理
   */
  private immersiveAnimMgr: ImmersiveAnimManager;

  /**
   * 列表动效管理
   */
  private listAnimMgr?: ImmersiveListAnimManager;

  /**
   * 当前沉浸类型
   */
  private curImmersiveType: ImmersiveType = ImmersiveType.TYPE_LIST;

  /**
   * VM，通知数据
   */
  private ntfListVM: NtfListKeyGuard | undefined = undefined;

  /**
   * 沉浸面板网格管理
   */
  private meshMgr: ImmersiveMeshManager;

  private colorModeVM: NtfColorModeVM = new NtfColorModeVM();

  /**
   * 长辈模式字体
   */
  private fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  /**
   * 条目图标点击监听
   */
  private onIconClick = (type: LiveUseScene, itemData?: ImmersiveNtfData ): void => {
    log.showWarn(`onIconClick hashCode：${itemData?.hashCode} type：${type}`);
    if (!type) {
      log.showWarn('click failed：type is invalid');
      return;
    }
    if (type === LiveUseScene.SCENE_SCREEN_LOCK || type === LiveUseScene.SCENE_LIVE_LIST) {
      let canImmersive = itemData?.shouldShowInImmersiveCard();
      if (!canImmersive) {
        log.showWarn(`onIconClick canImmersive false ${itemData?.hashCode}`);
        return;
      }
      this.checkBeforeToCard(itemData, type);
    }
  };

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
          this.onImmersiveTypeChange(state as ImmersiveState);
          break;
        default:
          break;
      }
    }
  };

  /**
   * 条目大小预切换
   */
  private onItemPreSizeChange: OnItemPreSizeChange = (paras: NotificationAnimationParas, isForceAnim?: boolean) => {
    this.staticState.updateChangeItemParas(paras);
    this.staticState.updateItemAnim(paras.getClipAnim(), isForceAnim);
  };

  /**
   * 监听列表动效状态切换
   */
  private onRootStateChange: IBaseStateChangeListener = {
    onStateChange: (stateType, stateId, property) => {
      if (property === WAnimProperty.ANIMATING) { // 动效状态切换
        this.onRootStateAnimatingChange();
      }
    }
  };
  /**
   * 屏幕亮灭监听回调
   */
  private onScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    if (event.isScreenOff()) {
      this.swipeItemToCollapse(true);
    } else if (event.isScreenOn() && this.immersiveState.isList() && this.ntfList.length > 0) {
      // 亮屏列表态、有通知则同步状态到锁屏
      this.updateListCollapsedState(false);
    }
  };

  /**
   * 监听竖屏状态
   */
  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION) {
        this.updatePanelPaddingTop();
      }
    }
  };

  /**
   * 时钟可见性状态
   */
  private slClockStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockStaticStateType.CLOCK_VISIBLE_STATE) {
        let clockSt = immersiveStateHelper.getSlClockBindState();
        let isClockVisible = clockSt?.getSlState(subType) as boolean ?? true;
        if (isClockVisible) {
          this.updatePanelPaddingTop();
        } else {
          // 三方主题，时钟不可见时，固定顶部间距
          this.resetPanelPaddingTop();
        }
      }
    }
  };

  /**
   * 构造
   *
   * @param animMgr 动效管理器
   */
  constructor(animMgr: ImmersiveAnimManager, meshMgr: ImmersiveMeshManager) {
    this.immersiveAnimMgr = animMgr;
    this.listAnimMgr = animMgr.getListAnimMgr();
    this.listAnimMgr?.setImmersiveListData(this.ntfList);
    this.listAnimMgr?.setListStaticState(this.staticState);
    this.listAnimMgr?.setListBindState(this.bindState);
    this.meshMgr = meshMgr;
    this.meshMgr?.setListAnimMgr(this.listAnimMgr);
    this.meshMgr?.setPanelState(this.panelState);
    this.meshMgr?.setListState(this.bindState, this.staticState);
    // 监听沉浸锁屏类型切换
    this.curImmersiveType = this.immersiveState.immersiveType;
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
    slUiStateMgr.registerSlStateChangeListener(this.slClockStateListener);
    this.updatePanelPaddingTop();
  }

  /**
   * 组件挂载
   */
  appear(ntfListVM: NtfListKeyGuard | undefined): void {
    // 锁屏通知增加阴影效果
    notificationStyle.item.setShadowOptions(ITEM_SHADOW_STYLE);
    // 设置锁屏通知隐藏样式
    notificationStyle.item.setHideNtfContentStyle(this.fontScaleState.getScaleSize($r('app.float.immersive_text_title_height')),
      {
        top: $r('app.float.immersive_hide_content_margin_top')
      });
    this.ntfListVM = ntfListVM;
    this.ntfListVM?.getNtfListAdapter()?.registerDataChangeListener(this);
    let ntfListInfo: NtfListInfoKeyGuard | undefined = this.ntfListVM?.getLockScreenListInfo();
    let newList = ntfListInfo?.ntfList ?? [];
    let delItem = this.initNtfList(newList);
    this.setNtfList(newList);
    this.checkDeleteItem(delItem);

    this.staticState.eventMgr.on(ScreenOnOffEvent, this.onScreenOnOffEvent);
    sEventManager.subscribe(EventConstants.SCREEN_LOCK_BEGIN_SLEEP, () => {
      this.swipeItemToCollapse(true);
      this.groupItemToCollapse();
    });

    const lightConfig: NtfColorModeConfig = {
      bgBrightnessOption: BrightnessOptionUtils.keyguardCardOption,
      foregroundDividerOption: BrightnessOptionUtils.getInstance().foregroundDividerOption
    };
    const darkConfig: NtfColorModeConfig = {
      bgBrightnessOption: BrightnessOptionUtils.keyguardCardDarkOption,
      foregroundDividerOption: BrightnessOptionUtils.getInstance().foregroundDividerDarkOption
    };
    this.colorModeVM.init(lightConfig, darkConfig);
    if (this.getSolidEnable()) {
      SlVisualControl.getInstance().registerSolidListener(SlAreaType.NTF_LIST, this.solidListener);
    }
    // 监听列表动效状态
    this.listAnimMgr?.getRootAnimState()?.registerStateChangeListener?.(this.onRootStateChange);
  }

  /**
   * 监听纯色模式刷新，触发通知列表元素颜色刷新
   */
  private solidListener: SolidColorListener = {
    onColorChange: () => {
      let solidEnable: boolean = this.getSolidEnable();
      let isInCardMode: boolean = this.immersiveState.isShowCard();
      if (!solidEnable || isInCardMode) {
        log.showInfo(`Background color remains unchanged for current mode is not solid ${solidEnable} or ` +
          `immersive state is in card mode ${isInCardMode}`);
        return;
      }
      let backColor = SlVisualControl.getInstance().getCurBackColorByType(SlAreaType.NTF_LIST);
      log.showInfo('solidListener update solid color');
      this.colorModeVM.updateScreenLockColor(backColor);
    }
  }

  /**
   * 纯色模式下，由于模糊提亮关闭，需要单独适配AOD场景下通知列表背板颜色
   */
  updateBackColorForAod(): void {
    if (!this.getSolidEnable()) {
      return;
    }

    let aodStyle = immersiveKgMgr.getOneMirrorState().getAodStyle(true);
    if (!aodStyle) {
      return;
    }
    if (aodStyle.isAod) {
      log.showInfo('updateBackColorForAod, in aod');
      this.colorModeVM.isNeedShowBackColorForAod = true;
    } else {
      log.showInfo('updateBackColorForAod, exit aod');
      this.colorModeVM.isNeedShowBackColorForAod = false
      this.solidListener.onColorChange();
    }
  }

  getSolidColorListener(): SolidColorListener {
    return this.solidListener;
  }

  getSolidEnable(): boolean {
    return SlVisualControl.getInstance().getEnable(CcmOption.SOLID, SlAreaType.NTF_LIST);
  }
  /**
   * 组件解挂载
   */
  disappear(): void {
    // 回收阴影效果
    notificationStyle.item.setShadowOptions();
    // 回收锁屏通隐藏通知样式设置
    notificationStyle.item.setHideNtfContentStyle();
    this.ntfListVM?.getNtfListAdapter()?.unregisterDataChangeListener(this);
    this.staticState.eventMgr.offAll();
    if (this.getSolidEnable()) {
      SlVisualControl.getInstance().unregisterSolidListener(SlAreaType.NTF_LIST, this.solidListener);
      this.solidListener.onColorChange();
    }
    this.colorModeVM.deinit();
  }

  /**
   * 列表面板状态管理器
   *
   * @returns 面板状态
   */
  getPanelState(): ImmersivePanelState {
    return this.panelState;
  }

  /**
   * 获取通知列表数据
   *
   * @returns 通知列表数据
   */
  getNtfList(): NotificationEntryArray {
    return this.ntfList;
  }

  /**
   * 设置通知列表数据
   *
   * @param list 通知列表数据
   */
  setNtfList(list: NotificationEntry[]): void {
    ArrayUtils.clearArr(this.ntfList);
    this.ntfList.push(...list);
    this.immersiveState.ntfNum = this.ntfList.length;
  }

  /**
   * 获取非UI绑定状态管理
   *
   * @returns 静态状态管理
   */
  getListStaticState(): NtfListStaticState {
    return this.staticState;
  }

  /**
   * 获取UI绑定状态管理
   *
   * @returns 动态状态管理
   */
  getListBindState(): NtfListBindState {
    return this.bindState;
  }

  /**
   * 获取列表滑动控制器
   *
   * @returns 滑动控制器
   */
  getListScroller(): Scroller {
    return this.staticState.getListScroller();
  }

  /**
   * 获取通知卡片颜色背景配置对象
   *
   * @returns 卡片颜色背景配置对象
   */
  getColorModeVM(): NtfColorModeVM {
    return this.colorModeVM;
  }

  /**
   * 获取条目图标点击监听器
   *
   * @param itemData 条目数据
   * @returns 监听器
   */
  getIconClickListener(itemData?: ImmersiveNtfData): ILiveIconClickListener | undefined {
    if (SlStateBaseMgr.isV2Enable()) {
      return undefined;
    }
    return new ImmersiveLiveIconClickListener(itemData, this.onIconClick);
  }

  /**
   * 条目大小变化监听
   *
   * @param groupKey 条目标识
   * @param oldSize 旧大小
   * @param newSize 新大小
   */
  onItemSizeChange(groupKey: string, oldSize: SizeOptions, newSize: SizeOptions): void {
    // 缓存item卡片位置
    this.listAnimMgr?.setChildViewArea(groupKey, newSize);
    // 栅格计算
    this.meshMgr?.onListItemSizeChange(groupKey, oldSize, newSize);
    // 刷新叠加效果
    this.listAnimMgr?.updateListAnimParas({
      sizeChangeItem: groupKey,
      oldSize: oldSize?.height as number,
      newSize: newSize?.height as number,
      isResolveWait: !this.staticState.isListHeightChange
    }).then(() => {
      let clipHeight = this.bindState?.getNtfAnimPara(groupKey)?.ntfItemClipHeight;
      log.showWarn(`onItemSizeChange, groupKey: ${groupKey}, oldHeight: ${oldSize?.height},
      newHeight: ${newSize?.height}, clipHeight: ${clipHeight}`);
    });
    this.staticState.setListHeightChange(); // 清除标记
  }

  /**
   * 列表布局位置变化监听
   *
   * @param oldArea 旧位置
   * @param newArea 新位置
   */
  onListAreaChange(oldArea: Area, newArea: Area): void {
    this.setNtfListHeight(newArea.height as number);
    this.setBindStateHeight(newArea.height);
    let bindState = immersiveStateHelper.getSlListBindState() as SlListWidgetBindState;
    bindState.setArea(newArea);
    // 列表高度变化，条目翻转效果动效过渡
    if (oldArea.height !== newArea.height) {
      const isAod = immersiveKgMgr.getOneMirrorState().getAodStyle(true)?.isAod;
      if (this.immersiveState?.isShowList() && !isAod) {
        this.listAnimMgr?.onListHeightChange();
      }
      this.staticState.setListHeightChange(); // 高度已变化，清除标记
    }
    // 更新阴影
    if (oldArea?.width !== newArea?.width) {
      notificationStyle.item?.changeShadow();
    }
  }

  isListEmpty(): boolean { // 列表数据空
    return ArrayUtils.isEmpty(this.ntfList);
  }

  /**
   * 开始列表态到沉浸态
   *
   * @param ImmersiveNtfData 通知数据
   * @param isLongClick 是否是长按卡片场景
   */
  startListToCard(immersiveData?: ImmersiveNtfData, scene?: LiveUseScene) {
    if (!immersiveData) {
      log.showInfo('immersiveData isInvalid');
      return;
    }
    if (!this.immersiveState.isList()) {
      log.showInfo(`current status error ${this.immersiveState.immersiveType}`);
      return;
    }
    immersiveStateMgr.requestImmersiveCard(immersiveData);
    immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_IMMERSIVE);
    if (LiveUseScene.SCENE_LIVE_LIST === scene) {
      if (!SystemUICcmConfig.instance.isEnabledLive2) {
        bannerMgr.releasePanelLiveList(SceneFlag.SCENE_RELEASE_LIVE_LIST_BY_IMMERSIVE);
      }
      this.immersiveAnimMgr.startLiveListToImmeCardFixAnim(immersiveData?.hashCode);
    } else {
      this.immersiveAnimMgr.startList2CardFixAnim(immersiveData?.groupKey);
    }
    // 列表态切换到沉浸态，无障碍自动聚焦沉浸态卡片
    AccessibilityUtil.requestFocusAccessibility(ImmersiveConstants.IMMERSIVE_CARD_ITEM_ID);
    // 点击列表图标，进入沉浸态
    ImmersiveSysEventUtil.reportToggleStatusEvent(immersiveData, StatusParams.LIST, StatusParams.IMMERSIVE,
      ToggleWay.CLICK);
    ImmersiveSysEventUtil.reportEnterCpuMemEvent();
  }

  /**
   * 在开始列表态到沉浸态前进行类型和状态校验
   *
   * @param ImmersiveNtfData 通知数据
   */
  checkBeforeToCard(immersiveData?: ImmersiveNtfData, scene?: LiveUseScene): void {
    // 判断是否是UiExtension类型卡片
    if (!immersiveData?.isUiExtensionCard() || immersiveStateMgr.getUnlockedState()) {
      this.startListToCard(immersiveData, scene);
      return;
    }
    // 如果是Uiextension类型卡片判断开机后应用是否进行了第一次解锁
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    try {
      accountManager.isOsAccountUnlocked().then((isVerified: boolean) => {
        if (isVerified) {
          immersiveStateMgr.setUnlockedState();
          this.startListToCard(immersiveData, scene);
          return;
        }
        ScreenLockApi.requestUnlock();
      });
    } catch (err) {
      log.error('isOsAccountUnlocked exception');
    }
  }

  swipeItemToCollapse(isForceReset: boolean = false): void { // 侧滑通知状态复位
    sEventManager.publish(
      obtainLocalEvent(ScreenLockNotificationConst.SCREENLOCK_NTF_NEED_TO_SWIPE_TO_COLLAPSE, isForceReset));
  }

  groupItemToCollapse(isCollapseDirectly: boolean = true): void { // 展开组通知收起
    sEventManager.publish(obtainLocalEvent(NotificationConstants.ntfFoldGroupItem, isCollapseDirectly));
  }

  updateListCollapsedState(isCollapse: boolean = false): void { // 刷新列表收起到胶囊状态
    if (SlStateBaseMgr.isV2Enable()) {
      return;
    }
    EvtBus.post(EnableBackGestureEvent, new EnableBackGestureEvent(!isCollapse, TAG));
    this.swipeItemToCollapse(); // 同步侧滑复位
  }

  resetGroupItemToCollapse(): void { // 组通知复位收起，依赖沉浸状态
    if (this.immersiveState?.isCapsule()) {
      this.staticState.updateMeshInterrupt(interruptHelper.animCap2ListIt); // 栅格测量时，拦截胶囊过渡列表动效
      this.groupItemToCollapse();
    }
  }

  isListAtTop(): boolean { // 判断列表是否滚动在顶部
    let initOffset = this.staticState.getInitScrollOffset();
    let curOffset = this.staticState.getCurScrollOffset();
    return curOffset <= (initOffset + TOP_OFFSET);
  }

  /**
   * 列表滚动到顶部
   */
  scrollListToTop(): void {
    const listLength: number = this.ntfList.length;
    if (listLength == 0) {
      return;
    }
    this.getListScroller().scrollTo({ xOffset: 0, yOffset: this.staticState.getInitScrollOffset() });
  }

  /**
   * 列表滚动到底部
   */
  scrollListToBottom(): void {
    const listLength: number = this.ntfList.length;
    if (listLength == 0) {
      return;
    }
    this.getListScroller().scrollEdge(Edge.Bottom);
  }

  /**
   * 刷新锁屏通知列表数据
   *
   * @param ntfList 新的锁屏通知列表数据
   */
  updateListData(ntfList: Array<NotificationEntry>) {
    let isAod = immersiveKgMgr.getOneMirrorState().getAodStyle(true)?.isAod;
    let isContentChange = ntfList && ntfList !== this.ntfList;
    // 列表参数初始化，不参与动效
    let delItem = this.initNtfList(ntfList);
    let updateData = () => {
      if (isContentChange) { // 内容切换参与动效
        this.setNtfList(ntfList!);
      }
    };

    // 面板可见，非Aod，允许动效
    if (this.immersiveState.isShowList() && !isAod && UserSwitchService.getInstance().isCurrentUserActive) {
      let animParam: AnimateParam = { duration: 350, curve: Curve.Friction };
      this.staticState.updateItemAnim(animParam); // 列表数据变化场景，翻转效果动效过渡
      animateTo(animParam, () => updateData());
    } else {
      updateData();
    }
    // 数据更新完移除item，熄屏或非列表态强制刷新堆叠效果
    if (!this.checkDeleteItem(delItem, isAod)) {
      this.listAnimMgr?.updateListAnimParas({
        offset: 0,
        isResolveWait: true
      });
    }
  }

  /**
   * 通知List发生变化的回调
   *
   * @param dataSource 新的通知列表的数据
   */
  async onNtfListDataChange(dataSource: Array<NotificationEntry>): Promise<void> {
    await interruptHelper.ntfDataChangeIt.awaitInterrupt(); // 数据刷新拦截等待
    let ntfListInfo: NtfListInfoKeyGuard | undefined = this.ntfListVM?.getLockScreenListInfo();
    let lockScreenNtfList = ntfListInfo?.ntfList ?? [];
    let oldSize = ArrayUtils.getSize(this.ntfList);
    let newSize = ArrayUtils.getSize(lockScreenNtfList);
    if (newSize === 0) {
      let delItem = this.initNtfList(lockScreenNtfList);
      this.setNtfList(lockScreenNtfList);
      this.checkDeleteItem(delItem);
      // 如果已经没有通知,重新获取通知默认的显示状态
      immersiveStateMgr.switchImmersiveState(immersiveKgMgr.getDefaultImmersiveType());
      log.showInfo(`ImmersiveType: ${immersiveKgMgr.getDefaultImmersiveType()}`);
      return;
    } else if (this.immersiveState.isShowList() && oldSize === 0 && newSize > 0) {
      // 列表态从无通知到来通知场景(如低指纹开启, 无胶囊态时), 需要通知锁屏
      this.updateListCollapsedState(false);
    }
    this.updateListData(lockScreenNtfList);
    if (oldSize === 0 && newSize > 0) { // 数据从无到有，保持顶部
      this.scrollListToTop();
    }
  }

  /**
   * 更新锁屏通知面板的高度
   *
   * @param height 锁屏通知面板的高度
   */
  setNtfListHeight(height: number): void {
    if (this.staticState.notificationListHeight !== height) {
      this.staticState.notificationListHeight = height;
    }
  }

  /**
   * 更新BindState 通知Height
   */
  setBindStateHeight(height: Length): void {
    if (this.bindState.listRealHeight !== height) {
      this.bindState.listRealHeight = height;
    }
  }

  /**
   * 更新list显示的index范围
   *
   * @param start List显示区域内第一个子组件的索引值
   * @param end List显示区域内最后一个子组件的索引值
   */
  updateScrollIndex(start: number, end: number): void {
    this.staticState.startItemIndex = start;
    this.staticState.endItemIndex = end;
  }

  /**
   * 重置顶部边距值
   */
  resetPanelPaddingTop(): void {
    this.panelState.resetPaddingTop();
  }

  /**
   * 更新面板顶部间距
   */
  updatePanelPaddingTop(): void {
    let slStaticState = immersiveStateHelper.getSlStaticState();
    let region = slStaticState?.getSlState(SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION) as Rectangle;
    let clockHeight = region?.height as number ?? 0;
    if (clockHeight !== 0) {
      this.panelState.paddingTop = clockHeight;
    }
  }

  /**
   * 初始化锁屏通知列表
   */
  private initNtfList(list: NotificationEntry[]): Map<string, number> {
    let keyIndex: Map<string, number> = new Map();
    list?.forEach((entry, index) => {
      // 动效参数初始化
      let key = entry.getGroupKey();
      this.bindState.getNtfAnimPara(key, this.onItemPreSizeChange);
      // 缓存最新条目索引
      keyIndex.set(key, index);
      // 清除索引
      this.staticState.groupKeyIndexMap?.delete(key);
    });
    // 余下的索引表示被删除的条目
    let delItem = this.staticState.groupKeyIndexMap;
    // 新的键值索引映射关系
    this.staticState.groupKeyIndexMap = keyIndex;
    this.meshMgr?.onListItemKeysChange(keyIndex);
    return delItem;
  }

  private checkDeleteItem(delItems?: Map<string, number>, isForceUpdate: boolean = false): boolean {
    let hasUpdateAnim = false;
    // 删除条目处理
    delItems?.forEach((itemIndex, itemKey) => {
      // 删除条目按sizeChange处理
      let oldSize = this.listAnimMgr?.getChildViewPosition(itemKey)?.height ?? 0;
      this.listAnimMgr?.removeChildAnimState(itemKey);
      this.bindState.delNtfAnimPara(itemKey);
      if (this.staticState.itemUpdateAnim || isForceUpdate) { // 动效未消费
        this.listAnimMgr?.updateListAnimParas({
          sizeChangeItem: itemKey,
          oldSize: oldSize,
          newSize: -1, // 确保高度变化
          isResolveWait: true
        });
        hasUpdateAnim = true;
      }
    });
    return hasUpdateAnim;
  }

  private isInterruptAnimating(): boolean {
    // 特殊动效场景，不拦截数据刷新
    for (let value of this.noNeedInterruptAnimScenes) {
      if (this.listAnimMgr?.getRootAnimState().isSceneAnimating(value)) {
        return false;
      }
    }

    if (this.listAnimMgr?.getRootAnimState().isSceneAnimating()) {
      return true;
    }

    return false;
  }

  private onRootStateAnimatingChange(): void { // 动效状态切换
    if (this.isInterruptAnimating()) { // 动效中，拦截数据刷新
      interruptHelper.ntfDataChangeIt.requestInterrupt();
      return;
    }
    const timeoutId = setTimeout(() => {
      // 非动效中，则放开数据刷新
      if (!this.listAnimMgr?.getRootAnimState().isSceneAnimating()) {
        interruptHelper.ntfDataChangeIt.releaseInterrupt();
        clearTimeout(timeoutId);
      }
    });
  }

  /**
   * 沉浸类型状态切换
   *
   * @param state 沉浸类型
   */
  private onImmersiveTypeChange(state: ImmersiveState): void {
    let preType = this.curImmersiveType;
    let curType = state.immersiveType;
    this.curImmersiveType = curType;
    // 沉浸类型切换，列表到胶囊，区分切换场景
    let isPreShowList = state.isShowList(preType);
    let isCurShowCap = state.isShowCapsule();
    if (!(isPreShowList && isCurShowCap)) {
      this.checkNotifyListCollapseState(state);
      return;
    }

    // 返回键切换，动效过渡
    let isBack = state.changeScene === ImmersiveTypeScene.SCENE_GESTURE_BACK;
    if (isBack) {
      // 动效期间，屏蔽指纹显示
      let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX;
      immersiveFgCtrl.addFingerHideScene(scene);
      this.immersiveAnimMgr.startList2CapsuleFixAnim(0, undefined, () => {
        setTimeout(() => {
          this.resetListIndexToTop();
          this.resetGroupItemToCollapse();
        });
        immersiveFgCtrl.removeFingerHideScene(scene);
      });
    }
    this.checkNotifyListCollapseState(state, isBack); // 滞后刷新
  }

  /**
   * 检测发送消息，列表收起到胶囊状态切换
   *
   * @param state
   * @param isListToCapsule
   */
  private checkNotifyListCollapseState(state: ImmersiveState, isListToCapsule: boolean = false): void {
    let isSkipGroupCollapse = isListToCapsule || state.changeScene === ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL;
    // 用于保持与锁屏时间交互, 后续布局算法替代后废弃
    if (state.isCapsule() || this.isListEmpty()) {
      this.updateListCollapsedState(true);
      // 切换到胶囊态时, 触发组通知收起，列表到胶囊例外
      if (!isSkipGroupCollapse) {
        this.groupItemToCollapse();
        this.scrollListToTop();
      }
    } else if (state.isShowList() || state.isImmersive()) {
      this.updateListCollapsedState(false);
    }
    // 条目数据更新动效，面板可见时允许动效
    notificationStyle.item.itemUpdateAnim = state.isShowList() ? UPDATE_ANIM : undefined;
  }

  private resetListIndexToTop(): void { // 列表位置置顶，依赖沉浸状态
    if (this.immersiveState?.isCapsule()) {
      this.scrollListToTop();
    }
  }
}