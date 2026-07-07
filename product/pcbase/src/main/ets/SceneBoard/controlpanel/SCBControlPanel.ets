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

import {
  HiSysEventUtil,
  PluginSlot,
  PluginWindowType,
  EvtBus,
  EventManager,
  WindowEvent,
  sEventManager,
  unsubscribe,
  ScreenOnOffEvent,
  viewMgrPolicy,
  ViewType,
  obtainLocalEvent,
  START_SERVICE_EXT_EVENT,
  ConfigurationEvent,
  ViewCallback,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import {
  Trace,
  CommonUtils,
  Observer,
  TraceUtil,
  LogDomain,
  LogHelper,
  DomainName,
} from '@ohos/basicutils';
import { windowMgr } from '@ohos/windowscene';
import { FASlotName, WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { AnimationConstants } from '@ohos/commonconstants/Index';
import StyleConfiguration from './common/StyleConfiguration';
import { IndexStyle } from './common/StyleConfiguration';
import StyleManager from './common/StyleManager';
import ControlCenterComponent from './control';
import { MultimodalInputManager,
  MultiKeyCode,
} from '@ohos/systemuicommon';
import { QuickToggleController } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import Constants from './common/constants';
import { LocalWindowManager } from '@ohos/systemuicommon';
import pluginComponentManager from '@ohos.pluginComponent'
import Want from '@ohos.app.ability.Want';
import screenLockMediator from '../screenlock/refactor/ScreenLockMediator';
import { DropDownPanelManager, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import {
  PrivacySensorViewModel
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/viewModel/PrivacySensorViewModel';
import { ControlCenterHideEvent } from '@ohos/systemuicommon/src/main/ets/event/ControlCenterHideEvent';
import { DarkModeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { FlashlightController } from '@ohos/flashlightcomponent/src/main/ets/com/ohos/controller/FlashlightController';
import ControlCenterComponentPcMode from './pcMode/ControlCenterComponentPcMode';
import sControlCenterController
  from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import { PcStbSecondaryPanelController } from '../../pluginPanel/controller/PcStbSecondaryPanelController';
import { HeaderButtonType } from './ControlCenterHeaderLayout';
import { AudioSoundViewModel } from '../soundpanel/viewmodel/AudioSoundViewModel';

const TAG = 'ControlPanel-Index';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 控制中心面板窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_CONTROL_CENTER;
const MAX_FONT_SCALE: number = 1.3;

interface PluginComponentTemplate {
  source: string; // 组件模板名
  ability: string; // 组件ability名
}

@Component
export struct SCBControlPanel {
  @State viewController: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.CONTROL_CENTER);
  persistentId: number = 0;
  @State style: IndexStyle | null = null;
  mClearCallbacks: Array<unsubscribe> = [];
  private screenLockObserver: Observer | null = null;
  private lastShowTime: number = 0;
  @Provide microphoneDialogIsOpen: boolean = false;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @StorageLink('needReleaseToggleIcon') needReleaseToggleIcon: boolean = false;
  @Provide castDialogIsOpen: boolean = false;
  @Provide superDeviceDialogIsOpen: boolean = false;
  private mTimeMeter: number = 0;
  private viewCallback: ViewCallback = {
    onShow: (): void => this.onViewShow(),
    onHide: (): void => this.onViewHide()
  };
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear() {
    log.showInfo(`aboutToAppear, start`);
    viewMgrPolicy.registerViewController(ViewType.CONTROL_CENTER, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.registerCallback(this.viewCallback);
    this.viewController.registerFocusCallback();
    interface rectTS {
      left: number;
      top: number;
      width: number;
      height: number;
    }
    let rect: rectTS = {
      left: 0,
      top: 0,
      width: px2vp(PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE)),
      height: LocalWindowManager.PC_CONTROL_PANEL_HEIGHT,
    };
    this.viewController.updateArea(rect);
    this.viewController.updateRect(rect);

    this.style = StyleConfiguration.getIndexStyle();
    StyleManager.setStyle();
    // 更新窗口大小
    let initRect = windowMgr.getWindowPosition(WINDOW_NAME);
    if (QuickToggleController.getInstance().getToggleData().quickToggle.length <= 5) {
      let newHeight = StyleManager.calcScaleSize(Constants.WINDOW_HEIGHT_FEW_TOGGLE) * AnimationConstants.LARGER_RATIO;
      initRect.height = newHeight;
      windowMgr.updateWindowPosition(WINDOW_NAME, initRect);
    }
    this.initWindowPolicy();
    // 窗口动画绑定onFrame
    windowMgr.startBindWinAnimOnFrame(WINDOW_NAME);
    log.showDebug(`aboutToAppear, end`);

    // Lock screen monitoring
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo('onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);

    this.eventMgr.on(ConfigurationEvent, (event: ConfigurationEvent) => {
      log.showInfo(`on config change: ${JSON.stringify(event)}`);
      this.controlCenterFontScale = Math.min(MAX_FONT_SCALE, event?.config?.fontSizeScale ?? 1);
    });
    this.eventMgr.on(DarkModeEvent, (event: DarkModeEvent) => {
      ColorModeViewModel.getInstance().onColorModeChange(event.isDarkMode ?
      ConfigurationConstant.ColorMode.COLOR_MODE_DARK : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
    });
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`);
    this.mClearCallbacks.forEach((unsubscribe) => unsubscribe());
    this.mClearCallbacks.length = 0;
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    if (this.screenLockObserver !== null) {
      screenLockMediator.deleteObserver(this.screenLockObserver);
    }
    this.viewController.unRegisterFocusCallback();
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowStartShow()) {
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(WINDOW_NAME)) {
        this.hideWindow();
      } else {
        TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
        HiSysEventUtil.reportControlCenterShow({
          POINTX: 0,
          POINTY: 0,
          RESOLUTION: `${DropDownPanelManager.getScreenInfo().width}x${DropDownPanelManager.getScreenInfo().height}`,
          TIMESTAMP: `${this.updateLastShowTime()}`,
          ORIENTATION: 0,
          LOCKSTATUS: 2,
        });
        log.showInfo('IntoCC start');
        if (ControlCenterPluginMgr.isPcMode) {
          FlashlightController.getInstance().updateUIFromCache();
        }
        QuickToggleController.getInstance().allTogglesControllerMap.forEach((viewModel) => {
          viewModel.initLottieData();
        });
        PrivacySensorViewModel.getInstance().initData();
        AudioSoundViewModel.getInstance().getOutputState(TAG);
        sEventManager.publish(obtainLocalEvent('ControlCenterState', 0));
        sEventManager.publish(obtainLocalEvent('DropdownEvent', true));
      }
    }

    if (!event.isMatchName(WINDOW_NAME)) {
      return;
    }

    if (event.isWindowEndShow()) {
      log.showInfo('IntoCC end');
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
    } else if (event.isWindowStartHide()) {
      log.showInfo('ExitCC start');
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_HIDE);
      HiSysEventUtil.reportControlCenterHide({
        KEEPTIME: new Date().getTime() - this.lastShowTime,
        TIMESTAMP: `${this.lastShowTime}`,
        ORIENTATION: 0,
        TYPE: 5,
        LOCKSTATUS: 2
      });
    } else if (event.isWindowEndHide()) {
      log.showInfo('ExitCC end');
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_HIDE);
    }
  }

  private initWindowPolicy(): void {
    log.showDebug(`init controlcenter panel window Policy`);
    // 监听窗口show/hide事件
    // win键统一到feature\multiinput\src\main\ets\default\common\viewmodel\MultiInputViewModel.ts中处理
    this.eventMgr.on(WindowEvent, (event: WindowEvent): void => {this.onWindowEvent(event)})
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {this.onScreenOnOffEvent(event)})
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
    this.mClearCallbacks.push(
      sEventManager.subscribe(START_SERVICE_EXT_EVENT, () => this.hideWindow()),
      sEventManager.subscribe('hideControlPanel', () => this.hideWindow())
    );
    pluginComponentManager.on('push', this.onPushListener);
  }

  private hideWindow(): void {
    let isShowing = windowMgr.isShowing(WINDOW_NAME);
    if (!isShowing) {
      log.showInfo(`hideWindow skiped, has hide`);
      return;
    }
    log.showDebug(`hide anim start: ${JSON.stringify(this)}`);
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      windowMgr.hideWindowImmediately(WINDOW_NAME);
    }
  }

  private updateLastShowTime(): number {
    this.lastShowTime = new Date().getTime();
    return this.lastShowTime;
  }

  private onPushListener = (source: Want, template: PluginComponentTemplate,
    data: pluginComponentManager.KVObject,
    extraData: pluginComponentManager.KVObject): void => {
    if (CommonUtils.isEmpty(source.abilityName)) {
      log.showInfo(`abilityName is null: ${source.abilityName}`);
      return;
    }
    if (source.abilityName == 'ServiceExtAbility') {
      switch (data.action) {
        case 'HIDE_PANEL':
          this.hideWindow();
          break;
        default:
          log.showInfo(`action is not permit: ${data.action}`);
          break;
      }
    }
  }

  private buildLog(): boolean {
    log.showInfo(` control panel Height: ${this.viewController.getArea().height}`);
    return true;
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  onPageShow() {
    log.showInfo(`onPageShow`);
    Trace.end(WINDOW_NAME);
  }

  private onViewShow(): void {
    log.showDebug('onViewShow');
    sControlCenterController.setControlCenterVisible(true);
    sToggleSubWindowController.setShowingSlot('');
    this.needReleaseToggleIcon = false;
    this.mTimeMeter = setTimeout(() => {
      const res: boolean = focusControl.requestFocus(Constants.CONTROL_PANEL_ID_PRIVACY_SENSOR);
      if (!res) {
        log.showError('requestFocus failed');
        focusControl.requestFocus(Constants.CONTROL_PANEL_ID_SETTINGS);
      }
    }, 50);
  }

  private onViewHide(): void {
    log.showDebug('onViewHide');
    sControlCenterController.setControlCenterVisible(false);
    // 当不显示编辑按钮，isPcEditMode不存在，因此不需要过滤
    if (!AppStorage.get<boolean>('isPcEditMode')) {
      this.needReleaseToggleIcon = true;
    }
    EvtBus.post(ControlCenterHideEvent, {isShowOfWindow: false});
    if (this.mTimeMeter) {
      clearTimeout(this.mTimeMeter);
    }
  }

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
      if (this.buildLog()) {
      }
      if (ControlCenterPluginMgr.isPcMode) {
        ControlCenterComponentPcMode({ buttonType: HeaderButtonType.EDIT_MODE })
      } else {
        ControlCenterComponent({ buttonType: HeaderButtonType.EDIT_MODE })
      }
    }
    .borderRadius(this.style!.borderRadius)
    .defaultFocus(true)
    .onKeyEvent((keyEvent: KeyEvent) => {
      if ((keyEvent.keyCode === MultiKeyCode.ESC || keyEvent.keyCode === MultiKeyCode.BACK) &&
        keyEvent.type === KeyType.Up) {
        this.hideWindow();
      }
    })
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
    .width(Constants.WINDOW_WIDTH)
    .height(this.viewController.getArea().height)
  }
}
