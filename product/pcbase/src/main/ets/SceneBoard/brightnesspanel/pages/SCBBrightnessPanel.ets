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

import { Log } from '@ohos/basicutils';
import {
  reportIntervalMgr,
  ReportIntervalManager,
  viewMgrPolicy,
  ViewArea,
  ViewType,
  ViewCallback,
  GlobalContext,
  EventManager,
  EvtBus,
  WallpaperChangeEvent,
  ViewManagerPolicy
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  SCBSceneSessionManager,
  DisplayMgr,
  SCBKeyboardManager,
  KeyboardChangeCallback,
  SCBFoldStatePropertyChangeEvent,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import StyleConfiguration, { BrightnessPanelComponentStyle } from '../common/StyleConfiguration';
import systemParameter from '@ohos.systemparameter';
import { MultimodalInputManager } from '@ohos/systemuicommon';
import mBrightnessManager from '../common/BrightnessManager';
import display from '@ohos.display';
import { LocalWindowManager } from '@ohos/systemuicommon';
import { Callback } from '@ohos.base';
import VolumeWindowController from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/common/VolumeWindowController';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ColorModeViewModel, ColorModeViewData } from '@ohos/systemuicommon/Index';
import viewModel, { BrightnessProgress } from '../viewModel/BrightnessVM'
import BrightnessPanelCanvas from './BrightnessPanelCanvas';

const TAG = 'BrightnessPanel-Index';
const COMPONENT_ID_SLIDER = TAG + '_Slider_volume';

const TIMEOUT_SHORT = 2000;
const BRIGHTNESS_PANEL_WIDTH: number = LocalWindowManager.PC_BRIGHTNESS_PANEL_WIDTH;
const BRIGHTNESS_PANEL_HEIGHT: number = LocalWindowManager.PC_BRIGHTNESS_PANEL_HEIGHT;
const RATIO: number = LocalWindowManager.PC_BRIGHTNESS_RATIO;
const BRIGHT_PANEL_ZINDEX: number = 1700;
const VIRTUAL_KEYBOARD_ZINDEX: number = 3902;
const ZINDEX_INCREMENT = 10;

@Component
export struct SCBBrightnessPanel {
  @StorageLink('screenWidth') @Watch('onScreenSizeChanged') screenWidth: number = 0;
  @StorageLink('screenHeight') @Watch('onScreenSizeChanged') screenHeight: number = 0;
  persistentId: number = 0;
  mInterval: number = TIMEOUT_SHORT;
  @State mWallpaperAvgColor: string = '#00ffffff';
  @State brightnessPanelCtrl: BaseViewController = new BaseViewController(ViewType.BRIGHTNESS_PANEL);
  @StorageLink('BrightnessValue') @Watch('onPhysicsValueChanged') brightnessValue: number = 0;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State viewData: BrightnessProgress = viewModel.getViewData();
  private mViewCallback: ViewCallback = {
    onShow: (): void => this.dismissVolumeWindowImmediately()
  };
  private previousShowTimerHandle: number = 0;
  private eventManager: EventManager = EvtBus.createEventManager();
  private minNum: number = 0;
  private maxNum: number = 0;
  private mComponentStyle: BrightnessPanelComponentStyle = StyleConfiguration.getBrightnessPanelComponentStyle();
  private defaultDisplay: display.Display | undefined = undefined;
  private zIndexVal: number = BRIGHT_PANEL_ZINDEX;
  private defaultZIndex: number = BRIGHT_PANEL_ZINDEX;
  private isTimerPaused: boolean = false;

  init(): void {
    // 多模输入监听
    let upCallback: BrightnessUpChange = { onBrightnessUpChange: () => this.onBrightnessUpChange() };
    let downCallback: BrightnessDownChange = { onBrightnessDownChange: () => this.onBrightnessDownChange() };
    this.eventManager
      .addOff(MultimodalInputManager.registerBrightnessUpListener(upCallback))
      .addOff(MultimodalInputManager.registerBrightnessDownListener(downCallback));
    this.brightnessPanelCtrl.registerCallback(this.mViewCallback);
  }

  onBrightnessDownChange(): void {
    Log.showInfo(TAG, 'onBrightnessDownChange');
    viewMgrPolicy.showView(ViewType.BRIGHTNESS_PANEL);
    mBrightnessManager.subValue(this.viewData.brightnessUIValue);
    this.autoDismissBrightnessWindow();
    reportIntervalMgr.addEventCount(ReportIntervalManager.BRIGHTNESS_DOWN);
  }

  onPhysicsValueChanged(): void {
    viewModel.updatePhysicsValue(this.brightnessValue);
    Log.showInfo(TAG, `onPhysicsValueChanged brightnessValue: ${this.brightnessValue}, sUIValue:${this.viewData.brightnessUIValue}`);
    // 数据值变化时窗口隐藏重新计时
    this.autoDismissBrightnessWindow();
  }

  onScreenSizeChanged(): void {
    this.updateArea(vp2px(this.screenHeight), vp2px(this.screenWidth));
    Log.showInfo(TAG, `onScreenSizeChanged screenHeight: ${this.screenHeight}, screenWidth:${this.screenWidth}`);
  }

  /**
   * 亮度条出现的时候隐藏音量条
   */
  dismissVolumeWindowImmediately(): void {
    Log.showInfo(TAG, 'dismissVolumeWindowImmediately');
    VolumeWindowController.getInstance().dismissVolumeWindowImmediately();
  }

  onBrightnessUpChange(): void {
    Log.showInfo(TAG, 'onBrightnessUpChange');
    viewMgrPolicy.showView(ViewType.BRIGHTNESS_PANEL);
    mBrightnessManager.addValue(this.viewData.brightnessUIValue);
    this.autoDismissBrightnessWindow();
    reportIntervalMgr.addEventCount(ReportIntervalManager.BRIGHTNESS_UP);
  }

  autoDismissBrightnessWindow() {
    this.clearWindowTimer();
    if (this.isTimerPaused) {
      Log.showInfo(TAG, 'timer paused, no need hide');
      return;
    }
    this.previousShowTimerHandle = setTimeout(() => {
      viewMgrPolicy.hideView(ViewType.BRIGHTNESS_PANEL);
    }, this.mInterval);
  }

  private clearWindowTimer(): void {
    if (this.previousShowTimerHandle > 0) {
      clearTimeout(this.previousShowTimerHandle);
      this.previousShowTimerHandle = 0;
    }
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    try {
      this.defaultDisplay = display.getDefaultDisplaySync();
    } catch (error) {
      Log.showError(TAG, '[aboutToAppear] display.getDefaultDisplaySync error' + JSON.stringify(error));
      return;
    }
    viewMgrPolicy.registerViewController(ViewType.BRIGHTNESS_PANEL, this.brightnessPanelCtrl);
    this.maxNum = mBrightnessManager.getMax();
    this.minNum = mBrightnessManager.getMax();
    Log.showInfo(TAG, `minNum: ${this.minNum} maxNum: ${this.maxNum}`);
    this.init();
    this.brightnessPanelCtrl.updateId(this.persistentId);
    viewModel.aboutToAppear(this.brightnessValue);
    this.updateArea(vp2px(this.screenHeight), vp2px(this.screenWidth));
    this.defaultZIndex = viewMgrPolicy.getZIndex(ViewType.BRIGHTNESS_PANEL) ?? BRIGHT_PANEL_ZINDEX;
    this.registerTransparentDetection();
    this.registerVirtualKeyboardChangeCallback();
  }

  updateArea(screenHeight: number, screenWidth: number): void {
    Log.showInfo(TAG, `screenHeight: ${screenHeight},  screenWidth: ${screenWidth}`);
    let brightnessWindowTop = px2vp(screenHeight) * RATIO - BRIGHTNESS_PANEL_HEIGHT;
    let brightnessWindowLeft = (px2vp(screenWidth) - BRIGHTNESS_PANEL_WIDTH) / 2;
    const rect: ViewArea = {
      left: brightnessWindowLeft,
      top: brightnessWindowTop,
      width: BRIGHTNESS_PANEL_WIDTH,
      height: BRIGHTNESS_PANEL_HEIGHT
    }
    this.brightnessPanelCtrl.updateArea(rect);
    this.brightnessPanelCtrl.updateRect(rect);
  }

  //virtual  keyboard call back
  private registerVirtualKeyboardChangeCallback(): void {
    // 监听键盘样式变化
    SCBKeyboardManager.getInstance().registerkeyboardGravityChangeCallbacks(this.keyboardChangeCallback);
    // 监听键盘拉起和关闭变化
    SCBKeyboardManager.getInstance().registerKeyboardSessionStateChangeCallbackForPC(this.keyboardStateChangeCallback);
  }

  private unRegisterVirtualKeyboardChangeCallback(): void {
    SCBKeyboardManager.getInstance().unRegisterkeyboardGravityChangeCallbacks(this.keyboardChangeCallback);
    SCBKeyboardManager.getInstance().unRegisterKeyboardSessionStateChangeCallbackForPC(
      this.keyboardStateChangeCallback);
  }

  private keyboardChangeCallback: KeyboardChangeCallback = {
    onKeyboardGravityChange: (sessionGravity: sceneSessionManager.KeyboardGravity): void => {
      this.notifyVirtualKeyboardStateChange();
    },

    onRectChangeChange: (rect: sceneSessionManager.SessionRect,
      reason: sceneSessionManager.SessionSizeChangeReason): void => {
    },

    onSessionTouchableChange: (isTouchable: boolean): void => {},

    onCustomAnimationPlaying: (isPlaying: boolean): void => {},

    onForceHide: (hide: boolean): void => {},

    getZIndex: (): number => { return -1; },

    onVirtualScreenStateChange: (
      screenId: number, persistentId: number, state: sceneSessionManager.SessionState): void => {},

    onCallingSessionChange: (callingSessionId: number): void => {}
  };

  notifyVirtualKeyboardStateChange(): void {
    let systemKeyboardSession = SCBKeyboardManager.getInstance().getSystemKeyboardSession();
    if (!systemKeyboardSession) {
      return;
    }
    let isKeyboardFloatGravity = systemKeyboardSession.isFloatGravity();
    let systemKeyboardState = systemKeyboardSession.sessionState;
    try {
      let foldStatus = display.getFoldStatus() as number;
      Log.showInfo(TAG, `notifyVirtualKeyboardStateChange isFloatGravity is ${isKeyboardFloatGravity}, ` +
        `keyboardState is ${systemKeyboardState}, foldStatus is ${foldStatus}`);
      // 锁屏状态不响应
      if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
        return;
      }
      // 非折叠态下键盘拉起
      if (!isKeyboardFloatGravity && systemKeyboardState === sceneSessionManager.SessionState.STATE_FOREGROUND &&
        foldStatus !== FoldStatus.FOLD_STATUS_HALF_FOLDED) {
        this.zIndexVal = VIRTUAL_KEYBOARD_ZINDEX + ZINDEX_INCREMENT;
        ViewManagerPolicy.setZIndex(ViewType.BRIGHTNESS_PANEL, this.zIndexVal);
      } else {
        this.zIndexVal = this.defaultZIndex;
        ViewManagerPolicy.setZIndex(ViewType.BRIGHTNESS_PANEL, this.zIndexVal);
      }
      Log.showInfo(TAG, `BRIGHTNESS_PANEL zIndex: ${this.zIndexVal}`);
    } catch (error) {
      Log.showError(TAG, `get foldStatus error: ${error}`)
    }
  }

  private keyboardStateChangeCallback = (parentId:number, persistentId:number,
    sessionState:sceneSessionManager.SessionState, mainScreenId:number) => {
    this.notifyVirtualKeyboardStateChange();
  }

  private registerTransparentDetection(): void {
    const session = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    session?.registerContextTransparentCallback(() => {
      Log.showError(TAG, 'window is transparency!!');
    })
  }

  aboutToDisappear() {
    this.brightnessPanelCtrl.unRegisterCallback(this.mViewCallback);
    this.eventManager.offAll();
    this.unRegisterVirtualKeyboardChangeCallback();
    Log.showInfo(TAG, `aboutToDisAppear`);
  }

  build() {
    Column() {
      Stack() {
        this.pcBrightness();
      }
      .clip(true)
      .alignContent(Alignment.Start)
      .borderRadius(this.mComponentStyle.panelBorderRadius)
      .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Horizontal, distance: 0, fingers: 1 })
          .onActionStart((event: GestureEvent) => {
            Log.showInfo(TAG, `onActionStart`);
            viewMgrPolicy.showView(ViewType.BRIGHTNESS_PANEL);
            viewModel.onPanActionStart(event);
          })
          .onActionUpdate((event: GestureEvent) => {
            Log.showInfo(TAG, `onActionUpdate`);
            viewModel.onPanActionUpdate(event);
          })
          .onActionEnd((event: GestureEvent) => {
            Log.showInfo(TAG, `onPanActionEnd`);
            viewModel.onPanActionEnd(event);
          })
          .onActionCancel((event: GestureEvent) => {
            Log.showInfo(TAG, `onActionCancel`);
            viewModel.onActionCancel(event);
          })
      ))
      .onTouch((event?: TouchEvent) => {
        Log.showInfo(TAG, `onTouch event start, type: ${event?.type}`);
        viewModel.handleOnTouch(event);
        if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
          this.autoDismissBrightnessWindow();
        } else {
          this.clearWindowTimer();
        }
      })
      .onHover((isHover: boolean, event: HoverEvent) => {
        Log.showInfo(TAG, `onHover event start, isHover: ${isHover}`);
        this.isTimerPaused = isHover;
        this.autoDismissBrightnessWindow();
      })
    }
    .id(COMPONENT_ID_SLIDER)
    .borderRadius(this.mComponentStyle.panelBorderRadius)
    .border({
      width: this.mComponentStyle.panelBorderWidth,
      color: this.mComponentStyle.panelBorderLightColor,
      radius: this.mComponentStyle.panelBorderRadius
    })
    .visibility(this.brightnessPanelCtrl.isShowing() ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  pcBrightness() {
    Column() {
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#FFFFFFFF')
    .borderRadius(this.mComponentStyle.panelBorderRadius)
    .border({
      width: this.mComponentStyle.panelBorderWidth,
      color: this.mComponentStyle.panelBorderColor,
      radius: this.mComponentStyle.panelBorderRadius
    })
    .backgroundBrightnessInternal(this.colorModeViewData.getVolumeDarkFgOption())

    Column() {
    }
    .width(this.viewData.brightnessUIValue)
    .height('100%')
    .backgroundColor('#DDFFFFFF')

    BrightnessPanelCanvas({brightnessValue: this.brightnessValue})
  }
}

export interface BrightnessUpChange {
  onBrightnessUpChange: Callback<void>
}

export interface BrightnessDownChange {
  onBrightnessDownChange: Callback<void>
}