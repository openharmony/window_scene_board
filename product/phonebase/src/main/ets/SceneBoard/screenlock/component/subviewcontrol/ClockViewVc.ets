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

import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, sEventManager, sSettingsUtil } from '@ohos/frameworkwrapper';
import { IDofParam } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { ClockStaticStateType } from '@ohos/screenlockcommon';
import { EditBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  KeyGuardMode,
  NotificationStateManager,
  ScreenBp,
  slClockOneShotToDesktopService,
  SlStaticStateType,
  SlSubStateType,
  slUiStateMgr,
  slWallpaperMgr,
  SLWallpaperType,
  SLWallpaperVisibleScene,
  ISlStateChangeListener,
  SlMainStateType
} from '@ohos/screenlockcommon';
import { DisplayStateManager, ScreenLockHeadManager } from '@ohos/screenlockcommon/Index';
import {
  DofWallpaperStaticStateType,
  SlBindStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import ScreenLockThemeManager, {
  defaultClockParam,
} from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import {
  CLOCK_LAYOUT_REVERSE_CONSTANT,
  IThemeParam,
  LockscreenThemeConfig,
  BatteryLayout
} from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { AnyClock,
  CLOCK_DEFAULT_FOREGROUND_COLOR } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockLocateState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockLocateState';
import { MainPageVc } from '../../controller/MainPageVc';
import { ScreenLockVc } from '@ohos/screenlockcomponent/src/main/ets/common/ScreenLockVc';
import { slStateHelper } from '../../model/helper/SlStateHelper';
import {
  ClockChangeType,
  ClockWidgetModel
} from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/ClockWidgetModel';
import { SlBindState } from '../../model/data/SlBindState';
import ScreenLockFormPanelModel from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelModel';
import ClockWidgetConfig from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/ClockWidgeMeshConfig';
import ScreenLockFormPanelMeshConfig from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelMeshConfig';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { SpecialModeViewData } from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import {
  KEY_OWNER_INFO,
  KEY_OWNER_INFO_SWITCH
} from '@ohos/screenlockcomponent/src/main/ets/datarestore/ScreenLockDataRestoreModule';
import { MainColor } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/MainColor';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import MultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import sMultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import { immersiveVm } from '@ohos/immersivekeyguard/src/main/ets/viewmodel/ImmersiveVm';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import lazy { OuterHomeManagerUtil } from '../../utils/OuterHomeManagerUtil';
import { SpecialModeManager } from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import { screenLockGreetModel } from '@ohos/screenlockcomponent/src/main/ets/greet/model/ScreenLockGreetModel';
import Constants, { SlGreetStateListener } from '@ohos/screenlockcomponent/src/main/ets/greet/constant/Constants';
import { Constants as EditConstants } from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/Contants';
import { immersiveKgMgr, IState, OnStateChangeListener, StateType } from '@ohos/systemuicommon';
import {
  AfterClockCollapseEvent,
  ClockInputEventType,
  ScreenSizeChangeEvent,
  SetNtfExpandCollapseEvent,
  UpdateClockParamEvent
} from '@ohos/screenlockwidget/src/main/ets/common/command/Event';
import { MpStateTypeUtils, MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import {
  ClockWidgetAnimManager
} from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/viewanim/ClockWidgetAnimManager';
import {
  ClockWidgetOneShotAnimManager
} from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/viewanim/ClockWidgetOneShotAnimManager';
import { ClockHookType, UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import lazy { TripleAnimManagerUtil } from '../../utils/TripleAnimManagerUtil';
import lazy { TripleFoldExpandAnimationVc } from './TripleFoldExpandAnimationVc';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { ClockAdapter } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { slEditorHelper } from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/EditSheetHelper';
import { ClockConstants } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockConstants';
import { ClockColorUtil } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockColorUtil';
import lazy { ScreenLockFoldExpandAnimUtil } from '@ohos/screenlockcommon/src/main/ets/utils/ScreenLockFoldExpandAnimUtil';
import { SCBRotateChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import lazy { v2Helper } from '@ohos/immersivekeyguard';
import { Constants as SheetConstants } from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/Contants';
import { EDIT_COLOR_ARRAY } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyColor';

const TAG = 'ClockViewVc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const CLOCK_UP_DISTANCE: number = -65;

/**
 * View Control里用于操作渲染界面的对象
 */
export interface ClockOperateParams {
  slBindState: SlBindState;
  slClockBindCtrl: SlClockBindState;
  slClockLocateState: SlClockLocateState;
  slClockAnimCtrl: WidgetAnimState;
  slClockStaticCtrl: SlClockStaticState;
  clockStyle: AnyClock;
  mainColor: MainColor;
  specialModeViewData: SpecialModeViewData;
}

/**
 * 缓存时钟间距的类
 */
class ClockMargin {
  private widgetLeftMargin: number = 0;
  private widgetTopMargin: number = 0;
  private borderLeftMargin: number = 0;
  private borderTopMargin: number = 0;

  /**
   * 缓存时钟间距
   *
   * @param widgetLeftMargin 左边距
   * @param widgetTopMargin 上边距
   * @param borderLeftMargin 外边距左边距
   * @param borderTopMargin 外边距上边距
   */
  public updateClockMargin(widgetLeftMargin: number, widgetTopMargin: number, borderLeftMargin: number,
    borderTopMargin: number) {
    this.widgetLeftMargin = widgetLeftMargin;
    this.widgetTopMargin = widgetTopMargin;
    this.borderLeftMargin = borderLeftMargin;
    this.borderTopMargin = borderTopMargin;
  }

  /**
   * 获取时钟左边距
   * @returns 时钟左边距
   */
  public getWidgetLeftMargin(): number {
    return this.widgetLeftMargin;
  }

  /**
   * 获取时钟上边距
   * @returns 时钟上边距
   */
  public getWidgetTopMargin(): number {
    return this.widgetTopMargin;
  }

  /**
   * 获取时钟外边距左边距
   * @returns 时钟外边距左边距
   */
  public getBorderLeftMargin(): number {
    return this.borderLeftMargin;
  }

  /**
   * 获取时钟外边距上边距
   * @returns 时钟外边距上边距
   */
  public getBorderTopMargin(): number {
    return this.borderTopMargin;
  }
}

/**
 * clock view control
 *
 * @since 2024-08-31
 */
export class ClockViewVc extends ScreenLockVc<MpStateType> {
  private slBindState: SlBindState;
  private slClockBindCtrl: SlClockBindState;
  private slClockLocateState: SlClockLocateState;
  private slClockAnimCtrl: WidgetAnimState;
  private slClockStaticCtrl: SlClockStaticState;
  private clockStyle: AnyClock;
  private mainColor: MainColor;
  private specialModeViewData: SpecialModeViewData;
  private _mainPageVc?: MainPageVc;
  private isEditClockUp: boolean = false;
  // 栅格是否已配置
  private hasMeshConfig: boolean = false;
  // 问候语模式状态
  private isGreetShow: boolean = false;
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();
  private clockAdapter = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE);
  private clockMargin: ClockMargin = new ClockMargin();
  private bpListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SCREEN_BP) {
        const bpState: ScreenBp = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.
          getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
        this.clockAdapter.getClockWidgetModel().updateElementConfAndLayout();
      }
    }
  }

  /**
   * 时钟静态状态监听器
   */
  private clockStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockStaticStateType.IS_CLOCK_EXPAND_STATE) {
        const isClockExpand = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.getSlState(
          ClockStaticStateType.IS_CLOCK_EXPAND_STATE) as boolean;
      }
    }
  };

  public constructor(params: ClockOperateParams, parentVc?: MainPageVc) {
    super();
    this.slBindState = params.slBindState;
    this.slClockBindCtrl = params.slClockBindCtrl;
    this.slClockLocateState = params.slClockLocateState;
    this.slClockAnimCtrl = params.slClockAnimCtrl;
    this.slClockStaticCtrl = params.slClockStaticCtrl;
    this.clockStyle = params.clockStyle;
    this.mainColor = params.mainColor;
    this.specialModeViewData = params.specialModeViewData;
    this._mainPageVc = parentVc;
  }

  get parentVc(): MainPageVc | undefined {
    return this._mainPageVc;
  }

  private readonly _clockMoveListener = (moveDistance: number) => {
    let isEditSt = false;
    if (this.parentVc?.currentState) {
      isEditSt = MpStateTypeUtils.isEditState(this.parentVc?.currentState);
    }
    log.showInfo(`Clock move distance: ${moveDistance}, ${isEditSt}`);
    if (this.slClockLocateState.getMoveDistance() === moveDistance) {
      return;
    }
    // 编辑状态，不允许偏移
    if (isEditSt) {
      return;
    }
    this.slClockLocateState.setMoveDistance(moveDistance);
  };

  private onStateChange: OnStateChangeListener = {
    /**
     * 沉浸状态回调
     */
    onStateChange: (state: IState): void => {
      switch (state.getStateType()) {
        case StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE:
          this.handleImmersiveStateChange();
          break;
        default:
          break;
      }
    }
  };

  private onGreetStateChange: SlGreetStateListener = {
    onGreetShow: (isAni?: boolean): void => {
      this.isGreetShow = true;
      this.checkGreetChangeClockState(isAni);
    },
    onGreetHide: (isAni?: boolean): void => {
      this.isGreetShow = false;
      if (!this.slClockStaticCtrl.getIsClockVisible()) {
        this.setClockVisibleBySlGreet(false);
      }
    }
  };

  private onFormGreetStateChange: SlGreetStateListener = {
    onGreetShow: (isAni?: boolean): void => {
      ScreenLockFormPanelModel.updateFormPanelVisible();
    },
    onGreetHide: (isAni?: boolean): void => {
      ScreenLockFormPanelModel.updateFormPanelVisible();
    }
  };

  private onRotateChange = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void => {
    if (reason === SCBRotateChangeReason.ROTATE_END) {
      this.reverseClockLayout();
    }
  }

    /**
   * 景深静态状态监听器 用户锁屏编辑切换时钟倒转样式
   */
  private dofStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === DofWallpaperStaticStateType.DOF_TYPE_CONFIG) {
          this.reverseClockLayout();
      }
    }
  };

  private reverseClockLayout(): void {
    const params: IDofParam | undefined = sMultiSceneThemeManager.getDofParamByScene();
    if (params && params?.isDofDone && params.clockType &&
      Math.abs(this.clockStyle.layout - params.clockType) === CLOCK_LAYOUT_REVERSE_CONSTANT) {
      log.showInfo(`reverseClockLayout isDofDone ${params?.isDofDone}  type:${params?.clockType}`);
      animateToImmediately({
        duration: 100,
        curve: Curve.FastOutSlowIn,
      }, () => {
        this.clockStyle.layout = params.clockType ?? this.clockStyle.layout;
        slEditorHelper.getLayoutEditManger().updateLayout(this.clockStyle.layout, true);
      })
    }
  }

  private resetWallpaper(): void {
    // 三方主题且非沉浸态时恢复锁屏壁纸
    if (!this.slClockStaticCtrl.getIsClockVisible() && !immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
    }
  }

  protected doInit(): void {
    log.showInfo('doInit');
    slUiStateMgr.registerSlStateChangeListener(this.bpListener);
    this.bpListener.onSlStateChange?.(SlMainStateType.SL_STATIC_STATE, SlStaticStateType.SCREEN_BP);
    sEventManager.subscribe(ClockChangeType.CLOCK_MOVE, this._clockMoveListener);
    slClockOneShotToDesktopService.setSetTextColorOfDesktopClockForEffect((textColor: string) => {
      this.slClockBindCtrl.setTextColorOfDesktopClock(textColor);
    });
    this.slObserverProxy.observerDisplayState({
      onScreenPropertyChange: () => {
        this.sendScreenSizeChangeEvent();
      }
    })
    // 栅格监听注册
    this.clockAdapter?.getClockWidgetModel()?.initMeshRange();
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.onRotateChange);
    slUiStateMgr.registerSlStateChangeListener(this.dofStaticStateListener);
    slUiStateMgr.registerSlStateChangeListener(this.clockStaticStateListener);
    this.registerImmersiveStateChange();
    this.registerSlGreetStateChange();
    this.registerFormGreetStateChange();
    this.resetWallpaper();
    super.doInit();
  }

  protected doRelease(): void {
    super.doRelease();
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.onRotateChange);
    slUiStateMgr.unregisterSlStateChangeListener(this.dofStaticStateListener);
    slUiStateMgr.unregisterSlStateChangeListener(this.clockStaticStateListener);
    sEventManager.off(ClockChangeType.CLOCK_MOVE, this._clockMoveListener);
    slClockOneShotToDesktopService.setSetTextColorOfDesktopClockForEffect(undefined);
    this.unRegisterImmersiveStateChange();
    this.unRegisterSlGreetStateChange();
    this.unRegisterFormGreetStateChange();
    this.slObserverProxy.release();
    slUiStateMgr.unregisterSlStateChangeListener(this.bpListener);
    this.clockAdapter?.getClockWidgetModel()?.destroyMeshRange();
  }

  public getClockAdapter(): ClockAdapter {
    return this.clockAdapter;
  }

  /**
   * 更新时钟是否被卡片中心往上挤位
   *
   * @param isEditClockUp
   */
  public setIsEditClockUp(isEditClockUp: boolean): void {
    this.isEditClockUp = isEditClockUp;
  }

  /**
   * 刷新时钟在布局中的边距
   * @param useAnimate
   */
  public updateClockMargin(useAnimate: boolean = false): void {
    let panelPositionX: number = 0;
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      panelPositionX = ScreenLockThemeManager.getInstance().getDefaultClockParams().clock.positionX;
    } else if (this.parentVc) {
      panelPositionX = this.parentVc.getScreenLockPanelPositionX();
    }
    let gridWidth: number = this.slBindState.getGridWidth();
    let clockWidgetTopMargin: number = 0;
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      clockWidgetTopMargin = defaultClockParam.positionY * gridWidth;
    } else if (this.parentVc) {
      clockWidgetTopMargin = this.isEditClockUp ? CLOCK_UP_DISTANCE :
        this.parentVc.getScreenLockPanelPositionY(gridWidth);
    }

    // 计算基础左边距（基于网格系统）
    const baseLeftMargin = panelPositionX * gridWidth +
      clockLayoutHelper.getHorizontalGridMargin(this.isPortrait());
    // 计算补偿边距：由于 gridWidth 使用了 Math.min(singleWidth, singleHeight)，
    // 当垂直方向较小时，水平方向的总宽度会小于屏幕宽度，需要额外补偿使时钟居中
    const gridAmount = clockLayoutHelper.getLayoutGridAmount(this.isPortrait());
    const screenWidth = clockLayoutHelper.getScreenWidth();
    const actualGridTotalWidth = gridWidth * gridAmount.x;
    const compensationMargin = (screenWidth - actualGridTotalWidth) / 2 -
      clockLayoutHelper.getHorizontalGridMargin(this.isPortrait());

    // 最终左边距 = 基础边距 + 补偿边距
    const clockWidgetLeftMargin = baseLeftMargin + compensationMargin;
    const clockBorderLeftMargin = gridWidth * this.slClockLocateState.getDragGridX();
    const clockBorderTopMargin = gridWidth * this.slClockLocateState.getDragGridY();

    if (DeviceHelper.isLargeInFoldProduct()) {
      if (ScreenLockFoldExpandAnimUtil.getInstance().getSkipClockAnimation()) {
        useAnimate = false;
        log.showInfo(`large fold product, useAnimate is ${useAnimate}`);
      }
    }

    if (DeviceHelper.isThreeFoldProduct()) {
      useAnimate = !TripleAnimManagerUtil.getInstance().getSkipClockMarginAnimation();
      log.showInfo(`triple fold product, useAnimate is ${useAnimate}`);
    }

    let oldLeftMargin = this.slClockBindCtrl.getClockWidgetLeftMargin();
    let oldTopMargin = this.slClockBindCtrl.getClockWidgetTopMargin();
    let expand = DisplayStateManager.getInstance().isFoldExpanded();
    if (oldLeftMargin === clockWidgetLeftMargin && oldTopMargin === clockWidgetTopMargin) {
      return;
    }

    log.showWarn(`updateClockMargin pand:${expand}, x:${panelPositionX}, y:${this.clockStyle.y}, width:${gridWidth},` +
      `portrait:${this.isPortrait()}, left:${clockWidgetLeftMargin}, top:${clockWidgetTopMargin},edit:
      ${this.isEditClockUp}, useAnimate:${useAnimate}, animSw:${this.slClockStaticCtrl.getIsClockMarginNeedAnim()}`);
    if (useAnimate && this.slClockStaticCtrl.getIsClockMarginNeedAnim()) {
      this.animateToMarginInner(clockWidgetLeftMargin, clockWidgetTopMargin,
        clockBorderLeftMargin, clockBorderTopMargin);
    } else {
      this.updateClockMarginInner(clockWidgetLeftMargin, clockWidgetTopMargin,
        clockBorderLeftMargin, clockBorderTopMargin);
    }
  }

  /**
   * 更新时钟布局
   *
   * @param widgetLeftMargin 左边距
   * @param widgetTopMargin 上边距
   * @param borderLeftMargin 外边距左边距
   * @param borderTopMargin 外边距上边距
   */
  private updateClockMarginInner(widgetLeftMargin: number, widgetTopMargin: number,
    borderLeftMargin: number, borderTopMargin: number) {
    this.slClockBindCtrl.setClockWidgetLeftMargin(widgetLeftMargin);
    this.slClockBindCtrl.setClockWidgetTopMargin(widgetTopMargin);
    this.slClockBindCtrl.setClockBorderLeftMargin(borderLeftMargin);
    this.slClockBindCtrl.setClockBorderTopMargin(borderTopMargin);
  }

  /**
   * 执行动画到目标位置
   *
   * @param widgetLeftMargin 左边距
   * @param widgetTopMargin 上边距
   * @param borderLeftMargin 外边距左边距
   * @param borderTopMargin 外边距上边距
   */
  private animateToMarginInner(widgetLeftMargin: number, widgetTopMargin: number,
    borderLeftMargin: number, borderTopMargin: number) {
    let vel = NotificationStateManager.notificationState.velY; // 速度
    //动效前进行缓存，避免因animateTo的post机制导致的时序问题
    this.clockMargin.updateClockMargin(widgetLeftMargin, widgetTopMargin, borderLeftMargin, borderTopMargin);
    animateTo({
      curve: curves.interpolatingSpring(vel, 1, 228, 24.5)
    }, () => {
      this.updateClockMarginInner(this.clockMargin.getWidgetLeftMargin(), this.clockMargin.getWidgetTopMargin(),
        this.clockMargin.getBorderLeftMargin(), this.clockMargin.getBorderTopMargin());
    });
  }

  /**
   * 刷新网格信息
   *
   * @param clockStyle 时钟设置
   */
  public static updateComponentMeshConfig(clockStyle: AnyClock): void {
    log.showInfo('updateComponentMeshConfig');
    ScreenLockFormPanelModel.destroy();
    ScreenLockHeadManager.destroy();
    ClockWidgetConfig.setClockMesh(clockStyle);
    ScreenLockFormPanelMeshConfig.setPanelBeginMesh(ClockWidgetConfig.clockBeginMeshY +
    ClockWidgetConfig.maxClockMeshY);
    ScreenLockHeadManager.init();
    ClockWidgetModel.initClockRange();
    ScreenLockFormPanelModel.init();
    // 刷新静态状态缓存, 通知沉浸锁屏更新状态
    slStateHelper.getSlStaticState()?.setClockExpandMeshY(ClockWidgetConfig.maxClockMeshY);
    // V2场景隔离
    if (SlStateBaseMgr.isV2Enable()) {
      v2Helper.getV2Hook()?.requestUpdateMeshRange();
    } else {
      immersiveVm.getImmersiveMeshManager().requestUpdateMeshRange();
    }
  }

  /**
   * 更新解锁进桌面时钟一镜到底配置
   */
  public updatePageDesktopOneShotState(isClockVisible: boolean, clockStyle: AnyClock): void {
    slClockOneShotToDesktopService.updateClockVisible(isClockVisible);
    if (isClockVisible) {
      ScreenLockThemeManager.getInstance().notifyUpdateCardStyle(JSON.stringify({
        fontFamily: clockStyle.clockFontFamily,
        mainTextWeight: ClockStaticData.getTimeFontWeightStr(clockStyle.clockFontFamily),
      }));
    }
  }

  /**
   * 更新时钟样式
   *
   * @param themeClockParam 时钟主题参数
   */
  public updateClockStyle(themeClockParam?: IThemeParam): void {
    if (themeClockParam) {
      this.clockStyle.x = themeClockParam.positionX;
      this.clockStyle.y = themeClockParam.positionY;
      this.clockStyle.alignment = themeClockParam.textAlign;
      let colorIndex = slEditorHelper.getTargetColorIndex(themeClockParam.color);
      slUiStateMgr.getSlState(SlMainStateType.SL_EDIT_BIND_STATE)?.setSlState(EditBindStateType.SELECTED_COLOR_INDEX,
        colorIndex);
      this.clockStyle.clockStrokeColor = themeClockParam.color;
      this.clockStyle.isClockTextShadowEnabled = themeClockParam.textShadow;
      this.clockStyle.isClockTextBlurEffectEnabled = themeClockParam.textBlurEffect;
      let restoreSignatureVisible: boolean = sSettingsUtil.getSecureValue(KEY_OWNER_INFO_SWITCH) === 'true';
      let restoreSignatureText: string = sSettingsUtil.getSecureValue(KEY_OWNER_INFO);
      this.clockStyle.isClockSignatureVisible =
        themeClockParam.signatureVisible ? themeClockParam.signatureVisible : restoreSignatureVisible;
      this.clockStyle.aestheticColorArgs = themeClockParam.aestheticColorArgs;
      this.clockStyle.isLightWallpaper = themeClockParam.aestheticColorArgs.brightness < 1;
      this.clockStyle.clockDegreeNumber = themeClockParam.clockDegree;
      this.clockStyle.isPosterShadow = false;
      let strokeColor = themeClockParam.aestheticColorArgs.needColor[0] +
        themeClockParam.aestheticColorArgs.needColor.substring(3);
      if (colorIndex === 0 && !this.isPocketOuterSpecialColor(themeClockParam.color)) {
        this.clockStyle.clockStrokeColor = strokeColor;
        this.clockStyle.isPosterShadow = themeClockParam.aestheticColorArgs.isPosterShadow;
      }

      slEditorHelper.getLayoutEditManger().clearEditCache();
      log.showWarn(`updateClockStyle clock style ${this.clockStyle?.toString()}`);
      this.initEditMainColor();
      if (DeviceHelper.isThreeFoldProduct()) {
        this.refreshPreClockPosition();
      }
    }
  }

  /**
   * 是否是阔折叠外屏特有颜色
   *
   * @param color 原始颜色
   * @returns true, 是阔折叠外屏特有颜色
   */
  private isPocketOuterSpecialColor(color: string): boolean {
      return false;
  }

  /**
   * 时钟主题样式切换
   */
  public updateClockThemeStyle(): void {
    // 初始配置栅格时问候语检测
    if (!this.hasMeshConfig) {
      this.hasMeshConfig = true;
      this.checkGreetChangeClockState(false);
    }
  }

  // 更新编辑面板属性
  initEditMainColor(): void {
    let clockStyle: AnyClock = this.clockStyle;
    this.mainColor.radius = this.clockStyle.aestheticColorArgs?.radius
    this.mainColor.saturation = this.clockStyle.aestheticColorArgs?.saturation;
    this.mainColor.brightness = this.clockStyle.aestheticColorArgs?.brightness;
    this.mainColor.needColor = this.clockStyle.aestheticColorArgs?.needColor;
    this.mainColor.isShadow = this.clockStyle.aestheticColorArgs?.isShadow;
    this.mainColor.colorType = ClockColorUtil.getColorType(clockStyle.aestheticColorArgs?.brightness);
  }

  /**
   * 时钟是否可见
   *
   * @returns 时钟可见性
   */
  public isSlClockVisible(): boolean {
    return this.slClockStaticCtrl.getIsClockVisible() ||
      (this.slBindState.getSlState(SlBindStateType.IMMERSIVE_SHOWING_STATE) as boolean) ||
      (this.slBindState.getSlState(SlBindStateType.SL_GREET_SHOWING_STATE) as boolean);
  }

  public onOrientationChange(orientation: number): void {
    super.onOrientationChange(orientation);
    log.showInfo('onOrientationChange');
    this.updateClockMargin(true);
  }

  public onScreenSizeChange(width: number, height: number): void {
    super.onScreenSizeChange(width, height);
    log.showInfo('onScreenSizeChange');
    this.updateClockMargin(true);
    this.progressFoldExpandAnimation();
  }

  protected onScreenLockThemeChange(themeParam?: LockscreenThemeConfig | undefined): void {
    super.onScreenLockThemeChange(themeParam);
    if (!MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      log.showInfo('not support multi scene theme');
      return;
    }
    this.slClockAnimCtrl?.setBgColor(this.slClockStaticCtrl.getBackgroundColor());
    this.slClockAnimCtrl?.setFgBrightness(this.getClockBrightnessOptions());
    this.slClockStaticCtrl.setChangeColorState(this.clockStyle.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR);
  }

  private getClockBrightnessOptions():BrightnessOptions {
    let isLightWallpaper = slStateHelper.getSlClockBindState()?.getLightWallpaperState();
    let isChangeColor = slStateHelper.getSlClockStaticState()?.getChangeColorState();

    if (isChangeColor) {
      return isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    return isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
    BrightnessOptionUtils.keyguardTimeLightOption;
  }

  private registerImmersiveStateChange(): void {
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
  }

  private unRegisterImmersiveStateChange(): void {
    immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
  }

  private registerSlGreetStateChange(): void {
    screenLockGreetModel.registerStateChangeListener(Constants.CLOCK_LISTENER, this.onGreetStateChange);
  }

  private unRegisterSlGreetStateChange(): void {
    screenLockGreetModel.unRegisterStateChangeListener(Constants.CLOCK_LISTENER, this.onGreetStateChange);
  }

  private registerFormGreetStateChange(): void {
    screenLockGreetModel.registerStateChangeListener(Constants.FORM_LISTENER, this.onFormGreetStateChange);
  }

  private unRegisterFormGreetStateChange(): void {
    screenLockGreetModel.unRegisterStateChangeListener(Constants.FORM_LISTENER, this.onFormGreetStateChange);
  }

  /**
   * 处理三方主题进出沉浸态，锁屏时钟动效业务
   */
  private handleImmersiveStateChange(): void {
    log.showInfo('immersive handleImmersiveStateChange');
    // 时钟可见，非三方主题场景，无需处理
    if (this.slClockStaticCtrl.getIsClockVisible()) {
      return;
    }

    if (immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      this.handleIntoImmersiveForClockInvisible();
    }

    if (!immersiveKgMgr.getImmersiveDisplayState().isImmersive() &&
      immersiveKgMgr.getBeforeImmersiveState().isImmersive()) {
      this.handleExitImmersiveForClockInvisible();
    }
  }

  private checkGreetChangeClockState(isAni?: boolean): void {
    if (!this.isGreetShow || !this.hasMeshConfig) {
      return;
    }
    if (this.slClockStaticCtrl.getIsClockVisible()) {
      this.updateClockToCollapseWithoutAni();
      // 进入问候模式收起通知
      this.sendSetNtfExpandCollapseEvent();
    }
    // 三方主题场景
    if (this.slClockStaticCtrl.getIsClockVisible() ||
    this.slBindState?.getSlState(SlBindStateType.SL_GREET_SHOWING_STATE)) {
      return;
    }
    if (!isAni) {
      this.updateClockToCollapseWithoutAni();
      this.setClockVisibleBySlGreet(true);
      return;
    }
    this.startIntoImmersive(() => this.setClockVisibleBySlGreet(true));
  }

  private handleIntoImmersiveForClockInvisible(): void {
    if (this.slBindState?.getSlState(SlBindStateType.SL_GREET_SHOWING_STATE)) {
      this.slBindState?.setSlState(SlBindStateType.IMMERSIVE_SHOWING_STATE, true);
      this.slBindState?.setSlState(SlBindStateType.SL_GREET_SHOWING_STATE, false);
    } else {
      this.startIntoImmersive(() => {
        this.slBindState?.setSlState(SlBindStateType.IMMERSIVE_SHOWING_STATE, true);
      });
    }
  }

  private handleExitImmersiveForClockInvisible(): void {
    this.startExitImmersive(() => {
      this.slBindState?.setSlState(SlBindStateType.IMMERSIVE_SHOWING_STATE, false);
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
      this.sendUpdateClockParamEvent();
    })
  }

  private startIntoImmersive(setClockShow: () => void): void {
    if (ClockStaticData.updateClockWidgetExpand(false)) {
      this.sendUpdateClockParamEvent();
    }
    this.getClockAnimMgr()?.doIntoImmersiveAnim(setClockShow);
  }

  private getClockAnimMgr(): ClockWidgetAnimManager | undefined {
    let animMgr = this.clockAdapter?.getHook(ClockHookType.CLOCK_ANIM_MANAGER);
    if (animMgr instanceof ClockWidgetAnimManager) {
      return animMgr as ClockWidgetAnimManager;
    }
    return undefined;
  }

  private startExitImmersive(animCallBack: () => void): void {
    this.getOneShotClockAnimMgr()?.doExitImmersiveAnim(animCallBack);
  }

  private getOneShotClockAnimMgr(): ClockWidgetOneShotAnimManager | undefined {
    let animMgr = this.clockAdapter?.getHook(ClockHookType.CLOCK_ONE_SHOT_ANIM_MANAGER);
    if (animMgr instanceof ClockWidgetOneShotAnimManager) {
      return animMgr as ClockWidgetOneShotAnimManager;
    }
    return undefined;
  }

  private updateClockToCollapseWithoutAni() {
    if (!ClockStaticData.sIsClockWidgetExpand) {
      return;
    }
    ClockStaticData.updateClockWidgetExpand(false);
    this.sendAfterClockCollapseEvent();
  }

  private setClockVisibleBySlGreet(isVisible: boolean): void {
    if (immersiveKgMgr.getImmersiveDisplayState().isImmersive() && !isVisible) {
      return;
    }
    this.slBindState?.setSlState(SlBindStateType.SL_GREET_SHOWING_STATE, isVisible);
  }

  private sendSetNtfExpandCollapseEvent(): void {
    let event = new SetNtfExpandCollapseEvent(ClockInputEventType.NTF_EXPAND_COLLAPSE, TAG);
    event.isExpand = false;
    this.clockAdapter.getInvoker().onEvent(event);
  }

  private sendScreenSizeChangeEvent(): void {
    let event = new ScreenSizeChangeEvent(ClockInputEventType.SCREEN_SIZE_CHANGE, TAG);
    this.clockAdapter.getInvoker().onEvent(event);
  }

  private sendUpdateClockParamEvent(): void {
    let event = new UpdateClockParamEvent(ClockInputEventType.UPDATE_CLOCK_PARAM_EVENT, TAG);
    this.clockAdapter.getInvoker().onEvent(event);
  }

  private sendAfterClockCollapseEvent(): void {
    let event = new AfterClockCollapseEvent(ClockInputEventType.AFTER_CLOCK_COLLAPSE_EVENT, TAG);
    this.clockAdapter.getInvoker().onEvent(event);
  }

  private progressFoldExpandAnimation(): void {
    if (DeviceHelper.isLargeInFoldProduct()) {
      // 双折叠，将开合时的时钟动效标志位复位
      ScreenLockFoldExpandAnimUtil.getInstance().setSkipClockAnimation(false);
    }
    if (DeviceHelper.isThreeFoldProduct()) {
      // 三折叠产品，触发时钟的锁屏开合动效
      this.tripleAnimationCtrl();
    }
  }

  // 更新时钟位置信息
  public refreshPreClockPosition(): void {
    if (!TripleAnimManagerUtil.getInstance().getSkipClockMarginAnimation() && DeviceHelper.isThreeFoldProduct()) {
      log.showInfo('change clock style, refresh pre clock position');
      TripleAnimManagerUtil.getInstance().setPreClockPosition(this.slClockBindCtrl.getClockWidgetLeftMargin(),
        this.slClockBindCtrl.getClockWidgetTopMargin());
    }
  }

  private tripleAnimationCtrl(): void {
    TripleAnimManagerUtil.getInstance().setCurClockPosition(this.slClockBindCtrl.getClockWidgetLeftMargin(),
      this.slClockBindCtrl.getClockWidgetTopMargin());
    TripleFoldExpandAnimationVc.getInstance().tripleAnimation(true);
    TripleAnimManagerUtil.getInstance().setSkipClockMarginAnimation(false);
  }



  public setBatteryLayout(): void {
    const isPartType: Nullable<boolean> = false;
    this.slClockBindCtrl?.setBatteryLayout(isPartType ? BatteryLayout.PART_AOD_LAYOUT :
    BatteryLayout.FULL_AOD_LAYOUT);
    log.showInfo(`isPartType: ${isPartType}`);
  }
}
