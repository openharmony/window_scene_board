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
import { effectKit } from '@kit.ArkGraphics2D';
import parameter from '@ohos.systemparameter';
import { ControlCenterState } from '@ohos/controlcentercommon/src/main/ets/common/ControlCenterConstants';
import { FASlotName } from '@ohos/commonconstants';
import {
  AppStorageUtil,
  CheckEmptyUtils,
  DomainName,
  DataProperty,
  LogDomain,
  LogHelper,
  SingletonHelper,
  TraceUtil,
  Trace
} from '@ohos/basicutils';
import {
  ConfigurationEvent,
  DeviceHelper,
  EvtBus,
  EventManager,
  GlobalContext,
  MediaControlEvent,
  WallpaperChangeEvent,
  obtainLocalEvent,
  sEventManager
} from '@ohos/frameworkwrapper'
import lazy { ScenePanelState } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { VolumePanelVisibilityEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { ThemeChangeEvent, ToggleStyle, ControlCenterBackgroundDegreeEvent } from '@ohos/systemuicommon';
import { ControlBrightnessManager } from '@ohos/brightnesscomponent/src/main/ets/default/ControlBrightnessManager';
import { FlashlightController } from '@ohos/flashlightcomponent/src/main/ets/com/ohos/controller/FlashlightController';
import {
  BrightnessOptionUtils,
  ColorModeViewModel,
  ColorModeViewData,
  DropDownPanelManager,
  LightHelper
} from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { VolumeController } from '@ohos/soundcomponent/src/main/ets/controller/VolumnController';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityUtil';
import { CardMediaController } from '@ohos/mediacontrolcomponent/src/main/ets/default/Controller/CardMediaController';
import lazy { WallpaperColorManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/WallpaperColorManagerAdapter';
import { SOLID_COLOR_USE_FIXED_COLOR } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { QuickToggleController } from './QuickToggleController';
import { ScreenToggleController } from './ScreenToggleController';
import { ControlCenterHomeViewData } from '../vm/ControlCenterHomeViewData';
import lazy StyleConfiguration, { ControlCenterComponentStyle } from '../common/StyleConfiguration';
import {
  ControlCenterData,
  ContentItemOption,
  ControlCenterItem,
  ThemeColor
} from '../common/Constants';
import sBrightnessController from '../viewModel/BrightnessController';

const TAG: string = 'Ctrl.ControlCenterController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const DISABLE_INTERVAL: number = 500;

export class ControlCenterController {
  /**
   * 控制中心当前状态
   */
  private controlCenterData: ControlCenterData = new ControlCenterData(ControlCenterState.MAIN_LAYOUT);
  private isEnableBackPress: boolean = true;
  private timeFlag: number = 0;

  /**
   * 控制中心内容集合
   */
  private contentDataList: Map<number, ContentItemOption> = new Map();

  // 当前控制中心是否可见
  private isVisible: boolean = false;

  // 默认值5-普通花壁纸
  private wallerPaperType: number = 5;

  private lastBackgroundType: number = 5;

  private homeViewData?: ControlCenterHomeViewData;

  private delayReleaseIot: boolean = false;
  private showToastMethod?: (msg: ResourceStr) => void;

  // 控制中心背景类型
  public backgroundType: SharedArrayBuffer = new SharedArrayBuffer(4);
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private wallpaperAvgColor: string | undefined = undefined;

  /**
   * 多事件管理器
   */
  private themeEventMgr: EventManager = EvtBus.createEventManager();

  private hasRegisterKeyInputEvent: boolean = false;

  /**
   * 构造方法
   */
  constructor() {
    AppStorageUtil.setOrCreate('ControlCenterState', this.controlCenterData, new DataProperty(true, false));
    this.controlCenterData = AppStorage.get<ControlCenterData>('ControlCenterState') as ControlCenterData;
    // 通过prop项'controlCenter.isNewStyle'切换控制中心新旧样式
    // 通过prop项'sceneboard.isNewStyle'切换整机新旧样式
    AppStorageUtil.setOrCreate('isNewStyle', this.isNewStyleOpen() && this.isSceneBoardNewStyleOpen(), new DataProperty(true, false));
    AppStorageUtil.setOrCreate('isSceneBoardNewStyle', this.isSceneBoardNewStyleOpen(), new DataProperty(true, false));

    // 播控监听
    EvtBus.on(MediaControlEvent, this.onMediaControlCallback);
    // degree修改监听
    EvtBus.on(ControlCenterBackgroundDegreeEvent, this.onDegreeChange);
    if (this.colorModeViewData.isUseSolidColor()) {
      EvtBus.on(WallpaperChangeEvent, this.handleWallpaperChangeEvent);
      WallpaperColorManagerAdapter.loadWallpaper().then(() => {
        this.setPickColor(this.colorModeViewData.convertResourceColorToEffectColor(this.wallpaperAvgColor));
      }).catch((err: Error) => {
        log.showError(`loadWallpaper failed, err: ${err}`);
      });
    }
    this.loadContent();
  }

  /**
   * 接收Degree变更事件
   */
  public onDegreeChange = (event: ControlCenterBackgroundDegreeEvent) => {
    if (CheckEmptyUtils.isEmpty(event)) {
      return;
    }
    if (event.controlCenterDegree !== this.lastBackgroundType && event.controlCenterDegree > 0) {
      this.lastBackgroundType = event.controlCenterDegree;
      log.showInfo('onDegreeChange wallerPaperType:' + this.lastBackgroundType);
    }
  }

  /**
   * 加载控制中心内容数据
   */
  loadContent() {
    this.contentDataList.set(ControlCenterItem.ITEM_MEDIA, ContentItemOption.create(0));
    this.contentDataList.set(ControlCenterItem.ITEM_TOGGLE, ContentItemOption.create(0));
    this.contentDataList.set(ControlCenterItem.ITEM_IOT, ContentItemOption.create(0));
  }

  /**
   * 获取控制中心内容数据
   */
  getContent(): Map<number, ContentItemOption> {
    return this.contentDataList;
  }

  public setWallerPaperType(type: number) {
    this.wallerPaperType = type;
  }

  public getWallerPaperType(): number {
    return this.wallerPaperType;
  }

  public setLastBackgroundType(type: number) {
    this.lastBackgroundType = type;
  }

  public getLastBackgroundType(): number {
    return this.lastBackgroundType;
  }

  public updateLabelColor(): void {
    let style: ControlCenterComponentStyle = StyleConfiguration.getControlCenterComponentStyle();
    if (this.wallerPaperType !== this.lastBackgroundType) {
      this.lastBackgroundType = this.wallerPaperType;
      log.showInfo('start update label color type:' + this.lastBackgroundType);
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_CHANGE_LABEL_COLOR);
      if (this.wallerPaperType === 1 || this.wallerPaperType === 2) {
        ToggleStyle.getToggleLabelStyle().setLabelColor(style.labelColorType1);
        ToggleStyle.getToggleLabelStyle().setLabelStyle(BrightnessOptionUtils.getInstance().foregroundSecondaryOption);
      } else if (this.wallerPaperType === 4) {
        ToggleStyle.getToggleLabelStyle().setLabelColor(style.labelColorType2);
        ToggleStyle.getToggleLabelStyle().setLabelStyle(BrightnessOptionUtils.getInstance()
          .foregroundSecondaryDarkOption);
      } else {
        ToggleStyle.getToggleLabelStyle().setLabelColor(style.labelColorType3);
        ToggleStyle.getToggleLabelStyle().setLabelStyle(BrightnessOptionUtils.getInstance()
          .foregroundSecondaryDarkOption);
      }
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_CHANGE_LABEL_COLOR);
    }
  }

  private handleWallpaperChangeEvent = (event: WallpaperChangeEvent): void => {
    this.wallpaperAvgColor = event.avgColor;
    log.showInfo(`new wallpaperAvgColor: ${this.wallpaperAvgColor}`);
    if (SOLID_COLOR_USE_FIXED_COLOR) {
      this.setPickColor(this.colorModeViewData.convertResourceColorToEffectColor(this.wallpaperAvgColor));
    }
  }

  /**
   * 保存控制中心纯色模式取色结果
   *
   * @param pickColor
   */
  public setPickColor(pickColor: effectKit.Color): void {
    if (!this.colorModeViewData.isUseSolidColor()) {
      return;
    }
    let scenePanelState: ScenePanelState = AppStorage.get<ScenePanelState>('scenePanelState') ?? ScenePanelState.RECENT;
    if ((SOLID_COLOR_USE_FIXED_COLOR || scenePanelState === ScenePanelState.HOME)) {
      let newColor: effectKit.Color = this.colorModeViewData.convertResourceColorToEffectColor(this.wallpaperAvgColor);
      if (!this.isSameColor(this.colorModeViewData.pickColor, newColor)) {
        this.colorModeViewData.pickColor = newColor;
      }
      return;
    }
    if (!this.isSimilarColor(pickColor, this.colorModeViewData.pickColor)) {
      this.colorModeViewData.pickColor = pickColor;
    }
  }

  private isSimilarColor(color1: effectKit.Color, color2: effectKit.Color): boolean {
    const similarRange: number = 32;
    return Math.abs(color1.red - color2.red) < similarRange &&
      Math.abs(color1.green - color2.green) < similarRange &&
      Math.abs(color1.blue - color2.blue) < similarRange;
  }

  private isSameColor(color1: effectKit.Color, color2: effectKit.Color): boolean {
    return color1.red === color2.red && color1.green === color2.green && color1.blue === color2.blue;
  }

  /**
   * 是否为PC
   */
  isPc(): boolean {
    return DeviceHelper.isPC();
  }

  isNewStyleOpen(): boolean {
    return parameter.getSync('controlCenter.isNewStyle', 'true') == 'true';
  }

  isSceneBoardNewStyleOpen(): boolean {
    return parameter.getSync('sceneboard.isNewStyle', 'true') == 'true';
  }

  /**
   * 注册事件监听
   */
  registerListener() {
    this.subscribeThemeChange();
  }

  private subscribeThemeChange(): void {
    try {
      this.themeEventMgr.on(ConfigurationEvent, (event: ConfigurationEvent) => {
        setTimeout(() => {
          log.showInfo('ThemeActivationEvent change')
          let themeChangeEvent: ThemeChangeEvent = ThemeChangeEvent.create();
          EvtBus.post(ThemeChangeEvent, themeChangeEvent);
          LightHelper.getInstance().onThemeChange();
          this.setDefaultBrightening();
        }, 100);
      });
    } catch (e) {
      log.showError(`Create subscriber error: ${e?.message}`);
    }
  }

  setDefaultBrightening() {
    if (this.isPc()) {
      log.showInfo(`setDefaultBrightening, is pc, the brightness status not to set`);
      return;
    }
    try {
      let isSysColor: boolean = ThemeColor.isDefaultColor();
      log.showInfo(`theme event activation ${isSysColor}`);
      AppStorageUtil.setOrCreate('isSysColor', isSysColor);
      this.colorModeViewData.setBrightnessStatus(isSysColor);
    } catch (err) {
      log.error(`setDefaultBrightening failed: ${err.message}`);
    }
  }

  /**
   * 反注册事件监听
   */
  unregisterListener() {
    this.themeEventMgr.offAll();
  }

  /**
   * 播控广播回调
   *
   * @param event 广播数据
   */
  public onMediaControlCallback = (event: MediaControlEvent) => {
    log.showInfo(`onMediaControlCallback begin: ${event.data}`);
    if (event.data == MediaControlEvent.MEDIA_CONTROL_JUMP) {
      GlobalContext.getInstance().setObject('isMediaCenterShow', false);
      DropDownPanelManager.postRequestHideWindow(true);
      setTimeout(() => {
        sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
      }, 115);
      if (systemUIWorkerManager.isEnabled()) {
        messageChannel.sendMessage('quitSubWindow', { hideWindow: true });
      }
    } else if (event.data == MediaControlEvent.MEDIA_CONTROL_QUIT) {
      GlobalContext.getInstance().setObject('isMediaCenterShow', false);
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
      if (systemUIWorkerManager.isEnabled()) {
        messageChannel.sendMessage('quitSubWindow', { hideWindow: false });
      }
      this.recoverBackPress();
      const isSwitch = CardMediaController.showingWant?.parameters?.message === 'switch';
      if (isSwitch) {
        AccessibilityUtil.requestFocusAccessibility('MediaCardComponent_debug_Audio_button');
      } else {
        AccessibilityUtil.requestFocusAccessibility('control_center_media_card_title');
      }
    }
  }

  private recoverBackPress(): void {
    if (this.timeFlag !== 0) {
      clearTimeout(this.timeFlag);
    }
    this.isEnableBackPress = false;
    this.timeFlag = setTimeout(() => {
      if (!this.isEnableBackPress) {
        this.isEnableBackPress = true;
      }
    }, DISABLE_INTERVAL);
  }

  /**
   * 是否禁用返回
   *
   * @return true 允许 false 不允许
   */
  getBackPressEnable(): boolean {
    return this.isEnableBackPress;
  }

  /**
   * 设置禁用状态
   *
   * @param
   */
  setBackPressEnable(isEnable: boolean): void {
    this.isEnableBackPress = isEnable;
  }

  /**
   * 获取控制中心当前状态
   */
  getData(): ControlCenterData {
    return this.controlCenterData;
  }

  /**
   * 控制中心是否可见
   *
   * @returns 控制中心是否可见
   */
  isControlCenterVisible(): boolean {
    return this.isVisible;
  }

  /**
   * 设置控制中心是否可见
   *
   * @returns void
   */
  setControlCenterVisible(visible: boolean): void {
    this.isVisible = visible;
    ControlBrightnessManager.getInstance().setControlCenterVisible(visible);
    FlashlightController.getInstance().setControlCenterVisible(visible);
  }

  // 在音量二级页或者控制中心主页时，侧边音量面板不显示
  public shieldVolumePanelCheck(state?: ControlCenterState): void {
    if (state === undefined) {
      state = this.controlCenterData.state;
    }
    if (this.isVisible && (state === ControlCenterState.SOUND_SUB_PAGE || state === ControlCenterState.MAIN_LAYOUT)) {
      // 如果已经注册就不在重复注册
      if (!this.hasRegisterKeyInputEvent) {
        VolumeController.getInstance().registerKeyInputEvent(VolumeController.getInstance().volumeUpKeyCallback,
          VolumeController.getInstance().volumeDownKeyCallback);
        log.showInfo(`registerKeyInputEvent`);
        this.hasRegisterKeyInputEvent = true;
        this.postVolumePanelVisibilityEvent(false);
      }
    } else if (this.hasRegisterKeyInputEvent) {
      VolumeController.getInstance().unregisterKeyInputEvent(VolumeController.getInstance().volumeUpKeyCallback,
        VolumeController.getInstance().volumeDownKeyCallback);
      log.showInfo(`unregisterKeyInputEvent`);
      this.hasRegisterKeyInputEvent = false;
      this.postVolumePanelVisibilityEvent(true);
    }
  }

  /**
   * 发送侧边音量面板可见性事件
   * @param panelNeedShow 侧边音量条是否展示
   */
  private postVolumePanelVisibilityEvent(panelNeedShow: boolean): void {
    EvtBus.post(VolumePanelVisibilityEvent, VolumePanelVisibilityEvent.create(panelNeedShow));
    log.showInfo(`postVolumePanelVisibilityEvent panelNeedShow: ${panelNeedShow}`);
  }

  /**
   * 设置控制中心状态
   *
   * @param state 控制中心状态
   */
  setControlCenterState(state: ControlCenterState): void {
    // 二级页状态兜底（从IOT/编辑页切换到二级页，导致状态异常）
    if (this.controlCenterData.state !== ControlCenterState.MAIN_LAYOUT && state === ControlCenterState.SUB_PANEL) {
      log.showInfo(`setControlCenterState, state = SUB_PANEL, oldstate != MAIN_LAYOUT, return`);
      sToggleSubWindowController.setShowingSlot('');
      return;
    }
    // 二级页状态兜底（从二级页切换到IOT/编辑页，导致二级页状态异常）
    if (this.controlCenterData.state === ControlCenterState.SUB_PANEL && state !== ControlCenterState.SUB_PANEL) {
      log.showInfo(`setControlCenterState, reset showingSlot`);
      sToggleSubWindowController.setShowingSlot('');
    }
    this.controlCenterData.state = state;
    AppStorage.setOrCreate('ControlCenterState', state);
  }

  /**
   * 设置homeViewData
   * @param viewData
   */
  setHomeViewData(viewData?: ControlCenterHomeViewData): void {
    this.homeViewData = viewData;
  }

  /**
   * 获取homeviewdata
   * @returns
   */
  getHomeViewData(): ControlCenterHomeViewData | undefined {
    return this.homeViewData;
  }

  /**
   * 设置是否延迟销毁iot
   * @param delayReleaseIot
   */
  setDelayReleaseIot(delayReleaseIot: boolean): void {
    this.delayReleaseIot = delayReleaseIot;
  }

  /**
   * 是否延迟销毁iot
   * @returns 是否延迟销毁iot
   */
  isDelayReleaseIot(): boolean {
    return this.delayReleaseIot;
  }

  showToast(msg: ResourceStr): void {
    this.showToastMethod?.(msg);
  }

  setShowToastMethod(showToastMethod?: (msg: ResourceStr) => void): void {
    this.showToastMethod = showToastMethod;
  }

  updateUIFromCache() {
    ControlBrightnessManager.getInstance().setBrightnessUiValue();
    FlashlightController.getInstance().updateUIFromCache();
    VolumeController.getInstance().updateVolumeUI();
    (QuickToggleController.getInstance().allTogglesControllerMap.get(FASlotName.SCREEN_RECORDER) as
    ScreenToggleController)?.registerMonitor();
  }

  /**
   * 刷新当前亮度值
   */
  public updateBrightnessUiValue(): void {
    ControlBrightnessManager.getInstance().executeTaskDelay();
    sBrightnessController.updateAutoBrightnessState();
  }
}

let sControlCenterController: ControlCenterController =
  SingletonHelper.getInstance(ControlCenterController, TAG);

export default sControlCenterController as ControlCenterController;
