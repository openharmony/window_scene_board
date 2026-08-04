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

import StyleConfiguration, { VolumePanelComponentStyle } from '../common/PCStyleConfiguration';
import { Log, LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  GlobalContext,
  EvtBus,
  HiDfxEventUtil,
  WallpaperChangeEvent,
  EventManager,
  ViewType,
  ViewArea,
  viewMgrPolicy,
  ViewManagerPolicy,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { BaseViewController, } from '@ohos/frameworkcommon';
import Constants, { SCBFoldState, VolumeInfo } from '../common/Constants';
import ViewModel from '../viewmodel/VolumePanelVM';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { VolumeReportBuilder, VolumeSysEventUtil } from '../common/VolumeSysEventUtil';
import VolumeWindowController from '../common/VolumeWindowController';
import { LocalWindowManager } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  DisplayMgr,
  KeyboardChangeCallback,
  SCBFoldStatePropertyChangeEvent,
  SCBKeyboardManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager
} from '@ohos/windowscene/src/main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import display from '@ohos.display';
import PanelViewModel, { VolumeViewData } from '../viewmodel/PCVolumePanelViewModel';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import VolumePanelCanvasComponent from './PCVolumePanelCanvasComponent';
import { audio } from '@kit.AudioKit';

const TAG = 'VolumePanel-VolumePanelComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const COMPONENT_ID_SLIDER = TAG + '_Slider_volume';
const COMPONENT_ID_ICON = TAG + '_Image_volume';

const VOLUME_PANEL_WIDTH: number = LocalWindowManager.PC_BRIGHTNESS_PANEL_WIDTH;
const VOLUME_PANEL_HEIGHT: number = LocalWindowManager.PC_BRIGHTNESS_PANEL_HEIGHT;
const RATIO: number = LocalWindowManager.PC_BRIGHTNESS_RATIO;
const VOLUME_ZINDEX: number = 1900;
const VIRTUAL_KEYBOARD_ZINDEX: number = 3902;
const ZINDEX_INCREMENT = 10;

@Component
export default struct VolumePanelComponent {
  @StorageLink('screenWidth') @Watch('onScreenSizeChanged') screenWidth: number = 0;
  @StorageLink('screenHeight') @Watch('onScreenSizeChanged') screenHeight: number = 0;
  private zIndexVal: number = VOLUME_ZINDEX;
  private defaultZIndex: number = VOLUME_ZINDEX;
  private readonly volumeHeight: number = 289;
  @StorageLink('VolumePanelMaxVolume')@Watch('onVolumePanelMaxVolumeChange') volumePanelMaxVolume: number = Constants.PC_DEFAULT_MAX_VOLUME;
  @StorageLink('VolumePanelMinVolume')@Watch('onVolumePanelMinVolumeChange') volumePanelMinVolume: number = Constants.DEFAULT_MIN_VOLUME;
  @StorageLink('VolumePanelVolumeValue')@Watch('onVolumePanelVolumeValueChange') volumePanelVolumeValue: number = Constants.DEFAULT_MIN_VOLUME;
  @StorageLink('VolumePanelIsMute') volumePanelIsMute: boolean = Constants.DEFAULT_MUTE_STATUS;
  @State style: VolumePanelComponentStyle = StyleConfiguration.getVolumePanelComponentStyle();
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @State mWallpaperAvgColor: string = '#00ffffff';
  private eventManager: EventManager = EvtBus.createEventManager();
  @State volumePanelCtrl: BaseViewController | undefined = undefined;
  persistentId: number = 0;
  @State volumePanelMaxVolumeLocal: number = this.volumePanelMaxVolume;
  @State volumePanelMinVolumeLocal: number = this.volumePanelMinVolume;
  @State volumePanelVolumeValueLocal: number = this.volumePanelVolumeValue;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State viewData: VolumeViewData = PanelViewModel.getViewData();

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    PanelViewModel.aboutToAppear(this.volumePanelVolumeValueLocal);
    ViewModel.initViewModel(this.isUpdateUiByVolumeInfo);
    this.volumePanelCtrl?.updateId(this.persistentId);
    this.updateArea(vp2px(this.screenHeight), vp2px(this.screenWidth));
    this.defaultZIndex = viewMgrPolicy.getZIndex(ViewType.VOLUME) ?? VOLUME_ZINDEX;
    this.eventManager
      .on(WallpaperChangeEvent, (data: WallpaperChangeEvent) => {
      this.mWallpaperAvgColor = data.avgColor;
    })
      .on(SCBFoldStatePropertyChangeEvent, this.onSuperFoldStatusChange);
    this.registerVirtualKeyboardChangeCallback();
  }

  private isUpdateUiByVolumeInfo = (volumeInfo: VolumeInfo): boolean => {
    let isSupport: boolean = false;
    // QXS的PC模式支持的类型跟随音频框架
    if (DeviceHelper.is2In1DevicePcType()) {
      isSupport = true;
      ViewModel.mCurrentAudioVolumeType = volumeInfo.volumeType;
    }
    return isSupport;
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.eventManager.offAll();
    this.unRegisterVirtualKeyboardChangeCallback();
  }

  initCalAres() {
    let screenWidth = vp2px(this.screenWidth);
    let screenHeight = vp2px(this.screenHeight);
    this.updateArea(screenHeight, screenWidth);
  }

  onSuperFoldStatusChange = async (superFoldStateProperty: SCBFoldStatePropertyChangeEvent) => {
    Log.showInfo(TAG, `onSuperFoldStatusChange property, bSideHeight: ${superFoldStateProperty.bSideHeight}, ` +
      `curState: ${superFoldStateProperty.curState}, tarState: ${superFoldStateProperty.tarState}`);
    // 虚拟键盘和磁吸键盘存在
    if (this.isCalculatedByBSide(superFoldStateProperty)) {
      let screenHeight = superFoldStateProperty.bSideHeight;
      let screenWidth = superFoldStateProperty.bSideWidth;
      this.updateArea(screenHeight, screenWidth);
    } else {
      // 获取的整个屏幕的宽高
      let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      // px
      let screenHeightTmp = screenSession.scbScreenProperty.height;
      let screenWidthTmp = screenSession.scbScreenProperty.width;
      this.updateArea(screenHeightTmp, screenWidthTmp);
      Log.showInfo(TAG, 'onSuperFoldStatusChange, other state');
    }
  }

  private isCalculatedByBSide(superFoldStateProperty: SCBFoldStatePropertyChangeEvent): boolean {
    return superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD ||
      superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD ||
      superFoldStateProperty.tarState === SCBFoldState.HALF_FOLDED;
  }

  updateArea(screenHeight: number, screenWidth: number): void {
    log.showInfo(`screenHeight: ${screenHeight},  screenWidth: ${screenWidth}`);
    let volumePanelWindowTop = px2vp(screenHeight) * RATIO - VOLUME_PANEL_HEIGHT;
    let volumePanelWindowLeft = (px2vp(screenWidth) - VOLUME_PANEL_WIDTH) / 2;
    const rect: ViewArea = {
      left: volumePanelWindowLeft,
      top: volumePanelWindowTop,
      width: VOLUME_PANEL_WIDTH,
      height: VOLUME_PANEL_HEIGHT
    }
    this.volumePanelCtrl?.updateArea(rect);
    this.volumePanelCtrl?.updateRect(rect);
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
    try {
      let systemKeyboardSession = SCBKeyboardManager.getInstance().getSystemKeyboardSession();
      if (!systemKeyboardSession) {
        return;
      }
      let isKeyboardFloatGravity = systemKeyboardSession.isFloatGravity();
      let systemKeyboardState = systemKeyboardSession.sessionState;
      let foldStatus = display.getFoldStatus() as number;
      log.showInfo(`notifyVirtualKeyboardStateChange isFloatGravity is ${isKeyboardFloatGravity}, ` +
        `keyboardState is ${systemKeyboardState}, foldStatus is ${foldStatus}`);
      // 锁屏状态不响应
      if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
        return;
      }
      // 非折叠态下键盘拉起
      if (!isKeyboardFloatGravity && systemKeyboardState === sceneSessionManager.SessionState.STATE_FOREGROUND &&
        foldStatus !== FoldStatus.FOLD_STATUS_HALF_FOLDED) {
        this.zIndexVal = VIRTUAL_KEYBOARD_ZINDEX + ZINDEX_INCREMENT;
        ViewManagerPolicy.setZIndex(ViewType.VOLUME, this.zIndexVal);
      } else {
        this.zIndexVal = this.defaultZIndex;
        ViewManagerPolicy.setZIndex(ViewType.VOLUME, this.zIndexVal);
      }
      log.showInfo(`VOLUME zIndex: ${this.zIndexVal}`);
    } catch (error) {
      log.info(`display getFoldStatus error ${error}`);
    }
  }

  private keyboardStateChangeCallback = (parentId:number, persistentId:number,
    sessionState:sceneSessionManager.SessionState, mainScreenId:number) => {
    this.notifyVirtualKeyboardStateChange();
  }

  build() {
    Column() {
      Stack() {
        this.VolumeSlider()
      }
      .clip(true)
      .alignContent(Alignment.Start)
      .borderRadius(this.style.panelBorderRadius)
      .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Horizontal, distance: 0, fingers: 1 })
          .onActionStart((event: GestureEvent) => PanelViewModel.onPanActionStart(event))
          .onActionUpdate((event: GestureEvent) => PanelViewModel.onPanActionUpdate(event))
          .onActionEnd((event: GestureEvent) => PanelViewModel.onPanActionEnd(event)),
      ))
      .onTouch((event?: TouchEvent) => {
        Log.showInfo(TAG, `onTouch event start, type: ${event?.type}`);
        PanelViewModel.handleOnTouch(event);
        if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
          VolumeWindowController.getInstance().resetWindowTimer();
        } else {
          VolumeWindowController.getInstance().clearWindowTimer();
        }
      })
      .onHover((isHover: boolean, event: HoverEvent) => {
        Log.showInfo(TAG, `onHover event start, isHover: ${isHover}`);
        VolumeWindowController.getInstance().resetWindowTimer(isHover);
      })
    }
    .id(COMPONENT_ID_SLIDER)
    .border({
      width: this.style.panelBorderWidth,
      color: this.style.panelBorderLightColor,
      radius: this.style.panelBorderRadius
    })
    .borderRadius(this.style.panelBorderRadius)
  }

  @Builder
  VolumeSlider() {
    Column() {
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#FFFFFFFF')
    .backgroundBrightnessInternal(this.colorModeViewData.getVolumeDarkFgOption())
    .border({
      width: this.style.panelBorderWidth,
      color: this.style.panelBorderColor,
      radius: this.style.panelBorderRadius
    })
    .borderRadius(this.style.panelBorderRadius)

    Column() {
    }
    .width(this.viewData.volumeUIValue)
    .height('100%')
    .backgroundColor('#DDFFFFFF')

    Column() {
      VolumePanelCanvasComponent({volumeValue: this.volumePanelVolumeValueLocal})
    }
    .width(32)
    .height(32)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .hitTestBehavior(this.volumePanelVolumeValueLocal === this.volumePanelMinVolumeLocal ? HitTestMode.None :
    HitTestMode.Block)
    .onClick(this.onMuteBtnClick)
  }

  onMuteBtnClick = (event?: ClickEvent) => {
    log.showInfo('onMuteBtnClick');
    ViewModel.mute();
    if (ViewModel.isMute(ViewModel.mCurrentAudioVolumeType)) {
      VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_PANEL_CLICK_MUTE,
        VolumeReportBuilder.builder()
          .channel(ViewModel.mCurrentAudioVolumeType).isLocked(ScreenLockApi.getLock()).build());
    } else {
      VolumeSysEventUtil.reportVolumeEvent(VolumeSysEventUtil.VOL_PANEL_CLICK_CANCEL_MUTE,
        VolumeReportBuilder.builder()
          .channel(ViewModel.mCurrentAudioVolumeType).isLocked(ScreenLockApi.getLock()).build());
    }
  }

  onVolumePanelMaxVolumeChange(): void {
    if (this.volumePanelMaxVolume <= Constants.DEFAULT_VOLUME_INVALID) {
      log.showError('volumePanelMaxVolume is invalid, update volumePanelMaxVolume');
      return;
    }
    this.volumePanelMaxVolumeLocal = this.volumePanelMaxVolume;
  }

  onScreenSizeChanged(): void {
    this.updateArea(vp2px(this.screenHeight), vp2px(this.screenWidth));
    Log.showInfo(TAG, `onScreenSizeChanged screenHeight: ${this.screenHeight}, screenWidth:${this.screenWidth}`);
  }

  onVolumePanelMinVolumeChange(): void {
    if (this.volumePanelMinVolume <= Constants.DEFAULT_VOLUME_INVALID) {
      log.showError('volumePanelMinVolume is invalid, update volumePanelMinVolume');
      return;
    }
    this.volumePanelMinVolumeLocal = this.volumePanelMinVolume;
  }

  onVolumePanelVolumeValueChange(): void {
    if (this.volumePanelVolumeValue <= Constants.DEFAULT_VOLUME_INVALID) {
      log.showError('volumePanelVolumeValue is invalid, update volumePanelVolumeValue');
      return;
    }
    this.volumePanelVolumeValueLocal = this.volumePanelVolumeValue;
    PanelViewModel.updatePhysicsValue(this.volumePanelVolumeValueLocal) // 更新UI视图
    log.showInfo(`onVolumePanelVolumeValueChange:${this.volumePanelVolumeValueLocal}; volumeUIValue: ${this.viewData.volumeUIValue}`)
  }
}