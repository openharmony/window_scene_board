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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import {
  DisplayUtils,
  ISlStateChangeListener,
  ListStaticStateType,
  ListWgBindStateType,
  MeshRange,
  SlMainStateType,
  SlSubStateType,
  slUiStateMgr,
} from '@ohos/screenlockcommon';
import { SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ScreenLockFsmProxy, EventCallback } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import {
  CoreStateType,
  CoreStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { ClockAdapter } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import {
  immersiveKgMgr,
  ImmersiveAodStyle,
  ImmersiveState,
  ImmersiveType,
  IState,
  OnStateChangeListener,
  StateType,
} from '@ohos/systemuicommon';
import { immersiveVm } from '@ohos/immersivekeyguard/src/main/ets/viewmodel/ImmersiveVm';
import { curves, display } from '@kit.ArkUI';
import { v2Helper } from '@ohos/immersivekeyguard';
import Constants, { SlGreetStateListener } from '@ohos/screenlockcomponent/src/main/ets/greet/constant/Constants';
import { screenLockGreetModel } from '@ohos/screenlockcomponent/src/main/ets/greet/model/ScreenLockGreetModel';
import { ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { IClockThemeStyleChange } from '@ohos/screenlockwidget/src/main/ets/common/interface/IClockThemeStyleChange';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { ClockThemeHelper } from '@ohos/screenlockwidget/src/main/ets/common/helper/ClockThemeHelper';

const TAG = 'MainPageHeightManger';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const CLOCK_SAFETY_MARGIN = 16; // 时钟与通知列表的安全间距
const NTF_LIST_MARGIN_BOTTOM = 100; // 通知列表的底部间距
const SCREEN_LOCK_HEAD_ICON_ID = 'sl_lock_head'; // 锁头的组件ID
// 正常时钟最大网格个数
const MAX_GRID_AMOUNT_NORMAL = 10;

/**
 * 主页组件高度管理器
 */
export class MainPageHeightManger {
  private persistentId: number;
  // 锁屏通知状态 胶囊态、列表态、沉浸态
  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
  // 锁屏主页面时钟组件适配器
  private kgClockAdapter: ClockAdapter = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE);
  // 全屏AOD时钟组件适配器
  private aodAlockAdapter: ClockAdapter = ClockAdapterFactory.wrapper(UseScene.AOD_FULL_SCREEN);
  // 通知列表条目总高度
  private itemHeightSum: number = 0;
  // 是否锁屏编辑状态
  private isKgEditor: boolean = false;
  // 问候语模式状态
  private isGreetShow: boolean = false;
  // 是否处于AOD状态
  private aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);
  // 是否显示艺术签名文本
  private isShowArtSign: boolean = true;

  private onClockThemeStyleChange: IClockThemeStyleChange = {
    onClockThemeChange: (clockStyle: AnyClock, gridWidth?: number): void => {
      if (this.isDigitalClock()) {
        log.showInfo(TAG, `no need handle for digtal`);
        return;
      }
      if (this.immersiveState.immersiveType === ImmersiveType.TYPE_IMMERSIVE) {
        //沉浸态场景时钟样式切换时进行更新
        this.clockCollapseAnim();
      }
    }
  };

  // 沉浸状态切换监听
  private onStateChange: OnStateChangeListener = {
    onStateChange: (state: IState): void => {
      switch (state.getStateType()) {
        case StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE:
          this.immersiveState = state as ImmersiveState;
          log.showInfo(TAG, `on immersive state change, immersiveType is ${this.immersiveState?.immersiveType}`);
          this.checkClockState();
          break;
        default:
          break;
      }
    }
  };

  // 锁屏通知高度监听
  private onScreenLockStateChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_LIST_WG_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ListStaticStateType.NTF_LIST_ITEM_HEIGHT_SUM) {
        this.itemHeightSum = slUiStateMgr.getSlState(SlMainStateType.SL_LIST_WG_STATIC_STATE)?.getSlState(
          ListStaticStateType.NTF_LIST_ITEM_HEIGHT_SUM) as number;
        log.showWarn(TAG, `onScreenLockStateChange new height = ${this.itemHeightSum}`);
        if (this.isDigitalClock() || this.immersiveState.immersiveType !== ImmersiveType.TYPE_LIST || this.isKgEditor) {
          return;
        }
        this.checkClockNtfHeight(true);
      }
    }
  }

  // 通知列表显示区域监听
  private onImmersiveListChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_LIST_WG_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ListWgBindStateType.SHOW_AREA || subType === ListWgBindStateType.NTF_LIST_ITEM_HEIGHT_MAX) {
        if (this.isDigitalClock() || !immersiveKgMgr.getImmersiveKeyguardState()?.immersiveState?.isList() ||
          this.isKgEditor) {
          return;
        }
        log.showWarn(TAG, 'onImmersiveListChange');
        this.checkClockNtfHeight(true);
      }
    }
  }

  // 问候语监听
  private onGreetStateChange: SlGreetStateListener = {
    onGreetShow: (isAni?: boolean): void => {
      this.isGreetShow = true;
      if (this.isDigitalClock()) {
        return;
      }
      log.showInfo(TAG, 'on greet show, collapse clock.');
      this.clockCollapseAnim();
    },
    onGreetHide: (isAni?: boolean): void => {
      this.isGreetShow = false;
      if (this.isDigitalClock() || this.isKgEditor) {
        return;
      }
      log.showInfo(TAG, 'on greet hide, check clock height.');
      if (this.immersiveState.immersiveType === ImmersiveType.TYPE_LIST) {
        this.checkClockNtfHeight();
      }
    }
  }

  // 编辑界面监听
  private readonly _screenLockStateListener: EventCallback<CoreStateType> = {
    onEventFinish: (oldState: CoreStateType, newState: CoreStateType): void => {
      if (CoreStateTypeUtils.isInEditMainPage(newState)) {
        this.onEnterEditor();
      } else if (CoreStateTypeUtils.isInMainPage(newState)) {
        this.isKgEditor = false;
        this.checkClockState();
      } else {
        log.showInfo(TAG, 'other keyguard state');
        this.isKgEditor = false;
      }
    }
  }

  constructor(persistentId: number) {
    this.persistentId = persistentId;
  }

  init(): void {
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
    slUiStateMgr.registerSlStateChangeListener(this.onScreenLockStateChange);
    slUiStateMgr.registerSlStateChangeListener(this.onImmersiveListChange);
    screenLockGreetModel.registerStateChangeListener(Constants.ART_SIGN_LISTENER, this.onGreetStateChange);
    ScreenLockFsmProxy.getInstance(this.persistentId).registerCoreEventCallback(this._screenLockStateListener);
    ClockThemeHelper.getInstance().registerClockThemeStyleListener(this.onClockThemeStyleChange);
  }

  destroy(): void {
    immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
    slUiStateMgr.unregisterSlStateChangeListener(this.onScreenLockStateChange);
    slUiStateMgr.unregisterSlStateChangeListener(this.onImmersiveListChange);
    screenLockGreetModel.unRegisterStateChangeListener(Constants.ART_SIGN_LISTENER, this.onGreetStateChange);
    ScreenLockFsmProxy.getInstance(this.persistentId).unregisterCoreEventCallback(this._screenLockStateListener);
    ClockThemeHelper.getInstance().unregisterClockThemeStyleListener(this.onClockThemeStyleChange);
  }

  private checkClockState(): void {
    log.showInfo(TAG, `checkClockState immersiveType=${this.immersiveState.immersiveType}, ${this.isGreetShow}`);
    if (this.isDigitalClock()) {
      return;
    }
    // 问候语场景，收起时钟
    if (this.isGreetShow) {
      this.clockCollapseAnim();
      return;
    }
    if (this.immersiveState.immersiveType === ImmersiveType.TYPE_CAPSULE) {
      this.clockExpandAnim();
    } else if (this.immersiveState.immersiveType === ImmersiveType.TYPE_IMMERSIVE) {
      this.clockCollapseAnim();
    } else {
      this.checkClockNtfHeight();
    }
  }

  private onEnterEditor(): void {
    log.showInfo(TAG, 'onEnterEditor');
    this.isKgEditor = true;
    if (this.isDigitalClock()) {
      return;
    }
  }

  // 计算时钟与通知列表的高度
  private checkClockNtfHeight(isListChange: boolean = false): void {
    if (this.itemHeightSum <= 0) {
      this.clockExpandAnim();
      // 列表底部对齐
      this.updateListReachMax(false);
      return;
    }
    // 屏幕缩放比例
    let displayScale = this.kgClockAdapter.getClockWidgetModel().getClockStaticState().displayScale;
    let clockBottomMargin = displayScale *
      (this.kgClockAdapter.getClockWidgetModel().getClockStaticState().expandGrid?.clockBottomMargin ?? 0);
    this.updateCollapseState(clockBottomMargin, isListChange);
  }

  /**
   * 检查通知列表当前的高度在底部对齐后，是否与时钟展开的处于安全间距内
   * @param clockBottomMargin 当前时钟样式展开态时，时钟基于父布局的底部偏移量
   */
  private updateCollapseState(clockBottomMargin: number, isListChange: boolean = false): void {
    // 通知列表底部对齐后高度 = 屏幕高度 - (小工具的固定高度(100) + 列表底部padding + 列表高度)
    let curDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
    if (!curDisplay) {
      return;
    }
    let displayHeight = px2vp(curDisplay.height);
    let ntfListHeight = displayHeight - (this.getListBottomPadding() + NTF_LIST_MARGIN_BOTTOM + this.itemHeightSum);
    // 时钟Y轴宫格位置
    let clockPosY = this.kgClockAdapter.getDataManager().getSlClockBindState().getPositionY() ?? 0;
    // 单宫格高度
    let singleGridHeight = this.kgClockAdapter.getClockWidgetModel().getClockStaticState().layoutGridWidth;
    // 屏幕缩放比例
    let displayScale = this.kgClockAdapter.getClockWidgetModel().getClockStaticState().displayScale;
    // 时钟展开后的真实位置 = 锁头位置 + 宫格偏移量 + 宫格配置高度 * 屏幕缩放比例 - 时钟基于父布局的底部偏移量
    let clockGridHeight =
      this.kgClockAdapter.getClockWidgetModel().getClockStaticState().expandGrid?.gridHeightSize ?? 0;
    // 排除时钟动态间距
    let clockDyMargin = this.kgClockAdapter.getDataManager().getSlClockBindState()?.getTopExpandDynamicMargin() ?? 0;
    let clockTotalHeight = clockDyMargin + clockGridHeight * displayScale;
    let expandClockBottomPos =
      this.getLockIconBottom() + clockPosY * singleGridHeight + clockTotalHeight - clockBottomMargin;
    log.showInfo(TAG, `ntfListHeight = ${ntfListHeight}, expandClockBottomPos=${expandClockBottomPos},` + `
       clockPosY=${clockPosY} singleGridHeight=${singleGridHeight} clockGridHeight=${clockGridHeight} ` + `
       displayHeight=${displayHeight}, oriH:${curDisplay.height}, ${clockDyMargin}, ${displayScale}`);
    if (ntfListHeight - 8 - expandClockBottomPos > CLOCK_SAFETY_MARGIN) {
      this.clockExpandAnim();
      // 列表底部对齐
      this.updateListReachMax(false);
    } else {
      this.clockCollapseAnim();
      // 列表顶部对齐
      this.updateListReachMax(true);
    }
  }

  // 收起时钟的动效
  private clockCollapseAnim(): void {
    this.setClockCollapse();
  }

  // 展开时钟的动效
  private clockExpandAnim(): void {
    this.setClockExpand();
  }


  // 设置时钟到折叠态
  private setClockCollapse(): void {
    let meshRange: MeshRange = new MeshRange(0, 1);
    this.kgClockAdapter.getClockWidgetModel().onMeshUsageChange(meshRange, () => {});
    this.aodAlockAdapter.getClockWidgetModel().onMeshUsageChange(meshRange, () => {});
  }

  // 设置时钟到展开态
  private setClockExpand(): void {
    let meshRange: MeshRange = new MeshRange(0, MAX_GRID_AMOUNT_NORMAL);
    this.kgClockAdapter.getClockWidgetModel().onMeshUsageChange(meshRange, () => {});
    this.aodAlockAdapter.getClockWidgetModel().onMeshUsageChange(meshRange, () => {});
  }



  private getListBottomPadding(): number {
    if (SlStateBaseMgr.isV2Enable()) {
      return v2Helper.getV2Hook()?.getListBottomPadding();
    }
    return immersiveVm.getImmersiveMeshManager()?.getListBottomPadding();
  }

  private updateListReachMax(isReachMax: boolean): void {
    if (SlStateBaseMgr.isV2Enable()) {
      v2Helper.getV2Hook()?.updateListReachMax(isReachMax);
    } else {
      if (isReachMax) {
        immersiveVm.getImmersiveMeshManager()?.updateListReachMax(isReachMax);
        return;
      }
      let isNtfReachMax = immersiveVm.getImmersiveMeshManager()?.checkNtfListHeightMax();
      immersiveVm.getImmersiveMeshManager()?.updateListReachMax(isNtfReachMax, true);
    }
  }

  private getLockIconBottom(): number {
    let lockIconRect = ItemUtils.getRectById(SCREEN_LOCK_HEAD_ICON_ID);
    return lockIconRect.bottom;
  }

  // 是否数字时钟场景，若为数字时钟，由网格管理类控制
  private isDigitalClock(): boolean {
    return this.kgClockAdapter.getDataManager().getSlClockBindState()
      .getClockLayout() < 200;
  }
}