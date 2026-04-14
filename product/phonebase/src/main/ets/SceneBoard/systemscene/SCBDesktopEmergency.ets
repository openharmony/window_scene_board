/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager, } from '@ohos/windowscene';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  ScreenState,
  ScreenStateModel,
  ScreenStateMonitor,
  ViewArea,
  ViewCallback,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper'
import { BaseViewController } from '@ohos/frameworkcommon';
import { CommonStyle, EmergencyStyle, EmergencyView, EmergencyViewModel,
  FoldExpandStyleConfig, ThermalSafeView, ThermalSafeViewModel } from '@ohos/emergencymode';
import { CommonConstants, DesktopModeEnum, DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { StyleConfigFactory } from '../emergency/StyleConfigFactory';
import { systemParameter } from '@kit.BasicServicesKit';

const TAG = 'SCBDesktopEmergency';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Layer-0 interface of Emergency Mode/Thermal Safety Mode.
 * Load the emergency mode main interface component or thermal safety mode component according to different modes.
 - Implement the corresponding ViewController to manage the show/hide of the new interface.
 - Does not respond to BACK, multi-window, slide up, slide left to negative screen, slide down to search gestures.
 - The new layer 0 page is not created by default, it is displayed in exclusive mode with the existing SCBDesktop.
 */
@Component
export struct SCBDesktopEmergency {
  persistentId: number = 0;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @Link screenProp: SCBScreenProperty
  private viewController: BaseViewController = new BaseViewController(ViewType.DESKTOP_EMERGENCY);
  // 屏幕状态， F代表1屏展开状态， M代表2屏展开状态， G代表3屏展开状态 （这里的F是默认值，初始化会覆盖）
  @State mScreenState: ScreenState = ScreenState.F;
  @State desktopMode: DesktopModeEnum = DesktopModeManager.getInstance().getDesktopMode();
  @State emergencyStyle: EmergencyStyle = StyleConfigFactory.createEmergencyStyle();
  @State thermalStyle: CommonStyle = StyleConfigFactory.createThermalStyle();
  private desktopFocusCallback: ViewCallback = {
    onGainFocus: (): void => {
      log.showInfo('DesktopEmergency focus');
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_FOCUS_CHANGE, true);
    },
    onLoseFocus: (): void => {
      log.showInfo('DesktopEmergency lose focus');
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_FOCUS_CHANGE, false);
    }
  };

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.voteBootEvent();
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProp.screenId);
    screenSession?.setEnableRotate(false, 'emergency');
    viewMgrPolicy.registerViewController(ViewType.DESKTOP_EMERGENCY, this.viewController);
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP_EMERGENCY, this.desktopFocusCallback);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    // 初始化screenState， 给mScreenState赋上正确的值
    this.initScreenState();
    this.initAreaAndRect();
    this.initStyleConfig();
    DesktopModeManager.getInstance().registerModeChangeCallback(TAG, this.desktopModeChangeFunc);
    this.registerScreenStateMonitor();
  }

  private voteBootEvent(): void {
    log.showInfo('voteBootEvent for emergency begin');
    try {
      systemParameter.setSync('bootevent.launcher.ready', 'true');
    } catch (err) {
      log.showInfo('set voteBootEvent error');
    }
    log.showInfo('voteBootEvent for emergency end');
  }

  /**
   * 初始化ScreenState,1.超大屏，按照断点取值设置。 2.其他设备，按照展开折叠设置
   */
  private initScreenState(): void {
    // 超大屏,按照断点取值设置
    if (DeviceHelper.isUltraScreenProduct()) {
      this.mScreenState = ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState;
      return;
    }
    // 其他设备，按照折叠展开赋值
    if (DeviceHelper.isFoldExpanded()) {
      this.mScreenState = ScreenState.M;
    } else {
      this.mScreenState = ScreenState.F;
    }
  }


  private desktopModeChangeFunc = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
    log.showInfo(`Notify preDesktopMode: ${preDesktopMode}, targetDesktopMode: ${targetDesktopMode}`);
    if (this.desktopMode === targetDesktopMode) {
      log.showInfo('no need init style again');
      return;
    }
    this.desktopMode = targetDesktopMode;
    this.initStyleConfig();
  }

  private registerScreenStateMonitor(): void {
    if (DeviceHelper.isUltraScreenProduct()) {
      ScreenStateMonitor.getInstance().registerScreenStateChangeListener(TAG, (old: ScreenStateModel,
        newData: ScreenStateModel) => {
        log.showInfo(`recevie screenState, old: ${old.screenState}, orientation: ${old.orientation}, w: ${
        old.width}, h: ${old.height}; new: ${newData.screenState}, orientation: ${newData.orientation}, w: ${
        newData.width}, h: ${newData.height}`);
        this.foldOrExpandScreen(old, newData);
      });
    }
  }

  private unRegisterScreenStateMonitor(): void {
    if (DeviceHelper.isUltraScreenProduct()) {
      ScreenStateMonitor.getInstance().unRegisterScreeStateChangeListener(TAG);
    }
  }

  /**
   * 超大屏折叠展开屏幕
   * @param oldState
   * @param newState
   */
  public foldOrExpandScreen(oldState: ScreenStateModel, newState: ScreenStateModel): void {
    this.mScreenState = newState.screenState;
    log.showInfo(`foldOrExpandScreen: state: ${newState.screenState}, width: ${newState.width} , height: ${newState.height}`);
    this.updateRect(newState.width, newState.height);
    this.initStyleConfig();
  }

  private updateRect(width: number, height: number): void {
    let newRect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(width),
      height: px2vp(height)
    };
    this.viewController.updateRect(newRect);
  }

  private initStyleConfig(): void {
    if (this.desktopMode === DesktopModeEnum.THERMAL_SAFE_MODE) {
      let thermalSafeViewModel: ThermalSafeViewModel = ThermalSafeViewModel.getInstance();
      thermalSafeViewModel.setThermalSafeStyle(this.thermalStyle);
      if (DeviceHelper.isUltraScreenProduct()) {
        log.showInfo('init thermal map');
        FoldExpandStyleConfig.initThermalMap();
      }
      if (DeviceHelper.isFold()) {
        let tmpScreenState = this.getScreenState();
        log.showInfo(`current state is ${tmpScreenState}`);
        thermalSafeViewModel.updateFoldLayoutConfig(tmpScreenState);
      }
    } else {
      let emergencyViewModel: EmergencyViewModel = EmergencyViewModel.getInstance();
      emergencyViewModel.setEmergencyStyle(this.emergencyStyle);
      if (DeviceHelper.isUltraScreenProduct()) {
        log.showInfo('init emergency map');
        FoldExpandStyleConfig.initEmergencyMap();
      }
      if (DeviceHelper.isFold()) {
        let tmpScreenState = this.getScreenState();
        log.showInfo(`current state is ${tmpScreenState}`);
        emergencyViewModel.updateFoldLayoutConfig(tmpScreenState);
      }
    }
  }

  // 获取当前屏幕展开状态：普通折叠屏按照当前折叠展开判定,新形态小折叠始终走F态（折叠态）布局
  private getScreenState(): ScreenState {
    return this.mScreenState;
  }

  private initAreaAndRect(): void {
    let screenWidth: number = px2vp(this.screenProp.width);
    let screenHeight: number = px2vp(this.screenProp.height);
    log.showInfo(`screen width: ${screenWidth}, screen height: ${screenHeight}`);
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: screenWidth,
      height: screenHeight
    }
    this.viewController.updateArea(rect);
    this.viewController.updateRect(rect);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, this.persistentId);
  }

  private screenPropertyChangeCallbackFunc = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`change width: ${px2vp(screenProperty.width)},height: ${px2vp(screenProperty.height)},reason: ${reason}`);
    this.processFoldOrExpand(screenProperty, reason);
  };

  private processFoldOrExpand(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    // 超大屏走断点监听
    if (DeviceHelper.isUltraScreenProduct()) {
      return;
    }
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      this.mScreenState = ScreenState.M;
    } else if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.mScreenState = ScreenState.F;
    }
    this.updateRect(screenProperty.width, screenProperty.height);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    viewMgrPolicy.unregisterViewController(ViewType.DESKTOP_EMERGENCY);
    viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP_EMERGENCY, this.desktopFocusCallback);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, true, this.persistentId);
    DesktopModeManager.getInstance().unRegisterModeChangeCallback(TAG);

    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProp.screenId);
    screenSession?.setEnableRotate(true, 'emergency');
    this.unRegisterScreenStateMonitor();
    if (DeviceHelper.isUltraScreenProduct()) {
      FoldExpandStyleConfig.clearMap();
    }
  }

  build() {
    if (this.desktopMode === DesktopModeEnum.EMERGENCY_MODE) {
      EmergencyView({
        emergencyStyle: this.emergencyStyle,
        mScreenState: this.mScreenState
      })
    } else if (this.desktopMode === DesktopModeEnum.THERMAL_SAFE_MODE) {
      ThermalSafeView({
        thermalStyle: this.thermalStyle,
        mScreenState: this.mScreenState
      })
    }
  }
}